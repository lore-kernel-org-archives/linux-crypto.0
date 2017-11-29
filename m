From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in kfree
Date: Wed, 29 Nov 2017 11:46:32 -0800
Message-ID: <20171129194632.GA29498@gmail.com>
References: <001a1144a1eebb0bbe055f1c88b3@google.com>
 <CACT4Y+ZVYKQ1Cd_4SNGhqJhEUeeoVavFBNo2BDSw_HQcbxGLJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+9f319d9f8748fecc56f23463861c56aae433413e@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Stephan Mueller <smueller@chronox.de>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZVYKQ1Cd_4SNGhqJhEUeeoVavFBNo2BDSw_HQcbxGLJw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 29, 2017 at 11:30:36AM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> On Wed, Nov 29, 2017 at 11:24 AM, syzbot
> <bot+9f319d9f8748fecc56f23463861c56aae433413e@syzkaller.appspotmail.com>
> wrote:
> > Hello,
> >
> > syzkaller hit the following crash on
> > 43570f0383d6d5879ae585e6c3cf027ba321546f
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> >
> > Unfortunately, I don't have any reproducer for this bug yet.
> >
> >
> > netlink: 3 bytes leftover after parsing attributes in process
> > `syz-executor3'.
> > device gre0 entered promiscuous mode
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000074
> > IP: virt_to_cache mm/slab.c:400 [inline]
> > IP: kfree+0xb2/0x250 mm/slab.c:3802
> > PGD 1d369e067 P4D 1d369e067 PUD 1c8da0067 PMD 0
> > Oops: 0000 [#1] SMP KASAN
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > Modules linked in:
> > CPU: 0 PID: 8031 Comm: syz-executor5 Not tainted 4.15.0-rc1+ #199
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > task: ffff8801d33f8540 task.stack: ffff8801d3b58000
> > RIP: 0010:virt_to_cache mm/slab.c:400 [inline]
> > RIP: 0010:kfree+0xb2/0x250 mm/slab.c:3802
> > RSP: 0018:ffff8801d3b5f780 EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: ffff8801d3b5f948 RCX: ffffffffffffffff
> > RDX: ffffea00074ed7c0 RSI: 0000000000000000 RDI: ffff8801d3b5f948
> > RBP: ffff8801d3b5f7a0 R08: ffffed003a2c3b7c R09: 0000000000000000
> > R10: 0000000000000001 R11: ffffed003a2c3b7b R12: 0000000000000286
> > R13: 0000000000000000 R14: ffff8801d3b5f948 R15: ffff8801d3b5f8b0
> > FS:  00007f7f80409700(0000) GS:ffff8801db400000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000074 CR3: 00000001c97a2000 CR4: 00000000001426f0
> > DR0: 0000000020001000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> > Call Trace:
> >  blkcipher_walk_done+0x72b/0xde0 crypto/blkcipher.c:139
> >  encrypt+0x50a/0xaf0 crypto/salsa20_generic.c:208
> >  skcipher_crypt_blkcipher crypto/skcipher.c:622 [inline]
> >  skcipher_decrypt_blkcipher+0x213/0x310 crypto/skcipher.c:640
> >  crypto_skcipher_decrypt include/crypto/skcipher.h:463 [inline]
> >  _skcipher_recvmsg crypto/algif_skcipher.c:144 [inline]
> >  skcipher_recvmsg+0xa54/0xf20 crypto/algif_skcipher.c:165
> >  sock_recvmsg_nosec net/socket.c:805 [inline]
> >  sock_recvmsg+0xc9/0x110 net/socket.c:812
> >  ___sys_recvmsg+0x29b/0x630 net/socket.c:2207
> >  __sys_recvmsg+0xe2/0x210 net/socket.c:2252
> >  SYSC_recvmsg net/socket.c:2264 [inline]
> >  SyS_recvmsg+0x2d/0x50 net/socket.c:2259
> >  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz dup: WARNING: suspicious RCU usage (3)

All the following 5 reports appear to be the same bug in Salsa20, and I've
marked them of duplicates of the first:

	WARNING: suspicious RCU usage (3)
	kernel BUG at ./include/linux/mm.h:LINE! (2)
	suspicious RCU usage at ./include/linux/mm.h:LINE
	suspicious RCU usage at ./include/trace/events/kmem.h:LINE
	BUG: unable to handle kernel NULL pointer dereference in kfree

The bug involves an uninitialized pointer being kfreed, or an uninitialized
'struct page' being freed.

Proposed fix is "crypto: salsa20 - fix blkcipher_walk API usage"
