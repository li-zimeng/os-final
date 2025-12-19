#include "types.h"
#include "uthreads.h"

void
rwlock_init(rwlock_t *l)
{
    mutex_init(&l->m);
    cond_init(&l->can_read);
    cond_init(&l->can_write);
    l->readers = 0;
    l->writers_wait = 0;
    l->writer_active = 0;
}

// void
// reader_lock(rwlock_t *l)
// {
//     mutex_lock(&l->m);
//     while (l->writer_active || l->writers_wait > 0)
//         cond_wait(&l->can_read, &l->m);
//     l->readers++;
//     mutex_unlock(&l->m);
// }

void
reader_lock(rwlock_t *l)
{
    mutex_lock(&l->m);
    while (l->writer_active)
        cond_wait(&l->can_read, &l->m);
    l->readers++;
    mutex_unlock(&l->m);
}


void
reader_unlock(rwlock_t *l)
{
    mutex_lock(&l->m);
    l->readers--;
    if (l->readers == 0 && l->writers_wait > 0)
        cond_signal(&l->can_write);
    mutex_unlock(&l->m);
}

void
writer_lock(rwlock_t *l)
{
    mutex_lock(&l->m);
    l->writers_wait++;
    while (l->writer_active || l->readers > 0)
        cond_wait(&l->can_write, &l->m);
    l->writers_wait--;
    l->writer_active = 1;
    mutex_unlock(&l->m);
}

void
writer_unlock(rwlock_t *l)
{
    mutex_lock(&l->m);
    l->writer_active = 0;
    if (l->writers_wait > 0)
        cond_signal(&l->can_write);
    else
        cond_broadcast(&l->can_read);
    mutex_unlock(&l->m);
}


