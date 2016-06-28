From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: crypto: tcrypt - Fix memory leaks/crashes in multibuffer hash
 speed test
Date: Tue, 28 Jun 2016 12:15:43 +0200
Message-ID: <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au> <57723A08.1010704@samsung.com> <20160628095511.GA16644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Megha Dey <megha.dey@linux.intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35959 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcF1LRV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 07:17:21 -0400
In-Reply-To: <20160628095511.GA16644@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 28, 2016 at 11:55 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> This patch resolves a number of issues with the mb speed test
> function:
>
> * The tfm is never freed.
> * Memory is allocated even when we're not using mb.
> * When an error occurs we don't wait for completion for other requests.
> * When an error occurs during allocation we may leak memory.
> * The test function ignores plen but still runs for plen != blen.
> * The backlog flag is incorrectly used (may crash).
>
> This patch tries to resolve all these issues as well as making
> the code consistent with the existing hash speed testing function.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

Oops:

[root@odroidxu3 ~]# modprobe tcrypt mode=422
[   23.466899]
[   23.466899] testing speed of multibuffer sha1 (sha1-neon)
[   23.472517] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):
[   23.480312] BUG: spinlock bad magic on CPU#5, modprobe/285
[   23.484918]  lock: 0xecab06a8, .magic: 00000000, .owner: <none>/-1,
.owner_cpu: 0
[   23.492374] CPU: 5 PID: 285 Comm: modprobe Not tainted
4.7.0-rc5-next-20160628-00003-g28618d2d8c0b #862
[   23.501724] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   23.507828] [<c010d738>] (unwind_backtrace) from [<c010a4b0>]
(show_stack+0x10/0x14)
[   23.515526] [<c010a4b0>] (show_stack) from [<c031f06c>]
(dump_stack+0x74/0x94)
[   23.522711] [<c031f06c>] (dump_stack) from [<c0156f78>]
(do_raw_spin_lock+0x160/0x1a8)
[   23.530605] [<c0156f78>] (do_raw_spin_lock) from [<c06bd34c>]
(wait_for_common+0x20/0x144)
[   23.538853] [<c06bd34c>] (wait_for_common) from [<bf157898>]
(test_mb_ahash_speed.constprop.2+0x20c/0x354 [tcrypt])
[   23.549196] [<bf157898>] (test_mb_ahash_speed.constprop.2 [tcrypt])
from [<bf159284>] (do_test+0x12c4/0x32ec [tcrypt])
[   23.559848] [<bf159284>] (do_test [tcrypt]) from [<bf15f048>]
(tcrypt_mod_init+0x48/0xa4 [tcrypt])
[   23.568776] [<bf15f048>] (tcrypt_mod_init [tcrypt]) from
[<c010178c>] (do_one_initcall+0x3c/0x16c)
[   23.577703] [<c010178c>] (do_one_initcall) from [<c0193370>]
(do_init_module+0x5c/0x1ac)
[   23.585764] [<c0193370>] (do_init_module) from [<c018659c>]
(load_module+0x1a30/0x1d08)
[   23.593731] [<c018659c>] (load_module) from [<c0186a3c>]
(SyS_finit_module+0x8c/0x98)
[   23.601530] [<c0186a3c>] (SyS_finit_module) from [<c0107900>]
(ret_fast_syscall+0x0/0x3c)
[   23.609677] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   23.617728] pgd = ec888000
[   23.620406] [00000000] *pgd=6ddc7835, *pte=00000000, *ppte=00000000
[   23.626646] Internal error: Oops: 817 [#1] PREEMPT SMP ARM
[   23.632106] Modules linked in: sha1_generic sha1_arm_neon sha1_arm
tcrypt(+) s5p_jpeg s5p_mfc v4l2_mem2mem videobuf2_dma_contig
v4l2_common videobuf2_memops videobuf2_v4l2 videobuf2_core videodev
media
[   23.649956] CPU: 5 PID: 285 Comm: modprobe Not tainted
4.7.0-rc5-next-20160628-00003-g28618d2d8c0b #862
[   23.659323] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   23.665383] task: eddcf800 ti: ec974000 task.ti: ec974000
[   23.670757] PC is at wait_for_common+0x6c/0x144
[   23.675262] LR is at unwind_frame+0x68/0x564
[   23.679507] pc : [<c06bd398>]    lr : [<c010d23c>]    psr: 60070093
[   23.679507] sp : ec975d30  ip : eddcf800  fp : 00000000
[   23.690953] r10: 00000000  r9 : 00000001  r8 : 00000000
[   23.696144] r7 : 00000002  r6 : ecab06a4  r5 : ecab06a8  r4 : 7fffffff
[   23.702644] r3 : 00000000  r2 : ec975d40  r1 : ecab06b8  r0 : 00000001
[   23.709141] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[   23.716335] Control: 10c5387d  Table: 6c88806a  DAC: 00000051
[   23.722050] Process modprobe (pid: 285, stack limit = 0xec974210)
[   23.728116] Stack: (0xec975d30 to 0xec976000)
[   23.732450] 5d20:                                     bf15c0c0
00000001 eddcf800 c013aa58
[   23.740601] 5d40: ecab06b8 00000000 00000000 00000008 bf15c0b4
ecab0620 bf15c0c0 ecab06a4
[   23.748746] 5d60: 00000000 bf157898 00000001 ee3f6110 ecab0000
2196bd9e ec8af480 ec8af4c0
[   23.756891] 5d80: 00000001 2196bd9e 000000c3 bf15c640 bf15c640
edee7940 bf15c4c0 bf15f000
[   23.765037] 5da0: 00000124 00000000 c0183918 bf159284 bf15c640
edee7940 00000010 bf15c640
[   23.773182] 5dc0: edee7940 bf15c4c0 bf15f000 00000124 00000000
bf15f048 bf15c4c0 00000001
[   23.781328] 5de0: edee7940 c010178c ffffff04 ecac8000 00000000
8040003e ee801b80 8040003f
[   23.789473] 5e00: c0b13154 c0a67b60 ef5e5000 ee801f00 c0183918
8040003e 00000080 ef5e5000
[   23.797618] 5e20: ee801f00 ee801f00 c0a67b60 c0b025ac c0183918
c01d37dc bf15c4c0 00000001
[   23.805764] 5e40: edee7940 bf15c4c0 00000001 00000124 00000003
c0193370 ec975f4c 00000001
[   23.813909] 5e60: edee7880 ec975f4c 00000001 edee7880 bf15c4c0
c018659c bf15c4cc 00007fff
[   23.822055] 5e80: bf15c4c0 c0184168 ed6f0300 00000000 c018398c
bf15c508 bf15c664 00000000
[   23.830201] 5ea0: bf15c4cc bf15c628 00000000 0000b320 00000000
ec975f3c ec975f40 c01e17fc
[   23.838346] 5ec0: 0000b320 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   23.846491] 5ee0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   23.854637] 5f00: 7fffffff 7fffffff 00000000 00000000 0003ff70
c0107ac4 ec974000 00000000
[   23.862782] 5f20: 0003fe38 c0186a3c 7fffffff 00000000 00000003
0000b320 ed6f0300 f2781000
[   23.870928] 5f40: 0000b320 00000000 bedfb924 f2781000 0000b320
f2787a88 f278792b f2788b00
[   23.879074] 5f60: 00006664 00006c84 00000000 00000000 00000000
000012bc 00000021 00000022
[   23.887219] 5f80: 00000019 00000000 00000015 00000000 00000000
0003fe08 00000008 0003e240
[   23.895364] 5fa0: 0000017b c0107900 0003fe08 00000008 00000003
0003ff70 00000000 00000000
[   23.903510] 5fc0: 0003fe08 00000008 0003e240 0000017b 0003ff70
00000008 0003ff70 0003fe38
[   23.911655] 5fe0: bedfb928 bedfb918 00020b08 b6e206e0 60070010
00000003 00000000 00000000
[   23.919806] [<c06bd398>] (wait_for_common) from [<bf157898>]
(test_mb_ahash_speed.constprop.2+0x20c/0x354 [tcrypt])
[   23.930206] [<bf157898>] (test_mb_ahash_speed.constprop.2 [tcrypt])
from [<bf159284>] (do_test+0x12c4/0x32ec [tcrypt])
[   23.940865] [<bf159284>] (do_test [tcrypt]) from [<bf15f048>]
(tcrypt_mod_init+0x48/0xa4 [tcrypt])
[   23.949787] [<bf15f048>] (tcrypt_mod_init [tcrypt]) from
[<c010178c>] (do_one_initcall+0x3c/0x16c)
[   23.958710] [<c010178c>] (do_one_initcall) from [<c0193370>]
(do_init_module+0x5c/0x1ac)
[   23.966769] [<c0193370>] (do_init_module) from [<c018659c>]
(load_module+0x1a30/0x1d08)
[   23.974741] [<c018659c>] (load_module) from [<c0186a3c>]
(SyS_finit_module+0x8c/0x98)
[   23.982539] [<c0186a3c>] (SyS_finit_module) from [<c0107900>]
(ret_fast_syscall+0x0/0x3c)
[   23.990685] Code: e28d2010 e98d1001 e5862018 e58d1010 (e5832000)
[   23.996749] ---[ end trace ba7506845ca39b55 ]---
[   24.001338] note: modprobe[285] exited with preempt_count 1
Segmentation fault

Best regards,
Krzysztof
