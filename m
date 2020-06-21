Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DB1C433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FAD20716
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgFULUK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 07:20:10 -0400
Received: from foss.arm.com ([217.140.110.172]:58554 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbgFULUK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 07:20:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47D3A101E;
        Sun, 21 Jun 2020 04:20:09 -0700 (PDT)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFEA03F6CF;
        Sun, 21 Jun 2020 04:20:07 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 1/3] crypto: ccree: fix resource leak on error path
Date:   Sun, 21 Jun 2020 14:19:57 +0300
Message-Id: <20200621112000.31495-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621112000.31495-1-gilad@benyossef.com>
References: <20200621112000.31495-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a small resource leak on the error path of cipher processing.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 63ee04c8b491e ("crypto: ccree - add skcipher support")
Cc: Markus Elfring <Markus.Elfring@web.de>
---
 drivers/crypto/ccree/cc_cipher.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 42ec46be427d..c2f759a04625 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -163,7 +163,6 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 				     skcipher_alg.base);
 	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
-	int rc = 0;
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
 		crypto_tfm_alg_name(tfm));
@@ -175,10 +174,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	ctx_p->flow_mode = cc_alg->flow_mode;
 	ctx_p->drvdata = cc_alg->drvdata;
 
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Alloc hash tfm for essiv */
+		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
+		if (IS_ERR(ctx_p->shash_tfm)) {
+			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
+			return PTR_ERR(ctx_p->shash_tfm);
+		}
+	}
+
 	/* Allocate key buffer, cache line aligned */
 	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
 	if (!ctx_p->user.key)
-		return -ENOMEM;
+		goto free_shash;
 
 	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
 		ctx_p->user.key);
@@ -190,21 +198,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
 		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
 			max_key_buf_size, ctx_p->user.key);
-		return -ENOMEM;
+		goto free_key;
 	}
 	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
 		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
 
-	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-		/* Alloc hash tfm for essiv */
-		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
-		if (IS_ERR(ctx_p->shash_tfm)) {
-			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
-			return PTR_ERR(ctx_p->shash_tfm);
-		}
-	}
+	return 0;
 
-	return rc;
+free_key:
+	kfree(ctx_p->user.key);
+free_shash:
+	crypto_free_shash(ctx_p->shash_tfm);
+
+	return -ENOMEM;
 }
 
 static void cc_cipher_exit(struct crypto_tfm *tfm)
-- 
2.27.0

