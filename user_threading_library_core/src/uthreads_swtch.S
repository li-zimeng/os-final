.text
.globl thread_switch
thread_switch:
  movl 4(%esp), %eax
  movl 8(%esp), %edx
  pushl %ebp
  pushl %ebx
  pushl %esi
  pushl %edi
  movl %esp, 12(%eax)
  movl 12(%edx), %esp
  popl %edi
  popl %esi
  popl %ebx
  popl %ebp
  ret
