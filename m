From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in crypto_aead_free_instance
Date: Wed, 20 Dec 2017 14:37:36 -0800
Message-ID: <20171220223736.GD38504@gmail.com>
References: <001a11c14bc887c2c60560c0cdda@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+e5e6fab2d4dc3d9877ac240fed364027bb960ad0@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:45286 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754428AbdLTWhk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 17:37:40 -0500
Content-Disposition: inline
In-Reply-To: <001a11c14bc887c2c60560c0cdda@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 11:48:01PM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 032b4cc8ff84490c4bc7c4ef8c91e6d83a637538
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> ==================================================================
> BUG: KASAN: use-after-free in crypto_aead_free_instance+0xc0/0xd0
> crypto/aead.c:154
> Read of size 8 at addr ffff8801c32cf240 by task cryptomgr_test/6646
> 
> CPU: 1 PID: 6646 Comm: cryptomgr_test Not tainted 4.15.0-rc3+ #132
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:430
>  crypto_aead_free_instance+0xc0/0xd0 crypto/aead.c:154
>  crypto_free_instance+0x6d/0x100 crypto/algapi.c:77
>  crypto_destroy_instance+0x3c/0x80 crypto/algapi.c:85
>  crypto_alg_put crypto/internal.h:116 [inline]
>  crypto_remove_final+0x212/0x370 crypto/algapi.c:331
>  crypto_alg_tested+0x445/0x6f0 crypto/algapi.c:320
>  cryptomgr_test+0x17/0x30 crypto/algboss.c:226
>  kthread+0x37a/0x440 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:441
> 
> Allocated by task 6641:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kmem_cache_alloc_trace+0x136/0x750 mm/slab.c:3610
>  kmalloc include/linux/slab.h:499 [inline]
>  kzalloc include/linux/slab.h:688 [inline]
>  pcrypt_create_aead crypto/pcrypt.c:291 [inline]
>  pcrypt_create+0x137/0x6c0 crypto/pcrypt.c:346
>  cryptomgr_probe+0x74/0x240 crypto/algboss.c:75
>  kthread+0x37a/0x440 kernel/kthread.c:238
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:441
> 
> Freed by task 3335:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3488 [inline]
>  kfree+0xca/0x250 mm/slab.c:3803
>  crypto_larval_destroy+0x110/0x150 crypto/api.c:107
>  crypto_alg_put crypto/internal.h:116 [inline]
>  crypto_larval_kill+0x1e8/0x2e0 crypto/api.c:167
>  crypto_alg_mod_lookup+0x178/0x1b0 crypto/api.c:283
>  crypto_find_alg crypto/api.c:501 [inline]
>  crypto_alloc_tfm+0xf3/0x2f0 crypto/api.c:534
>  crypto_alloc_aead+0x2c/0x40 crypto/aead.c:342
>  aead_bind+0x70/0x140 crypto/algif_aead.c:482
>  alg_bind+0x1ab/0x440 crypto/af_alg.c:179
>  SYSC_bind+0x1b4/0x3f0 net/socket.c:1454
>  SyS_bind+0x24/0x30 net/socket.c:1440
>  do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
>  do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
>  entry_SYSENTER_compat+0x51/0x60 arch/x86/entry/entry_64_compat.S:125
> 

Probably the pcrypt_free() bug.

#syz dup: KASAN: use-after-free Read in __list_del_entry_valid (2)
