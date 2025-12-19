#include "types.h"
#include "user.h"
#include "uthreads.h"

struct thread threads[MAX_THREADS];
struct thread *current_thread;
int next_tid = 1;

static void
thread_trampoline(void)
{
    void *ret = current_thread->start_routine(current_thread->arg);
    thread_exit(ret);
}

void
thread_init(void)
{
    for (int i = 0; i < MAX_THREADS; i++) {
        threads[i].tid = -1;
        threads[i].state = T_UNUSED;
        threads[i].stack = 0;
        threads[i].sp = 0;
        threads[i].start_routine = 0;
        threads[i].arg = 0;
        threads[i].retval = 0;
        threads[i].waiting_tid = -1;
    }

    threads[0].tid = 0;
    threads[0].state = T_RUNNING;
    threads[0].waiting_tid = -1;

    current_thread = &threads[0];
}

int
thread_self(void)
{
    return current_thread->tid;
}

int
thread_create(void* (*start_routine)(void*), void *arg)
{
    int i;
    for (i = 0; i < MAX_THREADS; i++) {
        if (threads[i].state == T_UNUSED)
            break;
    }
    if (i == MAX_THREADS)
        return -1;

    struct thread *t = &threads[i];

    t->tid = next_tid++;
    t->state = T_RUNNABLE;
    t->start_routine = start_routine;
    t->arg = arg;
    t->retval = 0;
    t->waiting_tid = -1;

    t->stack = malloc(STACK_SIZE);
    if (!t->stack) {
        t->state = T_UNUSED;
        return -1;
    }

    uint *sp = (uint *)((char *)t->stack + STACK_SIZE);
    *(--sp) = (uint)thread_trampoline;
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
    t->sp = sp;

    return t->tid;
}

void
thread_schedule(void)
{
    struct thread *old = current_thread;
    struct thread *next = 0;

    int start = (old - threads + 1) % MAX_THREADS;

    for (int i = 0; i < MAX_THREADS; i++) {
        int idx = (start + i) % MAX_THREADS;
        if (threads[idx].state == T_RUNNABLE) {
            next = &threads[idx];
            break;
        }
    }

    if (!next)
        return;

    if (old->state == T_RUNNING)
        old->state = T_RUNNABLE;

    next->state = T_RUNNING;
    current_thread = next;

    thread_switch(old, next);
}

void
thread_yield(void)
{
    thread_schedule();
}

void
thread_exit(void *retval)
{
    current_thread->retval = retval;
    current_thread->state = T_ZOMBIE;

    if (current_thread->waiting_tid >= 0) {
        for (int i = 0; i < MAX_THREADS; i++) {
            if (threads[i].tid == current_thread->waiting_tid) {
                threads[i].state = T_RUNNABLE;
                break;
            }
        }
    }

    thread_schedule();

    for (;;)
        ;
}

void *
thread_join(int tid)
{
    struct thread *target = 0;

    for (int i = 0; i < MAX_THREADS; i++) {
        if (threads[i].tid == tid) {
            target = &threads[i];
            break;
        }
    }
    if (!target)
        return 0;

    while (target->state != T_ZOMBIE) {
        current_thread->state = T_SLEEPING;
        target->waiting_tid = current_thread->tid;
        thread_schedule();
    }

    void *ret = target->retval;

    free(target->stack);
    target->stack = 0;
    target->state = T_UNUSED;
    target->tid = -1;

    return ret;
}
void
sem_init(sem_t *s, int value)
{
    s->count = value;
    s->wait_count = 0;
}

void
sem_wait(sem_t *s)
{
    s->count--;
    if (s->count < 0) {
        s->wait_queue[s->wait_count++] = current_thread->tid;
        current_thread->state = T_SLEEPING;
        thread_schedule();
    }
}

void
sem_post(sem_t *s)
{
    s->count++;
    if (s->count <= 0 && s->wait_count > 0) {
        int tid = s->wait_queue[0];
        for (int i = 1; i < s->wait_count; i++)
            s->wait_queue[i - 1] = s->wait_queue[i];
        s->wait_count--;

        for (int i = 0; i < MAX_THREADS; i++) {
            if (threads[i].tid == tid) {
                threads[i].state = T_RUNNABLE;
                break;
            }
        }
    }
}

void
cond_init(cond_t *c)
{
    c->wait_count = 0;
}

void
cond_wait(cond_t *c, mutex_t *m)
{
    c->wait_queue[c->wait_count++] = current_thread->tid;
    mutex_unlock(m);
    current_thread->state = T_SLEEPING;
    thread_schedule();
    mutex_lock(m);
}

void
cond_signal(cond_t *c)
{
    if (c->wait_count == 0)
        return;

    int tid = c->wait_queue[0];
    for (int i = 1; i < c->wait_count; i++)
        c->wait_queue[i - 1] = c->wait_queue[i];
    c->wait_count--;

    for (int i = 0; i < MAX_THREADS; i++) {
        if (threads[i].tid == tid) {
            threads[i].state = T_RUNNABLE;
            break;
        }
    }
}

void
cond_broadcast(cond_t *c)
{
    while (c->wait_count > 0)
        cond_signal(c);
}
