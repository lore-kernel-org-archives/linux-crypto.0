From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: INFO: task hung in exit_aio
Date: Sun, 8 Apr 2018 15:51:09 -0700
Message-ID: <20180408225109.GG685@sol.localdomain>
References: <94eb2c03c9bcf07754055ffc74d8@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        linux-crypto@vger.kernel.org
To: syzbot
        <bot+9989fce6df2040ae9a91d49373891afd5612fc3f@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94eb2c03c9bcf07754055ffc74d8@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[+Cc linux-crypto]

On Sun, Dec 10, 2017 at 05:33:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 82bcf1def3b5f1251177ad47c44f7e17af039b4b
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> INFO: task syzkaller265413:3189 blocked for more than 120 seconds.
>       Not tainted 4.15.0-rc2-mm1+ #39
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syzkaller265413 D24320  3189   3150 0x80000000
> Call Trace:
>  context_switch kernel/sched/core.c:2800 [inline]
>  __schedule+0x8eb/0x2060 kernel/sched/core.c:3376
>  schedule+0xf5/0x430 kernel/sched/core.c:3435
>  schedule_timeout+0x43a/0x560 kernel/time/timer.c:1776
>  do_wait_for_common kernel/sched/completion.c:91 [inline]
>  __wait_for_common kernel/sched/completion.c:112 [inline]
>  wait_for_common kernel/sched/completion.c:123 [inline]
>  wait_for_completion+0x44b/0x7b0 kernel/sched/completion.c:144
>  exit_aio+0x47f/0x530 fs/aio.c:903
>  __mmput kernel/fork.c:968 [inline]
>  mmput+0x1b1/0x6c0 kernel/fork.c:992
>  exit_mm kernel/exit.c:544 [inline]
>  do_exit+0x90a/0x1ae0 kernel/exit.c:856
>  do_group_exit+0x149/0x400 kernel/exit.c:972
>  SYSC_exit_group kernel/exit.c:983 [inline]
>  SyS_exit_group+0x1d/0x20 kernel/exit.c:981
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x440a99
> RSP: 002b:00007ffc5abebf68 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: ffffffffffffffff RCX: 0000000000440a99
> RDX: 0000000000440a99 RSI: 0000000000000058 RDI: 0000000000000000
> RBP: 000000000001cbc8 R08: 000000005abec108 R09: 0000000000401fd0
> R10: 000000005abec108 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000000000401fd0 R14: 0000000000000000 R15: 0000000000000000
> 
> Showing all locks held in the system:
> 2 locks held by khungtaskd/673:
>  #0:  (rcu_read_lock){....}, at: [<00000000a9ed5249>]
> check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
>  #0:  (rcu_read_lock){....}, at: [<00000000a9ed5249>] watchdog+0x1c5/0xd60
> kernel/hung_task.c:249
>  #1:  (tasklist_lock){.+.+}, at: [<0000000036eecee2>]
> debug_show_all_locks+0xd3/0x400 kernel/locking/lockdep.c:4554
> 2 locks held by getty/3117:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3118:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3119:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3120:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3121:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3122:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 2 locks held by getty/3123:
>  #0:  (&tty->ldisc_sem){++++}, at: [<000000008d3f9495>]
> ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
>  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000fafb010f>]
> n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 PID: 673 Comm: khungtaskd Not tainted 4.15.0-rc2-mm1+ #39
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
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0x6/0x10
> arch/x86/include/asm/irqflags.h:54
> 
> 
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> Please credit me with: Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> syzbot will keep track of this bug report.
> Once a fix for this bug is merged into any tree, reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report

Still happening occasionally, but the reproducer is using AF_ALG with the
"rfc4309(pcrypt(pcrypt(rfc4106(gcm(aes)))))" algorithm which means it's very
likely a duplicate of the recursive pcrypt bug, main thread here:
https://groups.google.com/d/msg/syzkaller-bugs/1_CXUd3gBcg/BvsRLH0lAgAJ

#syz dup: INFO: task hung in aead_recvmsg

- Eric
