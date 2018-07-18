From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: task hung in tls_push_record
Date: Wed, 18 Jul 2018 13:52:02 +0200
Message-ID: <CACT4Y+ams-zr7H-DYFJNy2sg09uMsMhrueu0MGnngAFLPmAgnQ@mail.gmail.com>
References: <00000000000042f064056b8d004d@google.com> <000000000000dde753056c9995b3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: aviadye@mellanox.com, borisp@mellanox.com, davejwatson@fb.com,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: syzbot <syzbot+4006516aae0b06e7050f@syzkaller.appspotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Jaegeuk Kim <jaegeuk@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000dde753056c9995b3@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, May 20, 2018 at 4:03 AM, syzbot
<syzbot+4006516aae0b06e7050f@syzkaller.appspotmail.com> wrote:
> syzbot has found a reproducer for the following crash on:
>
> HEAD commit:    eb38401c779d net: stmmac: Populate missing callbacks in HW..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16d0820f800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b632d8e2c2ab2c1
> dashboard link: https://syzkaller.appspot.com/bug?extid=4006516aae0b06e7050f
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=10f6927b800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b7a20f800000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+4006516aae0b06e7050f@syzkaller.appspotmail.com

Still happens.
Perhaps this is crypto-related, not net-related? That's why net
maintainers are not looking at this? +crypto maintainers


> INFO: task syz-executor793:4489 blocked for more than 120 seconds.
>       Not tainted 4.17.0-rc4+ #52
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor793 D23464  4489   4486 0x00000000
> Call Trace:
>  context_switch kernel/sched/core.c:2848 [inline]
>  __schedule+0x801/0x1e30 kernel/sched/core.c:3490
>  schedule+0xef/0x430 kernel/sched/core.c:3549
>  schedule_timeout+0x1b5/0x240 kernel/time/timer.c:1777
>  do_wait_for_common kernel/sched/completion.c:83 [inline]
>  __wait_for_common kernel/sched/completion.c:104 [inline]
>  wait_for_common kernel/sched/completion.c:115 [inline]
>  wait_for_completion+0x3e7/0x870 kernel/sched/completion.c:136
>  crypto_wait_req include/linux/crypto.h:512 [inline]
>  tls_do_encryption net/tls/tls_sw.c:217 [inline]
>  tls_push_record+0xedc/0x13e0 net/tls/tls_sw.c:248
>  tls_sw_sendmsg+0x8d7/0x12b0 net/tls/tls_sw.c:440
>  inet_sendmsg+0x19f/0x690 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:629 [inline]
>  sock_sendmsg+0xd5/0x120 net/socket.c:639
>  __sys_sendto+0x3d7/0x670 net/socket.c:1789
>  __do_sys_sendto net/socket.c:1801 [inline]
>  __se_sys_sendto net/socket.c:1797 [inline]
>  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1797
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4457d9
> RSP: 002b:00007fa388d06da8 EFLAGS: 00000216 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00000000006dac24 RCX: 00000000004457d9
> RDX: 00000000fffffdef RSI: 00000000200005c0 RDI: 0000000000000022
> RBP: 00000000006dac20 R08: 0000000020000000 R09: 000000000000001c
> R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000000
> R13: 00007ffd5148ecaf R14: 00007fa388d079c0 R15: 0000000000000001
>
> Showing all locks held in the system:
> 2 locks held by khungtaskd/892:
>  #0: 000000009dfaae0c (rcu_read_lock){....}, at:
> check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
>  #0: 000000009dfaae0c (rcu_read_lock){....}, at: watchdog+0x1ff/0xf60
> kernel/hung_task.c:249
>  #1: 0000000058f79a8d (tasklist_lock){.+.+}, at:
> debug_show_all_locks+0xde/0x34a kernel/locking/lockdep.c:4470
> 1 lock held by rsyslogd/4370:
>  #0: 0000000059c3c7ae (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1a9/0x1e0
> fs/file.c:766
> 2 locks held by getty/4460:
>  #0: 00000000e25a52c3 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 000000002caea50f (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4461:
>  #0: 00000000d38c9806 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 00000000eaffe99d (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4462:
>  #0: 00000000cec6abe7 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 0000000000afd91c (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4463:
>  #0: 000000003456fca5 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 0000000038a65d91 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4464:
>  #0: 0000000001e783b1 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 000000003ecd2e34 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4465:
>  #0: 000000007ef8b451 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 000000006996c3ed (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 2 locks held by getty/4466:
>  #0: 00000000d15d9a92 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x37/0x40
> drivers/tty/tty_ldsem.c:365
>  #1: 00000000ee44bcf4 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x321/0x1cc0 drivers/tty/n_tty.c:2131
> 1 lock held by syz-executor793/4489:
>  #0: 0000000008c84b0d (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 0000000008c84b0d (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4494:
>  #0: 00000000f2de7555 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000f2de7555 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4499:
>  #0: 0000000058a54751 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 0000000058a54751 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4504:
>  #0: 0000000045694cb9 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 0000000045694cb9 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4509:
>  #0: 00000000b663e61f (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000b663e61f (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4514:
>  #0: 00000000603baf06 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000603baf06 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4519:
>  #0: 00000000344afb7e (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000344afb7e (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4524:
>  #0: 000000004aa3e1ce (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 000000004aa3e1ce (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4529:
>  #0: 00000000b6c4b2ea (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000b6c4b2ea (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4534:
>  #0: 000000005bae881e (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 000000005bae881e (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4539:
>  #0: 000000004b04f235 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 000000004b04f235 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4544:
>  #0: 00000000b5888be7 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000b5888be7 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4549:
>  #0: 00000000e902c819 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000e902c819 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4554:
>  #0: 000000009cd1d95e (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 000000009cd1d95e (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4559:
>  #0: 000000001f3edf17 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 000000001f3edf17 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
> 1 lock held by syz-executor793/4563:
>  #0: 00000000802085f8 (sk_lock-AF_INET6){+.+.}, at: lock_sock
> include/net/sock.h:1474 [inline]
>  #0: 00000000802085f8 (sk_lock-AF_INET6){+.+.}, at:
> tls_sw_sendmsg+0x1b9/0x12b0 net/tls/tls_sw.c:384
>
> =============================================
>
> NMI backtrace for cpu 0
> CPU: 0 PID: 892 Comm: khungtaskd Not tainted 4.17.0-rc4+ #52
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
>  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
>  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_all_cpu_backtrace include/linux/nmi.h:138 [inline]
>  check_hung_task kernel/hung_task.c:132 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:190 [inline]
>  watchdog+0xc10/0xf60 kernel/hung_task.c:249
>  kthread+0x345/0x410 kernel/kthread.c:238
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 PID: 4486 Comm: sshd Not tainted 4.17.0-rc4+ #52
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__debug_object_init+0x25/0x12c0 lib/debugobjects.c:371
> RSP: 0018:ffff8801b30f73d0 EFLAGS: 00000a02
> RAX: 1ffff1003661ee3d RBX: ffff8801b30f7440 RCX: ffffffff877175fb
> RDX: 0000000000000001 RSI: ffffffff88d9a5e0 RDI: ffff8801b30f7440
> RBP: ffff8801b30f73f0 R08: ffff8801b0a10740 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801b30f73c8
> R13: dffffc0000000000 R14: ffff8801b30f74c0 R15: 0000000000000001
> FS:  00007f15863b87c0(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f38c25af9ce CR3: 00000001d0b17000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  debug_object_init_on_stack+0x19/0x20 lib/debugobjects.c:444
>  hrtimer_init_on_stack kernel/time/hrtimer.c:435 [inline]
>  schedule_hrtimeout_range_clock+0xcc/0x470 kernel/time/hrtimer.c:1936
>  schedule_hrtimeout_range+0x2a/0x40 kernel/time/hrtimer.c:1989
>  poll_schedule_timeout+0x11a/0x200 fs/select.c:243
>  do_select+0x1606/0x1ae0 fs/select.c:581
>  core_sys_select+0x768/0xb60 fs/select.c:655
>  kern_select+0x1b7/0x250 fs/select.c:696
>  __do_sys_select fs/select.c:705 [inline]
>  __se_sys_select fs/select.c:702 [inline]
>  __x64_sys_select+0xbe/0x150 fs/select.c:702
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7f1584758dd3
> RSP: 002b:00007ffe596ca1f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
> RAX: ffffffffffffffda RBX: 00007ffe596ca280 RCX: 00007f1584758dd3
> RDX: 000055a15612aab0 RSI: 000055a15612aad0 RDI: 000000000000000c
> RBP: 000055a1559bf8dc R08: 00007ffe596ca220 R09: 0101010101010101
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe596ca288
> R13: 0000000000000000 R14: 00007ffe596ca278 R15: 00007ffe596ca27c
> Code: 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 48 8d 85 f8 fd ff ff 41 55
> 48 c1 e8 03 49 bd 00 00 00 00 00 fc ff df 41 54 4c 8d 65 d8 <53> 48 89 fb 48
> 81 ec 30 02 00 00 48 89 85 d8 fd ff ff 4c 01 e8
