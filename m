From: syzbot <syzbot+264bca3a6e8d645550d3@syzkaller.appspotmail.com>
Subject: KASAN: slab-out-of-bounds Write in vmac_final
Date: Sat, 16 Jun 2018 03:27:02 -0700
Message-ID: <000000000000f7b199056ebfc5ef@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8efcf34a2639 Merge tag 'armsoc-late' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b9503f800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3de185e943e1d12f
dashboard link: https://syzkaller.appspot.com/bug?extid=264bca3a6e8d645550d3
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=158bc21f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12506eaf800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+264bca3a6e8d645550d3@syzkaller.appspotmail.com

==================================================================
kasan: CONFIG_KASAN_INLINE enabled
BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:330 [inline]
BUG: KASAN: slab-out-of-bounds in vmac_final+0x161/0x26a0 crypto/vmac.c:611
Write of size 18446744073709551516 at addr ffff8801ac760f0c by task  
syz-executor345/4580
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN

CPU: 1 PID: 4580 Comm: syz-executor345 Not tainted 4.17.0+ #98
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
  memset+0x23/0x40 mm/kasan/kasan.c:285
  memset include/linux/string.h:330 [inline]
  vmac_final+0x161/0x26a0 crypto/vmac.c:611
  crypto_shash_final+0x104/0x260 crypto/shash.c:152
  shash_async_final+0x35/0x40 crypto/shash.c:252
  crypto_ahash_op+0xcf/0x180 crypto/ahash.c:362
  crypto_ahash_final+0x57/0x70 crypto/ahash.c:367
  hash_sendmsg+0x750/0xac0 crypto/algif_hash.c:126
  sock_sendmsg_nosec net/socket.c:645 [inline]
  sock_sendmsg+0xd5/0x120 net/socket.c:655
  ___sys_sendmsg+0x805/0x940 net/socket.c:2161
CPU: 0 PID: 0 Comm:  Not tainted 4.17.0+ #98
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:188 [inline]
RIP: 0010:get_running_cputimer include/linux/sched/cputime.h:85 [inline]
RIP: 0010:account_group_system_time include/linux/sched/cputime.h:149  
[inline]
RIP: 0010:account_system_index_time+0xea/0x5b0 kernel/sched/cputime.c:168
Code:
63
04 00
00
  __sys_sendmsg+0x115/0x270 net/socket.c:2199
48 8b
83
b8
06
  __do_sys_sendmsg net/socket.c:2208 [inline]
  __se_sys_sendmsg net/socket.c:2206 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2206
00
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
00
48
ba
00
00
00 00
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
00
RIP: 0033:0x445e69
fc
Code:
ff df
e8
48
5c
8d
e7
b8
ff
38
ff
01
48
00
83
00
c4
48 8d
18
88
c3
20
0f
01
1f
00
80 00
00
00
48
00
89
00
fe
48
48
89
c1
f8
ee
48
03
89
<0f>
f7
b6
48
14
89
16
d6
48
48
89
89
fe
ca
83
4d
e6
89
07
c2
40
4d
38
89
f2
c8
7f
4c
08
8b
84
4c
d2
24
0f
08
85
0f
f6
05
03
<48>
00
3d
01
RSP: 0018:ffff8801dae07980 EFLAGS: 00010006
f0
ff
RAX: 0000000000000000 RBX: ffff8801ad1a4500 RCX: 0000000000000120
ff
RDX: dffffc0000000000 RSI: 0000000000000027 RDI: 0000000000000138
0f
RBP: ffff8801dae07a68 R08: ffff8801ad1a4500 R09: 0000000000000000
83
R10: ffffed0043fff001 R11: ffff88021fff8017 R12: ffff8801dae07a40
eb
R13: ffff8801ad1a4500 R14: 00000000000f4240 R15: 0000000000000002
51
FS:  00007fd7e78fb700(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
00
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
00
CR2: 00007fd7e78b8e78 CR3: 00000001ae829000 CR4: 00000000001406f0
c3
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
66
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
2e
Call Trace:
0f
  <IRQ>
1f
84
00
00
00
00
  account_system_time+0x7f/0xb0 kernel/sched/cputime.c:199
  account_process_tick+0x76/0x240 kernel/sched/cputime.c:498
RSP: 002b:00007fd7e78d9db8 EFLAGS: 00000246
  ORIG_RAX: 000000000000002e
  update_process_times+0x21/0x70 kernel/time/timer.c:1634
RAX: ffffffffffffffda RBX: 00000000006dac5c RCX: 0000000000445e69
  tick_sched_handle+0x9f/0x180 kernel/time/tick-sched.c:164
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 00000000000003ff
  tick_sched_timer+0x45/0x130 kernel/time/tick-sched.c:1274
RBP: 00000000006dac58 R08: 0000000000000000 R09: 0000000000000000
  __run_hrtimer kernel/time/hrtimer.c:1398 [inline]
  __hrtimer_run_queues+0x3e3/0x10a0 kernel/time/hrtimer.c:1460
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffde323e10f R14: 00007fd7e78da9c0 R15: 000000000000000b

Allocated by task 4557:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc mm/slab.c:3718 [inline]
  __kmalloc+0x14e/0x760 mm/slab.c:3727
  kmalloc include/linux/slab.h:518 [inline]
  kzalloc include/linux/slab.h:706 [inline]
  crypto_create_tfm+0x87/0x310 crypto/api.c:464
  crypto_init_shash_ops_async+0x5d/0x3e4 crypto/shash.c:357
  crypto_ahash_init_tfm+0x357/0x430 crypto/ahash.c:458
  crypto_create_tfm+0xe9/0x310 crypto/api.c:471
  crypto_alloc_tfm+0x1b5/0x2d0 crypto/api.c:543
  crypto_alloc_ahash+0x2c/0x40 crypto/ahash.c:539
  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
  hash_bind+0x25/0x30 crypto/algif_hash.c:408
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
  smp_apic_timer_interrupt+0x15d/0x710 arch/x86/kernel/apic/apic.c:1050
  alg_bind+0x2be/0x560 crypto/af_alg.c:183
  __sys_bind+0x331/0x440 net/socket.c:1528
  __do_sys_bind net/socket.c:1539 [inline]
  __se_sys_bind net/socket.c:1537 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1537
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
Freed by task 0:
  </IRQ>
(stack is not available)
Modules linked in:

The buggy address belongs to the object at ffff8801ac760d00
  which belongs to the cache kmalloc-512 of size 512
Dumping ftrace buffer:
The buggy address is located 12 bytes to the right of
  512-byte region [ffff8801ac760d00, ffff8801ac760f00)
    (ftrace buffer empty)
The buggy address belongs to the page:
---[ end trace d7db9a753b3ac637 ]---
page:ffffea0006b1d800 count:1 mapcount:0 mapping:ffff8801da800940 index:0x0
RIP: 0010:__read_once_size include/linux/compiler.h:188 [inline]
RIP: 0010:get_running_cputimer include/linux/sched/cputime.h:85 [inline]
RIP: 0010:account_group_system_time include/linux/sched/cputime.h:149  
[inline]
RIP: 0010:account_system_index_time+0xea/0x5b0 kernel/sched/cputime.c:168
Code:
flags: 0x2fffc0000000100(slab)
63
raw: 02fffc0000000100 ffffea000762d788 ffffea0007626dc8 ffff8801da800940
04
raw: 0000000000000000 ffff8801ac760080 0000000100000006 0000000000000000
00
page dumped because: kasan: bad access detected
00

48
Memory state around the buggy address:
8b
  ffff8801ac760e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
83
  ffff8801ac760e80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
b8
> ffff8801ac760f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
06
                       ^
00
  ffff8801ac760f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
00
  ffff8801ac761000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
48
==================================================================
ba
BUG: unable to handle kernel
00
NULL pointer dereference
00 00
  at 0000000000000000
00
PGD 1ae22a067
00
P4D 1ae22a067
fc
PUD 1adcde067
ff
PMD 0
df
48
Oops: 0010 [#2] SMP KASAN
8d
CPU: 1 PID: 4580 Comm: syz-executor345 Tainted: G    B D           4.17.0+  
#98
b8
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
38
RIP: 0010:          (null)
01
Code:
00
Bad RIP value.
00
RSP: 0018:ffff8801daf07b58 EFLAGS: 00010006
48
8d
RAX: 0000000000000000 RBX: ffff8801ad297ce0 RCX: ffffffff8168de27
88
RDX: 0000000000010000 RSI: ffffffff8168d644 RDI: ffff8801ad297ce0
20
RBP: ffff8801daf07de0 R08: ffff8801ae6ae300 R09: ffffed003b5e4b90
01
R10: ffffed003b5e4b90 R11: ffff8801daf25c83 R12: ffff8801daf25d00
00
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
00
FS:  00007fd7e78da700(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
48
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
89
CR2: ffffffffffffffd6 CR3: 00000001ae829000 CR4: 00000000001406e0
fe
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
48
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
c1 ee
Call Trace:
03
  <IRQ>
<0f>
b6
14
16
48
89
fe
83
e6
07
40
  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
38
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
  smp_apic_timer_interrupt+0x15d/0x710 arch/x86/kernel/apic/apic.c:1050
f2
7f
08
84
d2
0f
85
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
f6
  </IRQ>
03
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783  
[inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160  
[inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xa1/0xc0  
kernel/locking/spinlock.c:184
00
Code:
68
RSP: 0018:ffff8801dae07980 EFLAGS: 00010006
a8
f1
RAX: 0000000000000000 RBX: ffff8801ad1a4500 RCX: 0000000000000120
88
RDX: dffffc0000000000 RSI: 0000000000000027 RDI: 0000000000000138
48
RBP: ffff8801dae07a68 R08: ffff8801ad1a4500 R09: 0000000000000000
b8
R10: ffffed0043fff001 R11: ffff88021fff8017 R12: ffff8801dae07a40
00
R13: ffff8801ad1a4500 R14: 00000000000f4240 R15: 0000000000000002
00
FS:  00007fd7e78fb700(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
00
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
00
CR2: 00007fd7e78b8e78 CR3: 00000001ae829000 CR4: 00000000001406f0
00
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
fc
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
ff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
