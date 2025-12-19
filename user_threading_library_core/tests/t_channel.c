#include "types.h"
#include "user.h"
#include "uthreads.h"

#define CAP 2
#define PRODUCERS 3
#define SENDS 40

channel_t *ch;
int recv_count = 0;

void *
producer(void *arg)
{
    int id = (int)arg;
    for (int i = 0; i < SENDS; i++) {
        channel_send(ch, (void *)i);
        printf(1, "[P%d] send %d\n", id, i);
        thread_yield();
    }
    return 0;
}

void *
consumer(void *arg)
{
    void *data;
    while (1) {
        if (channel_recv(ch, &data) < 0)
            break;
        recv_count++;
        printf(1, "[C] recv %d (total=%d)\n", (int)data, recv_count);
        thread_yield();
    }
    return 0;
}

int
main(void)
{
    thread_init();
    ch = channel_create(CAP);

    int p[PRODUCERS];
    for (int i = 0; i < PRODUCERS; i++)
        p[i] = thread_create(producer, (void *)i);

    int c = thread_create(consumer, 0);

    for (int i = 0; i < PRODUCERS; i++)
        thread_join(p[i]);

    printf(1, "[main] all producers done, closing channel\n");
    channel_close(ch);

    thread_join(c);

    printf(1, "PASS channel correct recv=%d\n", recv_count);
    exit();
}