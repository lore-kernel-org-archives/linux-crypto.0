From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 10/13] crypto: crypto4xx: simplify sa and state context acquisition
Date: Wed,  4 Oct 2017 01:00:14 +0200
Message-ID: <6a5a2518ef14e783e87963ab783b7fd12f775661.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34941 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXA2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:28 -0400
Received: by mail-wr0-f194.google.com with SMTP id y44so1822509wry.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:27 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks to the big overhaul of crypto4xx_build_pd(), the request-local
sa_in, sa_out and state_record allocation can be simplified.

There's no need to setup any dma coherent memory anymore and
much of the support code can be removed.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c  | 27 +++++--------------
 drivers/crypto/amcc/crypto4xx_core.c | 50 ++++++------------------------------
 drivers/crypto/amcc/crypto4xx_core.h |  6 +----
 3 files changed, 15 insertions(+), 68 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 195445310f0c..22875ec2b2c8 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -122,20 +122,13 @@ static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
 	}
 
 	/* Create SA */
-	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+	if (ctx->sa_in || ctx->sa_out)
 		crypto4xx_free_sa(ctx);
 
 	rc = crypto4xx_alloc_sa(ctx, SA_AES128_LEN + (keylen-16) / 4);
 	if (rc)
 		return rc;
 
-	if (ctx->state_record_dma_addr == 0) {
-		rc = crypto4xx_alloc_state_record(ctx);
-		if (rc) {
-			crypto4xx_free_sa(ctx);
-			return rc;
-		}
-	}
 	/* Setup SA */
 	sa = ctx->sa_in;
 
@@ -203,8 +196,8 @@ int crypto4xx_setkey_rfc3686(struct crypto_ablkcipher *cipher,
 	if (rc)
 		return rc;
 
-	crypto4xx_memcpy_to_le32(ctx->state_record->save_iv,
-		key + keylen - CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
+	ctx->iv_nonce = cpu_to_le32p((u32 *)&key[keylen -
+						 CTR_RFC3686_NONCE_SIZE]);
 
 	return 0;
 }
@@ -213,7 +206,7 @@ int crypto4xx_rfc3686_encrypt(struct ablkcipher_request *req)
 {
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	__le32 iv[AES_IV_SIZE / 4] = {
-		ctx->state_record->save_iv[0],
+		ctx->iv_nonce,
 		cpu_to_le32p((u32 *) req->info),
 		cpu_to_le32p((u32 *) (req->info + 4)),
 		cpu_to_le32(1) };
@@ -227,7 +220,7 @@ int crypto4xx_rfc3686_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	__le32 iv[AES_IV_SIZE / 4] = {
-		ctx->state_record->save_iv[0],
+		ctx->iv_nonce,
 		cpu_to_le32p((u32 *) req->info),
 		cpu_to_le32p((u32 *) (req->info + 4)),
 		cpu_to_le32(1) };
@@ -254,21 +247,13 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 	ctx->dev   = my_alg->dev;
 
 	/* Create SA */
-	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+	if (ctx->sa_in || ctx->sa_out)
 		crypto4xx_free_sa(ctx);
 
 	rc = crypto4xx_alloc_sa(ctx, sa_len);
 	if (rc)
 		return rc;
 
-	if (ctx->state_record_dma_addr == 0) {
-		crypto4xx_alloc_state_record(ctx);
-		if (!ctx->state_record_dma_addr) {
-			crypto4xx_free_sa(ctx);
-			return -ENOMEM;
-		}
-	}
-
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct crypto4xx_ctx));
 	sa = (struct dynamic_sa_hash160 *)ctx->sa_in;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index de9044201a23..55a4dd8984c7 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -130,21 +130,17 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 
 int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
 {
-	ctx->sa_in = dma_alloc_coherent(ctx->dev->core_dev->device, size * 4,
-					&ctx->sa_in_dma_addr, GFP_ATOMIC);
+	ctx->sa_in = kzalloc(size * 4, GFP_ATOMIC);
 	if (ctx->sa_in == NULL)
 		return -ENOMEM;
 
-	ctx->sa_out = dma_alloc_coherent(ctx->dev->core_dev->device, size * 4,
-					 &ctx->sa_out_dma_addr, GFP_ATOMIC);
+	ctx->sa_out = kzalloc(size * 4, GFP_ATOMIC);
 	if (ctx->sa_out == NULL) {
-		dma_free_coherent(ctx->dev->core_dev->device, size * 4,
-				  ctx->sa_in, ctx->sa_in_dma_addr);
+		kfree(ctx->sa_in);
+		ctx->sa_in = NULL;
 		return -ENOMEM;
 	}
 
-	memset(ctx->sa_in, 0, size * 4);
-	memset(ctx->sa_out, 0, size * 4);
 	ctx->sa_len = size;
 
 	return 0;
@@ -152,40 +148,13 @@ int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
 
 void crypto4xx_free_sa(struct crypto4xx_ctx *ctx)
 {
-	if (ctx->sa_in != NULL)
-		dma_free_coherent(ctx->dev->core_dev->device, ctx->sa_len * 4,
-				  ctx->sa_in, ctx->sa_in_dma_addr);
-	if (ctx->sa_out != NULL)
-		dma_free_coherent(ctx->dev->core_dev->device, ctx->sa_len * 4,
-				  ctx->sa_out, ctx->sa_out_dma_addr);
-
-	ctx->sa_in_dma_addr = 0;
-	ctx->sa_out_dma_addr = 0;
+	kfree(ctx->sa_in);
+	ctx->sa_in = NULL;
+	kfree(ctx->sa_out);
+	ctx->sa_out = NULL;
 	ctx->sa_len = 0;
 }
 
-u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx)
-{
-	ctx->state_record = dma_alloc_coherent(ctx->dev->core_dev->device,
-				sizeof(struct sa_state_record),
-				&ctx->state_record_dma_addr, GFP_ATOMIC);
-	if (!ctx->state_record_dma_addr)
-		return -ENOMEM;
-	memset(ctx->state_record, 0, sizeof(struct sa_state_record));
-
-	return 0;
-}
-
-static void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx)
-{
-	if (ctx->state_record != NULL)
-		dma_free_coherent(ctx->dev->core_dev->device,
-				  sizeof(struct sa_state_record),
-				  ctx->state_record,
-				  ctx->state_record_dma_addr);
-	ctx->state_record_dma_addr = 0;
-}
-
 /**
  * alloc memory for the gather ring
  * no need to alloc buf for the ring
@@ -883,8 +852,6 @@ static int crypto4xx_alg_init(struct crypto_tfm *tfm)
 	ctx->dev = amcc_alg->dev;
 	ctx->sa_in = NULL;
 	ctx->sa_out = NULL;
-	ctx->sa_in_dma_addr = 0;
-	ctx->sa_out_dma_addr = 0;
 	ctx->sa_len = 0;
 
 	switch (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
@@ -905,7 +872,6 @@ static void crypto4xx_alg_exit(struct crypto_tfm *tfm)
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	crypto4xx_free_sa(ctx);
-	crypto4xx_free_state_record(ctx);
 }
 
 int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index b1d634b0f44f..650aa94cc4b8 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -122,11 +122,8 @@ struct crypto4xx_core_device {
 struct crypto4xx_ctx {
 	struct crypto4xx_device *dev;
 	struct dynamic_sa_ctl *sa_in;
-	dma_addr_t sa_in_dma_addr;
 	struct dynamic_sa_ctl *sa_out;
-	dma_addr_t sa_out_dma_addr;
-	struct sa_state_record *state_record;
-	dma_addr_t state_record_dma_addr;
+	__le32 iv_nonce;
 	u32 sa_len;
 };
 
@@ -159,7 +156,6 @@ static inline struct crypto4xx_alg *crypto_alg_to_crypto4xx_alg(
 int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
 void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
 void crypto4xx_free_ctx(struct crypto4xx_ctx *ctx);
-u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
 int crypto4xx_build_pd(struct crypto_async_request *req,
 		       struct crypto4xx_ctx *ctx,
 		       struct scatterlist *src,
-- 
2.14.2
