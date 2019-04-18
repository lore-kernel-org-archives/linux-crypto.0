Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1182C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A191720674
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbfDRNkU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:20 -0400
Received: from foss.arm.com ([217.140.101.70]:33552 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388762AbfDRNkT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 122F380D;
        Thu, 18 Apr 2019 06:40:19 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A1B13F5AF;
        Thu, 18 Apr 2019 06:40:17 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/35] crypto: ccree: add CID and PID support
Date:   Thu, 18 Apr 2019 16:38:45 +0300
Message-Id: <20190418133913.9122-11-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The new HW uses a new standard product and component ID registers
replacing the old ad-hoc version and signature gister schemes.
Update the driver to support the new HW ID registers.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_debugfs.c   | 44 ++++++++++++++++---
 drivers/crypto/ccree/cc_driver.c    | 68 +++++++++++++++++++++++++----
 drivers/crypto/ccree/cc_host_regs.h | 45 ++++++++++++++++++-
 3 files changed, 140 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 5fa05a7bcf36..989dd624f135 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
@@ -25,9 +25,24 @@ struct cc_debugfs_ctx {
  */
 static struct dentry *cc_debugfs_dir;
 
-static struct debugfs_reg32 debug_regs[] = {
+static struct debugfs_reg32 ver_sig_regs[] = {
 	{ .name = "SIGNATURE" }, /* Must be 0th */
 	{ .name = "VERSION" }, /* Must be 1st */
+};
+
+static struct debugfs_reg32 pid_cid_regs[] = {
+	CC_DEBUG_REG(PERIPHERAL_ID_0),
+	CC_DEBUG_REG(PERIPHERAL_ID_1),
+	CC_DEBUG_REG(PERIPHERAL_ID_2),
+	CC_DEBUG_REG(PERIPHERAL_ID_3),
+	CC_DEBUG_REG(PERIPHERAL_ID_4),
+	CC_DEBUG_REG(COMPONENT_ID_0),
+	CC_DEBUG_REG(COMPONENT_ID_1),
+	CC_DEBUG_REG(COMPONENT_ID_2),
+	CC_DEBUG_REG(COMPONENT_ID_3),
+};
+
+static struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(HOST_IRR),
 	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
 	CC_DEBUG_REG(AXIM_MON_ERR),
@@ -53,10 +68,7 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 {
 	struct device *dev = drvdata_to_dev(drvdata);
 	struct cc_debugfs_ctx *ctx;
-	struct debugfs_regset32 *regset;
-
-	debug_regs[0].offset = drvdata->sig_offset;
-	debug_regs[1].offset = drvdata->ver_offset;
+	struct debugfs_regset32 *regset, *verset;
 
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -75,8 +87,26 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	debugfs_create_regset32("regs", 0400, ctx->dir, regset);
 	debugfs_create_bool("coherent", 0400, ctx->dir, &drvdata->coherent);
 
-	drvdata->debugfs = ctx;
+	verset = devm_kzalloc(dev, sizeof(*verset), GFP_KERNEL);
+	/* Failing here is not important enough to fail the module load */
+	if (!regset)
+		goto out;
+
+	if (drvdata->hw_rev <= CC_HW_REV_712) {
+		ver_sig_regs[0].offset = drvdata->sig_offset;
+		ver_sig_regs[1].offset = drvdata->ver_offset;
+		verset->regs = ver_sig_regs;
+		verset->nregs = ARRAY_SIZE(ver_sig_regs);
+	} else {
+		verset->regs = pid_cid_regs;
+		verset->nregs = ARRAY_SIZE(pid_cid_regs);
+	}
+	verset->base = drvdata->cc_base;
+
+	debugfs_create_regset32("version", 0400, ctx->dir, verset);
 
+out:
+	drvdata->debugfs = ctx;
 	return 0;
 }
 
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 1cded418f223..a28548192211 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -30,7 +30,6 @@
 bool cc_dump_desc;
 module_param_named(dump_desc, cc_dump_desc, bool, 0600);
 MODULE_PARM_DESC(cc_dump_desc, "Dump descriptors to kernel log as debugging aid");
-
 bool cc_dump_bytes;
 module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
 MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
@@ -43,18 +42,35 @@ struct cc_hw_data {
 	char *name;
 	enum cc_hw_rev rev;
 	u32 sig;
+	u32 cidr_0123;
+	u32 pidr_0124;
 	int std_bodies;
 };
 
+#define CC_NUM_IDRS 4
+
+/* Note: PIDR3 holds CMOD/Rev so ignored for HW identification purposes */
+static const u32 pidr_0124_offsets[CC_NUM_IDRS] = {
+	CC_REG(PERIPHERAL_ID_0), CC_REG(PERIPHERAL_ID_1),
+	CC_REG(PERIPHERAL_ID_2), CC_REG(PERIPHERAL_ID_4)
+};
+
+static const u32 cidr_0123_offsets[CC_NUM_IDRS] = {
+	CC_REG(COMPONENT_ID_0), CC_REG(COMPONENT_ID_1),
+	CC_REG(COMPONENT_ID_2), CC_REG(COMPONENT_ID_3)
+};
+
 /* Hardware revisions defs. */
 
 /* The 703 is a OSCCA only variant of the 713 */
 static const struct cc_hw_data cc703_hw = {
-	.name = "703", .rev = CC_HW_REV_713, .std_bodies = CC_STD_OSCCA
+	.name = "703", .rev = CC_HW_REV_713, .cidr_0123 = 0xB105F00DU,
+	.pidr_0124 = 0x040BB0D0U, .std_bodies = CC_STD_OSCCA
 };
 
 static const struct cc_hw_data cc713_hw = {
-	.name = "713", .rev = CC_HW_REV_713, .std_bodies = CC_STD_ALL
+	.name = "713", .rev = CC_HW_REV_713, .cidr_0123 = 0xB105F00DU,
+	.pidr_0124 = 0x040BB0D0U, .std_bodies = CC_STD_ALL
 };
 
 static const struct cc_hw_data cc712_hw = {
@@ -82,6 +98,20 @@ static const struct of_device_id arm_ccree_dev_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
 
+static u32 cc_read_idr(struct cc_drvdata *drvdata, const u32 *idr_offsets)
+{
+	int i;
+	union {
+		u8 regs[CC_NUM_IDRS];
+		u32 val;
+	} idr;
+
+	for (i = 0; i < CC_NUM_IDRS; ++i)
+		idr.regs[i] = cc_ioread(drvdata, idr_offsets[i]);
+
+	return le32_to_cpu(idr.val);
+}
+
 void __dump_byte_array(const char *name, const u8 *buf, size_t len)
 {
 	char prefix[64];
@@ -205,7 +235,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct cc_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
-	u32 val;
+	u32 val, hw_rev_pidr, sig_cidr;
 	u64 dma_mask;
 	const struct cc_hw_data *hw_rev;
 	const struct of_device_id *dev_id;
@@ -328,8 +358,29 @@ static int init_cc_resources(struct platform_device *plat_dev)
 			rc = -EINVAL;
 			goto post_clk_err;
 		}
-		dev_dbg(dev, "CC SIGNATURE=0x%08X\n", val);
+		sig_cidr = val;
+		hw_rev_pidr = cc_ioread(new_drvdata, new_drvdata->ver_offset);
 	} else {
+		/* Verify correct mapping */
+		val = cc_read_idr(new_drvdata, pidr_0124_offsets);
+		if (val != hw_rev->pidr_0124) {
+			dev_err(dev, "Invalid CC PIDR: PIDR0124=0x%08X != expected=0x%08X\n",
+				val,  hw_rev->pidr_0124);
+			rc = -EINVAL;
+			goto post_clk_err;
+		}
+		hw_rev_pidr = val;
+
+		val = cc_read_idr(new_drvdata, cidr_0123_offsets);
+		if (val != hw_rev->cidr_0123) {
+			dev_err(dev, "Invalid CC CIDR: CIDR0123=0x%08X != expected=0x%08X\n",
+			val,  hw_rev->cidr_0123);
+			rc = -EINVAL;
+			goto post_clk_err;
+		}
+		sig_cidr = val;
+
+		/* Check security disable state */
 		val = cc_ioread(new_drvdata, CC_REG(SECURITY_DISABLED));
 		val &= CC_SECURITY_DISABLED_MASK;
 		new_drvdata->sec_disabled |= !!val;
@@ -345,9 +396,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		dev_info(dev, "Security Disabled mode is in effect. Security functions disabled.\n");
 
 	/* Display HW versions */
-	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
-		 hw_rev->name, cc_ioread(new_drvdata, new_drvdata->ver_offset),
-		 DRV_MODULE_VERSION);
+	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X/0x%8X, Driver version %s\n",
+		 hw_rev->name, hw_rev_pidr, sig_cidr, DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
 	if (rc) {
diff --git a/drivers/crypto/ccree/cc_host_regs.h b/drivers/crypto/ccree/cc_host_regs.h
index 6124b97680ac..d0764147573f 100644
--- a/drivers/crypto/ccree/cc_host_regs.h
+++ b/drivers/crypto/ccree/cc_host_regs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited or its affiliates. */
 
 #ifndef __CC_HOST_H__
 #define __CC_HOST_H__
@@ -204,6 +204,49 @@
 #define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SHIFT	0x0UL
 #define CC_HOST_POWER_DOWN_EN_VALUE_BIT_SIZE	0x1UL
 // --------------------------------------
+// BLOCK: ID_REGISTERS
+// --------------------------------------
+#define CC_PERIPHERAL_ID_4_REG_OFFSET	0x0FD0UL
+#define CC_PERIPHERAL_ID_4_VALUE_BIT_SHIFT	0x0UL
+#define CC_PERIPHERAL_ID_4_VALUE_BIT_SIZE	0x4UL
+#define CC_PIDRESERVED0_REG_OFFSET	0x0FD4UL
+#define CC_PIDRESERVED1_REG_OFFSET	0x0FD8UL
+#define CC_PIDRESERVED2_REG_OFFSET	0x0FDCUL
+#define CC_PERIPHERAL_ID_0_REG_OFFSET	0x0FE0UL
+#define CC_PERIPHERAL_ID_0_VALUE_BIT_SHIFT	0x0UL
+#define CC_PERIPHERAL_ID_0_VALUE_BIT_SIZE	0x8UL
+#define CC_PERIPHERAL_ID_1_REG_OFFSET	0x0FE4UL
+#define CC_PERIPHERAL_ID_1_PART_1_BIT_SHIFT	0x0UL
+#define CC_PERIPHERAL_ID_1_PART_1_BIT_SIZE	0x4UL
+#define CC_PERIPHERAL_ID_1_DES_0_JEP106_BIT_SHIFT	0x4UL
+#define CC_PERIPHERAL_ID_1_DES_0_JEP106_BIT_SIZE	0x4UL
+#define CC_PERIPHERAL_ID_2_REG_OFFSET	0x0FE8UL
+#define CC_PERIPHERAL_ID_2_DES_1_JEP106_BIT_SHIFT	0x0UL
+#define CC_PERIPHERAL_ID_2_DES_1_JEP106_BIT_SIZE	0x3UL
+#define CC_PERIPHERAL_ID_2_JEDEC_BIT_SHIFT	0x3UL
+#define CC_PERIPHERAL_ID_2_JEDEC_BIT_SIZE	0x1UL
+#define CC_PERIPHERAL_ID_2_REVISION_BIT_SHIFT	0x4UL
+#define CC_PERIPHERAL_ID_2_REVISION_BIT_SIZE	0x4UL
+#define CC_PERIPHERAL_ID_3_REG_OFFSET	0x0FECUL
+#define CC_PERIPHERAL_ID_3_CMOD_BIT_SHIFT	0x0UL
+#define CC_PERIPHERAL_ID_3_CMOD_BIT_SIZE	0x4UL
+#define CC_PERIPHERAL_ID_3_REVAND_BIT_SHIFT	0x4UL
+#define CC_PERIPHERAL_ID_3_REVAND_BIT_SIZE	0x4UL
+#define CC_COMPONENT_ID_0_REG_OFFSET	0x0FF0UL
+#define CC_COMPONENT_ID_0_VALUE_BIT_SHIFT	0x0UL
+#define CC_COMPONENT_ID_0_VALUE_BIT_SIZE	0x8UL
+#define CC_COMPONENT_ID_1_REG_OFFSET	0x0FF4UL
+#define CC_COMPONENT_ID_1_PRMBL_1_BIT_SHIFT	0x0UL
+#define CC_COMPONENT_ID_1_PRMBL_1_BIT_SIZE	0x4UL
+#define CC_COMPONENT_ID_1_CLASS_BIT_SHIFT	0x4UL
+#define CC_COMPONENT_ID_1_CLASS_BIT_SIZE	0x4UL
+#define CC_COMPONENT_ID_2_REG_OFFSET	0x0FF8UL
+#define CC_COMPONENT_ID_2_VALUE_BIT_SHIFT	0x0UL
+#define CC_COMPONENT_ID_2_VALUE_BIT_SIZE	0x8UL
+#define CC_COMPONENT_ID_3_REG_OFFSET	0x0FFCUL
+#define CC_COMPONENT_ID_3_VALUE_BIT_SHIFT	0x0UL
+#define CC_COMPONENT_ID_3_VALUE_BIT_SIZE	0x8UL
+// --------------------------------------
 // BLOCK: HOST_SRAM
 // --------------------------------------
 #define CC_SRAM_DATA_REG_OFFSET	0xF00UL
-- 
2.21.0

