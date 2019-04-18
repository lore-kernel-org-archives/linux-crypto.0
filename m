Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB723C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95D6320675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbfDRNkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:53 -0400
Received: from foss.arm.com ([217.140.101.70]:33620 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388301AbfDRNkx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52B9B80D;
        Thu, 18 Apr 2019 06:40:53 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB4663F5AF;
        Thu, 18 Apr 2019 06:40:51 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/35] crypto: ccree: use devm_kzalloc for device data
Date:   Thu, 18 Apr 2019 16:38:51 +0300
Message-Id: <20190418133913.9122-17-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move some remaining device data allocation to the safer devm_*
interface.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_fips.c     | 4 +---
 drivers/crypto/ccree/cc_sram_mgr.c | 5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index b4d0a6d983e0..9c03ab238a75 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -49,8 +49,6 @@ void cc_fips_fini(struct cc_drvdata *drvdata)
 
 	/* Kill tasklet */
 	tasklet_kill(&fips_h->tasklet);
-
-	kfree(fips_h);
 	drvdata->fips_handle = NULL;
 }
 
@@ -104,7 +102,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
 	if (p_drvdata->hw_rev < CC_HW_REV_712)
 		return 0;
 
-	fips_h = kzalloc(sizeof(*fips_h), GFP_KERNEL);
+	fips_h = devm_kzalloc(dev, sizeof(*fips_h), GFP_KERNEL);
 	if (!fips_h)
 		return -ENOMEM;
 
diff --git a/drivers/crypto/ccree/cc_sram_mgr.c b/drivers/crypto/ccree/cc_sram_mgr.c
index c8c276f6dee9..86319788e390 100644
--- a/drivers/crypto/ccree/cc_sram_mgr.c
+++ b/drivers/crypto/ccree/cc_sram_mgr.c
@@ -19,8 +19,7 @@ struct cc_sram_ctx {
  */
 void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
 {
-	/* Free "this" context */
-	kfree(drvdata->sram_mgr_handle);
+	/* Nothing needed */
 }
 
 /**
@@ -48,7 +47,7 @@ int cc_sram_mgr_init(struct cc_drvdata *drvdata)
 	}
 
 	/* Allocate "this" context */
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
 
 	if (!ctx)
 		return -ENOMEM;
-- 
2.21.0

