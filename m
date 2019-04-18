Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F655C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F53B20674
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388922AbfDRNjr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:39:47 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33472 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfDRNjp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:39:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E8AC169E;
        Thu, 18 Apr 2019 06:39:44 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20C8D3F5AF;
        Thu, 18 Apr 2019 06:39:42 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/35] crypto: ccree: add support for sec disabled mode
Date:   Thu, 18 Apr 2019 16:38:39 +0300
Message-Id: <20190418133913.9122-5-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for the Security Disabled mode under which only
pure cryptographic functionality is enabled and protected keys
services are unavailable.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c    | 17 ++++++++++++++++-
 drivers/crypto/ccree/cc_driver.c    | 22 +++++++++++++++++-----
 drivers/crypto/ccree/cc_driver.h    |  4 ++++
 drivers/crypto/ccree/cc_host_regs.h |  3 +++
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index e4398de3aa39..8a9c664390f0 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -889,6 +889,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_630,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "xts512(paes)",
@@ -907,6 +908,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "xts4096(paes)",
@@ -925,6 +927,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "essiv(paes)",
@@ -942,6 +945,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "essiv512(paes)",
@@ -960,6 +964,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "essiv4096(paes)",
@@ -978,6 +983,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "bitlocker(paes)",
@@ -995,6 +1001,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "bitlocker512(paes)",
@@ -1013,6 +1020,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.data_unit = 512,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "bitlocker4096(paes)",
@@ -1031,6 +1039,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.data_unit = 4096,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "ecb(paes)",
@@ -1048,6 +1057,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "cbc(paes)",
@@ -1065,6 +1075,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "ofb(paes)",
@@ -1082,6 +1093,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "cts(cbc(paes))",
@@ -1099,6 +1111,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "ctr(paes)",
@@ -1116,6 +1129,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.flow_mode = S_DIN_to_AES,
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
+		.sec_func = true,
 	},
 	{
 		.name = "xts(aes)",
@@ -1555,7 +1569,8 @@ int cc_cipher_alloc(struct cc_drvdata *drvdata)
 		ARRAY_SIZE(skcipher_algs));
 	for (alg = 0; alg < ARRAY_SIZE(skcipher_algs); alg++) {
 		if ((skcipher_algs[alg].min_hw_rev > drvdata->hw_rev) ||
-		    !(drvdata->std_bodies & skcipher_algs[alg].std_body))
+		    !(drvdata->std_bodies & skcipher_algs[alg].std_body) ||
+		    (drvdata->sec_disabled && skcipher_algs[alg].sec_func))
 			continue;
 
 		dev_dbg(dev, "creating %s\n", skcipher_algs[alg].driver_name);
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 3bcc6c76e090..255d2367bfa8 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -35,6 +35,10 @@ bool cc_dump_bytes;
 module_param_named(dump_bytes, cc_dump_bytes, bool, 0600);
 MODULE_PARM_DESC(cc_dump_bytes, "Dump buffers to kernel log as debugging aid");
 
+bool cc_sec_disable;
+module_param_named(sec_disable, cc_sec_disable, bool, 0600);
+MODULE_PARM_DESC(cc_sec_disable, "Disable security functions");
+
 struct cc_hw_data {
 	char *name;
 	enum cc_hw_rev rev;
@@ -201,7 +205,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct cc_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
-	u32 signature_val;
+	u32 val;
 	u64 dma_mask;
 	const struct cc_hw_data *hw_rev;
 	const struct of_device_id *dev_id;
@@ -313,16 +317,24 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	if (hw_rev->rev <= CC_HW_REV_712) {
 		/* Verify correct mapping */
-		signature_val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
-		if (signature_val != hw_rev->sig) {
+		val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
+		if (val != hw_rev->sig) {
 			dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
-				signature_val, hw_rev->sig);
+				val, hw_rev->sig);
 			rc = -EINVAL;
 			goto post_clk_err;
 		}
-		dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
+		dev_dbg(dev, "CC SIGNATURE=0x%08X\n", val);
+	} else {
+		val = cc_ioread(new_drvdata, CC_REG(SECURITY_DISABLED));
+		val &= CC_SECURITY_DISABLED_MASK;
+		new_drvdata->sec_disabled = !!val;
 	}
 
+	new_drvdata->sec_disabled |= cc_sec_disable;
+	if (new_drvdata->sec_disabled)
+		dev_info(dev, "Security Disabled mode is in effect. Security functions disabled.\n");
+
 	/* Display HW versions */
 	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
 		 hw_rev->name, cc_ioread(new_drvdata, new_drvdata->ver_offset),
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 384a886f613a..b4273f1aec62 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -70,6 +70,8 @@ enum cc_std_body {
 
 #define CC_COMP_IRQ_MASK BIT(CC_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
 
+#define CC_SECURITY_DISABLED_MASK BIT(CC_SECURITY_DISABLED_VALUE_BIT_SHIFT)
+
 #define AXIM_MON_COMP_VALUE GENMASK(CC_AXIM_MON_COMP_VALUE_BIT_SIZE + \
 				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
 				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
@@ -141,6 +143,7 @@ struct cc_drvdata {
 	u32 sig_offset;
 	u32 ver_offset;
 	int std_bodies;
+	bool sec_disabled;
 };
 
 struct cc_crypto_alg {
@@ -167,6 +170,7 @@ struct cc_alg_template {
 	int auth_mode;
 	u32 min_hw_rev;
 	enum cc_std_body std_body;
+	bool sec_func;
 	unsigned int data_unit;
 	struct cc_drvdata *drvdata;
 };
diff --git a/drivers/crypto/ccree/cc_host_regs.h b/drivers/crypto/ccree/cc_host_regs.h
index 616b2e1c41ba..c1be372a5bfe 100644
--- a/drivers/crypto/ccree/cc_host_regs.h
+++ b/drivers/crypto/ccree/cc_host_regs.h
@@ -45,6 +45,9 @@
 #define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE	0x1UL
 #define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT	0x17UL
 #define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE	0x1UL
+#define CC_SECURITY_DISABLED_REG_OFFSET		0x0A1CUL
+#define CC_SECURITY_DISABLED_VALUE_BIT_SHIFT	0x0UL
+#define CC_SECURITY_DISABLED_VALUE_BIT_SIZE	0x1UL
 #define CC_HOST_SIGNATURE_712_REG_OFFSET	0xA24UL
 #define CC_HOST_SIGNATURE_630_REG_OFFSET	0xAC8UL
 #define CC_HOST_SIGNATURE_VALUE_BIT_SHIFT	0x0UL
-- 
2.21.0

