Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CE0C5519F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Nov 2020 07:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 765072078E
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Nov 2020 07:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgKVHwC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Nov 2020 02:52:02 -0500
Received: from foss.arm.com ([217.140.110.172]:36784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgKVHwC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Nov 2020 02:52:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB2CC101E;
        Sat, 21 Nov 2020 23:52:01 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FA043F718;
        Sat, 21 Nov 2020 23:52:00 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] crypto: ccree - rework cache parameters handling
Date:   Sun, 22 Nov 2020 09:51:53 +0200
Message-Id: <20201122075154.20478-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rework the setting of DMA cache parameters, program more appropriate
values and explicitly set sharability domain.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---

Changes from previous versions:
- After discussion with Rob H., drop notion of setting the parameters
  from device tree and just use good defaults for cached/non cached.

 drivers/crypto/ccree/cc_driver.c | 75 +++++++++++++++++++++++++-------
 drivers/crypto/ccree/cc_driver.h |  6 +--
 drivers/crypto/ccree/cc_pm.c     |  2 +-
 3 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 6f519d3e896c..d0e59e942568 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -100,6 +100,57 @@ static const struct of_device_id arm_ccree_dev_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
 
+static void init_cc_cache_params(struct cc_drvdata *drvdata)
+{
+	struct device *dev = drvdata_to_dev(drvdata);
+	u32 cache_params, ace_const, val, mask;
+
+	/* compute CC_AXIM_CACHE_PARAMS */
+	cache_params = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
+	dev_dbg(dev, "Cache params previous: 0x%08X\n", cache_params);
+
+	/* non cached or write-back, write allocate */
+	val = drvdata->coherent ? 0xb : 0x2;
+
+	mask = CC_GENMASK(CC_AXIM_CACHE_PARAMS_AWCACHE);
+	cache_params &= ~mask;
+	cache_params |= FIELD_PREP(mask, val);
+
+	mask = CC_GENMASK(CC_AXIM_CACHE_PARAMS_AWCACHE_LAST);
+	cache_params &= ~mask;
+	cache_params |= FIELD_PREP(mask, val);
+
+	mask = CC_GENMASK(CC_AXIM_CACHE_PARAMS_ARCACHE);
+	cache_params &= ~mask;
+	cache_params |= FIELD_PREP(mask, val);
+
+	drvdata->cache_params = cache_params;
+
+	dev_dbg(dev, "Cache params current: 0x%08X\n", cache_params);
+
+	if (drvdata->hw_rev <= CC_HW_REV_710)
+		return;
+
+	/* compute CC_AXIM_ACE_CONST */
+	ace_const = cc_ioread(drvdata, CC_REG(AXIM_ACE_CONST));
+	dev_dbg(dev, "ACE-const previous: 0x%08X\n", ace_const);
+
+	/* system or outer-sharable */
+	val = drvdata->coherent ? 0x2 : 0x3;
+
+	mask = CC_GENMASK(CC_AXIM_ACE_CONST_ARDOMAIN);
+	ace_const &= ~mask;
+	ace_const |= FIELD_PREP(mask, val);
+
+	mask = CC_GENMASK(CC_AXIM_ACE_CONST_AWDOMAIN);
+	ace_const &= ~mask;
+	ace_const |= FIELD_PREP(mask, val);
+
+	dev_dbg(dev, "ACE-const current: 0x%08X\n", ace_const);
+
+	drvdata->ace_const = ace_const;
+}
+
 static u32 cc_read_idr(struct cc_drvdata *drvdata, const u32 *idr_offsets)
 {
 	int i;
@@ -218,9 +269,9 @@ bool cc_wait_for_reset_completion(struct cc_drvdata *drvdata)
 	return false;
 }
 
-int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
+int init_cc_regs(struct cc_drvdata *drvdata)
 {
-	unsigned int val, cache_params;
+	unsigned int val;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* Unmask all AXI interrupt sources AXI_CFG1 register   */
@@ -245,19 +296,9 @@ int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
 
 	cc_iowrite(drvdata, CC_REG(HOST_IMR), ~val);
 
-	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
-
-	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-
-	if (is_probe)
-		dev_dbg(dev, "Cache params previous: 0x%08X\n", val);
-
-	cc_iowrite(drvdata, CC_REG(AXIM_CACHE_PARAMS), cache_params);
-	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-
-	if (is_probe)
-		dev_dbg(dev, "Cache params current: 0x%08X (expect: 0x%08X)\n",
-			val, cache_params);
+	cc_iowrite(drvdata, CC_REG(AXIM_CACHE_PARAMS), drvdata->cache_params);
+	if (drvdata->hw_rev >= CC_HW_REV_712)
+		cc_iowrite(drvdata, CC_REG(AXIM_ACE_CONST), drvdata->ace_const);
 
 	return 0;
 }
@@ -445,7 +486,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 	dev_dbg(dev, "Registered to IRQ: %d\n", irq);
 
-	rc = init_cc_regs(new_drvdata, true);
+	init_cc_cache_params(new_drvdata);
+
+	rc = init_cc_regs(new_drvdata);
 	if (rc) {
 		dev_err(dev, "init_cc_regs failed\n");
 		goto post_pm_err;
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index af77b2020350..12cd68d59baa 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -49,8 +49,6 @@ enum cc_std_body {
 	CC_STD_ALL = 0x3
 };
 
-#define CC_COHERENT_CACHE_PARAMS 0xEEE
-
 #define CC_PINS_FULL	0x0
 #define CC_PINS_SLIM	0x9F
 
@@ -155,6 +153,8 @@ struct cc_drvdata {
 	int std_bodies;
 	bool sec_disabled;
 	u32 comp_mask;
+	u32 cache_params;
+	u32 ace_const;
 };
 
 struct cc_crypto_alg {
@@ -205,7 +205,7 @@ static inline void dump_byte_array(const char *name, const u8 *the_array,
 }
 
 bool cc_wait_for_reset_completion(struct cc_drvdata *drvdata);
-int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
+int init_cc_regs(struct cc_drvdata *drvdata);
 void fini_cc_regs(struct cc_drvdata *drvdata);
 unsigned int cc_get_default_hash_len(struct cc_drvdata *drvdata);
 
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 3c65bf070c90..d5421b0c6831 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -45,7 +45,7 @@ static int cc_pm_resume(struct device *dev)
 	}
 
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
-	rc = init_cc_regs(drvdata, false);
+	rc = init_cc_regs(drvdata);
 	if (rc) {
 		dev_err(dev, "init_cc_regs (%x)\n", rc);
 		return rc;
-- 
2.29.2

