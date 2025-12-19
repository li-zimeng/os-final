#include "types.h"
#include "user.h"
#include "uthreads.h"

#define READERS 3
#define WRITERS 2

int value = 0;

rwlock_t lock;

void *
reader(void *arg)
{
    int id = (int)arg;
    for (int i = 0; i < 5; i++) {
        reader_lock(&lock);

        printf(1, "Reader %d: reading value = %d\n", id, value);

        reader_unlock(&lock);
        thread_yield();
    }
    return 0;
}

void *
writer(void *arg)
{
    int id = (int)arg;
    for (int i = 0; i < 3; i++) {
        writer_lock(&lock);
        value++;
        printf(1, "Writer %d: wrote new value = %d\n", id, value);
        writer_unlock(&lock);

        thread_yield();
    }
    return 0;
}

int
main(void)
{
    thread_init();
    rwlock_init(&lock);

    int r[READERS], w[WRITERS];

    for (int i = 0; i < READERS; i++)
        r[i] = thread_create(reader, (void *)i);

    for (int i = 0; i < WRITERS; i++)
        w[i] = thread_create(writer, (void *)i);

    for (int i = 0; i < READERS; i++)
        thread_join(r[i]);

    for (int i = 0; i < WRITERS; i++)
        thread_join(w[i]);

    printf(1, "Reader-writer test done\n");
    exit();
}
