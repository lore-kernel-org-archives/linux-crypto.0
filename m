Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DCFC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 544DD20674
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389274AbfDRNmO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:42:14 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33762 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389270AbfDRNmN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:42:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74BC11688;
        Thu, 18 Apr 2019 06:42:12 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CCFA43F5AF;
        Thu, 18 Apr 2019 06:42:10 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 30/35] crypto: ccree: don't map AEAD key and IV on stack
Date:   Thu, 18 Apr 2019 16:39:05 +0300
Message-Id: <20190418133913.9122-31-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AEAD authenc key and IVs might be passed to us on stack. Copy it to
a slab buffer before mapping to gurantee proper DMA mapping.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_aead.c       | 11 ++++++++++-
 drivers/crypto/ccree/cc_buffer_mgr.c | 15 ++++++++++++---
 drivers/crypto/ccree/cc_driver.h     |  1 +
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 7447fd0ff48e..ca44a227b211 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -424,7 +424,7 @@ static int validate_keys_sizes(struct cc_aead_ctx *ctx)
 /* This function prepers the user key so it can pass to the hmac processing
  * (copy to intenral buffer or hash in case of key longer than block
  */
-static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *authkey,
 				 unsigned int keylen)
 {
 	dma_addr_t key_dma_addr = 0;
@@ -437,6 +437,7 @@ static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 	unsigned int hashmode;
 	unsigned int idx = 0;
 	int rc = 0;
+	u8 *key = NULL;
 	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
 	dma_addr_t padded_authkey_dma_addr =
 		ctx->auth_state.hmac.padded_authkey_dma_addr;
@@ -455,11 +456,17 @@ static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 	}
 
 	if (keylen != 0) {
+
+		key = kmemdup(authkey, keylen, GFP_KERNEL);
+		if (!key)
+			return -ENOMEM;
+
 		key_dma_addr = dma_map_single(dev, (void *)key, keylen,
 					      DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
+			kzfree(key);
 			return -ENOMEM;
 		}
 		if (keylen > blocksize) {
@@ -542,6 +549,8 @@ static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 	if (key_dma_addr)
 		dma_unmap_single(dev, key_dma_addr, keylen, DMA_TO_DEVICE);
 
+	kzfree(key);
+
 	return rc;
 }
 
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 09dceec7d828..c81ad33f9115 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -557,6 +557,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	if (areq_ctx->gen_ctx.iv_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
 				 hw_iv_size, DMA_BIDIRECTIONAL);
+		kzfree(areq_ctx->gen_ctx.iv);
 	}
 
 	/* Release pool */
@@ -607,19 +608,27 @@ static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
 	struct device *dev = drvdata_to_dev(drvdata);
+	gfp_t flags = cc_gfp_flags(&req->base);
 	int rc = 0;
 
 	if (!req->iv) {
 		areq_ctx->gen_ctx.iv_dma_addr = 0;
+		areq_ctx->gen_ctx.iv = NULL;
 		goto chain_iv_exit;
 	}
 
-	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
-						       hw_iv_size,
-						       DMA_BIDIRECTIONAL);
+	areq_ctx->gen_ctx.iv = kmemdup(req->iv, hw_iv_size, flags);
+	if (!areq_ctx->gen_ctx.iv)
+		return -ENOMEM;
+
+	areq_ctx->gen_ctx.iv_dma_addr =
+		dma_map_single(dev, areq_ctx->gen_ctx.iv, hw_iv_size,
+			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
 		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
 			hw_iv_size, req->iv);
+		kzfree(areq_ctx->gen_ctx.iv);
+		areq_ctx->gen_ctx.iv = NULL;
 		rc = -ENOMEM;
 		goto chain_iv_exit;
 	}
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 935ae0ba75c0..cc403d705c9d 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -204,6 +204,7 @@ struct cc_alg_template {
 
 struct async_gen_req_ctx {
 	dma_addr_t iv_dma_addr;
+	u8 *iv;
 	enum drv_crypto_direction op_type;
 };
 
-- 
2.21.0

