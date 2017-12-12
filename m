From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: task hung in lock_sock_nested
Date: Tue, 12 Dec 2017 17:47:34 +0100
Message-ID: <CACT4Y+ZAYckRqi4v+XTdn-eq6LdrxoXsCDvCycthsn44kLJNzQ@mail.gmail.com>
References: <f403043d11cc35affd055ffc8374@google.com>
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
        <bot+b09be8359497f2f986abf4f2db0e26de6ab1a00e@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42364 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdLLQrz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 11:47:55 -0500
Received: by mail-pf0-f193.google.com with SMTP id d23so14618172pfe.9
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 08:47:55 -0800 (PST)
In-Reply-To: <f403043d11cc35affd055ffc8374@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 10, 2017 at 2:37 PM, syzbot
<bot+b09be8359497f2f986abf4f2db0e26de6ab1a00e@syzkaller.appspotmail.com>
wrote:
> Hello,
>
> syzkaller hit the following crash on
> 51e18a453f5f59a40c721d4aeab082b4e2e9fac6
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
>
> Unfortunately, I don't have any reproducer for this bug yet.
>
>
> RDS: rds_bind could not find a transport for 172.20.1.187, load rds_tcp or
> rds_rdma?
> INFO: task syz-executor2:19495 blocked for more than 120 seconds.
>       Not tainted 4.15.0-rc2+ #148
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor2   D25200 19495   3406 0x00000004
> Call Trace:
>  context_switch kernel/sched/core.c:2799 [inline]
>  __schedule+0x8eb/0x2060 kernel/sched/core.c:3375
>  schedule+0xf5/0x430 kernel/sched/core.c:3434
>  __lock_sock+0x1dc/0x2f0 net/core/sock.c:2240
>  lock_sock_nested+0xf3/0x110 net/core/sock.c:2764
>  lock_sock include/net/sock.h:1461 [inline]
>  af_alg_sendmsg+0x349/0x1080 crypto/af_alg.c:858
>  aead_sendmsg+0x103/0x150 crypto/algif_aead.c:76
>  sock_sendmsg_nosec net/socket.c:636 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:646
>  ___sys_sendmsg+0x75b/0x8a0 net/socket.c:2026
>  __sys_sendmsg+0xe5/0x210 net/socket.c:2060
>  SYSC_sendmsg net/socket.c:2071 [inline]
>  SyS_sendmsg+0x2d/0x50 net/socket.c:2067
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a39
> RSP: 002b:00007f63f58cfc58 EFLAGS: 00000212 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000758020 RCX: 0000000000452a39
> RDX: 0000000000000040 RSI: 0000000020630000 RDI: 0000000000000015
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006ee0b8
> R13: 00000000ffffffff R14: 00007f63f58d06d4 R15: 0000000000000000
>
> Showing all locks held in the system:
> 2 locks held by khungtaskd/663:
>  #0:  (rcu_read_lock){....}, at: [<00000000b2540f7c>]
> check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
>  #0:  (rcu_read_lock){....}, at: [<00000000b2540f7c>] watchdog+0x1c5/0xd60
> kernel/hung_task.c:249
>  #1:  (tasklist_lock){.+.+}, at: [<00000000b425f323>]
> debug_show_all_locks+0xd3/0x400 kernel/locking/lockdep.c:4554
> 1 lock held by rsyslogd/3008:
>  #0:  (&f->f_pos_lock){+.+.}, at: [<00000000d620dede>]
> __fdget_pos+0x131/0x1a0 fs/file.c:770
> 2 locks held by getty/3130:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3131:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3132:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3133:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3134:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3135:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3136:
>  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 1 lock held by syz-executor2/19506:
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<00000000bb9361fc>] lock_sock
> include/net/sock.h:1461 [inline]
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<00000000bb9361fc>]
> aead_recvmsg+0xb3/0x1bc0 crypto/algif_aead.c:327
>
> =============================================
>
> NMI backtrace for cpu 1
> CPU: 1 PID: 663 Comm: khungtaskd Not tainted 4.15.0-rc2+ #148
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
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:441
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.15.0-rc2+ #148
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:atomic_inc arch/x86/include/asm/atomic.h:92 [inline]
> RIP: 0010:__lock_acquire+0x1d7/0x47f0 kernel/locking/lockdep.c:3391
> RSP: 0018:ffff8801db406fe0 EFLAGS: 00000006
> RAX: ffffffff86faabf0 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 1ffff1003b684b54 RSI: 0000000000000000 RDI: ffff8801db425aa0
> RBP: ffff8801db407368 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: ffffffff8748bd20 R12: ffffffff85e2f380
> R13: 0000000000000000 R14: 0000000000000001 R15: ffff8801db425a98
> FS:  0000000000000000(0000) GS:ffff8801db400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe02dc12000 CR3: 00000001d7695000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  lock_acquire+0x1d5/0x580 kernel/locking/lockdep.c:4004
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x96/0xc0 kernel/locking/spinlock.c:159
>  rq_lock_irqsave kernel/sched/sched.h:1750 [inline]
>  update_blocked_averages+0x124/0x1b60 kernel/sched/fair.c:7353
>  rebalance_domains+0x145/0xcc0 kernel/sched/fair.c:9122
>  run_rebalance_domains+0x381/0x780 kernel/sched/fair.c:9383
>  __do_softirq+0x29d/0xbb2 kernel/softirq.c:285
>  invoke_softirq kernel/softirq.c:365 [inline]
>  irq_exit+0x1d3/0x210 kernel/softirq.c:405
>  scheduler_ipi+0x32a/0x830 kernel/sched/core.c:1803
>  smp_reschedule_interrupt+0xe6/0x670 arch/x86/kernel/smp.c:277
>  reschedule_interrupt+0x9d/0xb0 arch/x86/entry/entry_64.S:819
>  </IRQ>
> RIP: 0010:native_safe_halt+0x6/0x10 arch/x86/include/asm/irqflags.h:54
> RSP: 0018:ffffffff85e07d08 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff02
> RAX: dffffc0000000000 RBX: 1ffffffff0bc0fa4 RCX: 0000000000000000
> RDX: 1ffffffff0bd9734 RSI: 0000000000000001 RDI: ffffffff85ecb9a0
> RBP: ffffffff85e07d08 R08: ffffffff85beaae0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffffff85e07dc0 R14: ffffffff865eb5e0 R15: 0000000000000000
>  arch_safe_halt arch/x86/include/asm/paravirt.h:93 [inline]
>  default_idle+0xbf/0x460 arch/x86/kernel/process.c:348
>  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:339
>  default_idle_call+0x36/0x90 kernel/sched/idle.c:98
>  cpuidle_idle_call kernel/sched/idle.c:156 [inline]
>  do_idle+0x24a/0x3b0 kernel/sched/idle.c:246
>  cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:351
>  rest_init+0xed/0xf0 init/main.c:435
>  start_kernel+0x729/0x74f init/main.c:710
>  x86_64_start_reservations+0x2a/0x2c arch/x86/kernel/head64.c:378
>  x86_64_start_kernel+0x77/0x7a arch/x86/kernel/head64.c:359
>  secondary_startup_64+0xa5/0xb0 arch/x86/kernel/head_64.S:237
> Code: 48 85 c0 44 8b 95 28 fd ff ff 8b 8d 20 fd ff ff 44 8b 8d 18 fd ff ff
> 4c 8b 9d 10 fd ff ff 0f 84 26 0b 00 00 f0 ff 80 38 01 00 00 <49> 8d b4 24 80
> 08 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 b5

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
> https://groups.google.com/d/msgid/syzkaller-bugs/f403043d11cc35affd055ffc8374%40google.com.
> For more options, visit https://groups.google.com/d/optout.
