From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in
 crypto_chacha20_crypt
Date: Sun, 3 Dec 2017 11:11:22 -0800
Message-ID: <20171203191122.GA844@zzz.localdomain>
References: <94eb2c05a5227b8588055f705abc@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+a2aae0656fcdc9990e110e63998f859a38854fde@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33912 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdLCTL0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Dec 2017 14:11:26 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c05a5227b8588055f705abc@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 03, 2017 at 06:24:02AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> dbf9f9124937139e6fcd3f6c64154a699408b481
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> BUG: unable to handle kernel paging request at ffffffff00000001
> IP: crypto_chacha20_init crypto/chacha20_generic.c:58 [inline]
> IP: crypto_chacha20_crypt+0x557/0xbd0 crypto/chacha20_generic.c:91
> PGD 5e28067 P4D 5e28067 PUD 0
> Oops: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 5290 Comm: syz-executor3 Not tainted 4.15.0-rc1-mm1+ #27
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> task: ffff8801c1b2c580 task.stack: ffff88018c840000
> RIP: 0010:crypto_chacha20_init crypto/chacha20_generic.c:58 [inline]
> RIP: 0010:crypto_chacha20_crypt+0x557/0xbd0 crypto/chacha20_generic.c:91
> RSP: 0018:ffff88018c847680 EFLAGS: 00010246
> RAX: ffff88018c8476f0 RBX: 00000000e6000000 RCX: ffffffff8226c4bb
> RDX: 0000000000000000 RSI: ffffc90002047000 RDI: ffff88018c84771c
> RBP: ffff88018c8478a0 R08: ffffed003b63a7f4 R09: ffff8801db1d3f80
> R10: ffff88018c8478b8 R11: ffffed003b63a7f3 R12: 0000000000000000
> R13: ffffffff00000001 R14: 0000000000000000 R15: dffffc0000000000
> FS:  00007fc8376e2700(0000) GS:ffff8801db500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffff00000001 CR3: 00000001db1a9000 CR4: 00000000001406e0
> DR0: 0000000020001000 DR1: 0000000020000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  crypto_skcipher_decrypt include/crypto/skcipher.h:463 [inline]
>  _skcipher_recvmsg crypto/algif_skcipher.c:126 [inline]
>  skcipher_recvmsg+0x739/0xf20 crypto/algif_skcipher.c:165
>  sock_recvmsg_nosec net/socket.c:805 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:812
>  sock_read_iter+0x361/0x560 net/socket.c:889
>  call_read_iter include/linux/fs.h:1766 [inline]
>  aio_read+0x2b0/0x3a0 fs/aio.c:1501
>  io_submit_one fs/aio.c:1611 [inline]
>  do_io_submit+0xf99/0x14f0 fs/aio.c:1682
>  SYSC_io_submit fs/aio.c:1707 [inline]
>  SyS_io_submit+0x27/0x30 fs/aio.c:1704
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz dup: general protection fault in crypto_chacha20_crypt
