From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in
 aead_accept_parent_nokey
Date: Tue, 30 Jan 2018 14:24:46 -0800
Message-ID: <20180130222446.4aim3hgarhlv5a2v@gmail.com>
References: <001a1143fd0067065e056096ef90@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+4d8b9d4de3fb89b15eb7f8b5c30d004f1836ee02@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:46169 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbeA3WYt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 17:24:49 -0500
Content-Disposition: inline
In-Reply-To: <001a1143fd0067065e056096ef90@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 17, 2017 at 09:51:01PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 41d8c16909ebda40f7b4982a7f5e2ad102705ade
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> device lo entered promiscuous mode
> BUG: unable to handle kernel paging request at fffffffffffffff0
> Bearer <> rejected, not supported in standalone mode
> IP: aead_accept_parent_nokey+0x2a/0x150 crypto/algif_aead.c:559
> PGD 3021067 P4D 3021067 PUD 3023067 PMD 0
> Oops: 0000 [#1] SMP
> Bearer <> rejected, not supported in standalone mode
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 5971 Comm: syz-executor1 Not tainted 4.15.0-rc3-next-20171213+
> #66
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:aead_accept_parent_nokey+0x2a/0x150 crypto/algif_aead.c:559
> RSP: 0018:ffffc90000d7bda8 EFLAGS: 00010216
> RAX: 0000000000000000 RBX: ffff88020ab17540 RCX: ffffffff816ca746
> RDX: 00000000014000c0 RSI: 0000000000000090 RDI: ffff8801e2c0e800
> RBP: ffffc90000d7bdc8 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801e2c0e800
> R13: ffffffff82a95520 R14: ffff880213fd5400 R15: 0000000000000000
> FS:  00007f60fba0c700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffff0 CR3: 00000001e10a4000 CR4: 00000000001426e0
> Call Trace:
>  aead_accept_parent+0x28/0x40 crypto/algif_aead.c:595
>  af_alg_accept+0x9c/0x1f0 crypto/af_alg.c:294
>  alg_accept+0x25/0x30 crypto/af_alg.c:330
>  SYSC_accept4+0x114/0x260 net/socket.c:1551
>  SyS_accept4 net/socket.c:1502 [inline]
>  SYSC_accept net/socket.c:1585 [inline]
>  SyS_accept+0x26/0x30 net/socket.c:1582
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x452a39
> RSP: 002b:00007f60fba0bc58 EFLAGS: 00000212 ORIG_RAX: 000000000000002b
> RAX: ffffffffffffffda RBX: 0000000000758020 RCX: 0000000000452a39
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000016
> RBP: 000000000000001a R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006ee310
> R13: 00000000ffffffff R14: 00007f60fba0c6d4 R15: 0000000000000000
> Code: 00 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb 49 89 f4 e8 2a fc be ff
> 48 8b 03 ba c0 00 40 01 be 90 00 00 00 4c 89 e7 48 8b 40 40 <44> 8b 68 f0 e8
> 7d a7 9d 00 48 85 c0 0f 84 ed 00 00 00 48 89 c3
> RIP: aead_accept_parent_nokey+0x2a/0x150 crypto/algif_aead.c:559 RSP:
> ffffc90000d7bda8
> CR2: fffffffffffffff0
> ---[ end trace 1608f1470cd99fdb ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

Invalidating this bug since it hasn't been seen again, and it was reported while
KASAN was accidentally disabled in the syzbot kconfig due to a change to the
kconfig menus in linux-next (so this crash was possibly caused by slab
corruption elsewhere).

#syz invalid
