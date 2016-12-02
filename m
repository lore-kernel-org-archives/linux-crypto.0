From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: Crash in crypto mcryptd
Date: Thu, 01 Dec 2016 17:47:02 -0800
Message-ID: <1480643222.3064.52.camel@linux.intel.com>
References: <alpine.LRH.2.02.1612011819540.27565@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Megha Dey <megha.dey@linux.intel.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35228 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752147AbcLBBrE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 20:47:04 -0500
In-Reply-To: <alpine.LRH.2.02.1612011819540.27565@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-12-01 at 19:00 -0500, Mikulas Patocka wrote:
> Hi
> 
> There is a bug in mcryptd initialization.
> 
> This is a test module that tries various hash algorithms. When you load 
> the module with "insmod test.ko 'alg=mcryptd(md5)'", the machine crashes.

I don't think your test setup is right.  The mcryptd supports only multi-buffer
algorithm.  I don't think there is such an implementation for md5.

Please refer to arch/x86/crypto/sha1-mb 
multi-buffer implementation of sha1 to see the proper
setup and usage with mcryptd.  You can also run tcrypt test to
exercise this code.

Tim

> 
> Mikulas
> 
> 
> #include <linux/module.h>
> #include <linux/init.h>
> #include <crypto/hash.h>
> 
> static char *alg = "md5";
> 
> module_param_named(alg, alg, charp, 0444);
> MODULE_PARM_DESC(alg, "the algorith to test");
> 
> static bool sync = true;
> 
> module_param_named(sync, sync, bool, 0444);
> MODULE_PARM_DESC(alg, "sync flag");
> 
> static int __init dump_init(void)
> {
>         struct crypto_shash *h;
>         char key[4];
>         int r;
>         printk("testing algorithm '%s'\n", alg);
>         h = crypto_alloc_shash(alg, 0, sync ? CRYPTO_ALG_ASYNC : 0);
>         if (IS_ERR(h)) {
>                 printk("error %d\n", (int)PTR_ERR(h));
>                 return PTR_ERR(h);
>         }
>         printk("setting key\n");
>         r = crypto_shash_setkey(h, key, sizeof key);
>         if (r)
>                 printk("setkey: %d\n", r);
>         crypto_free_shash(h);
>         printk("module loaded\n");
>         return 0;
> }
> 
> static void __exit dump_exit(void)
> {
>         printk("dump exit\n");
> }
> 
> module_init(dump_init)
> module_exit(dump_exit)
> MODULE_LICENSE("GPL");
> 
> 
> [898029.802035] BUG: unable to handle kernel NULL pointer dereference at           
> (null)
> [898029.806060] IP: [<ffffffffa022014d>] md5_final+0xad/0x210 [md5]
> [898029.808156] PGD 11a5d8067 [898029.809051] PUD 11a491067 
> PMD 0 [898029.810280] 
> [898029.810904] Oops: 0002 [#1] PREEMPT SMP
> [898029.812239] Modules linked in: md5 testdump(O+) mcryptd uvesafb 
> cfbfillrect cfbimgblt cn cfbcopyarea fbcon bitblit fbcon_rotate fbcon_ccw 
> fbcon_ud fbcon_cw softcursor fb fbdev font ipv6 binfmt_misc mousedev 
> af_packet psmouse pcspkr virtio_net virtio_balloon button ext4 crc16 jbd2 
> mbcache dm_mod virtio_blk evdev virtio_pci virtio_ring virtio
> [898029.817178] CPU: 9 PID: 187 Comm: kworker/9:1 Tainted: G           O    
> 4.9.0-rc7+ #6
> [898029.818066] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [898029.818732] Workqueue: crypto mcryptd_queue_worker [mcryptd]
> [898029.819394] task: ffff88011aa2bd80 task.stack: ffff880118480000
> [898029.820077] RIP: 0010:[<ffffffffa022014d>]  [<ffffffffa022014d>] 
> md5_final+0xad/0x210 [md5]
> [898029.821050] RSP: 0018:ffff880118483d48  EFLAGS: 00010286
> [898029.821661] RAX: 04b2008fd98c1dd4 RBX: ffff880119cd7f28 RCX: 
> 00000000980980e9
> [898029.822464] RDX: 7e42f8ec980980e9 RSI: 00000000ef1c4f74 RDI: 
> ffff880119cd7f30
> [898029.823293] RBP: ffff880118483d68 R08: 000000001b99d513 R09: 
> 0000000000000000
> [898029.824117] R10: 0000000000000000 R11: 00000000b8b56373 R12: 
> ffff880119cd7f18
> [898029.824944] R13: 0000000000000000 R14: ffff880119cd7f38 R15: 
> ffffffffa01ee43c
> [898029.825776] FS:  0000000000000000(0000) GS:ffff88011fd20000(0000) 
> knlGS:0000000000000000
> [898029.826712] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [898029.827376] CR2: 0000000000000000 CR3: 000000011a6c9000 CR4: 
> 00000000000006a0
> [898029.828204] Stack:
> [898029.828452]  ffff880119cd7f18 ffff88011fd3bb00 0000000000000000 
> ffff880119cd7e00
> [898029.829351]  ffff880118483da0 ffffffff8119f281 ffff880119cd7f18 
> ffff88011fd3bb00
> [898029.830242]  ffff88011fd3bae0 ffff880119cd7e00 ffffffffa01ee43c 
> ffff880119cd7ec8
> [898029.831141] Call Trace:
> [898029.831460]  [<ffffffff8119f281>] ? crypto_shash_final+0x31/0xb0
> [898029.832151]  [<ffffffffa01ee43c>] ? mcryptd_queue_worker+0x1c/0x190 
> [mcryptd]
> [898029.832980]  [<ffffffff8119f743>] ? shash_ahash_finup+0x73/0x80
> [898029.833672]  [<ffffffff81016a5f>] ? __switch_to+0x27f/0x460
> [898029.834305]  [<ffffffffa01eeabf>] ? mcryptd_hash_digest+0x4f/0x80 
> [mcryptd]
> [898029.835125]  [<ffffffffa01ee467>] ? mcryptd_queue_worker+0x47/0x190 
> [mcryptd]
> [898029.835963]  [<ffffffff8105974f>] ? process_one_work+0x1bf/0x3f0
> [898029.836681]  [<ffffffff810599c2>] ? worker_thread+0x42/0x4c0
> [898029.837362]  [<ffffffff81059980>] ? process_one_work+0x3f0/0x3f0
> [898029.838045]  [<ffffffff81059980>] ? process_one_work+0x3f0/0x3f0
> [898029.838739]  [<ffffffff8105ea49>] ? kthread+0xb9/0xd0
> [898029.839318]  [<ffffffff8105e990>] ? kthread_park+0x70/0x70
> [898029.839959]  [<ffffffff8131b965>] ? ret_from_fork+0x25/0x30
> [898029.840594] Code: 14 c5 00 00 00 00 48 c1 e8 1d 41 89 44 24 5c 41 89 
> 54 24 58 e8 45 ea 0e e1 49 8b 44 24 10 49 8b 54 24 18 48 8d 7b 08 48 83 e7 
> f8 <49> 89 45 00 49 89 55 08 31 c0 49 c7 44 24 10 00 00 00 00 48 c7 
> [898029.843633] RIP  [<ffffffffa022014d>] md5_final+0xad/0x210 [md5]
> [898029.844354]  RSP <ffff880118483d48>
> [898029.844769] CR2: 0000000000000000
> [898029.845166] ---[ end trace 2ecde0bf66717337 ]---
> 
