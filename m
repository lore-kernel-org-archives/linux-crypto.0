From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 __crypto_register_alg
Date: Fri, 2 Feb 2018 15:26:11 -0800
Message-ID: <20180202232611.s45ho7ckhrbh7ued@gmail.com>
References: <94eb2c1170ce51d6440561115a0c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+485d9c375867a8a90d6b2950c7b2c53797524c3b@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35835 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbeBBX0O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Feb 2018 18:26:14 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c1170ce51d6440561115a0c@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 23, 2017 at 11:54:01PM -0800, syzbot wrote:
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
> netlink: 'syz-executor4': attribute type 29 has an invalid length.
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> IP: __crypto_register_alg+0x7b/0x300 crypto/algapi.c:212
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 19130 Comm: cryptomgr_probe Not tainted
> 4.15.0-rc3-next-20171214+ #67
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__crypto_register_alg+0x7b/0x300 crypto/algapi.c:212
> RSP: 0018:ffffc90000fefe00 EFLAGS: 00010293
> RAX: ffff88020df4c240 RBX: 0000000000000000 RCX: ffffffff8167622b
> RDX: 0000000000000000 RSI: ffff8801fa6f8559 RDI: ffff8801fa6f8881
> RBP: ffffc90000fefe30 R08: 0000000000000001 R09: 0000000000000004
> R10: ffffc90000fefdb0 R11: 0000000000000004 R12: ffff8801fa6f84a0
> R13: 0000000000000000 R14: 000000000000080e R15: ffff8801fa6f8900
> FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000020 CR3: 000000000301e004 CR4: 00000000001626f0
> DR0: 0000000020000000 DR1: 0000000020000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Call Trace:
>  crypto_register_instance+0x83/0x140 crypto/algapi.c:544
>  shash_register_instance+0x34/0x50 crypto/shash.c:532
>  cbcmac_create+0x15c/0x190 crypto/ccm.c:988
>  cryptomgr_probe+0x40/0x100 crypto/algboss.c:75
>  kthread+0x149/0x170 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:524
> Code: 10 49 89 44 24 18 48 81 fb 60 21 0e 83 0f 84 bb 00 00 00 e8 28 41 c4
> ff 49 39 dc 74 43 49 8d 44 24 38 48 89 45 d0 e8 15 41 c4 ff <44> 8b 6b 20 41
> f6 c5 60 75 78 e8 06 41 c4 ff 41 83 e5 10 4c 8d
> RIP: __crypto_register_alg+0x7b/0x300 crypto/algapi.c:212 RSP:
> ffffc90000fefe00
> CR2: 0000000000000020
> ---[ end trace 598f24e6511387a3 ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 

This is yet another one that was reported while KASAN was accidentally disabled,
and it only happened once, so invalidating:

#syz invalid

- Eric
