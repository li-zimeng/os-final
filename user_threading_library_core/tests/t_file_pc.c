#include "types.h"
#include "user.h"

#define TOTAL_ITEMS 20

int
main(void)
{
    int p[2];
    pipe(p);

    int pid = fork();

    if (pid < 0) {
        printf(1, "fork failed\n");
        exit();
    }

    if (pid == 0) {
        close(p[1]);

        int received = 0;
        char c;

        while (received < TOTAL_ITEMS) {
            if (read(p[0], &c, 1) <= 0)
                break;

            if (c == '\n') {
                printf(1, "\n");
                received++;
            } else {
                printf(1, "%c", c);
            }
        }

        printf(1, "Consumer: done\n");
        exit();
    } else {
        close(p[0]);

        for (int i = 0; i < TOTAL_ITEMS; i++) {
            printf(p[1], "item %d\n", i);
            printf(1, "Producer: wrote item %d\n", i);
        }

        printf(1, "Producer: done\n");
        wait();
        exit();
    }
}
