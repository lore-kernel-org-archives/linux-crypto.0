From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 __crypto_alg_lookup
Date: Wed, 20 Dec 2017 14:36:01 -0800
Message-ID: <20171220223601.GC38504@gmail.com>
References: <001a1144a1eed09825056096eb88@google.com>
 <1722846.rDtNfF0TEk@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+08fafbe591c1d2980114c828ef2d7b5a46c19bff@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:45371 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdLTWgG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 17:36:06 -0500
Content-Disposition: inline
In-Reply-To: <1722846.rDtNfF0TEk@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 18, 2017 at 07:25:41AM +0100, Stephan Mueller wrote:
> Am Montag, 18. Dezember 2017, 06:50:01 CET schrieb syzbot:
> 
> Hi,
> 
> > Hello,
> > 
> > syzkaller hit the following crash on
> > 41d8c16909ebda40f7b4982a7f5e2ad102705ade
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> > C reproducer is attached
> > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > for information about syzkaller reproducers
> > 
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> > IP: __crypto_alg_lookup+0x43/0x190 crypto/api.c:63
> > PGD 0 P4D 0
> > Oops: 0000 [#1] SMP
> > Dumping ftrace buffer:
> >     (ftrace buffer empty)
> > Modules linked in:
> > CPU: 1 PID: 3321 Comm: cryptomgr_probe Not tainted
> > 4.15.0-rc3-next-20171213+ #66
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:__crypto_alg_lookup+0x43/0x190 crypto/api.c:63
> > RSP: 0018:ffffc900017ebd28 EFLAGS: 00010293
> > RAX: ffff880216762080 RBX: 0000000000000000 RCX: ffffffff81673d23
> > RDX: 0000000000000000 RSI: 0000000000000403 RDI: ffff880214eba120
> > RBP: ffffc900017ebd70 R08: 0000000000000001 R09: 0000000000000001
> > R10: ffffc900017ebcf0 R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000000 R14: 000000000000240f R15: 0000000000000403
> > FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000020 CR3: 000000020dc6b000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   crypto_alg_lookup+0x31/0x50 crypto/api.c:201
> >   crypto_larval_lookup.part.8+0x34/0x1c0 crypto/api.c:218
> >   crypto_larval_lookup crypto/api.c:212 [inline]
> >   crypto_alg_mod_lookup+0x77/0x120 crypto/api.c:271
> >   crypto_find_alg+0x63/0x70 crypto/api.c:501
> >   crypto_grab_spawn+0x2f/0x80 crypto/algapi.c:631
> >   crypto_grab_aead+0x35/0x40 crypto/aead.c:336
> >   pcrypt_create_aead crypto/pcrypt.c:298 [inline]
> >   pcrypt_create+0xca/0x2c0 crypto/pcrypt.c:346
> >   cryptomgr_probe+0x40/0x100 crypto/algboss.c:75
> >   kthread+0x149/0x170 kernel/kthread.c:238
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:524
> > Code: 89 7d d0 e8 70 66 c4 ff 48 8b 1d 59 e4 a6 01 48 81 fb 60 21 0e 83 0f
> > 84 4c 01 00 00 c7 45 c4 fe ff ff ff 45 31 e4 e8 4d 66 c4 ff <44> 8b 6b 20
> > 41 f6 c5 60 0f 85 03 01 00 00 e8 3a 66 c4 ff 44 89
> > RIP: __crypto_alg_lookup+0x43/0x190 crypto/api.c:63 RSP: ffffc900017ebd28
> > CR2: 0000000000000020
> > ---[ end trace ff8e3661b9c3aa04 ]---
> > Kernel panic - not syncing: Fatal exception
> > Dumping ftrace buffer:
> >     (ftrace buffer empty)
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
> 
> This bug seems to be triggerable again by the fact that some strange mask/type 
> combo is used. When setting it to zero, there is no crash.
> 
> Therefore I would see that this issue would be covered with the fix that we 
> currently work on to limit the number of allowed mask/type values.
> 

AF_ALG definitely should be locked down more, but we should fix the bugs before
they get hidden; after all, they are likely reachable in other ways as well.
There is a bug in pcrypt which seems to be causing some of these reports.  I've
sent out a fix and will mark the reports as a duplicate of the first:

#syz dup: KASAN: use-after-free Read in __list_del_entry_valid (2)

(It's a bit messy because the bug is causing a bogus pointer to be kfree()'d,
which can result in different symptoms, especially with slab merging.)
