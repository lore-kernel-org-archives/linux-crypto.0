Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921B7C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DAF7217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389220AbfDRNjv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:39:51 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33492 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfDRNju (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:39:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DB3980D;
        Thu, 18 Apr 2019 06:39:50 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 827DC3F5AF;
        Thu, 18 Apr 2019 06:39:48 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/35] crypto: ccree: add CPP completion handling
Date:   Thu, 18 Apr 2019 16:38:40 +0300
Message-Id: <20190418133913.9122-6-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the logic needed to track and report CPP operation rejection.
The new logic will be used by the CPP feature introduced later.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_crypto_ctx.h  |   8 ++
 drivers/crypto/ccree/cc_driver.c      |  25 +++++--
 drivers/crypto/ccree/cc_driver.h      |  28 +++++++
 drivers/crypto/ccree/cc_host_regs.h   |  75 ++++++++++++++++++-
 drivers/crypto/ccree/cc_request_mgr.c | 103 +++++++++++++++++++-------
 5 files changed, 200 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/ccree/cc_crypto_ctx.h b/drivers/crypto/ccree/cc_crypto_ctx.h
index c8dac273c563..97e56e9af01e 100644
--- a/drivers/crypto/ccree/cc_crypto_ctx.h
+++ b/drivers/crypto/ccree/cc_crypto_ctx.h
@@ -55,6 +55,14 @@
 
 #define CC_DRV_ALG_MAX_BLOCK_SIZE CC_HASH_BLOCK_SIZE_MAX
 
+#define CC_CPP_NUM_SLOTS	8
+#define CC_CPP_NUM_ALGS		2
+
+enum cc_cpp_alg {
+	CC_CPP_SM4 = 1,
+	CC_CPP_AES = 0
+};
+
 enum drv_engine_type {
 	DRV_ENGINE_NULL = 0,
 	DRV_ENGINE_AES = 1,
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 255d2367bfa8..1cded418f223 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -118,12 +118,12 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
-	if (irr & CC_COMP_IRQ_MASK) {
-		/* Mask AXI completion interrupt - will be unmasked in
-		 * Deferred service handler
+	if (irr & drvdata->comp_mask) {
+		/* Mask all completion interrupts - will be unmasked in
+		 * deferred service handler
 		 */
-		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_COMP_IRQ_MASK);
-		irr &= ~CC_COMP_IRQ_MASK;
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | drvdata->comp_mask);
+		irr &= ~drvdata->comp_mask;
 		complete_request(drvdata);
 	}
 #ifdef CONFIG_CRYPTO_FIPS
@@ -175,7 +175,7 @@ int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
 	cc_iowrite(drvdata, CC_REG(HOST_ICR), val);
 
 	/* Unmask relevant interrupt cause */
-	val = CC_COMP_IRQ_MASK | CC_AXI_ERR_IRQ_MASK;
+	val = drvdata->comp_mask | CC_AXI_ERR_IRQ_MASK;
 
 	if (drvdata->hw_rev >= CC_HW_REV_712)
 		val |= CC_GPR0_IRQ_MASK;
@@ -235,6 +235,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		new_drvdata->ver_offset = CC_REG(HOST_VERSION_630);
 	}
 
+	new_drvdata->comp_mask = CC_COMP_IRQ_MASK;
+
 	platform_set_drvdata(plat_dev, new_drvdata);
 	new_drvdata->plat_dev = plat_dev;
 
@@ -315,6 +317,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		return rc;
 	}
 
+	new_drvdata->sec_disabled = cc_sec_disable;
+
 	if (hw_rev->rev <= CC_HW_REV_712) {
 		/* Verify correct mapping */
 		val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
@@ -328,10 +332,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	} else {
 		val = cc_ioread(new_drvdata, CC_REG(SECURITY_DISABLED));
 		val &= CC_SECURITY_DISABLED_MASK;
-		new_drvdata->sec_disabled = !!val;
+		new_drvdata->sec_disabled |= !!val;
+
+		if (!new_drvdata->sec_disabled) {
+			new_drvdata->comp_mask |= CC_CPP_SM4_ABORT_MASK;
+			if (new_drvdata->std_bodies & CC_STD_NIST)
+				new_drvdata->comp_mask |= CC_CPP_AES_ABORT_MASK;
+		}
 	}
 
-	new_drvdata->sec_disabled |= cc_sec_disable;
 	if (new_drvdata->sec_disabled)
 		dev_info(dev, "Security Disabled mode is in effect. Security functions disabled.\n");
 
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index b4273f1aec62..10439ce27b3b 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -76,6 +76,26 @@ enum cc_std_body {
 				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
 				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
 
+#define CC_CPP_AES_ABORT_MASK ( \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_0_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_1_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_2_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_3_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_4_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_5_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_6_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_7_MASK_BIT_SHIFT))
+
+#define CC_CPP_SM4_ABORT_MASK ( \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_0_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_1_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_2_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_3_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_4_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_5_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_6_MASK_BIT_SHIFT) | \
+	BIT(CC_HOST_IMR_REE_OP_ABORTED_SM_7_MASK_BIT_SHIFT))
+
 /* Register name mangling macro */
 #define CC_REG(reg_name) CC_ ## reg_name ## _REG_OFFSET
 
@@ -97,6 +117,12 @@ enum cc_std_body {
  * field in the HW descriptor. The DMA engine +8 that value.
  */
 
+struct cc_cpp_req {
+	bool is_cpp;
+	enum cc_cpp_alg alg;
+	u8 slot;
+};
+
 #define CC_MAX_IVGEN_DMA_ADDRESSES	3
 struct cc_crypto_req {
 	void (*user_cb)(struct device *dev, void *req, int err);
@@ -111,6 +137,7 @@ struct cc_crypto_req {
 	/* The generated IV size required, 8/16 B allowed. */
 	unsigned int ivgen_size;
 	struct completion seq_compl; /* request completion */
+	struct cc_cpp_req cpp;
 };
 
 /**
@@ -144,6 +171,7 @@ struct cc_drvdata {
 	u32 ver_offset;
 	int std_bodies;
 	bool sec_disabled;
+	u32 comp_mask;
 };
 
 struct cc_crypto_alg {
diff --git a/drivers/crypto/ccree/cc_host_regs.h b/drivers/crypto/ccree/cc_host_regs.h
index c1be372a5bfe..6124b97680ac 100644
--- a/drivers/crypto/ccree/cc_host_regs.h
+++ b/drivers/crypto/ccree/cc_host_regs.h
@@ -7,33 +7,102 @@
 // --------------------------------------
 // BLOCK: HOST_P
 // --------------------------------------
+
+
+/* IRR */
 #define CC_HOST_IRR_REG_OFFSET	0xA00UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_0_INT_BIT_SHIFT	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_0_INT_BIT_SIZE	0x1UL
 #define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SHIFT	0x2UL
 #define CC_HOST_IRR_DSCRPTR_COMPLETION_LOW_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_1_INT_BIT_SHIFT	0x3UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_1_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_2_INT_BIT_SHIFT	0x4UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_2_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_3_INT_BIT_SHIFT	0x5UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_3_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_4_INT_BIT_SHIFT	0x6UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_4_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_5_INT_BIT_SHIFT	0x7UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_5_INT_BIT_SIZE	0x1UL
 #define CC_HOST_IRR_AXI_ERR_INT_BIT_SHIFT	0x8UL
 #define CC_HOST_IRR_AXI_ERR_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_6_INT_BIT_SHIFT	0x9UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_6_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_7_INT_BIT_SHIFT	0xAUL
+#define CC_HOST_IRR_REE_OP_ABORTED_AES_7_INT_BIT_SIZE	0x1UL
 #define CC_HOST_IRR_GPR0_BIT_SHIFT	0xBUL
 #define CC_HOST_IRR_GPR0_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_0_INT_BIT_SHIFT	0xCUL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_0_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_1_INT_BIT_SHIFT	0xDUL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_1_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_2_INT_BIT_SHIFT	0xEUL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_2_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_3_INT_BIT_SHIFT	0xFUL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_3_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_4_INT_BIT_SHIFT	0x10UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_4_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_5_INT_BIT_SHIFT	0x11UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_5_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_6_INT_BIT_SHIFT	0x12UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_6_INT_BIT_SIZE	0x1UL
 #define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SHIFT	0x13UL
 #define CC_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SIZE	0x1UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SHIFT	0x14UL
+#define CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SIZE	0x1UL
 #define CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT	0x17UL
 #define CC_HOST_IRR_AXIM_COMP_INT_BIT_SIZE	0x1UL
 #define CC_HOST_SEP_SRAM_THRESHOLD_REG_OFFSET	0xA10UL
 #define CC_HOST_SEP_SRAM_THRESHOLD_VALUE_BIT_SHIFT	0x0UL
 #define CC_HOST_SEP_SRAM_THRESHOLD_VALUE_BIT_SIZE	0xCUL
-#define CC_HOST_IMR_REG_OFFSET	0xA04UL
-#define CC_HOST_IMR_NOT_USED_MASK_BIT_SHIFT	0x1UL
-#define CC_HOST_IMR_NOT_USED_MASK_BIT_SIZE	0x1UL
+
+/* IMR */
+#define CC_HOST_IMR_REG_OFFSET	0x0A04UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_0_MASK_BIT_SHIFT	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_0_MASK_BIT_SIZE	0x1UL
 #define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SHIFT	0x2UL
 #define CC_HOST_IMR_DSCRPTR_COMPLETION_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_1_MASK_BIT_SHIFT	0x3UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_1_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_2_MASK_BIT_SHIFT	0x4UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_2_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_3_MASK_BIT_SHIFT	0x5UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_3_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_4_MASK_BIT_SHIFT	0x6UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_4_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_5_MASK_BIT_SHIFT	0x7UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_5_MASK_BIT_SIZE	0x1UL
 #define CC_HOST_IMR_AXI_ERR_MASK_BIT_SHIFT	0x8UL
 #define CC_HOST_IMR_AXI_ERR_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_6_MASK_BIT_SHIFT	0x9UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_6_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_7_MASK_BIT_SHIFT	0xAUL
+#define CC_HOST_IMR_REE_OP_ABORTED_AES_7_MASK_BIT_SIZE	0x1UL
 #define CC_HOST_IMR_GPR0_BIT_SHIFT	0xBUL
 #define CC_HOST_IMR_GPR0_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_0_MASK_BIT_SHIFT	0xCUL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_0_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_1_MASK_BIT_SHIFT	0xDUL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_1_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_2_MASK_BIT_SHIFT	0xEUL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_2_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_3_MASK_BIT_SHIFT	0xFUL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_3_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_4_MASK_BIT_SHIFT	0x10UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_4_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_5_MASK_BIT_SHIFT	0x11UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_5_MASK_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_6_MASK_BIT_SHIFT	0x12UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_6_MASK_BIT_SIZE	0x1UL
 #define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SHIFT	0x13UL
 #define CC_HOST_IMR_DSCRPTR_WATERMARK_MASK0_BIT_SIZE	0x1UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_7_MASK_BIT_SHIFT	0x14UL
+#define CC_HOST_IMR_REE_OP_ABORTED_SM_7_MASK_BIT_SIZE	0x1UL
 #define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SHIFT	0x17UL
 #define CC_HOST_IMR_AXIM_COMP_INT_MASK_BIT_SIZE	0x1UL
+
+/* ICR */
 #define CC_HOST_ICR_REG_OFFSET	0xA08UL
 #define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SHIFT	0x2UL
 #define CC_HOST_ICR_DSCRPTR_COMPLETION_BIT_SIZE	0x1UL
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 83a8aaae61c7..88c97a580dd8 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
+#include <linux/nospec.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
 #include "cc_request_mgr.h"
@@ -52,11 +53,38 @@ struct cc_bl_item {
 	bool notif;
 };
 
+static const u32 cc_cpp_int_masks[CC_CPP_NUM_ALGS][CC_CPP_NUM_SLOTS] = {
+	{ BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_0_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_1_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_2_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_3_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_4_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_5_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_6_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_AES_7_INT_BIT_SHIFT) },
+	{ BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_0_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_1_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_2_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_3_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_4_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_5_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_6_INT_BIT_SHIFT),
+	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SHIFT) }
+};
+
 static void comp_handler(unsigned long devarg);
 #ifdef COMP_IN_WQ
 static void comp_work_handler(struct work_struct *work);
 #endif
 
+static inline u32 cc_cpp_int_mask(enum cc_cpp_alg alg, int slot)
+{
+	alg = array_index_nospec(alg, CC_CPP_NUM_ALGS);
+	slot = array_index_nospec(slot, CC_CPP_NUM_SLOTS);
+
+	return cc_cpp_int_masks[alg][slot];
+}
+
 void cc_req_mgr_fini(struct cc_drvdata *drvdata)
 {
 	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
@@ -579,6 +607,8 @@ static void proc_completions(struct cc_drvdata *drvdata)
 						drvdata->request_mgr_handle;
 	unsigned int *tail = &request_mgr_handle->req_queue_tail;
 	unsigned int *head = &request_mgr_handle->req_queue_head;
+	int rc;
+	u32 mask;
 
 	while (request_mgr_handle->axi_completed) {
 		request_mgr_handle->axi_completed--;
@@ -596,8 +626,22 @@ static void proc_completions(struct cc_drvdata *drvdata)
 
 		cc_req = &request_mgr_handle->req_queue[*tail];
 
+		if (cc_req->cpp.is_cpp) {
+
+			dev_dbg(dev, "CPP request completion slot: %d alg:%d\n",
+				cc_req->cpp.slot, cc_req->cpp.alg);
+			mask = cc_cpp_int_mask(cc_req->cpp.alg,
+					       cc_req->cpp.slot);
+			rc = (drvdata->irq & mask ? -EPERM : 0);
+			dev_dbg(dev, "Got mask: %x irq: %x rc: %d\n", mask,
+				drvdata->irq, rc);
+		} else {
+			dev_dbg(dev, "None CPP request completion\n");
+			rc = 0;
+		}
+
 		if (cc_req->user_cb)
-			cc_req->user_cb(dev, cc_req->user_arg, 0);
+			cc_req->user_cb(dev, cc_req->user_arg, rc);
 		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
@@ -618,47 +662,50 @@ static void comp_handler(unsigned long devarg)
 	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
 	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
-
+	struct device *dev = drvdata_to_dev(drvdata);
 	u32 irq;
 
-	irq = (drvdata->irq & CC_COMP_IRQ_MASK);
+	dev_dbg(dev, "Completion handler called!\n");
+	irq = (drvdata->irq & drvdata->comp_mask);
 
-	if (irq & CC_COMP_IRQ_MASK) {
-		/* To avoid the interrupt from firing as we unmask it,
-		 * we clear it now
-		 */
-		cc_iowrite(drvdata, CC_REG(HOST_ICR), CC_COMP_IRQ_MASK);
+	/* To avoid the interrupt from firing as we unmask it,
+	 * we clear it now
+	 */
+	cc_iowrite(drvdata, CC_REG(HOST_ICR), irq);
 
-		/* Avoid race with above clear: Test completion counter
-		 * once more
-		 */
-		request_mgr_handle->axi_completed +=
-				cc_axi_comp_count(drvdata);
-
-		while (request_mgr_handle->axi_completed) {
-			do {
-				proc_completions(drvdata);
-				/* At this point (after proc_completions()),
-				 * request_mgr_handle->axi_completed is 0.
-				 */
-				request_mgr_handle->axi_completed =
-						cc_axi_comp_count(drvdata);
-			} while (request_mgr_handle->axi_completed > 0);
+	/* Avoid race with above clear: Test completion counter once more */
 
-			cc_iowrite(drvdata, CC_REG(HOST_ICR),
-				   CC_COMP_IRQ_MASK);
+	request_mgr_handle->axi_completed += cc_axi_comp_count(drvdata);
+
+	dev_dbg(dev, "AXI completion after updated: %d\n",
+		request_mgr_handle->axi_completed);
+
+	while (request_mgr_handle->axi_completed) {
+		do {
+			drvdata->irq |= cc_ioread(drvdata, CC_REG(HOST_IRR));
+			irq = (drvdata->irq & drvdata->comp_mask);
+			proc_completions(drvdata);
 
+			/* At this point (after proc_completions()),
+			 * request_mgr_handle->axi_completed is 0.
+			 */
 			request_mgr_handle->axi_completed +=
-					cc_axi_comp_count(drvdata);
-		}
+						cc_axi_comp_count(drvdata);
+		} while (request_mgr_handle->axi_completed > 0);
+
+		cc_iowrite(drvdata, CC_REG(HOST_ICR), irq);
+
+		request_mgr_handle->axi_completed += cc_axi_comp_count(drvdata);
 	}
+
 	/* after verifing that there is nothing to do,
 	 * unmask AXI completion interrupt
 	 */
 	cc_iowrite(drvdata, CC_REG(HOST_IMR),
-		   cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~irq);
+		   cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~drvdata->comp_mask);
 
 	cc_proc_backlog(drvdata);
+	dev_dbg(dev, "Comp. handler done.\n");
 }
 
 /*
-- 
2.21.0

