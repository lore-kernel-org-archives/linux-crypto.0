From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: [PATCH] crypto: crypto4xx - Perform read/modify/write on device
 control register
Date: Tue, 21 Jun 2011 08:13:21 -0400
Message-ID: <20110621121321.GA2414@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: James Hsiao <jhsiao@amcc.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48975 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1FUMLs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2011 08:11:48 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5LBhjso003523
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2011 07:43:45 -0400
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5LCBlWp148276
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2011 08:11:47 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5LCBiio012270
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2011 06:11:46 -0600
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Security function on the AMCC SoCs has multiple engines within a
single MMIO range.  The crypto driver currently enables the 3DES
functionality by doing a blind write to the device control register.
This can unintentionally disable other functions like the PKA or TRNG
when the driver is loaded.

Perform a read/modify/write to enable the 3DES function instead.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 1891252..1d103f9 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -51,6 +51,7 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	union ce_io_threshold io_threshold;
 	u32 rand_num;
 	union ce_pe_dma_cfg pe_dma_cfg;
+	u32 device_ctrl;
 
 	writel(PPC4XX_BYTE_ORDER, dev->ce_base + CRYPTO4XX_BYTE_ORDER_CFG);
 	/* setup pe dma, include reset sg, pdr and pe, then release reset */
@@ -84,7 +85,9 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	writel(ring_size.w, dev->ce_base + CRYPTO4XX_RING_SIZE);
 	ring_ctrl.w = 0;
 	writel(ring_ctrl.w, dev->ce_base + CRYPTO4XX_RING_CTRL);
-	writel(PPC4XX_DC_3DES_EN, dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
+	device_ctrl = readl(dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
+	device_ctrl |= PPC4XX_DC_3DES_EN;
+	writel(device_ctrl, dev->ce_base + CRYPTO4XX_DEVICE_CTRL);
 	writel(dev->gdr_pa, dev->ce_base + CRYPTO4XX_GATH_RING_BASE);
 	writel(dev->sdr_pa, dev->ce_base + CRYPTO4XX_SCAT_RING_BASE);
 	part_ring_size.w = 0;
