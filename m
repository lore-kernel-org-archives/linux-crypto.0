Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41019C28CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 15:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbiAZPBI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 10:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242451AbiAZPBI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 10:01:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5E0C06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 07:01:07 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nCjnF-0007Nd-H1; Wed, 26 Jan 2022 16:01:05 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nCjnE-000HMt-Vp; Wed, 26 Jan 2022 16:01:05 +0100
Message-ID: <c572bf6f0b0a5d7fd3f8f0744a85eb5660a003d4.camel@pengutronix.de>
Subject: Re: [PATCH] crypto: algapi - Remove test larvals to fix error paths
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 26 Jan 2022 16:01:04 +0100
In-Reply-To: <20220126145322.646723-1-p.zabel@pengutronix.de>
References: <20220126145322.646723-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2022-01-26 at 15:53 +0100, Philipp Zabel wrote:
[...]
> This can happen during cleanup if the error path is taken for a built-
> in algorithm, before crypto_algapi_init() was called.

I see this happen on ARM with CONFIG_CRYPTO_AES_ARM_BS=y since v5.16-rc1
because the simd_skcipher_create_compat("ecb(aes)", "ecb-aes-neonbs",
"__ecb-aes-neonbs") call in arch/arm/crypto/aes-neonbs-glue.c returns
-ENOENT. I believe that is the same issue as reported in [1].

[1] https://lore.kernel.org/lkml/CA+G9fYvyATAWicFbnKnOTqc=MKUXNrbCBYP6zej3FJJyA31WPQ@mail.gmail.com/

[    3.921012] ------------[ cut here ]------------
[    3.925715] kernel BUG at crypto/algapi.c:461!
[    3.930282] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[    3.936187] Modules linked in:
[    3.939318] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc1-20220124-1 #1
[    3.946614] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    3.953263] PC is at crypto_unregister_alg+0x11c/0x124
[    3.958486] LR is at __this_cpu_preempt_check+0x1c/0x20
[    3.963845] pc : [<805611d4>]    lr : [<80bac708>]    psr: 20000113
[    3.970180] sp : 81ce7e40  ip : 81ce7db0  fp : 81ce7e6c
[    3.975524] r10: 8104a878  r9 : 00000000  r8 : 000000ff
[    3.980818] r7 : 812af474  r6 : 00000001  r5 : 812af488  r4 : 82e64a80
[    3.987468] r3 : 00000002  r2 : 00000001  r1 : 00000000  r0 : 00000000
[    3.994066] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    4.001326] Control: 10c5387d  Table: 1000404a  DAC: 00000051
[    4.007139] Register r0 information: NULL pointer
[    4.011973] Register r1 information: NULL pointer
[    4.016750] Register r2 information: non-paged memory
[    4.021930] Register r3 information: non-paged memory
[    4.027053] Register r4 information: slab kmalloc-512 start 82e64a00 pointer offset 128 size 512
[    4.035991] Register r5 information: non-slab/vmalloc memory
[    4.041723] Register r6 information: non-paged memory
[    4.046899] Register r7 information: non-slab/vmalloc memory
[    4.052630] Register r8 information: non-paged memory
[    4.057807] Register r9 information: NULL pointer
[    4.062584] Register r10 information: non-slab/vmalloc memory
[    4.068456] Register r11 information: non-slab/vmalloc memory
[    4.074276] Register r12 information: non-slab/vmalloc memory
[    4.080147] Process swapper/0 (pid: 1, stack limit = 0xbd1e2d0f)
[    4.086226] Stack: (0x81ce7e40 to 0x81ce8000)
[    4.090712] 7e40: 00002080 81110580 00000000 81ce7e4c 81ce7e4c 81108ec8 00000000 82e64a00
[    4.098962] 7e60: 81ce7e7c 81ce7e70 80563044 805610c4 81ce7e94 81ce7e80 80574e94 80563034
[    4.107264] 7e80: 812af478 812af488 81ce7eac 81ce7e98 80122554 80574e80 81110580 fffffffe
[    4.115566] 7ea0: 81ce7ecc 81ce7eb0 81008f88 80122530 81da8fc0 8128f100 81108f10 81008f00
[    4.123866] 7ec0: 81ce7f4c 81ce7ed0 80102684 81008f0c 81ce7eec 81ce7ee0 80bac708 80bac500
[    4.132114] 7ee0: 81ce7f1c 81ce7ef0 80babd54 80bac6f8 00000001 81da8fc0 8128f100 81108f10
[    4.140415] 7f00: 8104a858 812af000 80fac7c4 8104a874 81ce7f2c 81ce7f20 801b91dc 81108ec8
[    4.148717] 7f20: 81ce7f4c 8107d0bc 81d240c0 00000008 8104a858 000000ff 812af000 8104a878
[    4.156964] 7f40: 81ce7f94 81ce7f50 81001428 8010260c 00000007 00000007 00000000 8100044c
[    4.165266] 7f60: 80fac7c4 8100044c 81ce7f8c 81108ec0 80bac9bc 00000000 00000000 00000000
[    4.173566] 7f80: 00000000 00000000 81ce7fac 81ce7f98 80bac9e4 8100125c 00000000 80bac9bc
[    4.181866] 7fa0: 00000000 81ce7fb0 80100108 80bac9c8 00000000 00000000 00000000 00000000
[    4.190113] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    4.198413] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    4.206709] Backtrace: 
[    4.209230]  crypto_unregister_alg from crypto_unregister_skcipher+0x1c/0x20
[    4.216417]  r4:82e64a00
[    4.219019]  crypto_unregister_skcipher from simd_skcipher_free+0x20/0x2c
[    4.225892]  simd_skcipher_free from aes_exit+0x30/0x4c
[    4.231257]  r5:812af488 r4:812af478
[    4.234900]  aes_exit from aes_init+0x88/0xa4
[    4.239393]  r5:fffffffe r4:81110580
[    4.243034]  aes_init from do_one_initcall+0x84/0x3c4
[    4.248168]  r7:81008f00 r6:81108f10 r5:8128f100 r4:81da8fc0
[    4.253949]  do_one_initcall from kernel_init_freeable+0x1d8/0x230
[    4.260218]  r10:8104a878 r9:812af000 r8:000000ff r7:8104a858 r6:00000008 r5:81d240c0
[    4.268168]  r4:8107d0bc
[    4.270769]  kernel_init_freeable from kernel_init+0x28/0x144
[    4.276656]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80bac9bc
[    4.284608]  r4:81108ec0
[    4.287208]  kernel_init from ret_from_fork+0x14/0x2c
[    4.292337] Exception stack(0x81ce7fb0 to 0x81ce7ff8)
[    4.297517] 7fa0:                                     00000000 00000000 00000000 00000000
[    4.305766] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    4.314067] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    4.320803]  r5:80bac9bc r4:00000000
[    4.324450] Code: e34800eb e58d4000 eb18fc40 eaffffe9 (e7f001f2) 
[    4.330669] ---[ end trace 0000000000000000 ]---
[    4.346697] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    4.354500] CPU2: stopping
[    4.357283] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D           5.17.0-rc1-20220124-1 #1
[    4.366022] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    4.372618] Backtrace: 
[    4.375137]  dump_backtrace from show_stack+0x20/0x24
[    4.380328]  r7:81cc3f40 r6:00000080 r5:80e968a4 r4:60000193
[    4.386055]  show_stack from dump_stack_lvl+0x60/0x78
[    4.391238]  dump_stack_lvl from dump_stack+0x18/0x1c
[    4.396369]  r7:81cc3f40 r6:8128f1a0 r5:00000002 r4:00000004
[    4.402146]  dump_stack from do_handle_IPI+0x330/0x35c
[    4.407364]  do_handle_IPI from ipi_handler+0x28/0x30
[    4.412550]  r10:bfd360b8 r9:81dc1f80 r8:81d09e38 r7:81cc3f40 r6:811096e4 r5:00000014
[    4.420447]  r4:81cc1600 r3:00000010
[    4.424142]  ipi_handler from handle_percpu_devid_irq+0xac/0x180
[    4.430229]  handle_percpu_devid_irq from generic_handle_domain_irq+0x50/0x94
[    4.437505]  r9:81dc1f80 r8:f400010c r7:81085b54 r6:81dc1f80 r5:00000004 r4:81cc4400
[    4.445367]  generic_handle_domain_irq from gic_handle_irq+0x80/0x94
[    4.451805]  r7:81085b54 r6:f4000100 r5:8123d2b4 r4:811096e4
[    4.457584]  gic_handle_irq from generic_handle_arch_irq+0x60/0x80
[    4.463847]  r9:81dc1f80 r8:00000000 r7:81d09ed0 r6:80eba814 r5:80e97b0c r4:81085b30
[    4.471707]  generic_handle_arch_irq from __irq_svc+0x54/0x88
[    4.477529] Exception stack(0x81d09ed0 to 0x81d09f18)
[    4.482706] 9ec0:                                     808ae49c 00000000 3ecb0000 00000000
[    4.490956] 9ee0: 00000001 038c318c 00000001 00000001 00000001 811116a8 bfd360b8 81d09f54
[    4.499203] 9f00: 81d09ef8 81d09f20 802434b8 808ae4a0 60000013 ffffffff
[    4.505942]  r9:81dc1f80 r8:00000001 r7:81d09f04 r6:ffffffff r5:60000013 r4:808ae4a0
[    4.513749]  cpuidle_enter_state from cpuidle_enter+0x40/0x50
[    4.519584]  r10:80eba814 r9:00000001 r8:0347bb80 r7:81108f50 r6:00000001 r5:811116a8
[    4.527535]  r4:bfd360b8
[    4.530133]  cpuidle_enter from do_idle+0x21c/0x2b4
[    4.535096]  r9:811116a8 r8:bfd360b8 r7:81108f50 r6:00000002 r5:81dc1f80 r4:81108f10
[    4.542959]  do_idle from cpu_startup_entry+0x28/0x2c
[    4.548092]  r10:00000000 r9:412fc09a r8:1000406a r7:812af324 r6:81dc1f80 r5:00000002
[    4.556043]  r4:00000097
[    4.558644]  cpu_startup_entry from secondary_start_kernel+0x174/0x198
[    4.565301]  secondary_start_kernel from 0x10101bd4
[    4.570258]  r7:812af324 r6:10c0387d r5:00000051 r4:11d6806a
[    4.576037] CPU3: stopping
[    4.578819] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D           5.17.0-rc1-20220124-1 #1
[    4.587561] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    4.594158] Backtrace: 
[    4.596732]  dump_backtrace from show_stack+0x20/0x24
[    4.601870]  r7:81cc3f40 r6:00000080 r5:80e968a4 r4:60000193
[    4.607650]  show_stack from dump_stack_lvl+0x60/0x78
[    4.612781]  dump_stack_lvl from dump_stack+0x18/0x1c
[    4.617969]  r7:81cc3f40 r6:8128f1a0 r5:00000003 r4:00000004
[    4.623695]  dump_stack from do_handle_IPI+0x330/0x35c
[    4.628912]  do_handle_IPI from ipi_handler+0x28/0x30
[    4.634099]  r10:bfd470b8 r9:81dc0fc0 r8:81d0be38 r7:81cc3f40 r6:811096e4 r5:00000014
[    4.642050]  r4:81cc1600 r3:00000010
[    4.645692]  ipi_handler from handle_percpu_devid_irq+0xac/0x180
[    4.651778]  handle_percpu_devid_irq from generic_handle_domain_irq+0x50/0x94
[    4.659053]  r9:81dc0fc0 r8:f400010c r7:81085b54 r6:81dc0fc0 r5:00000004 r4:81cc4400
[    4.666916]  generic_handle_domain_irq from gic_handle_irq+0x80/0x94
[    4.673352]  r7:81085b54 r6:f4000100 r5:8123d2b4 r4:811096e4
[    4.679132]  gic_handle_irq from generic_handle_arch_irq+0x60/0x80
[    4.685396]  r9:81dc0fc0 r8:00000000 r7:81d0bed0 r6:80eba814 r5:80e97b0c r4:81085b30
[    4.693259]  generic_handle_arch_irq from __irq_svc+0x54/0x88
[    4.699135] Exception stack(0x81d0bed0 to 0x81d0bf18)
[    4.704259] bec0:                                     808ae49c 00000000 3ecc1000 00000000
[    4.712562] bee0: 00000001 038c32da 00000001 00000001 00000001 811116a8 bfd470b8 81d0bf54
[    4.720810] bf00: 81d0bef8 81d0bf20 802434b8 808ae4a0 60000013 ffffffff
[    4.727549]  r9:81dc0fc0 r8:00000001 r7:81d0bf04 r6:ffffffff r5:60000013 r4:808ae4a0
[    4.735412]  cpuidle_enter_state from cpuidle_enter+0x40/0x50
[    4.741243]  r10:80eba814 r9:00000001 r8:0347bb80 r7:81108f50 r6:00000001 r5:811116a8
[    4.749195]  r4:bfd470b8
[    4.751796]  cpuidle_enter from do_idle+0x21c/0x2b4
[    4.756810]  r9:811116a8 r8:bfd470b8 r7:81108f50 r6:00000003 r5:81dc0fc0 r4:81108f10
[    4.764619]  do_idle from cpu_startup_entry+0x28/0x2c
[    4.769806]  r10:00000000 r9:412fc09a r8:1000406a r7:812af324 r6:81dc0fc0 r5:00000003
[    4.777703]  r4:00000097
[    4.780357]  cpu_startup_entry from secondary_start_kernel+0x174/0x198
[    4.786963]  secondary_start_kernel from 0x10101bd4
[    4.791970]  r7:812af324 r6:10c0387d r5:00000051 r4:11d6806a
[    4.797697] CPU1: stopping
[    4.800480] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D           5.17.0-rc1-20220124-1 #1
[    4.809219] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    4.815870] Backtrace: 
[    4.818389]  dump_backtrace from show_stack+0x20/0x24
[    4.823527]  r7:81cc3f40 r6:00000080 r5:80e968a4 r4:60000193
[    4.829311]  show_stack from dump_stack_lvl+0x60/0x78
[    4.834442]  dump_stack_lvl from dump_stack+0x18/0x1c
[    4.839630]  r7:81cc3f40 r6:8128f1a0 r5:00000001 r4:00000004
[    4.845357]  dump_stack from do_handle_IPI+0x330/0x35c
[    4.850628]  do_handle_IPI from ipi_handler+0x28/0x30
[    4.855761]  r10:bfd250b8 r9:81dbee40 r8:81d07e38 r7:81cc3f40 r6:811096e4 r5:00000014
[    4.863714]  r4:81cc1600 r3:00000010
[    4.867357]  ipi_handler from handle_percpu_devid_irq+0xac/0x180
[    4.873497]  handle_percpu_devid_irq from generic_handle_domain_irq+0x50/0x94
[    4.880716]  r9:81dbee40 r8:f400010c r7:81085b54 r6:81dbee40 r5:00000004 r4:81cc4400
[    4.888578]  generic_handle_domain_irq from gic_handle_irq+0x80/0x94
[    4.895067]  r7:81085b54 r6:f4000100 r5:8123d2b4 r4:811096e4
[    4.900793]  gic_handle_irq from generic_handle_arch_irq+0x60/0x80
[    4.907110]  r9:81dbee40 r8:00000000 r7:81d07ed0 r6:80eba814 r5:80e97b0c r4:81085b30
[    4.914919]  generic_handle_arch_irq from __irq_svc+0x54/0x88
[    4.920796] Exception stack(0x81d07ed0 to 0x81d07f18)
[    4.925921] 7ec0:                                     808ae49c 00000000 3ec9f000 00000000
[    4.934226] 7ee0: 00000001 038c32da 00000001 00000001 00000001 811116a8 bfd250b8 81d07f54
[    4.942528] 7f00: 81d07ef8 81d07f20 802434b8 808ae4a0 60000013 ffffffff
[    4.949214]  r9:81dbee40 r8:00000001 r7:81d07f04 r6:ffffffff r5:60000013 r4:808ae4a0
[    4.957077]  cpuidle_enter_state from cpuidle_enter+0x40/0x50
[    4.962961]  r10:80eba814 r9:00000001 r8:0347bb80 r7:81108f50 r6:00000001 r5:811116a8
[    4.970859]  r4:bfd250b8
[    4.973459]  cpuidle_enter from do_idle+0x21c/0x2b4
[    4.978474]  r9:811116a8 r8:bfd250b8 r7:81108f50 r6:00000001 r5:81dbee40 r4:81108f10
[    4.986338]  do_idle from cpu_startup_entry+0x28/0x2c
[    4.991471]  r10:00000000 r9:412fc09a r8:1000406a r7:812af324 r6:81dbee40 r5:00000001
[    4.999424]  r4:00000097
[    5.002025]  cpu_startup_entry from secondary_start_kernel+0x174/0x198
[    5.008683]  secondary_start_kernel from 0x10101bd4
[    5.013639]  r7:812af324 r6:10c0387d r5:00000051 r4:11d6806a
[    5.034197] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

regards
Philipp
