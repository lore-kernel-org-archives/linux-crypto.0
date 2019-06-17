Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC8AC31E44
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9DA82080A
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfFQIqn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 04:46:43 -0400
Received: from foss.arm.com ([217.140.110.172]:41816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfFQIqn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 04:46:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 162FC28;
        Mon, 17 Jun 2019 01:46:42 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D42863F246;
        Mon, 17 Jun 2019 01:46:40 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] crypto: ccree: check that cryptocell reset completed
Date:   Mon, 17 Jun 2019 11:46:28 +0300
Message-Id: <20190617084631.23551-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617084631.23551-1-gilad@benyossef.com>
References: <20190617084631.23551-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

In case of driver probe and pm resume we need to check that the cryptocell
hardware reset cycle is completed. during the reset cycle that Cryptocell
provide read only access to the APB interface which allows to verify
through the CC registers that the reset is completed. Until reset
completion we assume that any write/crypto operation is blocked.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
---
 drivers/crypto/ccree/cc_driver.c    | 33 ++++++++++++++++++++++++++++-
 drivers/crypto/ccree/cc_driver.h    |  3 +++
 drivers/crypto/ccree/cc_host_regs.h |  3 +++
 drivers/crypto/ccree/cc_pm.c        |  5 +++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 0f80cb4f79fb..1e73d32148dd 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -48,6 +48,7 @@ struct cc_hw_data {
 };
 
 #define CC_NUM_IDRS 4
+#define CC_HW_RESET_LOOP_COUNT 10
 
 /* Note: PIDR3 holds CMOD/Rev so ignored for HW identification purposes */
 static const u32 pidr_0124_offsets[CC_NUM_IDRS] = {
@@ -188,6 +189,31 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+bool cc_wait_for_reset_completion(struct cc_drvdata *drvdata)
+{
+	unsigned int val;
+	unsigned int i;
+
+	/* 712/710/63 has no reset completion indication, always return true */
+	if (drvdata->hw_rev <= CC_HW_REV_712)
+		return true;
+
+	for (i = 0; i < CC_HW_RESET_LOOP_COUNT; i++) {
+		/* in cc7x3 NVM_IS_IDLE indicates that CC reset is
+		 *  completed and device is fully functional
+		 */
+		val = cc_ioread(drvdata, CC_REG(NVM_IS_IDLE));
+		if (val & CC_NVM_IS_IDLE_MASK) {
+			/* hw indicate reset completed */
+			return true;
+		}
+		/* allow scheduling other process on the processor */
+		schedule();
+	}
+	/* reset not completed */
+	return false;
+}
+
 int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
 {
 	unsigned int val, cache_params;
@@ -343,6 +369,11 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	new_drvdata->sec_disabled = cc_sec_disable;
 
+	/* wait for Crytpcell reset completion */
+	if (!cc_wait_for_reset_completion(new_drvdata)) {
+		dev_err(dev, "Cryptocell reset not completed");
+	}
+
 	if (hw_rev->rev <= CC_HW_REV_712) {
 		/* Verify correct mapping */
 		val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
@@ -398,7 +429,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (rc) {
 		dev_err(dev, "Could not register to interrupt %d\n",
 			new_drvdata->irq);
-		return rc;
+		goto post_clk_err;
 	}
 	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
 
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index cc403d705c9d..556b3322667e 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -72,6 +72,8 @@ enum cc_std_body {
 
 #define CC_SECURITY_DISABLED_MASK BIT(CC_SECURITY_DISABLED_VALUE_BIT_SHIFT)
 
+#define CC_NVM_IS_IDLE_MASK BIT(CC_NVM_IS_IDLE_VALUE_BIT_SHIFT)
+
 #define AXIM_MON_COMP_VALUE GENMASK(CC_AXIM_MON_COMP_VALUE_BIT_SIZE + \
 				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
 				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
@@ -221,6 +223,7 @@ static inline void dump_byte_array(const char *name, const u8 *the_array,
 		__dump_byte_array(name, the_array, size);
 }
 
+bool cc_wait_for_reset_completion(struct cc_drvdata *drvdata);
 int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
 void fini_cc_regs(struct cc_drvdata *drvdata);
 int cc_clk_on(struct cc_drvdata *drvdata);
diff --git a/drivers/crypto/ccree/cc_host_regs.h b/drivers/crypto/ccree/cc_host_regs.h
index d0764147573f..ad1acb105f2d 100644
--- a/drivers/crypto/ccree/cc_host_regs.h
+++ b/drivers/crypto/ccree/cc_host_regs.h
@@ -114,6 +114,9 @@
 #define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE	0x1UL
 #define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT	0x17UL
 #define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE	0x1UL
+#define CC_NVM_IS_IDLE_REG_OFFSET       0x0A10UL
+#define CC_NVM_IS_IDLE_VALUE_BIT_SHIFT  0x0UL
+#define CC_NVM_IS_IDLE_VALUE_BIT_SIZE   0x1UL
 #define CC_SECURITY_DISABLED_REG_OFFSET		0x0A1CUL
 #define CC_SECURITY_DISABLED_VALUE_BIT_SHIFT	0x0UL
 #define CC_SECURITY_DISABLED_VALUE_BIT_SIZE	0x1UL
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 2dad9c9543c6..20f7f3d34e27 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -49,6 +49,11 @@ int cc_pm_resume(struct device *dev)
 		dev_err(dev, "failed getting clock back on. We're toast.\n");
 		return rc;
 	}
+	/* wait for Crytpcell reset completion */
+	if (!cc_wait_for_reset_completion(drvdata)) {
+		dev_err(dev, "Cryptocell reset not completed");
+		return -EBUSY;
+	}
 
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
 	rc = init_cc_regs(drvdata, false);
-- 
2.21.0

