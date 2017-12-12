From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: task hung in aead_recvmsg
Date: Tue, 12 Dec 2017 17:46:46 +0100
Message-ID: <CACT4Y+bgQ02e2=A0HpsRQbC6RFRi8N+GvhYfmCg+EuAXHHafxA@mail.gmail.com>
References: <001a1140b8307b0439055ffc7872@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs@googlegroups.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
To: syzbot
        <bot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34097 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdLLQrI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 11:47:08 -0500
Received: by mail-pf0-f193.google.com with SMTP id a90so14623852pfk.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 08:47:08 -0800 (PST)
In-Reply-To: <001a1140b8307b0439055ffc7872@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 10, 2017 at 2:34 PM, syzbot
<bot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>
wrote:
> Hello,
>
> syzkaller hit the following crash on
> ad4dac17f9d563b9e34aab78a34293b10993e9b5
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
>
> Unfortunately, I don't have any reproducer for this bug yet.
>
>
> Use struct sctp_assoc_value instead
> INFO: task syz-executor6:7377 blocked for more than 120 seconds.
>       Not tainted 4.15.0-rc2-next-20171208+ #63
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor6   D24416  7377   3393 0x00000004
> Call Trace:
>  context_switch kernel/sched/core.c:2800 [inline]
>  __schedule+0x8eb/0x2060 kernel/sched/core.c:3376
>  schedule+0xf5/0x430 kernel/sched/core.c:3435
>  schedule_timeout+0x43a/0x560 kernel/time/timer.c:1776
>  do_wait_for_common kernel/sched/completion.c:91 [inline]
>  __wait_for_common kernel/sched/completion.c:112 [inline]
>  wait_for_common kernel/sched/completion.c:123 [inline]
>  wait_for_completion+0x44b/0x7b0 kernel/sched/completion.c:144
>  crypto_wait_req include/linux/crypto.h:496 [inline]
>  _aead_recvmsg crypto/algif_aead.c:308 [inline]
>  aead_recvmsg+0x1396/0x1bc0 crypto/algif_aead.c:329
>  aead_recvmsg_nokey+0x60/0x80 crypto/algif_aead.c:447
>  sock_recvmsg_nosec net/socket.c:809 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:816
>  ___sys_recvmsg+0x29b/0x630 net/socket.c:2185
>  __sys_recvmsg+0xe2/0x210 net/socket.c:2230
>  SYSC_recvmsg net/socket.c:2242 [inline]
>  SyS_recvmsg+0x2d/0x50 net/socket.c:2237
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a39
> RSP: 002b:00007f9dc7c93c58 EFLAGS: 00000212 ORIG_RAX: 000000000000002f
> RAX: ffffffffffffffda RBX: 00007f9dc7c94700 RCX: 0000000000452a39
> RDX: 0000000000000000 RSI: 0000000020539fc8 RDI: 0000000000000025
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000000
> R13: 0000000000a6f7ff R14: 00007f9dc7c949c0 R15: 0000000000000000
>
> Showing all locks held in the system:
> 2 locks held by khungtaskd/671:
>  #0:  (rcu_read_lock){....}, at: [<00000000d256784e>]
> check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
>  #0:  (rcu_read_lock){....}, at: [<00000000d256784e>] watchdog+0x1c5/0xd60
> kernel/hung_task.c:249
>  #1:  (tasklist_lock){.+.+}, at: [<00000000d84da0f3>]
> debug_show_all_locks+0xd3/0x400 kernel/locking/lockdep.c:4554
> 1 lock held by rsyslogd/2995:
>  #0:  (&f->f_pos_lock){+.+.}, at: [<0000000034bb33fc>]
> __fdget_pos+0x131/0x1a0 fs/file.c:765
> 2 locks held by getty/3116:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3117:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3118:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3119:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3120:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3121:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3122:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 1 lock held by syz-executor6/7377:
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>] lock_sock
> include/net/sock.h:1463 [inline]
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>]
> aead_recvmsg+0xb3/0x1bc0 crypto/algif_aead.c:327
> 1 lock held by syz-executor6/7391:
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>] lock_sock
> include/net/sock.h:1463 [inline]
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>]
> aead_recvmsg+0xb3/0x1bc0 crypto/algif_aead.c:327
>
> =============================================
>
> NMI backtrace for cpu 0
> CPU: 0 PID: 671 Comm: khungtaskd Not tainted 4.15.0-rc2-next-20171208+ #63
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  nmi_cpu_backtrace+0x1d2/0x210 lib/nmi_backtrace.c:103
>  nmi_trigger_cpumask_backtrace+0x122/0x180 lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_all_cpu_backtrace include/linux/nmi.h:138 [inline]
>  check_hung_task kernel/hung_task.c:132 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:190 [inline]
>  watchdog+0x90c/0xd60 kernel/hung_task.c:249
>  kthread+0x37a/0x440 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:524
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.15.0-rc2-next-20171208+ #63
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:777
> [inline]
> RIP: 0010:lock_pin_lock+0x2b7/0x370 kernel/locking/lockdep.c:4064
> RSP: 0018:ffff8801db307470 EFLAGS: 00000086
> RAX: dffffc0000000000 RBX: ffff8801d9f88300 RCX: ffffffff82501583
> RDX: 1ffffffff0c59759 RSI: ffff8801db32c918 RDI: 0000000000000082
> RBP: ffff8801db3074b8 R08: ffff8801db306f88 R09: ffff8801d9f88300
> R10: 000000000000000b R11: ffffed003b660df3 R12: ffff8801d9f88300
> R13: ffffed003b3f1170 R14: ffff8801db32c918 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8801db300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c446de3010 CR3: 00000001cc38e000 CR4: 00000000001406e0
> DR0: 0000000020000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  <IRQ>
>  rq_pin_lock kernel/sched/sched.h:932 [inline]
>  rq_lock_irqsave kernel/sched/sched.h:1751 [inline]
>  update_blocked_averages+0x195/0x1b60 kernel/sched/fair.c:7353
>  rebalance_domains+0x145/0xcc0 kernel/sched/fair.c:9122
>  run_rebalance_domains+0x381/0x780 kernel/sched/fair.c:9383
>  __do_softirq+0x29d/0xbb2 kernel/softirq.c:285
>  invoke_softirq kernel/softirq.c:365 [inline]
>  irq_exit+0x1d3/0x210 kernel/softirq.c:405
>  scheduler_ipi+0x32a/0x830 kernel/sched/core.c:1804
>  smp_reschedule_interrupt+0xe6/0x670 arch/x86/kernel/smp.c:277
>  reschedule_interrupt+0xa9/0xb0 arch/x86/entry/entry_64.S:944
>  </IRQ>
> RIP: 0010:native_safe_halt+0x6/0x10 arch/x86/include/asm/irqflags.h:54
> RSP: 0018:ffff8801d9f97da8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff02
> RAX: dffffc0000000000 RBX: 1ffff1003b3f2fb8 RCX: 0000000000000000
> RDX: 1ffffffff0c5975c RSI: 0000000000000001 RDI: ffffffff862cbae0
> RBP: ffff8801d9f97da8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff8801d9f97e60 R14: ffffffff869efaa0 R15: 0000000000000000
>  arch_safe_halt arch/x86/include/asm/paravirt.h:93 [inline]
>  default_idle+0xbf/0x430 arch/x86/kernel/process.c:355
>  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:346
>  default_idle_call+0x36/0x90 kernel/sched/idle.c:98
>  cpuidle_idle_call kernel/sched/idle.c:156 [inline]
>  do_idle+0x24a/0x3b0 kernel/sched/idle.c:246
>  cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:351
>  start_secondary+0x330/0x460 arch/x86/kernel/smpboot.c:277
>  secondary_startup_64+0xa5/0xb0 arch/x86/kernel/head_64.S:237
> Code: ff df c7 83 84 08 00 00 00 00 00 00 48 89 fa 48 c1 ea 03 80 3c 02 00
> 0f 85 91 00 00 00 48 83 3d 37 78 d7 04 00 74 45 48 8b 7d c0 <57> 9d 0f 1f 44
> 00 00 8b 45 cc 48 83 c4 20 5b 41 5c 41 5d 41 5e

+crypto maintainers
this is crypto, not sched


> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> Please credit me with: Reported-by: syzbot <syzkaller@googlegroups.com>
>
> syzbot will keep track of this bug report.
> Once a fix for this bug is merged into any tree, reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/001a1140b8307b0439055ffc7872%40google.com.
> For more options, visit https://groups.google.com/d/optout.
