
_t_counter:     file format elf32-i386


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
       d:	56                   	push   %esi
       e:	53                   	push   %ebx
       f:	8d 75 e8             	lea    -0x18(%ebp),%esi
      12:	8d 5d dc             	lea    -0x24(%ebp),%ebx
      15:	51                   	push   %ecx
      16:	83 ec 1c             	sub    $0x1c,%esp
    thread_init();
      19:	e8 42 07 00 00       	call   760 <thread_init>
    mutex_init(&m);
      1e:	83 ec 0c             	sub    $0xc,%esp
      21:	68 a0 19 00 00       	push   $0x19a0
      26:	e8 65 0c 00 00       	call   c90 <mutex_init>

    int tids[T];
    for (int i = 0; i < T; i++)
      2b:	83 c4 10             	add    $0x10,%esp
        tids[i] = thread_create(worker, 0);
      2e:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < T; i++)
      31:	83 c3 04             	add    $0x4,%ebx
        tids[i] = thread_create(worker, 0);
      34:	6a 00                	push   $0x0
      36:	68 90 00 00 00       	push   $0x90
      3b:	e8 b0 07 00 00       	call   7f0 <thread_create>
    for (int i = 0; i < T; i++)
      40:	83 c4 10             	add    $0x10,%esp
        tids[i] = thread_create(worker, 0);
      43:	89 43 fc             	mov    %eax,-0x4(%ebx)
    for (int i = 0; i < T; i++)
      46:	39 f3                	cmp    %esi,%ebx
      48:	75 e4                	jne    2e <main+0x2e>

    for (int i = 0; i < T; i++)
        thread_join(tids[i]);
      4a:	83 ec 0c             	sub    $0xc,%esp
      4d:	ff 75 dc             	push   -0x24(%ebp)
      50:	e8 8b 09 00 00       	call   9e0 <thread_join>
      55:	58                   	pop    %eax
      56:	ff 75 e0             	push   -0x20(%ebp)
      59:	e8 82 09 00 00       	call   9e0 <thread_join>
      5e:	5a                   	pop    %edx
      5f:	ff 75 e4             	push   -0x1c(%ebp)
      62:	e8 79 09 00 00       	call   9e0 <thread_join>

    printf(1, "counter = %d (expected %d)\n", counter, T * N);
      67:	68 b8 0b 00 00       	push   $0xbb8
      6c:	ff 35 ec 19 00 00    	push   0x19ec
      72:	68 f4 11 00 00       	push   $0x11f4
      77:	6a 01                	push   $0x1
      79:	e8 d2 03 00 00       	call   450 <printf>
    exit();
      7e:	83 c4 20             	add    $0x20,%esp
      81:	e8 7d 02 00 00       	call   303 <exit>
      86:	66 90                	xchg   %ax,%ax
      88:	66 90                	xchg   %ax,%ax
      8a:	66 90                	xchg   %ax,%ax
      8c:	66 90                	xchg   %ax,%ax
      8e:	66 90                	xchg   %ax,%ax

00000090 <worker>:
{
      90:	55                   	push   %ebp
      91:	89 e5                	mov    %esp,%ebp
      93:	56                   	push   %esi
        int tmp = counter;
      94:	8b 35 ec 19 00 00    	mov    0x19ec,%esi
{
      9a:	53                   	push   %ebx
      9b:	8d 5e 01             	lea    0x1(%esi),%ebx
      9e:	81 c6 e9 03 00 00    	add    $0x3e9,%esi
      a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        thread_yield();
      a8:	e8 b3 08 00 00       	call   960 <thread_yield>
        counter = tmp + 1;
      ad:	89 1d ec 19 00 00    	mov    %ebx,0x19ec
    for (int i = 0; i < N; i++) {
      b3:	83 c3 01             	add    $0x1,%ebx
      b6:	39 f3                	cmp    %esi,%ebx
      b8:	75 ee                	jne    a8 <worker+0x18>
}
      ba:	5b                   	pop    %ebx
      bb:	31 c0                	xor    %eax,%eax
      bd:	5e                   	pop    %esi
      be:	5d                   	pop    %ebp
      bf:	c3                   	ret

000000c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
      c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
      c1:	31 c0                	xor    %eax,%eax
{
      c3:	89 e5                	mov    %esp,%ebp
      c5:	53                   	push   %ebx
      c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
      c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
      cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
      d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
      d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
      d7:	83 c0 01             	add    $0x1,%eax
      da:	84 d2                	test   %dl,%dl
      dc:	75 f2                	jne    d0 <strcpy+0x10>
    ;
  return os;
}
      de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      e1:	89 c8                	mov    %ecx,%eax
      e3:	c9                   	leave
      e4:	c3                   	ret
      e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
      ec:	00 
      ed:	8d 76 00             	lea    0x0(%esi),%esi

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
      f0:	55                   	push   %ebp
      f1:	89 e5                	mov    %esp,%ebp
      f3:	53                   	push   %ebx
      f4:	8b 55 08             	mov    0x8(%ebp),%edx
      f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
      fa:	0f b6 02             	movzbl (%edx),%eax
      fd:	84 c0                	test   %al,%al
      ff:	75 17                	jne    118 <strcmp+0x28>
     101:	eb 3a                	jmp    13d <strcmp+0x4d>
     103:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     108:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     10c:	83 c2 01             	add    $0x1,%edx
     10f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     112:	84 c0                	test   %al,%al
     114:	74 1a                	je     130 <strcmp+0x40>
     116:	89 d9                	mov    %ebx,%ecx
     118:	0f b6 19             	movzbl (%ecx),%ebx
     11b:	38 c3                	cmp    %al,%bl
     11d:	74 e9                	je     108 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     11f:	29 d8                	sub    %ebx,%eax
}
     121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     124:	c9                   	leave
     125:	c3                   	ret
     126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     12d:	00 
     12e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     130:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     134:	31 c0                	xor    %eax,%eax
     136:	29 d8                	sub    %ebx,%eax
}
     138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     13b:	c9                   	leave
     13c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     13d:	0f b6 19             	movzbl (%ecx),%ebx
     140:	31 c0                	xor    %eax,%eax
     142:	eb db                	jmp    11f <strcmp+0x2f>
     144:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     14b:	00 
     14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000150 <strlen>:

uint
strlen(const char *s)
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     156:	80 3a 00             	cmpb   $0x0,(%edx)
     159:	74 15                	je     170 <strlen+0x20>
     15b:	31 c0                	xor    %eax,%eax
     15d:	8d 76 00             	lea    0x0(%esi),%esi
     160:	83 c0 01             	add    $0x1,%eax
     163:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     167:	89 c1                	mov    %eax,%ecx
     169:	75 f5                	jne    160 <strlen+0x10>
    ;
  return n;
}
     16b:	89 c8                	mov    %ecx,%eax
     16d:	5d                   	pop    %ebp
     16e:	c3                   	ret
     16f:	90                   	nop
  for(n = 0; s[n]; n++)
     170:	31 c9                	xor    %ecx,%ecx
}
     172:	5d                   	pop    %ebp
     173:	89 c8                	mov    %ecx,%eax
     175:	c3                   	ret
     176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     17d:	00 
     17e:	66 90                	xchg   %ax,%ax

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
     180:	55                   	push   %ebp
     181:	89 e5                	mov    %esp,%ebp
     183:	57                   	push   %edi
     184:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     187:	8b 4d 10             	mov    0x10(%ebp),%ecx
     18a:	8b 45 0c             	mov    0xc(%ebp),%eax
     18d:	89 d7                	mov    %edx,%edi
     18f:	fc                   	cld
     190:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     192:	8b 7d fc             	mov    -0x4(%ebp),%edi
     195:	89 d0                	mov    %edx,%eax
     197:	c9                   	leave
     198:	c3                   	ret
     199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
     1a0:	55                   	push   %ebp
     1a1:	89 e5                	mov    %esp,%ebp
     1a3:	8b 45 08             	mov    0x8(%ebp),%eax
     1a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     1aa:	0f b6 10             	movzbl (%eax),%edx
     1ad:	84 d2                	test   %dl,%dl
     1af:	75 12                	jne    1c3 <strchr+0x23>
     1b1:	eb 1d                	jmp    1d0 <strchr+0x30>
     1b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     1b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     1bc:	83 c0 01             	add    $0x1,%eax
     1bf:	84 d2                	test   %dl,%dl
     1c1:	74 0d                	je     1d0 <strchr+0x30>
    if(*s == c)
     1c3:	38 d1                	cmp    %dl,%cl
     1c5:	75 f1                	jne    1b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
     1c7:	5d                   	pop    %ebp
     1c8:	c3                   	ret
     1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     1d0:	31 c0                	xor    %eax,%eax
}
     1d2:	5d                   	pop    %ebp
     1d3:	c3                   	ret
     1d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     1db:	00 
     1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001e0 <gets>:

char*
gets(char *buf, int max)
{
     1e0:	55                   	push   %ebp
     1e1:	89 e5                	mov    %esp,%ebp
     1e3:	57                   	push   %edi
     1e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     1e5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
     1e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     1e9:	31 db                	xor    %ebx,%ebx
{
     1eb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     1ee:	eb 27                	jmp    217 <gets+0x37>
    cc = read(0, &c, 1);
     1f0:	83 ec 04             	sub    $0x4,%esp
     1f3:	6a 01                	push   $0x1
     1f5:	56                   	push   %esi
     1f6:	6a 00                	push   $0x0
     1f8:	e8 1e 01 00 00       	call   31b <read>
    if(cc < 1)
     1fd:	83 c4 10             	add    $0x10,%esp
     200:	85 c0                	test   %eax,%eax
     202:	7e 1d                	jle    221 <gets+0x41>
      break;
    buf[i++] = c;
     204:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     208:	8b 55 08             	mov    0x8(%ebp),%edx
     20b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     20f:	3c 0a                	cmp    $0xa,%al
     211:	74 10                	je     223 <gets+0x43>
     213:	3c 0d                	cmp    $0xd,%al
     215:	74 0c                	je     223 <gets+0x43>
  for(i=0; i+1 < max; ){
     217:	89 df                	mov    %ebx,%edi
     219:	83 c3 01             	add    $0x1,%ebx
     21c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     21f:	7c cf                	jl     1f0 <gets+0x10>
     221:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
     223:	8b 45 08             	mov    0x8(%ebp),%eax
     226:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
     22a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     22d:	5b                   	pop    %ebx
     22e:	5e                   	pop    %esi
     22f:	5f                   	pop    %edi
     230:	5d                   	pop    %ebp
     231:	c3                   	ret
     232:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     239:	00 
     23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <stat>:

int
stat(const char *n, struct stat *st)
{
     240:	55                   	push   %ebp
     241:	89 e5                	mov    %esp,%ebp
     243:	56                   	push   %esi
     244:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     245:	83 ec 08             	sub    $0x8,%esp
     248:	6a 00                	push   $0x0
     24a:	ff 75 08             	push   0x8(%ebp)
     24d:	e8 f1 00 00 00       	call   343 <open>
  if(fd < 0)
     252:	83 c4 10             	add    $0x10,%esp
     255:	85 c0                	test   %eax,%eax
     257:	78 27                	js     280 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     259:	83 ec 08             	sub    $0x8,%esp
     25c:	ff 75 0c             	push   0xc(%ebp)
     25f:	89 c3                	mov    %eax,%ebx
     261:	50                   	push   %eax
     262:	e8 f4 00 00 00       	call   35b <fstat>
  close(fd);
     267:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     26a:	89 c6                	mov    %eax,%esi
  close(fd);
     26c:	e8 ba 00 00 00       	call   32b <close>
  return r;
     271:	83 c4 10             	add    $0x10,%esp
}
     274:	8d 65 f8             	lea    -0x8(%ebp),%esp
     277:	89 f0                	mov    %esi,%eax
     279:	5b                   	pop    %ebx
     27a:	5e                   	pop    %esi
     27b:	5d                   	pop    %ebp
     27c:	c3                   	ret
     27d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     280:	be ff ff ff ff       	mov    $0xffffffff,%esi
     285:	eb ed                	jmp    274 <stat+0x34>
     287:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     28e:	00 
     28f:	90                   	nop

00000290 <atoi>:

int
atoi(const char *s)
{
     290:	55                   	push   %ebp
     291:	89 e5                	mov    %esp,%ebp
     293:	53                   	push   %ebx
     294:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     297:	0f be 02             	movsbl (%edx),%eax
     29a:	8d 48 d0             	lea    -0x30(%eax),%ecx
     29d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     2a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     2a5:	77 1e                	ja     2c5 <atoi+0x35>
     2a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     2ae:	00 
     2af:	90                   	nop
    n = n*10 + *s++ - '0';
     2b0:	83 c2 01             	add    $0x1,%edx
     2b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     2b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     2ba:	0f be 02             	movsbl (%edx),%eax
     2bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
     2c0:	80 fb 09             	cmp    $0x9,%bl
     2c3:	76 eb                	jbe    2b0 <atoi+0x20>
  return n;
}
     2c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2c8:	89 c8                	mov    %ecx,%eax
     2ca:	c9                   	leave
     2cb:	c3                   	ret
     2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     2d0:	55                   	push   %ebp
     2d1:	89 e5                	mov    %esp,%ebp
     2d3:	57                   	push   %edi
     2d4:	8b 45 10             	mov    0x10(%ebp),%eax
     2d7:	8b 55 08             	mov    0x8(%ebp),%edx
     2da:	56                   	push   %esi
     2db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     2de:	85 c0                	test   %eax,%eax
     2e0:	7e 13                	jle    2f5 <memmove+0x25>
     2e2:	01 d0                	add    %edx,%eax
  dst = vdst;
     2e4:	89 d7                	mov    %edx,%edi
     2e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     2ed:	00 
     2ee:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     2f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     2f1:	39 f8                	cmp    %edi,%eax
     2f3:	75 fb                	jne    2f0 <memmove+0x20>
  return vdst;
}
     2f5:	5e                   	pop    %esi
     2f6:	89 d0                	mov    %edx,%eax
     2f8:	5f                   	pop    %edi
     2f9:	5d                   	pop    %ebp
     2fa:	c3                   	ret

000002fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     2fb:	b8 01 00 00 00       	mov    $0x1,%eax
     300:	cd 40                	int    $0x40
     302:	c3                   	ret

00000303 <exit>:
SYSCALL(exit)
     303:	b8 02 00 00 00       	mov    $0x2,%eax
     308:	cd 40                	int    $0x40
     30a:	c3                   	ret

0000030b <wait>:
SYSCALL(wait)
     30b:	b8 03 00 00 00       	mov    $0x3,%eax
     310:	cd 40                	int    $0x40
     312:	c3                   	ret

00000313 <pipe>:
SYSCALL(pipe)
     313:	b8 04 00 00 00       	mov    $0x4,%eax
     318:	cd 40                	int    $0x40
     31a:	c3                   	ret

0000031b <read>:
SYSCALL(read)
     31b:	b8 05 00 00 00       	mov    $0x5,%eax
     320:	cd 40                	int    $0x40
     322:	c3                   	ret

00000323 <write>:
SYSCALL(write)
     323:	b8 10 00 00 00       	mov    $0x10,%eax
     328:	cd 40                	int    $0x40
     32a:	c3                   	ret

0000032b <close>:
SYSCALL(close)
     32b:	b8 15 00 00 00       	mov    $0x15,%eax
     330:	cd 40                	int    $0x40
     332:	c3                   	ret

00000333 <kill>:
SYSCALL(kill)
     333:	b8 06 00 00 00       	mov    $0x6,%eax
     338:	cd 40                	int    $0x40
     33a:	c3                   	ret

0000033b <exec>:
SYSCALL(exec)
     33b:	b8 07 00 00 00       	mov    $0x7,%eax
     340:	cd 40                	int    $0x40
     342:	c3                   	ret

00000343 <open>:
SYSCALL(open)
     343:	b8 0f 00 00 00       	mov    $0xf,%eax
     348:	cd 40                	int    $0x40
     34a:	c3                   	ret

0000034b <mknod>:
SYSCALL(mknod)
     34b:	b8 11 00 00 00       	mov    $0x11,%eax
     350:	cd 40                	int    $0x40
     352:	c3                   	ret

00000353 <unlink>:
SYSCALL(unlink)
     353:	b8 12 00 00 00       	mov    $0x12,%eax
     358:	cd 40                	int    $0x40
     35a:	c3                   	ret

0000035b <fstat>:
SYSCALL(fstat)
     35b:	b8 08 00 00 00       	mov    $0x8,%eax
     360:	cd 40                	int    $0x40
     362:	c3                   	ret

00000363 <link>:
SYSCALL(link)
     363:	b8 13 00 00 00       	mov    $0x13,%eax
     368:	cd 40                	int    $0x40
     36a:	c3                   	ret

0000036b <mkdir>:
SYSCALL(mkdir)
     36b:	b8 14 00 00 00       	mov    $0x14,%eax
     370:	cd 40                	int    $0x40
     372:	c3                   	ret

00000373 <chdir>:
SYSCALL(chdir)
     373:	b8 09 00 00 00       	mov    $0x9,%eax
     378:	cd 40                	int    $0x40
     37a:	c3                   	ret

0000037b <dup>:
SYSCALL(dup)
     37b:	b8 0a 00 00 00       	mov    $0xa,%eax
     380:	cd 40                	int    $0x40
     382:	c3                   	ret

00000383 <getpid>:
SYSCALL(getpid)
     383:	b8 0b 00 00 00       	mov    $0xb,%eax
     388:	cd 40                	int    $0x40
     38a:	c3                   	ret

0000038b <sbrk>:
SYSCALL(sbrk)
     38b:	b8 0c 00 00 00       	mov    $0xc,%eax
     390:	cd 40                	int    $0x40
     392:	c3                   	ret

00000393 <sleep>:
SYSCALL(sleep)
     393:	b8 0d 00 00 00       	mov    $0xd,%eax
     398:	cd 40                	int    $0x40
     39a:	c3                   	ret

0000039b <uptime>:
SYSCALL(uptime)
     39b:	b8 0e 00 00 00       	mov    $0xe,%eax
     3a0:	cd 40                	int    $0x40
     3a2:	c3                   	ret
     3a3:	66 90                	xchg   %ax,%ax
     3a5:	66 90                	xchg   %ax,%ax
     3a7:	66 90                	xchg   %ax,%ax
     3a9:	66 90                	xchg   %ax,%ax
     3ab:	66 90                	xchg   %ax,%ax
     3ad:	66 90                	xchg   %ax,%ax
     3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	57                   	push   %edi
     3b4:	56                   	push   %esi
     3b5:	53                   	push   %ebx
     3b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     3b8:	89 d1                	mov    %edx,%ecx
{
     3ba:	83 ec 3c             	sub    $0x3c,%esp
     3bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
     3c0:	85 d2                	test   %edx,%edx
     3c2:	0f 89 80 00 00 00    	jns    448 <printint+0x98>
     3c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     3cc:	74 7a                	je     448 <printint+0x98>
    x = -xx;
     3ce:	f7 d9                	neg    %ecx
    neg = 1;
     3d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
     3d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     3d8:	31 f6                	xor    %esi,%esi
     3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     3e0:	89 c8                	mov    %ecx,%eax
     3e2:	31 d2                	xor    %edx,%edx
     3e4:	89 f7                	mov    %esi,%edi
     3e6:	f7 f3                	div    %ebx
     3e8:	8d 76 01             	lea    0x1(%esi),%esi
     3eb:	0f b6 92 70 12 00 00 	movzbl 0x1270(%edx),%edx
     3f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
     3f6:	89 ca                	mov    %ecx,%edx
     3f8:	89 c1                	mov    %eax,%ecx
     3fa:	39 da                	cmp    %ebx,%edx
     3fc:	73 e2                	jae    3e0 <printint+0x30>
  if(neg)
     3fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     401:	85 c0                	test   %eax,%eax
     403:	74 07                	je     40c <printint+0x5c>
    buf[i++] = '-';
     405:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
     40a:	89 f7                	mov    %esi,%edi
     40c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
     40f:	8b 75 c0             	mov    -0x40(%ebp),%esi
     412:	01 df                	add    %ebx,%edi
     414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
     418:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
     41b:	83 ec 04             	sub    $0x4,%esp
     41e:	88 45 d7             	mov    %al,-0x29(%ebp)
     421:	8d 45 d7             	lea    -0x29(%ebp),%eax
     424:	6a 01                	push   $0x1
     426:	50                   	push   %eax
     427:	56                   	push   %esi
     428:	e8 f6 fe ff ff       	call   323 <write>
  while(--i >= 0)
     42d:	89 f8                	mov    %edi,%eax
     42f:	83 c4 10             	add    $0x10,%esp
     432:	83 ef 01             	sub    $0x1,%edi
     435:	39 c3                	cmp    %eax,%ebx
     437:	75 df                	jne    418 <printint+0x68>
}
     439:	8d 65 f4             	lea    -0xc(%ebp),%esp
     43c:	5b                   	pop    %ebx
     43d:	5e                   	pop    %esi
     43e:	5f                   	pop    %edi
     43f:	5d                   	pop    %ebp
     440:	c3                   	ret
     441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     448:	31 c0                	xor    %eax,%eax
     44a:	eb 89                	jmp    3d5 <printint+0x25>
     44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	57                   	push   %edi
     454:	56                   	push   %esi
     455:	53                   	push   %ebx
     456:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     459:	8b 75 0c             	mov    0xc(%ebp),%esi
{
     45c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
     45f:	0f b6 1e             	movzbl (%esi),%ebx
     462:	83 c6 01             	add    $0x1,%esi
     465:	84 db                	test   %bl,%bl
     467:	74 67                	je     4d0 <printf+0x80>
     469:	8d 4d 10             	lea    0x10(%ebp),%ecx
     46c:	31 d2                	xor    %edx,%edx
     46e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
     471:	eb 34                	jmp    4a7 <printf+0x57>
     473:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     478:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     47b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     480:	83 f8 25             	cmp    $0x25,%eax
     483:	74 18                	je     49d <printf+0x4d>
  write(fd, &c, 1);
     485:	83 ec 04             	sub    $0x4,%esp
     488:	8d 45 e7             	lea    -0x19(%ebp),%eax
     48b:	88 5d e7             	mov    %bl,-0x19(%ebp)
     48e:	6a 01                	push   $0x1
     490:	50                   	push   %eax
     491:	57                   	push   %edi
     492:	e8 8c fe ff ff       	call   323 <write>
     497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     49a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     49d:	0f b6 1e             	movzbl (%esi),%ebx
     4a0:	83 c6 01             	add    $0x1,%esi
     4a3:	84 db                	test   %bl,%bl
     4a5:	74 29                	je     4d0 <printf+0x80>
    c = fmt[i] & 0xff;
     4a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     4aa:	85 d2                	test   %edx,%edx
     4ac:	74 ca                	je     478 <printf+0x28>
      }
    } else if(state == '%'){
     4ae:	83 fa 25             	cmp    $0x25,%edx
     4b1:	75 ea                	jne    49d <printf+0x4d>
      if(c == 'd'){
     4b3:	83 f8 25             	cmp    $0x25,%eax
     4b6:	0f 84 04 01 00 00    	je     5c0 <printf+0x170>
     4bc:	83 e8 63             	sub    $0x63,%eax
     4bf:	83 f8 15             	cmp    $0x15,%eax
     4c2:	77 1c                	ja     4e0 <printf+0x90>
     4c4:	ff 24 85 18 12 00 00 	jmp    *0x1218(,%eax,4)
     4cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     4d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4d3:	5b                   	pop    %ebx
     4d4:	5e                   	pop    %esi
     4d5:	5f                   	pop    %edi
     4d6:	5d                   	pop    %ebp
     4d7:	c3                   	ret
     4d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     4df:	00 
  write(fd, &c, 1);
     4e0:	83 ec 04             	sub    $0x4,%esp
     4e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
     4e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     4ea:	6a 01                	push   $0x1
     4ec:	52                   	push   %edx
     4ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     4f0:	57                   	push   %edi
     4f1:	e8 2d fe ff ff       	call   323 <write>
     4f6:	83 c4 0c             	add    $0xc,%esp
     4f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
     4fc:	6a 01                	push   $0x1
     4fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     501:	52                   	push   %edx
     502:	57                   	push   %edi
     503:	e8 1b fe ff ff       	call   323 <write>
        putc(fd, c);
     508:	83 c4 10             	add    $0x10,%esp
      state = 0;
     50b:	31 d2                	xor    %edx,%edx
     50d:	eb 8e                	jmp    49d <printf+0x4d>
     50f:	90                   	nop
        printint(fd, *ap, 16, 0);
     510:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     513:	83 ec 0c             	sub    $0xc,%esp
     516:	b9 10 00 00 00       	mov    $0x10,%ecx
     51b:	8b 13                	mov    (%ebx),%edx
     51d:	6a 00                	push   $0x0
     51f:	89 f8                	mov    %edi,%eax
        ap++;
     521:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
     524:	e8 87 fe ff ff       	call   3b0 <printint>
        ap++;
     529:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     52c:	83 c4 10             	add    $0x10,%esp
      state = 0;
     52f:	31 d2                	xor    %edx,%edx
     531:	e9 67 ff ff ff       	jmp    49d <printf+0x4d>
        s = (char*)*ap;
     536:	8b 45 d0             	mov    -0x30(%ebp),%eax
     539:	8b 18                	mov    (%eax),%ebx
        ap++;
     53b:	83 c0 04             	add    $0x4,%eax
     53e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
     541:	85 db                	test   %ebx,%ebx
     543:	0f 84 87 00 00 00    	je     5d0 <printf+0x180>
        while(*s != 0){
     549:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
     54c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
     54e:	84 c0                	test   %al,%al
     550:	0f 84 47 ff ff ff    	je     49d <printf+0x4d>
     556:	8d 55 e7             	lea    -0x19(%ebp),%edx
     559:	89 75 d4             	mov    %esi,-0x2c(%ebp)
     55c:	89 de                	mov    %ebx,%esi
     55e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
     560:	83 ec 04             	sub    $0x4,%esp
     563:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
     566:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     569:	6a 01                	push   $0x1
     56b:	53                   	push   %ebx
     56c:	57                   	push   %edi
     56d:	e8 b1 fd ff ff       	call   323 <write>
        while(*s != 0){
     572:	0f b6 06             	movzbl (%esi),%eax
     575:	83 c4 10             	add    $0x10,%esp
     578:	84 c0                	test   %al,%al
     57a:	75 e4                	jne    560 <printf+0x110>
      state = 0;
     57c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
     57f:	31 d2                	xor    %edx,%edx
     581:	e9 17 ff ff ff       	jmp    49d <printf+0x4d>
        printint(fd, *ap, 10, 1);
     586:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     589:	83 ec 0c             	sub    $0xc,%esp
     58c:	b9 0a 00 00 00       	mov    $0xa,%ecx
     591:	8b 13                	mov    (%ebx),%edx
     593:	6a 01                	push   $0x1
     595:	eb 88                	jmp    51f <printf+0xcf>
        putc(fd, *ap);
     597:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
     59a:	83 ec 04             	sub    $0x4,%esp
     59d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
     5a0:	8b 03                	mov    (%ebx),%eax
        ap++;
     5a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
     5a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     5a8:	6a 01                	push   $0x1
     5aa:	52                   	push   %edx
     5ab:	57                   	push   %edi
     5ac:	e8 72 fd ff ff       	call   323 <write>
        ap++;
     5b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     5b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
     5b7:	31 d2                	xor    %edx,%edx
     5b9:	e9 df fe ff ff       	jmp    49d <printf+0x4d>
     5be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
     5c0:	83 ec 04             	sub    $0x4,%esp
     5c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
     5c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
     5c9:	6a 01                	push   $0x1
     5cb:	e9 31 ff ff ff       	jmp    501 <printf+0xb1>
     5d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
     5d5:	bb 10 12 00 00       	mov    $0x1210,%ebx
     5da:	e9 77 ff ff ff       	jmp    556 <printf+0x106>
     5df:	90                   	nop

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     5e1:	a1 f0 19 00 00       	mov    0x19f0,%eax
{
     5e6:	89 e5                	mov    %esp,%ebp
     5e8:	57                   	push   %edi
     5e9:	56                   	push   %esi
     5ea:	53                   	push   %ebx
     5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     5f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     5fa:	39 c8                	cmp    %ecx,%eax
     5fc:	73 32                	jae    630 <free+0x50>
     5fe:	39 d1                	cmp    %edx,%ecx
     600:	72 04                	jb     606 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     602:	39 d0                	cmp    %edx,%eax
     604:	72 32                	jb     638 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
     606:	8b 73 fc             	mov    -0x4(%ebx),%esi
     609:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     60c:	39 fa                	cmp    %edi,%edx
     60e:	74 30                	je     640 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     610:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     613:	8b 50 04             	mov    0x4(%eax),%edx
     616:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     619:	39 f1                	cmp    %esi,%ecx
     61b:	74 3a                	je     657 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     61d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
     61f:	5b                   	pop    %ebx
  freep = p;
     620:	a3 f0 19 00 00       	mov    %eax,0x19f0
}
     625:	5e                   	pop    %esi
     626:	5f                   	pop    %edi
     627:	5d                   	pop    %ebp
     628:	c3                   	ret
     629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     630:	39 d0                	cmp    %edx,%eax
     632:	72 04                	jb     638 <free+0x58>
     634:	39 d1                	cmp    %edx,%ecx
     636:	72 ce                	jb     606 <free+0x26>
{
     638:	89 d0                	mov    %edx,%eax
     63a:	eb bc                	jmp    5f8 <free+0x18>
     63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
     640:	03 72 04             	add    0x4(%edx),%esi
     643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     646:	8b 10                	mov    (%eax),%edx
     648:	8b 12                	mov    (%edx),%edx
     64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     64d:	8b 50 04             	mov    0x4(%eax),%edx
     650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     653:	39 f1                	cmp    %esi,%ecx
     655:	75 c6                	jne    61d <free+0x3d>
    p->s.size += bp->s.size;
     657:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
     65a:	a3 f0 19 00 00       	mov    %eax,0x19f0
    p->s.size += bp->s.size;
     65f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     662:	8b 4b f8             	mov    -0x8(%ebx),%ecx
     665:	89 08                	mov    %ecx,(%eax)
}
     667:	5b                   	pop    %ebx
     668:	5e                   	pop    %esi
     669:	5f                   	pop    %edi
     66a:	5d                   	pop    %ebp
     66b:	c3                   	ret
     66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     670:	55                   	push   %ebp
     671:	89 e5                	mov    %esp,%ebp
     673:	57                   	push   %edi
     674:	56                   	push   %esi
     675:	53                   	push   %ebx
     676:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     67c:	8b 15 f0 19 00 00    	mov    0x19f0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     682:	8d 78 07             	lea    0x7(%eax),%edi
     685:	c1 ef 03             	shr    $0x3,%edi
     688:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
     68b:	85 d2                	test   %edx,%edx
     68d:	0f 84 8d 00 00 00    	je     720 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     693:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     695:	8b 48 04             	mov    0x4(%eax),%ecx
     698:	39 f9                	cmp    %edi,%ecx
     69a:	73 64                	jae    700 <malloc+0x90>
  if(nu < 4096)
     69c:	bb 00 10 00 00       	mov    $0x1000,%ebx
     6a1:	39 df                	cmp    %ebx,%edi
     6a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
     6a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
     6ad:	eb 0a                	jmp    6b9 <malloc+0x49>
     6af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     6b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     6b2:	8b 48 04             	mov    0x4(%eax),%ecx
     6b5:	39 f9                	cmp    %edi,%ecx
     6b7:	73 47                	jae    700 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     6b9:	89 c2                	mov    %eax,%edx
     6bb:	3b 05 f0 19 00 00    	cmp    0x19f0,%eax
     6c1:	75 ed                	jne    6b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
     6c3:	83 ec 0c             	sub    $0xc,%esp
     6c6:	56                   	push   %esi
     6c7:	e8 bf fc ff ff       	call   38b <sbrk>
  if(p == (char*)-1)
     6cc:	83 c4 10             	add    $0x10,%esp
     6cf:	83 f8 ff             	cmp    $0xffffffff,%eax
     6d2:	74 1c                	je     6f0 <malloc+0x80>
  hp->s.size = nu;
     6d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     6d7:	83 ec 0c             	sub    $0xc,%esp
     6da:	83 c0 08             	add    $0x8,%eax
     6dd:	50                   	push   %eax
     6de:	e8 fd fe ff ff       	call   5e0 <free>
  return freep;
     6e3:	8b 15 f0 19 00 00    	mov    0x19f0,%edx
      if((p = morecore(nunits)) == 0)
     6e9:	83 c4 10             	add    $0x10,%esp
     6ec:	85 d2                	test   %edx,%edx
     6ee:	75 c0                	jne    6b0 <malloc+0x40>
        return 0;
  }
}
     6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     6f3:	31 c0                	xor    %eax,%eax
}
     6f5:	5b                   	pop    %ebx
     6f6:	5e                   	pop    %esi
     6f7:	5f                   	pop    %edi
     6f8:	5d                   	pop    %ebp
     6f9:	c3                   	ret
     6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
     700:	39 cf                	cmp    %ecx,%edi
     702:	74 4c                	je     750 <malloc+0xe0>
        p->s.size -= nunits;
     704:	29 f9                	sub    %edi,%ecx
     706:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
     709:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
     70c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
     70f:	89 15 f0 19 00 00    	mov    %edx,0x19f0
}
     715:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
     718:	83 c0 08             	add    $0x8,%eax
}
     71b:	5b                   	pop    %ebx
     71c:	5e                   	pop    %esi
     71d:	5f                   	pop    %edi
     71e:	5d                   	pop    %ebp
     71f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
     720:	c7 05 f0 19 00 00 f4 	movl   $0x19f4,0x19f0
     727:	19 00 00 
    base.s.size = 0;
     72a:	b8 f4 19 00 00       	mov    $0x19f4,%eax
    base.s.ptr = freep = prevp = &base;
     72f:	c7 05 f4 19 00 00 f4 	movl   $0x19f4,0x19f4
     736:	19 00 00 
    base.s.size = 0;
     739:	c7 05 f8 19 00 00 00 	movl   $0x0,0x19f8
     740:	00 00 00 
    if(p->s.size >= nunits){
     743:	e9 54 ff ff ff       	jmp    69c <malloc+0x2c>
     748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     74f:	00 
        prevp->s.ptr = p->s.ptr;
     750:	8b 08                	mov    (%eax),%ecx
     752:	89 0a                	mov    %ecx,(%edx)
     754:	eb b9                	jmp    70f <malloc+0x9f>
     756:	66 90                	xchg   %ax,%ax
     758:	66 90                	xchg   %ax,%ax
     75a:	66 90                	xchg   %ax,%ax
     75c:	66 90                	xchg   %ax,%ax
     75e:	66 90                	xchg   %ax,%ax

00000760 <thread_init>:
}

void
thread_init(void)
{
    for (int i = 0; i < MAX_THREADS; i++) {
     760:	b8 20 1a 00 00       	mov    $0x1a20,%eax
     765:	8d 76 00             	lea    0x0(%esi),%esi
        threads[i].tid = -1;
     768:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     76e:	83 c0 20             	add    $0x20,%eax
        threads[i].state = T_UNUSED;
     771:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
        threads[i].stack = 0;
     778:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
        threads[i].sp = 0;
     77f:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        threads[i].start_routine = 0;
     786:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        threads[i].arg = 0;
     78d:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
        threads[i].retval = 0;
     794:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        threads[i].waiting_tid = -1;
     79b:	c7 40 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     7a2:	3d 20 1c 00 00       	cmp    $0x1c20,%eax
     7a7:	75 bf                	jne    768 <thread_init+0x8>
    }

    threads[0].tid = 0;
     7a9:	c7 05 20 1a 00 00 00 	movl   $0x0,0x1a20
     7b0:	00 00 00 
    threads[0].state = T_RUNNING;
     7b3:	c7 05 24 1a 00 00 02 	movl   $0x2,0x1a24
     7ba:	00 00 00 
    threads[0].waiting_tid = -1;
     7bd:	c7 05 3c 1a 00 00 ff 	movl   $0xffffffff,0x1a3c
     7c4:	ff ff ff 

    current_thread = &threads[0];
     7c7:	c7 05 00 1a 00 00 20 	movl   $0x1a20,0x1a00
     7ce:	1a 00 00 
}
     7d1:	c3                   	ret
     7d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7d9:	00 
     7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007e0 <thread_self>:

int
thread_self(void)
{
    return current_thread->tid;
     7e0:	a1 00 1a 00 00       	mov    0x1a00,%eax
     7e5:	8b 00                	mov    (%eax),%eax
}
     7e7:	c3                   	ret
     7e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7ef:	00 

000007f0 <thread_create>:

int
thread_create(void* (*start_routine)(void*), void *arg)
{
     7f0:	55                   	push   %ebp
    int i;
    for (i = 0; i < MAX_THREADS; i++) {
     7f1:	31 c0                	xor    %eax,%eax
{
     7f3:	89 e5                	mov    %esp,%ebp
     7f5:	56                   	push   %esi
     7f6:	53                   	push   %ebx
     7f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7fe:	00 
     7ff:	90                   	nop
        if (threads[i].state == T_UNUSED)
     800:	89 c3                	mov    %eax,%ebx
     802:	c1 e3 05             	shl    $0x5,%ebx
     805:	8b 93 24 1a 00 00    	mov    0x1a24(%ebx),%edx
     80b:	85 d2                	test   %edx,%edx
     80d:	74 19                	je     828 <thread_create+0x38>
    for (i = 0; i < MAX_THREADS; i++) {
     80f:	83 c0 01             	add    $0x1,%eax
     812:	83 f8 10             	cmp    $0x10,%eax
     815:	75 e9                	jne    800 <thread_create+0x10>
            break;
    }
    if (i == MAX_THREADS)
        return -1;
     817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     81c:	e9 8c 00 00 00       	jmp    8ad <thread_create+0xbd>
     821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    struct thread *t = &threads[i];

    t->tid = next_tid++;
     828:	a1 8c 19 00 00       	mov    0x198c,%eax
     82d:	8d b3 20 1a 00 00    	lea    0x1a20(%ebx),%esi
    t->start_routine = start_routine;
    t->arg = arg;
    t->retval = 0;
    t->waiting_tid = -1;

    t->stack = malloc(STACK_SIZE);
     833:	83 ec 0c             	sub    $0xc,%esp
    t->state = T_RUNNABLE;
     836:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    t->tid = next_tid++;
     83d:	89 83 20 1a 00 00    	mov    %eax,0x1a20(%ebx)
     843:	8d 50 01             	lea    0x1(%eax),%edx
    t->start_routine = start_routine;
     846:	8b 45 08             	mov    0x8(%ebp),%eax
    t->tid = next_tid++;
     849:	89 15 8c 19 00 00    	mov    %edx,0x198c
    t->start_routine = start_routine;
     84f:	89 46 10             	mov    %eax,0x10(%esi)
    t->arg = arg;
     852:	8b 45 0c             	mov    0xc(%ebp),%eax
    t->retval = 0;
     855:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    t->arg = arg;
     85c:	89 46 14             	mov    %eax,0x14(%esi)
    t->waiting_tid = -1;
     85f:	c7 46 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%esi)
    t->stack = malloc(STACK_SIZE);
     866:	68 00 10 00 00       	push   $0x1000
     86b:	e8 00 fe ff ff       	call   670 <malloc>
    if (!t->stack) {
     870:	83 c4 10             	add    $0x10,%esp
    t->stack = malloc(STACK_SIZE);
     873:	89 46 08             	mov    %eax,0x8(%esi)
    if (!t->stack) {
     876:	85 c0                	test   %eax,%eax
     878:	74 3a                	je     8b4 <thread_create+0xc4>
        t->state = T_UNUSED;
        return -1;
    }

    uint *sp = (uint *)((char *)t->stack + STACK_SIZE);
    *(--sp) = (uint)thread_trampoline;
     87a:	c7 80 fc 0f 00 00 c0 	movl   $0x9c0,0xffc(%eax)
     881:	09 00 00 
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
     884:	05 ec 0f 00 00       	add    $0xfec,%eax
    *(--sp) = 0;
     889:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    *(--sp) = 0;
     890:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    *(--sp) = 0;
     897:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    *(--sp) = 0;
     89e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     8a4:	89 46 0c             	mov    %eax,0xc(%esi)
    t->sp = sp;

    return t->tid;
     8a7:	8b 83 20 1a 00 00    	mov    0x1a20(%ebx),%eax
}
     8ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
     8b0:	5b                   	pop    %ebx
     8b1:	5e                   	pop    %esi
     8b2:	5d                   	pop    %ebp
     8b3:	c3                   	ret
        t->state = T_UNUSED;
     8b4:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
        return -1;
     8bb:	e9 57 ff ff ff       	jmp    817 <thread_create+0x27>

000008c0 <thread_schedule>:

void
thread_schedule(void)
{
     8c0:	55                   	push   %ebp
     8c1:	89 e5                	mov    %esp,%ebp
     8c3:	57                   	push   %edi
     8c4:	56                   	push   %esi
     8c5:	53                   	push   %ebx
     8c6:	83 ec 0c             	sub    $0xc,%esp
    struct thread *old = current_thread;
     8c9:	8b 35 00 1a 00 00    	mov    0x1a00,%esi
    struct thread *next = 0;

    int start = (old - threads + 1) % MAX_THREADS;
     8cf:	89 f0                	mov    %esi,%eax
     8d1:	2d 20 1a 00 00       	sub    $0x1a20,%eax
     8d6:	c1 f8 05             	sar    $0x5,%eax
     8d9:	83 c0 01             	add    $0x1,%eax
     8dc:	99                   	cltd
     8dd:	c1 ea 1c             	shr    $0x1c,%edx
     8e0:	01 d0                	add    %edx,%eax
     8e2:	83 e0 0f             	and    $0xf,%eax
     8e5:	29 d0                	sub    %edx,%eax
     8e7:	8d 58 10             	lea    0x10(%eax),%ebx
     8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for (int i = 0; i < MAX_THREADS; i++) {
        int idx = (start + i) % MAX_THREADS;
     8f0:	89 c1                	mov    %eax,%ecx
     8f2:	c1 f9 1f             	sar    $0x1f,%ecx
     8f5:	c1 e9 1c             	shr    $0x1c,%ecx
     8f8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
     8fb:	83 e2 0f             	and    $0xf,%edx
     8fe:	29 ca                	sub    %ecx,%edx
        if (threads[idx].state == T_RUNNABLE) {
     900:	89 d1                	mov    %edx,%ecx
     902:	c1 e1 05             	shl    $0x5,%ecx
     905:	83 b9 24 1a 00 00 01 	cmpl   $0x1,0x1a24(%ecx)
     90c:	8d b9 20 1a 00 00    	lea    0x1a20(%ecx),%edi
     912:	74 14                	je     928 <thread_schedule+0x68>
    for (int i = 0; i < MAX_THREADS; i++) {
     914:	83 c0 01             	add    $0x1,%eax
     917:	39 d8                	cmp    %ebx,%eax
     919:	75 d5                	jne    8f0 <thread_schedule+0x30>

    next->state = T_RUNNING;
    current_thread = next;

    thread_switch(old, next);
}
     91b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     91e:	5b                   	pop    %ebx
     91f:	5e                   	pop    %esi
     920:	5f                   	pop    %edi
     921:	5d                   	pop    %ebp
     922:	c3                   	ret
     923:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (old->state == T_RUNNING)
     928:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     92c:	75 07                	jne    935 <thread_schedule+0x75>
        old->state = T_RUNNABLE;
     92e:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    thread_switch(old, next);
     935:	83 ec 08             	sub    $0x8,%esp
    next->state = T_RUNNING;
     938:	c1 e2 05             	shl    $0x5,%edx
    current_thread = next;
     93b:	89 3d 00 1a 00 00    	mov    %edi,0x1a00
    next->state = T_RUNNING;
     941:	c7 82 24 1a 00 00 02 	movl   $0x2,0x1a24(%edx)
     948:	00 00 00 
    thread_switch(old, next);
     94b:	57                   	push   %edi
     94c:	56                   	push   %esi
     94d:	e8 1e 03 00 00       	call   c70 <thread_switch>
     952:	83 c4 10             	add    $0x10,%esp
}
     955:	8d 65 f4             	lea    -0xc(%ebp),%esp
     958:	5b                   	pop    %ebx
     959:	5e                   	pop    %esi
     95a:	5f                   	pop    %edi
     95b:	5d                   	pop    %ebp
     95c:	c3                   	ret
     95d:	8d 76 00             	lea    0x0(%esi),%esi

00000960 <thread_yield>:

void
thread_yield(void)
{
    thread_schedule();
     960:	e9 5b ff ff ff       	jmp    8c0 <thread_schedule>
     965:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     96c:	00 
     96d:	8d 76 00             	lea    0x0(%esi),%esi

00000970 <thread_exit>:
}

void
thread_exit(void *retval)
{
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	83 ec 08             	sub    $0x8,%esp
    current_thread->retval = retval;
     976:	a1 00 1a 00 00       	mov    0x1a00,%eax
     97b:	8b 55 08             	mov    0x8(%ebp),%edx
    current_thread->state = T_ZOMBIE;

    if (current_thread->waiting_tid >= 0) {
     97e:	8b 48 1c             	mov    0x1c(%eax),%ecx
    current_thread->state = T_ZOMBIE;
     981:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
    current_thread->retval = retval;
     988:	89 50 18             	mov    %edx,0x18(%eax)
    if (current_thread->waiting_tid >= 0) {
     98b:	85 c9                	test   %ecx,%ecx
     98d:	78 1e                	js     9ad <thread_exit+0x3d>
        for (int i = 0; i < MAX_THREADS; i++) {
     98f:	31 c0                	xor    %eax,%eax
     991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (threads[i].tid == current_thread->waiting_tid) {
     998:	89 c2                	mov    %eax,%edx
     99a:	c1 e2 05             	shl    $0x5,%edx
     99d:	3b 8a 20 1a 00 00    	cmp    0x1a20(%edx),%ecx
     9a3:	74 0f                	je     9b4 <thread_exit+0x44>
        for (int i = 0; i < MAX_THREADS; i++) {
     9a5:	83 c0 01             	add    $0x1,%eax
     9a8:	83 f8 10             	cmp    $0x10,%eax
     9ab:	75 eb                	jne    998 <thread_exit+0x28>
                break;
            }
        }
    }

    thread_schedule();
     9ad:	e8 0e ff ff ff       	call   8c0 <thread_schedule>

    for (;;)
     9b2:	eb fe                	jmp    9b2 <thread_exit+0x42>
                threads[i].state = T_RUNNABLE;
     9b4:	c7 82 24 1a 00 00 01 	movl   $0x1,0x1a24(%edx)
     9bb:	00 00 00 
                break;
     9be:	eb ed                	jmp    9ad <thread_exit+0x3d>

000009c0 <thread_trampoline>:
{
     9c0:	55                   	push   %ebp
     9c1:	89 e5                	mov    %esp,%ebp
     9c3:	83 ec 14             	sub    $0x14,%esp
    void *ret = current_thread->start_routine(current_thread->arg);
     9c6:	a1 00 1a 00 00       	mov    0x1a00,%eax
     9cb:	ff 70 14             	push   0x14(%eax)
     9ce:	ff 50 10             	call   *0x10(%eax)
    thread_exit(ret);
     9d1:	89 04 24             	mov    %eax,(%esp)
     9d4:	e8 97 ff ff ff       	call   970 <thread_exit>
     9d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009e0 <thread_join>:
        ;
}

void *
thread_join(int tid)
{
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	57                   	push   %edi
     9e4:	56                   	push   %esi
     9e5:	53                   	push   %ebx
    struct thread *target = 0;

    for (int i = 0; i < MAX_THREADS; i++) {
     9e6:	31 db                	xor    %ebx,%ebx
{
     9e8:	83 ec 0c             	sub    $0xc,%esp
     9eb:	8b 55 08             	mov    0x8(%ebp),%edx
     9ee:	66 90                	xchg   %ax,%ax
        if (threads[i].tid == tid) {
     9f0:	89 d8                	mov    %ebx,%eax
     9f2:	c1 e0 05             	shl    $0x5,%eax
     9f5:	39 90 20 1a 00 00    	cmp    %edx,0x1a20(%eax)
     9fb:	74 1b                	je     a18 <thread_join+0x38>
    for (int i = 0; i < MAX_THREADS; i++) {
     9fd:	83 c3 01             	add    $0x1,%ebx
     a00:	83 fb 10             	cmp    $0x10,%ebx
     a03:	75 eb                	jne    9f0 <thread_join+0x10>
    target->stack = 0;
    target->state = T_UNUSED;
    target->tid = -1;

    return ret;
}
     a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     a08:	31 ff                	xor    %edi,%edi
}
     a0a:	5b                   	pop    %ebx
     a0b:	89 f8                	mov    %edi,%eax
     a0d:	5e                   	pop    %esi
     a0e:	5f                   	pop    %edi
     a0f:	5d                   	pop    %ebp
     a10:	c3                   	ret
     a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (target->state != T_ZOMBIE) {
     a18:	83 b8 24 1a 00 00 04 	cmpl   $0x4,0x1a24(%eax)
     a1f:	8d b0 20 1a 00 00    	lea    0x1a20(%eax),%esi
     a25:	74 25                	je     a4c <thread_join+0x6c>
     a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a2e:	00 
     a2f:	90                   	nop
        current_thread->state = T_SLEEPING;
     a30:	a1 00 1a 00 00       	mov    0x1a00,%eax
     a35:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        target->waiting_tid = current_thread->tid;
     a3c:	8b 00                	mov    (%eax),%eax
     a3e:	89 46 1c             	mov    %eax,0x1c(%esi)
        thread_schedule();
     a41:	e8 7a fe ff ff       	call   8c0 <thread_schedule>
    while (target->state != T_ZOMBIE) {
     a46:	83 7e 04 04          	cmpl   $0x4,0x4(%esi)
     a4a:	75 e4                	jne    a30 <thread_join+0x50>
    void *ret = target->retval;
     a4c:	c1 e3 05             	shl    $0x5,%ebx
    free(target->stack);
     a4f:	83 ec 0c             	sub    $0xc,%esp
    void *ret = target->retval;
     a52:	8b bb 38 1a 00 00    	mov    0x1a38(%ebx),%edi
    free(target->stack);
     a58:	ff b3 28 1a 00 00    	push   0x1a28(%ebx)
     a5e:	e8 7d fb ff ff       	call   5e0 <free>
    return ret;
     a63:	83 c4 10             	add    $0x10,%esp
}
     a66:	89 f8                	mov    %edi,%eax
    target->stack = 0;
     a68:	c7 83 28 1a 00 00 00 	movl   $0x0,0x1a28(%ebx)
     a6f:	00 00 00 
    target->state = T_UNUSED;
     a72:	c7 83 24 1a 00 00 00 	movl   $0x0,0x1a24(%ebx)
     a79:	00 00 00 
    target->tid = -1;
     a7c:	c7 83 20 1a 00 00 ff 	movl   $0xffffffff,0x1a20(%ebx)
     a83:	ff ff ff 
}
     a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a89:	5b                   	pop    %ebx
     a8a:	5e                   	pop    %esi
     a8b:	5f                   	pop    %edi
     a8c:	5d                   	pop    %ebp
     a8d:	c3                   	ret
     a8e:	66 90                	xchg   %ax,%ax

00000a90 <sem_init>:
void
sem_init(sem_t *s, int value)
{
     a90:	55                   	push   %ebp
     a91:	89 e5                	mov    %esp,%ebp
     a93:	8b 45 08             	mov    0x8(%ebp),%eax
    s->count = value;
     a96:	8b 55 0c             	mov    0xc(%ebp),%edx
    s->wait_count = 0;
     a99:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    s->count = value;
     aa0:	89 10                	mov    %edx,(%eax)
}
     aa2:	5d                   	pop    %ebp
     aa3:	c3                   	ret
     aa4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     aab:	00 
     aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ab0 <sem_wait>:

void
sem_wait(sem_t *s)
{
     ab0:	55                   	push   %ebp
     ab1:	89 e5                	mov    %esp,%ebp
     ab3:	53                   	push   %ebx
     ab4:	8b 55 08             	mov    0x8(%ebp),%edx
    s->count--;
     ab7:	83 2a 01             	subl   $0x1,(%edx)
    if (s->count < 0) {
     aba:	78 0c                	js     ac8 <sem_wait+0x18>
        s->wait_queue[s->wait_count++] = current_thread->tid;
        current_thread->state = T_SLEEPING;
        thread_schedule();
    }
}
     abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     abf:	c9                   	leave
     ac0:	c3                   	ret
     ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s->wait_queue[s->wait_count++] = current_thread->tid;
     ac8:	8b 4a 44             	mov    0x44(%edx),%ecx
     acb:	a1 00 1a 00 00       	mov    0x1a00,%eax
     ad0:	8d 59 01             	lea    0x1(%ecx),%ebx
     ad3:	89 5a 44             	mov    %ebx,0x44(%edx)
     ad6:	8b 18                	mov    (%eax),%ebx
     ad8:	89 5c 8a 04          	mov    %ebx,0x4(%edx,%ecx,4)
        current_thread->state = T_SLEEPING;
     adc:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
}
     ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ae6:	c9                   	leave
        thread_schedule();
     ae7:	e9 d4 fd ff ff       	jmp    8c0 <thread_schedule>
     aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000af0 <sem_post>:

void
sem_post(sem_t *s)
{
     af0:	55                   	push   %ebp
     af1:	89 e5                	mov    %esp,%ebp
     af3:	57                   	push   %edi
     af4:	8b 55 08             	mov    0x8(%ebp),%edx
     af7:	56                   	push   %esi
     af8:	53                   	push   %ebx
    s->count++;
     af9:	8b 02                	mov    (%edx),%eax
     afb:	83 c0 01             	add    $0x1,%eax
     afe:	89 02                	mov    %eax,(%edx)
    if (s->count <= 0 && s->wait_count > 0) {
     b00:	85 c0                	test   %eax,%eax
     b02:	7e 0c                	jle    b10 <sem_post+0x20>
                threads[i].state = T_RUNNABLE;
                break;
            }
        }
    }
}
     b04:	5b                   	pop    %ebx
     b05:	5e                   	pop    %esi
     b06:	5f                   	pop    %edi
     b07:	5d                   	pop    %ebp
     b08:	c3                   	ret
     b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (s->count <= 0 && s->wait_count > 0) {
     b10:	8b 7a 44             	mov    0x44(%edx),%edi
     b13:	85 ff                	test   %edi,%edi
     b15:	7e ed                	jle    b04 <sem_post+0x14>
        int tid = s->wait_queue[0];
     b17:	8b 5a 04             	mov    0x4(%edx),%ebx
        for (int i = 1; i < s->wait_count; i++)
     b1a:	83 ff 01             	cmp    $0x1,%edi
     b1d:	74 16                	je     b35 <sem_post+0x45>
     b1f:	8d 42 04             	lea    0x4(%edx),%eax
     b22:	8d 34 ba             	lea    (%edx,%edi,4),%esi
     b25:	8d 76 00             	lea    0x0(%esi),%esi
            s->wait_queue[i - 1] = s->wait_queue[i];
     b28:	8b 48 04             	mov    0x4(%eax),%ecx
        for (int i = 1; i < s->wait_count; i++)
     b2b:	83 c0 04             	add    $0x4,%eax
            s->wait_queue[i - 1] = s->wait_queue[i];
     b2e:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int i = 1; i < s->wait_count; i++)
     b31:	39 f0                	cmp    %esi,%eax
     b33:	75 f3                	jne    b28 <sem_post+0x38>
        s->wait_count--;
     b35:	83 ef 01             	sub    $0x1,%edi
        for (int i = 0; i < MAX_THREADS; i++) {
     b38:	31 c0                	xor    %eax,%eax
        s->wait_count--;
     b3a:	89 7a 44             	mov    %edi,0x44(%edx)
        for (int i = 0; i < MAX_THREADS; i++) {
     b3d:	eb 09                	jmp    b48 <sem_post+0x58>
     b3f:	90                   	nop
     b40:	83 c0 01             	add    $0x1,%eax
     b43:	83 f8 10             	cmp    $0x10,%eax
     b46:	74 bc                	je     b04 <sem_post+0x14>
            if (threads[i].tid == tid) {
     b48:	89 c2                	mov    %eax,%edx
     b4a:	c1 e2 05             	shl    $0x5,%edx
     b4d:	39 9a 20 1a 00 00    	cmp    %ebx,0x1a20(%edx)
     b53:	75 eb                	jne    b40 <sem_post+0x50>
                threads[i].state = T_RUNNABLE;
     b55:	c7 82 24 1a 00 00 01 	movl   $0x1,0x1a24(%edx)
     b5c:	00 00 00 
}
     b5f:	5b                   	pop    %ebx
     b60:	5e                   	pop    %esi
     b61:	5f                   	pop    %edi
     b62:	5d                   	pop    %ebp
     b63:	c3                   	ret
     b64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b6b:	00 
     b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b70 <cond_init>:

void
cond_init(cond_t *c)
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
    c->wait_count = 0;
     b73:	8b 45 08             	mov    0x8(%ebp),%eax
     b76:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%eax)
}
     b7d:	5d                   	pop    %ebp
     b7e:	c3                   	ret
     b7f:	90                   	nop

00000b80 <cond_wait>:

void
cond_wait(cond_t *c, mutex_t *m)
{
     b80:	55                   	push   %ebp
     b81:	89 e5                	mov    %esp,%ebp
     b83:	53                   	push   %ebx
     b84:	83 ec 10             	sub    $0x10,%esp
     b87:	8b 45 08             	mov    0x8(%ebp),%eax
     b8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    c->wait_queue[c->wait_count++] = current_thread->tid;
     b8d:	8b 50 40             	mov    0x40(%eax),%edx
     b90:	8d 4a 01             	lea    0x1(%edx),%ecx
     b93:	89 48 40             	mov    %ecx,0x40(%eax)
     b96:	8b 0d 00 1a 00 00    	mov    0x1a00,%ecx
     b9c:	8b 09                	mov    (%ecx),%ecx
     b9e:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    mutex_unlock(m);
     ba1:	53                   	push   %ebx
     ba2:	e8 79 01 00 00       	call   d20 <mutex_unlock>
    current_thread->state = T_SLEEPING;
     ba7:	a1 00 1a 00 00       	mov    0x1a00,%eax
     bac:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
    thread_schedule();
     bb3:	e8 08 fd ff ff       	call   8c0 <thread_schedule>
    mutex_lock(m);
     bb8:	83 c4 10             	add    $0x10,%esp
     bbb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     bc1:	c9                   	leave
    mutex_lock(m);
     bc2:	e9 e9 00 00 00       	jmp    cb0 <mutex_lock>
     bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bce:	00 
     bcf:	90                   	nop

00000bd0 <cond_signal>:

void
cond_signal(cond_t *c)
{
     bd0:	55                   	push   %ebp
     bd1:	89 e5                	mov    %esp,%ebp
     bd3:	57                   	push   %edi
     bd4:	8b 7d 08             	mov    0x8(%ebp),%edi
     bd7:	56                   	push   %esi
     bd8:	53                   	push   %ebx
    if (c->wait_count == 0)
     bd9:	8b 77 40             	mov    0x40(%edi),%esi
     bdc:	85 f6                	test   %esi,%esi
     bde:	74 3d                	je     c1d <cond_signal+0x4d>
        return;

    int tid = c->wait_queue[0];
     be0:	8b 0f                	mov    (%edi),%ecx
    for (int i = 1; i < c->wait_count; i++)
     be2:	83 fe 01             	cmp    $0x1,%esi
     be5:	7e 16                	jle    bfd <cond_signal+0x2d>
     be7:	89 f8                	mov    %edi,%eax
     be9:	8d 5c b7 fc          	lea    -0x4(%edi,%esi,4),%ebx
     bed:	8d 76 00             	lea    0x0(%esi),%esi
        c->wait_queue[i - 1] = c->wait_queue[i];
     bf0:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < c->wait_count; i++)
     bf3:	83 c0 04             	add    $0x4,%eax
        c->wait_queue[i - 1] = c->wait_queue[i];
     bf6:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < c->wait_count; i++)
     bf9:	39 d8                	cmp    %ebx,%eax
     bfb:	75 f3                	jne    bf0 <cond_signal+0x20>
    c->wait_count--;
     bfd:	83 ee 01             	sub    $0x1,%esi

    for (int i = 0; i < MAX_THREADS; i++) {
     c00:	31 c0                	xor    %eax,%eax
    c->wait_count--;
     c02:	89 77 40             	mov    %esi,0x40(%edi)
    for (int i = 0; i < MAX_THREADS; i++) {
     c05:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == tid) {
     c08:	89 c2                	mov    %eax,%edx
     c0a:	c1 e2 05             	shl    $0x5,%edx
     c0d:	39 8a 20 1a 00 00    	cmp    %ecx,0x1a20(%edx)
     c13:	74 13                	je     c28 <cond_signal+0x58>
    for (int i = 0; i < MAX_THREADS; i++) {
     c15:	83 c0 01             	add    $0x1,%eax
     c18:	83 f8 10             	cmp    $0x10,%eax
     c1b:	75 eb                	jne    c08 <cond_signal+0x38>
            threads[i].state = T_RUNNABLE;
            break;
        }
    }
}
     c1d:	5b                   	pop    %ebx
     c1e:	5e                   	pop    %esi
     c1f:	5f                   	pop    %edi
     c20:	5d                   	pop    %ebp
     c21:	c3                   	ret
     c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     c28:	c7 82 24 1a 00 00 01 	movl   $0x1,0x1a24(%edx)
     c2f:	00 00 00 
}
     c32:	5b                   	pop    %ebx
     c33:	5e                   	pop    %esi
     c34:	5f                   	pop    %edi
     c35:	5d                   	pop    %ebp
     c36:	c3                   	ret
     c37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c3e:	00 
     c3f:	90                   	nop

00000c40 <cond_broadcast>:

void
cond_broadcast(cond_t *c)
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	53                   	push   %ebx
     c44:	83 ec 04             	sub    $0x4,%esp
     c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (c->wait_count > 0)
     c4a:	8b 53 40             	mov    0x40(%ebx),%edx
     c4d:	85 d2                	test   %edx,%edx
     c4f:	7e 1a                	jle    c6b <cond_broadcast+0x2b>
     c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(c);
     c58:	83 ec 0c             	sub    $0xc,%esp
     c5b:	53                   	push   %ebx
     c5c:	e8 6f ff ff ff       	call   bd0 <cond_signal>
    while (c->wait_count > 0)
     c61:	8b 43 40             	mov    0x40(%ebx),%eax
     c64:	83 c4 10             	add    $0x10,%esp
     c67:	85 c0                	test   %eax,%eax
     c69:	7f ed                	jg     c58 <cond_broadcast+0x18>
}
     c6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c6e:	c9                   	leave
     c6f:	c3                   	ret

00000c70 <thread_switch>:
.text
.globl thread_switch
thread_switch:
  movl 4(%esp), %eax
     c70:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
     c74:	8b 54 24 08          	mov    0x8(%esp),%edx
  pushl %ebp
     c78:	55                   	push   %ebp
  pushl %ebx
     c79:	53                   	push   %ebx
  pushl %esi
     c7a:	56                   	push   %esi
  pushl %edi
     c7b:	57                   	push   %edi
  movl %esp, 12(%eax)
     c7c:	89 60 0c             	mov    %esp,0xc(%eax)
  movl 12(%edx), %esp
     c7f:	8b 62 0c             	mov    0xc(%edx),%esp
  popl %edi
     c82:	5f                   	pop    %edi
  popl %esi
     c83:	5e                   	pop    %esi
  popl %ebx
     c84:	5b                   	pop    %ebx
  popl %ebp
     c85:	5d                   	pop    %ebp
  ret
     c86:	c3                   	ret
     c87:	66 90                	xchg   %ax,%ax
     c89:	66 90                	xchg   %ax,%ax
     c8b:	66 90                	xchg   %ax,%ax
     c8d:	66 90                	xchg   %ax,%ax
     c8f:	90                   	nop

00000c90 <mutex_init>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

void
mutex_init(mutex_t *m)
{
     c90:	55                   	push   %ebp
     c91:	89 e5                	mov    %esp,%ebp
     c93:	8b 45 08             	mov    0x8(%ebp),%eax
    m->locked = 0;
     c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    m->owner = -1;
     c9c:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    m->wait_count = 0;
     ca3:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
}
     caa:	5d                   	pop    %ebp
     cab:	c3                   	ret
     cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cb0 <mutex_lock>:

void
mutex_lock(mutex_t *m)
{
     cb0:	55                   	push   %ebp
     cb1:	89 e5                	mov    %esp,%ebp
     cb3:	53                   	push   %ebx
     cb4:	83 ec 04             	sub    $0x4,%esp
     cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (m->locked) {
     cba:	8b 13                	mov    (%ebx),%edx
     cbc:	85 d2                	test   %edx,%edx
     cbe:	75 29                	jne    ce9 <mutex_lock+0x39>
     cc0:	eb 3e                	jmp    d00 <mutex_lock+0x50>
     cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (m->owner == current_thread->tid)
            return;
        m->wait_queue[m->wait_count++] = current_thread->tid;
     cc8:	8b 53 48             	mov    0x48(%ebx),%edx
     ccb:	8d 4a 01             	lea    0x1(%edx),%ecx
     cce:	89 4b 48             	mov    %ecx,0x48(%ebx)
     cd1:	8b 08                	mov    (%eax),%ecx
     cd3:	89 4c 93 08          	mov    %ecx,0x8(%ebx,%edx,4)
        current_thread->state = T_SLEEPING;
     cd7:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        thread_schedule();
     cde:	e8 dd fb ff ff       	call   8c0 <thread_schedule>
    while (m->locked) {
     ce3:	8b 03                	mov    (%ebx),%eax
     ce5:	85 c0                	test   %eax,%eax
     ce7:	74 17                	je     d00 <mutex_lock+0x50>
        if (m->owner == current_thread->tid)
     ce9:	a1 00 1a 00 00       	mov    0x1a00,%eax
     cee:	8b 10                	mov    (%eax),%edx
     cf0:	39 53 04             	cmp    %edx,0x4(%ebx)
     cf3:	75 d3                	jne    cc8 <mutex_lock+0x18>
    }
    m->locked = 1;
    m->owner = current_thread->tid;
}
     cf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     cf8:	c9                   	leave
     cf9:	c3                   	ret
     cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m->locked = 1;
     d00:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    m->owner = current_thread->tid;
     d06:	a1 00 1a 00 00       	mov    0x1a00,%eax
     d0b:	8b 00                	mov    (%eax),%eax
     d0d:	89 43 04             	mov    %eax,0x4(%ebx)
}
     d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d13:	c9                   	leave
     d14:	c3                   	ret
     d15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d1c:	00 
     d1d:	8d 76 00             	lea    0x0(%esi),%esi

00000d20 <mutex_unlock>:

void
mutex_unlock(mutex_t *m)
{
     d20:	55                   	push   %ebp
    if (m->owner != current_thread->tid)
     d21:	a1 00 1a 00 00       	mov    0x1a00,%eax
{
     d26:	89 e5                	mov    %esp,%ebp
     d28:	57                   	push   %edi
     d29:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d2c:	56                   	push   %esi
     d2d:	53                   	push   %ebx
    if (m->owner != current_thread->tid)
     d2e:	8b 00                	mov    (%eax),%eax
     d30:	39 41 04             	cmp    %eax,0x4(%ecx)
     d33:	75 48                	jne    d7d <mutex_unlock+0x5d>
        return;

    if (m->wait_count == 0) {
     d35:	8b 79 48             	mov    0x48(%ecx),%edi
     d38:	85 ff                	test   %edi,%edi
     d3a:	74 4c                	je     d88 <mutex_unlock+0x68>
        m->locked = 0;
        m->owner = -1;
        return;
    }

    int next_tid = m->wait_queue[0];
     d3c:	8b 59 08             	mov    0x8(%ecx),%ebx
    for (int i = 1; i < m->wait_count; i++)
     d3f:	83 ff 01             	cmp    $0x1,%edi
     d42:	7e 19                	jle    d5d <mutex_unlock+0x3d>
     d44:	8d 41 08             	lea    0x8(%ecx),%eax
     d47:	8d 74 b9 04          	lea    0x4(%ecx,%edi,4),%esi
     d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        m->wait_queue[i - 1] = m->wait_queue[i];
     d50:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < m->wait_count; i++)
     d53:	83 c0 04             	add    $0x4,%eax
        m->wait_queue[i - 1] = m->wait_queue[i];
     d56:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < m->wait_count; i++)
     d59:	39 f0                	cmp    %esi,%eax
     d5b:	75 f3                	jne    d50 <mutex_unlock+0x30>
    m->wait_count--;
     d5d:	83 ef 01             	sub    $0x1,%edi

    for (int i = 0; i < MAX_THREADS; i++) {
     d60:	31 c0                	xor    %eax,%eax
    m->wait_count--;
     d62:	89 79 48             	mov    %edi,0x48(%ecx)
    for (int i = 0; i < MAX_THREADS; i++) {
     d65:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == next_tid) {
     d68:	89 c2                	mov    %eax,%edx
     d6a:	c1 e2 05             	shl    $0x5,%edx
     d6d:	39 9a 20 1a 00 00    	cmp    %ebx,0x1a20(%edx)
     d73:	74 2b                	je     da0 <mutex_unlock+0x80>
    for (int i = 0; i < MAX_THREADS; i++) {
     d75:	83 c0 01             	add    $0x1,%eax
     d78:	83 f8 10             	cmp    $0x10,%eax
     d7b:	75 eb                	jne    d68 <mutex_unlock+0x48>
            threads[i].state = T_RUNNABLE;
            m->owner = next_tid;
            break;
        }
    }
}
     d7d:	5b                   	pop    %ebx
     d7e:	5e                   	pop    %esi
     d7f:	5f                   	pop    %edi
     d80:	5d                   	pop    %ebp
     d81:	c3                   	ret
     d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        m->locked = 0;
     d88:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
        m->owner = -1;
     d8e:	c7 41 04 ff ff ff ff 	movl   $0xffffffff,0x4(%ecx)
}
     d95:	5b                   	pop    %ebx
     d96:	5e                   	pop    %esi
     d97:	5f                   	pop    %edi
     d98:	5d                   	pop    %ebp
     d99:	c3                   	ret
     d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     da0:	c7 82 24 1a 00 00 01 	movl   $0x1,0x1a24(%edx)
     da7:	00 00 00 
            m->owner = next_tid;
     daa:	89 59 04             	mov    %ebx,0x4(%ecx)
}
     dad:	5b                   	pop    %ebx
     dae:	5e                   	pop    %esi
     daf:	5f                   	pop    %edi
     db0:	5d                   	pop    %ebp
     db1:	c3                   	ret
     db2:	66 90                	xchg   %ax,%ax
     db4:	66 90                	xchg   %ax,%ax
     db6:	66 90                	xchg   %ax,%ax
     db8:	66 90                	xchg   %ax,%ax
     dba:	66 90                	xchg   %ax,%ax
     dbc:	66 90                	xchg   %ax,%ax
     dbe:	66 90                	xchg   %ax,%ax

00000dc0 <channel_create>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

channel_t *
channel_create(int capacity)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	56                   	push   %esi
     dc4:	53                   	push   %ebx
     dc5:	8b 75 08             	mov    0x8(%ebp),%esi
    channel_t *ch = malloc(sizeof(channel_t));
     dc8:	83 ec 0c             	sub    $0xc,%esp
     dcb:	68 ec 00 00 00       	push   $0xec
     dd0:	e8 9b f8 ff ff       	call   670 <malloc>
    if (!ch)
     dd5:	83 c4 10             	add    $0x10,%esp
     dd8:	85 c0                	test   %eax,%eax
     dda:	0f 84 7c 00 00 00    	je     e5c <channel_create+0x9c>
        return 0;

    ch->buffer = malloc(sizeof(void *) * capacity);
     de0:	83 ec 0c             	sub    $0xc,%esp
     de3:	89 c3                	mov    %eax,%ebx
     de5:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
     dec:	50                   	push   %eax
     ded:	e8 7e f8 ff ff       	call   670 <malloc>
    if (!ch->buffer) {
     df2:	83 c4 10             	add    $0x10,%esp
    ch->buffer = malloc(sizeof(void *) * capacity);
     df5:	89 03                	mov    %eax,(%ebx)
    if (!ch->buffer) {
     df7:	85 c0                	test   %eax,%eax
     df9:	74 55                	je     e50 <channel_create+0x90>
    ch->count = 0;
    ch->head = 0;
    ch->tail = 0;
    ch->closed = 0;

    mutex_init(&ch->lock);
     dfb:	83 ec 0c             	sub    $0xc,%esp
     dfe:	8d 43 18             	lea    0x18(%ebx),%eax
    ch->capacity = capacity;
     e01:	89 73 04             	mov    %esi,0x4(%ebx)
    ch->count = 0;
     e04:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    ch->head = 0;
     e0b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    ch->tail = 0;
     e12:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    ch->closed = 0;
     e19:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    mutex_init(&ch->lock);
     e20:	50                   	push   %eax
     e21:	e8 6a fe ff ff       	call   c90 <mutex_init>
    cond_init(&ch->not_empty);
     e26:	8d 43 64             	lea    0x64(%ebx),%eax
     e29:	89 04 24             	mov    %eax,(%esp)
     e2c:	e8 3f fd ff ff       	call   b70 <cond_init>
    cond_init(&ch->not_full);
     e31:	8d 83 a8 00 00 00    	lea    0xa8(%ebx),%eax
     e37:	89 04 24             	mov    %eax,(%esp)
     e3a:	e8 31 fd ff ff       	call   b70 <cond_init>

    return ch;
     e3f:	83 c4 10             	add    $0x10,%esp
}
     e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
     e45:	89 d8                	mov    %ebx,%eax
     e47:	5b                   	pop    %ebx
     e48:	5e                   	pop    %esi
     e49:	5d                   	pop    %ebp
     e4a:	c3                   	ret
     e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        free(ch);
     e50:	83 ec 0c             	sub    $0xc,%esp
     e53:	53                   	push   %ebx
     e54:	e8 87 f7 ff ff       	call   5e0 <free>
        return 0;
     e59:	83 c4 10             	add    $0x10,%esp
        return 0;
     e5c:	31 db                	xor    %ebx,%ebx
     e5e:	eb e2                	jmp    e42 <channel_create+0x82>

00000e60 <channel_send>:

int
channel_send(channel_t *ch, void *data)
{
     e60:	55                   	push   %ebp
     e61:	89 e5                	mov    %esp,%ebp
     e63:	57                   	push   %edi
     e64:	56                   	push   %esi
     e65:	53                   	push   %ebx
     e66:	83 ec 18             	sub    $0x18,%esp
     e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
     e6c:	8d 73 18             	lea    0x18(%ebx),%esi
     e6f:	8d bb a8 00 00 00    	lea    0xa8(%ebx),%edi
     e75:	56                   	push   %esi
     e76:	e8 35 fe ff ff       	call   cb0 <mutex_lock>

    while (ch->count == ch->capacity && !ch->closed)
     e7b:	8b 43 04             	mov    0x4(%ebx),%eax
     e7e:	83 c4 10             	add    $0x10,%esp
     e81:	39 43 08             	cmp    %eax,0x8(%ebx)
     e84:	74 1f                	je     ea5 <channel_send+0x45>
     e86:	eb 38                	jmp    ec0 <channel_send+0x60>
     e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e8f:	00 
        cond_wait(&ch->not_full, &ch->lock);
     e90:	83 ec 08             	sub    $0x8,%esp
     e93:	56                   	push   %esi
     e94:	57                   	push   %edi
     e95:	e8 e6 fc ff ff       	call   b80 <cond_wait>
    while (ch->count == ch->capacity && !ch->closed)
     e9a:	8b 43 04             	mov    0x4(%ebx),%eax
     e9d:	83 c4 10             	add    $0x10,%esp
     ea0:	39 43 08             	cmp    %eax,0x8(%ebx)
     ea3:	75 1b                	jne    ec0 <channel_send+0x60>
     ea5:	8b 43 14             	mov    0x14(%ebx),%eax
     ea8:	85 c0                	test   %eax,%eax
     eaa:	74 e4                	je     e90 <channel_send+0x30>

    if (ch->closed) {
        mutex_unlock(&ch->lock);
     eac:	83 ec 0c             	sub    $0xc,%esp
        return -1;
     eaf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        mutex_unlock(&ch->lock);
     eb4:	56                   	push   %esi
     eb5:	e8 66 fe ff ff       	call   d20 <mutex_unlock>
        return -1;
     eba:	83 c4 10             	add    $0x10,%esp
     ebd:	eb 3b                	jmp    efa <channel_send+0x9a>
     ebf:	90                   	nop
    if (ch->closed) {
     ec0:	8b 7b 14             	mov    0x14(%ebx),%edi
     ec3:	85 ff                	test   %edi,%edi
     ec5:	75 e5                	jne    eac <channel_send+0x4c>
    }

    ch->buffer[ch->tail] = data;
     ec7:	8b 53 10             	mov    0x10(%ebx),%edx
     eca:	8b 03                	mov    (%ebx),%eax
    ch->tail = (ch->tail + 1) % ch->capacity;
    ch->count++;

    cond_signal(&ch->not_empty);
     ecc:	83 ec 0c             	sub    $0xc,%esp
    ch->buffer[ch->tail] = data;
     ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     ed2:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    ch->tail = (ch->tail + 1) % ch->capacity;
     ed5:	8b 43 10             	mov    0x10(%ebx),%eax
    ch->count++;
     ed8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    ch->tail = (ch->tail + 1) % ch->capacity;
     edc:	83 c0 01             	add    $0x1,%eax
     edf:	99                   	cltd
     ee0:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_empty);
     ee3:	83 c3 64             	add    $0x64,%ebx
    ch->tail = (ch->tail + 1) % ch->capacity;
     ee6:	89 53 ac             	mov    %edx,-0x54(%ebx)
    cond_signal(&ch->not_empty);
     ee9:	53                   	push   %ebx
     eea:	e8 e1 fc ff ff       	call   bd0 <cond_signal>
    mutex_unlock(&ch->lock);
     eef:	89 34 24             	mov    %esi,(%esp)
     ef2:	e8 29 fe ff ff       	call   d20 <mutex_unlock>
    return 0;
     ef7:	83 c4 10             	add    $0x10,%esp
}
     efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
     efd:	89 f8                	mov    %edi,%eax
     eff:	5b                   	pop    %ebx
     f00:	5e                   	pop    %esi
     f01:	5f                   	pop    %edi
     f02:	5d                   	pop    %ebp
     f03:	c3                   	ret
     f04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f0b:	00 
     f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f10 <channel_recv>:

int
channel_recv(channel_t *ch, void **data)
{
     f10:	55                   	push   %ebp
     f11:	89 e5                	mov    %esp,%ebp
     f13:	57                   	push   %edi
     f14:	56                   	push   %esi
     f15:	53                   	push   %ebx
     f16:	83 ec 18             	sub    $0x18,%esp
     f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
     f1c:	8d 73 18             	lea    0x18(%ebx),%esi
     f1f:	8d 7b 64             	lea    0x64(%ebx),%edi
     f22:	56                   	push   %esi
     f23:	e8 88 fd ff ff       	call   cb0 <mutex_lock>

    while (ch->count == 0 && !ch->closed)
     f28:	8b 4b 08             	mov    0x8(%ebx),%ecx
     f2b:	83 c4 10             	add    $0x10,%esp
     f2e:	85 c9                	test   %ecx,%ecx
     f30:	74 1a                	je     f4c <channel_recv+0x3c>
     f32:	eb 3c                	jmp    f70 <channel_recv+0x60>
     f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&ch->not_empty, &ch->lock);
     f38:	83 ec 08             	sub    $0x8,%esp
     f3b:	56                   	push   %esi
     f3c:	57                   	push   %edi
     f3d:	e8 3e fc ff ff       	call   b80 <cond_wait>
    while (ch->count == 0 && !ch->closed)
     f42:	8b 53 08             	mov    0x8(%ebx),%edx
     f45:	83 c4 10             	add    $0x10,%esp
     f48:	85 d2                	test   %edx,%edx
     f4a:	75 24                	jne    f70 <channel_recv+0x60>
     f4c:	8b 43 14             	mov    0x14(%ebx),%eax
     f4f:	85 c0                	test   %eax,%eax
     f51:	74 e5                	je     f38 <channel_recv+0x28>

    if (ch->count == 0 && ch->closed) {
        mutex_unlock(&ch->lock);
     f53:	83 ec 0c             	sub    $0xc,%esp
     f56:	56                   	push   %esi
     f57:	e8 c4 fd ff ff       	call   d20 <mutex_unlock>
        return -1;
     f5c:	83 c4 10             	add    $0x10,%esp
     f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f64:	eb 47                	jmp    fad <channel_recv+0x9d>
     f66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f6d:	00 
     f6e:	66 90                	xchg   %ax,%ax
    }

    *data = ch->buffer[ch->head];
     f70:	8b 53 0c             	mov    0xc(%ebx),%edx
     f73:	8b 03                	mov    (%ebx),%eax
    ch->head = (ch->head + 1) % ch->capacity;
    ch->count--;

    cond_signal(&ch->not_full);
     f75:	83 ec 0c             	sub    $0xc,%esp
    *data = ch->buffer[ch->head];
     f78:	8b 14 90             	mov    (%eax,%edx,4),%edx
     f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7e:	89 10                	mov    %edx,(%eax)
    ch->head = (ch->head + 1) % ch->capacity;
     f80:	8b 43 0c             	mov    0xc(%ebx),%eax
    ch->count--;
     f83:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    ch->head = (ch->head + 1) % ch->capacity;
     f87:	83 c0 01             	add    $0x1,%eax
     f8a:	99                   	cltd
     f8b:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_full);
     f8e:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    ch->head = (ch->head + 1) % ch->capacity;
     f94:	89 93 64 ff ff ff    	mov    %edx,-0x9c(%ebx)
    cond_signal(&ch->not_full);
     f9a:	53                   	push   %ebx
     f9b:	e8 30 fc ff ff       	call   bd0 <cond_signal>
    mutex_unlock(&ch->lock);
     fa0:	89 34 24             	mov    %esi,(%esp)
     fa3:	e8 78 fd ff ff       	call   d20 <mutex_unlock>
    return 0;
     fa8:	83 c4 10             	add    $0x10,%esp
     fab:	31 c0                	xor    %eax,%eax
}
     fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fb0:	5b                   	pop    %ebx
     fb1:	5e                   	pop    %esi
     fb2:	5f                   	pop    %edi
     fb3:	5d                   	pop    %ebp
     fb4:	c3                   	ret
     fb5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fbc:	00 
     fbd:	8d 76 00             	lea    0x0(%esi),%esi

00000fc0 <channel_close>:

void
channel_close(channel_t *ch)
{
     fc0:	55                   	push   %ebp
     fc1:	89 e5                	mov    %esp,%ebp
     fc3:	56                   	push   %esi
     fc4:	53                   	push   %ebx
     fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
     fc8:	8d 73 18             	lea    0x18(%ebx),%esi
     fcb:	83 ec 0c             	sub    $0xc,%esp
     fce:	56                   	push   %esi
     fcf:	e8 dc fc ff ff       	call   cb0 <mutex_lock>
    ch->closed = 1;
    cond_broadcast(&ch->not_empty);
     fd4:	8d 43 64             	lea    0x64(%ebx),%eax
    ch->closed = 1;
     fd7:	c7 43 14 01 00 00 00 	movl   $0x1,0x14(%ebx)
    cond_broadcast(&ch->not_full);
     fde:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    cond_broadcast(&ch->not_empty);
     fe4:	89 04 24             	mov    %eax,(%esp)
     fe7:	e8 54 fc ff ff       	call   c40 <cond_broadcast>
    cond_broadcast(&ch->not_full);
     fec:	89 1c 24             	mov    %ebx,(%esp)
     fef:	e8 4c fc ff ff       	call   c40 <cond_broadcast>
    mutex_unlock(&ch->lock);
     ff4:	83 c4 10             	add    $0x10,%esp
     ff7:	89 75 08             	mov    %esi,0x8(%ebp)
}
     ffa:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ffd:	5b                   	pop    %ebx
     ffe:	5e                   	pop    %esi
     fff:	5d                   	pop    %ebp
    mutex_unlock(&ch->lock);
    1000:	e9 1b fd ff ff       	jmp    d20 <mutex_unlock>
    1005:	66 90                	xchg   %ax,%ax
    1007:	66 90                	xchg   %ax,%ax
    1009:	66 90                	xchg   %ax,%ax
    100b:	66 90                	xchg   %ax,%ax
    100d:	66 90                	xchg   %ax,%ax
    100f:	90                   	nop

00001010 <rwlock_init>:
#include "types.h"
#include "uthreads.h"

void
rwlock_init(rwlock_t *l)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	53                   	push   %ebx
    1014:	83 ec 10             	sub    $0x10,%esp
    1017:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_init(&l->m);
    101a:	53                   	push   %ebx
    101b:	e8 70 fc ff ff       	call   c90 <mutex_init>
    cond_init(&l->can_read);
    1020:	8d 43 4c             	lea    0x4c(%ebx),%eax
    1023:	89 04 24             	mov    %eax,(%esp)
    1026:	e8 45 fb ff ff       	call   b70 <cond_init>
    cond_init(&l->can_write);
    102b:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1031:	89 04 24             	mov    %eax,(%esp)
    1034:	e8 37 fb ff ff       	call   b70 <cond_init>
    l->readers = 0;
    l->writers_wait = 0;
    l->writer_active = 0;
}
    1039:	83 c4 10             	add    $0x10,%esp
    l->readers = 0;
    103c:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%ebx)
    1043:	00 00 00 
    l->writers_wait = 0;
    1046:	c7 83 d8 00 00 00 00 	movl   $0x0,0xd8(%ebx)
    104d:	00 00 00 
    l->writer_active = 0;
    1050:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    1057:	00 00 00 
}
    105a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    105d:	c9                   	leave
    105e:	c3                   	ret
    105f:	90                   	nop

00001060 <reader_lock>:
//     mutex_unlock(&l->m);
// }

void
reader_lock(rwlock_t *l)
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	56                   	push   %esi
    1064:	53                   	push   %ebx
    1065:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    1068:	83 ec 0c             	sub    $0xc,%esp
    106b:	53                   	push   %ebx
    106c:	e8 3f fc ff ff       	call   cb0 <mutex_lock>
    while (l->writer_active)
    1071:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    1077:	83 c4 10             	add    $0x10,%esp
    107a:	85 d2                	test   %edx,%edx
    107c:	74 21                	je     109f <reader_lock+0x3f>
    107e:	8d 73 4c             	lea    0x4c(%ebx),%esi
    1081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_read, &l->m);
    1088:	83 ec 08             	sub    $0x8,%esp
    108b:	53                   	push   %ebx
    108c:	56                   	push   %esi
    108d:	e8 ee fa ff ff       	call   b80 <cond_wait>
    while (l->writer_active)
    1092:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
    1098:	83 c4 10             	add    $0x10,%esp
    109b:	85 c0                	test   %eax,%eax
    109d:	75 e9                	jne    1088 <reader_lock+0x28>
    l->readers++;
    109f:	83 83 d4 00 00 00 01 	addl   $0x1,0xd4(%ebx)
    mutex_unlock(&l->m);
    10a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    10a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10ac:	5b                   	pop    %ebx
    10ad:	5e                   	pop    %esi
    10ae:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    10af:	e9 6c fc ff ff       	jmp    d20 <mutex_unlock>
    10b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10bb:	00 
    10bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000010c0 <reader_unlock>:


void
reader_unlock(rwlock_t *l)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	53                   	push   %ebx
    10c4:	83 ec 10             	sub    $0x10,%esp
    10c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    10ca:	53                   	push   %ebx
    10cb:	e8 e0 fb ff ff       	call   cb0 <mutex_lock>
    l->readers--;
    10d0:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    if (l->readers == 0 && l->writers_wait > 0)
    10d6:	83 c4 10             	add    $0x10,%esp
    l->readers--;
    10d9:	83 e8 01             	sub    $0x1,%eax
    10dc:	89 83 d4 00 00 00    	mov    %eax,0xd4(%ebx)
    if (l->readers == 0 && l->writers_wait > 0)
    10e2:	85 c0                	test   %eax,%eax
    10e4:	75 0a                	jne    10f0 <reader_unlock+0x30>
    10e6:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    10ec:	85 c0                	test   %eax,%eax
    10ee:	7f 10                	jg     1100 <reader_unlock+0x40>
        cond_signal(&l->can_write);
    mutex_unlock(&l->m);
    10f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    10f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10f6:	c9                   	leave
    mutex_unlock(&l->m);
    10f7:	e9 24 fc ff ff       	jmp    d20 <mutex_unlock>
    10fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(&l->can_write);
    1100:	83 ec 0c             	sub    $0xc,%esp
    1103:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1109:	50                   	push   %eax
    110a:	e8 c1 fa ff ff       	call   bd0 <cond_signal>
    110f:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    1112:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1118:	c9                   	leave
    mutex_unlock(&l->m);
    1119:	e9 02 fc ff ff       	jmp    d20 <mutex_unlock>
    111e:	66 90                	xchg   %ax,%ax

00001120 <writer_lock>:

void
writer_lock(rwlock_t *l)
{
    1120:	55                   	push   %ebp
    1121:	89 e5                	mov    %esp,%ebp
    1123:	56                   	push   %esi
    1124:	53                   	push   %ebx
    1125:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    l->writers_wait++;
    while (l->writer_active || l->readers > 0)
        cond_wait(&l->can_write, &l->m);
    1128:	8d b3 90 00 00 00    	lea    0x90(%ebx),%esi
    mutex_lock(&l->m);
    112e:	83 ec 0c             	sub    $0xc,%esp
    1131:	53                   	push   %ebx
    1132:	e8 79 fb ff ff       	call   cb0 <mutex_lock>
    l->writers_wait++;
    1137:	83 83 d8 00 00 00 01 	addl   $0x1,0xd8(%ebx)
    while (l->writer_active || l->readers > 0)
    113e:	83 c4 10             	add    $0x10,%esp
    1141:	eb 12                	jmp    1155 <writer_lock+0x35>
    1143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_write, &l->m);
    1148:	83 ec 08             	sub    $0x8,%esp
    114b:	53                   	push   %ebx
    114c:	56                   	push   %esi
    114d:	e8 2e fa ff ff       	call   b80 <cond_wait>
    1152:	83 c4 10             	add    $0x10,%esp
    while (l->writer_active || l->readers > 0)
    1155:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    115b:	85 d2                	test   %edx,%edx
    115d:	75 e9                	jne    1148 <writer_lock+0x28>
    115f:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    1165:	85 c0                	test   %eax,%eax
    1167:	7f df                	jg     1148 <writer_lock+0x28>
    l->writers_wait--;
    1169:	83 ab d8 00 00 00 01 	subl   $0x1,0xd8(%ebx)
    l->writer_active = 1;
    1170:	c7 83 dc 00 00 00 01 	movl   $0x1,0xdc(%ebx)
    1177:	00 00 00 
    mutex_unlock(&l->m);
    117a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    117d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1180:	5b                   	pop    %ebx
    1181:	5e                   	pop    %esi
    1182:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    1183:	e9 98 fb ff ff       	jmp    d20 <mutex_unlock>
    1188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    118f:	00 

00001190 <writer_unlock>:

void
writer_unlock(rwlock_t *l)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	53                   	push   %ebx
    1194:	83 ec 10             	sub    $0x10,%esp
    1197:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    119a:	53                   	push   %ebx
    119b:	e8 10 fb ff ff       	call   cb0 <mutex_lock>
    l->writer_active = 0;
    if (l->writers_wait > 0)
    11a0:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    11a6:	83 c4 10             	add    $0x10,%esp
    l->writer_active = 0;
    11a9:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    11b0:	00 00 00 
    if (l->writers_wait > 0)
    11b3:	85 c0                	test   %eax,%eax
    11b5:	7e 21                	jle    11d8 <writer_unlock+0x48>
        cond_signal(&l->can_write);
    11b7:	83 ec 0c             	sub    $0xc,%esp
    11ba:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    11c0:	50                   	push   %eax
    11c1:	e8 0a fa ff ff       	call   bd0 <cond_signal>
    11c6:	83 c4 10             	add    $0x10,%esp
    else
        cond_broadcast(&l->can_read);
    mutex_unlock(&l->m);
    11c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    11cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11cf:	c9                   	leave
    mutex_unlock(&l->m);
    11d0:	e9 4b fb ff ff       	jmp    d20 <mutex_unlock>
    11d5:	8d 76 00             	lea    0x0(%esi),%esi
        cond_broadcast(&l->can_read);
    11d8:	83 ec 0c             	sub    $0xc,%esp
    11db:	8d 43 4c             	lea    0x4c(%ebx),%eax
    11de:	50                   	push   %eax
    11df:	e8 5c fa ff ff       	call   c40 <cond_broadcast>
    11e4:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    11e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    11ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11ed:	c9                   	leave
    mutex_unlock(&l->m);
    11ee:	e9 2d fb ff ff       	jmp    d20 <mutex_unlock>
