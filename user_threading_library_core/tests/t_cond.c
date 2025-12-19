#include "types.h"
#include "user.h"
#include "uthreads.h"

mutex_t m;
cond_t c;
int ready = 0;

void *
worker(void *arg)
{
    int id = (int)arg;
    mutex_lock(&m);
    while (!ready)
        cond_wait(&c, &m);
    printf(1, "thread %d running\n", id);
    mutex_unlock(&m);
    return 0;
}

int
main(void)
{
    thread_init();
    mutex_init(&m);
    cond_init(&c);

    int t1 = thread_create(worker, (void *)1);
    int t2 = thread_create(worker, (void *)2);
    int t3 = thread_create(worker, (void *)3);

    thread_yield();

    mutex_lock(&m);
    ready = 1;
    cond_broadcast(&c); //check point
    // cond_signal(&c);
    mutex_unlock(&m);

    thread_join(t1);
    thread_join(t2);
    thread_join(t3);

    printf(1, "condition variable test done\n");
    exit();
}
