#include "types.h"
#include "user.h"
#include "uthreads.h"

extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

void
mutex_init(mutex_t *m)
{
    m->locked = 0;
    m->owner = -1;
    m->wait_count = 0;
}

void
mutex_lock(mutex_t *m)
{
    while (m->locked) {
        if (m->owner == current_thread->tid)
            return;
        m->wait_queue[m->wait_count++] = current_thread->tid;
        current_thread->state = T_SLEEPING;
        thread_schedule();
    }
    m->locked = 1;
    m->owner = current_thread->tid;
}

void
mutex_unlock(mutex_t *m)
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
