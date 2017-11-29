From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: suspicious RCU usage at ./include/linux/mm.h:LINE
Date: Tue, 28 Nov 2017 21:00:27 -0800
Message-ID: <20171129050027.GD24001@zzz.localdomain>
References: <001a1143d74236531a055f0c986c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+7991df012bd9be52601c6e536addde6cefbfbde6@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41482 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdK2FAa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 00:00:30 -0500
Content-Disposition: inline
In-Reply-To: <001a1143d74236531a055f0c986c@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 07:23:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1d3b78bbc6e983fabb3fbf91b76339bf66e4a12c
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> WARNING: suspicious RCU usage
> 4.14.0+ #130 Not tainted
> page:ffffea000765abc0 count:0 mapcount:0 mapping:          (null) index:0x0
> flags: 0x2fffc0000000000()
> raw: 02fffc0000000000 0000000000000000 0000000000000000 00000000ffffffff
> raw: 0000000000000000 0000000100000001 0000000000000000 0000000000000000
> page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/mm.h:482!
> invalid opcode: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 10013 Comm: syz-executor2 Not tainted 4.14.0+ #130
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> task: ffff8801d807a300 task.stack: ffff8801d96a8000
> RIP: 0010:put_page_testzero include/linux/mm.h:482 [inline]
> RIP: 0010:__free_pages+0x118/0x150 mm/page_alloc.c:4288
> RSP: 0018:ffff8801d96af860 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: ffffea000765abc0 RCX: 0000000000000000
> RDX: 00000000001f0100 RSI: 1ffff1003b00f575 RDI: ffffed003b2d5f00
> RBP: ffff8801d96af8f0 R08: 1ffff1003b2d5e30 R09: 0000000000000000
> R10: dffffc0000000000 R11: 0000000000000000 R12: 1ffff1003b2d5f0d
> R13: 1ffff1003b2d5f11 R14: 0000000000000000 R15: ffff8801d96af8c8
> FS:  00007f5ca866d700(0000) GS:ffff8801db500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020f73000 CR3: 00000001d7cf7000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  free_pages+0x51/0x90 mm/page_alloc.c:4302
>  blkcipher_walk_done+0x767/0xde0 crypto/blkcipher.c:141
>  encrypt+0x50a/0xaf0 crypto/salsa20_generic.c:208
>  skcipher_crypt_blkcipher crypto/skcipher.c:619 [inline]
>  skcipher_decrypt_blkcipher+0x213/0x310 crypto/skcipher.c:637
>  crypto_skcipher_decrypt include/crypto/skcipher.h:463 [inline]
>  _skcipher_recvmsg crypto/algif_skcipher.c:133 [inline]
>  skcipher_recvmsg+0xb06/0xf30 crypto/algif_skcipher.c:164
>  sock_recvmsg_nosec net/socket.c:805 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:812
>  SYSC_recvfrom+0x2dc/0x570 net/socket.c:1801
>  SyS_recvfrom+0x40/0x50 net/socket.c:1773
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz dup: WARNING: suspicious RCU usage (3)
