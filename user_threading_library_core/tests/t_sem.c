#include "types.h"
#include "user.h"
#include "uthreads.h"

sem_t s;

void *
worker(void *arg)
{
    int id = (int)arg;
    sem_wait(&s);
    printf(1, "thread %d in\n", id);
    thread_yield();
    printf(1, "thread %d out\n", id);
    sem_post(&s);
    return 0;
}

int
main(void)
{
    thread_init();
    sem_init(&s, 1);

    int t1 = thread_create(worker, (void *)1);
    int t2 = thread_create(worker, (void *)2);
    int t3 = thread_create(worker, (void *)3);

    thread_join(t1);
    thread_join(t2);
    thread_join(t3);

    printf(1, "semaphore test done\n");
    exit();
}
