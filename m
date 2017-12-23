From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: INFO: task hung in aead_recvmsg
Date: Sat, 23 Dec 2017 14:29:42 -0600
Message-ID: <20171223202942.GB10162@zzz.localdomain>
References: <001a1140b8307b0439055ffc7872@google.com>
 <CACT4Y+bgQ02e2=A0HpsRQbC6RFRi8N+GvhYfmCg+EuAXHHafxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs@googlegroups.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:43265 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756963AbdLWU3q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Dec 2017 15:29:46 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+bgQ02e2=A0HpsRQbC6RFRi8N+GvhYfmCg+EuAXHHafxA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[+Cc Steffen Klassert <steffen.klassert@secunet.com>]

On Tue, Dec 12, 2017 at 05:46:46PM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> On Sun, Dec 10, 2017 at 2:34 PM, syzbot
> <bot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>
> wrote:
> > Hello,
> >
> > syzkaller hit the following crash on
> > ad4dac17f9d563b9e34aab78a34293b10993e9b5
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> >
> > Unfortunately, I don't have any reproducer for this bug yet.
> >
> >
> > Use struct sctp_assoc_value instead
> > INFO: task syz-executor6:7377 blocked for more than 120 seconds.
> >       Not tainted 4.15.0-rc2-next-20171208+ #63
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > syz-executor6   D24416  7377   3393 0x00000004
> > Call Trace:
> >  context_switch kernel/sched/core.c:2800 [inline]
> >  __schedule+0x8eb/0x2060 kernel/sched/core.c:3376
> >  schedule+0xf5/0x430 kernel/sched/core.c:3435
> >  schedule_timeout+0x43a/0x560 kernel/time/timer.c:1776
> >  do_wait_for_common kernel/sched/completion.c:91 [inline]
> >  __wait_for_common kernel/sched/completion.c:112 [inline]
> >  wait_for_common kernel/sched/completion.c:123 [inline]
> >  wait_for_completion+0x44b/0x7b0 kernel/sched/completion.c:144
> >  crypto_wait_req include/linux/crypto.h:496 [inline]
> >  _aead_recvmsg crypto/algif_aead.c:308 [inline]
> >  aead_recvmsg+0x1396/0x1bc0 crypto/algif_aead.c:329
> >  aead_recvmsg_nokey+0x60/0x80 crypto/algif_aead.c:447
> >  sock_recvmsg_nosec net/socket.c:809 [inline]
> >  sock_recvmsg+0xc9/0x110 net/socket.c:816
> >  ___sys_recvmsg+0x29b/0x630 net/socket.c:2185
> >  __sys_recvmsg+0xe2/0x210 net/socket.c:2230
> >  SYSC_recvmsg net/socket.c:2242 [inline]
> >  SyS_recvmsg+0x2d/0x50 net/socket.c:2237
> >  entry_SYSCALL_64_fastpath+0x1f/0x96
> > RIP: 0033:0x452a39
> > RSP: 002b:00007f9dc7c93c58 EFLAGS: 00000212 ORIG_RAX: 000000000000002f
> > RAX: ffffffffffffffda RBX: 00007f9dc7c94700 RCX: 0000000000452a39
> > RDX: 0000000000000000 RSI: 0000000020539fc8 RDI: 0000000000000025
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000000
> > R13: 0000000000a6f7ff R14: 00007f9dc7c949c0 R15: 0000000000000000
> >
> > Showing all locks held in the system:
> > 2 locks held by khungtaskd/671:
> >  #0:  (rcu_read_lock){....}, at: [<00000000d256784e>]
> > check_hung_uninterruptible_tasks kernel/hung_task.c:175 [inline]
> >  #0:  (rcu_read_lock){....}, at: [<00000000d256784e>] watchdog+0x1c5/0xd60
> > kernel/hung_task.c:249
> >  #1:  (tasklist_lock){.+.+}, at: [<00000000d84da0f3>]
> > debug_show_all_locks+0xd3/0x400 kernel/locking/lockdep.c:4554
> > 1 lock held by rsyslogd/2995:
> >  #0:  (&f->f_pos_lock){+.+.}, at: [<0000000034bb33fc>]
> > __fdget_pos+0x131/0x1a0 fs/file.c:765
> > 2 locks held by getty/3116:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3117:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3118:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3119:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3120:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3121:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 2 locks held by getty/3122:
> >  #0:  (&tty->ldisc_sem){++++}, at: [<000000008df66e53>]
> > ldsem_down_read+0x37/0x40 drivers/tty/tty_ldsem.c:365
> >  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<00000000870ebf25>]
> > n_tty_read+0x2f2/0x1a10 drivers/tty/n_tty.c:2131
> > 1 lock held by syz-executor6/7377:
> >  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>] lock_sock
> > include/net/sock.h:1463 [inline]
> >  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>]
> > aead_recvmsg+0xb3/0x1bc0 crypto/algif_aead.c:327
> > 1 lock held by syz-executor6/7391:
> >  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>] lock_sock
> > include/net/sock.h:1463 [inline]
> >  #0:  (sk_lock-AF_ALG){+.+.}, at: [<0000000096d0e030>]
> > aead_recvmsg+0xb3/0x1bc0 crypto/algif_aead.c:327
> >

I was able to reproduce this by trying to use 'pcrypt' recursively.  I am not
100% sure it is the exact same bug, but it probably is.  Here is a C reproducer:

	#include <linux/if_alg.h>
	#include <sys/socket.h>
	#include <unistd.h>

	int main()
	{
		struct sockaddr_alg addr = {
			.salg_type = "aead",
			.salg_name = "pcrypt(pcrypt(rfc4106-gcm-aesni))",
		};
		int algfd, reqfd;
		char buf[32] = { 0 };

		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
		bind(algfd, (void *)&addr, sizeof(addr));
		setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, 20);

		reqfd = accept(algfd, 0, 0);
		write(reqfd, buf, 32);
		read(reqfd, buf, 16);
	}

It seems the problem is that all 'pcrypt' instances use the same
'padata_instance', which completes works in the order they are submitted.  But
with nested use, the outer work is submitted before the inner work, so the inner
work isn't allowed to complete until the outer work does, which deadlocks
because actually the inner work needs to complete first.

What a mess.  Maybe there should be a separate 'padata_instance' per pcrypt
instance?  Or maybe there should be a way for an algorithm to declare that it
can only appear in the stack one time?  

Eric
