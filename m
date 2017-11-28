From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in scatterwalk_copychunks
Date: Tue, 28 Nov 2017 14:50:50 -0800
Message-ID: <20171128225050.GI45321@gmail.com>
References: <001a113ebb5eeb43ae055f0e48ae@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+bad1be57103f3cca1808f4a5231ab02d20f69fa3@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:40978 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752297AbdK1Wux (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 17:50:53 -0500
Content-Disposition: inline
In-Reply-To: <001a113ebb5eeb43ae055f0e48ae@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 09:24:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 17658 Comm: syzkaller625686 Not tainted 4.14.0-mm1+ #25
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> task: ffff8801c734e280 task.stack: ffff8801c5f10000
> RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:86 [inline]
> RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:111 [inline]
> RIP: 0010:scatterwalk_copychunks+0x337/0x480 crypto/scatterwalk.c:55
> RSP: 0018:ffff8801c5f175c8 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff82502da9
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000008
> RBP: ffff8801c5f17628 R08: ffff8801c5f177c0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff8801c5f177c0 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00007f8ce5e49700(0000) GS:ffff8801db400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020284000 CR3: 00000001ce96c000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  blkcipher_next_slow crypto/blkcipher.c:175 [inline]
>  blkcipher_walk_next+0xca0/0x13d0 crypto/blkcipher.c:255
>  blkcipher_walk_first+0x261/0x570 crypto/blkcipher.c:346
>  blkcipher_walk_virt+0x219/0x2a0 crypto/blkcipher.c:308
>  skcipher_null_crypt+0x10e/0x2d0 crypto/crypto_null.c:85
>  skcipher_crypt_blkcipher crypto/skcipher.c:619 [inline]
>  skcipher_encrypt_blkcipher+0x213/0x310 crypto/skcipher.c:628
>  crypto_skcipher_encrypt include/crypto/skcipher.h:445 [inline]
>  crypto_aead_copy_sgl crypto/algif_aead.c:90 [inline]
>  _aead_recvmsg crypto/algif_aead.c:228 [inline]
>  aead_recvmsg+0xc96/0x1970 crypto/algif_aead.c:313
>  aead_recvmsg_nokey+0x60/0x80 crypto/algif_aead.c:431
>  sock_recvmsg_nosec net/socket.c:805 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:812
>  ___sys_recvmsg+0x29b/0x630 net/socket.c:2207
>  __sys_recvmsg+0xe2/0x210 net/socket.c:2252
>  SYSC_recvmsg net/socket.c:2264 [inline]
>  SyS_recvmsg+0x2d/0x50 net/socket.c:2259
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz fix: crypto: algif_aead - skip SGL entries with NULL page
