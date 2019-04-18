Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD63C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD7520675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfDRNkt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:49 -0400
Received: from foss.arm.com ([217.140.101.70]:33608 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388850AbfDRNks (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2D8880D;
        Thu, 18 Apr 2019 06:40:47 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 275913F5AF;
        Thu, 18 Apr 2019 06:40:45 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/35] crypto: ccree: fix mem leak on error path
Date:   Thu, 18 Apr 2019 16:38:50 +0300
Message-Id: <20190418133913.9122-16-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a memory leak on the error path of IV generation code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_ivgen.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_ivgen.c b/drivers/crypto/ccree/cc_ivgen.c
index 769458323394..1abec3896a78 100644
--- a/drivers/crypto/ccree/cc_ivgen.c
+++ b/drivers/crypto/ccree/cc_ivgen.c
@@ -154,9 +154,6 @@ void cc_ivgen_fini(struct cc_drvdata *drvdata)
 	}
 
 	ivgen_ctx->pool = NULL_SRAM_ADDR;
-
-	/* release "this" context */
-	kfree(ivgen_ctx);
 }
 
 /*!
@@ -174,10 +171,12 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
 	int rc;
 
 	/* Allocate "this" context */
-	ivgen_ctx = kzalloc(sizeof(*ivgen_ctx), GFP_KERNEL);
+	ivgen_ctx = devm_kzalloc(device, sizeof(*ivgen_ctx), GFP_KERNEL);
 	if (!ivgen_ctx)
 		return -ENOMEM;
 
+	drvdata->ivgen_handle = ivgen_ctx;
+
 	/* Allocate pool's header for initial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
@@ -196,8 +195,6 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
 		goto out;
 	}
 
-	drvdata->ivgen_handle = ivgen_ctx;
-
 	return cc_init_iv_sram(drvdata);
 
 out:
-- 
2.21.0

