#include "types.h"
#include "user.h"
#include "uthreads.h"

#define N 1000

int counter = 0;
mutex_t m;

void *
worker(void *arg)
{
    for (int i = 0; i < N; i++) {
        mutex_lock(&m); //1/2 lock
        int tmp = counter;
        thread_yield();
        counter = tmp + 1;
        mutex_unlock(&m); //2/2 unlock
    }
    return 0;
}

int
main(void)
{
    thread_init();
    mutex_init(&m);

    int t1 = thread_create(worker, 0);
    int t2 = thread_create(worker, 0);

    thread_join(t1);
    thread_join(t2);

    printf(1, "counter = %d\n", counter);
    exit();
}
