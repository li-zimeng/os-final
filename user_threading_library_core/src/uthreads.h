#ifndef UTHREADS_H
#define UTHREADS_H

#define MAX_THREADS 16
#define STACK_SIZE 4096

enum thread_state {
    T_UNUSED,
    T_RUNNABLE,
    T_RUNNING,
    T_SLEEPING,
    T_ZOMBIE
};

struct thread {
    int tid;
    enum thread_state state;
    void *stack;
    void *sp;
    void *(*start_routine)(void *);
    void *arg;
    void *retval;
    int waiting_tid;
};

typedef struct {
    int locked;
    int owner;
    int wait_queue[MAX_THREADS];
    int wait_count;
} mutex_t;

typedef struct {
    int count;
    int wait_queue[MAX_THREADS];
    int wait_count;
} sem_t;

typedef struct {
    int wait_queue[MAX_THREADS];
    int wait_count;
} cond_t;

typedef struct {
    void **buf;
    int capacity;
    int count;
    int read_pos;
    int write_pos;
    int closed;
    mutex_t lock;
    cond_t not_empty;
    cond_t not_full;
} channel_t;

typedef struct {
    mutex_t m;
    cond_t can_read;
    cond_t can_write;
    int readers;
    int writers_wait;
    int writer_active;
} rwlock_t;

void thread_init(void);
int thread_create(void *(*start_routine)(void *), void *arg);
void thread_yield(void);
void thread_exit(void *retval);
void *thread_join(int tid);
int thread_self(void);
void thread_schedule(void);
void thread_switch(struct thread *old, struct thread *new);

void mutex_init(mutex_t *m);
void mutex_lock(mutex_t *m);
void mutex_unlock(mutex_t *m);

void sem_init(sem_t *s, int value);
void sem_wait(sem_t *s);
void sem_post(sem_t *s);

void cond_init(cond_t *c);
void cond_wait(cond_t *c, mutex_t *m);
void cond_signal(cond_t *c);
void cond_broadcast(cond_t *c);

channel_t *channel_create(int capacity);
int channel_send(channel_t *ch, void *data);
int channel_recv(channel_t *ch, void **data);
void channel_close(channel_t *ch);

void rwlock_init(rwlock_t *l);
void reader_lock(rwlock_t *l);
void reader_unlock(rwlock_t *l);
void writer_lock(rwlock_t *l);
void writer_unlock(rwlock_t *l);

#endif
