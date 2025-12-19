## Final Project Design Document

Zimeng Li (zl6655)

 

## 1. Overview

The goal of this project is to design and implement a user-level threading library for xv6, enabling multiple threads of execution within a single process. This library provides fundamental thread management functionality, including thread creation, scheduling, and context switching, as well as a complete set of synchronization primitives such as mutexes, semaphores, condition variables, and channels.

Beyond implementing the core primitives, this project also demonstrates how they can be composed to solve real-world concurrency problems, including the shared counter problem, producer–consumer synchronization, reader–writer locks with writer priority, and thread-safe file-based communication. 

#### 1.1 Code Environment

- Open in Codespace 
- Install packages:

  - `sudo apt update`

  - `sudo apt install -y qemu-system-x86 qemu-utils build-essential gdb gcc-multilib`
- Run:

  - (`make clean`)
  - `make qemu-nox`

#### 1.2 Architecture Diagram

The user-level threading system is implemented entirely in user space and sits on top of the xv6 process abstraction. Each xv6 process contains a lightweight threading runtime that manages multiple user threads, their execution contexts, and synchronization primitives without kernel support.

**Overall Architecture:**

```
+------------------------------------------------------+
|                    xv6 Kernel                        |
|                                                      |
|  - Process abstraction                               |
|  - System calls (read, write, fork, exit, etc.)      |
+------------------------▲-----------------------------+
                         |
                         | system calls
                         |
+------------------------|-----------------------------+
|              User Process (Single xv6 Process)       |
|                                                      |
|  +-----------------------------------------------+   |
|  |        User-Level Threading Library            |   |
|  |                                               |   |
|  |  Thread Management                             |   |
|  |  - thread_init                                |   |
|  |  - thread_create                              |   |
|  |  - thread_exit                                |   |
|  |  - thread_join                                |   |
|  |                                               |   |
|  |  Scheduler & Context Switching                 |   |
|  |  - round-robin scheduler                      |   |
|  |  - thread_switch (assembly)                   |   |
|  |                                               |   |
|  |  Synchronization Primitives                    |   |
|  |  - mutex                                      |   |
|  |  - semaphore                                  |   |
|  |  - condition variable                         |   |
|  |  - channel                                    |   |
|  |                                               |   |
|  |  Wait Queues & Thread States                   |   |
|  |  - RUNNABLE / RUNNING / SLEEPING / ZOMBIE      |   |
|  +-----------------------------------------------+   |
|                                                      |
|  +-----------------------------------------------+   |
|  |              User Threads                      |   |
|  |                                               |   |
|  |  Thread 0 (main thread)                        |   |
|  |  Thread 1                                     |   |
|  |  Thread 2                                     |   |
|  |  ...                                          |   |
|  +-----------------------------------------------+   |
|                                                      |
+------------------------------------------------------+

```

- **Single xv6 Process Model**
   All threads run within a single xv6 process. The kernel is unaware of threads and only schedules the process as a whole.
- **User-Level Threading Library**
   The threading library manages:
  - Thread creation and termination
  - Thread scheduling and context switching
  - Synchronization and blocking semantics
- **Context Switching in User Space**
   Thread context switches are performed using a dedicated assembly routine (`thread_switch`) that saves and restores stack pointers between threads.
- **Cooperative Scheduling**
   Threads explicitly yield execution via `thread_yield()` or by blocking on synchronization primitives. There is no preemption.
- **Synchronization Layer**
   Higher-level primitives (mutexes, semaphores, condition variables, channels) are built on top of thread states and wait queues, enabling safe coordination between threads.

#### 1.3 Thread Structure Layout

Each user-level thread is represented by a fixed-size `thread` structure stored in a global thread table. This structure encapsulates all metadata required to manage execution, scheduling, synchronization, and thread lifecycle.

```
struct thread {
    int tid;
    enum thread_state state;
    void *stack;
    void *sp;
    void *(*start_routine)(void *);
    void *arg;
    void *retval;
    int waiting_tid;
};
```

* **tid**
  A unique thread identifier assigned at creation time.
  `tid = 0` is reserved for the main thread of the process.

* **state**
  The current execution state of the thread.
  Possible values include `T_UNUSED`, `T_RUNNABLE`, `T_RUNNING`, `T_SLEEPING`, and `T_ZOMBIE`.
  This field is central to scheduling and synchronization decisions.

* **stack**
  Pointer to the base of the thread’s allocated stack in user space.
  Each thread has a private stack of fixed size (`STACK_SIZE`), allocated using `malloc`.

* **sp (stack pointer)**
  The saved stack pointer of the thread.
  During a context switch, the scheduler saves the current thread’s stack pointer here and restores another thread’s `sp` to resume execution.

* **start_routine**
  Function pointer representing the entry point of the thread.
  This function is invoked through a trampoline function when the thread is first scheduled.

* **arg**
  Argument passed to `start_routine`.
  This allows threads to receive thread-specific input data at creation time.

* **retval**
  Stores the return value of `start_routine`.
  This value is later retrieved by another thread via `thread_join`.

* **waiting_tid**
  Records the thread ID of a thread that is waiting to join this thread.
  When the thread exits, the waiting thread (if any) is transitioned back to the runnable state.

#### 1.4 Thread States and Transitions

The user-level threading library models each thread using a small set of explicit states. These states describe the lifecycle of a thread from creation to termination and are used by the scheduler and synchronization primitives to make correct execution decisions.

##### 1.4.1 Thread states:

* **T_UNUSED**
  The thread slot is free and not associated with any active thread.
  This is the initial state for all entries in the global thread table.

* **T_RUNNABLE**
  The thread is ready to execute and may be selected by the scheduler.
  A runnable thread has a valid stack and saved context but is not currently executing.

* **T_RUNNING**
  The thread is currently executing on the CPU.
  At any moment, exactly one thread can be in this state.

* **T_SLEEPING**
  The thread is blocked, waiting for some event to occur.
  This state is used by synchronization primitives such as mutexes, semaphores, and condition variables.

* **T_ZOMBIE**
  The thread has finished execution but has not yet been joined.
  Its return value is preserved until another thread calls `thread_join`.

##### 1.4.2 State Transitions：

```
T_UNUSED
    |
    | thread_create
    v
T_RUNNABLE <-------------------------+
    |                                 |
    | scheduled                        | thread_yield
    v                                 |
T_RUNNING                             |
    |                                 |
    | block (mutex, sem, cond)         |
    v                                 |
T_SLEEPING                            |
    |                                 |
    | wakeup (signal, unlock, post)   |
    +---------------------------------+
    |
    | thread_exit
    v
T_ZOMBIE
    |
    | thread_join
    v
T_UNUSED
```

* **Creation (`T_UNUSED → T_RUNNABLE`)**
  When `thread_create` is called, an unused thread slot is initialized, a stack is allocated, and the thread becomes runnable.

* **Scheduling (`T_RUNNABLE → T_RUNNING`)**
  The scheduler selects a runnable thread and performs a context switch, transitioning it into the running state.

* **Yielding (`T_RUNNING → T_RUNNABLE`)**
  When a thread voluntarily yields via `thread_yield`, it relinquishes the CPU and becomes runnable again.

* **Blocking (`T_RUNNING → T_SLEEPING`)**
  A running thread enters the sleeping state when it cannot proceed, such as when:

  * attempting to acquire a locked mutex,
  * waiting on a semaphore,
  * waiting on a condition variable,
  * waiting for another thread via `thread_join`.

* **Waking Up (`T_SLEEPING → T_RUNNABLE`)**
  Another thread signals the event the sleeping thread was waiting for, transitioning it back to the runnable state.

* **Termination (`T_RUNNING → T_ZOMBIE`)**
  When a thread finishes execution and calls `thread_exit`, it becomes a zombie thread.
  Its stack and resources are preserved until joined.

* **Reclamation (`T_ZOMBIE → T_UNUSED`)**
  After `thread_join` retrieves the thread’s return value, the thread slot is cleaned up and marked unused.

## 2. Implementation Details



### Part 1



#### 2.1 Context Switching Mechanism

The threading library performs user-level context switching by explicitly saving and restoring CPU register state between threads. This mechanism is implemented using a small assembly routine and coordinated by the scheduler in C.

Context switching occurs cooperatively: a running thread explicitly yields, blocks, or exits, at which point control is transferred to another runnable thread.

##### 2.1.1 Context Switch Interface:

The context switch is performed by the function:

```c
void thread_switch(struct thread *old, struct thread *new);
```

* `old`: currently running thread
* `new`: next thread selected by the scheduler

This function is implemented in assembly (`uthreads_swtch.S`) and is responsible for:

* Saving the execution context of `old`
* Restoring the execution context of `new`
* Transferring control to the new thread

##### 2.1.2 Saved and Restored State:

The context switch preserves only callee-saved registers, consistent with the x86 calling convention:

* `%esp` (stack pointer)
* `%ebp`
* `%ebx`
* `%esi`
* `%edi`

Caller-saved registers (`%eax`, `%ecx`, `%edx`) are not preserved, as threads only switch at well-defined yield/block points.

Each thread stores its saved stack pointer in:

```c
struct thread {
    ...
    void *sp;
    ...
};
```

##### 2.1.3 Assembly Implementation:

Core logic of `thread_switch`:

```asm
thread_switch:
    movl 4(%esp), %eax    # eax = old
    movl 8(%esp), %edx    # edx = new

    pushl %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    movl %esp, (%eax)    # old->sp = esp
    movl (%edx), %esp    # esp = new->sp

    popl %edi
    popl %esi
    popl %ebx
    popl %ebp

    ret
```

Execution steps:

1. Save callee-saved registers of the current thread onto its stack
2. Store the current `%esp` into `old->sp`
3. Load `%esp` from `new->sp`
4. Restore callee-saved registers from the new thread’s stack
5. `ret` transfers execution into the new thread

##### 2.1.4 Control Flow After Switch:

* For a previously running thread, execution resumes exactly after the `thread_switch` call.
* For a newly created thread, execution begins at `thread_trampoline`, because its stack was pre-initialized with that return address.

This unifies execution flow:

* New threads and resumed threads both enter via `ret`
* No special-case logic is needed in the scheduler

##### 2.1.5 Integration with Scheduler:

Context switching is always triggered by the scheduler:

```c
thread_schedule() {
    ...
    current_thread = next;
    thread_switch(old, next);
}
```

State updates occur before the switch:

* `old`: `T_RUNNING → T_RUNNABLE` or `T_SLEEPING`
* `next`: `T_RUNNABLE → T_RUNNING`

This guarantees:

* No two threads are ever in `T_RUNNING`
* The scheduler has a consistent view of thread states

#### 2.2 Scheduler Algorithm

The scheduler is responsible for selecting the next runnable thread and performing a context switch. This library implements a cooperative, round-robin scheduler over a fixed-size thread table.

Scheduling decisions occur only when a thread explicitly yields, blocks, or exits.

##### 2.2.1 Scheduling Entry Point:

The scheduler is invoked through:

```c
void thread_schedule(void);
```

This function is called by:

* `thread_yield`
* `thread_exit`
* `thread_join`
* Blocking synchronization primitives (mutex, semaphore, condition variable)

##### 2.2.2 Thread Table and Indexing:

All threads are stored in a global fixed-size array:

```c
struct thread threads[MAX_THREADS];
struct thread *current_thread;
```

The scheduler identifies the index of the current thread using pointer arithmetic:

```c
int start = (current_thread - threads + 1) % MAX_THREADS;
```

This ensures round-robin traversal begins after the current thread.

##### 2.2.3 Runnable Thread Selection (Round-Robin Scan)

The scheduler scans the thread table at most once:

```c
for (int i = 0; i < MAX_THREADS; i++) {
    int idx = (start + i) % MAX_THREADS;
    if (threads[idx].state == T_RUNNABLE) {
        next = &threads[idx];
        break;
    }
}
```

* Wrap-around scanning using modulo arithmetic
* First runnable thread encountered is selected
* Fairness is ensured among runnable threads
* No priority levels or starvation logic are involved

##### 2.2.4 No-Runnable-Thread Case

If no thread is found in `T_RUNNABLE` state:

```c
if (!next)
    return;
```

Behavior:

* The current thread continues execution
* No state changes occur
* No context switch is performed

This case typically occurs when:

* The current thread is the only runnable thread
* All other threads are blocked (`T_SLEEPING`) or exited (`T_ZOMBIE`)

##### 2.2.5 State Transition Ordering**

Before performing the context switch, the scheduler updates thread states:

```c
if (old->state == T_RUNNING)
    old->state = T_RUNNABLE;

next->state = T_RUNNING;
current_thread = next;
```

State transitions:

* `old`: `T_RUNNING → T_RUNNABLE` (unless already `T_SLEEPING` or `T_ZOMBIE`)
* `next`: `T_RUNNABLE → T_RUNNING`

This ordering guarantees:

* Exactly one thread is in `T_RUNNING`
* Blocked threads are never rescheduled
* Scheduler state remains consistent across switches

##### 2.2.6 Context Switch Invocation

After state updates:

```c
thread_switch(old, next);
```

Important control-flow detail:

* Execution resumes in the new thread
* The function does not return to the caller in the original thread
* The old thread resumes only when scheduled again later

##### 2.2.7 Determinism and Cooperative Semantics

The scheduler never preempts running threads.
A thread runs until it explicitly:

* Calls `thread_yield`
* Blocks in a synchronization primitive
* Calls `thread_exit`

This property ensures:

* Scheduling points are explicit and predictable
* No asynchronous interrupts affect thread state
* Synchronization logic can assume atomicity between yields

 

### Part 2



#### 2.3 Sleep / Wakeup Mechanism

Thread sleeping and waking are implemented entirely in user space by manipulating thread states and invoking the cooperative scheduler. There is no kernel support, no interrupts, and no preemption.

##### 2.3.1 Sleeping a Thread

A thread goes to sleep only when it cannot make progress due to synchronization constraints.

Sleeping occurs in:

* `mutex_lock`
* `sem_wait`
* `cond_wait`
* `thread_join`

The common pattern is:

```c
current_thread->state = T_SLEEPING;
thread_schedule();
```
* The thread marks itself as `T_SLEEPING` before yielding
* Sleeping threads are never selected by the scheduler
* Control is explicitly transferred via `thread_schedule`

There is no separate sleep function; sleeping is encoded as a state transition plus a scheduler call.

##### 2.3.2 Atomic Sleep from the Programmer’s Perspective

Because the system is cooperative, the following sequence is atomic:

```c
mutex_unlock(m);
current_thread->state = T_SLEEPING;
thread_schedule();
```

No other thread can run between these operations unless `thread_schedule` is called. This property is critical for:

* `cond_wait`
* avoiding lost wakeups
* correct mutex–condition interaction

##### 2.3.3 Wakeup Mechanism

Waking a thread consists of:

1. Identifying the blocked thread
2. Changing its state to `T_RUNNABLE`

```c
threads[i].state = T_RUNNABLE;
```

Once woken:

* The thread does not run immediately
* It becomes eligible for scheduling
* It will execute when selected by the scheduler

##### 2.3.4 Wakeup via Wait Queues

All synchronization primitives maintain their own wait queues as arrays of thread IDs:

```c
int wait_queue[MAX_THREADS];
int wait_count;
```

Blocked threads are enqueued when they sleep:

```c
wait_queue[wait_count++] = current_thread->tid;
```

Wakeup removes one or more threads from the queue:

```c
int tid = wait_queue[0];
shift queue left;
wait_count--;
```

The scheduler never inspects wait queues. Only the synchronization primitive modifies them.

##### 2.3.5 Sleeping in `thread_join`

`thread_join` blocks the caller until the target thread reaches `T_ZOMBIE`:

```c
while (target->state != T_ZOMBIE) {
    current_thread->state = T_SLEEPING;
    target->waiting_tid = current_thread->tid;
    thread_schedule();
}
```

Wakeup occurs in `thread_exit`:

```c
if (current_thread->waiting_tid >= 0)
    wake waiting thread
```

This ensures:

* Exactly one waiting thread is woken
* Return value remains available until join completes

##### 2.3.6 Sleeping in Mutex Lock

When a mutex is held:

```c
m->wait_queue[m->wait_count++] = current_thread->tid;
current_thread->state = T_SLEEPING;
thread_schedule();
```

Wakeup occurs in `mutex_unlock`, which:

* selects one waiting thread
* marks it `T_RUNNABLE`
* assigns mutex ownership before wakeup

##### 2.3.7 Sleeping in Semaphores

In `sem_wait`:

```c
s->count--;
if (s->count < 0) {
    enqueue current_thread
    current_thread->state = T_SLEEPING;
    thread_schedule();
}
```

Wakeup occurs in `sem_post`:

```c
s->count++;
if (s->count <= 0)
    wake one waiting thread
```

The semaphore count encodes whether threads must block.

##### 2.3.8 Sleeping in Condition Variables

In `cond_wait`:

```c
enqueue current_thread in cond queue
mutex_unlock(m)
current_thread->state = T_SLEEPING
thread_schedule()
mutex_lock(m)
```

Wakeup occurs via:

* `cond_signal` (one thread)
* `cond_broadcast` (all threads)

Threads resume holding the mutex again.

##### 2.3.9 Absence of Kernel Wakeups

There is:

* No kernel sleep
* No signals
* No interrupts

All sleep/wakeup behavior is:

* explicit
* deterministic
* driven entirely by thread state transitions and scheduling

#### 2.4 Wait Queue Management

Wait queues are the core mechanism used to block and wake threads in all synchronization primitives. Each primitive maintains its own private wait queue in user space.

##### 2.4.1 Wait Queue Data Structure

All wait queues use the same simple representation:

```c
int wait_queue[MAX_THREADS];
int wait_count;
```

* Stores thread IDs (tid), not pointers
* FIFO order
* Fixed-size array (bounded by `MAX_THREADS`)
* No dynamic allocation

##### 2.4.2 Enqueue Operation

A thread is enqueued when it must block:

```c
wait_queue[wait_count++] = current_thread->tid;
```

* Enqueue happens before the thread goes to `T_SLEEPING`
* Only the currently running thread can enqueue itself
* No duplicate insertion: a thread enqueues at most once per blocking point

Used in:

* `mutex_lock`
* `sem_wait`
* `cond_wait`
* `thread_join`

##### 2.4.3 Dequeue Operation (Single Wakeup)

To wake one thread:

```c
int tid = wait_queue[0];
for (int i = 1; i < wait_count; i++)
    wait_queue[i - 1] = wait_queue[i];
wait_count--;
```

Then locate the thread structure:

```c
threads[i].state = T_RUNNABLE;
```

* FIFO wakeup ensures fairness
* Thread is only marked runnable, not immediately executed
* Ownership (e.g., mutex owner) is assigned before wakeup

Used in:

* `mutex_unlock`
* `sem_post`
* `cond_signal`
* `thread_exit`

##### 2.4.4 Dequeue Operation (Broadcast)

For waking all waiting threads:

```c
while (wait_count > 0) {
    dequeue tid
    mark corresponding thread T_RUNNABLE
}
```

Used in:

* `cond_broadcast`
* `channel_close`

All waiting threads become runnable in a single scheduling round.

##### 2.4.5 Thread Identification

Threads are located by matching `tid`:

```c
if (threads[i].tid == tid)
```

This avoids storing raw pointers and keeps wait queues robust across thread reuse.

##### 2.4.6 Ownership Transfer and Wakeup Ordering

For primitives with ownership semantics (mutex, channel):

* Ownership is transferred before wakeup
* The woken thread resumes assuming it owns the resource

Example in `mutex_unlock`:

1. Remove one waiting thread
2. Assign `m->owner = tid`
3. Mark thread `T_RUNNABLE`

This prevents races where a thread wakes without owning the lock.

##### 2.4.7 Interaction with Scheduler

The scheduler:

* Does not inspect wait queues
* Only considers thread state (`T_RUNNABLE`)

Wait queues are entirely managed by synchronization primitives. The scheduler remains simple and generic.

##### 2.4.8 Safety Guarantees

This wait queue design ensures:

* No lost wakeups
* No spurious wakeups
* Deterministic wakeup order
* No concurrent queue modification (cooperative model)

All modifications occur while the current thread is running and before calling `thread_schedule`.

#### 2.5 Mutex Implementation

##### 2.5.1 Mutex Data Structure

The mutex is implemented as a user-level synchronization primitive that enforces mutual exclusion among cooperative threads.

```c
typedef struct {
    int locked;
    int owner;
    int wait_queue[MAX_THREADS];
    int wait_count;
} mutex_t;
```

* `locked`
  Indicates whether the mutex is currently held (`1`) or free (`0`).

* `owner`
  Stores the `tid` of the thread that currently owns the mutex. This is used to:

  * enforce ownership on `mutex_unlock`
  * transfer ownership correctly when waking a blocked thread

* `wait_queue[]` and `wait_count`
  A FIFO queue storing the `tid`s of threads blocked while attempting to acquire the mutex.

##### 2.5.2 Mutex Initialization

```c
void mutex_init(mutex_t *m)
{
    m->locked = 0;
    m->owner = -1;
    m->wait_count = 0;
}
```

The mutex starts in an unlocked state with no owner and an empty wait queue. No dynamic allocation is used; all state is stored directly in the structure.

##### 2.5.3 Lock Acquisition (`mutex_lock`)

```c
void mutex_lock(mutex_t *m)
{
    if (!m->locked) {
        m->locked = 1;
        m->owner = current_thread->tid;
        return;
    }

    if (m->owner == current_thread->tid)
        return;

    m->wait_queue[m->wait_count++] = current_thread->tid;
    current_thread->state = T_SLEEPING;
    thread_schedule();
}
```

The lock acquisition path has three cases:

1. **Unlocked mutex**

   * The calling thread immediately acquires the lock.
   * `locked` is set to `1`.
   * `owner` is set to the current thread’s `tid`.

2. **Re-entrant lock attempt by owner**

   * If the current thread already owns the mutex, the call returns immediately.
   * This avoids self-deadlock without adding recursion counters.

3. **Locked by another thread**

   * The current thread is appended to the mutex wait queue.
   * Its state is set to `T_SLEEPING`.
   * `thread_schedule()` is invoked to yield control.

Because the threading model is cooperative, no other thread can run between enqueuing the thread and calling `thread_schedule()`. This guarantees atomicity of the block operation.

When the thread is later woken, it resumes execution directly after `thread_schedule()` and already owns the mutex (ownership is transferred by the unlock path).

##### 2.5.4 Lock Release (`mutex_unlock`)

```c
void mutex_unlock(mutex_t *m)
{
    if (m->owner != current_thread->tid)
        return;

    if (m->wait_count == 0) {
        m->locked = 0;
        m->owner = -1;
        return;
    }

    int next_tid = m->wait_queue[0];
    for (int i = 1; i < m->wait_count; i++)
        m->wait_queue[i - 1] = m->wait_queue[i];
    m->wait_count--;

    for (int i = 0; i < MAX_THREADS; i++) {
        if (threads[i].tid == next_tid) {
            threads[i].state = T_RUNNABLE;
            m->owner = next_tid;
            break;
        }
    }
}
```

The unlock path enforces strict ownership and FIFO wakeup:

1. **Ownership check**

   * If the calling thread is not the owner, the function returns immediately.
   * This prevents accidental unlocks by non-owning threads.

2. **No waiting threads**

   * The mutex is marked as unlocked.
   * `owner` is cleared.

3. **Waiting threads present**

   * The first thread in the wait queue is dequeued (FIFO).
   * That thread’s state is set to `T_RUNNABLE`.
   * Ownership of the mutex is transferred directly to the woken thread.
   * The mutex remains logically locked.

The woken thread will resume execution after its blocked `mutex_lock` call and enter the critical section without rechecking the lock.

##### 2.5.5 Interaction with Thread States and Scheduler

* Threads blocked on a mutex are placed in `T_SLEEPING` state.
* `mutex_unlock` does not invoke the scheduler directly.
* Woken threads become `T_RUNNABLE` and are scheduled naturally by the round-robin scheduler.
* At no point does the mutex perform busy-waiting.

#### 2.6 Shared Counter without / with Mutex

##### 2.6.1 Problem Setup

A shared integer counter is initialized to zero and incremented concurrently by multiple user-level threads.

* Number of threads: ≥ 2
* Each thread performs `N` increments
* Expected final value: `num_threads × N`

The test is implemented twice:

1. Without synchronization
2. With mutex protection

##### 2.6.2 Case 1: Without Mutex (Race Condition)

**Code Pattern：**

```c
for (int i = 0; i < N; i++) {
    counter++;
}
```

**Observed Behavior：**

When running with two threads and `N = 1000`, the final output is frequently:

```text
counter = 1000
```

instead of the expected:

```text
counter = 2000
```

The exact result consistently less than expected.

**Root Cause Analysis：**

The increment operation is not atomic. At the machine level, `counter++` expands to three steps:

1. Load `counter` from memory into a register
2. Increment the register
3. Store the register back to memory

In a cooperative threading model, context switches can occur between any of these steps due to:

* `thread_yield()`
* blocking on another primitive
* scheduler invocation at explicit yield points

**Example Interleaving：**

Initial value: `counter = 0`

| Thread A         | Thread B         |
| ---------------- | ---------------- |
| load counter → 0 |                  |
|                  | load counter → 0 |
| increment → 1    |                  |
| store → 1        |                  |
|                  | increment → 1    |
|                  | store → 1        |

Two increments occurred, but the final value increased by only 1.

This is a classic lost update race condition.

##### 2.6.3 Case 2: With Mutex (Correct Synchronization)

**Code Pattern：**

```c
for (int i = 0; i < N; i++) {
    mutex_lock(&m);
    counter++;
    mutex_unlock(&m);
}
```

**Observed Behavior：**

With the mutex enabled, the output becomes deterministic:

```text
counter = 2000
```

for two threads with `N = 1000`.

**Why the Mutex Fixes the Problem：**

The mutex enforces **exclusive access** to the critical section containing `counter++`.

* Only one thread can execute the increment at a time.
* Other threads attempting to enter the critical section are:

  * placed into the mutex wait queue
  * transitioned to `T_SLEEPING`
  * resumed only after the mutex is released

Because the mutex spans the entire read–modify–write sequence, the increment operation becomes effectively atomic at the thread level.

##### 2.6.4 Interaction with Thread Scheduler

* Threads blocked on `mutex_lock` are removed from scheduling consideration.
* The unlocking thread wakes exactly one waiting thread.
* Ownership is transferred before the woken thread resumes execution.
* No busy waiting or repeated checking occurs.

#### 2.7 Semaphores

##### 2.7.1 Semaphore Structure

The semaphore is implemented as a counting semaphore with an explicit wait queue.

```c
typedef struct {
    int count;
    int wait_queue[MAX_THREADS];
    int wait_count;
} sem_t;
```

* `count` represents available resources
* `count < 0` indicates the number of threads currently blocked
* `wait_queue` stores thread IDs of blocked threads in FIFO order
* `wait_count` tracks the number of waiting threads

##### 2.7.2 sem_init

```c
void sem_init(sem_t *s, int value)
```

* Initializes `count` to the given value
* Clears the wait queue
* No thread is blocked at initialization


##### 2.7.3 sem_wait

```c
void sem_wait(sem_t *s)
```

**Execution Steps：**

1. Decrement `s->count`
2. If `count >= 0`, return immediately
3. If `count < 0`:

   * enqueue the current thread into `wait_queue`
   * set thread state to `T_SLEEPING`
   * invoke `thread_schedule()`

**Blocking Semantics：**

* The decrement occurs before the decision to block
* The number of blocked threads is exactly `-count`
* Threads sleep without spinning and are removed from scheduling


##### 2.7.4 sem_post

```c
void sem_post(sem_t *s)
```

**Execution Steps：**

1. Increment `s->count`
2. If `count <= 0`:

   * dequeue one thread from `wait_queue`
   * set its state to `T_RUNNABLE`

**Wakeup Semantics：**

* Exactly one waiting thread is woken per `sem_post`
* FIFO order ensures predictable wakeup behavior
* Ownership of the semaphore is transferred implicitly through scheduling


##### 2.7.5 Atomicity Guarantees

All semaphore operations execute without internal yields between:

* modifying `count`
* enqueueing or dequeueing waiters
* changing thread states

Because the threading model is cooperative, no other thread can interleave within a semaphore operation unless explicitly scheduled.


##### 2.7.6 Interaction with Thread States

| Operation         | Thread State Change   |
| ----------------- | --------------------- |
| `sem_wait` blocks | `RUNNING → SLEEPING`  |
| `sem_post` wakes  | `SLEEPING → RUNNABLE` |

Blocked threads are excluded from scheduling until explicitly woken.


##### 2.7.7 Usage Pattern in This Project

Semaphores are used to solve the Producer–Consumer problem with:

* one semaphore tracking empty slots
* one semaphore tracking filled slots
* a mutex protecting buffer access

This separation allows:

* resource counting via semaphores
* mutual exclusion via mutexes
* no busy waiting or polling


##### 2.7.8 Failure Modes Prevented

* Lost wakeups: waiters are queued explicitly
* Over-release: `count` encodes resource availability
* Starvation: FIFO queue ensures fairness among waiters

#### 2.8 Condition Variables

##### 2.8.1 Condition Variable Structure

Condition variables are implemented as a pure waiting mechanism without internal state.

```c
typedef struct {
    int wait_queue[MAX_THREADS];
    int wait_count;
} cond_t;
```

* Condition variables do not store predicates
* They only manage a queue of sleeping threads
* Correctness depends on external state protected by a mutex


##### 2.8.2 cond_init

```c
void cond_init(cond_t *c)
```

* Initializes an empty wait queue
* No thread is blocked at initialization


##### 2.8.3 cond_wait

```c
void cond_wait(cond_t *c, mutex_t *m)
```

**Required Preconditions：**

* The calling thread **must hold mutex `m`**
* The predicate associated with the condition must be checked by the caller

**Execution Steps：**

1. Enqueue the current thread into `c->wait_queue`
2. Release mutex `m` using `mutex_unlock`
3. Set current thread state to `T_SLEEPING`
4. Call `thread_schedule`
5. Upon wakeup, re-acquire mutex `m` using `mutex_lock`

**Atomicity Guarantee：**

* No thread can run between:

  * releasing the mutex
  * entering the sleeping state
* This prevents missed wakeups in a cooperative scheduler


##### 2.8.4 cond_signal

```c
void cond_signal(cond_t *c)
```

**Execution Steps：**

1. If the wait queue is empty, return
2. Dequeue one waiting thread
3. Set its state to `T_RUNNABLE`

* Wakes **at most one** waiting thread
* Does not transfer mutex ownership


##### 2.8.5 cond_broadcast

```c
void cond_broadcast(cond_t *c)
```

**Execution Steps：**

1. Iterate through all waiting threads
2. Set each thread’s state to `T_RUNNABLE`
3. Clear the wait queue

* Used when multiple threads may proceed
* All woken threads must re-check the predicate after acquiring the mutex


##### 2.8.6 Thread State Transitions

| Operation        | State Transition            |
| ---------------- | --------------------------- |
| `cond_wait`      | `RUNNING → SLEEPING`        |
| `cond_signal`    | `SLEEPING → RUNNABLE`       |
| `cond_broadcast` | `SLEEPING → RUNNABLE` (all) |


##### 2.8.7 Mutex Interaction Model

* Condition variables **never** lock or unlock on their own
* Mutex ownership is explicitly released before sleeping and reacquired after wakeup
* This preserves the invariant that the predicate is always checked under mutual exclusion


##### 2.8.8 Usage Pattern in This Project

Condition variables are used to implement:

* Writer-priority reader–writer locks
* Channel blocking semantics (internally)
* Controlled wakeups without busy waiting

All condition waits are enclosed in loops that re-check the condition after wakeup.


##### 2.8.9 Correctness Properties

* No lost wakeups
* No busy waiting
* Deterministic sleep/wakeup behavior
* Compatible with cooperative scheduling model

#### 2.9 Channels

##### 2.9.1 Channel Structure

Channels are implemented as a bounded circular buffer with internal synchronization.

```c
typedef struct {
    void **buf;
    int capacity;
    int count;
    int read_pos;
    int write_pos;
    int closed;

    mutex_t lock;
    cond_t not_empty;
    cond_t not_full;
} channel_t;
```

* `buf` stores data pointers (`void *`)
* `count` tracks number of elements currently in the buffer
* `read_pos` and `write_pos` implement a circular queue
* `closed` indicates no further sends are allowed
* All state is protected by a single mutex

##### 2.9.2 channel_create

```c
channel_t* channel_create(int capacity)
```

**Initialization Steps：**

1. Allocate `channel_t`
2. Allocate buffer of size `capacity`
3. Initialize indices and counters to zero
4. Set `closed = 0`
5. Initialize mutex and both condition variables

The channel is empty and open upon creation.

##### 2.9.3 channel_send

```c
int channel_send(channel_t *ch, void *data)
```

**Execution Steps：**

1. Acquire `ch->lock`
2. If channel is closed, release lock and return `-1`
3. While buffer is full:

   * Wait on `not_full`
   * If channel becomes closed while waiting, return `-1`
4. Insert `data` at `write_pos`
5. Advance `write_pos` modulo `capacity`
6. Increment `count`
7. Signal `not_empty`
8. Release lock and return `0`

**Blocking Semantics：**

* Sender blocks only when buffer is full
* No busy waiting
* Woken senders must re-check buffer state

##### 2.9.4 channel_recv

```c
int channel_recv(channel_t *ch, void **data)
```

**Execution Steps：**

1. Acquire `ch->lock`
2. While buffer is empty:

   * If channel is closed, release lock and return `-1`
   * Wait on `not_empty`
3. Read data from `read_pos`
4. Advance `read_pos` modulo `capacity`
5. Decrement `count`
6. Signal `not_full`
7. Release lock and return `0`

**Blocking Semantics：**

* Receiver blocks only when buffer is empty
* Receivers wake immediately when data is available

##### 2.9.5 channel_close

```c
void channel_close(channel_t *ch)
```

**Execution Steps：**

1. Acquire `ch->lock`
2. Set `closed = 1`
3. Broadcast on `not_empty`
4. Broadcast on `not_full`
5. Release lock

**Close Semantics：**

* All blocked senders wake and return `-1`
* All blocked receivers wake:

  * return remaining buffered data if any
  * return `-1` when buffer becomes empty
* No thread remains blocked after close

##### 2.9.6 Internal Synchronization Model

* Single mutex protects all channel state
* Two condition variables separate waiting roles:

  * `not_empty`: receivers
  * `not_full`: senders
* No external synchronization required by users

##### 2.9.7 Thread State Transitions

| Operation           | State Transition      |
| ------------------- | --------------------- |
| send (buffer full)  | `RUNNING → SLEEPING`  |
| recv (buffer empty) | `RUNNING → SLEEPING`  |
| signal/broadcast    | `SLEEPING → RUNNABLE` |

##### 2.9.8 Channel Guarantees

* FIFO ordering of messages
* No lost wakeups
* No busy waiting
* Correct shutdown behavior

##### 2.9.9 Usage in This Project

Channels are used to implement:

* Producer–Consumer without explicit locks or semaphores
* Message-based coordination between threads
* Blocking communication with bounded buffering

All concurrency control is internal to the channel implementation.

 

### Part 3



#### 2.10 Producer–Consumer Problem

- Producers generate fixed number of items
- Consumers process items until all are consumed
- Bounded buffer size = 5
- Correctness requirements:
  - No lost items
  - No duplicate consumption
  - No buffer overflow / underflow
  - Proper termination of consumers

##### 2.10.1 Using Semaphores

**Shared State：**

```c
int buffer[BUF_SIZE];
int in;
int out;

int consumed;

mutex_t buf_mutex;
mutex_t count_mutex;

sem_t empty;
sem_t full;
```

- `buffer` is a circular queue
- `in / out` are write/read indices
- `consumed` tracks total processed items

##### Semaphore Initialization：

```c
sem_init(&empty, BUF_SIZE);
sem_init(&full, 0);
```

- `empty`: number of free slots
- `full`: number of available items

##### Producer Logic：

Execution order per item:

1. `sem_wait(empty)`
2. `mutex_lock(buf_mutex)`
3. Write item to `buffer[in]`
4. Advance `in`
5. `mutex_unlock(buf_mutex)`
6. `sem_post(full)`

Key properties:

- Producers block only when buffer is full
- Mutual exclusion enforced only during buffer access
- No producer touches `out`

##### Consumer Logic：

Execution order per item:

1. `sem_wait(full)`
2. `mutex_lock(buf_mutex)`
3. Read item from `buffer[out]`
4. Advance `out`
5. `mutex_unlock(buf_mutex)`
6. `sem_post(empty)`
7. Update `consumed` under `count_mutex`

##### Termination Handling：

- Consumers exit when `consumed == TOTAL_ITEMS`
- `count_mutex` ensures termination condition is checked atomically
- Producers terminate independently after fixed production count

##### Blocking & Wakeup Semantics：

| Condition    | Blocked On        |
| ------------ | ----------------- |
| Buffer full  | `empty` semaphore |
| Buffer empty | `full` semaphore  |

No busy waiting, no missed wakeups.

##### Observed Behavior：

- Interleaved production and consumption
- Consumers may consume items produced by different producers
- Ordering is FIFO relative to buffer insertion, not producer identity

##### 2.10.2 Using Channels

**Shared State：**

```c
channel_t *ch;
```

- Single communication object
- No explicit buffer or counters exposed to user code

**Channel Initialization：**

```c
ch = channel_create(BUF_SIZE);
```

- Buffer size is enforced internally
- All synchronization handled inside channel

**Producer Logic：**

```c
channel_send(ch, item);
```

- Blocks if channel buffer is full
- Returns `-1` if channel is closed

Each producer:

- Sends exactly `ITEMS_PER_PROD` items
- Terminates without coordination with consumers

**Consumer Logic：**

```c
while (channel_recv(ch, &item) == 0) {
    consume(item);
}
```

- Blocks if channel is empty
- Exits cleanly when channel is closed and drained

**Channel Closure Protocol：**

After all producers finish:

```c
channel_close(ch);
```

Effects:

- Wakes all blocked senders and receivers
- No new sends allowed
- Receivers drain remaining buffered items
- Consumers exit naturally when buffer becomes empty

**Blocking & Wakeup Semantics：**

| Operation | Wait Condition             |
| --------- | -------------------------- |
| send      | buffer full (`not_full`)   |
| recv      | buffer empty (`not_empty`) |

Implemented via:

- Internal mutex
- Condition variables
- Broadcast on close

##### 2.10.3 Comparison: Semaphores vs Channels

| Aspect                | Semaphores  | Channels            |
| --------------------- | ----------- | ------------------- |
| Buffer management     | Explicit    | Internal            |
| Termination logic     | Manual      | Automatic via close |
| Error-prone state     | High        | Low                 |
| Code complexity       | Higher      | Lower               |
| Synchronization scope | Distributed | Encapsulated        |

**Key Observation：**

The channel-based implementation removes:

- Explicit semaphores
- Shared counters
- Termination coordination logic

All synchronization correctness is enforced by the channel abstraction.

#### 2.11 Reader-Writer Lock (Writer Priority)

##### 2.11.1 Shared State

The reader–writer lock is implemented using the following shared variables:

```c
int readers;
int writers_waiting;
int writer_active;

mutex_t lock;
cond_t can_read;
cond_t can_write;
```

- `readers`: number of readers currently holding the lock
- `writers_waiting`: number of writers waiting to acquire the lock
- `writer_active`: whether a writer currently holds the lock
- `lock`: protects all shared state
- `can_read`: condition variable for blocked readers
- `can_write`: condition variable for blocked writers

##### 2.11.2 Reader Lock Acquisition

```c
void reader_lock() {
    mutex_lock(&lock);
    while (writer_active || writers_waiting > 0) {
        cond_wait(&can_read, &lock);
    }
    readers++;
    mutex_unlock(&lock);
}
```

Behavior:

- A reader blocks if:
  - a writer is currently active, or
  - any writer is waiting
- This prevents new readers from entering once a writer expresses intent
- Multiple readers may proceed concurrently if no writer is active or waiting

##### 2.11.3 Reader Lock Release

```c
void reader_unlock() {
    mutex_lock(&lock);
    readers--;
    if (readers == 0 && writers_waiting > 0) {
        cond_signal(&can_write);
    }
    mutex_unlock(&lock);
}
```

Behavior:

- The last reader wakes one waiting writer
- Readers do not wake other readers
- Writers are given priority once readers drain

##### 2.11.4 Writer Lock Acquisition

```c
void writer_lock() {
    mutex_lock(&lock);
    writers_waiting++;
    while (writer_active || readers > 0) {
        cond_wait(&can_write, &lock);
    }
    writers_waiting--;
    writer_active = 1;
    mutex_unlock(&lock);
}
```

Behavior:

- Writer blocks until:
  - no active writer, and
  - no active readers
- `writers_waiting` is incremented before blocking
- This immediately prevents new readers from entering

##### 2.11.5 Writer Lock Release

```c
void writer_unlock() {
    mutex_lock(&lock);
    writer_active = 0;
    if (writers_waiting > 0) {
        cond_signal(&can_write);
    } else {
        cond_broadcast(&can_read);
    }
    mutex_unlock(&lock);
}
```

Behavior:

- Writers are woken first if any are waiting
- Readers are only woken when no writers remain
- Ensures writer priority without starvation

##### 2.11.6 Writer Priority Guarantee

Writer priority is enforced by two mechanisms:

1. Admission control
   - Readers block if `writers_waiting > 0`
2. Wake-up ordering
   - Writers are signaled before readers

This guarantees:

- No writer starvation
- No concurrent read/write access
- Maximumreader concurrency when no writer is pending

##### 2.11.7 Observed Execution Pattern

- Multiple readers may run concurrently
- Once a writer arrives:
  - No new readers are admitted
  - Existing readers finish
  - Writer executes exclusively
- Writers execute sequentially
- Readers resume only after all waiting writers complete



### Part 4



#### 2.11 Thread-Safe File I/O

##### 2.11.1 Problem Context

In xv6, file system operations (`read`, `write`) are blocking system calls.
In a user-level threading library, a blocking syscall blocks the entire process, not just the calling thread.

Therefore, true asynchronous file I/O cannot be implemented transparently without kernel support.
This section instead demonstrates safe coordination of file-based communication between threads using synchronization primitives, while respecting xv6’s blocking semantics.

##### 2.11.2 Design Approach

We implement Producer–Consumer through a shared file:

* The file acts as an unbounded append-only buffer
* Producers append data using `write`
* Consumers read data using `read`
* Synchronization is handled entirely in user space
* No circular buffer or in-memory queue is used

This demonstrates:

* Safe coordination across blocking I/O
* Correct ordering and completeness
* Integration of threads with OS-level file APIs

##### 2.11.3 Shared Resources

```c
int fd;
int produced;
int consumed;
```

Synchronization primitives:

```c
mutex_t file_lock;
mutex_t count_lock;
cond_t can_read;
```

* `file_lock`: serializes file access
* `count_lock`: protects counters
* `can_read`: signals consumers when new data is available

##### 2.11.4 Producer Logic

```c
void *producer(void *arg) {
    for (int i = 0; i < N; i++) {
        char buf[32];
        snprintf(buf, sizeof(buf), "item %d\n", i);

        mutex_lock(&file_lock);
        write(fd, buf, strlen(buf));
        mutex_unlock(&file_lock);

        mutex_lock(&count_lock);
        produced++;
        cond_signal(&can_read);
        mutex_unlock(&count_lock);

        thread_yield();
    }
    return 0;
}
```

Key points:

* File writes are serialized using `file_lock`
* Each write appends a complete record
* Producer signals consumers after each successful write
* `thread_yield()` ensures interleaving for demonstration

##### 2.11.5 Consumer Logic

```c
void *consumer(void *arg) {
    char buf[32];

    while (1) {
        mutex_lock(&count_lock);
        while (consumed >= produced) {
            cond_wait(&can_read, &count_lock);
        }
        mutex_unlock(&count_lock);

        mutex_lock(&file_lock);
        int n = read(fd, buf, sizeof(buf));
        mutex_unlock(&file_lock);

        if (n <= 0)
            break;

        write(1, buf, n);

        mutex_lock(&count_lock);
        consumed++;
        mutex_unlock(&count_lock);

        thread_yield();
    }
    return 0;
}
```

Key points:

* Consumers block using condition variables instead of busy waiting
* File reads are serialized
* Consumers only proceed when producers have written new data
* No data loss or duplication occurs

##### 2.11.6 Asynchronous Semantics in User Space

Although `read` and `write` are blocking:

* Threads cooperate explicitly
* Blocking is avoided by:

  * separating I/O from synchronization
  * ensuring threads only enter I/O when safe
* This achieves logical asynchrony, not kernel-level asynchrony

##### 2.11.7 Observed Behavior

* Producers and consumers interleave correctly
* Output ordering may interleave at character granularity due to console writes
* All produced items are eventually consumed
* No deadlocks or missed data occur



### 3 How the Primitives Were Used to Solve the Problems
#### 3.1 Mutual Exclusion: Protecting Critical Sections

**Primitive used**

* `mutex_t`

**Usage**

* Mutexes were used to guard shared data structures accessed by multiple threads:

  * Shared counters
  * Bounded buffers
  * File descriptors and file offsets
  * Reader–writer state variables

**Mechanism**

* Threads attempting to enter a critical section call `mutex_lock`
* If the mutex is held, the thread transitions to `T_SLEEPING` and is enqueued
* `mutex_unlock` wakes exactly one waiting thread or releases the lock

**Why mutexes are required**

* Prevents concurrent writes to shared memory
* Eliminates race conditions caused by interleaved execution at yield points
* Provides exclusive access without busy waiting

#### 3.2 Shared Counter Problem

**Without synchronization**

* Multiple threads increment a shared integer
* Operations `load → increment → store` interleave
* Lost updates occur

**With mutex**

* Counter increments are enclosed in `mutex_lock / mutex_unlock`
* Only one thread modifies the counter at a time
* Final value matches expected total

**Primitive used**

* `mutex_t`

**What this demonstrates**

* Correctness of mutex implementation
* Observable race condition prevention

#### 3.3 Producer–Consumer with Semaphores

**Primitives used**

* `sem_t` (counting semaphores)
* `mutex_t`

**Semaphores**

* `empty`: tracks available buffer slots
* `full`: tracks available items

**Mutex**

* Protects buffer indices and data

**Mechanism**

* Producers:

  1. `sem_wait(empty)`
  2. `mutex_lock`
  3. write to buffer
  4. `mutex_unlock`
  5. `sem_post(full)`

* Consumers:

  1. `sem_wait(full)`
  2. `mutex_lock`
  3. read from buffer
  4. `mutex_unlock`
  5. `sem_post(empty)`

**Why semaphores are needed**

* Prevent lost wakeups
* Encode resource availability directly
* Avoid polling or manual condition tracking

#### 3.4 Producer–Consumer with Channels

**Primitive used**

* `channel_t`

**Internal composition**

* One mutex
* Two condition variables (`not_empty`, `not_full`)
* Circular buffer

**Mechanism**

* Producers block automatically when the channel is full
* Consumers block automatically when the channel is empty
* Channel close wakes all blocked threads

**Why channels simplify the problem**

* No explicit buffer or index management in user code
* No separate semaphores or mutexes required
* Synchronization is entirely encapsulated

#### 3.5 Condition Variables for Coordination

**Primitive used**

* `cond_t` with `mutex_t`

**Usage**

* Used when threads must wait for logical conditions rather than resource counts:

  * Buffer state transitions
  * Reader–writer coordination
  * Channel signaling

**Mechanism**

* Waiting thread:

  * releases mutex
  * sleeps on condition queue
* Signaling thread:

  * wakes one or all waiting threads
* Mutex is re-acquired before returning

**What this enables**

* Fine-grained coordination
* No busy waiting
* Precise wakeup semantics

#### 3.6 Reader–Writer Lock with Writer Priority

**Primitives used**

* `mutex_t`
* `cond_t`

**State protected by mutex**

* active readers count
* active writer flag
* waiting writers count

**Writer priority enforcement**

* Readers block if any writer is waiting
* Writers wait until no readers or writers are active
* Last reader wakes a writer
* Writer completion wakes next writer or all readers

**Why condition variables are required**

* Multiple distinct waiting conditions
* Selective wakeup policy
* Avoids writer starvation

#### 3.7 Channels as Message-Passing Abstraction

**Primitive used**

* `channel_t`

**Usage**

* Thread-to-thread communication without shared memory
* Used for:

  * Producer–consumer
  * Pipeline-style workflows

**Mechanism**

* Threads block on send/receive automatically
* Buffering and wakeups handled internally
* Channel close propagates termination

**Benefit**

* Eliminates explicit locking from application logic
* Demonstrates composition of primitives

#### 3.8 Thread-Safe File I/O

**Primitives used**

* `mutex_t`
* `cond_t`

**Problem**

* xv6 file system calls block the entire process
* User-level threads cannot rely on kernel async I/O

**Solution**

* Serialize file access with mutex
* Coordinate producer and consumer using condition variables
* Ensure file offset consistency

**What this demonstrates**

* Limits of user-level threading
* Safe coordination around blocking syscalls
* Correctness over performance

#### 3.9 Summary of Primitive Usage Mapping

| Problem                         | Primitives Used             |
| ------------------------------- | --------------------------- |
| Shared counter                  | Mutex                       |
| Producer–consumer               | Semaphores + Mutex          |
| Producer–consumer (alt)         | Channel                     |
| Reader–writer (writer priority) | Mutex + Condition Variables |
| Message passing                 | Channel                     |
| File-based producer–consumer    | Mutex + Condition Variables |



### 4 Summary

This project implements a complete user-level threading and synchronization library on top of xv6, progressively building from low-level execution mechanisms to higher-level concurrency abstractions and real-world synchronization problems.

At the core, the system provides:

* A fixed-size thread table with explicit thread states
* Per-thread stacks and a deterministic context switching mechanism
* A cooperative round-robin scheduler implemented entirely in user space

On top of this foundation, the library implements a full set of synchronization primitives:

* Mutexes for mutual exclusion and critical section protection
* Semaphores for resource counting and blocking coordination
* Condition variables for predicate-based waiting and signaling
* Channels as a higher-level message-passing abstraction built from mutexes and condition variables

These primitives were validated through classical concurrency problems:

* Shared counter race conditions
* Producer–consumer with both semaphores and channels
* Reader–writer synchronization with writer priority
* Message passing with bounded buffers
* Thread-safe file I/O in the presence of blocking system calls

All synchronization is implemented using sleep–wakeup semantics integrated with the thread scheduler, without busy waiting or kernel modification. Blocking is achieved by transitioning threads to `T_SLEEPING` and resuming them via explicit wakeups, ensuring correctness under cooperative scheduling.

