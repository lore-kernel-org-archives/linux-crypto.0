From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in __crypto_alg_lookup
Date: Tue, 16 Jan 2018 22:42:54 -0800
Message-ID: <20180117064254.GF15527@zzz.localdomain>
References: <94eb2c19e7562b0ed30560c0d1f8@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+e73a4dea901456e1260a0ac63aac133495835be2@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f41.google.com ([209.85.160.41]:35681 "EHLO
        mail-pl0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeAQGm5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 01:42:57 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c19e7562b0ed30560c0d1f8@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 11:49:02PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> SELinux: unrecognized netlink message: protocol=0 nlmsg_type=256
> sclass=netlink_route_socket pig=17315 comm=syz-executor6
> SELinux: unrecognized netlink message: protocol=0 nlmsg_type=256
> sclass=netlink_route_socket pig=17326 comm=syz-executor6
> general protection fault: 0000 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 17336 Comm: syz-executor7 Not tainted 4.15.0-rc3-next-20171214+
> #67
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__crypto_alg_lookup+0x43/0x190 crypto/api.c:63
> RSP: 0018:ffffc90000d7fcb8 EFLAGS: 00010216
> RAX: 0000000000010000 RBX: 623e2d6261746826 RCX: ffffffff816741f3
> RDX: 00000000000000d9 RSI: ffffc90001a01000 RDI: ffff8801f9d11891
> RBP: ffffc90000d7fd00 R08: 0000000000000001 R09: 0000000000000001
> R10: ffffc90000d7fc80 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000072612f66 R14: 000000000000240e R15: 000000000000040f
> FS:  00007ff6c7ec5700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020f35000 CR3: 00000001fce0e004 CR4: 00000000001606e0
> Call Trace:
>  crypto_alg_lookup+0x31/0x50 crypto/api.c:201
>  crypto_larval_lookup.part.8+0x34/0x1c0 crypto/api.c:218
>  crypto_larval_lookup crypto/api.c:212 [inline]
>  crypto_alg_mod_lookup+0x77/0x120 crypto/api.c:271
>  crypto_find_alg crypto/api.c:501 [inline]
>  crypto_alloc_tfm+0x67/0x180 crypto/api.c:534
>  crypto_alloc_ahash+0x2c/0x40 crypto/ahash.c:540
>  hash_bind+0x51/0x90 crypto/algif_hash.c:422
>  alg_bind+0x94/0x180 crypto/af_alg.c:179
>  SYSC_bind+0xa8/0x130 net/socket.c:1454
>  SyS_bind+0x24/0x30 net/socket.c:1440
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a09
> RSP: 002b:00007ff6c7ec4c58 EFLAGS: 00000212 ORIG_RAX: 0000000000000031
> RAX: ffffffffffffffda RBX: 000000000071bea0 RCX: 0000000000452a09
> RDX: 0000000000000058 RSI: 0000000020f35000 RDI: 0000000000000013
> RBP: 0000000000000554 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006f5080
> R13: 00000000ffffffff R14: 00007ff6c7ec56d4 R15: 0000000000000000
> Code: 89 7d d0 e8 70 61 c4 ff 48 8b 1d 89 df a6 01 48 81 fb 60 21 0e 83 0f
> 84 4c 01 00 00 c7 45 c4 fe ff ff ff 45 31 e4 e8 4d 61 c4 ff <44> 8b 6b 20 41
> f6 c5 60 0f 85 03 01 00 00 e8 3a 61 c4 ff 44 89
> RIP: __crypto_alg_lookup+0x43/0x190 crypto/api.c:63 RSP: ffffc90000d7fcb8
> ---[ end trace 17ac9655be6571e5 ]---
> Kernel panic - not syncing: Fatal exception
> netlink: 5 bytes leftover after parsing attributes in process
> `syz-executor6'.
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 

Invalidating this bug now that a similar one has been fixed; we'll see if it
happens again...

#syz invalid
