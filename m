Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E95C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53DBE2083D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbfDRNmg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:42:36 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33806 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389054AbfDRNmf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:42:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63EBE1688;
        Thu, 18 Apr 2019 06:42:35 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBE623F5AF;
        Thu, 18 Apr 2019 06:42:33 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 34/35] crypto: ccree: add function to handle cryptocell tee fips error
Date:   Thu, 18 Apr 2019 16:39:09 +0300
Message-Id: <20190418133913.9122-35-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

Adds function that checks if cryptocell tee fips error occurred
and in such case triggers system error through kernel panic.
Change fips function to use this new routine.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_fips.c | 23 +++++++++++++++--------
 drivers/crypto/ccree/cc_fips.h |  2 ++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 4a67248f5625..5ad3ffb7acaa 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -70,20 +70,28 @@ static inline void tee_fips_error(struct device *dev)
 		dev_err(dev, "TEE reported error!\n");
 }
 
+/*
+ * This function check if cryptocell tee fips error occurred
+ * and in such case triggers system error
+ */
+void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata)
+{
+	struct device *dev = drvdata_to_dev(p_drvdata);
+
+	if (!cc_get_tee_fips_status(p_drvdata))
+		tee_fips_error(dev);
+}
+
 /* Deferred service handler, run as interrupt-fired tasklet */
 static void fips_dsr(unsigned long devarg)
 {
 	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
-	struct device *dev = drvdata_to_dev(drvdata);
-	u32 irq, state, val;
+	u32 irq, val;
 
 	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
 
 	if (irq) {
-		state = cc_ioread(drvdata, CC_REG(GPR_HOST));
-
-		if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
-			tee_fips_error(dev);
+		cc_tee_handle_fips_error(drvdata);
 	}
 
 	/* after verifing that there is nothing to do,
@@ -111,8 +119,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
 	dev_dbg(dev, "Initializing fips tasklet\n");
 	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
 
-	if (!cc_get_tee_fips_status(p_drvdata))
-		tee_fips_error(dev);
+	cc_tee_handle_fips_error(p_drvdata);
 
 	return 0;
 }
diff --git a/drivers/crypto/ccree/cc_fips.h b/drivers/crypto/ccree/cc_fips.h
index 2c287faf10ff..fc33eeb4d566 100644
--- a/drivers/crypto/ccree/cc_fips.h
+++ b/drivers/crypto/ccree/cc_fips.h
@@ -18,6 +18,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata);
 void cc_fips_fini(struct cc_drvdata *drvdata);
 void fips_handler(struct cc_drvdata *drvdata);
 void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
+void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata);
 
 #else  /* CONFIG_CRYPTO_FIPS */
 
@@ -30,6 +31,7 @@ static inline void cc_fips_fini(struct cc_drvdata *drvdata) {}
 static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
 					  bool ok) {}
 static inline void fips_handler(struct cc_drvdata *drvdata) {}
+static inline void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata) {}
 
 #endif /* CONFIG_CRYPTO_FIPS */
 
-- 
2.21.0

