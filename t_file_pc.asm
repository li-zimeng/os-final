
_t_file_pc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define TOTAL_ITEMS 20

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
    int p[2];
    pipe(p);
       f:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
      12:	51                   	push   %ecx
      13:	83 ec 28             	sub    $0x28,%esp
    pipe(p);
      16:	50                   	push   %eax
      17:	e8 57 03 00 00       	call   373 <pipe>

    int pid = fork();
      1c:	e8 3a 03 00 00       	call   35b <fork>

    if (pid < 0) {
      21:	83 c4 10             	add    $0x10,%esp
      24:	85 c0                	test   %eax,%eax
      26:	0f 88 dd 00 00 00    	js     109 <main+0x109>
        printf(1, "fork failed\n");
        exit();
    }

    if (pid == 0) {
      2c:	75 50                	jne    7e <main+0x7e>
        close(p[1]);
      2e:	83 ec 0c             	sub    $0xc,%esp
      31:	ff 75 e4             	push   -0x1c(%ebp)
      34:	89 c3                	mov    %eax,%ebx
      36:	8d 75 df             	lea    -0x21(%ebp),%esi
      39:	e8 4d 03 00 00       	call   38b <close>
      3e:	83 c4 10             	add    $0x10,%esp
      41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

        int received = 0;
        char c;

        while (received < TOTAL_ITEMS) {
            if (read(p[0], &c, 1) <= 0)
      48:	83 ec 04             	sub    $0x4,%esp
      4b:	6a 01                	push   $0x1
      4d:	56                   	push   %esi
      4e:	ff 75 e0             	push   -0x20(%ebp)
      51:	e8 25 03 00 00       	call   37b <read>
      56:	83 c4 10             	add    $0x10,%esp
      59:	85 c0                	test   %eax,%eax
      5b:	0f 8e 95 00 00 00    	jle    f6 <main+0xf6>
                break;

            if (c == '\n') {
      61:	0f be 45 df          	movsbl -0x21(%ebp),%eax
      65:	3c 0a                	cmp    $0xa,%al
      67:	74 6f                	je     d8 <main+0xd8>
                printf(1, "\n");
                received++;
            } else {
                printf(1, "%c", c);
      69:	83 ec 04             	sub    $0x4,%esp
      6c:	50                   	push   %eax
      6d:	68 61 12 00 00       	push   $0x1261
      72:	6a 01                	push   $0x1
      74:	e8 37 04 00 00       	call   4b0 <printf>
      79:	83 c4 10             	add    $0x10,%esp
      7c:	eb ca                	jmp    48 <main+0x48>
        }

        printf(1, "Consumer: done\n");
        exit();
    } else {
        close(p[0]);
      7e:	83 ec 0c             	sub    $0xc,%esp
      81:	ff 75 e0             	push   -0x20(%ebp)

        for (int i = 0; i < TOTAL_ITEMS; i++) {
      84:	31 db                	xor    %ebx,%ebx
        close(p[0]);
      86:	e8 00 03 00 00       	call   38b <close>
      8b:	83 c4 10             	add    $0x10,%esp
      8e:	66 90                	xchg   %ax,%ax
            printf(p[1], "item %d\n", i);
      90:	83 ec 04             	sub    $0x4,%esp
      93:	53                   	push   %ebx
      94:	68 84 12 00 00       	push   $0x1284
      99:	ff 75 e4             	push   -0x1c(%ebp)
      9c:	e8 0f 04 00 00       	call   4b0 <printf>
            printf(1, "Producer: wrote item %d\n", i);
      a1:	83 c4 0c             	add    $0xc,%esp
      a4:	53                   	push   %ebx
        for (int i = 0; i < TOTAL_ITEMS; i++) {
      a5:	83 c3 01             	add    $0x1,%ebx
            printf(1, "Producer: wrote item %d\n", i);
      a8:	68 74 12 00 00       	push   $0x1274
      ad:	6a 01                	push   $0x1
      af:	e8 fc 03 00 00       	call   4b0 <printf>
        for (int i = 0; i < TOTAL_ITEMS; i++) {
      b4:	83 c4 10             	add    $0x10,%esp
      b7:	83 fb 14             	cmp    $0x14,%ebx
      ba:	75 d4                	jne    90 <main+0x90>
        }

        printf(1, "Producer: done\n");
      bc:	50                   	push   %eax
      bd:	50                   	push   %eax
      be:	68 8d 12 00 00       	push   $0x128d
      c3:	6a 01                	push   $0x1
      c5:	e8 e6 03 00 00       	call   4b0 <printf>
        wait();
      ca:	e8 9c 02 00 00       	call   36b <wait>
        exit();
      cf:	e8 8f 02 00 00       	call   363 <exit>
      d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(1, "\n");
      d8:	83 ec 08             	sub    $0x8,%esp
                received++;
      db:	83 c3 01             	add    $0x1,%ebx
                printf(1, "\n");
      de:	68 8b 12 00 00       	push   $0x128b
      e3:	6a 01                	push   $0x1
      e5:	e8 c6 03 00 00       	call   4b0 <printf>
        while (received < TOTAL_ITEMS) {
      ea:	83 c4 10             	add    $0x10,%esp
      ed:	83 fb 14             	cmp    $0x14,%ebx
      f0:	0f 85 52 ff ff ff    	jne    48 <main+0x48>
        printf(1, "Consumer: done\n");
      f6:	52                   	push   %edx
      f7:	52                   	push   %edx
      f8:	68 64 12 00 00       	push   $0x1264
      fd:	6a 01                	push   $0x1
      ff:	e8 ac 03 00 00       	call   4b0 <printf>
        exit();
     104:	e8 5a 02 00 00       	call   363 <exit>
        printf(1, "fork failed\n");
     109:	51                   	push   %ecx
     10a:	51                   	push   %ecx
     10b:	68 54 12 00 00       	push   $0x1254
     110:	6a 01                	push   $0x1
     112:	e8 99 03 00 00       	call   4b0 <printf>
        exit();
     117:	e8 47 02 00 00       	call   363 <exit>
     11c:	66 90                	xchg   %ax,%ax
     11e:	66 90                	xchg   %ax,%ax

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     120:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     121:	31 c0                	xor    %eax,%eax
{
     123:	89 e5                	mov    %esp,%ebp
     125:	53                   	push   %ebx
     126:	8b 4d 08             	mov    0x8(%ebp),%ecx
     129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     130:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     134:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     137:	83 c0 01             	add    $0x1,%eax
     13a:	84 d2                	test   %dl,%dl
     13c:	75 f2                	jne    130 <strcpy+0x10>
    ;
  return os;
}
     13e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     141:	89 c8                	mov    %ecx,%eax
     143:	c9                   	leave
     144:	c3                   	ret
     145:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     14c:	00 
     14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	53                   	push   %ebx
     154:	8b 55 08             	mov    0x8(%ebp),%edx
     157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     15a:	0f b6 02             	movzbl (%edx),%eax
     15d:	84 c0                	test   %al,%al
     15f:	75 17                	jne    178 <strcmp+0x28>
     161:	eb 3a                	jmp    19d <strcmp+0x4d>
     163:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     168:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     16c:	83 c2 01             	add    $0x1,%edx
     16f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     172:	84 c0                	test   %al,%al
     174:	74 1a                	je     190 <strcmp+0x40>
     176:	89 d9                	mov    %ebx,%ecx
     178:	0f b6 19             	movzbl (%ecx),%ebx
     17b:	38 c3                	cmp    %al,%bl
     17d:	74 e9                	je     168 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     17f:	29 d8                	sub    %ebx,%eax
}
     181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     184:	c9                   	leave
     185:	c3                   	ret
     186:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     18d:	00 
     18e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     190:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     194:	31 c0                	xor    %eax,%eax
     196:	29 d8                	sub    %ebx,%eax
}
     198:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     19b:	c9                   	leave
     19c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     19d:	0f b6 19             	movzbl (%ecx),%ebx
     1a0:	31 c0                	xor    %eax,%eax
     1a2:	eb db                	jmp    17f <strcmp+0x2f>
     1a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     1ab:	00 
     1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strlen>:

uint
strlen(const char *s)
{
     1b0:	55                   	push   %ebp
     1b1:	89 e5                	mov    %esp,%ebp
     1b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     1b6:	80 3a 00             	cmpb   $0x0,(%edx)
     1b9:	74 15                	je     1d0 <strlen+0x20>
     1bb:	31 c0                	xor    %eax,%eax
     1bd:	8d 76 00             	lea    0x0(%esi),%esi
     1c0:	83 c0 01             	add    $0x1,%eax
     1c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     1c7:	89 c1                	mov    %eax,%ecx
     1c9:	75 f5                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
     1cb:	89 c8                	mov    %ecx,%eax
     1cd:	5d                   	pop    %ebp
     1ce:	c3                   	ret
     1cf:	90                   	nop
  for(n = 0; s[n]; n++)
     1d0:	31 c9                	xor    %ecx,%ecx
}
     1d2:	5d                   	pop    %ebp
     1d3:	89 c8                	mov    %ecx,%eax
     1d5:	c3                   	ret
     1d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     1dd:	00 
     1de:	66 90                	xchg   %ax,%ax

000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     1e0:	55                   	push   %ebp
     1e1:	89 e5                	mov    %esp,%ebp
     1e3:	57                   	push   %edi
     1e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
     1ed:	89 d7                	mov    %edx,%edi
     1ef:	fc                   	cld
     1f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     1f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     1f5:	89 d0                	mov    %edx,%eax
     1f7:	c9                   	leave
     1f8:	c3                   	ret
     1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
     200:	55                   	push   %ebp
     201:	89 e5                	mov    %esp,%ebp
     203:	8b 45 08             	mov    0x8(%ebp),%eax
     206:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     20a:	0f b6 10             	movzbl (%eax),%edx
     20d:	84 d2                	test   %dl,%dl
     20f:	75 12                	jne    223 <strchr+0x23>
     211:	eb 1d                	jmp    230 <strchr+0x30>
     213:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     218:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     21c:	83 c0 01             	add    $0x1,%eax
     21f:	84 d2                	test   %dl,%dl
     221:	74 0d                	je     230 <strchr+0x30>
    if(*s == c)
     223:	38 d1                	cmp    %dl,%cl
     225:	75 f1                	jne    218 <strchr+0x18>
      return (char*)s;
  return 0;
}
     227:	5d                   	pop    %ebp
     228:	c3                   	ret
     229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     230:	31 c0                	xor    %eax,%eax
}
     232:	5d                   	pop    %ebp
     233:	c3                   	ret
     234:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     23b:	00 
     23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <gets>:

char*
gets(char *buf, int max)
{
     240:	55                   	push   %ebp
     241:	89 e5                	mov    %esp,%ebp
     243:	57                   	push   %edi
     244:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     245:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
     248:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     249:	31 db                	xor    %ebx,%ebx
{
     24b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     24e:	eb 27                	jmp    277 <gets+0x37>
    cc = read(0, &c, 1);
     250:	83 ec 04             	sub    $0x4,%esp
     253:	6a 01                	push   $0x1
     255:	56                   	push   %esi
     256:	6a 00                	push   $0x0
     258:	e8 1e 01 00 00       	call   37b <read>
    if(cc < 1)
     25d:	83 c4 10             	add    $0x10,%esp
     260:	85 c0                	test   %eax,%eax
     262:	7e 1d                	jle    281 <gets+0x41>
      break;
    buf[i++] = c;
     264:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     268:	8b 55 08             	mov    0x8(%ebp),%edx
     26b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     26f:	3c 0a                	cmp    $0xa,%al
     271:	74 10                	je     283 <gets+0x43>
     273:	3c 0d                	cmp    $0xd,%al
     275:	74 0c                	je     283 <gets+0x43>
  for(i=0; i+1 < max; ){
     277:	89 df                	mov    %ebx,%edi
     279:	83 c3 01             	add    $0x1,%ebx
     27c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     27f:	7c cf                	jl     250 <gets+0x10>
     281:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
     283:	8b 45 08             	mov    0x8(%ebp),%eax
     286:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
     28a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     28d:	5b                   	pop    %ebx
     28e:	5e                   	pop    %esi
     28f:	5f                   	pop    %edi
     290:	5d                   	pop    %ebp
     291:	c3                   	ret
     292:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     299:	00 
     29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002a0 <stat>:

int
stat(const char *n, struct stat *st)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
     2a3:	56                   	push   %esi
     2a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     2a5:	83 ec 08             	sub    $0x8,%esp
     2a8:	6a 00                	push   $0x0
     2aa:	ff 75 08             	push   0x8(%ebp)
     2ad:	e8 f1 00 00 00       	call   3a3 <open>
  if(fd < 0)
     2b2:	83 c4 10             	add    $0x10,%esp
     2b5:	85 c0                	test   %eax,%eax
     2b7:	78 27                	js     2e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     2b9:	83 ec 08             	sub    $0x8,%esp
     2bc:	ff 75 0c             	push   0xc(%ebp)
     2bf:	89 c3                	mov    %eax,%ebx
     2c1:	50                   	push   %eax
     2c2:	e8 f4 00 00 00       	call   3bb <fstat>
  close(fd);
     2c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     2ca:	89 c6                	mov    %eax,%esi
  close(fd);
     2cc:	e8 ba 00 00 00       	call   38b <close>
  return r;
     2d1:	83 c4 10             	add    $0x10,%esp
}
     2d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     2d7:	89 f0                	mov    %esi,%eax
     2d9:	5b                   	pop    %ebx
     2da:	5e                   	pop    %esi
     2db:	5d                   	pop    %ebp
     2dc:	c3                   	ret
     2dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     2e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
     2e5:	eb ed                	jmp    2d4 <stat+0x34>
     2e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     2ee:	00 
     2ef:	90                   	nop

000002f0 <atoi>:

int
atoi(const char *s)
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	53                   	push   %ebx
     2f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     2f7:	0f be 02             	movsbl (%edx),%eax
     2fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
     2fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     300:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     305:	77 1e                	ja     325 <atoi+0x35>
     307:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     30e:	00 
     30f:	90                   	nop
    n = n*10 + *s++ - '0';
     310:	83 c2 01             	add    $0x1,%edx
     313:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     316:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     31a:	0f be 02             	movsbl (%edx),%eax
     31d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     320:	80 fb 09             	cmp    $0x9,%bl
     323:	76 eb                	jbe    310 <atoi+0x20>
  return n;
}
     325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     328:	89 c8                	mov    %ecx,%eax
     32a:	c9                   	leave
     32b:	c3                   	ret
     32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000330 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     330:	55                   	push   %ebp
     331:	89 e5                	mov    %esp,%ebp
     333:	57                   	push   %edi
     334:	8b 45 10             	mov    0x10(%ebp),%eax
     337:	8b 55 08             	mov    0x8(%ebp),%edx
     33a:	56                   	push   %esi
     33b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     33e:	85 c0                	test   %eax,%eax
     340:	7e 13                	jle    355 <memmove+0x25>
     342:	01 d0                	add    %edx,%eax
  dst = vdst;
     344:	89 d7                	mov    %edx,%edi
     346:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     34d:	00 
     34e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
     350:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     351:	39 f8                	cmp    %edi,%eax
     353:	75 fb                	jne    350 <memmove+0x20>
  return vdst;
}
     355:	5e                   	pop    %esi
     356:	89 d0                	mov    %edx,%eax
     358:	5f                   	pop    %edi
     359:	5d                   	pop    %ebp
     35a:	c3                   	ret

0000035b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     35b:	b8 01 00 00 00       	mov    $0x1,%eax
     360:	cd 40                	int    $0x40
     362:	c3                   	ret

00000363 <exit>:
SYSCALL(exit)
     363:	b8 02 00 00 00       	mov    $0x2,%eax
     368:	cd 40                	int    $0x40
     36a:	c3                   	ret

0000036b <wait>:
SYSCALL(wait)
     36b:	b8 03 00 00 00       	mov    $0x3,%eax
     370:	cd 40                	int    $0x40
     372:	c3                   	ret

00000373 <pipe>:
SYSCALL(pipe)
     373:	b8 04 00 00 00       	mov    $0x4,%eax
     378:	cd 40                	int    $0x40
     37a:	c3                   	ret

0000037b <read>:
SYSCALL(read)
     37b:	b8 05 00 00 00       	mov    $0x5,%eax
     380:	cd 40                	int    $0x40
     382:	c3                   	ret

00000383 <write>:
SYSCALL(write)
     383:	b8 10 00 00 00       	mov    $0x10,%eax
     388:	cd 40                	int    $0x40
     38a:	c3                   	ret

0000038b <close>:
SYSCALL(close)
     38b:	b8 15 00 00 00       	mov    $0x15,%eax
     390:	cd 40                	int    $0x40
     392:	c3                   	ret

00000393 <kill>:
SYSCALL(kill)
     393:	b8 06 00 00 00       	mov    $0x6,%eax
     398:	cd 40                	int    $0x40
     39a:	c3                   	ret

0000039b <exec>:
SYSCALL(exec)
     39b:	b8 07 00 00 00       	mov    $0x7,%eax
     3a0:	cd 40                	int    $0x40
     3a2:	c3                   	ret

000003a3 <open>:
SYSCALL(open)
     3a3:	b8 0f 00 00 00       	mov    $0xf,%eax
     3a8:	cd 40                	int    $0x40
     3aa:	c3                   	ret

000003ab <mknod>:
SYSCALL(mknod)
     3ab:	b8 11 00 00 00       	mov    $0x11,%eax
     3b0:	cd 40                	int    $0x40
     3b2:	c3                   	ret

000003b3 <unlink>:
SYSCALL(unlink)
     3b3:	b8 12 00 00 00       	mov    $0x12,%eax
     3b8:	cd 40                	int    $0x40
     3ba:	c3                   	ret

000003bb <fstat>:
SYSCALL(fstat)
     3bb:	b8 08 00 00 00       	mov    $0x8,%eax
     3c0:	cd 40                	int    $0x40
     3c2:	c3                   	ret

000003c3 <link>:
SYSCALL(link)
     3c3:	b8 13 00 00 00       	mov    $0x13,%eax
     3c8:	cd 40                	int    $0x40
     3ca:	c3                   	ret

000003cb <mkdir>:
SYSCALL(mkdir)
     3cb:	b8 14 00 00 00       	mov    $0x14,%eax
     3d0:	cd 40                	int    $0x40
     3d2:	c3                   	ret

000003d3 <chdir>:
SYSCALL(chdir)
     3d3:	b8 09 00 00 00       	mov    $0x9,%eax
     3d8:	cd 40                	int    $0x40
     3da:	c3                   	ret

000003db <dup>:
SYSCALL(dup)
     3db:	b8 0a 00 00 00       	mov    $0xa,%eax
     3e0:	cd 40                	int    $0x40
     3e2:	c3                   	ret

000003e3 <getpid>:
SYSCALL(getpid)
     3e3:	b8 0b 00 00 00       	mov    $0xb,%eax
     3e8:	cd 40                	int    $0x40
     3ea:	c3                   	ret

000003eb <sbrk>:
SYSCALL(sbrk)
     3eb:	b8 0c 00 00 00       	mov    $0xc,%eax
     3f0:	cd 40                	int    $0x40
     3f2:	c3                   	ret

000003f3 <sleep>:
SYSCALL(sleep)
     3f3:	b8 0d 00 00 00       	mov    $0xd,%eax
     3f8:	cd 40                	int    $0x40
     3fa:	c3                   	ret

000003fb <uptime>:
SYSCALL(uptime)
     3fb:	b8 0e 00 00 00       	mov    $0xe,%eax
     400:	cd 40                	int    $0x40
     402:	c3                   	ret
     403:	66 90                	xchg   %ax,%ax
     405:	66 90                	xchg   %ax,%ax
     407:	66 90                	xchg   %ax,%ax
     409:	66 90                	xchg   %ax,%ax
     40b:	66 90                	xchg   %ax,%ax
     40d:	66 90                	xchg   %ax,%ax
     40f:	90                   	nop

00000410 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	57                   	push   %edi
     414:	56                   	push   %esi
     415:	53                   	push   %ebx
     416:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     418:	89 d1                	mov    %edx,%ecx
{
     41a:	83 ec 3c             	sub    $0x3c,%esp
     41d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
     420:	85 d2                	test   %edx,%edx
     422:	0f 89 80 00 00 00    	jns    4a8 <printint+0x98>
     428:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     42c:	74 7a                	je     4a8 <printint+0x98>
    x = -xx;
     42e:	f7 d9                	neg    %ecx
    neg = 1;
     430:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
     435:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     438:	31 f6                	xor    %esi,%esi
     43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     440:	89 c8                	mov    %ecx,%eax
     442:	31 d2                	xor    %edx,%edx
     444:	89 f7                	mov    %esi,%edi
     446:	f7 f3                	div    %ebx
     448:	8d 76 01             	lea    0x1(%esi),%esi
     44b:	0f b6 92 fc 12 00 00 	movzbl 0x12fc(%edx),%edx
     452:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
     456:	89 ca                	mov    %ecx,%edx
     458:	89 c1                	mov    %eax,%ecx
     45a:	39 da                	cmp    %ebx,%edx
     45c:	73 e2                	jae    440 <printint+0x30>
  if(neg)
     45e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     461:	85 c0                	test   %eax,%eax
     463:	74 07                	je     46c <printint+0x5c>
    buf[i++] = '-';
     465:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
     46a:	89 f7                	mov    %esi,%edi
     46c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
     46f:	8b 75 c0             	mov    -0x40(%ebp),%esi
     472:	01 df                	add    %ebx,%edi
     474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
     478:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
     47b:	83 ec 04             	sub    $0x4,%esp
     47e:	88 45 d7             	mov    %al,-0x29(%ebp)
     481:	8d 45 d7             	lea    -0x29(%ebp),%eax
     484:	6a 01                	push   $0x1
     486:	50                   	push   %eax
     487:	56                   	push   %esi
     488:	e8 f6 fe ff ff       	call   383 <write>
  while(--i >= 0)
     48d:	89 f8                	mov    %edi,%eax
     48f:	83 c4 10             	add    $0x10,%esp
     492:	83 ef 01             	sub    $0x1,%edi
     495:	39 c3                	cmp    %eax,%ebx
     497:	75 df                	jne    478 <printint+0x68>
}
     499:	8d 65 f4             	lea    -0xc(%ebp),%esp
     49c:	5b                   	pop    %ebx
     49d:	5e                   	pop    %esi
     49e:	5f                   	pop    %edi
     49f:	5d                   	pop    %ebp
     4a0:	c3                   	ret
     4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     4a8:	31 c0                	xor    %eax,%eax
     4aa:	eb 89                	jmp    435 <printint+0x25>
     4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     4b0:	55                   	push   %ebp
     4b1:	89 e5                	mov    %esp,%ebp
     4b3:	57                   	push   %edi
     4b4:	56                   	push   %esi
     4b5:	53                   	push   %ebx
     4b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     4b9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
     4bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
     4bf:	0f b6 1e             	movzbl (%esi),%ebx
     4c2:	83 c6 01             	add    $0x1,%esi
     4c5:	84 db                	test   %bl,%bl
     4c7:	74 67                	je     530 <printf+0x80>
     4c9:	8d 4d 10             	lea    0x10(%ebp),%ecx
     4cc:	31 d2                	xor    %edx,%edx
     4ce:	89 4d d0             	mov    %ecx,-0x30(%ebp)
     4d1:	eb 34                	jmp    507 <printf+0x57>
     4d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     4d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     4db:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     4e0:	83 f8 25             	cmp    $0x25,%eax
     4e3:	74 18                	je     4fd <printf+0x4d>
  write(fd, &c, 1);
     4e5:	83 ec 04             	sub    $0x4,%esp
     4e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
     4eb:	88 5d e7             	mov    %bl,-0x19(%ebp)
     4ee:	6a 01                	push   $0x1
     4f0:	50                   	push   %eax
     4f1:	57                   	push   %edi
     4f2:	e8 8c fe ff ff       	call   383 <write>
     4f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     4fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     4fd:	0f b6 1e             	movzbl (%esi),%ebx
     500:	83 c6 01             	add    $0x1,%esi
     503:	84 db                	test   %bl,%bl
     505:	74 29                	je     530 <printf+0x80>
    c = fmt[i] & 0xff;
     507:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     50a:	85 d2                	test   %edx,%edx
     50c:	74 ca                	je     4d8 <printf+0x28>
      }
    } else if(state == '%'){
     50e:	83 fa 25             	cmp    $0x25,%edx
     511:	75 ea                	jne    4fd <printf+0x4d>
      if(c == 'd'){
     513:	83 f8 25             	cmp    $0x25,%eax
     516:	0f 84 04 01 00 00    	je     620 <printf+0x170>
     51c:	83 e8 63             	sub    $0x63,%eax
     51f:	83 f8 15             	cmp    $0x15,%eax
     522:	77 1c                	ja     540 <printf+0x90>
     524:	ff 24 85 a4 12 00 00 	jmp    *0x12a4(,%eax,4)
     52b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     530:	8d 65 f4             	lea    -0xc(%ebp),%esp
     533:	5b                   	pop    %ebx
     534:	5e                   	pop    %esi
     535:	5f                   	pop    %edi
     536:	5d                   	pop    %ebp
     537:	c3                   	ret
     538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     53f:	00 
  write(fd, &c, 1);
     540:	83 ec 04             	sub    $0x4,%esp
     543:	8d 55 e7             	lea    -0x19(%ebp),%edx
     546:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     54a:	6a 01                	push   $0x1
     54c:	52                   	push   %edx
     54d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     550:	57                   	push   %edi
     551:	e8 2d fe ff ff       	call   383 <write>
     556:	83 c4 0c             	add    $0xc,%esp
     559:	88 5d e7             	mov    %bl,-0x19(%ebp)
     55c:	6a 01                	push   $0x1
     55e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     561:	52                   	push   %edx
     562:	57                   	push   %edi
     563:	e8 1b fe ff ff       	call   383 <write>
        putc(fd, c);
     568:	83 c4 10             	add    $0x10,%esp
      state = 0;
     56b:	31 d2                	xor    %edx,%edx
     56d:	eb 8e                	jmp    4fd <printf+0x4d>
     56f:	90                   	nop
        printint(fd, *ap, 16, 0);
     570:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     573:	83 ec 0c             	sub    $0xc,%esp
     576:	b9 10 00 00 00       	mov    $0x10,%ecx
     57b:	8b 13                	mov    (%ebx),%edx
     57d:	6a 00                	push   $0x0
     57f:	89 f8                	mov    %edi,%eax
        ap++;
     581:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
     584:	e8 87 fe ff ff       	call   410 <printint>
        ap++;
     589:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     58c:	83 c4 10             	add    $0x10,%esp
      state = 0;
     58f:	31 d2                	xor    %edx,%edx
     591:	e9 67 ff ff ff       	jmp    4fd <printf+0x4d>
        s = (char*)*ap;
     596:	8b 45 d0             	mov    -0x30(%ebp),%eax
     599:	8b 18                	mov    (%eax),%ebx
        ap++;
     59b:	83 c0 04             	add    $0x4,%eax
     59e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
     5a1:	85 db                	test   %ebx,%ebx
     5a3:	0f 84 87 00 00 00    	je     630 <printf+0x180>
        while(*s != 0){
     5a9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
     5ac:	31 d2                	xor    %edx,%edx
        while(*s != 0){
     5ae:	84 c0                	test   %al,%al
     5b0:	0f 84 47 ff ff ff    	je     4fd <printf+0x4d>
     5b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
     5b9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
     5bc:	89 de                	mov    %ebx,%esi
     5be:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
     5c0:	83 ec 04             	sub    $0x4,%esp
     5c3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
     5c6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     5c9:	6a 01                	push   $0x1
     5cb:	53                   	push   %ebx
     5cc:	57                   	push   %edi
     5cd:	e8 b1 fd ff ff       	call   383 <write>
        while(*s != 0){
     5d2:	0f b6 06             	movzbl (%esi),%eax
     5d5:	83 c4 10             	add    $0x10,%esp
     5d8:	84 c0                	test   %al,%al
     5da:	75 e4                	jne    5c0 <printf+0x110>
      state = 0;
     5dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
     5df:	31 d2                	xor    %edx,%edx
     5e1:	e9 17 ff ff ff       	jmp    4fd <printf+0x4d>
        printint(fd, *ap, 10, 1);
     5e6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     5e9:	83 ec 0c             	sub    $0xc,%esp
     5ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
     5f1:	8b 13                	mov    (%ebx),%edx
     5f3:	6a 01                	push   $0x1
     5f5:	eb 88                	jmp    57f <printf+0xcf>
        putc(fd, *ap);
     5f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
     5fa:	83 ec 04             	sub    $0x4,%esp
     5fd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
     600:	8b 03                	mov    (%ebx),%eax
        ap++;
     602:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
     605:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     608:	6a 01                	push   $0x1
     60a:	52                   	push   %edx
     60b:	57                   	push   %edi
     60c:	e8 72 fd ff ff       	call   383 <write>
        ap++;
     611:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     614:	83 c4 10             	add    $0x10,%esp
      state = 0;
     617:	31 d2                	xor    %edx,%edx
     619:	e9 df fe ff ff       	jmp    4fd <printf+0x4d>
     61e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
     620:	83 ec 04             	sub    $0x4,%esp
     623:	88 5d e7             	mov    %bl,-0x19(%ebp)
     626:	8d 55 e7             	lea    -0x19(%ebp),%edx
     629:	6a 01                	push   $0x1
     62b:	e9 31 ff ff ff       	jmp    561 <printf+0xb1>
     630:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
     635:	bb 9d 12 00 00       	mov    $0x129d,%ebx
     63a:	e9 77 ff ff ff       	jmp    5b6 <printf+0x106>
     63f:	90                   	nop

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     641:	a1 00 1a 00 00       	mov    0x1a00,%eax
{
     646:	89 e5                	mov    %esp,%ebp
     648:	57                   	push   %edi
     649:	56                   	push   %esi
     64a:	53                   	push   %ebx
     64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     64e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     658:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     65a:	39 c8                	cmp    %ecx,%eax
     65c:	73 32                	jae    690 <free+0x50>
     65e:	39 d1                	cmp    %edx,%ecx
     660:	72 04                	jb     666 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     662:	39 d0                	cmp    %edx,%eax
     664:	72 32                	jb     698 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
     666:	8b 73 fc             	mov    -0x4(%ebx),%esi
     669:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     66c:	39 fa                	cmp    %edi,%edx
     66e:	74 30                	je     6a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     670:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     673:	8b 50 04             	mov    0x4(%eax),%edx
     676:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     679:	39 f1                	cmp    %esi,%ecx
     67b:	74 3a                	je     6b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     67d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
     67f:	5b                   	pop    %ebx
  freep = p;
     680:	a3 00 1a 00 00       	mov    %eax,0x1a00
}
     685:	5e                   	pop    %esi
     686:	5f                   	pop    %edi
     687:	5d                   	pop    %ebp
     688:	c3                   	ret
     689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     690:	39 d0                	cmp    %edx,%eax
     692:	72 04                	jb     698 <free+0x58>
     694:	39 d1                	cmp    %edx,%ecx
     696:	72 ce                	jb     666 <free+0x26>
{
     698:	89 d0                	mov    %edx,%eax
     69a:	eb bc                	jmp    658 <free+0x18>
     69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
     6a0:	03 72 04             	add    0x4(%edx),%esi
     6a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     6a6:	8b 10                	mov    (%eax),%edx
     6a8:	8b 12                	mov    (%edx),%edx
     6aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     6ad:	8b 50 04             	mov    0x4(%eax),%edx
     6b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     6b3:	39 f1                	cmp    %esi,%ecx
     6b5:	75 c6                	jne    67d <free+0x3d>
    p->s.size += bp->s.size;
     6b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
     6ba:	a3 00 1a 00 00       	mov    %eax,0x1a00
    p->s.size += bp->s.size;
     6bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     6c2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
     6c5:	89 08                	mov    %ecx,(%eax)
}
     6c7:	5b                   	pop    %ebx
     6c8:	5e                   	pop    %esi
     6c9:	5f                   	pop    %edi
     6ca:	5d                   	pop    %ebp
     6cb:	c3                   	ret
     6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     6d0:	55                   	push   %ebp
     6d1:	89 e5                	mov    %esp,%ebp
     6d3:	57                   	push   %edi
     6d4:	56                   	push   %esi
     6d5:	53                   	push   %ebx
     6d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     6dc:	8b 15 00 1a 00 00    	mov    0x1a00,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     6e2:	8d 78 07             	lea    0x7(%eax),%edi
     6e5:	c1 ef 03             	shr    $0x3,%edi
     6e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
     6eb:	85 d2                	test   %edx,%edx
     6ed:	0f 84 8d 00 00 00    	je     780 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     6f3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     6f5:	8b 48 04             	mov    0x4(%eax),%ecx
     6f8:	39 f9                	cmp    %edi,%ecx
     6fa:	73 64                	jae    760 <malloc+0x90>
  if(nu < 4096)
     6fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
     701:	39 df                	cmp    %ebx,%edi
     703:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
     706:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
     70d:	eb 0a                	jmp    719 <malloc+0x49>
     70f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     710:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     712:	8b 48 04             	mov    0x4(%eax),%ecx
     715:	39 f9                	cmp    %edi,%ecx
     717:	73 47                	jae    760 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     719:	89 c2                	mov    %eax,%edx
     71b:	3b 05 00 1a 00 00    	cmp    0x1a00,%eax
     721:	75 ed                	jne    710 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
     723:	83 ec 0c             	sub    $0xc,%esp
     726:	56                   	push   %esi
     727:	e8 bf fc ff ff       	call   3eb <sbrk>
  if(p == (char*)-1)
     72c:	83 c4 10             	add    $0x10,%esp
     72f:	83 f8 ff             	cmp    $0xffffffff,%eax
     732:	74 1c                	je     750 <malloc+0x80>
  hp->s.size = nu;
     734:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     737:	83 ec 0c             	sub    $0xc,%esp
     73a:	83 c0 08             	add    $0x8,%eax
     73d:	50                   	push   %eax
     73e:	e8 fd fe ff ff       	call   640 <free>
  return freep;
     743:	8b 15 00 1a 00 00    	mov    0x1a00,%edx
      if((p = morecore(nunits)) == 0)
     749:	83 c4 10             	add    $0x10,%esp
     74c:	85 d2                	test   %edx,%edx
     74e:	75 c0                	jne    710 <malloc+0x40>
        return 0;
  }
}
     750:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     753:	31 c0                	xor    %eax,%eax
}
     755:	5b                   	pop    %ebx
     756:	5e                   	pop    %esi
     757:	5f                   	pop    %edi
     758:	5d                   	pop    %ebp
     759:	c3                   	ret
     75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
     760:	39 cf                	cmp    %ecx,%edi
     762:	74 4c                	je     7b0 <malloc+0xe0>
        p->s.size -= nunits;
     764:	29 f9                	sub    %edi,%ecx
     766:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
     769:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
     76c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
     76f:	89 15 00 1a 00 00    	mov    %edx,0x1a00
}
     775:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
     778:	83 c0 08             	add    $0x8,%eax
}
     77b:	5b                   	pop    %ebx
     77c:	5e                   	pop    %esi
     77d:	5f                   	pop    %edi
     77e:	5d                   	pop    %ebp
     77f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
     780:	c7 05 00 1a 00 00 04 	movl   $0x1a04,0x1a00
     787:	1a 00 00 
    base.s.size = 0;
     78a:	b8 04 1a 00 00       	mov    $0x1a04,%eax
    base.s.ptr = freep = prevp = &base;
     78f:	c7 05 04 1a 00 00 04 	movl   $0x1a04,0x1a04
     796:	1a 00 00 
    base.s.size = 0;
     799:	c7 05 08 1a 00 00 00 	movl   $0x0,0x1a08
     7a0:	00 00 00 
    if(p->s.size >= nunits){
     7a3:	e9 54 ff ff ff       	jmp    6fc <malloc+0x2c>
     7a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7af:	00 
        prevp->s.ptr = p->s.ptr;
     7b0:	8b 08                	mov    (%eax),%ecx
     7b2:	89 0a                	mov    %ecx,(%edx)
     7b4:	eb b9                	jmp    76f <malloc+0x9f>
     7b6:	66 90                	xchg   %ax,%ax
     7b8:	66 90                	xchg   %ax,%ax
     7ba:	66 90                	xchg   %ax,%ax
     7bc:	66 90                	xchg   %ax,%ax
     7be:	66 90                	xchg   %ax,%ax

000007c0 <thread_init>:
}

void
thread_init(void)
{
    for (int i = 0; i < MAX_THREADS; i++) {
     7c0:	b8 40 1a 00 00       	mov    $0x1a40,%eax
     7c5:	8d 76 00             	lea    0x0(%esi),%esi
        threads[i].tid = -1;
     7c8:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     7ce:	83 c0 20             	add    $0x20,%eax
        threads[i].state = T_UNUSED;
     7d1:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
        threads[i].stack = 0;
     7d8:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
        threads[i].sp = 0;
     7df:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        threads[i].start_routine = 0;
     7e6:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        threads[i].arg = 0;
     7ed:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
        threads[i].retval = 0;
     7f4:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        threads[i].waiting_tid = -1;
     7fb:	c7 40 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%eax)
    for (int i = 0; i < MAX_THREADS; i++) {
     802:	3d 40 1c 00 00       	cmp    $0x1c40,%eax
     807:	75 bf                	jne    7c8 <thread_init+0x8>
    }

    threads[0].tid = 0;
     809:	c7 05 40 1a 00 00 00 	movl   $0x0,0x1a40
     810:	00 00 00 
    threads[0].state = T_RUNNING;
     813:	c7 05 44 1a 00 00 02 	movl   $0x2,0x1a44
     81a:	00 00 00 
    threads[0].waiting_tid = -1;
     81d:	c7 05 5c 1a 00 00 ff 	movl   $0xffffffff,0x1a5c
     824:	ff ff ff 

    current_thread = &threads[0];
     827:	c7 05 20 1a 00 00 40 	movl   $0x1a40,0x1a20
     82e:	1a 00 00 
}
     831:	c3                   	ret
     832:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     839:	00 
     83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000840 <thread_self>:

int
thread_self(void)
{
    return current_thread->tid;
     840:	a1 20 1a 00 00       	mov    0x1a20,%eax
     845:	8b 00                	mov    (%eax),%eax
}
     847:	c3                   	ret
     848:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     84f:	00 

00000850 <thread_create>:

int
thread_create(void* (*start_routine)(void*), void *arg)
{
     850:	55                   	push   %ebp
    int i;
    for (i = 0; i < MAX_THREADS; i++) {
     851:	31 c0                	xor    %eax,%eax
{
     853:	89 e5                	mov    %esp,%ebp
     855:	56                   	push   %esi
     856:	53                   	push   %ebx
     857:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     85e:	00 
     85f:	90                   	nop
        if (threads[i].state == T_UNUSED)
     860:	89 c3                	mov    %eax,%ebx
     862:	c1 e3 05             	shl    $0x5,%ebx
     865:	8b 93 44 1a 00 00    	mov    0x1a44(%ebx),%edx
     86b:	85 d2                	test   %edx,%edx
     86d:	74 19                	je     888 <thread_create+0x38>
    for (i = 0; i < MAX_THREADS; i++) {
     86f:	83 c0 01             	add    $0x1,%eax
     872:	83 f8 10             	cmp    $0x10,%eax
     875:	75 e9                	jne    860 <thread_create+0x10>
            break;
    }
    if (i == MAX_THREADS)
        return -1;
     877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     87c:	e9 8c 00 00 00       	jmp    90d <thread_create+0xbd>
     881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    struct thread *t = &threads[i];

    t->tid = next_tid++;
     888:	a1 f0 19 00 00       	mov    0x19f0,%eax
     88d:	8d b3 40 1a 00 00    	lea    0x1a40(%ebx),%esi
    t->start_routine = start_routine;
    t->arg = arg;
    t->retval = 0;
    t->waiting_tid = -1;

    t->stack = malloc(STACK_SIZE);
     893:	83 ec 0c             	sub    $0xc,%esp
    t->state = T_RUNNABLE;
     896:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    t->tid = next_tid++;
     89d:	89 83 40 1a 00 00    	mov    %eax,0x1a40(%ebx)
     8a3:	8d 50 01             	lea    0x1(%eax),%edx
    t->start_routine = start_routine;
     8a6:	8b 45 08             	mov    0x8(%ebp),%eax
    t->tid = next_tid++;
     8a9:	89 15 f0 19 00 00    	mov    %edx,0x19f0
    t->start_routine = start_routine;
     8af:	89 46 10             	mov    %eax,0x10(%esi)
    t->arg = arg;
     8b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    t->retval = 0;
     8b5:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
    t->arg = arg;
     8bc:	89 46 14             	mov    %eax,0x14(%esi)
    t->waiting_tid = -1;
     8bf:	c7 46 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%esi)
    t->stack = malloc(STACK_SIZE);
     8c6:	68 00 10 00 00       	push   $0x1000
     8cb:	e8 00 fe ff ff       	call   6d0 <malloc>
    if (!t->stack) {
     8d0:	83 c4 10             	add    $0x10,%esp
    t->stack = malloc(STACK_SIZE);
     8d3:	89 46 08             	mov    %eax,0x8(%esi)
    if (!t->stack) {
     8d6:	85 c0                	test   %eax,%eax
     8d8:	74 3a                	je     914 <thread_create+0xc4>
        t->state = T_UNUSED;
        return -1;
    }

    uint *sp = (uint *)((char *)t->stack + STACK_SIZE);
    *(--sp) = (uint)thread_trampoline;
     8da:	c7 80 fc 0f 00 00 20 	movl   $0xa20,0xffc(%eax)
     8e1:	0a 00 00 
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;
     8e4:	05 ec 0f 00 00       	add    $0xfec,%eax
    *(--sp) = 0;
     8e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    *(--sp) = 0;
     8f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    *(--sp) = 0;
     8f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    *(--sp) = 0;
     8fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     904:	89 46 0c             	mov    %eax,0xc(%esi)
    t->sp = sp;

    return t->tid;
     907:	8b 83 40 1a 00 00    	mov    0x1a40(%ebx),%eax
}
     90d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     910:	5b                   	pop    %ebx
     911:	5e                   	pop    %esi
     912:	5d                   	pop    %ebp
     913:	c3                   	ret
        t->state = T_UNUSED;
     914:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
        return -1;
     91b:	e9 57 ff ff ff       	jmp    877 <thread_create+0x27>

00000920 <thread_schedule>:

void
thread_schedule(void)
{
     920:	55                   	push   %ebp
     921:	89 e5                	mov    %esp,%ebp
     923:	57                   	push   %edi
     924:	56                   	push   %esi
     925:	53                   	push   %ebx
     926:	83 ec 0c             	sub    $0xc,%esp
    struct thread *old = current_thread;
     929:	8b 35 20 1a 00 00    	mov    0x1a20,%esi
    struct thread *next = 0;

    int start = (old - threads + 1) % MAX_THREADS;
     92f:	89 f0                	mov    %esi,%eax
     931:	2d 40 1a 00 00       	sub    $0x1a40,%eax
     936:	c1 f8 05             	sar    $0x5,%eax
     939:	83 c0 01             	add    $0x1,%eax
     93c:	99                   	cltd
     93d:	c1 ea 1c             	shr    $0x1c,%edx
     940:	01 d0                	add    %edx,%eax
     942:	83 e0 0f             	and    $0xf,%eax
     945:	29 d0                	sub    %edx,%eax
     947:	8d 58 10             	lea    0x10(%eax),%ebx
     94a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for (int i = 0; i < MAX_THREADS; i++) {
        int idx = (start + i) % MAX_THREADS;
     950:	89 c1                	mov    %eax,%ecx
     952:	c1 f9 1f             	sar    $0x1f,%ecx
     955:	c1 e9 1c             	shr    $0x1c,%ecx
     958:	8d 14 08             	lea    (%eax,%ecx,1),%edx
     95b:	83 e2 0f             	and    $0xf,%edx
     95e:	29 ca                	sub    %ecx,%edx
        if (threads[idx].state == T_RUNNABLE) {
     960:	89 d1                	mov    %edx,%ecx
     962:	c1 e1 05             	shl    $0x5,%ecx
     965:	83 b9 44 1a 00 00 01 	cmpl   $0x1,0x1a44(%ecx)
     96c:	8d b9 40 1a 00 00    	lea    0x1a40(%ecx),%edi
     972:	74 14                	je     988 <thread_schedule+0x68>
    for (int i = 0; i < MAX_THREADS; i++) {
     974:	83 c0 01             	add    $0x1,%eax
     977:	39 d8                	cmp    %ebx,%eax
     979:	75 d5                	jne    950 <thread_schedule+0x30>

    next->state = T_RUNNING;
    current_thread = next;

    thread_switch(old, next);
}
     97b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     97e:	5b                   	pop    %ebx
     97f:	5e                   	pop    %esi
     980:	5f                   	pop    %edi
     981:	5d                   	pop    %ebp
     982:	c3                   	ret
     983:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (old->state == T_RUNNING)
     988:	83 7e 04 02          	cmpl   $0x2,0x4(%esi)
     98c:	75 07                	jne    995 <thread_schedule+0x75>
        old->state = T_RUNNABLE;
     98e:	c7 46 04 01 00 00 00 	movl   $0x1,0x4(%esi)
    thread_switch(old, next);
     995:	83 ec 08             	sub    $0x8,%esp
    next->state = T_RUNNING;
     998:	c1 e2 05             	shl    $0x5,%edx
    current_thread = next;
     99b:	89 3d 20 1a 00 00    	mov    %edi,0x1a20
    next->state = T_RUNNING;
     9a1:	c7 82 44 1a 00 00 02 	movl   $0x2,0x1a44(%edx)
     9a8:	00 00 00 
    thread_switch(old, next);
     9ab:	57                   	push   %edi
     9ac:	56                   	push   %esi
     9ad:	e8 1e 03 00 00       	call   cd0 <thread_switch>
     9b2:	83 c4 10             	add    $0x10,%esp
}
     9b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9b8:	5b                   	pop    %ebx
     9b9:	5e                   	pop    %esi
     9ba:	5f                   	pop    %edi
     9bb:	5d                   	pop    %ebp
     9bc:	c3                   	ret
     9bd:	8d 76 00             	lea    0x0(%esi),%esi

000009c0 <thread_yield>:

void
thread_yield(void)
{
    thread_schedule();
     9c0:	e9 5b ff ff ff       	jmp    920 <thread_schedule>
     9c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9cc:	00 
     9cd:	8d 76 00             	lea    0x0(%esi),%esi

000009d0 <thread_exit>:
}

void
thread_exit(void *retval)
{
     9d0:	55                   	push   %ebp
     9d1:	89 e5                	mov    %esp,%ebp
     9d3:	83 ec 08             	sub    $0x8,%esp
    current_thread->retval = retval;
     9d6:	a1 20 1a 00 00       	mov    0x1a20,%eax
     9db:	8b 55 08             	mov    0x8(%ebp),%edx
    current_thread->state = T_ZOMBIE;

    if (current_thread->waiting_tid >= 0) {
     9de:	8b 48 1c             	mov    0x1c(%eax),%ecx
    current_thread->state = T_ZOMBIE;
     9e1:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
    current_thread->retval = retval;
     9e8:	89 50 18             	mov    %edx,0x18(%eax)
    if (current_thread->waiting_tid >= 0) {
     9eb:	85 c9                	test   %ecx,%ecx
     9ed:	78 1e                	js     a0d <thread_exit+0x3d>
        for (int i = 0; i < MAX_THREADS; i++) {
     9ef:	31 c0                	xor    %eax,%eax
     9f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (threads[i].tid == current_thread->waiting_tid) {
     9f8:	89 c2                	mov    %eax,%edx
     9fa:	c1 e2 05             	shl    $0x5,%edx
     9fd:	3b 8a 40 1a 00 00    	cmp    0x1a40(%edx),%ecx
     a03:	74 0f                	je     a14 <thread_exit+0x44>
        for (int i = 0; i < MAX_THREADS; i++) {
     a05:	83 c0 01             	add    $0x1,%eax
     a08:	83 f8 10             	cmp    $0x10,%eax
     a0b:	75 eb                	jne    9f8 <thread_exit+0x28>
                break;
            }
        }
    }

    thread_schedule();
     a0d:	e8 0e ff ff ff       	call   920 <thread_schedule>

    for (;;)
     a12:	eb fe                	jmp    a12 <thread_exit+0x42>
                threads[i].state = T_RUNNABLE;
     a14:	c7 82 44 1a 00 00 01 	movl   $0x1,0x1a44(%edx)
     a1b:	00 00 00 
                break;
     a1e:	eb ed                	jmp    a0d <thread_exit+0x3d>

00000a20 <thread_trampoline>:
{
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	83 ec 14             	sub    $0x14,%esp
    void *ret = current_thread->start_routine(current_thread->arg);
     a26:	a1 20 1a 00 00       	mov    0x1a20,%eax
     a2b:	ff 70 14             	push   0x14(%eax)
     a2e:	ff 50 10             	call   *0x10(%eax)
    thread_exit(ret);
     a31:	89 04 24             	mov    %eax,(%esp)
     a34:	e8 97 ff ff ff       	call   9d0 <thread_exit>
     a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a40 <thread_join>:
        ;
}

void *
thread_join(int tid)
{
     a40:	55                   	push   %ebp
     a41:	89 e5                	mov    %esp,%ebp
     a43:	57                   	push   %edi
     a44:	56                   	push   %esi
     a45:	53                   	push   %ebx
    struct thread *target = 0;

    for (int i = 0; i < MAX_THREADS; i++) {
     a46:	31 db                	xor    %ebx,%ebx
{
     a48:	83 ec 0c             	sub    $0xc,%esp
     a4b:	8b 55 08             	mov    0x8(%ebp),%edx
     a4e:	66 90                	xchg   %ax,%ax
        if (threads[i].tid == tid) {
     a50:	89 d8                	mov    %ebx,%eax
     a52:	c1 e0 05             	shl    $0x5,%eax
     a55:	39 90 40 1a 00 00    	cmp    %edx,0x1a40(%eax)
     a5b:	74 1b                	je     a78 <thread_join+0x38>
    for (int i = 0; i < MAX_THREADS; i++) {
     a5d:	83 c3 01             	add    $0x1,%ebx
     a60:	83 fb 10             	cmp    $0x10,%ebx
     a63:	75 eb                	jne    a50 <thread_join+0x10>
    target->stack = 0;
    target->state = T_UNUSED;
    target->tid = -1;

    return ret;
}
     a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     a68:	31 ff                	xor    %edi,%edi
}
     a6a:	5b                   	pop    %ebx
     a6b:	89 f8                	mov    %edi,%eax
     a6d:	5e                   	pop    %esi
     a6e:	5f                   	pop    %edi
     a6f:	5d                   	pop    %ebp
     a70:	c3                   	ret
     a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (target->state != T_ZOMBIE) {
     a78:	83 b8 44 1a 00 00 04 	cmpl   $0x4,0x1a44(%eax)
     a7f:	8d b0 40 1a 00 00    	lea    0x1a40(%eax),%esi
     a85:	74 25                	je     aac <thread_join+0x6c>
     a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a8e:	00 
     a8f:	90                   	nop
        current_thread->state = T_SLEEPING;
     a90:	a1 20 1a 00 00       	mov    0x1a20,%eax
     a95:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        target->waiting_tid = current_thread->tid;
     a9c:	8b 00                	mov    (%eax),%eax
     a9e:	89 46 1c             	mov    %eax,0x1c(%esi)
        thread_schedule();
     aa1:	e8 7a fe ff ff       	call   920 <thread_schedule>
    while (target->state != T_ZOMBIE) {
     aa6:	83 7e 04 04          	cmpl   $0x4,0x4(%esi)
     aaa:	75 e4                	jne    a90 <thread_join+0x50>
    void *ret = target->retval;
     aac:	c1 e3 05             	shl    $0x5,%ebx
    free(target->stack);
     aaf:	83 ec 0c             	sub    $0xc,%esp
    void *ret = target->retval;
     ab2:	8b bb 58 1a 00 00    	mov    0x1a58(%ebx),%edi
    free(target->stack);
     ab8:	ff b3 48 1a 00 00    	push   0x1a48(%ebx)
     abe:	e8 7d fb ff ff       	call   640 <free>
    return ret;
     ac3:	83 c4 10             	add    $0x10,%esp
}
     ac6:	89 f8                	mov    %edi,%eax
    target->stack = 0;
     ac8:	c7 83 48 1a 00 00 00 	movl   $0x0,0x1a48(%ebx)
     acf:	00 00 00 
    target->state = T_UNUSED;
     ad2:	c7 83 44 1a 00 00 00 	movl   $0x0,0x1a44(%ebx)
     ad9:	00 00 00 
    target->tid = -1;
     adc:	c7 83 40 1a 00 00 ff 	movl   $0xffffffff,0x1a40(%ebx)
     ae3:	ff ff ff 
}
     ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ae9:	5b                   	pop    %ebx
     aea:	5e                   	pop    %esi
     aeb:	5f                   	pop    %edi
     aec:	5d                   	pop    %ebp
     aed:	c3                   	ret
     aee:	66 90                	xchg   %ax,%ax

00000af0 <sem_init>:
void
sem_init(sem_t *s, int value)
{
     af0:	55                   	push   %ebp
     af1:	89 e5                	mov    %esp,%ebp
     af3:	8b 45 08             	mov    0x8(%ebp),%eax
    s->count = value;
     af6:	8b 55 0c             	mov    0xc(%ebp),%edx
    s->wait_count = 0;
     af9:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    s->count = value;
     b00:	89 10                	mov    %edx,(%eax)
}
     b02:	5d                   	pop    %ebp
     b03:	c3                   	ret
     b04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b0b:	00 
     b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b10 <sem_wait>:

void
sem_wait(sem_t *s)
{
     b10:	55                   	push   %ebp
     b11:	89 e5                	mov    %esp,%ebp
     b13:	53                   	push   %ebx
     b14:	8b 55 08             	mov    0x8(%ebp),%edx
    s->count--;
     b17:	83 2a 01             	subl   $0x1,(%edx)
    if (s->count < 0) {
     b1a:	78 0c                	js     b28 <sem_wait+0x18>
        s->wait_queue[s->wait_count++] = current_thread->tid;
        current_thread->state = T_SLEEPING;
        thread_schedule();
    }
}
     b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b1f:	c9                   	leave
     b20:	c3                   	ret
     b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s->wait_queue[s->wait_count++] = current_thread->tid;
     b28:	8b 4a 44             	mov    0x44(%edx),%ecx
     b2b:	a1 20 1a 00 00       	mov    0x1a20,%eax
     b30:	8d 59 01             	lea    0x1(%ecx),%ebx
     b33:	89 5a 44             	mov    %ebx,0x44(%edx)
     b36:	8b 18                	mov    (%eax),%ebx
     b38:	89 5c 8a 04          	mov    %ebx,0x4(%edx,%ecx,4)
        current_thread->state = T_SLEEPING;
     b3c:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
}
     b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b46:	c9                   	leave
        thread_schedule();
     b47:	e9 d4 fd ff ff       	jmp    920 <thread_schedule>
     b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b50 <sem_post>:

void
sem_post(sem_t *s)
{
     b50:	55                   	push   %ebp
     b51:	89 e5                	mov    %esp,%ebp
     b53:	57                   	push   %edi
     b54:	8b 55 08             	mov    0x8(%ebp),%edx
     b57:	56                   	push   %esi
     b58:	53                   	push   %ebx
    s->count++;
     b59:	8b 02                	mov    (%edx),%eax
     b5b:	83 c0 01             	add    $0x1,%eax
     b5e:	89 02                	mov    %eax,(%edx)
    if (s->count <= 0 && s->wait_count > 0) {
     b60:	85 c0                	test   %eax,%eax
     b62:	7e 0c                	jle    b70 <sem_post+0x20>
                threads[i].state = T_RUNNABLE;
                break;
            }
        }
    }
}
     b64:	5b                   	pop    %ebx
     b65:	5e                   	pop    %esi
     b66:	5f                   	pop    %edi
     b67:	5d                   	pop    %ebp
     b68:	c3                   	ret
     b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (s->count <= 0 && s->wait_count > 0) {
     b70:	8b 7a 44             	mov    0x44(%edx),%edi
     b73:	85 ff                	test   %edi,%edi
     b75:	7e ed                	jle    b64 <sem_post+0x14>
        int tid = s->wait_queue[0];
     b77:	8b 5a 04             	mov    0x4(%edx),%ebx
        for (int i = 1; i < s->wait_count; i++)
     b7a:	83 ff 01             	cmp    $0x1,%edi
     b7d:	74 16                	je     b95 <sem_post+0x45>
     b7f:	8d 42 04             	lea    0x4(%edx),%eax
     b82:	8d 34 ba             	lea    (%edx,%edi,4),%esi
     b85:	8d 76 00             	lea    0x0(%esi),%esi
            s->wait_queue[i - 1] = s->wait_queue[i];
     b88:	8b 48 04             	mov    0x4(%eax),%ecx
        for (int i = 1; i < s->wait_count; i++)
     b8b:	83 c0 04             	add    $0x4,%eax
            s->wait_queue[i - 1] = s->wait_queue[i];
     b8e:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for (int i = 1; i < s->wait_count; i++)
     b91:	39 f0                	cmp    %esi,%eax
     b93:	75 f3                	jne    b88 <sem_post+0x38>
        s->wait_count--;
     b95:	83 ef 01             	sub    $0x1,%edi
        for (int i = 0; i < MAX_THREADS; i++) {
     b98:	31 c0                	xor    %eax,%eax
        s->wait_count--;
     b9a:	89 7a 44             	mov    %edi,0x44(%edx)
        for (int i = 0; i < MAX_THREADS; i++) {
     b9d:	eb 09                	jmp    ba8 <sem_post+0x58>
     b9f:	90                   	nop
     ba0:	83 c0 01             	add    $0x1,%eax
     ba3:	83 f8 10             	cmp    $0x10,%eax
     ba6:	74 bc                	je     b64 <sem_post+0x14>
            if (threads[i].tid == tid) {
     ba8:	89 c2                	mov    %eax,%edx
     baa:	c1 e2 05             	shl    $0x5,%edx
     bad:	39 9a 40 1a 00 00    	cmp    %ebx,0x1a40(%edx)
     bb3:	75 eb                	jne    ba0 <sem_post+0x50>
                threads[i].state = T_RUNNABLE;
     bb5:	c7 82 44 1a 00 00 01 	movl   $0x1,0x1a44(%edx)
     bbc:	00 00 00 
}
     bbf:	5b                   	pop    %ebx
     bc0:	5e                   	pop    %esi
     bc1:	5f                   	pop    %edi
     bc2:	5d                   	pop    %ebp
     bc3:	c3                   	ret
     bc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     bcb:	00 
     bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000bd0 <cond_init>:

void
cond_init(cond_t *c)
{
     bd0:	55                   	push   %ebp
     bd1:	89 e5                	mov    %esp,%ebp
    c->wait_count = 0;
     bd3:	8b 45 08             	mov    0x8(%ebp),%eax
     bd6:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%eax)
}
     bdd:	5d                   	pop    %ebp
     bde:	c3                   	ret
     bdf:	90                   	nop

00000be0 <cond_wait>:

void
cond_wait(cond_t *c, mutex_t *m)
{
     be0:	55                   	push   %ebp
     be1:	89 e5                	mov    %esp,%ebp
     be3:	53                   	push   %ebx
     be4:	83 ec 10             	sub    $0x10,%esp
     be7:	8b 45 08             	mov    0x8(%ebp),%eax
     bea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    c->wait_queue[c->wait_count++] = current_thread->tid;
     bed:	8b 50 40             	mov    0x40(%eax),%edx
     bf0:	8d 4a 01             	lea    0x1(%edx),%ecx
     bf3:	89 48 40             	mov    %ecx,0x40(%eax)
     bf6:	8b 0d 20 1a 00 00    	mov    0x1a20,%ecx
     bfc:	8b 09                	mov    (%ecx),%ecx
     bfe:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    mutex_unlock(m);
     c01:	53                   	push   %ebx
     c02:	e8 79 01 00 00       	call   d80 <mutex_unlock>
    current_thread->state = T_SLEEPING;
     c07:	a1 20 1a 00 00       	mov    0x1a20,%eax
     c0c:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
    thread_schedule();
     c13:	e8 08 fd ff ff       	call   920 <thread_schedule>
    mutex_lock(m);
     c18:	83 c4 10             	add    $0x10,%esp
     c1b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     c1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c21:	c9                   	leave
    mutex_lock(m);
     c22:	e9 e9 00 00 00       	jmp    d10 <mutex_lock>
     c27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c2e:	00 
     c2f:	90                   	nop

00000c30 <cond_signal>:

void
cond_signal(cond_t *c)
{
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	57                   	push   %edi
     c34:	8b 7d 08             	mov    0x8(%ebp),%edi
     c37:	56                   	push   %esi
     c38:	53                   	push   %ebx
    if (c->wait_count == 0)
     c39:	8b 77 40             	mov    0x40(%edi),%esi
     c3c:	85 f6                	test   %esi,%esi
     c3e:	74 3d                	je     c7d <cond_signal+0x4d>
        return;

    int tid = c->wait_queue[0];
     c40:	8b 0f                	mov    (%edi),%ecx
    for (int i = 1; i < c->wait_count; i++)
     c42:	83 fe 01             	cmp    $0x1,%esi
     c45:	7e 16                	jle    c5d <cond_signal+0x2d>
     c47:	89 f8                	mov    %edi,%eax
     c49:	8d 5c b7 fc          	lea    -0x4(%edi,%esi,4),%ebx
     c4d:	8d 76 00             	lea    0x0(%esi),%esi
        c->wait_queue[i - 1] = c->wait_queue[i];
     c50:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < c->wait_count; i++)
     c53:	83 c0 04             	add    $0x4,%eax
        c->wait_queue[i - 1] = c->wait_queue[i];
     c56:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < c->wait_count; i++)
     c59:	39 d8                	cmp    %ebx,%eax
     c5b:	75 f3                	jne    c50 <cond_signal+0x20>
    c->wait_count--;
     c5d:	83 ee 01             	sub    $0x1,%esi

    for (int i = 0; i < MAX_THREADS; i++) {
     c60:	31 c0                	xor    %eax,%eax
    c->wait_count--;
     c62:	89 77 40             	mov    %esi,0x40(%edi)
    for (int i = 0; i < MAX_THREADS; i++) {
     c65:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == tid) {
     c68:	89 c2                	mov    %eax,%edx
     c6a:	c1 e2 05             	shl    $0x5,%edx
     c6d:	39 8a 40 1a 00 00    	cmp    %ecx,0x1a40(%edx)
     c73:	74 13                	je     c88 <cond_signal+0x58>
    for (int i = 0; i < MAX_THREADS; i++) {
     c75:	83 c0 01             	add    $0x1,%eax
     c78:	83 f8 10             	cmp    $0x10,%eax
     c7b:	75 eb                	jne    c68 <cond_signal+0x38>
            threads[i].state = T_RUNNABLE;
            break;
        }
    }
}
     c7d:	5b                   	pop    %ebx
     c7e:	5e                   	pop    %esi
     c7f:	5f                   	pop    %edi
     c80:	5d                   	pop    %ebp
     c81:	c3                   	ret
     c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     c88:	c7 82 44 1a 00 00 01 	movl   $0x1,0x1a44(%edx)
     c8f:	00 00 00 
}
     c92:	5b                   	pop    %ebx
     c93:	5e                   	pop    %esi
     c94:	5f                   	pop    %edi
     c95:	5d                   	pop    %ebp
     c96:	c3                   	ret
     c97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c9e:	00 
     c9f:	90                   	nop

00000ca0 <cond_broadcast>:

void
cond_broadcast(cond_t *c)
{
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	53                   	push   %ebx
     ca4:	83 ec 04             	sub    $0x4,%esp
     ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (c->wait_count > 0)
     caa:	8b 53 40             	mov    0x40(%ebx),%edx
     cad:	85 d2                	test   %edx,%edx
     caf:	7e 1a                	jle    ccb <cond_broadcast+0x2b>
     cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(c);
     cb8:	83 ec 0c             	sub    $0xc,%esp
     cbb:	53                   	push   %ebx
     cbc:	e8 6f ff ff ff       	call   c30 <cond_signal>
    while (c->wait_count > 0)
     cc1:	8b 43 40             	mov    0x40(%ebx),%eax
     cc4:	83 c4 10             	add    $0x10,%esp
     cc7:	85 c0                	test   %eax,%eax
     cc9:	7f ed                	jg     cb8 <cond_broadcast+0x18>
}
     ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     cce:	c9                   	leave
     ccf:	c3                   	ret

00000cd0 <thread_switch>:
.text
.globl thread_switch
thread_switch:
  movl 4(%esp), %eax
     cd0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
     cd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  pushl %ebp
     cd8:	55                   	push   %ebp
  pushl %ebx
     cd9:	53                   	push   %ebx
  pushl %esi
     cda:	56                   	push   %esi
  pushl %edi
     cdb:	57                   	push   %edi
  movl %esp, 12(%eax)
     cdc:	89 60 0c             	mov    %esp,0xc(%eax)
  movl 12(%edx), %esp
     cdf:	8b 62 0c             	mov    0xc(%edx),%esp
  popl %edi
     ce2:	5f                   	pop    %edi
  popl %esi
     ce3:	5e                   	pop    %esi
  popl %ebx
     ce4:	5b                   	pop    %ebx
  popl %ebp
     ce5:	5d                   	pop    %ebp
  ret
     ce6:	c3                   	ret
     ce7:	66 90                	xchg   %ax,%ax
     ce9:	66 90                	xchg   %ax,%ax
     ceb:	66 90                	xchg   %ax,%ax
     ced:	66 90                	xchg   %ax,%ax
     cef:	90                   	nop

00000cf0 <mutex_init>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

void
mutex_init(mutex_t *m)
{
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	8b 45 08             	mov    0x8(%ebp),%eax
    m->locked = 0;
     cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    m->owner = -1;
     cfc:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    m->wait_count = 0;
     d03:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
}
     d0a:	5d                   	pop    %ebp
     d0b:	c3                   	ret
     d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d10 <mutex_lock>:

void
mutex_lock(mutex_t *m)
{
     d10:	55                   	push   %ebp
     d11:	89 e5                	mov    %esp,%ebp
     d13:	53                   	push   %ebx
     d14:	83 ec 04             	sub    $0x4,%esp
     d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (m->locked) {
     d1a:	8b 13                	mov    (%ebx),%edx
     d1c:	85 d2                	test   %edx,%edx
     d1e:	75 29                	jne    d49 <mutex_lock+0x39>
     d20:	eb 3e                	jmp    d60 <mutex_lock+0x50>
     d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (m->owner == current_thread->tid)
            return;
        m->wait_queue[m->wait_count++] = current_thread->tid;
     d28:	8b 53 48             	mov    0x48(%ebx),%edx
     d2b:	8d 4a 01             	lea    0x1(%edx),%ecx
     d2e:	89 4b 48             	mov    %ecx,0x48(%ebx)
     d31:	8b 08                	mov    (%eax),%ecx
     d33:	89 4c 93 08          	mov    %ecx,0x8(%ebx,%edx,4)
        current_thread->state = T_SLEEPING;
     d37:	c7 40 04 03 00 00 00 	movl   $0x3,0x4(%eax)
        thread_schedule();
     d3e:	e8 dd fb ff ff       	call   920 <thread_schedule>
    while (m->locked) {
     d43:	8b 03                	mov    (%ebx),%eax
     d45:	85 c0                	test   %eax,%eax
     d47:	74 17                	je     d60 <mutex_lock+0x50>
        if (m->owner == current_thread->tid)
     d49:	a1 20 1a 00 00       	mov    0x1a20,%eax
     d4e:	8b 10                	mov    (%eax),%edx
     d50:	39 53 04             	cmp    %edx,0x4(%ebx)
     d53:	75 d3                	jne    d28 <mutex_lock+0x18>
    }
    m->locked = 1;
    m->owner = current_thread->tid;
}
     d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d58:	c9                   	leave
     d59:	c3                   	ret
     d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m->locked = 1;
     d60:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    m->owner = current_thread->tid;
     d66:	a1 20 1a 00 00       	mov    0x1a20,%eax
     d6b:	8b 00                	mov    (%eax),%eax
     d6d:	89 43 04             	mov    %eax,0x4(%ebx)
}
     d70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d73:	c9                   	leave
     d74:	c3                   	ret
     d75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d7c:	00 
     d7d:	8d 76 00             	lea    0x0(%esi),%esi

00000d80 <mutex_unlock>:

void
mutex_unlock(mutex_t *m)
{
     d80:	55                   	push   %ebp
    if (m->owner != current_thread->tid)
     d81:	a1 20 1a 00 00       	mov    0x1a20,%eax
{
     d86:	89 e5                	mov    %esp,%ebp
     d88:	57                   	push   %edi
     d89:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d8c:	56                   	push   %esi
     d8d:	53                   	push   %ebx
    if (m->owner != current_thread->tid)
     d8e:	8b 00                	mov    (%eax),%eax
     d90:	39 41 04             	cmp    %eax,0x4(%ecx)
     d93:	75 48                	jne    ddd <mutex_unlock+0x5d>
        return;

    if (m->wait_count == 0) {
     d95:	8b 79 48             	mov    0x48(%ecx),%edi
     d98:	85 ff                	test   %edi,%edi
     d9a:	74 4c                	je     de8 <mutex_unlock+0x68>
        m->locked = 0;
        m->owner = -1;
        return;
    }

    int next_tid = m->wait_queue[0];
     d9c:	8b 59 08             	mov    0x8(%ecx),%ebx
    for (int i = 1; i < m->wait_count; i++)
     d9f:	83 ff 01             	cmp    $0x1,%edi
     da2:	7e 19                	jle    dbd <mutex_unlock+0x3d>
     da4:	8d 41 08             	lea    0x8(%ecx),%eax
     da7:	8d 74 b9 04          	lea    0x4(%ecx,%edi,4),%esi
     dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        m->wait_queue[i - 1] = m->wait_queue[i];
     db0:	8b 50 04             	mov    0x4(%eax),%edx
    for (int i = 1; i < m->wait_count; i++)
     db3:	83 c0 04             	add    $0x4,%eax
        m->wait_queue[i - 1] = m->wait_queue[i];
     db6:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (int i = 1; i < m->wait_count; i++)
     db9:	39 f0                	cmp    %esi,%eax
     dbb:	75 f3                	jne    db0 <mutex_unlock+0x30>
    m->wait_count--;
     dbd:	83 ef 01             	sub    $0x1,%edi

    for (int i = 0; i < MAX_THREADS; i++) {
     dc0:	31 c0                	xor    %eax,%eax
    m->wait_count--;
     dc2:	89 79 48             	mov    %edi,0x48(%ecx)
    for (int i = 0; i < MAX_THREADS; i++) {
     dc5:	8d 76 00             	lea    0x0(%esi),%esi
        if (threads[i].tid == next_tid) {
     dc8:	89 c2                	mov    %eax,%edx
     dca:	c1 e2 05             	shl    $0x5,%edx
     dcd:	39 9a 40 1a 00 00    	cmp    %ebx,0x1a40(%edx)
     dd3:	74 2b                	je     e00 <mutex_unlock+0x80>
    for (int i = 0; i < MAX_THREADS; i++) {
     dd5:	83 c0 01             	add    $0x1,%eax
     dd8:	83 f8 10             	cmp    $0x10,%eax
     ddb:	75 eb                	jne    dc8 <mutex_unlock+0x48>
            threads[i].state = T_RUNNABLE;
            m->owner = next_tid;
            break;
        }
    }
}
     ddd:	5b                   	pop    %ebx
     dde:	5e                   	pop    %esi
     ddf:	5f                   	pop    %edi
     de0:	5d                   	pop    %ebp
     de1:	c3                   	ret
     de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        m->locked = 0;
     de8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
        m->owner = -1;
     dee:	c7 41 04 ff ff ff ff 	movl   $0xffffffff,0x4(%ecx)
}
     df5:	5b                   	pop    %ebx
     df6:	5e                   	pop    %esi
     df7:	5f                   	pop    %edi
     df8:	5d                   	pop    %ebp
     df9:	c3                   	ret
     dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            threads[i].state = T_RUNNABLE;
     e00:	c7 82 44 1a 00 00 01 	movl   $0x1,0x1a44(%edx)
     e07:	00 00 00 
            m->owner = next_tid;
     e0a:	89 59 04             	mov    %ebx,0x4(%ecx)
}
     e0d:	5b                   	pop    %ebx
     e0e:	5e                   	pop    %esi
     e0f:	5f                   	pop    %edi
     e10:	5d                   	pop    %ebp
     e11:	c3                   	ret
     e12:	66 90                	xchg   %ax,%ax
     e14:	66 90                	xchg   %ax,%ax
     e16:	66 90                	xchg   %ax,%ax
     e18:	66 90                	xchg   %ax,%ax
     e1a:	66 90                	xchg   %ax,%ax
     e1c:	66 90                	xchg   %ax,%ax
     e1e:	66 90                	xchg   %ax,%ax

00000e20 <channel_create>:
extern struct thread threads[MAX_THREADS];
extern struct thread *current_thread;

channel_t *
channel_create(int capacity)
{
     e20:	55                   	push   %ebp
     e21:	89 e5                	mov    %esp,%ebp
     e23:	56                   	push   %esi
     e24:	53                   	push   %ebx
     e25:	8b 75 08             	mov    0x8(%ebp),%esi
    channel_t *ch = malloc(sizeof(channel_t));
     e28:	83 ec 0c             	sub    $0xc,%esp
     e2b:	68 ec 00 00 00       	push   $0xec
     e30:	e8 9b f8 ff ff       	call   6d0 <malloc>
    if (!ch)
     e35:	83 c4 10             	add    $0x10,%esp
     e38:	85 c0                	test   %eax,%eax
     e3a:	0f 84 7c 00 00 00    	je     ebc <channel_create+0x9c>
        return 0;

    ch->buffer = malloc(sizeof(void *) * capacity);
     e40:	83 ec 0c             	sub    $0xc,%esp
     e43:	89 c3                	mov    %eax,%ebx
     e45:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
     e4c:	50                   	push   %eax
     e4d:	e8 7e f8 ff ff       	call   6d0 <malloc>
    if (!ch->buffer) {
     e52:	83 c4 10             	add    $0x10,%esp
    ch->buffer = malloc(sizeof(void *) * capacity);
     e55:	89 03                	mov    %eax,(%ebx)
    if (!ch->buffer) {
     e57:	85 c0                	test   %eax,%eax
     e59:	74 55                	je     eb0 <channel_create+0x90>
    ch->count = 0;
    ch->head = 0;
    ch->tail = 0;
    ch->closed = 0;

    mutex_init(&ch->lock);
     e5b:	83 ec 0c             	sub    $0xc,%esp
     e5e:	8d 43 18             	lea    0x18(%ebx),%eax
    ch->capacity = capacity;
     e61:	89 73 04             	mov    %esi,0x4(%ebx)
    ch->count = 0;
     e64:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    ch->head = 0;
     e6b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    ch->tail = 0;
     e72:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    ch->closed = 0;
     e79:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    mutex_init(&ch->lock);
     e80:	50                   	push   %eax
     e81:	e8 6a fe ff ff       	call   cf0 <mutex_init>
    cond_init(&ch->not_empty);
     e86:	8d 43 64             	lea    0x64(%ebx),%eax
     e89:	89 04 24             	mov    %eax,(%esp)
     e8c:	e8 3f fd ff ff       	call   bd0 <cond_init>
    cond_init(&ch->not_full);
     e91:	8d 83 a8 00 00 00    	lea    0xa8(%ebx),%eax
     e97:	89 04 24             	mov    %eax,(%esp)
     e9a:	e8 31 fd ff ff       	call   bd0 <cond_init>

    return ch;
     e9f:	83 c4 10             	add    $0x10,%esp
}
     ea2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ea5:	89 d8                	mov    %ebx,%eax
     ea7:	5b                   	pop    %ebx
     ea8:	5e                   	pop    %esi
     ea9:	5d                   	pop    %ebp
     eaa:	c3                   	ret
     eab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        free(ch);
     eb0:	83 ec 0c             	sub    $0xc,%esp
     eb3:	53                   	push   %ebx
     eb4:	e8 87 f7 ff ff       	call   640 <free>
        return 0;
     eb9:	83 c4 10             	add    $0x10,%esp
        return 0;
     ebc:	31 db                	xor    %ebx,%ebx
     ebe:	eb e2                	jmp    ea2 <channel_create+0x82>

00000ec0 <channel_send>:

int
channel_send(channel_t *ch, void *data)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	57                   	push   %edi
     ec4:	56                   	push   %esi
     ec5:	53                   	push   %ebx
     ec6:	83 ec 18             	sub    $0x18,%esp
     ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
     ecc:	8d 73 18             	lea    0x18(%ebx),%esi
     ecf:	8d bb a8 00 00 00    	lea    0xa8(%ebx),%edi
     ed5:	56                   	push   %esi
     ed6:	e8 35 fe ff ff       	call   d10 <mutex_lock>

    while (ch->count == ch->capacity && !ch->closed)
     edb:	8b 43 04             	mov    0x4(%ebx),%eax
     ede:	83 c4 10             	add    $0x10,%esp
     ee1:	39 43 08             	cmp    %eax,0x8(%ebx)
     ee4:	74 1f                	je     f05 <channel_send+0x45>
     ee6:	eb 38                	jmp    f20 <channel_send+0x60>
     ee8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     eef:	00 
        cond_wait(&ch->not_full, &ch->lock);
     ef0:	83 ec 08             	sub    $0x8,%esp
     ef3:	56                   	push   %esi
     ef4:	57                   	push   %edi
     ef5:	e8 e6 fc ff ff       	call   be0 <cond_wait>
    while (ch->count == ch->capacity && !ch->closed)
     efa:	8b 43 04             	mov    0x4(%ebx),%eax
     efd:	83 c4 10             	add    $0x10,%esp
     f00:	39 43 08             	cmp    %eax,0x8(%ebx)
     f03:	75 1b                	jne    f20 <channel_send+0x60>
     f05:	8b 43 14             	mov    0x14(%ebx),%eax
     f08:	85 c0                	test   %eax,%eax
     f0a:	74 e4                	je     ef0 <channel_send+0x30>

    if (ch->closed) {
        mutex_unlock(&ch->lock);
     f0c:	83 ec 0c             	sub    $0xc,%esp
        return -1;
     f0f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        mutex_unlock(&ch->lock);
     f14:	56                   	push   %esi
     f15:	e8 66 fe ff ff       	call   d80 <mutex_unlock>
        return -1;
     f1a:	83 c4 10             	add    $0x10,%esp
     f1d:	eb 3b                	jmp    f5a <channel_send+0x9a>
     f1f:	90                   	nop
    if (ch->closed) {
     f20:	8b 7b 14             	mov    0x14(%ebx),%edi
     f23:	85 ff                	test   %edi,%edi
     f25:	75 e5                	jne    f0c <channel_send+0x4c>
    }

    ch->buffer[ch->tail] = data;
     f27:	8b 53 10             	mov    0x10(%ebx),%edx
     f2a:	8b 03                	mov    (%ebx),%eax
    ch->tail = (ch->tail + 1) % ch->capacity;
    ch->count++;

    cond_signal(&ch->not_empty);
     f2c:	83 ec 0c             	sub    $0xc,%esp
    ch->buffer[ch->tail] = data;
     f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     f32:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    ch->tail = (ch->tail + 1) % ch->capacity;
     f35:	8b 43 10             	mov    0x10(%ebx),%eax
    ch->count++;
     f38:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    ch->tail = (ch->tail + 1) % ch->capacity;
     f3c:	83 c0 01             	add    $0x1,%eax
     f3f:	99                   	cltd
     f40:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_empty);
     f43:	83 c3 64             	add    $0x64,%ebx
    ch->tail = (ch->tail + 1) % ch->capacity;
     f46:	89 53 ac             	mov    %edx,-0x54(%ebx)
    cond_signal(&ch->not_empty);
     f49:	53                   	push   %ebx
     f4a:	e8 e1 fc ff ff       	call   c30 <cond_signal>
    mutex_unlock(&ch->lock);
     f4f:	89 34 24             	mov    %esi,(%esp)
     f52:	e8 29 fe ff ff       	call   d80 <mutex_unlock>
    return 0;
     f57:	83 c4 10             	add    $0x10,%esp
}
     f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f5d:	89 f8                	mov    %edi,%eax
     f5f:	5b                   	pop    %ebx
     f60:	5e                   	pop    %esi
     f61:	5f                   	pop    %edi
     f62:	5d                   	pop    %ebp
     f63:	c3                   	ret
     f64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f6b:	00 
     f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f70 <channel_recv>:

int
channel_recv(channel_t *ch, void **data)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	57                   	push   %edi
     f74:	56                   	push   %esi
     f75:	53                   	push   %ebx
     f76:	83 ec 18             	sub    $0x18,%esp
     f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
     f7c:	8d 73 18             	lea    0x18(%ebx),%esi
     f7f:	8d 7b 64             	lea    0x64(%ebx),%edi
     f82:	56                   	push   %esi
     f83:	e8 88 fd ff ff       	call   d10 <mutex_lock>

    while (ch->count == 0 && !ch->closed)
     f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
     f8b:	83 c4 10             	add    $0x10,%esp
     f8e:	85 c9                	test   %ecx,%ecx
     f90:	74 1a                	je     fac <channel_recv+0x3c>
     f92:	eb 3c                	jmp    fd0 <channel_recv+0x60>
     f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&ch->not_empty, &ch->lock);
     f98:	83 ec 08             	sub    $0x8,%esp
     f9b:	56                   	push   %esi
     f9c:	57                   	push   %edi
     f9d:	e8 3e fc ff ff       	call   be0 <cond_wait>
    while (ch->count == 0 && !ch->closed)
     fa2:	8b 53 08             	mov    0x8(%ebx),%edx
     fa5:	83 c4 10             	add    $0x10,%esp
     fa8:	85 d2                	test   %edx,%edx
     faa:	75 24                	jne    fd0 <channel_recv+0x60>
     fac:	8b 43 14             	mov    0x14(%ebx),%eax
     faf:	85 c0                	test   %eax,%eax
     fb1:	74 e5                	je     f98 <channel_recv+0x28>

    if (ch->count == 0 && ch->closed) {
        mutex_unlock(&ch->lock);
     fb3:	83 ec 0c             	sub    $0xc,%esp
     fb6:	56                   	push   %esi
     fb7:	e8 c4 fd ff ff       	call   d80 <mutex_unlock>
        return -1;
     fbc:	83 c4 10             	add    $0x10,%esp
     fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fc4:	eb 47                	jmp    100d <channel_recv+0x9d>
     fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fcd:	00 
     fce:	66 90                	xchg   %ax,%ax
    }

    *data = ch->buffer[ch->head];
     fd0:	8b 53 0c             	mov    0xc(%ebx),%edx
     fd3:	8b 03                	mov    (%ebx),%eax
    ch->head = (ch->head + 1) % ch->capacity;
    ch->count--;

    cond_signal(&ch->not_full);
     fd5:	83 ec 0c             	sub    $0xc,%esp
    *data = ch->buffer[ch->head];
     fd8:	8b 14 90             	mov    (%eax,%edx,4),%edx
     fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
     fde:	89 10                	mov    %edx,(%eax)
    ch->head = (ch->head + 1) % ch->capacity;
     fe0:	8b 43 0c             	mov    0xc(%ebx),%eax
    ch->count--;
     fe3:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    ch->head = (ch->head + 1) % ch->capacity;
     fe7:	83 c0 01             	add    $0x1,%eax
     fea:	99                   	cltd
     feb:	f7 7b 04             	idivl  0x4(%ebx)
    cond_signal(&ch->not_full);
     fee:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    ch->head = (ch->head + 1) % ch->capacity;
     ff4:	89 93 64 ff ff ff    	mov    %edx,-0x9c(%ebx)
    cond_signal(&ch->not_full);
     ffa:	53                   	push   %ebx
     ffb:	e8 30 fc ff ff       	call   c30 <cond_signal>
    mutex_unlock(&ch->lock);
    1000:	89 34 24             	mov    %esi,(%esp)
    1003:	e8 78 fd ff ff       	call   d80 <mutex_unlock>
    return 0;
    1008:	83 c4 10             	add    $0x10,%esp
    100b:	31 c0                	xor    %eax,%eax
}
    100d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1010:	5b                   	pop    %ebx
    1011:	5e                   	pop    %esi
    1012:	5f                   	pop    %edi
    1013:	5d                   	pop    %ebp
    1014:	c3                   	ret
    1015:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    101c:	00 
    101d:	8d 76 00             	lea    0x0(%esi),%esi

00001020 <channel_close>:

void
channel_close(channel_t *ch)
{
    1020:	55                   	push   %ebp
    1021:	89 e5                	mov    %esp,%ebp
    1023:	56                   	push   %esi
    1024:	53                   	push   %ebx
    1025:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&ch->lock);
    1028:	8d 73 18             	lea    0x18(%ebx),%esi
    102b:	83 ec 0c             	sub    $0xc,%esp
    102e:	56                   	push   %esi
    102f:	e8 dc fc ff ff       	call   d10 <mutex_lock>
    ch->closed = 1;
    cond_broadcast(&ch->not_empty);
    1034:	8d 43 64             	lea    0x64(%ebx),%eax
    ch->closed = 1;
    1037:	c7 43 14 01 00 00 00 	movl   $0x1,0x14(%ebx)
    cond_broadcast(&ch->not_full);
    103e:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
    cond_broadcast(&ch->not_empty);
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 54 fc ff ff       	call   ca0 <cond_broadcast>
    cond_broadcast(&ch->not_full);
    104c:	89 1c 24             	mov    %ebx,(%esp)
    104f:	e8 4c fc ff ff       	call   ca0 <cond_broadcast>
    mutex_unlock(&ch->lock);
    1054:	83 c4 10             	add    $0x10,%esp
    1057:	89 75 08             	mov    %esi,0x8(%ebp)
}
    105a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    105d:	5b                   	pop    %ebx
    105e:	5e                   	pop    %esi
    105f:	5d                   	pop    %ebp
    mutex_unlock(&ch->lock);
    1060:	e9 1b fd ff ff       	jmp    d80 <mutex_unlock>
    1065:	66 90                	xchg   %ax,%ax
    1067:	66 90                	xchg   %ax,%ax
    1069:	66 90                	xchg   %ax,%ax
    106b:	66 90                	xchg   %ax,%ax
    106d:	66 90                	xchg   %ax,%ax
    106f:	90                   	nop

00001070 <rwlock_init>:
#include "types.h"
#include "uthreads.h"

void
rwlock_init(rwlock_t *l)
{
    1070:	55                   	push   %ebp
    1071:	89 e5                	mov    %esp,%ebp
    1073:	53                   	push   %ebx
    1074:	83 ec 10             	sub    $0x10,%esp
    1077:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_init(&l->m);
    107a:	53                   	push   %ebx
    107b:	e8 70 fc ff ff       	call   cf0 <mutex_init>
    cond_init(&l->can_read);
    1080:	8d 43 4c             	lea    0x4c(%ebx),%eax
    1083:	89 04 24             	mov    %eax,(%esp)
    1086:	e8 45 fb ff ff       	call   bd0 <cond_init>
    cond_init(&l->can_write);
    108b:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1091:	89 04 24             	mov    %eax,(%esp)
    1094:	e8 37 fb ff ff       	call   bd0 <cond_init>
    l->readers = 0;
    l->writers_wait = 0;
    l->writer_active = 0;
}
    1099:	83 c4 10             	add    $0x10,%esp
    l->readers = 0;
    109c:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%ebx)
    10a3:	00 00 00 
    l->writers_wait = 0;
    10a6:	c7 83 d8 00 00 00 00 	movl   $0x0,0xd8(%ebx)
    10ad:	00 00 00 
    l->writer_active = 0;
    10b0:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    10b7:	00 00 00 
}
    10ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10bd:	c9                   	leave
    10be:	c3                   	ret
    10bf:	90                   	nop

000010c0 <reader_lock>:
//     mutex_unlock(&l->m);
// }

void
reader_lock(rwlock_t *l)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	56                   	push   %esi
    10c4:	53                   	push   %ebx
    10c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    10c8:	83 ec 0c             	sub    $0xc,%esp
    10cb:	53                   	push   %ebx
    10cc:	e8 3f fc ff ff       	call   d10 <mutex_lock>
    while (l->writer_active)
    10d1:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    10d7:	83 c4 10             	add    $0x10,%esp
    10da:	85 d2                	test   %edx,%edx
    10dc:	74 21                	je     10ff <reader_lock+0x3f>
    10de:	8d 73 4c             	lea    0x4c(%ebx),%esi
    10e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_read, &l->m);
    10e8:	83 ec 08             	sub    $0x8,%esp
    10eb:	53                   	push   %ebx
    10ec:	56                   	push   %esi
    10ed:	e8 ee fa ff ff       	call   be0 <cond_wait>
    while (l->writer_active)
    10f2:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
    10f8:	83 c4 10             	add    $0x10,%esp
    10fb:	85 c0                	test   %eax,%eax
    10fd:	75 e9                	jne    10e8 <reader_lock+0x28>
    l->readers++;
    10ff:	83 83 d4 00 00 00 01 	addl   $0x1,0xd4(%ebx)
    mutex_unlock(&l->m);
    1106:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1109:	8d 65 f8             	lea    -0x8(%ebp),%esp
    110c:	5b                   	pop    %ebx
    110d:	5e                   	pop    %esi
    110e:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    110f:	e9 6c fc ff ff       	jmp    d80 <mutex_unlock>
    1114:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    111b:	00 
    111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001120 <reader_unlock>:


void
reader_unlock(rwlock_t *l)
{
    1120:	55                   	push   %ebp
    1121:	89 e5                	mov    %esp,%ebp
    1123:	53                   	push   %ebx
    1124:	83 ec 10             	sub    $0x10,%esp
    1127:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    112a:	53                   	push   %ebx
    112b:	e8 e0 fb ff ff       	call   d10 <mutex_lock>
    l->readers--;
    1130:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    if (l->readers == 0 && l->writers_wait > 0)
    1136:	83 c4 10             	add    $0x10,%esp
    l->readers--;
    1139:	83 e8 01             	sub    $0x1,%eax
    113c:	89 83 d4 00 00 00    	mov    %eax,0xd4(%ebx)
    if (l->readers == 0 && l->writers_wait > 0)
    1142:	85 c0                	test   %eax,%eax
    1144:	75 0a                	jne    1150 <reader_unlock+0x30>
    1146:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    114c:	85 c0                	test   %eax,%eax
    114e:	7f 10                	jg     1160 <reader_unlock+0x40>
        cond_signal(&l->can_write);
    mutex_unlock(&l->m);
    1150:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1156:	c9                   	leave
    mutex_unlock(&l->m);
    1157:	e9 24 fc ff ff       	jmp    d80 <mutex_unlock>
    115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cond_signal(&l->can_write);
    1160:	83 ec 0c             	sub    $0xc,%esp
    1163:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1169:	50                   	push   %eax
    116a:	e8 c1 fa ff ff       	call   c30 <cond_signal>
    116f:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    1172:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1178:	c9                   	leave
    mutex_unlock(&l->m);
    1179:	e9 02 fc ff ff       	jmp    d80 <mutex_unlock>
    117e:	66 90                	xchg   %ax,%ax

00001180 <writer_lock>:

void
writer_lock(rwlock_t *l)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	56                   	push   %esi
    1184:	53                   	push   %ebx
    1185:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    l->writers_wait++;
    while (l->writer_active || l->readers > 0)
        cond_wait(&l->can_write, &l->m);
    1188:	8d b3 90 00 00 00    	lea    0x90(%ebx),%esi
    mutex_lock(&l->m);
    118e:	83 ec 0c             	sub    $0xc,%esp
    1191:	53                   	push   %ebx
    1192:	e8 79 fb ff ff       	call   d10 <mutex_lock>
    l->writers_wait++;
    1197:	83 83 d8 00 00 00 01 	addl   $0x1,0xd8(%ebx)
    while (l->writer_active || l->readers > 0)
    119e:	83 c4 10             	add    $0x10,%esp
    11a1:	eb 12                	jmp    11b5 <writer_lock+0x35>
    11a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        cond_wait(&l->can_write, &l->m);
    11a8:	83 ec 08             	sub    $0x8,%esp
    11ab:	53                   	push   %ebx
    11ac:	56                   	push   %esi
    11ad:	e8 2e fa ff ff       	call   be0 <cond_wait>
    11b2:	83 c4 10             	add    $0x10,%esp
    while (l->writer_active || l->readers > 0)
    11b5:	8b 93 dc 00 00 00    	mov    0xdc(%ebx),%edx
    11bb:	85 d2                	test   %edx,%edx
    11bd:	75 e9                	jne    11a8 <writer_lock+0x28>
    11bf:	8b 83 d4 00 00 00    	mov    0xd4(%ebx),%eax
    11c5:	85 c0                	test   %eax,%eax
    11c7:	7f df                	jg     11a8 <writer_lock+0x28>
    l->writers_wait--;
    11c9:	83 ab d8 00 00 00 01 	subl   $0x1,0xd8(%ebx)
    l->writer_active = 1;
    11d0:	c7 83 dc 00 00 00 01 	movl   $0x1,0xdc(%ebx)
    11d7:	00 00 00 
    mutex_unlock(&l->m);
    11da:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    11dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11e0:	5b                   	pop    %ebx
    11e1:	5e                   	pop    %esi
    11e2:	5d                   	pop    %ebp
    mutex_unlock(&l->m);
    11e3:	e9 98 fb ff ff       	jmp    d80 <mutex_unlock>
    11e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    11ef:	00 

000011f0 <writer_unlock>:

void
writer_unlock(rwlock_t *l)
{
    11f0:	55                   	push   %ebp
    11f1:	89 e5                	mov    %esp,%ebp
    11f3:	53                   	push   %ebx
    11f4:	83 ec 10             	sub    $0x10,%esp
    11f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mutex_lock(&l->m);
    11fa:	53                   	push   %ebx
    11fb:	e8 10 fb ff ff       	call   d10 <mutex_lock>
    l->writer_active = 0;
    if (l->writers_wait > 0)
    1200:	8b 83 d8 00 00 00    	mov    0xd8(%ebx),%eax
    1206:	83 c4 10             	add    $0x10,%esp
    l->writer_active = 0;
    1209:	c7 83 dc 00 00 00 00 	movl   $0x0,0xdc(%ebx)
    1210:	00 00 00 
    if (l->writers_wait > 0)
    1213:	85 c0                	test   %eax,%eax
    1215:	7e 21                	jle    1238 <writer_unlock+0x48>
        cond_signal(&l->can_write);
    1217:	83 ec 0c             	sub    $0xc,%esp
    121a:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
    1220:	50                   	push   %eax
    1221:	e8 0a fa ff ff       	call   c30 <cond_signal>
    1226:	83 c4 10             	add    $0x10,%esp
    else
        cond_broadcast(&l->can_read);
    mutex_unlock(&l->m);
    1229:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    122c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    122f:	c9                   	leave
    mutex_unlock(&l->m);
    1230:	e9 4b fb ff ff       	jmp    d80 <mutex_unlock>
    1235:	8d 76 00             	lea    0x0(%esi),%esi
        cond_broadcast(&l->can_read);
    1238:	83 ec 0c             	sub    $0xc,%esp
    123b:	8d 43 4c             	lea    0x4c(%ebx),%eax
    123e:	50                   	push   %eax
    123f:	e8 5c fa ff ff       	call   ca0 <cond_broadcast>
    1244:	83 c4 10             	add    $0x10,%esp
    mutex_unlock(&l->m);
    1247:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    124a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    124d:	c9                   	leave
    mutex_unlock(&l->m);
    124e:	e9 2d fb ff ff       	jmp    d80 <mutex_unlock>
