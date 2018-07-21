From: syzbot
        <syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>
Subject: Re: INFO: task hung in aead_recvmsg
Date: Sat, 21 Jul 2018 05:37:02 -0700
Message-ID: <0000000000004e5aa5057181ab72@google.com>
References: <001a1140b8307b0439055ffc7872@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, dvyukov@google.com, ebiggers3@gmail.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a1140b8307b0439055ffc7872@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    99d20a461c43 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1593e1c2400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acf770f568ef945b
dashboard link:  
https://syzkaller.appspot.com/bug?extid=56c7151cad94eec37c521f0e47d2eee53f9361c4
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=174a932c400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10cc732c400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by:  
syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com

INFO: task syz-executor592:4465 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24544  4465   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000019
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4466 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24448  4466   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000013
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4467 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24240  4467   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000016
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4468 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24240  4468   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000019
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4469 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24592  4469   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000010
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4470 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24592  4470   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000013
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4471 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24032  4471   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000016
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor592:4472 blocked for more than 140 seconds.
       Not tainted 4.18.0-rc5+ #132
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor592 D24480  4472   4464 0x00000000
Call Trace:
  context_switch kernel/sched/core.c:2853 [inline]
  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
  schedule+0xfb/0x450 kernel/sched/core.c:3545
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1777
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x430/0x8d0 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:512 [inline]
  _aead_recvmsg crypto/algif_aead.c:313 [inline]
  aead_recvmsg+0x1544/0x1bb0 crypto/algif_aead.c:334
  sock_recvmsg_nosec+0x8c/0xb0 net/socket.c:814
  ___sys_recvmsg+0x2b6/0x680 net/socket.c:2287
  __sys_recvmmsg+0x301/0xba0 net/socket.c:2399
  do_sys_recvmmsg+0x181/0x1a0 net/socket.c:2475
  __do_sys_recvmmsg net/socket.c:2493 [inline]
  __se_sys_recvmmsg net/socket.c:2489 [inline]
  __x64_sys_recvmmsg+0xbe/0x150 net/socket.c:2489
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4407b9
Code: Bad RIP value.
RSP: 002b:00007ffe6735bf58 EFLAGS: 00000207 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00000000004407b9
RDX: 0000000000000002 RSI: 0000000020003340 RDI: 0000000000000016
RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401c40
R13: 0000000000401cd0 R14: 0000000000000000 R15: 0000000000000000
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 PID: 900 Comm: khungtaskd Not tainted 4.18.0-rc5+ #132
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.5+0x19/0xce lib/nmi_backtrace.c:103
  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:138 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:196 [inline]
  watchdog+0x9c4/0xf80 kernel/hung_task.c:252
  kthread+0x345/0x410 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0x6/0x10  
arch/x86/include/asm/irqflags.h:54
