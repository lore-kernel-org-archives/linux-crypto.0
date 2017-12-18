From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in __list_del_entry_valid (2)
Date: Mon, 18 Dec 2017 07:36:00 +0100
Message-ID: <14556514.LfxTAgkPiZ@tauon.chronox.de>
References: <94eb2c05a380d3908b056096eb58@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+29cf0a34886ca39d13fc0451b174140973b5bed3@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44384 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbdLRGgD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 01:36:03 -0500
In-Reply-To: <94eb2c05a380d3908b056096eb58@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Dezember 2017, 06:50:01 CET schrieb syzbot:

Hi,

> Hello,
> 
> syzkaller hit the following crash on
> 82bcf1def3b5f1251177ad47c44f7e17af039b4b
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> ==================================================================
> BUG: KASAN: use-after-free in __list_del_entry_valid+0x11d/0x150
> lib/list_debug.c:42
> Read of size 8 at addr ffff8801c4471248 by task syzkaller960526/6767
> 
> CPU: 0 PID: 6767 Comm: syzkaller960526 Not tainted 4.15.0-rc2-mm1+ #39
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:17 [inline]
>   dump_stack+0x194/0x257 lib/dump_stack.c:53
>   print_address_description+0x73/0x250 mm/kasan/report.c:252
>   kasan_report_error mm/kasan/report.c:351 [inline]
>   kasan_report+0x25b/0x340 mm/kasan/report.c:409
>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:430
>   __list_del_entry_valid+0x11d/0x150 lib/list_debug.c:42
>   __list_del_entry include/linux/list.h:117 [inline]
>   list_del include/linux/list.h:125 [inline]
>   crypto_larval_kill+0x79/0x2e0 crypto/api.c:164
>   crypto_alg_mod_lookup+0x178/0x1b0 crypto/api.c:283
>   crypto_find_alg crypto/api.c:501 [inline]
>   crypto_alloc_tfm+0xf3/0x2f0 crypto/api.c:534
>   crypto_alloc_aead+0x2c/0x40 crypto/aead.c:342
>   aead_bind+0x70/0x140 crypto/algif_aead.c:482
>   alg_bind+0x1ab/0x440 crypto/af_alg.c:179
>   SYSC_bind+0x1b4/0x3f0 net/socket.c:1454
>   SyS_bind+0x24/0x30 net/socket.c:1440
>   entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x4406f9
> RSP: 002b:00007ffe2d384878 EFLAGS: 00000203 ORIG_RAX: 0000000000000031
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004406f9
> RDX: 0000000000000058 RSI: 0000000020269000 RDI: 0000000000000003
> RBP: 000000000000ac2d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000203 R12: 0000000000000000
> R13: 0000000000401c30 R14: 0000000000000000 R15: 0000000000000000

This bug seems to be triggerable again by the fact that some strange mask/type 
combo is used. When setting it to zero, there is no crash.

Therefore I would see that this issue would be covered with the fix that we 
currently work on to limit the number of allowed mask/type values.

Ciao
Stephan
