From: Christian Lamparter <chunkeey@googlemail.com>
Subject: crash in ppc4xx-rng on canyonland
Date: Fri, 25 Mar 2016 19:29:38 +0100
Message-ID: <2309246.SDn0H6XuZk@debian64>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: jwboyer@linux.vnet.ibm.com, mpm@selenic.com,
	herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34824 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbcCYS3n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Mar 2016 14:29:43 -0400
Received: by mail-wm0-f48.google.com with SMTP id l68so25795531wml.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Mar 2016 11:29:42 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm currently trying to port a Western Digital MyBook Live to
a 4.4.6 kernel. The device has a APM82181 and the board is called
Apollo-3G, which is a derivative of the "amcc,canyonland".

Almost everything is working, except when I try to enable the
ppc4xx-rng in the dts. Then the machine dies with the following:

[    0.801839] Machine check in kernel mode.
[    0.805830] Data Read PLB Error
[    0.808962] Oops: Machine check, sig: 7 [#1]
[    0.813208] Canyonlands
[    0.815646] Modules linked in:
[    0.818710] CPU: 0 PID: 1 Comm: swapper Not tainted 4.4.6 #39
[    0.824436] task: cf830000 ti: cfff2000 task.ti: cf834000
[    0.829808] NIP: c01b9a00 LR: c01b99e8 CTR: 00000000
[    0.834751] REGS: cfff3f10 TRAP: 0214   Not tainted  (4.4.6)
[    0.840382] MSR: 00029000 <CE,EE,ME>  CR: 820c3222  XER: 00000000
[    0.846515] 
GPR00: c01b99e8 cf835d50 cf830000 d1080000 d1100000 cf857800 00200000 00000004 
GPR08: 00000000 d10e0000 d10e0080 0020051b 820c3428 00000000 c0001c54 00000000 
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 c0420000 c03d7290 
GPR24: 00000043 00000000 c044e1cc c03a500f 00000001 00000000 cfffb9b8 00000005 
[    0.876429] NIP [c01b9a00] ppc4xx_rng_enable+0xec/0x12c
[    0.881634] LR [c01b99e8] ppc4xx_rng_enable+0xd4/0x12c
[    0.886752] Call Trace:
[    0.889194] [cf835d50] [c01b99e8] ppc4xx_rng_enable+0xd4/0x12c (unreliable)
[    0.896141] [cf835db0] [c01b9ab8] ppc4xx_rng_probe+0x2c/0x80
[    0.901791] [cf835dc0] [c01c0614] platform_drv_probe+0x34/0x70
[    0.907606] [cf835dd0] [c01beda8] driver_probe_device+0x110/0x264
[    0.913679] [cf835e00] [c01bef74] __driver_attach+0x78/0xac
[    0.919243] [cf835e20] [c01bd300] bus_for_each_dev+0x9c/0xac
[    0.924885] [cf835e50] [c01be49c] bus_add_driver+0xe0/0x1fc
[    0.930441] [cf835e70] [c01bf688] driver_register+0xb4/0x104
[    0.936086] [cf835e90] [c0001704] do_one_initcall+0x11c/0x1ac
[    0.941825] [cf835f00] [c03d7af0] kernel_init_freeable+0x128/0x1c4
[    0.947989] [cf835f30] [c0001c68] kernel_init+0x14/0x114
[    0.953288] [cf835f40] [c000a748] ret_from_kernel_thread+0x5c/0x64
[    0.959449] Instruction dump:
[    0.962415] 2f9f0004 3bff0001 409effa8 38800000 7fc3f378 4806f6c5 2c030000 41a2ff68 
[    0.970197] 3d230006 39490080 7c0004ac 7d00542c <0c080000> 4c00012c 2f9c0000 550a03da 
[    0.978180] ---[ end trace cff1212128646932 ]---

The crash is caused by a bad read in ppc4xx_rng_enable [0]. From what I
can tell, the driver is mapping the crypto control registers. The
problem is that they are claimed by the main crypto driver: crypto4xx [1].

I'm not sure what to do in this case. In my opinion the crypto4xx driver
should just initialize the trng [see patch]. I would like to move the
trng into the crypto-ppc4xx, but given that this breaks some of the DTS
out there I'm not sure.

Regards,
Christian
---
>From 2159e200fcb68f88a94b1d5570d6000c100133a8 Mon Sep 17 00:00:00 2001
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 25 Mar 2016 19:00:05 +0100
Subject: [PATCH] ppc4xx-rng: fix crash during init

This patch fixes a crash that happens in the ppc4xx-rng driver
when accessing the main crypto core to enable the true random
number generator.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/char/hw_random/ppc4xx-rng.c     | 42 ---------------------------------
 drivers/crypto/amcc/crypto4xx_core.c    |  1 +
 drivers/crypto/amcc/crypto4xx_reg_def.h |  1 +
 3 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index c0db438..a9a8a29 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -17,9 +17,6 @@
 #include <linux/of_platform.h>
 #include <asm/io.h>
 
-#define PPC4XX_TRNG_DEV_CTRL 0x60080
-
-#define PPC4XX_TRNGE 0x00020000
 #define PPC4XX_TRNG_CTRL 0x0008
 #define PPC4XX_TRNG_CTRL_DALM 0x20
 #define PPC4XX_TRNG_STAT 0x0004
@@ -51,40 +48,6 @@ static int ppc4xx_rng_data_read(struct hwrng *rng, u32 *data)
 	return 4;
 }
 
-static int ppc4xx_rng_enable(int enable)
-{
-	struct device_node *ctrl;
-	void __iomem *ctrl_reg;
-	int err = 0;
-	u32 val;
-
-	/* Find the main crypto device node and map it to turn the TRNG on */
-	ctrl = of_find_compatible_node(NULL, NULL, "amcc,ppc4xx-crypto");
-	if (!ctrl)
-		return -ENODEV;
-
-	ctrl_reg = of_iomap(ctrl, 0);
-	if (!ctrl_reg) {
-		err = -ENODEV;
-		goto out;
-	}
-
-	val = in_le32(ctrl_reg + PPC4XX_TRNG_DEV_CTRL);
-
-	if (enable)
-		val |= PPC4XX_TRNGE;
-	else
-		val = val & ~PPC4XX_TRNGE;
-
-	out_le32(ctrl_reg + PPC4XX_TRNG_DEV_CTRL, val);
-	iounmap(ctrl_reg);
-
-out:
-	of_node_put(ctrl);
-
-	return err;
-}
-
 static struct hwrng ppc4xx_rng = {
 	.name = MODULE_NAME,
 	.data_present = ppc4xx_rng_data_present,
@@ -100,10 +63,6 @@ static int ppc4xx_rng_probe(struct platform_device *dev)
 	if (!rng_regs)
 		return -ENODEV;
 
-	err = ppc4xx_rng_enable(1);
-	if (err)
-		return err;
-
 	out_le32(rng_regs + PPC4XX_TRNG_CTRL, PPC4XX_TRNG_CTRL_DALM);
 	ppc4xx_rng.priv = (unsigned long) rng_regs;
 
@@ -117,7 +76,6 @@ static int ppc4xx_rng_remove(struct platform_device *dev)
 	void __iomem *rng_regs = (void __iomem *) ppc4xx_rng.priv;
 
 	hwrng_unregister(&ppc4xx_rng);
-	ppc4xx_rng_enable(0);
 	iounmap(rng_regs);
 
 	return 0;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 62134c8..cb0b262 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -90,6 +90,7 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	writel(ring_ctrl.w, dev->ce_base + CRYPTO4XX_RING_CTRL);
 	device_ctrl = readl(dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
 	device_ctrl |= PPC4XX_DC_3DES_EN;
+	device_ctrl |= PPC4XX_TRNGE;
 	writel(device_ctrl, dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
 	writel(dev->gdr_pa, dev->ce_base + CRYPTO4XX_GATH_RING_BASE);
 	writel(dev->sdr_pa, dev->ce_base + CRYPTO4XX_SCAT_RING_BASE);
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 5f5fbc0..914efc6 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -124,6 +124,7 @@
 #define PPC4XX_BYTE_ORDER			0x22222
 #define PPC4XX_INTERRUPT_CLR			0x3ffff
 #define PPC4XX_PRNG_CTRL_AUTO_EN		0x3
+#define PPC4XX_TRNGE				0x00020000
 #define PPC4XX_DC_3DES_EN			1
 #define PPC4XX_INT_DESCR_CNT			4
 #define PPC4XX_INT_TIMEOUT_CNT			0
-- 
2.8.0.rc3

[0] <http://lxr.free-electrons.com/source/drivers/char/hw_random/ppc4xx-rng.c#L72>
[1] <http://lxr.free-electrons.com/source/drivers/crypto/amcc/>
