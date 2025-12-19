#include "types.h"
#include "user.h"
#include "uthreads.h"

void *
f1(void *arg)
{
    for (int i = 0; i < 5; i++) {
        printf(1, "thread 1 %d\n", i);
        thread_yield();
    }
    return (void *)1;
}

void *
f2(void *arg)
{
    for (int i = 0; i < 5; i++) {
        printf(1, "thread 2 %d\n", i);
        thread_yield();
    }
    return (void *)2;
}

int
main(void)
{
    thread_init();

    int t1 = thread_create(f1, 0);
    int t2 = thread_create(f2, 0);

    void *r1 = thread_join(t1);
    void *r2 = thread_join(t2);

    printf(1, "joined %d %d\n", (int)r1, (int)r2);
    exit();
}
