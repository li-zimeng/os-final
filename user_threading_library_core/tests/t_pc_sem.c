#include "types.h"
#include "user.h"
#include "uthreads.h"

#define PRODUCERS 3
#define CONSUMERS 2
#define ITEMS_PER_PROD 10
#define TOTAL_ITEMS (PRODUCERS * ITEMS_PER_PROD)
#define BUF_SIZE 5
#define POISON -1

int buffer[BUF_SIZE];
int in = 0;
int out = 0;

mutex_t buf_mutex;
sem_t empty;
sem_t full;

void *
producer(void *arg)
{
    int id = (int)arg;

    for (int i = 0; i < ITEMS_PER_PROD; i++) {
        sem_wait(&empty);
        mutex_lock(&buf_mutex);

        buffer[in] = i;
        in = (in + 1) % BUF_SIZE;
        printf(1, "Producer %d: produced %d\n", id, i);

        mutex_unlock(&buf_mutex);
        sem_post(&full);

        thread_yield();
    }

    return 0;
}

void *
consumer(void *arg)
{
    int id = (int)arg;

    while (1) {
        sem_wait(&full);
        mutex_lock(&buf_mutex);

        int item = buffer[out];
        out = (out + 1) % BUF_SIZE;

        mutex_unlock(&buf_mutex);
        sem_post(&empty);

        if (item == POISON)
            break;

        printf(1, "Consumer %d: consumed %d\n", id, item);
        thread_yield();
    }

    return 0;
}

int
main(void)
{
    thread_init();

    mutex_init(&buf_mutex);
    sem_init(&empty, BUF_SIZE);
    sem_init(&full, 0);

    int p[PRODUCERS];
    int c[CONSUMERS];

    for (int i = 0; i < PRODUCERS; i++)
        p[i] = thread_create(producer, (void *)i);

    for (int i = 0; i < CONSUMERS; i++)
        c[i] = thread_create(consumer, (void *)i);

    for (int i = 0; i < PRODUCERS; i++)
        thread_join(p[i]);

    for (int i = 0; i < CONSUMERS; i++) {
        sem_wait(&empty);
        mutex_lock(&buf_mutex);

        buffer[in] = POISON;
        in = (in + 1) % BUF_SIZE;

        mutex_unlock(&buf_mutex);
        sem_post(&full);
    }

    for (int i = 0; i < CONSUMERS; i++)
        thread_join(c[i]);

    printf(1, "All items processed. Consumers exiting.\n");
    exit();
}
