#include "types.h"
#include "user.h"
#include "uthreads.h"

#define PRODUCERS 3
#define CONSUMERS 2
#define ITEMS_PER_PROD 10

channel_t *ch;

void *
producer(void *arg)
{
    int id = (int)arg;
    for (int i = 0; i < ITEMS_PER_PROD; i++) {
        channel_send(ch, (void *)i);
        printf(1, "Producer %d: sent %d\n", id, i);
        thread_yield();
    }
    return 0;
}

void *
consumer(void *arg)
{
    int id = (int)arg;
    void *data;

    while (channel_recv(ch, &data) == 0) {
        printf(1, "Consumer %d: received %d\n", id, (int)data);
        thread_yield();
    }

    return 0;
}

int
main(void)
{
    thread_init();
    ch = channel_create(5);

    int p[PRODUCERS];
    int c[CONSUMERS];

    for (int i = 0; i < PRODUCERS; i++)
        p[i] = thread_create(producer, (void *)i);

    for (int i = 0; i < CONSUMERS; i++)
        c[i] = thread_create(consumer, (void *)i);

    for (int i = 0; i < PRODUCERS; i++)
        thread_join(p[i]);

    printf(1, "All producers finished. Closing channel.\n");
    channel_close(ch);

    for (int i = 0; i < CONSUMERS; i++)
        thread_join(c[i]);

    printf(1, "All consumers exited.\n");
    exit();
}
