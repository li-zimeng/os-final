
_t_pc_sem:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	push   -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	57                   	push   %edi
       e:	56                   	push   %esi
       f:	53                   	push   %ebx
      10:	51                   	push   %ecx
      11:	83 ec 28             	sub    $0x28,%esp
    thread_init();
      14:	e8 17 09 00 00       	call   930 <thread_init>

    mutex_init(&buf_mutex);
      19:	83 ec 0c             	sub    $0xc,%esp
      1c:	68 a0 1c 00 00       	push   $0x1ca0
      21:	e8 3a 0e 00 00       	call   e60 <mutex_init>
    sem_init(&empty, BUF_SIZE);
      26:	58                   	pop    %eax
      27:	5a                   	pop    %edx
      28:	6a 05                	push   $0x5
      2a:	68 40 1c 00 00       	push   $0x1c40
      2f:	e8 2c 0c 00 00       	call   c60 <sem_init>
    sem_init(&full, 0);
      34:	59                   	pop    %ecx
      35:	5b                   	pop    %ebx
      36:	6a 00                	push   $0x0
      38:	68 e0 1b 00 00       	push   $0x1be0

    int p[PRODUCERS];
    int c[CONSUMERS];

    for (int i = 0; i < PRODUCERS; i++)
      3d:	31 db                	xor    %ebx,%ebx
    sem_init(&full, 0);
      3f:	e8 1c 0c 00 00       	call   c60 <sem_init>
      44:	83 c4 10             	add    $0x10,%esp
        p[i] = thread_create(producer, (void *)i);
      47:	83 ec 08             	sub    $0x8,%esp
      4a:	53                   	push   %ebx
      4b:	68 50 01 00 00       	push   $0x150
      50:	e8 6b 09 00 00       	call   9c0 <thread_create>
    for (int i = 0; i < PRODUCERS; i++)
      55:	83 c4 10             	add    $0x10,%esp
        p[i] = thread_create(producer, (void *)i);
      58:	89 44 9d dc          	mov    %eax,-0x24(%ebp,%ebx,4)
    for (int i = 0; i < PRODUCERS; i++)
      5c:	83 c3 01             	add    $0x1,%ebx
      5f:	83 fb 03             	cmp    $0x3,%ebx
      62:	75 e3                	jne    47 <main+0x47>

    for (int i = 0; i < CONSUMERS; i++)
        c[i] = thread_create(consumer, (void *)i);
      64:	83 ec 08             	sub    $0x8,%esp
      67:	6a 00                	push   $0x0
      69:	68 f0 01 00 00       	push   $0x1f0
      6e:	e8 4d 09 00 00       	call   9c0 <thread_create>
      73:	5b                   	pop    %ebx
      74:	5f                   	pop    %edi
      75:	6a 01                	push   $0x1
      77:	68 f0 01 00 00       	push   $0x1f0
      7c:	89 c6                	mov    %eax,%esi

    for (int i = 0; i < PRODUCERS; i++)
        thread_join(p[i]);
      7e:	bb 02 00 00 00       	mov    $0x2,%ebx
    for (int i = 0; i < CONSUMERS; i++) {
        sem_wait(&empty);
        mutex_lock(&buf_mutex);

        buffer[in] = POISON;
        in = (in + 1) % BUF_SIZE;
      83:	bf 67 66 66 66       	mov    $0x66666667,%edi
        c[i] = thread_create(consumer, (void *)i);
      88:	e8 33 09 00 00       	call   9c0 <thread_create>
      8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        thread_join(p[i]);
      90:	58                   	pop    %eax
      91:	ff 75 dc             	push   -0x24(%ebp)
      94:	e8 17 0b 00 00       	call   bb0 <thread_join>
      99:	58                   	pop    %eax
      9a:	ff 75 e0             	push   -0x20(%ebp)
      9d:	e8 0e 0b 00 00       	call   bb0 <thread_join>
      a2:	58                   	pop    %eax
      a3:	ff 75 e4             	push   -0x1c(%ebp)
      a6:	e8 05 0b 00 00       	call   bb0 <thread_join>
      ab:	83 c4 10             	add    $0x10,%esp
        sem_wait(&empty);
      ae:	83 ec 0c             	sub    $0xc,%esp
      b1:	68 40 1c 00 00       	push   $0x1c40
      b6:	e8 c5 0b 00 00       	call   c80 <sem_wait>
        mutex_lock(&buf_mutex);
      bb:	c7 04 24 a0 1c 00 00 	movl   $0x1ca0,(%esp)
      c2:	e8 b9 0d 00 00       	call   e80 <mutex_lock>
        buffer[in] = POISON;
      c7:	8b 0d f0 1c 00 00    	mov    0x1cf0,%ecx

        mutex_unlock(&buf_mutex);
      cd:	c7 04 24 a0 1c 00 00 	movl   $0x1ca0,(%esp)
        buffer[in] = POISON;
      d4:	c7 04 8d f4 1c 00 00 	movl   $0xffffffff,0x1cf4(,%ecx,4)
      db:	ff ff ff ff 
        in = (in + 1) % BUF_SIZE;
      df:	83 c1 01             	add    $0x1,%ecx
      e2:	89 c8                	mov    %ecx,%eax
      e4:	f7 ef                	imul   %edi
      e6:	89 c8                	mov    %ecx,%eax
      e8:	c1 f8 1f             	sar    $0x1f,%eax
      eb:	d1 fa                	sar    $1,%edx
      ed:	29 c2                	sub    %eax,%edx
      ef:	8d 04 92             	lea    (%edx,%edx,4),%eax
      f2:	29 c1                	sub    %eax,%ecx
      f4:	89 0d f0 1c 00 00    	mov    %ecx,0x1cf0
        mutex_unlock(&buf_mutex);
      fa:	e8 f1 0d 00 00       	call   ef0 <mutex_unlock>
        sem_post(&full);
      ff:	c7 04 24 e0 1b 00 00 	movl   $0x1be0,(%esp)
     106:	e8 b5 0b 00 00       	call   cc0 <sem_post>
    for (int i = 0; i < CONSUMERS; i++) {
     10b:	83 c4 10             	add    $0x10,%esp
     10e:	83 fb 01             	cmp    $0x1,%ebx
     111:	74 0d                	je     120 <main+0x120>
     113:	bb 01 00 00 00       	mov    $0x1,%ebx
     118:	eb 94                	jmp    ae <main+0xae>
     11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }

    for (int i = 0; i < CONSUMERS; i++)
        thread_join(c[i]);
     120:	83 ec 0c             	sub    $0xc,%esp
     123:	56                   	push   %esi
     124:	e8 87 0a 00 00       	call   bb0 <thread_join>
     129:	58                   	pop    %eax
     12a:	ff 75 d4             	push   -0x2c(%ebp)
     12d:	e8 7e 0a 00 00       	call   bb0 <thread_join>

    printf(1, "All items processed. Consumers exiting.\n");
     132:	5a                   	pop    %edx
     133:	59                   	pop    %ecx
     134:	68 00 14 00 00       	push   $0x1400
     139:	6a 01                	push   $0x1
     13b:	e8 e0 04 00 00       	call   620 <printf>
    exit();
     140:	e8 8e 03 00 00       	call   4d3 <exit>
     145:	66 90                	xchg   %ax,%ax
     147:	66 90                	xchg   %ax,%ax
     149:	66 90                	xchg   %ax,%ax
     14b:	66 90                	xchg   %ax,%ax
     14d:	66 90                	xchg   %ax,%ax
     14f:	90                   	nop

00000150 <producer>:
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	57                   	push   %edi
    for (int i = 0; i < ITEMS_PER_PROD; i++) {
     154:	31 ff                	xor    %edi,%edi
{
     156:	56                   	push   %esi
     157:	53                   	push   %ebx
        in = (in + 1) % BUF_SIZE;
     158:	bb 67 66 66 66       	mov    $0x66666667,%ebx
{
     15d:	83 ec 0c             	sub    $0xc,%esp
     160:	8b 75 08             	mov    0x8(%ebp),%esi
    for (int i = 0; i < ITEMS_PER_PROD; i++) {
     163:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        sem_wait(&empty);
     168:	83 ec 0c             	sub    $0xc,%esp
     16b:	68 40 1c 00 00       	push   $0x1c40
     170:	e8 0b 0b 00 00       	call   c80 <sem_wait>
        mutex_lock(&buf_mutex);
     175:	c7 04 24 a0 1c 00 00 	movl   $0x1ca0,(%esp)
     17c:	e8 ff 0c 00 00       	call   e80 <mutex_lock>
        buffer[in] = i;
     181:	8b 0d f0 1c 00 00    	mov    0x1cf0,%ecx
     187:	89 3c 8d f4 1c 00 00 	mov    %edi,0x1cf4(,%ecx,4)
        in = (in + 1) % BUF_SIZE;
     18e:	83 c1 01             	add    $0x1,%ecx
     191:	89 c8                	mov    %ecx,%eax
     193:	f7 eb                	imul   %ebx
     195:	89 c8                	mov    %ecx,%eax
     197:	c1 f8 1f             	sar    $0x1f,%eax
     19a:	d1 fa                	sar    $1,%edx
     19c:	29 c2                	sub    %eax,%edx
     19e:	8d 04 92             	lea    (%edx,%edx,4),%eax
     1a1:	29 c1                	sub    %eax,%ecx
     1a3:	89 0d f0 1c 00 00    	mov    %ecx,0x1cf0
        printf(1, "Producer %d: produced %d\n", id, i);
     1a9:	57                   	push   %edi
    for (int i = 0; i < ITEMS_PER_PROD; i++) {
     1aa:	83 c7 01             	add    $0x1,%edi
        printf(1, "Producer %d: produced %d\n", id, i);
     1ad:	56                   	push   %esi
     1ae:	68 c4 13 00 00       	push   $0x13c4
     1b3:	6a 01                	push   $0x1
     1b5:	e8 66 04 00 00       	call   620 <printf>
        mutex_unlock(&buf_mutex);
     1ba:	83 c4 14             	add    $0x14,%esp
     1bd:	68 a0 1c 00 00       	push   $0x1ca0
     1c2:	e8 29 0d 00 00       	call   ef0 <mutex_unlock>
        sem_post(&full);
     1c7:	c7 04 24 e0 1b 00 00 	movl   $0x1be0,(%esp)
     1ce:	e8 ed 0a 00 00       	call   cc0 <sem_post>
        thread_yield();
     1d3:	e8 58 09 00 00       	call   b30 <thread_yield>
    for (int i = 0; i < ITEMS_PER_PROD; i++) {
     1d8:	83 c4 10             	add    $0x10,%esp
     1db:	83 ff 0a             	cmp    $0xa,%edi
     1de:	75 88                	jne    168 <producer+0x18>
}
     1e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     1e3:	31 c0                	xor    %eax,%eax
     1e5:	5b                   	pop    %ebx
     1e6:	5e                   	pop    %esi
     1e7:	5f                   	pop    %edi
     1e8:	5d                   	pop    %ebp
     1e9:	c3                   	ret
     1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <consumer>:
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	57                   	push   %edi
     1f4:	56                   	push   %esi
     1f5:	53                   	push   %ebx
        out = (out + 1) % BUF_SIZE;
     1f6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
{
     1fb:	83 ec 0c             	sub    $0xc,%esp
     1fe:	8b 75 08             	mov    0x8(%ebp),%esi
     201:	eb 1b                	jmp    21e <consumer+0x2e>
     203:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printf(1, "Consumer %d: consumed %d\n", id, item);
     208:	57                   	push   %edi
     209:	56                   	push   %esi
     20a:	68 de 13 00 00       	push   $0x13de
     20f:	6a 01                	push   $0x1
     211:	e8 0a 04 00 00       	call   620 <printf>
        thread_yield();
     216:	e8 15 09 00 00       	call   b30 <thread_yield>
    while (1) {
     21b:	83 c4 10             	add    $0x10,%esp
        sem_wait(&full);
     21e:	83 ec 0c             	sub    $0xc,%esp
     221:	68 e0 1b 00 00       	push   $0x1be0
     226:	e8 55 0a 00 00       	call   c80 <sem_wait>
        mutex_lock(&buf_mutex);
     22b:	c7 04 24 a0 1c 00 00 	movl   $0x1ca0,(%esp)
     232:	e8 49 0c 00 00       	call   e80 <mutex_lock>
        int item = buffer[out];
     237:	8b 0d ec 1c 00 00    	mov    0x1cec,%ecx
     23d:	8b 3c 8d f4 1c 00 00 	mov    0x1cf4(,%ecx,4),%edi
        out = (out + 1) % BUF_SIZE;
     244:	83 c1 01             	add    $0x1,%ecx
     247:	89 c8                	mov    %ecx,%eax
     249:	f7 eb                	imul   %ebx
     24b:	89 c8                	mov    %ecx,%eax
     24d:	c1 f8 1f             	sar    $0x1f,%eax
     250:	d1 fa                	sar    $1,%edx
     252:	29 c2                	sub    %eax,%edx
     254:	8d 04 92             	lea    (%edx,%edx,4),%eax
     257:	29 c1                	sub    %eax,%ecx
     259:	89 0d ec 1c 00 00    	mov    %ecx,0x1cec
        mutex_unlock(&buf_mutex);
     25f:	c7 04 24 a0 1c 00 00 	movl   $0x1ca0,(%esp)
     266:	e8 85 0c 00 00       	call   ef0 <mutex_unlock>
        sem_post(&empty);
     26b:	c7 04 24 40 1c 00 00 	movl   $0x1c40,(%esp)
     272:	e8 49 0a 00 00       	call   cc0 <sem_post>
        if (item == POISON)
     277:	83 c4 10             	add    $0x10,%esp
     27a:	83 ff ff             	cmp    $0xffffffff,%edi
     27d:	75 89                	jne    208 <consumer+0x18>
}
     27f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     282:	31 c0                	xor    %eax,%eax
     284:	5b                   	pop    %ebx
     285:	5e                   	pop    %esi
     286:	5f                   	pop    %edi
     287:	5d                   	pop    %ebp
     288:	c3                   	ret
     289:	66 90                	xchg   %ax,%ax
     28b:	66 90                	xchg   %ax,%ax
     28d:	66 90                	xchg   %ax,%ax
     28f:	90                   	nop

00000290 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     290:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     291:	31 c0                	xor    %eax,%eax
{
     293:	89 e5                	mov    %esp,%ebp
     295:	53                   	push   %ebx
     296:	8b 4d 08             	mov    0x8(%ebp),%ecx
     299:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     2a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     2a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     2a7:	83 c0 01             	add    $0x1,%eax
     2aa:	84 d2                	test   %dl,%dl
     2ac:	75 f2                	jne    2a0 <strcpy+0x10>
    ;
  return os;
}
     2ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2b1:	89 c8                	mov    %ecx,%eax
     2b3:	c9                   	leave
     2b4:	c3                   	ret
     2b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     2bc:	00 
     2bd:	8d 76 00             	lea    0x0(%esi),%esi

000002c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     2c0:	55                   	push   %ebp
     2c1:	89 e5                	mov    %esp,%ebp
     2c3:	53                   	push   %ebx
     2c4:	8b 55 08             	mov    0x8(%ebp),%edx
     2c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     2ca:	0f b6 02             	movzbl (%edx),%eax
     2cd:	84 c0                	test   %al,%al
     2cf:	75 17                	jne    2e8 <strcmp+0x28>
     2d1:	eb 3a                	jmp    30d <strcmp+0x4d>
     2d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     2d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     2dc:	83 c2 01             	add    $0x1,%edx
     2df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     2e2:	84 c0                	test   %al,%al
     2e4:	74 1a                	je     300 <strcmp+0x40>
     2e6:	89 d9                	mov    %ebx,%ecx
     2e8:	0f b6 19             	movzbl (%ecx),%ebx
     2eb:	38 c3                	cmp    %al,%bl
     2ed:	74 e9                	je     2d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     2ef:	29 d8                	sub    %ebx,%eax
}
     2f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2f4:	c9                   	leave
     2f5:	c3                   	ret
     2f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     2fd:	00 
     2fe:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     300:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     304:	31 c0                	xor    %eax,%eax
     306:	29 d8                	sub    %ebx,%eax
}
     308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     30b:	c9                   	leave
     30c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     30d:	0f b6 19             	movzbl (%ecx),%ebx
     310:	31 c0                	xor    %eax,%eax
     312:	eb db                	jmp    2ef <strcmp+0x2f>
     314:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     31b:	00 
     31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000320 <strlen>:

uint
strlen(const char *s)
{
     320:	55                   	push   %ebp
     321:	89 e5                	mov    %esp,%ebp
     323:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     326:	80 3a 00             	cmpb   $0x0,(%edx)
     329:	74 15                	je     340 <strlen+0x20>
     32b:	31 c0                	xor    %eax,%eax
     32d:	8d 76 00             	lea    0x0(%esi),%esi
     330:	83 c0 01             	add    $0x1,%eax
     333:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     337:	89 c1                	mov    %eax,%ecx
     339:	75 f5                	jne    330 <strlen+0x10>
    ;
  return n;
}
     33b:	89 c8                	mov    %ecx,%eax
     33d:	5d                   	pop    %ebp
     33e:	c3                   	ret
     33f:	90                   	nop
  for(n = 0; s[n]; n++)
     340:	31 c9                	xor    %ecx,%ecx
}
     342:	5d                   	pop    %ebp
     343:	89 c8                	mov    %ecx,%eax
     345:	c3                   	ret
     346:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     34d:	00 
     34e:	66 90                	xchg   %ax,%ax

00000350 <memset>:

void*
memset(void *dst, int c, uint n)
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	57                   	push   %edi
     354:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     357:	8b 4d 10             	mov    0x10(%ebp),%ecx
     35a:	8b 45 0c             	mov    0xc(%ebp),%eax
     35d:	89 d7                	mov    %edx,%edi
     35f:	fc                   	cld
     360:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     362:	8b 7d fc             	mov    -0x4(%ebp),%edi
     365:	89 d0                	mov    %edx,%eax
     367:	c9                   	leave
     368:	c3                   	ret
     369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000370 <strchr>:

char*
strchr(const char *s, char c)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	8b 45 08             	mov    0x8(%ebp),%eax
     376:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     37a:	0f b6 10             	movzbl (%eax),%edx
     37d:	84 d2                	test   %dl,%dl
     37f:	75 12                	jne    393 <strchr+0x23>
     381:	eb 1d                	jmp    3a0 <strchr+0x30>
     383:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     388:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     38c:	83 c0 01             	add    $0x1,%eax
     38f:	84 d2                	test   %dl,%dl
     391:	74 0d                	je     3a0 <strchr+0x30>
    if(*s == c)
     393:	38 d1                	cmp    %dl,%cl
     395:	75 f1                	jne    388 <strchr+0x18>
      return (char*)s;
  return 0;
}
     397:	5d                   	pop    %ebp
     398:	c3                   	ret
     399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     3a0:	31 c0                	xor    %eax,%eax
}
     3a2:	5d                   	pop    %ebp
     3a3:	c3                   	ret
     3a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3ab:	00 
     3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <gets>:

char*
gets(char *buf, int max)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	57                   	push   %edi
     3b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     3b5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
     3b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     3b9:	31 db                	xor    %ebx,%ebx
{
     3bb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     3be:	eb 27                	jmp    3e7 <gets+0x37>
    cc = read(0, &c, 1);
     3c0:	83 ec 04             	sub    $0x4,%esp
     3c3:	6a 01                	push   $0x1
     3c5:	56                   	push   %esi
     3c6:	6a 00                	push   $0x0
     3c8:	e8 1e 01 00 00       	call   4eb <read>
    if(cc < 1)
     3cd:	83 c4 10             	add    $0x10,%esp
     3d0:	85 c0                	test   %eax,%eax
     3d2:	7e 1d                	jle    3f1 <gets+0x41>
      break;
    buf[i++] = c;
     3d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     3d8:	8b 55 08             	mov    0x8(%ebp),%edx
     3db:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     3df:	3c 0a                	cmp    $0xa,%al
     3e1:	74 10                	je     3f3 <gets+0x43>
     3e3:	3c 0d                	cmp    $0xd,%al
     3e5:	74 0c                	je     3f3 <gets+0x43>
  for(i=0; i+1 < max; ){
     3e7:	89 df                	mov    %ebx,%edi
     3e9:	83 c3 01             	add    $0x1,%ebx
     3ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     3ef:	7c cf                	jl     3c0 <gets+0x10>
     3f1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
     3f3:	8b 45 08             	mov    0x8(%ebp),%eax
     3f6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
     3fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3fd:	5b                   	pop    %ebx
     3fe:	5e                   	pop    %esi
     3ff:	5f                   	pop    %edi
     400:	5d                   	pop    %ebp
     401:	c3                   	ret
     402:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     409:	00 
     40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000410 <stat>:

int
stat(const char *n, struct stat *st)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	56                   	push   %esi
     414:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     415:	83 ec 08             	sub    $0x8,%esp
     418:	6a 00                	push   $0x0
     41a:	ff 75 08             	push   0x8(%ebp)
     41d:	e8 f1 00 00 00       	call   513 <open>
  if(fd < 0)
     422:	83 c4 10             	add    $0x10,%esp
     425:	85 c0                	test   %eax,%eax
     427:	78 27                	js     450 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     429:	83 ec 08             	sub    $0x8,%esp
     42c:	ff 75 0c             	push   0xc(%ebp)
     42f:	89 c3                	mov    %eax,%ebx
     431:	50                   	push   %eax
     432:	e8 f4 00 00 00       	call   52b <fstat>
  close(fd);
     437:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     43a:	89 c6                	mov    %eax,%esi
  close(fd);
     43c:	e8 ba 00 00 00       	call   4fb <close>
  return r;
     441:	83 c4 10             	add    $0x10,%esp
}
     444:	8d 65 f8             	lea    -0x8(%ebp),%esp
     447:	89 f0                	mov    %esi,%eax
     449:	5b                   	pop    %ebx
     44a:	5e                   	pop    %esi
     44b:	5d                   	pop    %ebp
     44c:	c3                   	ret
     44d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     450:	be ff ff ff ff       	mov    $0xffffffff,%esi
     455:	eb ed                	jmp    444 <stat+0x34>
     457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     45e:	00 
     45f:	90                   	nop

00000460 <atoi>:

int
atoi(const char *s)
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	53                   	push   %ebx
     464:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     467:	0f be 02             	movsbl (%edx),%eax
     46a:	8d 48 d0             	lea    -0x30(%eax),%ecx
     46d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     470:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     475:	77 1e                	ja     495 <atoi+0x35>
     477:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     47e:	00 
     47f:	90                   	nop
    n = n*10 + *s++ - '0';
     480:	83 c2 01             	add    $0x1,%edx
     483:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     486:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     48a:	0f be 02             	movsbl (%edx),%eax
     48d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     490:	80 fb 09             	cmp    $0x9,%bl
     493:	76 eb                	jbe    480 <atoi+0x20>
  return n;
}
     495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     498:	89 c8                	mov    %ecx,%eax
     49a:	c9                   	leave
     49b:	c3                   	ret
     49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     4a0:	55                   	push   %ebp
     4a1:	89 e5                	mov    %esp,%ebp
     4a3:	57                   	push   %edi
     4a4:	8b 45 10             	mov    0x10(%ebp),%eax
     4a7:	8b 55 08             	mov    0x8(%ebp),%edx
     4aa:	56                   	push   %esi
     4ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     4ae:	85 c0                	test   %eax,%eax
     4b0:	7e 13                	jle    4c5 <memmove+0x25>
     4b2:	01 d0                	add    %edx,%eax
  dst = vdst;
     4b4:	89 d7                	mov    %edx,%edi
     4b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     4bd:	00 
     4be:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     4c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     4c1:	39 f8                	cmp    %edi,%eax
     4c3:	75 fb                	jne    4c0 <memmove+0x20>
  return vdst;
}
     4c5:	5e                   	pop    %esi
     4c6:	89 d0                	mov    %edx,%eax
     4c8:	5f                   	pop    %edi
     4c9:	5d                   	pop    %ebp
     4ca:	c3                   	ret

000004cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     4cb:	b8 01 00 00 00       	mov    $0x1,%eax
     4d0:	cd 40                	int    $0x40
     4d2:	c3                   	ret

000004d3 <exit>:
SYSCALL(exit)
     4d3:	b8 02 00 00 00       	mov    $0x2,%eax
     4d8:	cd 40                	int    $0x40
     4da:	c3                   	ret

000004db <wait>:
SYSCALL(wait)
     4db:	b8 03 00 00 00       	mov    $0x3,%eax
     4e0:	cd 40                	int    $0x40
     4e2:	c3                   	ret

000004e3 <pipe>:
SYSCALL(pipe)
     4e3:	b8 04 00 00 00       	mov    $0x4,%eax
     4e8:	cd 40                	int    $0x40
     4ea:	c3                   	ret

000004eb <read>:
SYSCALL(read)
     4eb:	b8 05 00 00 00       	mov    $0x5,%eax
     4f0:	cd 40                	int    $0x40
     4f2:	c3                   	ret

000004f3 <write>:
SYSCALL(write)
     4f3:	b8 10 00 00 00       	mov    $0x10,%eax
     4f8:	cd 40                	int    $0x40
     4fa:	c3                   	ret

000004fb <close>:
SYSCALL(close)
     4fb:	b8 15 00 00 00       	mov    $0x15,%eax
     500:	cd 40                	int    $0x40
     502:	c3                   	ret

00000503 <kill>:
SYSCALL(kill)
     503:	b8 06 00 00 00       	mov    $0x6,%eax
     508:	cd 40                	int    $0x40
     50a:	c3                   	ret

0000050b <exec>:
SYSCALL(exec)
     50b:	b8 07 00 00 00       	mov    $0x7,%eax
     510:	cd 40                	int    $0x40
     512:	c3                   	ret

00000513 <open>:
SYSCALL(open)
     513:	b8 0f 00 00 00       	mov    $0xf,%eax
     518:	cd 40                	int    $0x40
     51a:	c3                   	ret

0000051b <mknod>:
SYSCALL(mknod)
     51b:	b8 11 00 00 00       	mov    $0x11,%eax
     520:	cd 40                	int    $0x40
     522:	c3                   	ret

00000523 <unlink>:
SYSCALL(unlink)
     523:	b8 12 00 00 00       	mov    $0x12,%eax
     528:	cd 40                	int    $0x40
     52a:	c3                   	ret

0000052b <fstat>:
SYSCALL(fstat)
     52b:	b8 08 00 00 00       	mov    $0x8,%eax
     530:	cd 40                	int    $0x40
     532:	c3                   	ret

00000533 <link>:
SYSCALL(link)
     533:	b8 13 00 00 00       	mov    $0x13,%eax
     538:	cd 40                	int    $0x40
     53a:	c3                   	ret

0000053b <mkdir>:
SYSCALL(mkdir)
     53b:	b8 14 00 00 00       	mov    $0x14,%eax
     540:	cd 40                	int    $0x40
     542:	c3                   	ret

00000543 <chdir>:
SYSCALL(chdir)
     543:	b8 09 00 00 00       	mov    $0x9,%eax
     548:	cd 40                	int    $0x40
     54a:	c3                   	ret

0000054b <dup>:
SYSCALL(dup)
     54b:	b8 0a 00 00 00       	mov    $0xa,%eax
     550:	cd 40                	int    $0x40
     552:	c3                   	ret

00000553 <getpid>:
SYSCALL(getpid)
     553:	b8 0b 00 00 00       	mov    $0xb,%eax
     558:	cd 40                	int    $0x40
     55a:	c3                   	ret

0000055b <sbrk>:
SYSCALL(sbrk)
     55b:	b8 0c 00 00 00       	mov    $0xc,%eax
     560:	cd 40                	int    $0x40
     562:	c3                   	ret

00000563 <sleep>:
SYSCALL(sleep)
     563:	b8 0d 00 00 00       	mov    $0xd,%eax
     568:	cd 40                	int    $0x40
     56a:	c3                   	ret

0000056b <uptime>:
SYSCALL(uptime)
     56b:	b8 0e 00 00 00       	mov    $0xe,%eax
     570:	cd 40                	int    $0x40
     572:	c3                   	ret
     573:	66 90                	xchg   %ax,%ax
     575:	66 90                	xchg   %ax,%ax
     577:	66 90                	xchg   %ax,%ax
     579:	66 90                	xchg   %ax,%ax
     57b:	66 90                	xchg   %ax,%ax
     57d:	66 90                	xchg   %ax,%ax
     57f:	90                   	nop

00000580 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     580:	55                   	push   %ebp
     581:	89 e5                	mov    %esp,%ebp
     583:	57                   	push   %edi
     584:	56                   	push   %esi
     585:	53                   	push   %ebx
     586:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     588:	89 d1                	mov    %edx,%ecx
{
     58a:	83 ec 3c             	sub    $0x3c,%esp
     58d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
     590:	85 d2                	test   %edx,%edx
     592:	0f 89 80 00 00 00    	jns    618 <printint+0x98>
     598:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     59c:	74 7a                	je     618 <printint+0x98>
    x = -xx;
     59e:	f7 d9                	neg    %ecx
    neg = 1;
     5a0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
     5a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     5a8:	31 f6                	xor    %esi,%esi
     5aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     5b0:	89 c8                	mov    %ecx,%eax
     5b2:	31 d2                	xor    %edx,%edx
     5b4:	89 f7                	mov    %esi,%edi
     5b6:	f7 f3                	div    %ebx
     5b8:	8d 76 01             	lea    0x1(%esi),%esi
     5bb:	0f b6 92 84 14 00 00 	movzbl 0x1484(%edx),%edx
     5c2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
     5c6:	89 ca                	mov    %ecx,%edx
     5c8:	89 c1                	mov    %eax,%ecx
     5ca:	39 da                	cmp    %ebx,%edx
     5cc:	73 e2                	jae    5b0 <printint+0x30>
  if(neg)
     5ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     5d1:	85 c0                	test   %eax,%eax
     5d3:	74 07                	je     5dc <printint+0x5c>
    buf[i++] = '-';
     5d5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
     5da:	89 f7                	mov    %esi,%edi
     5dc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
     5df:	8b 75 c0             	mov    -0x40(%ebp),%esi
     5e2:	01 df                	add    %ebx,%edi
     5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
     5e8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
     5eb:	83 ec 04             	sub    $0x4,%esp
     5ee:	88 45 d7             	mov    %al,-0x29(%ebp)
     5f1:	8d 45 d7             	lea    -0x29(%ebp),%eax
     5f4:	6a 01                	push   $0x1
     5f6:	50                   	push   %eax
     5f7:	56                   	push   %esi
     5f8:	e8 f6 fe ff ff       	call   4f3 <write>
  while(--i >= 0)
     5fd:	89 f8                	mov    %edi,%eax
     5ff:	83 c4 10             	add    $0x10,%esp
     602:	83 ef 01             	sub    $0x1,%edi
     605:	39 c3                	cmp    %eax,%ebx
     607:	75 df                	jne    5e8 <printint+0x68>
}
     609:	8d 65 f4             	lea    -0xc(%ebp),%esp
     60c:	5b                   	pop    %ebx
     60d:	5e                   	pop    %esi
     60e:	5f                   	pop    %edi
     60f:	5d                   	pop    %ebp
     610:	c3                   	ret
     611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     618:	31 c0                	xor    %eax,%eax
     61a:	eb 89                	jmp    5a5 <printint+0x25>
     61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     620:	55                   	push   %ebp
     621:	89 e5                	mov    %esp,%ebp
     623:	57                   	push   %edi
     624:	56                   	push   %esi
     625:	53                   	push   %ebx
     626:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     629:	8b 75 0c             	mov    0xc(%ebp),%esi
{
     62c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
     62f:	0f b6 1e             	movzbl (%esi),%ebx
     632:	83 c6 01             	add    $0x1,%esi
     635:	84 db                	test   %bl,%bl
     637:	74 67                	je     6a0 <printf+0x80>
     639:	8d 4d 10             	lea    0x10(%ebp),%ecx
     63c:	31 d2                	xor    %edx,%edx
     63e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
     641:	eb 34                	jmp    677 <printf+0x57>
     643:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     648:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     64b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     650:	83 f8 25             	cmp    $0x25,%eax
     653:	74 18                	je     66d <printf+0x4d>
  write(fd, &c, 1);
     655:	83 ec 04             	sub    $0x4,%esp
     658:	8d 45 e7             	lea    -0x19(%ebp),%eax
     65b:	88 5d e7             	mov    %bl,-0x19(%ebp)
     65e:	6a 01                	push   $0x1
     660:	50                   	push   %eax
     661:	57                   	push   %edi
     662:	e8 8c fe ff ff       	call   4f3 <write>
     667:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     66a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     66d:	0f b6 1e             	movzbl (%esi),%ebx
     670:	83 c6 01             	add    $0x1,%esi
     673:	84 db                	test   %bl,%bl
     675:	74 29                	je     6a0 <printf+0x80>
    c = fmt[i] & 0xff;
     677:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     67a:	85 d2                	test   %edx,%edx
     67c:	74 ca                	je     648 <printf+0x28>
      }
    } else if(state == '%'){
     67e:	83 fa 25             	cmp    $0x25,%edx
     681:	75 ea                	jne    66d <printf+0x4d>
      if(c == 'd'){
     683:	83 f8 25             	cmp    $0x25,%eax
     686:	0f 84 04 01 00 00    	je     790 <printf+0x170>
     68c:	83 e8 63             	sub    $0x63,%eax
     68f:	83 f8 15             	cmp    $0x15,%eax
     692:	77 1c                	ja     6b0 <printf+0x90>
     694:	ff 24 85 2c 14 00 00 	jmp    *0x142c(,%eax,4)
     69b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6a3:	5b                   	pop    %ebx
     6a4:	5e                   	pop    %esi
     6a5:	5f                   	pop    %edi
     6a6:	5d                   	pop    %ebp
     6a7:	c3                   	ret
     6a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     6af:	00 
  write(fd, &c, 1);
     6b0:	83 ec 04             	sub    $0x4,%esp
     6b3:	8d 55 e7             	lea    -0x19(%ebp),%edx
     6b6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     6ba:	6a 01                	push   $0x1
     6bc:	52                   	push   %edx
     6bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     6c0:	57                   	push   %edi
     6c1:	e8 2d fe ff ff       	call   4f3 <write>
     6c6:	83 c4 0c             	add    $0xc,%esp
     6c9:	88 5d e7             	mov    %bl,-0x19(%ebp)
     6cc:	6a 01                	push   $0x1
     6ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     6d1:	52                   	push   %edx
     6d2:	57                   	push   %edi
     6d3:	e8 1b fe ff ff       	call   4f3 <write>
        putc(fd, c);
     6d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
     6db:	31 d2                	xor    %edx,%edx
     6dd:	eb 8e                	jmp    66d <printf+0x4d>
     6df:	90                   	nop
        printint(fd, *ap, 16, 0);
     6e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     6e3:	83 ec 0c             	sub    $0xc,%esp
     6e6:	b9 10 00 00 00       	mov    $0x10,%ecx
     6eb:	8b 13                	mov    (%ebx),%edx
     6ed:	6a 00                	push   $0x0
     6ef:	89 f8                	mov    %edi,%eax
        ap++;
     6f1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
     6f4:	e8 87 fe ff ff       	call   580 <printint>
        ap++;
     6f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     6fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
     6ff:	31 d2                	xor    %edx,%edx
     701:	e9 67 ff ff ff       	jmp    66d <printf+0x4d>
        s = (char*)*ap;
     706:	8b 45 d0             	mov    -0x30(%ebp),%eax
     709:	8b 18                	mov    (%eax),%ebx
        ap++;
     70b:	83 c0 04             	add    $0x4,%eax
     70e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
     711:	85 db                	test   %ebx,%ebx
     713:	0f 84 87 00 00 00    	je     7a0 <printf+0x180>
        while(*s != 0){
     719:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
     71c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
     71e:	84 c0                	test   %al,%al
     720:	0f 84 47 ff ff ff    	je     66d <printf+0x4d>
     726:	8d 55 e7             	lea    -0x19(%ebp),%edx
     729:	89 75 d4             	mov    %esi,-0x2c(%ebp)
     72c:	89 de                	mov    %ebx,%esi
     72e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
     730:	83 ec 04             	sub    $0x4,%esp
     733:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
     736:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     739:	6a 01                	push   $0x1
     73b:	53                   	push   %ebx
     73c:	57                   	push   %edi
     73d:	e8 b1 fd ff ff       	call   4f3 <write>
        while(*s != 0){
     742:	0f b6 06             	movzbl (%esi),%eax
     745:	83 c4 10             	add    $0x10,%esp
     748:	84 c0                	test   %al,%al
     74a:	75 e4                	jne    730 <printf+0x110>
      state = 0;
     74c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
     74f:	31 d2                	xor    %edx,%edx
     751:	e9 17 ff ff ff       	jmp    66d <printf+0x4d>
        printint(fd, *ap, 10, 1);
     756:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     759:	83 ec 0c             	sub    $0xc,%esp
     75c:	b9 0a 00 00 00       	mov    $0xa,%ecx
     761:	8b 13                	mov    (%ebx),%edx
     763:	6a 01                	push   $0x1
     765:	eb 88                	jmp    6ef <printf+0xcf>
        putc(fd, *ap);
     767:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
     76a:	83 ec 04             	sub    $0x4,%esp
     76d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
     770:	8b 03                	mov    (%ebx),%eax
        ap++;
     772:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
     775:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     778:	6a 01                	push   $0x1
     77a:	52                   	push   %edx
     77b:	57                   	push   %edi
     77c:	e8 72 fd ff ff       	call   4f3 <write>
        ap++;
     781:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     784:	83 c4 10             	add    $0x10,%esp
      state = 0;
     787:	31 d2                	xor    %edx,%edx
     789:	e9 df fe ff ff       	jmp    66d <printf+0x4d>
     78e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
     790:	83 ec 04             	sub    $0x4,%esp
     793:	88 5d e7             	mov    %bl,-0x19(%ebp)
     796:	8d 55 e7             	lea    -0x19(%ebp),%edx
     799:	6a 01                	push   $0x1
     79b:	e9 31 ff ff ff       	jmp    6d1 <printf+0xb1>
     7a0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
     7a5:	bb f8 13 00 00       	mov    $0x13f8,%ebx
     7aa:	e9 77 ff ff ff       	jmp    726 <printf+0x106>
     7af:	90                   	nop

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     7b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7b1:	a1 08 1d 00 00       	mov    0x1d08,%eax
{
     7b6:	89 e5                	mov    %esp,%ebp
     7b8:	57                   	push   %edi
     7b9:	56                   	push   %esi
     7ba:	53                   	push   %ebx
     7bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     7be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     7c8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     7ca:	39 c8                	cmp    %ecx,%eax
     7cc:	73 32                	jae    800 <free+0x50>
     7ce:	39 d1                	cmp    %edx,%ecx
     7d0:	72 04                	jb     7d6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     7d2:	39 d0                	cmp    %edx,%eax
     7d4:	72 32                	jb     808 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
     7d6:	8b 73 fc             	mov    -0x4(%ebx),%esi
     7d9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     7dc:	39 fa                	cmp    %edi,%edx
     7de:	74 30                	je     810 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     7e0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     7e3:	8b 50 04             	mov    0x4(%eax),%edx
     7e6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     7e9:	39 f1                	cmp    %esi,%ecx
     7eb:	74 3a                	je     827 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     7ed:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
     7ef:	5b                   	pop    %ebx
  freep = p;
     7f0:	a3 08 1d 00 00       	mov    %eax,0x1d08
}
     7f5:	5e                   	pop    %esi
     7f6:	5f                   	pop    %edi
     7f7:	5d                   	pop    %ebp
     7f8:	c3                   	ret
     7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     800:	39 d0                	cmp    %edx,%eax
     802:	72 04                	jb     808 <free+0x58>
     804:	39 d1                	cmp    %edx,%ecx
     806:	72 ce                	jb     7d6 <free+0x26>
{
     808:	89 d0                	mov    %edx,%eax
     80a:	eb bc                	jmp    7c8 <free+0x18>
     80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
     810:	03 72 04             	add    0x4(%edx),%esi
     813:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     816:	8b 10                	mov    (%eax),%edx
     818:	8b 12                	mov    (%edx),%edx
     81a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     81d:	8b 50 04             	mov    0x4(%eax),%edx
     820:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     823:	39 f1                	cmp    %esi,%ecx
     825:	75 c6                	jne    7ed <free+0x3d>
    p->s.size += bp->s.size;
     827:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
     82a:	a3 08 1d 00 00       	mov    %eax,0x1d08
    p->s.size += bp->s.size;
     82f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     832:	8b 4b f8             	mov    -0x8(%ebx),%ecx
     835:	89 08                	mov    %ecx,(%eax)
}
     837:	5b                   	pop    %ebx
     838:	5e                   	pop    %esi
     839:	5f                   	pop    %edi
     83a:	5d                   	pop    %ebp
     83b:	c3                   	ret
     83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     840:	55                   	push   %ebp
     841:	89 e5                	mov    %esp,%ebp
     843:	57                   	push   %edi
     844:	56                   	push   %esi
     845:	53                   	push   %ebx
     846:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     849:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     84c:	8b 15 08 1d 00 00    	mov    0x1d08,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     852:	8d 78 07             	lea    0x7(%eax),%edi
     855:	c1 ef 03             	shr    $0x3,%edi
     858:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
     85b:	85 d2                	test   %edx,%edx
     85d:	0f 84 8d 00 00 00    	je     8f0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     863:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     865:	8b 48 04             	mov    0x4(%eax),%ecx
     868:	39 f9                	cmp    %edi,%ecx
     86a:	73 64                	jae    8d0 <malloc+0x90>
  if(nu < 4096)
     86c:	bb 00 10 00 00       	mov    $0x1000,%ebx
     871:	39 df                	cmp    %ebx,%edi
     873:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
     876:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
     87d:	eb 0a                	jmp    889 <malloc+0x49>
     87f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     880:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     882:	8b 48 04             	mov    0x4(%eax),%ecx
     885:	39 f9                	cmp    %edi,%ecx
     887:	73 47                	jae    8d0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     889:	89 c2                	mov    %eax,%edx
     88b:	3b 05 08 1d 00 00    	cmp    0x1d08,%eax
     891:	75 ed                	jne    880 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
     893:	83 ec 0c             	sub    $0xc,%esp
     896:	56                   	push   %esi
     897:	e8 bf fc ff ff       	call   55b <sbrk>
  if(p == (char*)-1)
     89c:	83 c4 10             	add    $0x10,%esp
     89f:	83 f8 ff             	cmp    $0xffffffff,%eax
     8a2:	74 1c                	je     8c0 <malloc+0x80>
  hp->s.size = nu;
     8a4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     8a7:	83 ec 0c             	sub    $0xc,%esp
     8aa:	83 c0 08             	add    $0x8,%eax
     8ad:	50                   	push   %eax
     8ae:	e8 fd fe ff ff       	call   7b0 <free>
  return freep;
     8b3:	8b 15 08 1d 00 00    	mov    0x1d08,%edx
      if((p = morecore(nunits)) == 0)
     8b9:	83 c4 10             	add    $0x10,%esp
     8bc:	85 d2                	test   %edx,%edx
     8be:	75 c0                	jne    880 <malloc+0x40>
        return 0;
  }
}
     8c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     8c3:	31 c0                	xor    %eax,%eax
}
     8c5:	5b                   	pop    %ebx
     8c6:	5e                   	pop    %esi
     8c7:	5f                   	pop    %edi
     8c8:	5d                   	pop    %ebp
     8c9:	c3                   	ret
     8ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
     8d0:	39 cf                	cmp    %ecx,%edi
     8d2:	74 4c                	je     920 <malloc+0xe0>
        p->s.size -= nunits;
     8d4:	29 f9                	sub    %edi,%ecx
     8d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
     8d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
     8dc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
     8df:	89 15 08 1d 00 00    	mov    %edx,0x1d08
}
     8e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
     8e8:	83 c0 08             	add    $0x8,%eax
}
     8eb:	5b                   	pop    %ebx
     8ec:	5e                   	pop    %esi
     8ed:	5f                   	pop    %edi
     8ee:	5d                   	pop    %ebp
     8ef:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
     8f0:	c7 05 08 1d 00 00 0c 	movl   $0x1d0c,0x1d08
     8f7:	1d 00 00 
    base.s.size = 0;
     8fa:	b8 0c 1d 00 00       	mov    $0x1d0c,%eax
    base.s.ptr = freep = prevp = &base;
     8ff:	c7 05 0c 1d 00 00 0c 	movl   $0x1d0c,0x1d0c
     906:	1d 00 00 
    base.s.size = 0;
     909:	c7 05 10 1d 00 00 00 	movl   $0x0,0x1d10
     910:	00 00 00 
    if(p->s.size >= nunits){
     913:	e9 54 ff ff ff       	jmp    86c <malloc+0x2c>
     918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     91f:	00 
        prevp->s.ptr = p->s.ptr;
     920:	8b 08                	mov    (%eax),%ecx
     922:	89 0a                	mov    %ecx,(%edx)
     924:	eb b9                	jmp    8df <malloc+0x9f>
     926:	66 90                	xchg   %ax,%ax
     928:	66 90                	xchg   %ax,%ax
     92a:	66 90                	xchg   %ax,%ax
     92c:	66 90                	xchg   %ax,%ax
     92e:	66 90                	xchg   %ax,%ax

00000930 <thread_init>:
}

void
thread_init(void)
{
    for (int i = 0; i < MAX_THREADS; i++) {
     930:	b8 40 1d 00 00       	mov    $0x1d40,%eax
     935:	8d 76 00             	lea    0x0(%esi),%esi
        threads[i].tid = -1;
     938:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     93e:	83 c0 20             	add    $0x20,%eax
        threads[i].state = T_UNUSED;
     941:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
        threads[i].stack = 0;
     948:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
        threads[i].sp = 0;
     94f:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        threads[i].start_routine = 0;
     956:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        threads[i].arg = 0;
     95d:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
        threads[i].retval = 0;
     964:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        threads[i].waiting_tid = -1;
     96b:	c7 40 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     972:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
     977:	75 bf                	jne    938 <thread_init+0x8>
    }

    threads[0].tid = 0;
     979:	c7 05 40 1d 00 00 00 	movl   $0x0,0x1d40
     980:	00 00 00 
    threads[0].state = T_RUNNING;
     983:	c7 05 44 1d 00 00 02 	movl   $0x2,0x1d44
     98a:	00 00 00 
    threads[0].waiting_tid = -1;
     98d:	c7 05 5c 1d 00 00 ff 	movl   $0xffffffff,0x1d5c
     994:	ff ff ff 

    current_thread = &threads[0];
     997:	c7 05 20 1d 00 00 40 	movl   $0x1d40,0x1d20
     99e:	1d 00 00 
}
     9a1:	c3                   	ret
     9a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9a9:	00 
     9aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000009b0 <thread_self>:

int
thread_self(void)
{
    return current_thread->tid;
     9b0:	a1 20 1d 00 00       	mov    0x1d20,%eax
     9b5:	8b 00                	mov    (%eax),%eax
}
     9b7:	c3                   	ret
     9b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9bf:	00 

000009c0 <thread_create>:

int
thread_create(void* (*start_routine)(void*), void *arg)
{
     9c0:	55                   	push   %ebp
    int i;
    for (i = 0; i < MAX_THREADS; i++) {
     9c1:	31 c0                	xor    %eax,%eax
{
     9c3:	89 e5                	mov    %esp,%ebp
     9c5:	56                   	push   %esi
     9c6:	53                   	push   %ebx
     9c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9ce:	00 
     9cf:	90                   	nop
        if (threads[i].state == T_UNUSED)
     9d0:	89 c3                	mov    %eax,%ebx
     9d2:	c1 e3 05             	shl    $0x5,%ebx
     9d5:	8b 93 44 1d 00 00    	mov    0x1d44(%ebx),%edx
     9db:	85 d2                	test   %edx,%edx
     9dd:	74 19                	je     9f8 <thread_create+0x38>
    for (i = 0; i < MAX_THREADS; i++) {
     9df:	83 c0 01             	add    $0x1,%eax
     9e2:	83 f8 10             	cmp    $0x10,%eax
     9e5:	75 e9                	jne    9d0 <thread_create+0x10>
            break;
    }
    if (i == MAX_THREADS)
        return -1;
     9e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     9ec:	e9 8c 00 00 00       	jmp    a7d <thread_create+0xbd>
     9f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    struct thread *t = &threads[i];

    t->tid = next_tid++;
     9f8:	a1 d8 1b 00 00       	mov    0x1bd8,%eax
     9fd:	8d b3 40 1d 00 00    	lea    0x1d40(%ebx),%esi
    t->start_routine = start_routine;
    t->arg = arg;
    t->retval = 0;
    t->waiting_tid = -1;

    t->stack = malloc(STACK_SIZE);
     a03:	83 ec 0c             	sub    $0xc,%esp
    t->state = T_RUNNABLE;
     a06:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    t->tid = next_tid++;
     a0d:	89 83 40 1d 00 00    	mov    %eax,0x1d40(%ebx)
     a13:	8d 50 01             	lea    0x1(%eax),%edx
    t->start_routine = start_routine;
     a16:	8b 45 08             	mov    0x8(%ebp),%eax
    t->tid = next_tid++;
     a19:	89 15 d8 1b 00 00    	mov    %edx,0x1bd8
    t->start_routine = start_routine;
     a1f:	89 46 10             	mov    %eax,0x10(%esi)
    t->arg = arg;
     a22:	8b 45 0c             	mov    0xc(%ebp),%eax
    t->retval = 0;
     a25:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    t->arg = arg;
     a2c:	89 46 14             	mov    %eax,0x14(%esi)
    t->waiting_tid = -1;
     a2f:	c7 46 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%esi)
    t->stack = malloc(STACK_SIZE);
     a36:	68 00 10 00 00       	push   $0x1000
     a3b:	e8 00 fe ff ff       	call   840 <malloc>
    if (!t->stack) {
     a40:	83 c4 10             	add    $0x10,%esp
    t->stack = malloc(STACK_SIZE);
     a43:	89 46 08             	mov    %eax,0x8(%esi)
    if (!t->stack) {
     a46:	85 c0                	test   %eax,%eax
     a48:	74 3a                	je     a84 <thread_create+0xc4>
        t->state = T_UNUSED;
        return -1;
    }

    uint *sp = (uint *)((char *)t->stack + STACK_SIZE);
    *(--sp) = (uint)thread_trampoline;
     a4a:	c7 80 fc 0f 00 00 90 	movl   $0xb90,0xffc(%eax)
     a51:	0b 00 00 
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
     a54:	05 ec 0f 00 00       	add    $0xfec,%eax
    *(--sp) = 0;
     a59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    *(--sp) = 0;
     a60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    *(--sp) = 0;
     a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    *(--sp) = 0;
     a6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     a74:	89 46 0c             	mov    %eax,0xc(%esi)
    t->sp = sp;

    return t->tid;
     a77:	8b 83 40 1d 00 00    	mov    0x1d40(%ebx),%eax
}
     a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     a80:	5b                   	pop    %ebx
     a81:	5e                   	pop    %esi
     a82:	5d                   	pop    %ebp
     a83:	c3                   	ret
        t->state = T_UNUSED;
     a84:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
        return -1;
     a8b:	e9 57 ff ff ff       	jmp    9e7 <thread_create+0x27>

00000a90 <thread_schedule>:

void
thread_schedule(void)
{
     a90:	55                   	push   %ebp
     a91:	89 e5                	mov    %esp,%ebp
     a93:	57                   	push   %edi
     a94:	56                   	push   %esi
     a95:	53                   	push   %ebx
     a96:	83 ec 0c             	sub    $0xc,%esp
    struct thread *old = current_thread;
     a99:	8b 35 20 1d 00 00    	mov    0x1d20,%esi
    struct thread *next = 0;

    int start = (old - threads + 1) % MAX_THREADS;
     a9f:	89 f0                	mov    %esi,%eax
     aa1:	2d 40 1d 00 00       	sub    $0x1d40,%eax
     aa6:	c1 f8 05             	sar    $0x5,%eax
     aa9:	83 c0 01             	add    $0x1,%eax
     aac:	99                   	cltd
     aad:	c1 ea 1c             	shr    $0x1c,%edx
     ab0:	01 d0                	add    %edx,%eax
     ab2:	83 e0 0f             	and    $0xf,%eax
     ab5:	29 d0                	sub    %edx,%eax
     ab7:	8d 58 10             	lea    0x10(%eax),%ebx
     aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for (int i = 0; i < MAX_THREADS; i++) {
        int idx = (start + i) % MAX_THREADS;
     ac0:	89 c1                	mov    %eax,%ecx
     ac2:	c1 f9 1f             	sar    $0x1f,%ecx
     ac5:	c1 e9 1c             	shr    $0x1c,%ecx
     ac8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
     acb:	83 e2 0f             	and    $0xf,%edx
     ace:	29 ca                	sub    %ecx,%edx
        if (threads[idx].state == T_RUNNABLE) {
     ad0:	89 d1                	mov    %edx,%ecx
     ad2:	c1 e1 05             	shl    $0x5,%ecx
     ad5:	83 b9 44 1d 00 00 01 	cmpl   $0x1,0x1d44(%ecx)
     adc:	8d b9 40 1d 00 00    	lea    0x1d40(%ecx),%edi
     ae2:	74 14                	je     af8 <thread_schedule+0x68>
    for (int i = 0; i < MAX_THREADS; i++) {
     ae4:	83 c0 01             	add    $0x1,%eax
     ae7:	39 d8                	cmp    %ebx,%eax
     ae9:	75 d5                	jne    ac0 <thread_schedule+0x30>

    next->state = T_RUNNING;
    current_thread = next;

    thread_switch(old, next);
}
     aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     aee:	5b                   	pop    %ebx
     aef:	5e                   	pop    %esi
     af0:	5f                   	pop    %edi
     af1:	5d                   	pop    %ebp
     af2:	c3                   	ret
     af3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (old->state == T_RUNNING)
     af8:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     afc:	75 07                	jne    b05 <thread_schedule+0x75>
        old->state = T_RUNNABLE;
     afe:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    thread_switch(old, next);
     b05:	83 ec 08             	sub    $0x8,%esp
    next->state = T_RUNNING;
     b08:	c1 e2 05             	shl    $0x5,%edx
    current_thread = next;
     b0b:	89 3d 20 1d 00 00    	mov    %edi,0x1d20
    next->state = T_RUNNING;
     b11:	c7 82 44 1d 00 00 02 	movl   $0x2,0x1d44(%edx)
     b18:	00 00 00 
    thread_switch(old, next);
     b1b:	57                   	push   %edi
     b1c:	56                   	push   %esi
     b1d:	e8 1e 03 00 00       	call   e40 <thread_switch>
     b22:	83 c4 10             	add    $0x10,%esp
}
     b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b28:	5b                   	pop    %ebx
     b29:	5e                   	pop    %esi
     b2a:	5f                   	pop    %edi
     b2b:	5d                   	pop    %ebp
     b2c:	c3                   	ret
     b2d:	8d 76 00             	lea    0x0(%esi),%esi

00000b30 <thread_yield>:

void
thread_yield(void)
{
    thread_schedule();
     b30:	e9 5b ff ff ff       	jmp    a90 <thread_schedule>
     b35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b3c:	00 
     b3d:	8d 76 00             	lea    0x0(%esi),%esi

00000b40 <thread_exit>:
}

void
thread_exit(void *retval)
{
     b40:	55                   	push   %ebp
     b41:	89 e5                	mov    %esp,%ebp
     b43:	83 ec 08             	sub    $0x8,%esp
    current_thread->retval = retval;
     b46:	a1 20 1d 00 00       	mov    0x1d20,%eax
     b4b:	8b 55 08             	mov    0x8(%ebp),%edx
    current_thread->state = T_ZOMBIE;

    if (current_thread->waiting_tid >= 0) {
     b4e:	8b 48 1c             	mov    0x1c(%eax),%ecx
    current_thread->state = T_ZOMBIE;
     b51:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
    current_thread->retval = retval;
     b58:	89 50 18             	mov    %edx,0x18(%eax)
    if (current_thread->waiting_tid >= 0) {
     b5b:	85 c9                	test   %ecx,%ecx
     b5d:	78 1e                	js     b7d <thread_exit+0x3d>
        for (int i = 0; i < MAX_THREADS; i++) {
     b5f:	31 c0                	xor    %eax,%eax
     b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (threads[i].tid == current_thread->waiting_tid) {
     b68:	89 c2                	mov    %eax,%edx
     b6a:	c1 e2 05             	shl    $0x5,%edx
     b6d:	3b 8a 40 1d 00 00    	cmp    0x1d40(%edx),%ecx
     b73:	74 0f                	je     b84 <thread_exit+0x44>
        for (int i = 0; i < MAX_THREADS; i++) {
     b75:	83 c0 01             	add    $0x1,%eax
     b78:	83 f8 10             	cmp    $0x10,%eax
     b7b:	75 eb                	jne    b68 <thread_exit+0x28>
                break;
            }
        }
    }

    thread_schedule();
     b7d:	e8 0e ff ff ff       	call   a90 <thread_schedule>

    for (;;)
     b82:	eb fe                	jmp    b82 <thread_exit+0x42>
                threads[i].state = T_RUNNABLE;
     b84:	c7 82 44 1d 00 00 01 	movl   $0x1,0x1d44(%edx)
     b8b:	00 00 00 
                break;
     b8e:	eb ed                	jmp    b7d <thread_exit+0x3d>

00000b90 <thread_trampoline>:
{
     b90:	55                   	push   %ebp
     b91:	89 e5                	mov    %esp,%ebp
     b93:	83 ec 14             	sub    $0x14,%esp
    void *ret = current_thread->start_routine(current_thread->arg);
     b96:	a1 20 1d 00 00       	mov    0x1d20,%eax
     b9b:	ff 70 14             	push   0x14(%eax)
     b9e:	ff 50 10             	call   *0x10(%eax)
    thread_exit(ret);
     ba1:	89 04 24             	mov    %eax,(%esp)
     ba4:	e8 97 ff ff ff       	call   b40 <thread_exit>
     ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000bb0 <thread_join>:
        ;
}

void *
thread_join(int tid)
{
     bb0:	55                   	push   %ebp
     bb1:	89 e5                	mov    %esp,%ebp
     bb3:	57                   	push   %edi
     bb4:	56                   	push   %esi
     bb5:	53                   	push   %ebx
    struct thread *target = 0;

    for (int i = 0; i < MAX_THREADS; i++) {
     bb6:	31 db                	xor    %ebx,%ebx
{
     bb8:	83 ec 0c             	sub    $0xc,%esp
     bbb:	8b 55 08             	mov    0x8(%ebp),%edx
     bbe:	66 90                	xchg   %ax,%ax
        if (threads[i].tid == tid) {
     bc0:	89 d8                	mov    %ebx,%eax
     bc2:	c1 e0 05             	shl    $0x5,%eax
     bc5:	39 90 40 1d 00 00    	cmp    %edx,0x1d40(%eax)
     bcb:	74 1b                	je     be8 <thread_join+0x38>
    for (int i = 0; i < MAX_THREADS; i++) {
     bcd:	83 c3 01             	add    $0x1,%ebx
     bd0:	83 fb 10             	cmp    $0x10,%ebx
     bd3:	75 eb                	jne    bc0 <thread_join+0x10>
    target->stack = 0;
    target->state = T_UNUSED;
    target->tid = -1;

    return ret;
}
     bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     bd8:	31 ff                	xor    %edi,%edi
}
     bda:	5b                   	pop    %ebx
     bdb:	89 f8                	mov    %edi,%eax
     bdd:	5e                   	pop    %esi
     bde:	5f                   	pop    %edi
     bdf:	5d                   	pop    %ebp
     be0:	c3                   	ret
     be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (target->state != T_ZOMBIE) {
     be8:	83 b8 44 1d 00 00 04 	cmpl   $0x4,0x1d44(%eax)
     bef:	8d b0 40 1d 00 00    	lea    0x1d40(%eax),%esi
     bf5:	74 25                	je     c1c <thread_join+0x6c>
     bf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bfe:	00 
     bff:	90                   	nop
        current_thread->state = T_SLEEPING;
     c00:	a1 20 1d 00 00       	mov    0x1d20,%eax
     c05:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        target->waiting_tid = current_thread->tid;
     c0c:	8b 00                	mov    (%eax),%eax
     c0e:	89 46 1c             	mov    %eax,0x1c(%esi)
        thread_schedule();
     c11:	e8 7a fe ff ff       	call   a90 <thread_schedule>
    while (target->state != T_ZOMBIE) {
     c16:	83 7e 04 04          	cmpl   $0x4,0x4(%esi)
     c1a:	75 e4                	jne    c00 <thread_join+0x50>
    void *ret = target->retval;
     c1c:	c1 e3 05             	shl    $0x5,%ebx
    free(target->stack);
     c1f:	83 ec 0c             	sub    $0xc,%esp
    void *ret = target->retval;
     c22:	8b bb 58 1d 00 00    	mov    0x1d58(%ebx),%edi
    free(target->stack);
     c28:	ff b3 48 1d 00 00    	push   0x1d48(%ebx)
     c2e:	e8 7d fb ff ff       	call   7b0 <free>
    return ret;
     c33:	83 c4 10             	add    $0x10,%esp
}
     c36:	89 f8                	mov    %edi,%eax
    target->stack = 0;
     c38:	c7 83 48 1d 00 00 00 	movl   $0x0,0x1d48(%ebx)
     c3f:	00 00 00 
    target->state = T_UNUSED;
     c42:	c7 83 44 1d 00 00 00 	movl   $0x0,0x1d44(%ebx)
     c49:	00 00 00 
    target->tid = -1;
     c4c:	c7 83 40 1d 00 00 ff 	movl   $0xffffffff,0x1d40(%ebx)
     c53:	ff ff ff 
}
     c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c59:	5b                   	pop    %ebx
     c5a:	5e                   	pop    %esi
     c5b:	5f                   	pop    %edi
     c5c:	5d                   	pop    %ebp
     c5d:	c3                   	ret
     c5e:	66 90                	xchg   %ax,%ax

00000c60 <sem_init>:
void
sem_init(sem_t *s, int value)
{
     c60:	55                   	push   %ebp
     c61:	89 e5                	mov    %esp,%ebp
     c63:	8b 45 08             	mov    0x8(%ebp),%eax
    s->count = value;
     c66:	8b 55 0c             	mov    0xc(%ebp),%edx
    s->wait_count = 0;
     c69:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    s->count = value;
     c70:	89 10                	mov    %edx,(%eax)
}
     c72:	5d                   	pop    %ebp
     c73:	c3                   	ret
     c74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c7b:	00 
     c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c80 <sem_wait>:

void
sem_wait(sem_t *s)
{
     c80:	55                   	push   %ebp
     c81:	89 e5                	mov    %esp,%ebp
     c83:	53                   	push   %ebx
     c84:	8b 55 08             	mov    0x8(%ebp),%edx
    s->count--;
     c87:	83 2a 01             	subl   $0x1,(%edx)
    if (s->count < 0) {
     c8a:	78 0c                	js     c98 <sem_wait+0x18>
        s->wait_queue[s->wait_count++] = current_thread->tid;
        current_thread->state = T_SLEEPING;
        thread_schedule();
    }
}
     c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c8f:	c9                   	leave
     c90:	c3                   	ret
     c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s->wait_queue[s->wait_count++] = current_thread->tid;
     c98:	8b 4a 44             	mov    0x44(%edx),%ecx
     c9b:	a1 20 1d 00 00       	mov    0x1d20,%eax
     ca0:	8d 59 01             	lea    0x1(%ecx),%ebx
     ca3:	89 5a 44             	mov    %ebx,0x44(%edx)
     ca6:	8b 18                	mov    (%eax),%ebx
     ca8:	89 5c 8a 04          	mov    %ebx,0x4(%edx,%ecx,4)
        current_thread->state = T_SLEEPING;
     cac:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
}
     cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     cb6:	c9                   	leave
        thread_schedule();
     cb7:	e9 d4 fd ff ff       	jmp    a90 <thread_schedule>
     cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cc0 <sem_post>:

void
sem_post(sem_t *s)
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	57                   	push   %edi
     cc4:	8b 55 08             	mov    0x8(%ebp),%edx
     cc7:	56                   	push   %esi
     cc8:	53                   	push   %ebx
    s->count++;
     cc9:	8b 02                	mov    (%edx),%eax
     ccb:	83 c0 01             	add    $0x1,%eax
     cce:	89 02                	mov    %eax,(%edx)
    if (s->count <= 0 && s->wait_count > 0) {
     cd0:	85 c0                	test   %eax,%eax
     cd2:	7e 0c                	jle    ce0 <sem_post+0x20>
                threads[i].state = T_RUNNABLE;
                break;
            }
        }
    }
}
     cd4:	5b                   	pop    %ebx
     cd5:	5e                   	pop    %esi
     cd6:	5f                   	pop    %edi
     cd7:	5d                   	pop    %ebp
     cd8:	c3                   	ret
     cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (s->count <= 0 && s->wait_count > 0) {
     ce0:	8b 7a 44             	mov    0x44(%edx),%edi
     ce3:	85 ff                	test   %edi,%edi
     ce5:	7e ed                	jle    cd4 <sem_post+0x14>
        int tid = s->wait_queue[0];
     ce7:	8b 5a 04             	mov    0x4(%edx),%ebx
        for (int i = 1; i < s->wait_count; i++)
     cea:	83 ff 01             	cmp    $0x1,%edi
     ced:	74 16                	je     d05 <sem_post+0x45>
     cef:	8d 42 04             	lea    0x4(%edx),%eax
     cf2:	8d 34 ba             	lea    (%edx,%edi,4),%esi
     cf5:	8d 76 00             	lea    0x0(%esi),%esi
            s->wait_queue[i - 1] = s->wait_queue[i];
     cf8:	8b 48 04             	mov    0x4(%eax),%ecx
        for (int i = 1; i < s->wait_count; i++)
     cfb:	83 c0 04             	add    $0x4,%eax
            s->wait_queue[i - 1] = s->wait_queue[i];
     cfe:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int i = 1; i < s->wait_count; i++)
     d01:	39 f0                	cmp    %esi,%eax
     d03:	75 f3                	jne    cf8 <sem_post+0x38>
        s->wait_count--;
     d05:	83 ef 01             	sub    $0x1,%edi
        for (int i = 0; i < MAX_THREADS; i++) {
     d08:	31 c0                	xor    %eax,%eax
        s->wait_count--;
     d0a:	89 7a 44             	mov    %edi,0x44(%edx)
        for (int i = 0; i < MAX_THREADS; i++) {
     d0d:	eb 09                	jmp    d18 <sem_post+0x58>
     d0f:	90                   	nop
     d10:	83 c0 01             	add    $0x1,%eax
     d13:	83 f8 10             	cmp    $0x10,%eax
     d16:	74 bc                	je     cd4 <sem_post+0x14>
            if (threads[i].tid == tid) {
     d18:	89 c2                	mov    %eax,%edx
     d1a:	c1 e2 05             	shl    $0x5,%edx
     d1d:	39 9a 40 1d 00 00    	cmp    %ebx,0x1d40(%edx)
     d23:	75 eb                	jne    d10 <sem_post+0x50>
                threads[i].state = T_RUNNABLE;
     d25:	c7 82 44 1d 00 00 01 	movl   $0x1,0x1d44(%edx)
     d2c:	00 00 00 
}
     d2f:	5b                   	pop    %ebx
     d30:	5e                   	pop    %esi
     d31:	5f                   	pop    %edi
     d32:	5d                   	pop    %ebp
     d33:	c3                   	ret
     d34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d3b:	00 
     d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d40 <cond_init>:

void
cond_init(cond_t *c)
{
     d40:	55                   	push   %ebp
     d41:	89 e5                	mov    %esp,%ebp
    c->wait_count = 0;
     d43:	8b 45 08             	mov    0x8(%ebp),%eax
     d46:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%eax)
}
     d4d:	5d                   	pop    %ebp
     d4e:	c3                   	ret
     d4f:	90                   	nop

00000d50 <cond_wait>:

void
cond_wait(cond_t *c, mutex_t *m)
{
     d50:	55                   	push   %ebp
     d51:	89 e5                	mov    %esp,%ebp
     d53:	53                   	push   %ebx
     d54:	83 ec 10             	sub    $0x10,%esp
     d57:	8b 45 08             	mov    0x8(%ebp),%eax
     d5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    c->wait_queue[c->wait_count++] = current_thread->tid;
     d5d:	8b 50 40             	mov    0x40(%eax),%edx
     d60:	8d 4a 01             	lea    0x1(%edx),%ecx
     d63:	89 48 40             	mov    %ecx,0x40(%eax)
     d66:	8b 0d 20 1d 00 00    	mov    0x1d20,%ecx
     d6c:	8b 09                	mov    (%ecx),%ecx
     d6e:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    mutex_unlock(m);
     d71:	53                   	push   %ebx
     d72:	e8 79 01 00 00       	call   ef0 <mutex_unlock>
    current_thread->state = T_SLEEPING;
     d77:	a1 20 1d 00 00       	mov    0x1d20,%eax
     d7c:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
    thread_schedule();
     d83:	e8 08 fd ff ff       	call   a90 <thread_schedule>
    mutex_lock(m);
     d88:	83 c4 10             	add    $0x10,%esp
     d8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d91:	c9                   	leave
    mutex_lock(m);
     d92:	e9 e9 00 00 00       	jmp    e80 <mutex_lock>
     d97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d9e:	00 
     d9f:	90                   	nop

00000da0 <cond_signal>:

void
cond_signal(cond_t *c)
{
     da0:	55                   	push   %ebp
     da1:	89 e5                	mov    %esp,%ebp
     da3:	57                   	push   %edi
     da4:	8b 7d 08             	mov    0x8(%ebp),%edi
     da7:	56                   	push   %esi
     da8:	53                   	push   %ebx
    if (c->wait_count == 0)
     da9:	8b 77 40             	mov    0x40(%edi),%esi
     dac:	85 f6                	test   %esi,%esi
     dae:	74 3d                	je     ded <cond_signal+0x4d>
        return;

    int tid = c->wait_queue[0];
     db0:	8b 0f                	mov    (%edi),%ecx
    for (int i = 1; i < c->wait_count; i++)
     db2:	83 fe 01             	cmp    $0x1,%esi
     db5:	7e 16                	jle    dcd <cond_signal+0x2d>
     db7:	89 f8                	mov    %edi,%eax
     db9:	8d 5c b7 fc          	lea    -0x4(%edi,%esi,4),%ebx
     dbd:	8d 76 00             	lea    0x0(%esi),%esi
        c->wait_queue[i - 1] = c->wait_queue[i];
     dc0:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < c->wait_count; i++)
     dc3:	83 c0 04             	add    $0x4,%eax
        c->wait_queue[i - 1] = c->wait_queue[i];
     dc6:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < c->wait_count; i++)
     dc9:	39 d8                	cmp    %ebx,%eax
     dcb:	75 f3                	jne    dc0 <cond_signal+0x20>
    c->wait_count--;
     dcd:	83 ee 01             	sub    $0x1,%esi

    for (int i = 0; i < MAX_THREADS; i++) {
     dd0:	31 c0                	xor    %eax,%eax
    c->wait_count--;
     dd2:	89 77 40             	mov    %esi,0x40(%edi)
    for (int i = 0; i < MAX_THREADS; i++) {
     dd5:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == tid) {
     dd8:	89 c2                	mov    %eax,%edx
     dda:	c1 e2 05             	shl    $0x5,%edx
     ddd:	39 8a 40 1d 00 00    	cmp    %ecx,0x1d40(%edx)
     de3:	74 13                	je     df8 <cond_signal+0x58>
    for (int i = 0; i < MAX_THREADS; i++) {
     de5:	83 c0 01             	add    $0x1,%eax
     de8:	83 f8 10             	cmp    $0x10,%eax
     deb:	75 eb                	jne    dd8 <cond_signal+0x38>
            threads[i].state = T_RUNNABLE;
            break;
        }
    }
}
     ded:	5b                   	pop    %ebx
     dee:	5e                   	pop    %esi
     def:	5f                   	pop    %edi
     df0:	5d                   	pop    %ebp
     df1:	c3                   	ret
     df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     df8:	c7 82 44 1d 00 00 01 	movl   $0x1,0x1d44(%edx)
     dff:	00 00 00 
}
     e02:	5b                   	pop    %ebx
     e03:	5e                   	pop    %esi
     e04:	5f                   	pop    %edi
     e05:	5d                   	pop    %ebp
     e06:	c3                   	ret
     e07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e0e:	00 
     e0f:	90                   	nop

00000e10 <cond_broadcast>:

void
cond_broadcast(cond_t *c)
{
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	53                   	push   %ebx
     e14:	83 ec 04             	sub    $0x4,%esp
     e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (c->wait_count > 0)
     e1a:	8b 53 40             	mov    0x40(%ebx),%edx
     e1d:	85 d2                	test   %edx,%edx
     e1f:	7e 1a                	jle    e3b <cond_broadcast+0x2b>
     e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(c);
     e28:	83 ec 0c             	sub    $0xc,%esp
     e2b:	53                   	push   %ebx
     e2c:	e8 6f ff ff ff       	call   da0 <cond_signal>
    while (c->wait_count > 0)
     e31:	8b 43 40             	mov    0x40(%ebx),%eax
     e34:	83 c4 10             	add    $0x10,%esp
     e37:	85 c0                	test   %eax,%eax
     e39:	7f ed                	jg     e28 <cond_broadcast+0x18>
}
     e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e3e:	c9                   	leave
     e3f:	c3                   	ret

00000e40 <thread_switch>:
.text
.globl thread_switch
thread_switch:
  movl 4(%esp), %eax
     e40:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
     e44:	8b 54 24 08          	mov    0x8(%esp),%edx
  pushl %ebp
     e48:	55                   	push   %ebp
  pushl %ebx
     e49:	53                   	push   %ebx
  pushl %esi
     e4a:	56                   	push   %esi
  pushl %edi
     e4b:	57                   	push   %edi
  movl %esp, 12(%eax)
     e4c:	89 60 0c             	mov    %esp,0xc(%eax)
  movl 12(%edx), %esp
     e4f:	8b 62 0c             	mov    0xc(%edx),%esp
  popl %edi
     e52:	5f                   	pop    %edi
  popl %esi
     e53:	5e                   	pop    %esi
  popl %ebx
     e54:	5b                   	pop    %ebx
  popl %ebp
     e55:	5d                   	pop    %ebp
  ret
     e56:	c3                   	ret
     e57:	66 90                	xchg   %ax,%ax
     e59:	66 90                	xchg   %ax,%ax
     e5b:	66 90                	xchg   %ax,%ax
     e5d:	66 90                	xchg   %ax,%ax
     e5f:	90                   	nop

00000e60 <mutex_init>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

void
mutex_init(mutex_t *m)
{
     e60:	55                   	push   %ebp
     e61:	89 e5                	mov    %esp,%ebp
     e63:	8b 45 08             	mov    0x8(%ebp),%eax
    m->locked = 0;
     e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    m->owner = -1;
     e6c:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    m->wait_count = 0;
     e73:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
}
     e7a:	5d                   	pop    %ebp
     e7b:	c3                   	ret
     e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e80 <mutex_lock>:

void
mutex_lock(mutex_t *m)
{
     e80:	55                   	push   %ebp
     e81:	89 e5                	mov    %esp,%ebp
     e83:	53                   	push   %ebx
     e84:	83 ec 04             	sub    $0x4,%esp
     e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (m->locked) {
     e8a:	8b 13                	mov    (%ebx),%edx
     e8c:	85 d2                	test   %edx,%edx
     e8e:	75 29                	jne    eb9 <mutex_lock+0x39>
     e90:	eb 3e                	jmp    ed0 <mutex_lock+0x50>
     e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (m->owner == current_thread->tid)
            return;
        m->wait_queue[m->wait_count++] = current_thread->tid;
     e98:	8b 53 48             	mov    0x48(%ebx),%edx
     e9b:	8d 4a 01             	lea    0x1(%edx),%ecx
     e9e:	89 4b 48             	mov    %ecx,0x48(%ebx)
     ea1:	8b 08                	mov    (%eax),%ecx
     ea3:	89 4c 93 08          	mov    %ecx,0x8(%ebx,%edx,4)
        current_thread->state = T_SLEEPING;
     ea7:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        thread_schedule();
     eae:	e8 dd fb ff ff       	call   a90 <thread_schedule>
    while (m->locked) {
     eb3:	8b 03                	mov    (%ebx),%eax
     eb5:	85 c0                	test   %eax,%eax
     eb7:	74 17                	je     ed0 <mutex_lock+0x50>
        if (m->owner == current_thread->tid)
     eb9:	a1 20 1d 00 00       	mov    0x1d20,%eax
     ebe:	8b 10                	mov    (%eax),%edx
     ec0:	39 53 04             	cmp    %edx,0x4(%ebx)
     ec3:	75 d3                	jne    e98 <mutex_lock+0x18>
    }
    m->locked = 1;
    m->owner = current_thread->tid;
}
     ec5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ec8:	c9                   	leave
     ec9:	c3                   	ret
     eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m->locked = 1;
     ed0:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    m->owner = current_thread->tid;
     ed6:	a1 20 1d 00 00       	mov    0x1d20,%eax
     edb:	8b 00                	mov    (%eax),%eax
     edd:	89 43 04             	mov    %eax,0x4(%ebx)
}
     ee0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ee3:	c9                   	leave
     ee4:	c3                   	ret
     ee5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     eec:	00 
     eed:	8d 76 00             	lea    0x0(%esi),%esi

00000ef0 <mutex_unlock>:

void
mutex_unlock(mutex_t *m)
{
     ef0:	55                   	push   %ebp
    if (m->owner != current_thread->tid)
     ef1:	a1 20 1d 00 00       	mov    0x1d20,%eax
{
     ef6:	89 e5                	mov    %esp,%ebp
     ef8:	57                   	push   %edi
     ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
     efc:	56                   	push   %esi
     efd:	53                   	push   %ebx
    if (m->owner != current_thread->tid)
     efe:	8b 00                	mov    (%eax),%eax
     f00:	39 41 04             	cmp    %eax,0x4(%ecx)
     f03:	75 48                	jne    f4d <mutex_unlock+0x5d>
        return;

    if (m->wait_count == 0) {
     f05:	8b 79 48             	mov    0x48(%ecx),%edi
     f08:	85 ff                	test   %edi,%edi
     f0a:	74 4c                	je     f58 <mutex_unlock+0x68>
        m->locked = 0;
        m->owner = -1;
        return;
    }

    int next_tid = m->wait_queue[0];
     f0c:	8b 59 08             	mov    0x8(%ecx),%ebx
    for (int i = 1; i < m->wait_count; i++)
     f0f:	83 ff 01             	cmp    $0x1,%edi
     f12:	7e 19                	jle    f2d <mutex_unlock+0x3d>
     f14:	8d 41 08             	lea    0x8(%ecx),%eax
     f17:	8d 74 b9 04          	lea    0x4(%ecx,%edi,4),%esi
     f1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        m->wait_queue[i - 1] = m->wait_queue[i];
     f20:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < m->wait_count; i++)
     f23:	83 c0 04             	add    $0x4,%eax
        m->wait_queue[i - 1] = m->wait_queue[i];
     f26:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < m->wait_count; i++)
     f29:	39 f0                	cmp    %esi,%eax
     f2b:	75 f3                	jne    f20 <mutex_unlock+0x30>
    m->wait_count--;
     f2d:	83 ef 01             	sub    $0x1,%edi

    for (int i = 0; i < MAX_THREADS; i++) {
     f30:	31 c0                	xor    %eax,%eax
    m->wait_count--;
     f32:	89 79 48             	mov    %edi,0x48(%ecx)
    for (int i = 0; i < MAX_THREADS; i++) {
     f35:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == next_tid) {
     f38:	89 c2                	mov    %eax,%edx
     f3a:	c1 e2 05             	shl    $0x5,%edx
     f3d:	39 9a 40 1d 00 00    	cmp    %ebx,0x1d40(%edx)
     f43:	74 2b                	je     f70 <mutex_unlock+0x80>
    for (int i = 0; i < MAX_THREADS; i++) {
     f45:	83 c0 01             	add    $0x1,%eax
     f48:	83 f8 10             	cmp    $0x10,%eax
     f4b:	75 eb                	jne    f38 <mutex_unlock+0x48>
            threads[i].state = T_RUNNABLE;
            m->owner = next_tid;
            break;
        }
    }
}
     f4d:	5b                   	pop    %ebx
     f4e:	5e                   	pop    %esi
     f4f:	5f                   	pop    %edi
     f50:	5d                   	pop    %ebp
     f51:	c3                   	ret
     f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        m->locked = 0;
     f58:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
        m->owner = -1;
     f5e:	c7 41 04 ff ff ff ff 	movl   $0xffffffff,0x4(%ecx)
}
     f65:	5b                   	pop    %ebx
     f66:	5e                   	pop    %esi
     f67:	5f                   	pop    %edi
     f68:	5d                   	pop    %ebp
     f69:	c3                   	ret
     f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     f70:	c7 82 44 1d 00 00 01 	movl   $0x1,0x1d44(%edx)
     f77:	00 00 00 
            m->owner = next_tid;
     f7a:	89 59 04             	mov    %ebx,0x4(%ecx)
}
     f7d:	5b                   	pop    %ebx
     f7e:	5e                   	pop    %esi
     f7f:	5f                   	pop    %edi
     f80:	5d                   	pop    %ebp
     f81:	c3                   	ret
     f82:	66 90                	xchg   %ax,%ax
     f84:	66 90                	xchg   %ax,%ax
     f86:	66 90                	xchg   %ax,%ax
     f88:	66 90                	xchg   %ax,%ax
     f8a:	66 90                	xchg   %ax,%ax
     f8c:	66 90                	xchg   %ax,%ax
     f8e:	66 90                	xchg   %ax,%ax

00000f90 <channel_create>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

channel_t *
channel_create(int capacity)
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
     f93:	56                   	push   %esi
     f94:	53                   	push   %ebx
     f95:	8b 75 08             	mov    0x8(%ebp),%esi
    channel_t *ch = malloc(sizeof(channel_t));
     f98:	83 ec 0c             	sub    $0xc,%esp
     f9b:	68 ec 00 00 00       	push   $0xec
     fa0:	e8 9b f8 ff ff       	call   840 <malloc>
    if (!ch)
     fa5:	83 c4 10             	add    $0x10,%esp
     fa8:	85 c0                	test   %eax,%eax
     faa:	0f 84 7c 00 00 00    	je     102c <channel_create+0x9c>
        return 0;

    ch->buffer = malloc(sizeof(void *) * capacity);
     fb0:	83 ec 0c             	sub    $0xc,%esp
     fb3:	89 c3                	mov    %eax,%ebx
     fb5:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
     fbc:	50                   	push   %eax
     fbd:	e8 7e f8 ff ff       	call   840 <malloc>
    if (!ch->buffer) {
     fc2:	83 c4 10             	add    $0x10,%esp
    ch->buffer = malloc(sizeof(void *) * capacity);
     fc5:	89 03                	mov    %eax,(%ebx)
    if (!ch->buffer) {
     fc7:	85 c0                	test   %eax,%eax
     fc9:	74 55                	je     1020 <channel_create+0x90>
    ch->count = 0;
    ch->head = 0;
    ch->tail = 0;
    ch->closed = 0;

    mutex_init(&ch->lock);
     fcb:	83 ec 0c             	sub    $0xc,%esp
     fce:	8d 43 18             	lea    0x18(%ebx),%eax
    ch->capacity = capacity;
     fd1:	89 73 04             	mov    %esi,0x4(%ebx)
    ch->count = 0;
     fd4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    ch->head = 0;
     fdb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    ch->tail = 0;
     fe2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    ch->closed = 0;
     fe9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    mutex_init(&ch->lock);
     ff0:	50                   	push   %eax
     ff1:	e8 6a fe ff ff       	call   e60 <mutex_init>
    cond_init(&ch->not_empty);
     ff6:	8d 43 64             	lea    0x64(%ebx),%eax
     ff9:	89 04 24             	mov    %eax,(%esp)
     ffc:	e8 3f fd ff ff       	call   d40 <cond_init>
    cond_init(&ch->not_full);
    1001:	8d 83 a8 00 00 00    	lea    0xa8(%ebx),%eax
    1007:	89 04 24             	mov    %eax,(%esp)
    100a:	e8 31 fd ff ff       	call   d40 <cond_init>

    return ch;
    100f:	83 c4 10             	add    $0x10,%esp
}
    1012:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1015:	89 d8                	mov    %ebx,%eax
    1017:	5b                   	pop    %ebx
    1018:	5e                   	pop    %esi
    1019:	5d                   	pop    %ebp
    101a:	c3                   	ret
    101b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        free(ch);
    1020:	83 ec 0c             	sub    $0xc,%esp
    1023:	53                   	push   %ebx
    1024:	e8 87 f7 ff ff       	call   7b0 <free>
        return 0;
    1029:	83 c4 10             	add    $0x10,%esp
        return 0;
    102c:	31 db                	xor    %ebx,%ebx
    102e:	eb e2                	jmp    1012 <channel_create+0x82>

00001030 <channel_send>:

int
channel_send(channel_t *ch, void *data)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	57                   	push   %edi
    1034:	56                   	push   %esi
    1035:	53                   	push   %ebx
    1036:	83 ec 18             	sub    $0x18,%esp
    1039:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
    103c:	8d 73 18             	lea    0x18(%ebx),%esi
    103f:	8d bb a8 00 00 00    	lea    0xa8(%ebx),%edi
    1045:	56                   	push   %esi
    1046:	e8 35 fe ff ff       	call   e80 <mutex_lock>

    while (ch->count == ch->capacity && !ch->closed)
    104b:	8b 43 04             	mov    0x4(%ebx),%eax
    104e:	83 c4 10             	add    $0x10,%esp
    1051:	39 43 08             	cmp    %eax,0x8(%ebx)
    1054:	74 1f                	je     1075 <channel_send+0x45>
    1056:	eb 38                	jmp    1090 <channel_send+0x60>
    1058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    105f:	00 
        cond_wait(&ch->not_full, &ch->lock);
    1060:	83 ec 08             	sub    $0x8,%esp
    1063:	56                   	push   %esi
    1064:	57                   	push   %edi
    1065:	e8 e6 fc ff ff       	call   d50 <cond_wait>
    while (ch->count == ch->capacity && !ch->closed)
    106a:	8b 43 04             	mov    0x4(%ebx),%eax
    106d:	83 c4 10             	add    $0x10,%esp
    1070:	39 43 08             	cmp    %eax,0x8(%ebx)
    1073:	75 1b                	jne    1090 <channel_send+0x60>
    1075:	8b 43 14             	mov    0x14(%ebx),%eax
    1078:	85 c0                	test   %eax,%eax
    107a:	74 e4                	je     1060 <channel_send+0x30>

    if (ch->closed) {
        mutex_unlock(&ch->lock);
    107c:	83 ec 0c             	sub    $0xc,%esp
        return -1;
    107f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        mutex_unlock(&ch->lock);
    1084:	56                   	push   %esi
    1085:	e8 66 fe ff ff       	call   ef0 <mutex_unlock>
        return -1;
    108a:	83 c4 10             	add    $0x10,%esp
    108d:	eb 3b                	jmp    10ca <channel_send+0x9a>
    108f:	90                   	nop
    if (ch->closed) {
    1090:	8b 7b 14             	mov    0x14(%ebx),%edi
    1093:	85 ff                	test   %edi,%edi
    1095:	75 e5                	jne    107c <channel_send+0x4c>
    }

    ch->buffer[ch->tail] = data;
    1097:	8b 53 10             	mov    0x10(%ebx),%edx
    109a:	8b 03                	mov    (%ebx),%eax
    ch->tail = (ch->tail + 1) % ch->capacity;
    ch->count++;

    cond_signal(&ch->not_empty);
    109c:	83 ec 0c             	sub    $0xc,%esp
    ch->buffer[ch->tail] = data;
    109f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    10a2:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    ch->tail = (ch->tail + 1) % ch->capacity;
    10a5:	8b 43 10             	mov    0x10(%ebx),%eax
    ch->count++;
    10a8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    ch->tail = (ch->tail + 1) % ch->capacity;
    10ac:	83 c0 01             	add    $0x1,%eax
    10af:	99                   	cltd
    10b0:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_empty);
    10b3:	83 c3 64             	add    $0x64,%ebx
    ch->tail = (ch->tail + 1) % ch->capacity;
    10b6:	89 53 ac             	mov    %edx,-0x54(%ebx)
    cond_signal(&ch->not_empty);
    10b9:	53                   	push   %ebx
    10ba:	e8 e1 fc ff ff       	call   da0 <cond_signal>
    mutex_unlock(&ch->lock);
    10bf:	89 34 24             	mov    %esi,(%esp)
    10c2:	e8 29 fe ff ff       	call   ef0 <mutex_unlock>
    return 0;
    10c7:	83 c4 10             	add    $0x10,%esp
}
    10ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10cd:	89 f8                	mov    %edi,%eax
    10cf:	5b                   	pop    %ebx
    10d0:	5e                   	pop    %esi
    10d1:	5f                   	pop    %edi
    10d2:	5d                   	pop    %ebp
    10d3:	c3                   	ret
    10d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10db:	00 
    10dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000010e0 <channel_recv>:

int
channel_recv(channel_t *ch, void **data)
{
    10e0:	55                   	push   %ebp
    10e1:	89 e5                	mov    %esp,%ebp
    10e3:	57                   	push   %edi
    10e4:	56                   	push   %esi
    10e5:	53                   	push   %ebx
    10e6:	83 ec 18             	sub    $0x18,%esp
    10e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
    10ec:	8d 73 18             	lea    0x18(%ebx),%esi
    10ef:	8d 7b 64             	lea    0x64(%ebx),%edi
    10f2:	56                   	push   %esi
    10f3:	e8 88 fd ff ff       	call   e80 <mutex_lock>

    while (ch->count == 0 && !ch->closed)
    10f8:	8b 4b 08             	mov    0x8(%ebx),%ecx
    10fb:	83 c4 10             	add    $0x10,%esp
    10fe:	85 c9                	test   %ecx,%ecx
    1100:	74 1a                	je     111c <channel_recv+0x3c>
    1102:	eb 3c                	jmp    1140 <channel_recv+0x60>
    1104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&ch->not_empty, &ch->lock);
    1108:	83 ec 08             	sub    $0x8,%esp
    110b:	56                   	push   %esi
    110c:	57                   	push   %edi
    110d:	e8 3e fc ff ff       	call   d50 <cond_wait>
    while (ch->count == 0 && !ch->closed)
    1112:	8b 53 08             	mov    0x8(%ebx),%edx
    1115:	83 c4 10             	add    $0x10,%esp
    1118:	85 d2                	test   %edx,%edx
    111a:	75 24                	jne    1140 <channel_recv+0x60>
    111c:	8b 43 14             	mov    0x14(%ebx),%eax
    111f:	85 c0                	test   %eax,%eax
    1121:	74 e5                	je     1108 <channel_recv+0x28>

    if (ch->count == 0 && ch->closed) {
        mutex_unlock(&ch->lock);
    1123:	83 ec 0c             	sub    $0xc,%esp
    1126:	56                   	push   %esi
    1127:	e8 c4 fd ff ff       	call   ef0 <mutex_unlock>
        return -1;
    112c:	83 c4 10             	add    $0x10,%esp
    112f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1134:	eb 47                	jmp    117d <channel_recv+0x9d>
    1136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    113d:	00 
    113e:	66 90                	xchg   %ax,%ax
    }

    *data = ch->buffer[ch->head];
    1140:	8b 53 0c             	mov    0xc(%ebx),%edx
    1143:	8b 03                	mov    (%ebx),%eax
    ch->head = (ch->head + 1) % ch->capacity;
    ch->count--;

    cond_signal(&ch->not_full);
    1145:	83 ec 0c             	sub    $0xc,%esp
    *data = ch->buffer[ch->head];
    1148:	8b 14 90             	mov    (%eax,%edx,4),%edx
    114b:	8b 45 0c             	mov    0xc(%ebp),%eax
    114e:	89 10                	mov    %edx,(%eax)
    ch->head = (ch->head + 1) % ch->capacity;
    1150:	8b 43 0c             	mov    0xc(%ebx),%eax
    ch->count--;
    1153:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    ch->head = (ch->head + 1) % ch->capacity;
    1157:	83 c0 01             	add    $0x1,%eax
    115a:	99                   	cltd
    115b:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_full);
    115e:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    ch->head = (ch->head + 1) % ch->capacity;
    1164:	89 93 64 ff ff ff    	mov    %edx,-0x9c(%ebx)
    cond_signal(&ch->not_full);
    116a:	53                   	push   %ebx
    116b:	e8 30 fc ff ff       	call   da0 <cond_signal>
    mutex_unlock(&ch->lock);
    1170:	89 34 24             	mov    %esi,(%esp)
    1173:	e8 78 fd ff ff       	call   ef0 <mutex_unlock>
    return 0;
    1178:	83 c4 10             	add    $0x10,%esp
    117b:	31 c0                	xor    %eax,%eax
}
    117d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1180:	5b                   	pop    %ebx
    1181:	5e                   	pop    %esi
    1182:	5f                   	pop    %edi
    1183:	5d                   	pop    %ebp
    1184:	c3                   	ret
    1185:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    118c:	00 
    118d:	8d 76 00             	lea    0x0(%esi),%esi

00001190 <channel_close>:

void
channel_close(channel_t *ch)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	56                   	push   %esi
    1194:	53                   	push   %ebx
    1195:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
    1198:	8d 73 18             	lea    0x18(%ebx),%esi
    119b:	83 ec 0c             	sub    $0xc,%esp
    119e:	56                   	push   %esi
    119f:	e8 dc fc ff ff       	call   e80 <mutex_lock>
    ch->closed = 1;
    cond_broadcast(&ch->not_empty);
    11a4:	8d 43 64             	lea    0x64(%ebx),%eax
    ch->closed = 1;
    11a7:	c7 43 14 01 00 00 00 	movl   $0x1,0x14(%ebx)
    cond_broadcast(&ch->not_full);
    11ae:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    cond_broadcast(&ch->not_empty);
    11b4:	89 04 24             	mov    %eax,(%esp)
    11b7:	e8 54 fc ff ff       	call   e10 <cond_broadcast>
    cond_broadcast(&ch->not_full);
    11bc:	89 1c 24             	mov    %ebx,(%esp)
    11bf:	e8 4c fc ff ff       	call   e10 <cond_broadcast>
    mutex_unlock(&ch->lock);
    11c4:	83 c4 10             	add    $0x10,%esp
    11c7:	89 75 08             	mov    %esi,0x8(%ebp)
}
    11ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11cd:	5b                   	pop    %ebx
    11ce:	5e                   	pop    %esi
    11cf:	5d                   	pop    %ebp
    mutex_unlock(&ch->lock);
    11d0:	e9 1b fd ff ff       	jmp    ef0 <mutex_unlock>
    11d5:	66 90                	xchg   %ax,%ax
    11d7:	66 90                	xchg   %ax,%ax
    11d9:	66 90                	xchg   %ax,%ax
    11db:	66 90                	xchg   %ax,%ax
    11dd:	66 90                	xchg   %ax,%ax
    11df:	90                   	nop

000011e0 <rwlock_init>:
#include "types.h"
#include "uthreads.h"

void
rwlock_init(rwlock_t *l)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	53                   	push   %ebx
    11e4:	83 ec 10             	sub    $0x10,%esp
    11e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_init(&l->m);
    11ea:	53                   	push   %ebx
    11eb:	e8 70 fc ff ff       	call   e60 <mutex_init>
    cond_init(&l->can_read);
    11f0:	8d 43 4c             	lea    0x4c(%ebx),%eax
    11f3:	89 04 24             	mov    %eax,(%esp)
    11f6:	e8 45 fb ff ff       	call   d40 <cond_init>
    cond_init(&l->can_write);
    11fb:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1201:	89 04 24             	mov    %eax,(%esp)
    1204:	e8 37 fb ff ff       	call   d40 <cond_init>
    l->readers = 0;
    l->writers_wait = 0;
    l->writer_active = 0;
}
    1209:	83 c4 10             	add    $0x10,%esp
    l->readers = 0;
    120c:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%ebx)
    1213:	00 00 00 
    l->writers_wait = 0;
    1216:	c7 83 d8 00 00 00 00 	movl   $0x0,0xd8(%ebx)
    121d:	00 00 00 
    l->writer_active = 0;
    1220:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    1227:	00 00 00 
}
    122a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    122d:	c9                   	leave
    122e:	c3                   	ret
    122f:	90                   	nop

00001230 <reader_lock>:
//     mutex_unlock(&l->m);
// }

void
reader_lock(rwlock_t *l)
{
    1230:	55                   	push   %ebp
    1231:	89 e5                	mov    %esp,%ebp
    1233:	56                   	push   %esi
    1234:	53                   	push   %ebx
    1235:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    1238:	83 ec 0c             	sub    $0xc,%esp
    123b:	53                   	push   %ebx
    123c:	e8 3f fc ff ff       	call   e80 <mutex_lock>
    while (l->writer_active)
    1241:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    1247:	83 c4 10             	add    $0x10,%esp
    124a:	85 d2                	test   %edx,%edx
    124c:	74 21                	je     126f <reader_lock+0x3f>
    124e:	8d 73 4c             	lea    0x4c(%ebx),%esi
    1251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_read, &l->m);
    1258:	83 ec 08             	sub    $0x8,%esp
    125b:	53                   	push   %ebx
    125c:	56                   	push   %esi
    125d:	e8 ee fa ff ff       	call   d50 <cond_wait>
    while (l->writer_active)
    1262:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
    1268:	83 c4 10             	add    $0x10,%esp
    126b:	85 c0                	test   %eax,%eax
    126d:	75 e9                	jne    1258 <reader_lock+0x28>
    l->readers++;
    126f:	83 83 d4 00 00 00 01 	addl   $0x1,0xd4(%ebx)
    mutex_unlock(&l->m);
    1276:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1279:	8d 65 f8             	lea    -0x8(%ebp),%esp
    127c:	5b                   	pop    %ebx
    127d:	5e                   	pop    %esi
    127e:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    127f:	e9 6c fc ff ff       	jmp    ef0 <mutex_unlock>
    1284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    128b:	00 
    128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001290 <reader_unlock>:


void
reader_unlock(rwlock_t *l)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	53                   	push   %ebx
    1294:	83 ec 10             	sub    $0x10,%esp
    1297:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    129a:	53                   	push   %ebx
    129b:	e8 e0 fb ff ff       	call   e80 <mutex_lock>
    l->readers--;
    12a0:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    if (l->readers == 0 && l->writers_wait > 0)
    12a6:	83 c4 10             	add    $0x10,%esp
    l->readers--;
    12a9:	83 e8 01             	sub    $0x1,%eax
    12ac:	89 83 d4 00 00 00    	mov    %eax,0xd4(%ebx)
    if (l->readers == 0 && l->writers_wait > 0)
    12b2:	85 c0                	test   %eax,%eax
    12b4:	75 0a                	jne    12c0 <reader_unlock+0x30>
    12b6:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    12bc:	85 c0                	test   %eax,%eax
    12be:	7f 10                	jg     12d0 <reader_unlock+0x40>
        cond_signal(&l->can_write);
    mutex_unlock(&l->m);
    12c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    12c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    12c6:	c9                   	leave
    mutex_unlock(&l->m);
    12c7:	e9 24 fc ff ff       	jmp    ef0 <mutex_unlock>
    12cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(&l->can_write);
    12d0:	83 ec 0c             	sub    $0xc,%esp
    12d3:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    12d9:	50                   	push   %eax
    12da:	e8 c1 fa ff ff       	call   da0 <cond_signal>
    12df:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    12e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    12e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    12e8:	c9                   	leave
    mutex_unlock(&l->m);
    12e9:	e9 02 fc ff ff       	jmp    ef0 <mutex_unlock>
    12ee:	66 90                	xchg   %ax,%ax

000012f0 <writer_lock>:

void
writer_lock(rwlock_t *l)
{
    12f0:	55                   	push   %ebp
    12f1:	89 e5                	mov    %esp,%ebp
    12f3:	56                   	push   %esi
    12f4:	53                   	push   %ebx
    12f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    l->writers_wait++;
    while (l->writer_active || l->readers > 0)
        cond_wait(&l->can_write, &l->m);
    12f8:	8d b3 90 00 00 00    	lea    0x90(%ebx),%esi
    mutex_lock(&l->m);
    12fe:	83 ec 0c             	sub    $0xc,%esp
    1301:	53                   	push   %ebx
    1302:	e8 79 fb ff ff       	call   e80 <mutex_lock>
    l->writers_wait++;
    1307:	83 83 d8 00 00 00 01 	addl   $0x1,0xd8(%ebx)
    while (l->writer_active || l->readers > 0)
    130e:	83 c4 10             	add    $0x10,%esp
    1311:	eb 12                	jmp    1325 <writer_lock+0x35>
    1313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_write, &l->m);
    1318:	83 ec 08             	sub    $0x8,%esp
    131b:	53                   	push   %ebx
    131c:	56                   	push   %esi
    131d:	e8 2e fa ff ff       	call   d50 <cond_wait>
    1322:	83 c4 10             	add    $0x10,%esp
    while (l->writer_active || l->readers > 0)
    1325:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    132b:	85 d2                	test   %edx,%edx
    132d:	75 e9                	jne    1318 <writer_lock+0x28>
    132f:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    1335:	85 c0                	test   %eax,%eax
    1337:	7f df                	jg     1318 <writer_lock+0x28>
    l->writers_wait--;
    1339:	83 ab d8 00 00 00 01 	subl   $0x1,0xd8(%ebx)
    l->writer_active = 1;
    1340:	c7 83 dc 00 00 00 01 	movl   $0x1,0xdc(%ebx)
    1347:	00 00 00 
    mutex_unlock(&l->m);
    134a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    134d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1350:	5b                   	pop    %ebx
    1351:	5e                   	pop    %esi
    1352:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    1353:	e9 98 fb ff ff       	jmp    ef0 <mutex_unlock>
    1358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    135f:	00 

00001360 <writer_unlock>:

void
writer_unlock(rwlock_t *l)
{
    1360:	55                   	push   %ebp
    1361:	89 e5                	mov    %esp,%ebp
    1363:	53                   	push   %ebx
    1364:	83 ec 10             	sub    $0x10,%esp
    1367:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    136a:	53                   	push   %ebx
    136b:	e8 10 fb ff ff       	call   e80 <mutex_lock>
    l->writer_active = 0;
    if (l->writers_wait > 0)
    1370:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    1376:	83 c4 10             	add    $0x10,%esp
    l->writer_active = 0;
    1379:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    1380:	00 00 00 
    if (l->writers_wait > 0)
    1383:	85 c0                	test   %eax,%eax
    1385:	7e 21                	jle    13a8 <writer_unlock+0x48>
        cond_signal(&l->can_write);
    1387:	83 ec 0c             	sub    $0xc,%esp
    138a:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1390:	50                   	push   %eax
    1391:	e8 0a fa ff ff       	call   da0 <cond_signal>
    1396:	83 c4 10             	add    $0x10,%esp
    else
        cond_broadcast(&l->can_read);
    mutex_unlock(&l->m);
    1399:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    139c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    139f:	c9                   	leave
    mutex_unlock(&l->m);
    13a0:	e9 4b fb ff ff       	jmp    ef0 <mutex_unlock>
    13a5:	8d 76 00             	lea    0x0(%esi),%esi
        cond_broadcast(&l->can_read);
    13a8:	83 ec 0c             	sub    $0xc,%esp
    13ab:	8d 43 4c             	lea    0x4c(%ebx),%eax
    13ae:	50                   	push   %eax
    13af:	e8 5c fa ff ff       	call   e10 <cond_broadcast>
    13b4:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    13b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    13ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13bd:	c9                   	leave
    mutex_unlock(&l->m);
    13be:	e9 2d fb ff ff       	jmp    ef0 <mutex_unlock>
