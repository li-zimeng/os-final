#include "types.h"
#include "user.h"
#include "uthreads.h"

extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

channel_t *
channel_create(int capacity)
{
    channel_t *ch = malloc(sizeof(channel_t));
    if (!ch)
        return 0;

    ch->buffer = malloc(sizeof(void *) * capacity);
    if (!ch->buffer) {
        free(ch);
        return 0;
    }

    ch->capacity = capacity;
    ch->count = 0;
    ch->head = 0;
    ch->tail = 0;
    ch->closed = 0;

    mutex_init(&ch->lock);
    cond_init(&ch->not_empty);
    cond_init(&ch->not_full);

    return ch;
}

int
channel_send(channel_t *ch, void *data)
{
    mutex_lock(&ch->lock);

    while (ch->count == ch->capacity && !ch->closed)
        cond_wait(&ch->not_full, &ch->lock);

    if (ch->closed) {
        mutex_unlock(&ch->lock);
        return -1;
    }

    ch->buffer[ch->tail] = data;
    ch->tail = (ch->tail + 1) % ch->capacity;
    ch->count++;

    cond_signal(&ch->not_empty);
    mutex_unlock(&ch->lock);
    return 0;
}

int
channel_recv(channel_t *ch, void **data)
{
    mutex_lock(&ch->lock);

    while (ch->count == 0 && !ch->closed)
        cond_wait(&ch->not_empty, &ch->lock);

    if (ch->count == 0 && ch->closed) {
        mutex_unlock(&ch->lock);
        return -1;
    }

    *data = ch->buffer[ch->head];
    ch->head = (ch->head + 1) % ch->capacity;
    ch->count--;

    cond_signal(&ch->not_full);
    mutex_unlock(&ch->lock);
    return 0;
}

void
channel_close(channel_t *ch)
{
    mutex_lock(&ch->lock);
    ch->closed = 1;
    cond_broadcast(&ch->not_empty);
    cond_broadcast(&ch->not_full);
    mutex_unlock(&ch->lock);
}
