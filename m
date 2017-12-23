From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: INFO: task hung in lock_sock_nested
Date: Sat, 23 Dec 2017 14:15:47 -0600
Message-ID: <20171223201547.GA10162@zzz.localdomain>
References: <f403043d11cc35affd055ffc8374@google.com>
 <CACT4Y+ZAYckRqi4v+XTdn-eq6LdrxoXsCDvCycthsn44kLJNzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+b09be8359497f2f986abf4f2db0e26de6ab1a00e@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs@googlegroups.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36657 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdLWUPw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Dec 2017 15:15:52 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZAYckRqi4v+XTdn-eq6LdrxoXsCDvCycthsn44kLJNzQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 12, 2017 at 05:47:34PM +0100, Dmitry Vyukov wrote:
> On Sun, Dec 10, 2017 at 2:37 PM, syzbot
> <bot+b09be8359497f2f986abf4f2db0e26de6ab1a00e@syzkaller.appspotmail.com>
> wrote:
> > Hello,
> >
> > syzkaller hit the following crash on
> > 51e18a453f5f59a40c721d4aeab082b4e2e9fac6
> > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> >
> > Unfortunately, I don't have any reproducer for this bug yet.
> >
> >
> > RDS: rds_bind could not find a transport for 172.20.1.187, load rds_tcp or
> > rds_rdma?
> > INFO: task syz-executor2:19495 blocked for more than 120 seconds.
> >       Not tainted 4.15.0-rc2+ #148
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > syz-executor2   D25200 19495   3406 0x00000004
> > Call Trace:
> >  context_switch kernel/sched/core.c:2799 [inline]
> >  __schedule+0x8eb/0x2060 kernel/sched/core.c:3375
> >  schedule+0xf5/0x430 kernel/sched/core.c:3434
> >  __lock_sock+0x1dc/0x2f0 net/core/sock.c:2240
> >  lock_sock_nested+0xf3/0x110 net/core/sock.c:2764
> >  lock_sock include/net/sock.h:1461 [inline]
> >  af_alg_sendmsg+0x349/0x1080 crypto/af_alg.c:858
> >  aead_sendmsg+0x103/0x150 crypto/algif_aead.c:76
> >  sock_sendmsg_nosec net/socket.c:636 [inline]
> >  sock_sendmsg+0xca/0x110 net/socket.c:646
> >  ___sys_sendmsg+0x75b/0x8a0 net/socket.c:2026
> >  __sys_sendmsg+0xe5/0x210 net/socket.c:2060
> >  SYSC_sendmsg net/socket.c:2071 [inline]
> >  SyS_sendmsg+0x2d/0x50 net/socket.c:2067
> >  entry_SYSCALL_64_fastpath+0x1f/0x96
> > RIP: 0033:0x452a39
> > RSP: 002b:00007f63f58cfc58 EFLAGS: 00000212 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 0000000000758020 RCX: 0000000000452a39
> > RDX: 0000000000000040 RSI: 0000000020630000 RDI: 0000000000000015
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006ee0b8
> > R13: 00000000ffffffff R14: 00007f63f58d06d4 R15: 0000000000000000
> >
> > Showing all locks held in the system:
> > 2 locks held by khungtaskd/663:
> >  #0:  (rcu_read_lock){....}, at: [<00000000b2540f7c>]
> > check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
> >  #0:  (rcu_read_lock){....}, at: [<00000000b2540f7c>] watchdog+0x1c5/0xd60
> > kernel/hung_task.c:249
> >  #1:  (tasklist_lock){.+.+}, at: [<00000000b425f323>]
> > debug_show_all_locks+0xd3/0x400 kernel/locking/lockdep.c:4554
> > 1 lock held by rsyslogd/3008:
> >  #0:  (&f->f_pos_lock){+.+.}, at: [<00000000d620dede>]
> > __fdget_pos+0x131/0x1a0 fs/file.c:770
> > 2 locks held by getty/3130:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3131:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3132:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3133:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3134:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3135:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3136:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<00000000ed362dba>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<000000002bd4e259>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 1 lock held by syz-executor2/19506:
> >  #0:  (sk_lock-AF_ALG){+.+.}, at: [<00000000bb9361fc>] lock_sock
> > include/net/sock.h:1461 [inline]
> >  #0:  (sk_lock-AF_ALG){+.+.}, at: [<00000000bb9361fc>]
> > aead_recvmsg+0xb3/0x1bc0 crypto/algif_aead.c:327
> >

I think this is a duplicate:

#syz dup: INFO: task hung in aead_recvmsg

There is a thread hung in aead_recvmsg() while holding the socket lock, so it's
blocking other threads too.

Eric
