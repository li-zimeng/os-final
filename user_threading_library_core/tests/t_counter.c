#include "types.h"
#include "user.h"
#include "uthreads.h"

#define N 1000
#define T 3

int counter = 0;
mutex_t m;

void *
worker(void *arg)
{
    for (int i = 0; i < N; i++) {
        // mutex_lock(&m);
        int tmp = counter;
        thread_yield();
        counter = tmp + 1;
        // mutex_unlock(&m);
    }
    return 0;
}

int
main(void)
{
    thread_init();
    mutex_init(&m);

    int tids[T];
    for (int i = 0; i < T; i++)
        tids[i] = thread_create(worker, 0);

    for (int i = 0; i < T; i++)
        thread_join(tids[i]);

    printf(1, "counter = %d (expected %d)\n", counter, T * N);
    exit();
}
