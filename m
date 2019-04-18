Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14D5C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA7EB2186A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbfDRNmH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:42:07 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33742 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389071AbfDRNmH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:42:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB32380D;
        Thu, 18 Apr 2019 06:42:06 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EE6D3F5AF;
        Thu, 18 Apr 2019 06:42:04 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 29/35] crypto: ccree: don't map MAC key on stack
Date:   Thu, 18 Apr 2019 16:39:04 +0300
Message-Id: <20190418133913.9122-30-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The MAC hash key might be passed to us on stack. Copy it to
a slab buffer before mapping to gurantee proper DMA mapping.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_hash.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 36e9fb4141f8..a6abe4e3bb0e 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -69,6 +69,7 @@ struct cc_hash_alg {
 struct hash_key_req_ctx {
 	u32 keylen;
 	dma_addr_t key_dma_addr;
+	u8 *key;
 };
 
 /* hash per-session context */
@@ -742,13 +743,20 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	ctx->key_params.keylen = keylen;
 	ctx->key_params.key_dma_addr = 0;
 	ctx->is_hmac = true;
+	ctx->key_params.key = NULL;
 
 	if (keylen) {
+		ctx->key_params.key = kmemdup(key, keylen, GFP_KERNEL);
+		if (!ctx->key_params.key)
+			return -ENOMEM;
+
 		ctx->key_params.key_dma_addr =
-			dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+			dma_map_single(dev, (void *)ctx->key_params.key, keylen,
+				       DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
-				key, keylen);
+				ctx->key_params.key, keylen);
+			kzfree(ctx->key_params.key);
 			return -ENOMEM;
 		}
 		dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
@@ -899,6 +907,9 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 			&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 	}
+
+	kzfree(ctx->key_params.key);
+
 	return rc;
 }
 
@@ -925,11 +936,16 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 
 	ctx->key_params.keylen = keylen;
 
+	ctx->key_params.key = kmemdup(key, keylen, GFP_KERNEL);
+	if (!ctx->key_params.key)
+		return -ENOMEM;
+
 	ctx->key_params.key_dma_addr =
-		dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		dma_map_single(dev, ctx->key_params.key, keylen, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 			key, keylen);
+		kzfree(ctx->key_params.key);
 		return -ENOMEM;
 	}
 	dev_dbg(dev, "mapping key-buffer: key_dma_addr=%pad keylen=%u\n",
@@ -981,6 +997,8 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
 		&ctx->key_params.key_dma_addr, ctx->key_params.keylen);
 
+	kzfree(ctx->key_params.key);
+
 	return rc;
 }
 
-- 
2.21.0

