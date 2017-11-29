From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in crypto_chacha20_crypt
Date: Wed, 29 Nov 2017 01:24:38 -0800
Message-ID: <20171129092438.GC20992@zzz.localdomain>
References: <001a113fae28149757055f0bbe00@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+fa2ed481fed0c7ace1571b88a89dfd49ffd89cb6@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33220 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdK2JYl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 04:24:41 -0500
Content-Disposition: inline
In-Reply-To: <001a113fae28149757055f0bbe00@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 06:22:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 0c86a6bd85ff0629cd2c5141027fc1c8bb6cde9c
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
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
> CPU: 0 PID: 6285 Comm: syzkaller774851 Not tainted 4.14.0+ #128
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> task: ffff8801c63fa140 task.stack: ffff8801c52e8000
> RIP: 0010:__le32_to_cpup include/uapi/linux/byteorder/little_endian.h:58
> [inline]
> RIP: 0010:le32_to_cpuvp crypto/chacha20_generic.c:19 [inline]
> RIP: 0010:crypto_chacha20_init crypto/chacha20_generic.c:58 [inline]
> RIP: 0010:crypto_chacha20_crypt+0x537/0xbd0 crypto/chacha20_generic.c:91
> RSP: 0018:ffff8801c52ef5b0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 00000000ef9ecba1 RCX: ffffffff82265bab
> RDX: 0000000000000000 RSI: ffff8801c5554780 RDI: ffff8801c52ef64c
> RBP: ffff8801c52ef7d0 R08: ffffed0038a8ee6c R09: ffff8801c5477340
> R10: ffff8801c52ef7f0 R11: ffffed0038a8ee6b R12: 0000000000000000
> R13: 0000000000000000 R14: 000000005c3d10a6 R15: dffffc0000000000
> FS:  00007f7725fce700(0000) GS:ffff8801db400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020216000 CR3: 00000001c5566000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  chacha20_simd+0xe4/0x410 arch/x86/crypto/chacha20_glue.c:78
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

The bug is that the skcipher_walk API doesn't set the IV for zero-length inputs,
while some algorithms (e.g. ChaCha20) access the IV even if the input is
zero-length.  So it was dereferencing a pointer which came from uninitialized
stack memory.  I've sent out a fix:

"crypto: skcipher - set walk.iv for zero-length inputs"
