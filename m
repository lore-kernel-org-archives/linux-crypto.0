From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in crypto_remove_spawns
Date: Tue, 16 Jan 2018 22:34:36 -0800
Message-ID: <20180117063436.GD15527@zzz.localdomain>
References: <001a1141c43ad30ccf055efb76ed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35563 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbeAQGej (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 01:34:39 -0500
Content-Disposition: inline
In-Reply-To: <001a1141c43ad30ccf055efb76ed@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:56:46AM -0800, syzbot wrote:
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
> CPU: 0 PID: 25985 Comm: cryptomgr_test Not tainted 4.14.0-mm1+ #25
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> task: ffff8801c4562180 task.stack: ffff8801d5b70000
> RIP: 0010:crypto_remove_spawns+0x58c/0x1260 crypto/algapi.c:159
> RSP: 0018:ffff8801d5b779e8 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: dffffc0000000000 RCX: ffffffff82258aab
> RDX: 0000000000000000 RSI: 1ffff1003ab6efa6 RDI: 0000000000000018
> RBP: ffff8801d5b77dd8 R08: ffff8801d5b77d70 R09: 0000000000000004
> R10: 0000000000000000 R11: ffffffff8747dda0 R12: 0000000000000000
> R13: ffff8801c505bb60 R14: ffffed003ab6ef4e R15: ffff8801d5b77db0
> FS:  0000000000000000(0000) GS:ffff8801db400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff1d3ffcac CR3: 00000001cf825000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  crypto_alg_tested+0x514/0x6f0 crypto/algapi.c:311
>  cryptomgr_test+0x17/0x30 crypto/algboss.c:226
>  kthread+0x37a/0x440 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:437
> Code: 84 e3 01 00 00 e8 35 94 4a ff 4c 89 e8 48 c1 e8 03 80 3c 18 00 0f 85
> d8 09 00 00 4d 8b 65 00 49 8d 7c 24 18 48 89 f8 48 c1 e8 03 <80> 3c 18 00 0f
> 85 b4 09 00 00 4d 8b 6c 24 18 4c 3b ad 50 fc ff
> RIP: crypto_remove_spawns+0x58c/0x1260 crypto/algapi.c:159 RSP:
> ffff8801d5b779e8
> ---[ end trace 14ce8f86fe2873b1 ]---
> Kernel panic - not syncing: Fatal exception
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

Fix for the actual crash now is in Linus' tree:

#syz fix: crypto: algapi - fix NULL dereference in crypto_remove_spawns()
