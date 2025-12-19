
_t_rw:     file format elf32-i386


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
    thread_init();
    rwlock_init(&lock);

    int r[READERS], w[WRITERS];

    for (int i = 0; i < READERS; i++)
       f:	31 db                	xor    %ebx,%ebx
{
      11:	51                   	push   %ecx
      12:	83 ec 1c             	sub    $0x1c,%esp
    thread_init();
      15:	e8 f6 07 00 00       	call   810 <thread_init>
    rwlock_init(&lock);
      1a:	83 ec 0c             	sub    $0xc,%esp
      1d:	68 c0 1a 00 00       	push   $0x1ac0
      22:	e8 99 10 00 00       	call   10c0 <rwlock_init>
      27:	83 c4 10             	add    $0x10,%esp
        r[i] = thread_create(reader, (void *)i);
      2a:	83 ec 08             	sub    $0x8,%esp
      2d:	53                   	push   %ebx
      2e:	68 b0 00 00 00       	push   $0xb0
      33:	e8 68 08 00 00       	call   8a0 <thread_create>
    for (int i = 0; i < READERS; i++)
      38:	83 c4 10             	add    $0x10,%esp
        r[i] = thread_create(reader, (void *)i);
      3b:	89 44 9d dc          	mov    %eax,-0x24(%ebp,%ebx,4)
    for (int i = 0; i < READERS; i++)
      3f:	83 c3 01             	add    $0x1,%ebx
      42:	83 fb 03             	cmp    $0x3,%ebx
      45:	75 e3                	jne    2a <main+0x2a>

    for (int i = 0; i < WRITERS; i++)
        w[i] = thread_create(writer, (void *)i);
      47:	83 ec 08             	sub    $0x8,%esp
      4a:	6a 00                	push   $0x0
      4c:	68 10 01 00 00       	push   $0x110
      51:	e8 4a 08 00 00       	call   8a0 <thread_create>
      56:	89 c6                	mov    %eax,%esi
      58:	58                   	pop    %eax
      59:	5a                   	pop    %edx
      5a:	6a 01                	push   $0x1
      5c:	68 10 01 00 00       	push   $0x110
      61:	e8 3a 08 00 00       	call   8a0 <thread_create>

    for (int i = 0; i < READERS; i++)
        thread_join(r[i]);
      66:	59                   	pop    %ecx
      67:	ff 75 dc             	push   -0x24(%ebp)
        w[i] = thread_create(writer, (void *)i);
      6a:	89 c3                	mov    %eax,%ebx
        thread_join(r[i]);
      6c:	e8 1f 0a 00 00       	call   a90 <thread_join>
      71:	58                   	pop    %eax
      72:	ff 75 e0             	push   -0x20(%ebp)
      75:	e8 16 0a 00 00       	call   a90 <thread_join>
      7a:	58                   	pop    %eax
      7b:	ff 75 e4             	push   -0x1c(%ebp)
      7e:	e8 0d 0a 00 00       	call   a90 <thread_join>

    for (int i = 0; i < WRITERS; i++)
        thread_join(w[i]);
      83:	89 34 24             	mov    %esi,(%esp)
      86:	e8 05 0a 00 00       	call   a90 <thread_join>
      8b:	89 1c 24             	mov    %ebx,(%esp)
      8e:	e8 fd 09 00 00       	call   a90 <thread_join>

    printf(1, "Reader-writer test done\n");
      93:	58                   	pop    %eax
      94:	5a                   	pop    %edx
      95:	68 e5 12 00 00       	push   $0x12e5
      9a:	6a 01                	push   $0x1
      9c:	e8 5f 04 00 00       	call   500 <printf>
    exit();
      a1:	e8 0d 03 00 00       	call   3b3 <exit>
      a6:	66 90                	xchg   %ax,%ax
      a8:	66 90                	xchg   %ax,%ax
      aa:	66 90                	xchg   %ax,%ax
      ac:	66 90                	xchg   %ax,%ax
      ae:	66 90                	xchg   %ax,%ax

000000b0 <reader>:
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	56                   	push   %esi
      b4:	53                   	push   %ebx
      b5:	8b 75 08             	mov    0x8(%ebp),%esi
    int id = (int)arg;
      b8:	bb 05 00 00 00       	mov    $0x5,%ebx
      bd:	8d 76 00             	lea    0x0(%esi),%esi
        reader_lock(&lock);
      c0:	83 ec 0c             	sub    $0xc,%esp
      c3:	68 c0 1a 00 00       	push   $0x1ac0
      c8:	e8 43 10 00 00       	call   1110 <reader_lock>
        printf(1, "Reader %d: reading value = %d\n", id, value);
      cd:	ff 35 a0 1b 00 00    	push   0x1ba0
      d3:	56                   	push   %esi
      d4:	68 a4 12 00 00       	push   $0x12a4
      d9:	6a 01                	push   $0x1
      db:	e8 20 04 00 00       	call   500 <printf>
        reader_unlock(&lock);
      e0:	83 c4 14             	add    $0x14,%esp
      e3:	68 c0 1a 00 00       	push   $0x1ac0
      e8:	e8 83 10 00 00       	call   1170 <reader_unlock>
        thread_yield();
      ed:	e8 1e 09 00 00       	call   a10 <thread_yield>
    for (int i = 0; i < 5; i++) {
      f2:	83 c4 10             	add    $0x10,%esp
      f5:	83 eb 01             	sub    $0x1,%ebx
      f8:	75 c6                	jne    c0 <reader+0x10>
}
      fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
      fd:	31 c0                	xor    %eax,%eax
      ff:	5b                   	pop    %ebx
     100:	5e                   	pop    %esi
     101:	5d                   	pop    %ebp
     102:	c3                   	ret
     103:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     10a:	00 
     10b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000110 <writer>:
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	56                   	push   %esi
     114:	53                   	push   %ebx
     115:	8b 75 08             	mov    0x8(%ebp),%esi
    int id = (int)arg;
     118:	bb 03 00 00 00       	mov    $0x3,%ebx
        writer_lock(&lock);
     11d:	83 ec 0c             	sub    $0xc,%esp
     120:	68 c0 1a 00 00       	push   $0x1ac0
     125:	e8 a6 10 00 00       	call   11d0 <writer_lock>
        value++;
     12a:	a1 a0 1b 00 00       	mov    0x1ba0,%eax
     12f:	83 c0 01             	add    $0x1,%eax
     132:	a3 a0 1b 00 00       	mov    %eax,0x1ba0
        printf(1, "Writer %d: wrote new value = %d\n", id, value);
     137:	50                   	push   %eax
     138:	56                   	push   %esi
     139:	68 c4 12 00 00       	push   $0x12c4
     13e:	6a 01                	push   $0x1
     140:	e8 bb 03 00 00       	call   500 <printf>
        writer_unlock(&lock);
     145:	83 c4 14             	add    $0x14,%esp
     148:	68 c0 1a 00 00       	push   $0x1ac0
     14d:	e8 ee 10 00 00       	call   1240 <writer_unlock>
        thread_yield();
     152:	e8 b9 08 00 00       	call   a10 <thread_yield>
    for (int i = 0; i < 3; i++) {
     157:	83 c4 10             	add    $0x10,%esp
     15a:	83 eb 01             	sub    $0x1,%ebx
     15d:	75 be                	jne    11d <writer+0xd>
}
     15f:	8d 65 f8             	lea    -0x8(%ebp),%esp
     162:	31 c0                	xor    %eax,%eax
     164:	5b                   	pop    %ebx
     165:	5e                   	pop    %esi
     166:	5d                   	pop    %ebp
     167:	c3                   	ret
     168:	66 90                	xchg   %ax,%ax
     16a:	66 90                	xchg   %ax,%ax
     16c:	66 90                	xchg   %ax,%ax
     16e:	66 90                	xchg   %ax,%ax

00000170 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     170:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     171:	31 c0                	xor    %eax,%eax
{
     173:	89 e5                	mov    %esp,%ebp
     175:	53                   	push   %ebx
     176:	8b 4d 08             	mov    0x8(%ebp),%ecx
     179:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     180:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     184:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     187:	83 c0 01             	add    $0x1,%eax
     18a:	84 d2                	test   %dl,%dl
     18c:	75 f2                	jne    180 <strcpy+0x10>
    ;
  return os;
}
     18e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     191:	89 c8                	mov    %ecx,%eax
     193:	c9                   	leave
     194:	c3                   	ret
     195:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     19c:	00 
     19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     1a0:	55                   	push   %ebp
     1a1:	89 e5                	mov    %esp,%ebp
     1a3:	53                   	push   %ebx
     1a4:	8b 55 08             	mov    0x8(%ebp),%edx
     1a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     1aa:	0f b6 02             	movzbl (%edx),%eax
     1ad:	84 c0                	test   %al,%al
     1af:	75 17                	jne    1c8 <strcmp+0x28>
     1b1:	eb 3a                	jmp    1ed <strcmp+0x4d>
     1b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     1b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     1bc:	83 c2 01             	add    $0x1,%edx
     1bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     1c2:	84 c0                	test   %al,%al
     1c4:	74 1a                	je     1e0 <strcmp+0x40>
     1c6:	89 d9                	mov    %ebx,%ecx
     1c8:	0f b6 19             	movzbl (%ecx),%ebx
     1cb:	38 c3                	cmp    %al,%bl
     1cd:	74 e9                	je     1b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     1cf:	29 d8                	sub    %ebx,%eax
}
     1d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     1d4:	c9                   	leave
     1d5:	c3                   	ret
     1d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     1dd:	00 
     1de:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     1e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     1e4:	31 c0                	xor    %eax,%eax
     1e6:	29 d8                	sub    %ebx,%eax
}
     1e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     1eb:	c9                   	leave
     1ec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     1ed:	0f b6 19             	movzbl (%ecx),%ebx
     1f0:	31 c0                	xor    %eax,%eax
     1f2:	eb db                	jmp    1cf <strcmp+0x2f>
     1f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     1fb:	00 
     1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000200 <strlen>:

uint
strlen(const char *s)
{
     200:	55                   	push   %ebp
     201:	89 e5                	mov    %esp,%ebp
     203:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     206:	80 3a 00             	cmpb   $0x0,(%edx)
     209:	74 15                	je     220 <strlen+0x20>
     20b:	31 c0                	xor    %eax,%eax
     20d:	8d 76 00             	lea    0x0(%esi),%esi
     210:	83 c0 01             	add    $0x1,%eax
     213:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     217:	89 c1                	mov    %eax,%ecx
     219:	75 f5                	jne    210 <strlen+0x10>
    ;
  return n;
}
     21b:	89 c8                	mov    %ecx,%eax
     21d:	5d                   	pop    %ebp
     21e:	c3                   	ret
     21f:	90                   	nop
  for(n = 0; s[n]; n++)
     220:	31 c9                	xor    %ecx,%ecx
}
     222:	5d                   	pop    %ebp
     223:	89 c8                	mov    %ecx,%eax
     225:	c3                   	ret
     226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     22d:	00 
     22e:	66 90                	xchg   %ax,%ax

00000230 <memset>:

void*
memset(void *dst, int c, uint n)
{
     230:	55                   	push   %ebp
     231:	89 e5                	mov    %esp,%ebp
     233:	57                   	push   %edi
     234:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     237:	8b 4d 10             	mov    0x10(%ebp),%ecx
     23a:	8b 45 0c             	mov    0xc(%ebp),%eax
     23d:	89 d7                	mov    %edx,%edi
     23f:	fc                   	cld
     240:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     242:	8b 7d fc             	mov    -0x4(%ebp),%edi
     245:	89 d0                	mov    %edx,%eax
     247:	c9                   	leave
     248:	c3                   	ret
     249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000250 <strchr>:

char*
strchr(const char *s, char c)
{
     250:	55                   	push   %ebp
     251:	89 e5                	mov    %esp,%ebp
     253:	8b 45 08             	mov    0x8(%ebp),%eax
     256:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     25a:	0f b6 10             	movzbl (%eax),%edx
     25d:	84 d2                	test   %dl,%dl
     25f:	75 12                	jne    273 <strchr+0x23>
     261:	eb 1d                	jmp    280 <strchr+0x30>
     263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     268:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     26c:	83 c0 01             	add    $0x1,%eax
     26f:	84 d2                	test   %dl,%dl
     271:	74 0d                	je     280 <strchr+0x30>
    if(*s == c)
     273:	38 d1                	cmp    %dl,%cl
     275:	75 f1                	jne    268 <strchr+0x18>
      return (char*)s;
  return 0;
}
     277:	5d                   	pop    %ebp
     278:	c3                   	ret
     279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     280:	31 c0                	xor    %eax,%eax
}
     282:	5d                   	pop    %ebp
     283:	c3                   	ret
     284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     28b:	00 
     28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <gets>:

char*
gets(char *buf, int max)
{
     290:	55                   	push   %ebp
     291:	89 e5                	mov    %esp,%ebp
     293:	57                   	push   %edi
     294:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     295:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
     298:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     299:	31 db                	xor    %ebx,%ebx
{
     29b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     29e:	eb 27                	jmp    2c7 <gets+0x37>
    cc = read(0, &c, 1);
     2a0:	83 ec 04             	sub    $0x4,%esp
     2a3:	6a 01                	push   $0x1
     2a5:	56                   	push   %esi
     2a6:	6a 00                	push   $0x0
     2a8:	e8 1e 01 00 00       	call   3cb <read>
    if(cc < 1)
     2ad:	83 c4 10             	add    $0x10,%esp
     2b0:	85 c0                	test   %eax,%eax
     2b2:	7e 1d                	jle    2d1 <gets+0x41>
      break;
    buf[i++] = c;
     2b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     2b8:	8b 55 08             	mov    0x8(%ebp),%edx
     2bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     2bf:	3c 0a                	cmp    $0xa,%al
     2c1:	74 10                	je     2d3 <gets+0x43>
     2c3:	3c 0d                	cmp    $0xd,%al
     2c5:	74 0c                	je     2d3 <gets+0x43>
  for(i=0; i+1 < max; ){
     2c7:	89 df                	mov    %ebx,%edi
     2c9:	83 c3 01             	add    $0x1,%ebx
     2cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     2cf:	7c cf                	jl     2a0 <gets+0x10>
     2d1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
     2d3:	8b 45 08             	mov    0x8(%ebp),%eax
     2d6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
     2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
     2dd:	5b                   	pop    %ebx
     2de:	5e                   	pop    %esi
     2df:	5f                   	pop    %edi
     2e0:	5d                   	pop    %ebp
     2e1:	c3                   	ret
     2e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     2e9:	00 
     2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002f0 <stat>:

int
stat(const char *n, struct stat *st)
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	56                   	push   %esi
     2f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     2f5:	83 ec 08             	sub    $0x8,%esp
     2f8:	6a 00                	push   $0x0
     2fa:	ff 75 08             	push   0x8(%ebp)
     2fd:	e8 f1 00 00 00       	call   3f3 <open>
  if(fd < 0)
     302:	83 c4 10             	add    $0x10,%esp
     305:	85 c0                	test   %eax,%eax
     307:	78 27                	js     330 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     309:	83 ec 08             	sub    $0x8,%esp
     30c:	ff 75 0c             	push   0xc(%ebp)
     30f:	89 c3                	mov    %eax,%ebx
     311:	50                   	push   %eax
     312:	e8 f4 00 00 00       	call   40b <fstat>
  close(fd);
     317:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     31a:	89 c6                	mov    %eax,%esi
  close(fd);
     31c:	e8 ba 00 00 00       	call   3db <close>
  return r;
     321:	83 c4 10             	add    $0x10,%esp
}
     324:	8d 65 f8             	lea    -0x8(%ebp),%esp
     327:	89 f0                	mov    %esi,%eax
     329:	5b                   	pop    %ebx
     32a:	5e                   	pop    %esi
     32b:	5d                   	pop    %ebp
     32c:	c3                   	ret
     32d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     330:	be ff ff ff ff       	mov    $0xffffffff,%esi
     335:	eb ed                	jmp    324 <stat+0x34>
     337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     33e:	00 
     33f:	90                   	nop

00000340 <atoi>:

int
atoi(const char *s)
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	53                   	push   %ebx
     344:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     347:	0f be 02             	movsbl (%edx),%eax
     34a:	8d 48 d0             	lea    -0x30(%eax),%ecx
     34d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     350:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     355:	77 1e                	ja     375 <atoi+0x35>
     357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     35e:	00 
     35f:	90                   	nop
    n = n*10 + *s++ - '0';
     360:	83 c2 01             	add    $0x1,%edx
     363:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     366:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     36a:	0f be 02             	movsbl (%edx),%eax
     36d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     370:	80 fb 09             	cmp    $0x9,%bl
     373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
     375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     378:	89 c8                	mov    %ecx,%eax
     37a:	c9                   	leave
     37b:	c3                   	ret
     37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	57                   	push   %edi
     384:	8b 45 10             	mov    0x10(%ebp),%eax
     387:	8b 55 08             	mov    0x8(%ebp),%edx
     38a:	56                   	push   %esi
     38b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     38e:	85 c0                	test   %eax,%eax
     390:	7e 13                	jle    3a5 <memmove+0x25>
     392:	01 d0                	add    %edx,%eax
  dst = vdst;
     394:	89 d7                	mov    %edx,%edi
     396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     39d:	00 
     39e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     3a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     3a1:	39 f8                	cmp    %edi,%eax
     3a3:	75 fb                	jne    3a0 <memmove+0x20>
  return vdst;
}
     3a5:	5e                   	pop    %esi
     3a6:	89 d0                	mov    %edx,%eax
     3a8:	5f                   	pop    %edi
     3a9:	5d                   	pop    %ebp
     3aa:	c3                   	ret

000003ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     3ab:	b8 01 00 00 00       	mov    $0x1,%eax
     3b0:	cd 40                	int    $0x40
     3b2:	c3                   	ret

000003b3 <exit>:
SYSCALL(exit)
     3b3:	b8 02 00 00 00       	mov    $0x2,%eax
     3b8:	cd 40                	int    $0x40
     3ba:	c3                   	ret

000003bb <wait>:
SYSCALL(wait)
     3bb:	b8 03 00 00 00       	mov    $0x3,%eax
     3c0:	cd 40                	int    $0x40
     3c2:	c3                   	ret

000003c3 <pipe>:
SYSCALL(pipe)
     3c3:	b8 04 00 00 00       	mov    $0x4,%eax
     3c8:	cd 40                	int    $0x40
     3ca:	c3                   	ret

000003cb <read>:
SYSCALL(read)
     3cb:	b8 05 00 00 00       	mov    $0x5,%eax
     3d0:	cd 40                	int    $0x40
     3d2:	c3                   	ret

000003d3 <write>:
SYSCALL(write)
     3d3:	b8 10 00 00 00       	mov    $0x10,%eax
     3d8:	cd 40                	int    $0x40
     3da:	c3                   	ret

000003db <close>:
SYSCALL(close)
     3db:	b8 15 00 00 00       	mov    $0x15,%eax
     3e0:	cd 40                	int    $0x40
     3e2:	c3                   	ret

000003e3 <kill>:
SYSCALL(kill)
     3e3:	b8 06 00 00 00       	mov    $0x6,%eax
     3e8:	cd 40                	int    $0x40
     3ea:	c3                   	ret

000003eb <exec>:
SYSCALL(exec)
     3eb:	b8 07 00 00 00       	mov    $0x7,%eax
     3f0:	cd 40                	int    $0x40
     3f2:	c3                   	ret

000003f3 <open>:
SYSCALL(open)
     3f3:	b8 0f 00 00 00       	mov    $0xf,%eax
     3f8:	cd 40                	int    $0x40
     3fa:	c3                   	ret

000003fb <mknod>:
SYSCALL(mknod)
     3fb:	b8 11 00 00 00       	mov    $0x11,%eax
     400:	cd 40                	int    $0x40
     402:	c3                   	ret

00000403 <unlink>:
SYSCALL(unlink)
     403:	b8 12 00 00 00       	mov    $0x12,%eax
     408:	cd 40                	int    $0x40
     40a:	c3                   	ret

0000040b <fstat>:
SYSCALL(fstat)
     40b:	b8 08 00 00 00       	mov    $0x8,%eax
     410:	cd 40                	int    $0x40
     412:	c3                   	ret

00000413 <link>:
SYSCALL(link)
     413:	b8 13 00 00 00       	mov    $0x13,%eax
     418:	cd 40                	int    $0x40
     41a:	c3                   	ret

0000041b <mkdir>:
SYSCALL(mkdir)
     41b:	b8 14 00 00 00       	mov    $0x14,%eax
     420:	cd 40                	int    $0x40
     422:	c3                   	ret

00000423 <chdir>:
SYSCALL(chdir)
     423:	b8 09 00 00 00       	mov    $0x9,%eax
     428:	cd 40                	int    $0x40
     42a:	c3                   	ret

0000042b <dup>:
SYSCALL(dup)
     42b:	b8 0a 00 00 00       	mov    $0xa,%eax
     430:	cd 40                	int    $0x40
     432:	c3                   	ret

00000433 <getpid>:
SYSCALL(getpid)
     433:	b8 0b 00 00 00       	mov    $0xb,%eax
     438:	cd 40                	int    $0x40
     43a:	c3                   	ret

0000043b <sbrk>:
SYSCALL(sbrk)
     43b:	b8 0c 00 00 00       	mov    $0xc,%eax
     440:	cd 40                	int    $0x40
     442:	c3                   	ret

00000443 <sleep>:
SYSCALL(sleep)
     443:	b8 0d 00 00 00       	mov    $0xd,%eax
     448:	cd 40                	int    $0x40
     44a:	c3                   	ret

0000044b <uptime>:
SYSCALL(uptime)
     44b:	b8 0e 00 00 00       	mov    $0xe,%eax
     450:	cd 40                	int    $0x40
     452:	c3                   	ret
     453:	66 90                	xchg   %ax,%ax
     455:	66 90                	xchg   %ax,%ax
     457:	66 90                	xchg   %ax,%ax
     459:	66 90                	xchg   %ax,%ax
     45b:	66 90                	xchg   %ax,%ax
     45d:	66 90                	xchg   %ax,%ax
     45f:	90                   	nop

00000460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	57                   	push   %edi
     464:	56                   	push   %esi
     465:	53                   	push   %ebx
     466:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     468:	89 d1                	mov    %edx,%ecx
{
     46a:	83 ec 3c             	sub    $0x3c,%esp
     46d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
     470:	85 d2                	test   %edx,%edx
     472:	0f 89 80 00 00 00    	jns    4f8 <printint+0x98>
     478:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     47c:	74 7a                	je     4f8 <printint+0x98>
    x = -xx;
     47e:	f7 d9                	neg    %ecx
    neg = 1;
     480:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
     485:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     488:	31 f6                	xor    %esi,%esi
     48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     490:	89 c8                	mov    %ecx,%eax
     492:	31 d2                	xor    %edx,%edx
     494:	89 f7                	mov    %esi,%edi
     496:	f7 f3                	div    %ebx
     498:	8d 76 01             	lea    0x1(%esi),%esi
     49b:	0f b6 92 60 13 00 00 	movzbl 0x1360(%edx),%edx
     4a2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
     4a6:	89 ca                	mov    %ecx,%edx
     4a8:	89 c1                	mov    %eax,%ecx
     4aa:	39 da                	cmp    %ebx,%edx
     4ac:	73 e2                	jae    490 <printint+0x30>
  if(neg)
     4ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     4b1:	85 c0                	test   %eax,%eax
     4b3:	74 07                	je     4bc <printint+0x5c>
    buf[i++] = '-';
     4b5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
     4ba:	89 f7                	mov    %esi,%edi
     4bc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
     4bf:	8b 75 c0             	mov    -0x40(%ebp),%esi
     4c2:	01 df                	add    %ebx,%edi
     4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
     4c8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
     4cb:	83 ec 04             	sub    $0x4,%esp
     4ce:	88 45 d7             	mov    %al,-0x29(%ebp)
     4d1:	8d 45 d7             	lea    -0x29(%ebp),%eax
     4d4:	6a 01                	push   $0x1
     4d6:	50                   	push   %eax
     4d7:	56                   	push   %esi
     4d8:	e8 f6 fe ff ff       	call   3d3 <write>
  while(--i >= 0)
     4dd:	89 f8                	mov    %edi,%eax
     4df:	83 c4 10             	add    $0x10,%esp
     4e2:	83 ef 01             	sub    $0x1,%edi
     4e5:	39 c3                	cmp    %eax,%ebx
     4e7:	75 df                	jne    4c8 <printint+0x68>
}
     4e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4ec:	5b                   	pop    %ebx
     4ed:	5e                   	pop    %esi
     4ee:	5f                   	pop    %edi
     4ef:	5d                   	pop    %ebp
     4f0:	c3                   	ret
     4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     4f8:	31 c0                	xor    %eax,%eax
     4fa:	eb 89                	jmp    485 <printint+0x25>
     4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     500:	55                   	push   %ebp
     501:	89 e5                	mov    %esp,%ebp
     503:	57                   	push   %edi
     504:	56                   	push   %esi
     505:	53                   	push   %ebx
     506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     509:	8b 75 0c             	mov    0xc(%ebp),%esi
{
     50c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
     50f:	0f b6 1e             	movzbl (%esi),%ebx
     512:	83 c6 01             	add    $0x1,%esi
     515:	84 db                	test   %bl,%bl
     517:	74 67                	je     580 <printf+0x80>
     519:	8d 4d 10             	lea    0x10(%ebp),%ecx
     51c:	31 d2                	xor    %edx,%edx
     51e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
     521:	eb 34                	jmp    557 <printf+0x57>
     523:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     528:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     52b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     530:	83 f8 25             	cmp    $0x25,%eax
     533:	74 18                	je     54d <printf+0x4d>
  write(fd, &c, 1);
     535:	83 ec 04             	sub    $0x4,%esp
     538:	8d 45 e7             	lea    -0x19(%ebp),%eax
     53b:	88 5d e7             	mov    %bl,-0x19(%ebp)
     53e:	6a 01                	push   $0x1
     540:	50                   	push   %eax
     541:	57                   	push   %edi
     542:	e8 8c fe ff ff       	call   3d3 <write>
     547:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     54a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     54d:	0f b6 1e             	movzbl (%esi),%ebx
     550:	83 c6 01             	add    $0x1,%esi
     553:	84 db                	test   %bl,%bl
     555:	74 29                	je     580 <printf+0x80>
    c = fmt[i] & 0xff;
     557:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     55a:	85 d2                	test   %edx,%edx
     55c:	74 ca                	je     528 <printf+0x28>
      }
    } else if(state == '%'){
     55e:	83 fa 25             	cmp    $0x25,%edx
     561:	75 ea                	jne    54d <printf+0x4d>
      if(c == 'd'){
     563:	83 f8 25             	cmp    $0x25,%eax
     566:	0f 84 04 01 00 00    	je     670 <printf+0x170>
     56c:	83 e8 63             	sub    $0x63,%eax
     56f:	83 f8 15             	cmp    $0x15,%eax
     572:	77 1c                	ja     590 <printf+0x90>
     574:	ff 24 85 08 13 00 00 	jmp    *0x1308(,%eax,4)
     57b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     580:	8d 65 f4             	lea    -0xc(%ebp),%esp
     583:	5b                   	pop    %ebx
     584:	5e                   	pop    %esi
     585:	5f                   	pop    %edi
     586:	5d                   	pop    %ebp
     587:	c3                   	ret
     588:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     58f:	00 
  write(fd, &c, 1);
     590:	83 ec 04             	sub    $0x4,%esp
     593:	8d 55 e7             	lea    -0x19(%ebp),%edx
     596:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     59a:	6a 01                	push   $0x1
     59c:	52                   	push   %edx
     59d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     5a0:	57                   	push   %edi
     5a1:	e8 2d fe ff ff       	call   3d3 <write>
     5a6:	83 c4 0c             	add    $0xc,%esp
     5a9:	88 5d e7             	mov    %bl,-0x19(%ebp)
     5ac:	6a 01                	push   $0x1
     5ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5b1:	52                   	push   %edx
     5b2:	57                   	push   %edi
     5b3:	e8 1b fe ff ff       	call   3d3 <write>
        putc(fd, c);
     5b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
     5bb:	31 d2                	xor    %edx,%edx
     5bd:	eb 8e                	jmp    54d <printf+0x4d>
     5bf:	90                   	nop
        printint(fd, *ap, 16, 0);
     5c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     5c3:	83 ec 0c             	sub    $0xc,%esp
     5c6:	b9 10 00 00 00       	mov    $0x10,%ecx
     5cb:	8b 13                	mov    (%ebx),%edx
     5cd:	6a 00                	push   $0x0
     5cf:	89 f8                	mov    %edi,%eax
        ap++;
     5d1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
     5d4:	e8 87 fe ff ff       	call   460 <printint>
        ap++;
     5d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     5dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
     5df:	31 d2                	xor    %edx,%edx
     5e1:	e9 67 ff ff ff       	jmp    54d <printf+0x4d>
        s = (char*)*ap;
     5e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
     5e9:	8b 18                	mov    (%eax),%ebx
        ap++;
     5eb:	83 c0 04             	add    $0x4,%eax
     5ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
     5f1:	85 db                	test   %ebx,%ebx
     5f3:	0f 84 87 00 00 00    	je     680 <printf+0x180>
        while(*s != 0){
     5f9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
     5fc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
     5fe:	84 c0                	test   %al,%al
     600:	0f 84 47 ff ff ff    	je     54d <printf+0x4d>
     606:	8d 55 e7             	lea    -0x19(%ebp),%edx
     609:	89 75 d4             	mov    %esi,-0x2c(%ebp)
     60c:	89 de                	mov    %ebx,%esi
     60e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
     610:	83 ec 04             	sub    $0x4,%esp
     613:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
     616:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     619:	6a 01                	push   $0x1
     61b:	53                   	push   %ebx
     61c:	57                   	push   %edi
     61d:	e8 b1 fd ff ff       	call   3d3 <write>
        while(*s != 0){
     622:	0f b6 06             	movzbl (%esi),%eax
     625:	83 c4 10             	add    $0x10,%esp
     628:	84 c0                	test   %al,%al
     62a:	75 e4                	jne    610 <printf+0x110>
      state = 0;
     62c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
     62f:	31 d2                	xor    %edx,%edx
     631:	e9 17 ff ff ff       	jmp    54d <printf+0x4d>
        printint(fd, *ap, 10, 1);
     636:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     639:	83 ec 0c             	sub    $0xc,%esp
     63c:	b9 0a 00 00 00       	mov    $0xa,%ecx
     641:	8b 13                	mov    (%ebx),%edx
     643:	6a 01                	push   $0x1
     645:	eb 88                	jmp    5cf <printf+0xcf>
        putc(fd, *ap);
     647:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
     64a:	83 ec 04             	sub    $0x4,%esp
     64d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
     650:	8b 03                	mov    (%ebx),%eax
        ap++;
     652:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
     655:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     658:	6a 01                	push   $0x1
     65a:	52                   	push   %edx
     65b:	57                   	push   %edi
     65c:	e8 72 fd ff ff       	call   3d3 <write>
        ap++;
     661:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     664:	83 c4 10             	add    $0x10,%esp
      state = 0;
     667:	31 d2                	xor    %edx,%edx
     669:	e9 df fe ff ff       	jmp    54d <printf+0x4d>
     66e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
     670:	83 ec 04             	sub    $0x4,%esp
     673:	88 5d e7             	mov    %bl,-0x19(%ebp)
     676:	8d 55 e7             	lea    -0x19(%ebp),%edx
     679:	6a 01                	push   $0x1
     67b:	e9 31 ff ff ff       	jmp    5b1 <printf+0xb1>
     680:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
     685:	bb fe 12 00 00       	mov    $0x12fe,%ebx
     68a:	e9 77 ff ff ff       	jmp    606 <printf+0x106>
     68f:	90                   	nop

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     690:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     691:	a1 a4 1b 00 00       	mov    0x1ba4,%eax
{
     696:	89 e5                	mov    %esp,%ebp
     698:	57                   	push   %edi
     699:	56                   	push   %esi
     69a:	53                   	push   %ebx
     69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     69e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     6a8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     6aa:	39 c8                	cmp    %ecx,%eax
     6ac:	73 32                	jae    6e0 <free+0x50>
     6ae:	39 d1                	cmp    %edx,%ecx
     6b0:	72 04                	jb     6b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     6b2:	39 d0                	cmp    %edx,%eax
     6b4:	72 32                	jb     6e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
     6b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
     6b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     6bc:	39 fa                	cmp    %edi,%edx
     6be:	74 30                	je     6f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     6c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     6c3:	8b 50 04             	mov    0x4(%eax),%edx
     6c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     6c9:	39 f1                	cmp    %esi,%ecx
     6cb:	74 3a                	je     707 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     6cd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
     6cf:	5b                   	pop    %ebx
  freep = p;
     6d0:	a3 a4 1b 00 00       	mov    %eax,0x1ba4
}
     6d5:	5e                   	pop    %esi
     6d6:	5f                   	pop    %edi
     6d7:	5d                   	pop    %ebp
     6d8:	c3                   	ret
     6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     6e0:	39 d0                	cmp    %edx,%eax
     6e2:	72 04                	jb     6e8 <free+0x58>
     6e4:	39 d1                	cmp    %edx,%ecx
     6e6:	72 ce                	jb     6b6 <free+0x26>
{
     6e8:	89 d0                	mov    %edx,%eax
     6ea:	eb bc                	jmp    6a8 <free+0x18>
     6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
     6f0:	03 72 04             	add    0x4(%edx),%esi
     6f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     6f6:	8b 10                	mov    (%eax),%edx
     6f8:	8b 12                	mov    (%edx),%edx
     6fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     6fd:	8b 50 04             	mov    0x4(%eax),%edx
     700:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     703:	39 f1                	cmp    %esi,%ecx
     705:	75 c6                	jne    6cd <free+0x3d>
    p->s.size += bp->s.size;
     707:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
     70a:	a3 a4 1b 00 00       	mov    %eax,0x1ba4
    p->s.size += bp->s.size;
     70f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     712:	8b 4b f8             	mov    -0x8(%ebx),%ecx
     715:	89 08                	mov    %ecx,(%eax)
}
     717:	5b                   	pop    %ebx
     718:	5e                   	pop    %esi
     719:	5f                   	pop    %edi
     71a:	5d                   	pop    %ebp
     71b:	c3                   	ret
     71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     720:	55                   	push   %ebp
     721:	89 e5                	mov    %esp,%ebp
     723:	57                   	push   %edi
     724:	56                   	push   %esi
     725:	53                   	push   %ebx
     726:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     729:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     72c:	8b 15 a4 1b 00 00    	mov    0x1ba4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     732:	8d 78 07             	lea    0x7(%eax),%edi
     735:	c1 ef 03             	shr    $0x3,%edi
     738:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
     73b:	85 d2                	test   %edx,%edx
     73d:	0f 84 8d 00 00 00    	je     7d0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     743:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     745:	8b 48 04             	mov    0x4(%eax),%ecx
     748:	39 f9                	cmp    %edi,%ecx
     74a:	73 64                	jae    7b0 <malloc+0x90>
  if(nu < 4096)
     74c:	bb 00 10 00 00       	mov    $0x1000,%ebx
     751:	39 df                	cmp    %ebx,%edi
     753:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
     756:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
     75d:	eb 0a                	jmp    769 <malloc+0x49>
     75f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     760:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     762:	8b 48 04             	mov    0x4(%eax),%ecx
     765:	39 f9                	cmp    %edi,%ecx
     767:	73 47                	jae    7b0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     769:	89 c2                	mov    %eax,%edx
     76b:	3b 05 a4 1b 00 00    	cmp    0x1ba4,%eax
     771:	75 ed                	jne    760 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
     773:	83 ec 0c             	sub    $0xc,%esp
     776:	56                   	push   %esi
     777:	e8 bf fc ff ff       	call   43b <sbrk>
  if(p == (char*)-1)
     77c:	83 c4 10             	add    $0x10,%esp
     77f:	83 f8 ff             	cmp    $0xffffffff,%eax
     782:	74 1c                	je     7a0 <malloc+0x80>
  hp->s.size = nu;
     784:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     787:	83 ec 0c             	sub    $0xc,%esp
     78a:	83 c0 08             	add    $0x8,%eax
     78d:	50                   	push   %eax
     78e:	e8 fd fe ff ff       	call   690 <free>
  return freep;
     793:	8b 15 a4 1b 00 00    	mov    0x1ba4,%edx
      if((p = morecore(nunits)) == 0)
     799:	83 c4 10             	add    $0x10,%esp
     79c:	85 d2                	test   %edx,%edx
     79e:	75 c0                	jne    760 <malloc+0x40>
        return 0;
  }
}
     7a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     7a3:	31 c0                	xor    %eax,%eax
}
     7a5:	5b                   	pop    %ebx
     7a6:	5e                   	pop    %esi
     7a7:	5f                   	pop    %edi
     7a8:	5d                   	pop    %ebp
     7a9:	c3                   	ret
     7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
     7b0:	39 cf                	cmp    %ecx,%edi
     7b2:	74 4c                	je     800 <malloc+0xe0>
        p->s.size -= nunits;
     7b4:	29 f9                	sub    %edi,%ecx
     7b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
     7b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
     7bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
     7bf:	89 15 a4 1b 00 00    	mov    %edx,0x1ba4
}
     7c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
     7c8:	83 c0 08             	add    $0x8,%eax
}
     7cb:	5b                   	pop    %ebx
     7cc:	5e                   	pop    %esi
     7cd:	5f                   	pop    %edi
     7ce:	5d                   	pop    %ebp
     7cf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
     7d0:	c7 05 a4 1b 00 00 a8 	movl   $0x1ba8,0x1ba4
     7d7:	1b 00 00 
    base.s.size = 0;
     7da:	b8 a8 1b 00 00       	mov    $0x1ba8,%eax
    base.s.ptr = freep = prevp = &base;
     7df:	c7 05 a8 1b 00 00 a8 	movl   $0x1ba8,0x1ba8
     7e6:	1b 00 00 
    base.s.size = 0;
     7e9:	c7 05 ac 1b 00 00 00 	movl   $0x0,0x1bac
     7f0:	00 00 00 
    if(p->s.size >= nunits){
     7f3:	e9 54 ff ff ff       	jmp    74c <malloc+0x2c>
     7f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7ff:	00 
        prevp->s.ptr = p->s.ptr;
     800:	8b 08                	mov    (%eax),%ecx
     802:	89 0a                	mov    %ecx,(%edx)
     804:	eb b9                	jmp    7bf <malloc+0x9f>
     806:	66 90                	xchg   %ax,%ax
     808:	66 90                	xchg   %ax,%ax
     80a:	66 90                	xchg   %ax,%ax
     80c:	66 90                	xchg   %ax,%ax
     80e:	66 90                	xchg   %ax,%ax

00000810 <thread_init>:
}

void
thread_init(void)
{
    for (int i = 0; i < MAX_THREADS; i++) {
     810:	b8 e0 1b 00 00       	mov    $0x1be0,%eax
     815:	8d 76 00             	lea    0x0(%esi),%esi
        threads[i].tid = -1;
     818:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     81e:	83 c0 20             	add    $0x20,%eax
        threads[i].state = T_UNUSED;
     821:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
        threads[i].stack = 0;
     828:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
        threads[i].sp = 0;
     82f:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        threads[i].start_routine = 0;
     836:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        threads[i].arg = 0;
     83d:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
        threads[i].retval = 0;
     844:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        threads[i].waiting_tid = -1;
     84b:	c7 40 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     852:	3d e0 1d 00 00       	cmp    $0x1de0,%eax
     857:	75 bf                	jne    818 <thread_init+0x8>
    }

    threads[0].tid = 0;
     859:	c7 05 e0 1b 00 00 00 	movl   $0x0,0x1be0
     860:	00 00 00 
    threads[0].state = T_RUNNING;
     863:	c7 05 e4 1b 00 00 02 	movl   $0x2,0x1be4
     86a:	00 00 00 
    threads[0].waiting_tid = -1;
     86d:	c7 05 fc 1b 00 00 ff 	movl   $0xffffffff,0x1bfc
     874:	ff ff ff 

    current_thread = &threads[0];
     877:	c7 05 c0 1b 00 00 e0 	movl   $0x1be0,0x1bc0
     87e:	1b 00 00 
}
     881:	c3                   	ret
     882:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     889:	00 
     88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000890 <thread_self>:

int
thread_self(void)
{
    return current_thread->tid;
     890:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     895:	8b 00                	mov    (%eax),%eax
}
     897:	c3                   	ret
     898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     89f:	00 

000008a0 <thread_create>:

int
thread_create(void* (*start_routine)(void*), void *arg)
{
     8a0:	55                   	push   %ebp
    int i;
    for (i = 0; i < MAX_THREADS; i++) {
     8a1:	31 c0                	xor    %eax,%eax
{
     8a3:	89 e5                	mov    %esp,%ebp
     8a5:	56                   	push   %esi
     8a6:	53                   	push   %ebx
     8a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8ae:	00 
     8af:	90                   	nop
        if (threads[i].state == T_UNUSED)
     8b0:	89 c3                	mov    %eax,%ebx
     8b2:	c1 e3 05             	shl    $0x5,%ebx
     8b5:	8b 93 e4 1b 00 00    	mov    0x1be4(%ebx),%edx
     8bb:	85 d2                	test   %edx,%edx
     8bd:	74 19                	je     8d8 <thread_create+0x38>
    for (i = 0; i < MAX_THREADS; i++) {
     8bf:	83 c0 01             	add    $0x1,%eax
     8c2:	83 f8 10             	cmp    $0x10,%eax
     8c5:	75 e9                	jne    8b0 <thread_create+0x10>
            break;
    }
    if (i == MAX_THREADS)
        return -1;
     8c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     8cc:	e9 8c 00 00 00       	jmp    95d <thread_create+0xbd>
     8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    struct thread *t = &threads[i];

    t->tid = next_tid++;
     8d8:	a1 a4 1a 00 00       	mov    0x1aa4,%eax
     8dd:	8d b3 e0 1b 00 00    	lea    0x1be0(%ebx),%esi
    t->start_routine = start_routine;
    t->arg = arg;
    t->retval = 0;
    t->waiting_tid = -1;

    t->stack = malloc(STACK_SIZE);
     8e3:	83 ec 0c             	sub    $0xc,%esp
    t->state = T_RUNNABLE;
     8e6:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    t->tid = next_tid++;
     8ed:	89 83 e0 1b 00 00    	mov    %eax,0x1be0(%ebx)
     8f3:	8d 50 01             	lea    0x1(%eax),%edx
    t->start_routine = start_routine;
     8f6:	8b 45 08             	mov    0x8(%ebp),%eax
    t->tid = next_tid++;
     8f9:	89 15 a4 1a 00 00    	mov    %edx,0x1aa4
    t->start_routine = start_routine;
     8ff:	89 46 10             	mov    %eax,0x10(%esi)
    t->arg = arg;
     902:	8b 45 0c             	mov    0xc(%ebp),%eax
    t->retval = 0;
     905:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    t->arg = arg;
     90c:	89 46 14             	mov    %eax,0x14(%esi)
    t->waiting_tid = -1;
     90f:	c7 46 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%esi)
    t->stack = malloc(STACK_SIZE);
     916:	68 00 10 00 00       	push   $0x1000
     91b:	e8 00 fe ff ff       	call   720 <malloc>
    if (!t->stack) {
     920:	83 c4 10             	add    $0x10,%esp
    t->stack = malloc(STACK_SIZE);
     923:	89 46 08             	mov    %eax,0x8(%esi)
    if (!t->stack) {
     926:	85 c0                	test   %eax,%eax
     928:	74 3a                	je     964 <thread_create+0xc4>
        t->state = T_UNUSED;
        return -1;
    }

    uint *sp = (uint *)((char *)t->stack + STACK_SIZE);
    *(--sp) = (uint)thread_trampoline;
     92a:	c7 80 fc 0f 00 00 70 	movl   $0xa70,0xffc(%eax)
     931:	0a 00 00 
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
     934:	05 ec 0f 00 00       	add    $0xfec,%eax
    *(--sp) = 0;
     939:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    *(--sp) = 0;
     940:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    *(--sp) = 0;
     947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    *(--sp) = 0;
     94e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     954:	89 46 0c             	mov    %eax,0xc(%esi)
    t->sp = sp;

    return t->tid;
     957:	8b 83 e0 1b 00 00    	mov    0x1be0(%ebx),%eax
}
     95d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     960:	5b                   	pop    %ebx
     961:	5e                   	pop    %esi
     962:	5d                   	pop    %ebp
     963:	c3                   	ret
        t->state = T_UNUSED;
     964:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
        return -1;
     96b:	e9 57 ff ff ff       	jmp    8c7 <thread_create+0x27>

00000970 <thread_schedule>:

void
thread_schedule(void)
{
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	57                   	push   %edi
     974:	56                   	push   %esi
     975:	53                   	push   %ebx
     976:	83 ec 0c             	sub    $0xc,%esp
    struct thread *old = current_thread;
     979:	8b 35 c0 1b 00 00    	mov    0x1bc0,%esi
    struct thread *next = 0;

    int start = (old - threads + 1) % MAX_THREADS;
     97f:	89 f0                	mov    %esi,%eax
     981:	2d e0 1b 00 00       	sub    $0x1be0,%eax
     986:	c1 f8 05             	sar    $0x5,%eax
     989:	83 c0 01             	add    $0x1,%eax
     98c:	99                   	cltd
     98d:	c1 ea 1c             	shr    $0x1c,%edx
     990:	01 d0                	add    %edx,%eax
     992:	83 e0 0f             	and    $0xf,%eax
     995:	29 d0                	sub    %edx,%eax
     997:	8d 58 10             	lea    0x10(%eax),%ebx
     99a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for (int i = 0; i < MAX_THREADS; i++) {
        int idx = (start + i) % MAX_THREADS;
     9a0:	89 c1                	mov    %eax,%ecx
     9a2:	c1 f9 1f             	sar    $0x1f,%ecx
     9a5:	c1 e9 1c             	shr    $0x1c,%ecx
     9a8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
     9ab:	83 e2 0f             	and    $0xf,%edx
     9ae:	29 ca                	sub    %ecx,%edx
        if (threads[idx].state == T_RUNNABLE) {
     9b0:	89 d1                	mov    %edx,%ecx
     9b2:	c1 e1 05             	shl    $0x5,%ecx
     9b5:	83 b9 e4 1b 00 00 01 	cmpl   $0x1,0x1be4(%ecx)
     9bc:	8d b9 e0 1b 00 00    	lea    0x1be0(%ecx),%edi
     9c2:	74 14                	je     9d8 <thread_schedule+0x68>
    for (int i = 0; i < MAX_THREADS; i++) {
     9c4:	83 c0 01             	add    $0x1,%eax
     9c7:	39 d8                	cmp    %ebx,%eax
     9c9:	75 d5                	jne    9a0 <thread_schedule+0x30>

    next->state = T_RUNNING;
    current_thread = next;

    thread_switch(old, next);
}
     9cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9ce:	5b                   	pop    %ebx
     9cf:	5e                   	pop    %esi
     9d0:	5f                   	pop    %edi
     9d1:	5d                   	pop    %ebp
     9d2:	c3                   	ret
     9d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (old->state == T_RUNNING)
     9d8:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     9dc:	75 07                	jne    9e5 <thread_schedule+0x75>
        old->state = T_RUNNABLE;
     9de:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    thread_switch(old, next);
     9e5:	83 ec 08             	sub    $0x8,%esp
    next->state = T_RUNNING;
     9e8:	c1 e2 05             	shl    $0x5,%edx
    current_thread = next;
     9eb:	89 3d c0 1b 00 00    	mov    %edi,0x1bc0
    next->state = T_RUNNING;
     9f1:	c7 82 e4 1b 00 00 02 	movl   $0x2,0x1be4(%edx)
     9f8:	00 00 00 
    thread_switch(old, next);
     9fb:	57                   	push   %edi
     9fc:	56                   	push   %esi
     9fd:	e8 1e 03 00 00       	call   d20 <thread_switch>
     a02:	83 c4 10             	add    $0x10,%esp
}
     a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a08:	5b                   	pop    %ebx
     a09:	5e                   	pop    %esi
     a0a:	5f                   	pop    %edi
     a0b:	5d                   	pop    %ebp
     a0c:	c3                   	ret
     a0d:	8d 76 00             	lea    0x0(%esi),%esi

00000a10 <thread_yield>:

void
thread_yield(void)
{
    thread_schedule();
     a10:	e9 5b ff ff ff       	jmp    970 <thread_schedule>
     a15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a1c:	00 
     a1d:	8d 76 00             	lea    0x0(%esi),%esi

00000a20 <thread_exit>:
}

void
thread_exit(void *retval)
{
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	83 ec 08             	sub    $0x8,%esp
    current_thread->retval = retval;
     a26:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     a2b:	8b 55 08             	mov    0x8(%ebp),%edx
    current_thread->state = T_ZOMBIE;

    if (current_thread->waiting_tid >= 0) {
     a2e:	8b 48 1c             	mov    0x1c(%eax),%ecx
    current_thread->state = T_ZOMBIE;
     a31:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
    current_thread->retval = retval;
     a38:	89 50 18             	mov    %edx,0x18(%eax)
    if (current_thread->waiting_tid >= 0) {
     a3b:	85 c9                	test   %ecx,%ecx
     a3d:	78 1e                	js     a5d <thread_exit+0x3d>
        for (int i = 0; i < MAX_THREADS; i++) {
     a3f:	31 c0                	xor    %eax,%eax
     a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (threads[i].tid == current_thread->waiting_tid) {
     a48:	89 c2                	mov    %eax,%edx
     a4a:	c1 e2 05             	shl    $0x5,%edx
     a4d:	3b 8a e0 1b 00 00    	cmp    0x1be0(%edx),%ecx
     a53:	74 0f                	je     a64 <thread_exit+0x44>
        for (int i = 0; i < MAX_THREADS; i++) {
     a55:	83 c0 01             	add    $0x1,%eax
     a58:	83 f8 10             	cmp    $0x10,%eax
     a5b:	75 eb                	jne    a48 <thread_exit+0x28>
                break;
            }
        }
    }

    thread_schedule();
     a5d:	e8 0e ff ff ff       	call   970 <thread_schedule>

    for (;;)
     a62:	eb fe                	jmp    a62 <thread_exit+0x42>
                threads[i].state = T_RUNNABLE;
     a64:	c7 82 e4 1b 00 00 01 	movl   $0x1,0x1be4(%edx)
     a6b:	00 00 00 
                break;
     a6e:	eb ed                	jmp    a5d <thread_exit+0x3d>

00000a70 <thread_trampoline>:
{
     a70:	55                   	push   %ebp
     a71:	89 e5                	mov    %esp,%ebp
     a73:	83 ec 14             	sub    $0x14,%esp
    void *ret = current_thread->start_routine(current_thread->arg);
     a76:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     a7b:	ff 70 14             	push   0x14(%eax)
     a7e:	ff 50 10             	call   *0x10(%eax)
    thread_exit(ret);
     a81:	89 04 24             	mov    %eax,(%esp)
     a84:	e8 97 ff ff ff       	call   a20 <thread_exit>
     a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a90 <thread_join>:
        ;
}

void *
thread_join(int tid)
{
     a90:	55                   	push   %ebp
     a91:	89 e5                	mov    %esp,%ebp
     a93:	57                   	push   %edi
     a94:	56                   	push   %esi
     a95:	53                   	push   %ebx
    struct thread *target = 0;

    for (int i = 0; i < MAX_THREADS; i++) {
     a96:	31 db                	xor    %ebx,%ebx
{
     a98:	83 ec 0c             	sub    $0xc,%esp
     a9b:	8b 55 08             	mov    0x8(%ebp),%edx
     a9e:	66 90                	xchg   %ax,%ax
        if (threads[i].tid == tid) {
     aa0:	89 d8                	mov    %ebx,%eax
     aa2:	c1 e0 05             	shl    $0x5,%eax
     aa5:	39 90 e0 1b 00 00    	cmp    %edx,0x1be0(%eax)
     aab:	74 1b                	je     ac8 <thread_join+0x38>
    for (int i = 0; i < MAX_THREADS; i++) {
     aad:	83 c3 01             	add    $0x1,%ebx
     ab0:	83 fb 10             	cmp    $0x10,%ebx
     ab3:	75 eb                	jne    aa0 <thread_join+0x10>
    target->stack = 0;
    target->state = T_UNUSED;
    target->tid = -1;

    return ret;
}
     ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     ab8:	31 ff                	xor    %edi,%edi
}
     aba:	5b                   	pop    %ebx
     abb:	89 f8                	mov    %edi,%eax
     abd:	5e                   	pop    %esi
     abe:	5f                   	pop    %edi
     abf:	5d                   	pop    %ebp
     ac0:	c3                   	ret
     ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (target->state != T_ZOMBIE) {
     ac8:	83 b8 e4 1b 00 00 04 	cmpl   $0x4,0x1be4(%eax)
     acf:	8d b0 e0 1b 00 00    	lea    0x1be0(%eax),%esi
     ad5:	74 25                	je     afc <thread_join+0x6c>
     ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     ade:	00 
     adf:	90                   	nop
        current_thread->state = T_SLEEPING;
     ae0:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     ae5:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        target->waiting_tid = current_thread->tid;
     aec:	8b 00                	mov    (%eax),%eax
     aee:	89 46 1c             	mov    %eax,0x1c(%esi)
        thread_schedule();
     af1:	e8 7a fe ff ff       	call   970 <thread_schedule>
    while (target->state != T_ZOMBIE) {
     af6:	83 7e 04 04          	cmpl   $0x4,0x4(%esi)
     afa:	75 e4                	jne    ae0 <thread_join+0x50>
    void *ret = target->retval;
     afc:	c1 e3 05             	shl    $0x5,%ebx
    free(target->stack);
     aff:	83 ec 0c             	sub    $0xc,%esp
    void *ret = target->retval;
     b02:	8b bb f8 1b 00 00    	mov    0x1bf8(%ebx),%edi
    free(target->stack);
     b08:	ff b3 e8 1b 00 00    	push   0x1be8(%ebx)
     b0e:	e8 7d fb ff ff       	call   690 <free>
    return ret;
     b13:	83 c4 10             	add    $0x10,%esp
}
     b16:	89 f8                	mov    %edi,%eax
    target->stack = 0;
     b18:	c7 83 e8 1b 00 00 00 	movl   $0x0,0x1be8(%ebx)
     b1f:	00 00 00 
    target->state = T_UNUSED;
     b22:	c7 83 e4 1b 00 00 00 	movl   $0x0,0x1be4(%ebx)
     b29:	00 00 00 
    target->tid = -1;
     b2c:	c7 83 e0 1b 00 00 ff 	movl   $0xffffffff,0x1be0(%ebx)
     b33:	ff ff ff 
}
     b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b39:	5b                   	pop    %ebx
     b3a:	5e                   	pop    %esi
     b3b:	5f                   	pop    %edi
     b3c:	5d                   	pop    %ebp
     b3d:	c3                   	ret
     b3e:	66 90                	xchg   %ax,%ax

00000b40 <sem_init>:
void
sem_init(sem_t *s, int value)
{
     b40:	55                   	push   %ebp
     b41:	89 e5                	mov    %esp,%ebp
     b43:	8b 45 08             	mov    0x8(%ebp),%eax
    s->count = value;
     b46:	8b 55 0c             	mov    0xc(%ebp),%edx
    s->wait_count = 0;
     b49:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    s->count = value;
     b50:	89 10                	mov    %edx,(%eax)
}
     b52:	5d                   	pop    %ebp
     b53:	c3                   	ret
     b54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b5b:	00 
     b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b60 <sem_wait>:

void
sem_wait(sem_t *s)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	53                   	push   %ebx
     b64:	8b 55 08             	mov    0x8(%ebp),%edx
    s->count--;
     b67:	83 2a 01             	subl   $0x1,(%edx)
    if (s->count < 0) {
     b6a:	78 0c                	js     b78 <sem_wait+0x18>
        s->wait_queue[s->wait_count++] = current_thread->tid;
        current_thread->state = T_SLEEPING;
        thread_schedule();
    }
}
     b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b6f:	c9                   	leave
     b70:	c3                   	ret
     b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s->wait_queue[s->wait_count++] = current_thread->tid;
     b78:	8b 4a 44             	mov    0x44(%edx),%ecx
     b7b:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     b80:	8d 59 01             	lea    0x1(%ecx),%ebx
     b83:	89 5a 44             	mov    %ebx,0x44(%edx)
     b86:	8b 18                	mov    (%eax),%ebx
     b88:	89 5c 8a 04          	mov    %ebx,0x4(%edx,%ecx,4)
        current_thread->state = T_SLEEPING;
     b8c:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
}
     b93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b96:	c9                   	leave
        thread_schedule();
     b97:	e9 d4 fd ff ff       	jmp    970 <thread_schedule>
     b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ba0 <sem_post>:

void
sem_post(sem_t *s)
{
     ba0:	55                   	push   %ebp
     ba1:	89 e5                	mov    %esp,%ebp
     ba3:	57                   	push   %edi
     ba4:	8b 55 08             	mov    0x8(%ebp),%edx
     ba7:	56                   	push   %esi
     ba8:	53                   	push   %ebx
    s->count++;
     ba9:	8b 02                	mov    (%edx),%eax
     bab:	83 c0 01             	add    $0x1,%eax
     bae:	89 02                	mov    %eax,(%edx)
    if (s->count <= 0 && s->wait_count > 0) {
     bb0:	85 c0                	test   %eax,%eax
     bb2:	7e 0c                	jle    bc0 <sem_post+0x20>
                threads[i].state = T_RUNNABLE;
                break;
            }
        }
    }
}
     bb4:	5b                   	pop    %ebx
     bb5:	5e                   	pop    %esi
     bb6:	5f                   	pop    %edi
     bb7:	5d                   	pop    %ebp
     bb8:	c3                   	ret
     bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (s->count <= 0 && s->wait_count > 0) {
     bc0:	8b 7a 44             	mov    0x44(%edx),%edi
     bc3:	85 ff                	test   %edi,%edi
     bc5:	7e ed                	jle    bb4 <sem_post+0x14>
        int tid = s->wait_queue[0];
     bc7:	8b 5a 04             	mov    0x4(%edx),%ebx
        for (int i = 1; i < s->wait_count; i++)
     bca:	83 ff 01             	cmp    $0x1,%edi
     bcd:	74 16                	je     be5 <sem_post+0x45>
     bcf:	8d 42 04             	lea    0x4(%edx),%eax
     bd2:	8d 34 ba             	lea    (%edx,%edi,4),%esi
     bd5:	8d 76 00             	lea    0x0(%esi),%esi
            s->wait_queue[i - 1] = s->wait_queue[i];
     bd8:	8b 48 04             	mov    0x4(%eax),%ecx
        for (int i = 1; i < s->wait_count; i++)
     bdb:	83 c0 04             	add    $0x4,%eax
            s->wait_queue[i - 1] = s->wait_queue[i];
     bde:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int i = 1; i < s->wait_count; i++)
     be1:	39 f0                	cmp    %esi,%eax
     be3:	75 f3                	jne    bd8 <sem_post+0x38>
        s->wait_count--;
     be5:	83 ef 01             	sub    $0x1,%edi
        for (int i = 0; i < MAX_THREADS; i++) {
     be8:	31 c0                	xor    %eax,%eax
        s->wait_count--;
     bea:	89 7a 44             	mov    %edi,0x44(%edx)
        for (int i = 0; i < MAX_THREADS; i++) {
     bed:	eb 09                	jmp    bf8 <sem_post+0x58>
     bef:	90                   	nop
     bf0:	83 c0 01             	add    $0x1,%eax
     bf3:	83 f8 10             	cmp    $0x10,%eax
     bf6:	74 bc                	je     bb4 <sem_post+0x14>
            if (threads[i].tid == tid) {
     bf8:	89 c2                	mov    %eax,%edx
     bfa:	c1 e2 05             	shl    $0x5,%edx
     bfd:	39 9a e0 1b 00 00    	cmp    %ebx,0x1be0(%edx)
     c03:	75 eb                	jne    bf0 <sem_post+0x50>
                threads[i].state = T_RUNNABLE;
     c05:	c7 82 e4 1b 00 00 01 	movl   $0x1,0x1be4(%edx)
     c0c:	00 00 00 
}
     c0f:	5b                   	pop    %ebx
     c10:	5e                   	pop    %esi
     c11:	5f                   	pop    %edi
     c12:	5d                   	pop    %ebp
     c13:	c3                   	ret
     c14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c1b:	00 
     c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c20 <cond_init>:

void
cond_init(cond_t *c)
{
     c20:	55                   	push   %ebp
     c21:	89 e5                	mov    %esp,%ebp
    c->wait_count = 0;
     c23:	8b 45 08             	mov    0x8(%ebp),%eax
     c26:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%eax)
}
     c2d:	5d                   	pop    %ebp
     c2e:	c3                   	ret
     c2f:	90                   	nop

00000c30 <cond_wait>:

void
cond_wait(cond_t *c, mutex_t *m)
{
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	53                   	push   %ebx
     c34:	83 ec 10             	sub    $0x10,%esp
     c37:	8b 45 08             	mov    0x8(%ebp),%eax
     c3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    c->wait_queue[c->wait_count++] = current_thread->tid;
     c3d:	8b 50 40             	mov    0x40(%eax),%edx
     c40:	8d 4a 01             	lea    0x1(%edx),%ecx
     c43:	89 48 40             	mov    %ecx,0x40(%eax)
     c46:	8b 0d c0 1b 00 00    	mov    0x1bc0,%ecx
     c4c:	8b 09                	mov    (%ecx),%ecx
     c4e:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    mutex_unlock(m);
     c51:	53                   	push   %ebx
     c52:	e8 79 01 00 00       	call   dd0 <mutex_unlock>
    current_thread->state = T_SLEEPING;
     c57:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     c5c:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
    thread_schedule();
     c63:	e8 08 fd ff ff       	call   970 <thread_schedule>
    mutex_lock(m);
     c68:	83 c4 10             	add    $0x10,%esp
     c6b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c71:	c9                   	leave
    mutex_lock(m);
     c72:	e9 e9 00 00 00       	jmp    d60 <mutex_lock>
     c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c7e:	00 
     c7f:	90                   	nop

00000c80 <cond_signal>:

void
cond_signal(cond_t *c)
{
     c80:	55                   	push   %ebp
     c81:	89 e5                	mov    %esp,%ebp
     c83:	57                   	push   %edi
     c84:	8b 7d 08             	mov    0x8(%ebp),%edi
     c87:	56                   	push   %esi
     c88:	53                   	push   %ebx
    if (c->wait_count == 0)
     c89:	8b 77 40             	mov    0x40(%edi),%esi
     c8c:	85 f6                	test   %esi,%esi
     c8e:	74 3d                	je     ccd <cond_signal+0x4d>
        return;

    int tid = c->wait_queue[0];
     c90:	8b 0f                	mov    (%edi),%ecx
    for (int i = 1; i < c->wait_count; i++)
     c92:	83 fe 01             	cmp    $0x1,%esi
     c95:	7e 16                	jle    cad <cond_signal+0x2d>
     c97:	89 f8                	mov    %edi,%eax
     c99:	8d 5c b7 fc          	lea    -0x4(%edi,%esi,4),%ebx
     c9d:	8d 76 00             	lea    0x0(%esi),%esi
        c->wait_queue[i - 1] = c->wait_queue[i];
     ca0:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < c->wait_count; i++)
     ca3:	83 c0 04             	add    $0x4,%eax
        c->wait_queue[i - 1] = c->wait_queue[i];
     ca6:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < c->wait_count; i++)
     ca9:	39 d8                	cmp    %ebx,%eax
     cab:	75 f3                	jne    ca0 <cond_signal+0x20>
    c->wait_count--;
     cad:	83 ee 01             	sub    $0x1,%esi

    for (int i = 0; i < MAX_THREADS; i++) {
     cb0:	31 c0                	xor    %eax,%eax
    c->wait_count--;
     cb2:	89 77 40             	mov    %esi,0x40(%edi)
    for (int i = 0; i < MAX_THREADS; i++) {
     cb5:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == tid) {
     cb8:	89 c2                	mov    %eax,%edx
     cba:	c1 e2 05             	shl    $0x5,%edx
     cbd:	39 8a e0 1b 00 00    	cmp    %ecx,0x1be0(%edx)
     cc3:	74 13                	je     cd8 <cond_signal+0x58>
    for (int i = 0; i < MAX_THREADS; i++) {
     cc5:	83 c0 01             	add    $0x1,%eax
     cc8:	83 f8 10             	cmp    $0x10,%eax
     ccb:	75 eb                	jne    cb8 <cond_signal+0x38>
            threads[i].state = T_RUNNABLE;
            break;
        }
    }
}
     ccd:	5b                   	pop    %ebx
     cce:	5e                   	pop    %esi
     ccf:	5f                   	pop    %edi
     cd0:	5d                   	pop    %ebp
     cd1:	c3                   	ret
     cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     cd8:	c7 82 e4 1b 00 00 01 	movl   $0x1,0x1be4(%edx)
     cdf:	00 00 00 
}
     ce2:	5b                   	pop    %ebx
     ce3:	5e                   	pop    %esi
     ce4:	5f                   	pop    %edi
     ce5:	5d                   	pop    %ebp
     ce6:	c3                   	ret
     ce7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     cee:	00 
     cef:	90                   	nop

00000cf0 <cond_broadcast>:

void
cond_broadcast(cond_t *c)
{
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	53                   	push   %ebx
     cf4:	83 ec 04             	sub    $0x4,%esp
     cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (c->wait_count > 0)
     cfa:	8b 53 40             	mov    0x40(%ebx),%edx
     cfd:	85 d2                	test   %edx,%edx
     cff:	7e 1a                	jle    d1b <cond_broadcast+0x2b>
     d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(c);
     d08:	83 ec 0c             	sub    $0xc,%esp
     d0b:	53                   	push   %ebx
     d0c:	e8 6f ff ff ff       	call   c80 <cond_signal>
    while (c->wait_count > 0)
     d11:	8b 43 40             	mov    0x40(%ebx),%eax
     d14:	83 c4 10             	add    $0x10,%esp
     d17:	85 c0                	test   %eax,%eax
     d19:	7f ed                	jg     d08 <cond_broadcast+0x18>
}
     d1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d1e:	c9                   	leave
     d1f:	c3                   	ret

00000d20 <thread_switch>:
.text
.globl thread_switch
thread_switch:
  movl 4(%esp), %eax
     d20:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
     d24:	8b 54 24 08          	mov    0x8(%esp),%edx
  pushl %ebp
     d28:	55                   	push   %ebp
  pushl %ebx
     d29:	53                   	push   %ebx
  pushl %esi
     d2a:	56                   	push   %esi
  pushl %edi
     d2b:	57                   	push   %edi
  movl %esp, 12(%eax)
     d2c:	89 60 0c             	mov    %esp,0xc(%eax)
  movl 12(%edx), %esp
     d2f:	8b 62 0c             	mov    0xc(%edx),%esp
  popl %edi
     d32:	5f                   	pop    %edi
  popl %esi
     d33:	5e                   	pop    %esi
  popl %ebx
     d34:	5b                   	pop    %ebx
  popl %ebp
     d35:	5d                   	pop    %ebp
  ret
     d36:	c3                   	ret
     d37:	66 90                	xchg   %ax,%ax
     d39:	66 90                	xchg   %ax,%ax
     d3b:	66 90                	xchg   %ax,%ax
     d3d:	66 90                	xchg   %ax,%ax
     d3f:	90                   	nop

00000d40 <mutex_init>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

void
mutex_init(mutex_t *m)
{
     d40:	55                   	push   %ebp
     d41:	89 e5                	mov    %esp,%ebp
     d43:	8b 45 08             	mov    0x8(%ebp),%eax
    m->locked = 0;
     d46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    m->owner = -1;
     d4c:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    m->wait_count = 0;
     d53:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
}
     d5a:	5d                   	pop    %ebp
     d5b:	c3                   	ret
     d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d60 <mutex_lock>:

void
mutex_lock(mutex_t *m)
{
     d60:	55                   	push   %ebp
     d61:	89 e5                	mov    %esp,%ebp
     d63:	53                   	push   %ebx
     d64:	83 ec 04             	sub    $0x4,%esp
     d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (m->locked) {
     d6a:	8b 13                	mov    (%ebx),%edx
     d6c:	85 d2                	test   %edx,%edx
     d6e:	75 29                	jne    d99 <mutex_lock+0x39>
     d70:	eb 3e                	jmp    db0 <mutex_lock+0x50>
     d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (m->owner == current_thread->tid)
            return;
        m->wait_queue[m->wait_count++] = current_thread->tid;
     d78:	8b 53 48             	mov    0x48(%ebx),%edx
     d7b:	8d 4a 01             	lea    0x1(%edx),%ecx
     d7e:	89 4b 48             	mov    %ecx,0x48(%ebx)
     d81:	8b 08                	mov    (%eax),%ecx
     d83:	89 4c 93 08          	mov    %ecx,0x8(%ebx,%edx,4)
        current_thread->state = T_SLEEPING;
     d87:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        thread_schedule();
     d8e:	e8 dd fb ff ff       	call   970 <thread_schedule>
    while (m->locked) {
     d93:	8b 03                	mov    (%ebx),%eax
     d95:	85 c0                	test   %eax,%eax
     d97:	74 17                	je     db0 <mutex_lock+0x50>
        if (m->owner == current_thread->tid)
     d99:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     d9e:	8b 10                	mov    (%eax),%edx
     da0:	39 53 04             	cmp    %edx,0x4(%ebx)
     da3:	75 d3                	jne    d78 <mutex_lock+0x18>
    }
    m->locked = 1;
    m->owner = current_thread->tid;
}
     da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     da8:	c9                   	leave
     da9:	c3                   	ret
     daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m->locked = 1;
     db0:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    m->owner = current_thread->tid;
     db6:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     dbb:	8b 00                	mov    (%eax),%eax
     dbd:	89 43 04             	mov    %eax,0x4(%ebx)
}
     dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     dc3:	c9                   	leave
     dc4:	c3                   	ret
     dc5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     dcc:	00 
     dcd:	8d 76 00             	lea    0x0(%esi),%esi

00000dd0 <mutex_unlock>:

void
mutex_unlock(mutex_t *m)
{
     dd0:	55                   	push   %ebp
    if (m->owner != current_thread->tid)
     dd1:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
{
     dd6:	89 e5                	mov    %esp,%ebp
     dd8:	57                   	push   %edi
     dd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ddc:	56                   	push   %esi
     ddd:	53                   	push   %ebx
    if (m->owner != current_thread->tid)
     dde:	8b 00                	mov    (%eax),%eax
     de0:	39 41 04             	cmp    %eax,0x4(%ecx)
     de3:	75 48                	jne    e2d <mutex_unlock+0x5d>
        return;

    if (m->wait_count == 0) {
     de5:	8b 79 48             	mov    0x48(%ecx),%edi
     de8:	85 ff                	test   %edi,%edi
     dea:	74 4c                	je     e38 <mutex_unlock+0x68>
        m->locked = 0;
        m->owner = -1;
        return;
    }

    int next_tid = m->wait_queue[0];
     dec:	8b 59 08             	mov    0x8(%ecx),%ebx
    for (int i = 1; i < m->wait_count; i++)
     def:	83 ff 01             	cmp    $0x1,%edi
     df2:	7e 19                	jle    e0d <mutex_unlock+0x3d>
     df4:	8d 41 08             	lea    0x8(%ecx),%eax
     df7:	8d 74 b9 04          	lea    0x4(%ecx,%edi,4),%esi
     dfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        m->wait_queue[i - 1] = m->wait_queue[i];
     e00:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < m->wait_count; i++)
     e03:	83 c0 04             	add    $0x4,%eax
        m->wait_queue[i - 1] = m->wait_queue[i];
     e06:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < m->wait_count; i++)
     e09:	39 f0                	cmp    %esi,%eax
     e0b:	75 f3                	jne    e00 <mutex_unlock+0x30>
    m->wait_count--;
     e0d:	83 ef 01             	sub    $0x1,%edi

    for (int i = 0; i < MAX_THREADS; i++) {
     e10:	31 c0                	xor    %eax,%eax
    m->wait_count--;
     e12:	89 79 48             	mov    %edi,0x48(%ecx)
    for (int i = 0; i < MAX_THREADS; i++) {
     e15:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == next_tid) {
     e18:	89 c2                	mov    %eax,%edx
     e1a:	c1 e2 05             	shl    $0x5,%edx
     e1d:	39 9a e0 1b 00 00    	cmp    %ebx,0x1be0(%edx)
     e23:	74 2b                	je     e50 <mutex_unlock+0x80>
    for (int i = 0; i < MAX_THREADS; i++) {
     e25:	83 c0 01             	add    $0x1,%eax
     e28:	83 f8 10             	cmp    $0x10,%eax
     e2b:	75 eb                	jne    e18 <mutex_unlock+0x48>
            threads[i].state = T_RUNNABLE;
            m->owner = next_tid;
            break;
        }
    }
}
     e2d:	5b                   	pop    %ebx
     e2e:	5e                   	pop    %esi
     e2f:	5f                   	pop    %edi
     e30:	5d                   	pop    %ebp
     e31:	c3                   	ret
     e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        m->locked = 0;
     e38:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
        m->owner = -1;
     e3e:	c7 41 04 ff ff ff ff 	movl   $0xffffffff,0x4(%ecx)
}
     e45:	5b                   	pop    %ebx
     e46:	5e                   	pop    %esi
     e47:	5f                   	pop    %edi
     e48:	5d                   	pop    %ebp
     e49:	c3                   	ret
     e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     e50:	c7 82 e4 1b 00 00 01 	movl   $0x1,0x1be4(%edx)
     e57:	00 00 00 
            m->owner = next_tid;
     e5a:	89 59 04             	mov    %ebx,0x4(%ecx)
}
     e5d:	5b                   	pop    %ebx
     e5e:	5e                   	pop    %esi
     e5f:	5f                   	pop    %edi
     e60:	5d                   	pop    %ebp
     e61:	c3                   	ret
     e62:	66 90                	xchg   %ax,%ax
     e64:	66 90                	xchg   %ax,%ax
     e66:	66 90                	xchg   %ax,%ax
     e68:	66 90                	xchg   %ax,%ax
     e6a:	66 90                	xchg   %ax,%ax
     e6c:	66 90                	xchg   %ax,%ax
     e6e:	66 90                	xchg   %ax,%ax

00000e70 <channel_create>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

channel_t *
channel_create(int capacity)
{
     e70:	55                   	push   %ebp
     e71:	89 e5                	mov    %esp,%ebp
     e73:	56                   	push   %esi
     e74:	53                   	push   %ebx
     e75:	8b 75 08             	mov    0x8(%ebp),%esi
    channel_t *ch = malloc(sizeof(channel_t));
     e78:	83 ec 0c             	sub    $0xc,%esp
     e7b:	68 ec 00 00 00       	push   $0xec
     e80:	e8 9b f8 ff ff       	call   720 <malloc>
    if (!ch)
     e85:	83 c4 10             	add    $0x10,%esp
     e88:	85 c0                	test   %eax,%eax
     e8a:	0f 84 7c 00 00 00    	je     f0c <channel_create+0x9c>
        return 0;

    ch->buffer = malloc(sizeof(void *) * capacity);
     e90:	83 ec 0c             	sub    $0xc,%esp
     e93:	89 c3                	mov    %eax,%ebx
     e95:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
     e9c:	50                   	push   %eax
     e9d:	e8 7e f8 ff ff       	call   720 <malloc>
    if (!ch->buffer) {
     ea2:	83 c4 10             	add    $0x10,%esp
    ch->buffer = malloc(sizeof(void *) * capacity);
     ea5:	89 03                	mov    %eax,(%ebx)
    if (!ch->buffer) {
     ea7:	85 c0                	test   %eax,%eax
     ea9:	74 55                	je     f00 <channel_create+0x90>
    ch->count = 0;
    ch->head = 0;
    ch->tail = 0;
    ch->closed = 0;

    mutex_init(&ch->lock);
     eab:	83 ec 0c             	sub    $0xc,%esp
     eae:	8d 43 18             	lea    0x18(%ebx),%eax
    ch->capacity = capacity;
     eb1:	89 73 04             	mov    %esi,0x4(%ebx)
    ch->count = 0;
     eb4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    ch->head = 0;
     ebb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    ch->tail = 0;
     ec2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    ch->closed = 0;
     ec9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    mutex_init(&ch->lock);
     ed0:	50                   	push   %eax
     ed1:	e8 6a fe ff ff       	call   d40 <mutex_init>
    cond_init(&ch->not_empty);
     ed6:	8d 43 64             	lea    0x64(%ebx),%eax
     ed9:	89 04 24             	mov    %eax,(%esp)
     edc:	e8 3f fd ff ff       	call   c20 <cond_init>
    cond_init(&ch->not_full);
     ee1:	8d 83 a8 00 00 00    	lea    0xa8(%ebx),%eax
     ee7:	89 04 24             	mov    %eax,(%esp)
     eea:	e8 31 fd ff ff       	call   c20 <cond_init>

    return ch;
     eef:	83 c4 10             	add    $0x10,%esp
}
     ef2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ef5:	89 d8                	mov    %ebx,%eax
     ef7:	5b                   	pop    %ebx
     ef8:	5e                   	pop    %esi
     ef9:	5d                   	pop    %ebp
     efa:	c3                   	ret
     efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        free(ch);
     f00:	83 ec 0c             	sub    $0xc,%esp
     f03:	53                   	push   %ebx
     f04:	e8 87 f7 ff ff       	call   690 <free>
        return 0;
     f09:	83 c4 10             	add    $0x10,%esp
        return 0;
     f0c:	31 db                	xor    %ebx,%ebx
     f0e:	eb e2                	jmp    ef2 <channel_create+0x82>

00000f10 <channel_send>:

int
channel_send(channel_t *ch, void *data)
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
     f1f:	8d bb a8 00 00 00    	lea    0xa8(%ebx),%edi
     f25:	56                   	push   %esi
     f26:	e8 35 fe ff ff       	call   d60 <mutex_lock>

    while (ch->count == ch->capacity && !ch->closed)
     f2b:	8b 43 04             	mov    0x4(%ebx),%eax
     f2e:	83 c4 10             	add    $0x10,%esp
     f31:	39 43 08             	cmp    %eax,0x8(%ebx)
     f34:	74 1f                	je     f55 <channel_send+0x45>
     f36:	eb 38                	jmp    f70 <channel_send+0x60>
     f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f3f:	00 
        cond_wait(&ch->not_full, &ch->lock);
     f40:	83 ec 08             	sub    $0x8,%esp
     f43:	56                   	push   %esi
     f44:	57                   	push   %edi
     f45:	e8 e6 fc ff ff       	call   c30 <cond_wait>
    while (ch->count == ch->capacity && !ch->closed)
     f4a:	8b 43 04             	mov    0x4(%ebx),%eax
     f4d:	83 c4 10             	add    $0x10,%esp
     f50:	39 43 08             	cmp    %eax,0x8(%ebx)
     f53:	75 1b                	jne    f70 <channel_send+0x60>
     f55:	8b 43 14             	mov    0x14(%ebx),%eax
     f58:	85 c0                	test   %eax,%eax
     f5a:	74 e4                	je     f40 <channel_send+0x30>

    if (ch->closed) {
        mutex_unlock(&ch->lock);
     f5c:	83 ec 0c             	sub    $0xc,%esp
        return -1;
     f5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        mutex_unlock(&ch->lock);
     f64:	56                   	push   %esi
     f65:	e8 66 fe ff ff       	call   dd0 <mutex_unlock>
        return -1;
     f6a:	83 c4 10             	add    $0x10,%esp
     f6d:	eb 3b                	jmp    faa <channel_send+0x9a>
     f6f:	90                   	nop
    if (ch->closed) {
     f70:	8b 7b 14             	mov    0x14(%ebx),%edi
     f73:	85 ff                	test   %edi,%edi
     f75:	75 e5                	jne    f5c <channel_send+0x4c>
    }

    ch->buffer[ch->tail] = data;
     f77:	8b 53 10             	mov    0x10(%ebx),%edx
     f7a:	8b 03                	mov    (%ebx),%eax
    ch->tail = (ch->tail + 1) % ch->capacity;
    ch->count++;

    cond_signal(&ch->not_empty);
     f7c:	83 ec 0c             	sub    $0xc,%esp
    ch->buffer[ch->tail] = data;
     f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     f82:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    ch->tail = (ch->tail + 1) % ch->capacity;
     f85:	8b 43 10             	mov    0x10(%ebx),%eax
    ch->count++;
     f88:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    ch->tail = (ch->tail + 1) % ch->capacity;
     f8c:	83 c0 01             	add    $0x1,%eax
     f8f:	99                   	cltd
     f90:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_empty);
     f93:	83 c3 64             	add    $0x64,%ebx
    ch->tail = (ch->tail + 1) % ch->capacity;
     f96:	89 53 ac             	mov    %edx,-0x54(%ebx)
    cond_signal(&ch->not_empty);
     f99:	53                   	push   %ebx
     f9a:	e8 e1 fc ff ff       	call   c80 <cond_signal>
    mutex_unlock(&ch->lock);
     f9f:	89 34 24             	mov    %esi,(%esp)
     fa2:	e8 29 fe ff ff       	call   dd0 <mutex_unlock>
    return 0;
     fa7:	83 c4 10             	add    $0x10,%esp
}
     faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fad:	89 f8                	mov    %edi,%eax
     faf:	5b                   	pop    %ebx
     fb0:	5e                   	pop    %esi
     fb1:	5f                   	pop    %edi
     fb2:	5d                   	pop    %ebp
     fb3:	c3                   	ret
     fb4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fbb:	00 
     fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000fc0 <channel_recv>:

int
channel_recv(channel_t *ch, void **data)
{
     fc0:	55                   	push   %ebp
     fc1:	89 e5                	mov    %esp,%ebp
     fc3:	57                   	push   %edi
     fc4:	56                   	push   %esi
     fc5:	53                   	push   %ebx
     fc6:	83 ec 18             	sub    $0x18,%esp
     fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
     fcc:	8d 73 18             	lea    0x18(%ebx),%esi
     fcf:	8d 7b 64             	lea    0x64(%ebx),%edi
     fd2:	56                   	push   %esi
     fd3:	e8 88 fd ff ff       	call   d60 <mutex_lock>

    while (ch->count == 0 && !ch->closed)
     fd8:	8b 4b 08             	mov    0x8(%ebx),%ecx
     fdb:	83 c4 10             	add    $0x10,%esp
     fde:	85 c9                	test   %ecx,%ecx
     fe0:	74 1a                	je     ffc <channel_recv+0x3c>
     fe2:	eb 3c                	jmp    1020 <channel_recv+0x60>
     fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&ch->not_empty, &ch->lock);
     fe8:	83 ec 08             	sub    $0x8,%esp
     feb:	56                   	push   %esi
     fec:	57                   	push   %edi
     fed:	e8 3e fc ff ff       	call   c30 <cond_wait>
    while (ch->count == 0 && !ch->closed)
     ff2:	8b 53 08             	mov    0x8(%ebx),%edx
     ff5:	83 c4 10             	add    $0x10,%esp
     ff8:	85 d2                	test   %edx,%edx
     ffa:	75 24                	jne    1020 <channel_recv+0x60>
     ffc:	8b 43 14             	mov    0x14(%ebx),%eax
     fff:	85 c0                	test   %eax,%eax
    1001:	74 e5                	je     fe8 <channel_recv+0x28>

    if (ch->count == 0 && ch->closed) {
        mutex_unlock(&ch->lock);
    1003:	83 ec 0c             	sub    $0xc,%esp
    1006:	56                   	push   %esi
    1007:	e8 c4 fd ff ff       	call   dd0 <mutex_unlock>
        return -1;
    100c:	83 c4 10             	add    $0x10,%esp
    100f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1014:	eb 47                	jmp    105d <channel_recv+0x9d>
    1016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    101d:	00 
    101e:	66 90                	xchg   %ax,%ax
    }

    *data = ch->buffer[ch->head];
    1020:	8b 53 0c             	mov    0xc(%ebx),%edx
    1023:	8b 03                	mov    (%ebx),%eax
    ch->head = (ch->head + 1) % ch->capacity;
    ch->count--;

    cond_signal(&ch->not_full);
    1025:	83 ec 0c             	sub    $0xc,%esp
    *data = ch->buffer[ch->head];
    1028:	8b 14 90             	mov    (%eax,%edx,4),%edx
    102b:	8b 45 0c             	mov    0xc(%ebp),%eax
    102e:	89 10                	mov    %edx,(%eax)
    ch->head = (ch->head + 1) % ch->capacity;
    1030:	8b 43 0c             	mov    0xc(%ebx),%eax
    ch->count--;
    1033:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    ch->head = (ch->head + 1) % ch->capacity;
    1037:	83 c0 01             	add    $0x1,%eax
    103a:	99                   	cltd
    103b:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_full);
    103e:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    ch->head = (ch->head + 1) % ch->capacity;
    1044:	89 93 64 ff ff ff    	mov    %edx,-0x9c(%ebx)
    cond_signal(&ch->not_full);
    104a:	53                   	push   %ebx
    104b:	e8 30 fc ff ff       	call   c80 <cond_signal>
    mutex_unlock(&ch->lock);
    1050:	89 34 24             	mov    %esi,(%esp)
    1053:	e8 78 fd ff ff       	call   dd0 <mutex_unlock>
    return 0;
    1058:	83 c4 10             	add    $0x10,%esp
    105b:	31 c0                	xor    %eax,%eax
}
    105d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1060:	5b                   	pop    %ebx
    1061:	5e                   	pop    %esi
    1062:	5f                   	pop    %edi
    1063:	5d                   	pop    %ebp
    1064:	c3                   	ret
    1065:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    106c:	00 
    106d:	8d 76 00             	lea    0x0(%esi),%esi

00001070 <channel_close>:

void
channel_close(channel_t *ch)
{
    1070:	55                   	push   %ebp
    1071:	89 e5                	mov    %esp,%ebp
    1073:	56                   	push   %esi
    1074:	53                   	push   %ebx
    1075:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
    1078:	8d 73 18             	lea    0x18(%ebx),%esi
    107b:	83 ec 0c             	sub    $0xc,%esp
    107e:	56                   	push   %esi
    107f:	e8 dc fc ff ff       	call   d60 <mutex_lock>
    ch->closed = 1;
    cond_broadcast(&ch->not_empty);
    1084:	8d 43 64             	lea    0x64(%ebx),%eax
    ch->closed = 1;
    1087:	c7 43 14 01 00 00 00 	movl   $0x1,0x14(%ebx)
    cond_broadcast(&ch->not_full);
    108e:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    cond_broadcast(&ch->not_empty);
    1094:	89 04 24             	mov    %eax,(%esp)
    1097:	e8 54 fc ff ff       	call   cf0 <cond_broadcast>
    cond_broadcast(&ch->not_full);
    109c:	89 1c 24             	mov    %ebx,(%esp)
    109f:	e8 4c fc ff ff       	call   cf0 <cond_broadcast>
    mutex_unlock(&ch->lock);
    10a4:	83 c4 10             	add    $0x10,%esp
    10a7:	89 75 08             	mov    %esi,0x8(%ebp)
}
    10aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10ad:	5b                   	pop    %ebx
    10ae:	5e                   	pop    %esi
    10af:	5d                   	pop    %ebp
    mutex_unlock(&ch->lock);
    10b0:	e9 1b fd ff ff       	jmp    dd0 <mutex_unlock>
    10b5:	66 90                	xchg   %ax,%ax
    10b7:	66 90                	xchg   %ax,%ax
    10b9:	66 90                	xchg   %ax,%ax
    10bb:	66 90                	xchg   %ax,%ax
    10bd:	66 90                	xchg   %ax,%ax
    10bf:	90                   	nop

000010c0 <rwlock_init>:
#include "types.h"
#include "uthreads.h"

void
rwlock_init(rwlock_t *l)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	53                   	push   %ebx
    10c4:	83 ec 10             	sub    $0x10,%esp
    10c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_init(&l->m);
    10ca:	53                   	push   %ebx
    10cb:	e8 70 fc ff ff       	call   d40 <mutex_init>
    cond_init(&l->can_read);
    10d0:	8d 43 4c             	lea    0x4c(%ebx),%eax
    10d3:	89 04 24             	mov    %eax,(%esp)
    10d6:	e8 45 fb ff ff       	call   c20 <cond_init>
    cond_init(&l->can_write);
    10db:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    10e1:	89 04 24             	mov    %eax,(%esp)
    10e4:	e8 37 fb ff ff       	call   c20 <cond_init>
    l->readers = 0;
    l->writers_wait = 0;
    l->writer_active = 0;
}
    10e9:	83 c4 10             	add    $0x10,%esp
    l->readers = 0;
    10ec:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%ebx)
    10f3:	00 00 00 
    l->writers_wait = 0;
    10f6:	c7 83 d8 00 00 00 00 	movl   $0x0,0xd8(%ebx)
    10fd:	00 00 00 
    l->writer_active = 0;
    1100:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    1107:	00 00 00 
}
    110a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    110d:	c9                   	leave
    110e:	c3                   	ret
    110f:	90                   	nop

00001110 <reader_lock>:
//     mutex_unlock(&l->m);
// }

void
reader_lock(rwlock_t *l)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	56                   	push   %esi
    1114:	53                   	push   %ebx
    1115:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    1118:	83 ec 0c             	sub    $0xc,%esp
    111b:	53                   	push   %ebx
    111c:	e8 3f fc ff ff       	call   d60 <mutex_lock>
    while (l->writer_active)
    1121:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    1127:	83 c4 10             	add    $0x10,%esp
    112a:	85 d2                	test   %edx,%edx
    112c:	74 21                	je     114f <reader_lock+0x3f>
    112e:	8d 73 4c             	lea    0x4c(%ebx),%esi
    1131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_read, &l->m);
    1138:	83 ec 08             	sub    $0x8,%esp
    113b:	53                   	push   %ebx
    113c:	56                   	push   %esi
    113d:	e8 ee fa ff ff       	call   c30 <cond_wait>
    while (l->writer_active)
    1142:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
    1148:	83 c4 10             	add    $0x10,%esp
    114b:	85 c0                	test   %eax,%eax
    114d:	75 e9                	jne    1138 <reader_lock+0x28>
    l->readers++;
    114f:	83 83 d4 00 00 00 01 	addl   $0x1,0xd4(%ebx)
    mutex_unlock(&l->m);
    1156:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1159:	8d 65 f8             	lea    -0x8(%ebp),%esp
    115c:	5b                   	pop    %ebx
    115d:	5e                   	pop    %esi
    115e:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    115f:	e9 6c fc ff ff       	jmp    dd0 <mutex_unlock>
    1164:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    116b:	00 
    116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001170 <reader_unlock>:


void
reader_unlock(rwlock_t *l)
{
    1170:	55                   	push   %ebp
    1171:	89 e5                	mov    %esp,%ebp
    1173:	53                   	push   %ebx
    1174:	83 ec 10             	sub    $0x10,%esp
    1177:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    117a:	53                   	push   %ebx
    117b:	e8 e0 fb ff ff       	call   d60 <mutex_lock>
    l->readers--;
    1180:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    if (l->readers == 0 && l->writers_wait > 0)
    1186:	83 c4 10             	add    $0x10,%esp
    l->readers--;
    1189:	83 e8 01             	sub    $0x1,%eax
    118c:	89 83 d4 00 00 00    	mov    %eax,0xd4(%ebx)
    if (l->readers == 0 && l->writers_wait > 0)
    1192:	85 c0                	test   %eax,%eax
    1194:	75 0a                	jne    11a0 <reader_unlock+0x30>
    1196:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    119c:	85 c0                	test   %eax,%eax
    119e:	7f 10                	jg     11b0 <reader_unlock+0x40>
        cond_signal(&l->can_write);
    mutex_unlock(&l->m);
    11a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    11a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11a6:	c9                   	leave
    mutex_unlock(&l->m);
    11a7:	e9 24 fc ff ff       	jmp    dd0 <mutex_unlock>
    11ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(&l->can_write);
    11b0:	83 ec 0c             	sub    $0xc,%esp
    11b3:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    11b9:	50                   	push   %eax
    11ba:	e8 c1 fa ff ff       	call   c80 <cond_signal>
    11bf:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    11c2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    11c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11c8:	c9                   	leave
    mutex_unlock(&l->m);
    11c9:	e9 02 fc ff ff       	jmp    dd0 <mutex_unlock>
    11ce:	66 90                	xchg   %ax,%ax

000011d0 <writer_lock>:

void
writer_lock(rwlock_t *l)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	56                   	push   %esi
    11d4:	53                   	push   %ebx
    11d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    l->writers_wait++;
    while (l->writer_active || l->readers > 0)
        cond_wait(&l->can_write, &l->m);
    11d8:	8d b3 90 00 00 00    	lea    0x90(%ebx),%esi
    mutex_lock(&l->m);
    11de:	83 ec 0c             	sub    $0xc,%esp
    11e1:	53                   	push   %ebx
    11e2:	e8 79 fb ff ff       	call   d60 <mutex_lock>
    l->writers_wait++;
    11e7:	83 83 d8 00 00 00 01 	addl   $0x1,0xd8(%ebx)
    while (l->writer_active || l->readers > 0)
    11ee:	83 c4 10             	add    $0x10,%esp
    11f1:	eb 12                	jmp    1205 <writer_lock+0x35>
    11f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_write, &l->m);
    11f8:	83 ec 08             	sub    $0x8,%esp
    11fb:	53                   	push   %ebx
    11fc:	56                   	push   %esi
    11fd:	e8 2e fa ff ff       	call   c30 <cond_wait>
    1202:	83 c4 10             	add    $0x10,%esp
    while (l->writer_active || l->readers > 0)
    1205:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    120b:	85 d2                	test   %edx,%edx
    120d:	75 e9                	jne    11f8 <writer_lock+0x28>
    120f:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    1215:	85 c0                	test   %eax,%eax
    1217:	7f df                	jg     11f8 <writer_lock+0x28>
    l->writers_wait--;
    1219:	83 ab d8 00 00 00 01 	subl   $0x1,0xd8(%ebx)
    l->writer_active = 1;
    1220:	c7 83 dc 00 00 00 01 	movl   $0x1,0xdc(%ebx)
    1227:	00 00 00 
    mutex_unlock(&l->m);
    122a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1230:	5b                   	pop    %ebx
    1231:	5e                   	pop    %esi
    1232:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    1233:	e9 98 fb ff ff       	jmp    dd0 <mutex_unlock>
    1238:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    123f:	00 

00001240 <writer_unlock>:

void
writer_unlock(rwlock_t *l)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	53                   	push   %ebx
    1244:	83 ec 10             	sub    $0x10,%esp
    1247:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    124a:	53                   	push   %ebx
    124b:	e8 10 fb ff ff       	call   d60 <mutex_lock>
    l->writer_active = 0;
    if (l->writers_wait > 0)
    1250:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    1256:	83 c4 10             	add    $0x10,%esp
    l->writer_active = 0;
    1259:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    1260:	00 00 00 
    if (l->writers_wait > 0)
    1263:	85 c0                	test   %eax,%eax
    1265:	7e 21                	jle    1288 <writer_unlock+0x48>
        cond_signal(&l->can_write);
    1267:	83 ec 0c             	sub    $0xc,%esp
    126a:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1270:	50                   	push   %eax
    1271:	e8 0a fa ff ff       	call   c80 <cond_signal>
    1276:	83 c4 10             	add    $0x10,%esp
    else
        cond_broadcast(&l->can_read);
    mutex_unlock(&l->m);
    1279:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    127c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    127f:	c9                   	leave
    mutex_unlock(&l->m);
    1280:	e9 4b fb ff ff       	jmp    dd0 <mutex_unlock>
    1285:	8d 76 00             	lea    0x0(%esi),%esi
        cond_broadcast(&l->can_read);
    1288:	83 ec 0c             	sub    $0xc,%esp
    128b:	8d 43 4c             	lea    0x4c(%ebx),%eax
    128e:	50                   	push   %eax
    128f:	e8 5c fa ff ff       	call   cf0 <cond_broadcast>
    1294:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    1297:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    129a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    129d:	c9                   	leave
    mutex_unlock(&l->m);
    129e:	e9 2d fb ff ff       	jmp    dd0 <mutex_unlock>
