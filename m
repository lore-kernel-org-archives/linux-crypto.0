From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: suspicious RCU usage at ./include/trace/events/kmem.h:LINE
Date: Tue, 28 Nov 2017 20:59:55 -0800
Message-ID: <20171129045955.GC24001@zzz.localdomain>
References: <001a11445ed40f1e82055f0bbe7b@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+fbbeacd3de00d98d2fe5a9e69d8025f36dbd2ddb@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a11445ed40f1e82055f0bbe7b@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 06:22:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> 
> =============================
> WARNING: suspicious RCU usage
> 4.14.0+ #192 Not tainted
> -----------------------------
> ./include/trace/events/kmem.h:142 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by syzkaller215525/3051:
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<ffffffff8239ac22>] lock_sock
> include/net/sock.h:1465 [inline]
>  #0:  (sk_lock-AF_ALG){+.+.}, at: [<ffffffff8239ac22>]
> af_alg_wait_for_data+0x2f2/0x650 crypto/af_alg.c:768
> 
> stack backtrace:
> CPU: 0 PID: 3051 Comm: syzkaller215525 Not tainted 4.14.0+ #192
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  lockdep_rcu_suspicious+0x123/0x170 kernel/locking/lockdep.c:4675
>  trace_kfree include/trace/events/kmem.h:137 [inline]
>  kfree+0x20a/0x250 mm/slab.c:3796
>  blkcipher_walk_done+0x72b/0xde0 crypto/blkcipher.c:139
>  encrypt+0x20e/0x540 arch/x86/crypto/salsa20_glue.c:79
>  skcipher_crypt_blkcipher crypto/skcipher.c:619 [inline]
>  skcipher_decrypt_blkcipher+0x213/0x310 crypto/skcipher.c:637
>  crypto_skcipher_decrypt include/crypto/skcipher.h:463 [inline]
>  _skcipher_recvmsg crypto/algif_skcipher.c:133 [inline]
>  skcipher_recvmsg+0xb06/0xf30 crypto/algif_skcipher.c:164
>  skcipher_recvmsg_nokey+0x60/0x80 crypto/algif_skcipher.c:283
>  sock_recvmsg_nosec net/socket.c:805 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:812
>  ___sys_recvmsg+0x29b/0x630 net/socket.c:2207
>  __sys_recvmsg+0xe2/0x210 net/socket.c:2252
>  SYSC_recvmsg net/socket.c:2264 [inline]
>  SyS_recvmsg+0x2d/0x50 net/socket.c:2259
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz dup: WARNING: suspicious RCU usage (3)
