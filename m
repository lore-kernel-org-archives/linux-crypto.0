Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9C6ECE587
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44282206B7
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570941635;
	bh=UnPLR2/eX2uTRMGWc5kdNGr+F44XlgaJQFekeu5nu4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=N0Jad9NWSo+pXxlJpGnG6FGY+tEk5XlmwLNzAkQtTz6bob8CIVAgCAbOFfxMfGIku
	 MG2F1lrDQqtoxEq9Tr+yTiUN0dvVOGNnpYy70/4OfOkNifNToJ2nM2i6Tt+wdufIKr
	 flv819RoiUC+DfHUAQcx/7XLh6OdyFkGuhA+ymBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfJMEke (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 00:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfJMEkc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 00:40:32 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D75820869;
        Sun, 13 Oct 2019 04:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570941631;
        bh=UnPLR2/eX2uTRMGWc5kdNGr+F44XlgaJQFekeu5nu4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCCBOfVgYaLyEzZqtzqBKVefmyo5BSK54iksc50WnhMa/q7zyJHK3VheBKojHM8gA
         5mY2Dc80v2evEXLwRe9fOjTGq12BVSAlC9Ab3SpYCoawdbBqD0P8zuLvrpKRBi58XN
         ZLdIWtZhN6DcBCV7CSaXFkaaN6EH9KOlNaxV0pQw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: [PATCH 4/4] crypto: nx - convert AES-CTR to skcipher API
Date:   Sat, 12 Oct 2019 21:39:18 -0700
Message-Id: <20191013043918.337113-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191013043918.337113-1-ebiggers@kernel.org>
References: <20191013043918.337113-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the PowerPC Nest (NX) implementation of AES-CTR from the
deprecated "blkcipher" API to the "skcipher" API.  This is needed in
order for the blkcipher API to be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/nx/nx-aes-ctr.c | 84 +++++++++++++++-------------------
 drivers/crypto/nx/nx.c         | 25 +++-------
 drivers/crypto/nx/nx.h         |  4 +-
 3 files changed, 46 insertions(+), 67 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 05e558cefe94..6d5ce1a66f1e 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -19,11 +19,11 @@
 #include "nx.h"
 
 
-static int ctr_aes_nx_set_key(struct crypto_tfm *tfm,
-			      const u8          *in_key,
-			      unsigned int       key_len)
+static int ctr_aes_nx_set_key(struct crypto_skcipher *tfm,
+			      const u8               *in_key,
+			      unsigned int            key_len)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 
 	nx_ctx_init(nx_ctx, HCOP_FC_AES);
@@ -51,11 +51,11 @@ static int ctr_aes_nx_set_key(struct crypto_tfm *tfm,
 	return 0;
 }
 
-static int ctr3686_aes_nx_set_key(struct crypto_tfm *tfm,
-				  const u8          *in_key,
-				  unsigned int       key_len)
+static int ctr3686_aes_nx_set_key(struct crypto_skcipher *tfm,
+				  const u8               *in_key,
+				  unsigned int            key_len)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 
 	if (key_len < CTR_RFC3686_NONCE_SIZE)
 		return -EINVAL;
@@ -69,12 +69,10 @@ static int ctr3686_aes_nx_set_key(struct crypto_tfm *tfm,
 	return ctr_aes_nx_set_key(tfm, in_key, key_len);
 }
 
-static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
-			    struct scatterlist    *dst,
-			    struct scatterlist    *src,
-			    unsigned int           nbytes)
+static int ctr_aes_nx_crypt(struct skcipher_request *req, u8 *iv)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
@@ -83,9 +81,9 @@ static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
 	do {
-		to_process = nbytes - processed;
+		to_process = req->cryptlen - processed;
 
-		rc = nx_build_sg_lists(nx_ctx, desc->info, dst, src,
+		rc = nx_build_sg_lists(nx_ctx, iv, req->dst, req->src,
 				       &to_process, processed,
 				       csbcpb->cpb.aes_ctr.iv);
 		if (rc)
@@ -97,59 +95,51 @@ static int ctr_aes_nx_crypt(struct blkcipher_desc *desc,
 		}
 
 		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
 
-		memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
+		memcpy(iv, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
 		atomic64_add(csbcpb->csb.processed_byte_count,
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
-	} while (processed < nbytes);
+	} while (processed < req->cryptlen);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
 
-static int ctr3686_aes_nx_crypt(struct blkcipher_desc *desc,
-				struct scatterlist    *dst,
-				struct scatterlist    *src,
-				unsigned int           nbytes)
+static int ctr3686_aes_nx_crypt(struct skcipher_request *req)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	u8 iv[16];
 
 	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
-	memcpy(iv + CTR_RFC3686_NONCE_SIZE,
-	       desc->info, CTR_RFC3686_IV_SIZE);
+	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
 	iv[12] = iv[13] = iv[14] = 0;
 	iv[15] = 1;
 
-	desc->info = iv;
-
-	return ctr_aes_nx_crypt(desc, dst, src, nbytes);
+	return ctr_aes_nx_crypt(req, iv);
 }
 
-struct crypto_alg nx_ctr3686_aes_alg = {
-	.cra_name        = "rfc3686(ctr(aes))",
-	.cra_driver_name = "rfc3686-ctr-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize   = 1,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_blkcipher_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_ctr_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_blkcipher = {
-		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-		.ivsize      = CTR_RFC3686_IV_SIZE,
-		.setkey      = ctr3686_aes_nx_set_key,
-		.encrypt     = ctr3686_aes_nx_crypt,
-		.decrypt     = ctr3686_aes_nx_crypt,
-	}
+struct skcipher_alg nx_ctr3686_aes_alg = {
+	.base.cra_name		= "rfc3686(ctr(aes))",
+	.base.cra_driver_name	= "rfc3686-ctr-aes-nx",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct nx_crypto_ctx),
+	.base.cra_module	= THIS_MODULE,
+	.init			= nx_crypto_ctx_aes_ctr_init,
+	.exit			= nx_crypto_ctx_skcipher_exit,
+	.min_keysize		= AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+	.ivsize			= CTR_RFC3686_IV_SIZE,
+	.setkey			= ctr3686_aes_nx_set_key,
+	.encrypt		= ctr3686_aes_nx_crypt,
+	.decrypt		= ctr3686_aes_nx_crypt,
+	.chunksize		= AES_BLOCK_SIZE,
 };
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 8e5367776ca0..f03c238f5a31 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -511,12 +511,6 @@ static bool nx_check_props(struct device *dev, u32 fc, u32 mode)
 	return true;
 }
 
-static int nx_register_alg(struct crypto_alg *alg, u32 fc, u32 mode)
-{
-	return nx_check_props(&nx_driver.viodev->dev, fc, mode) ?
-	       crypto_register_alg(alg) : 0;
-}
-
 static int nx_register_skcipher(struct skcipher_alg *alg, u32 fc, u32 mode)
 {
 	return nx_check_props(&nx_driver.viodev->dev, fc, mode) ?
@@ -537,12 +531,6 @@ static int nx_register_shash(struct shash_alg *alg, u32 fc, u32 mode, int slot)
 	       crypto_register_shash(alg) : 0;
 }
 
-static void nx_unregister_alg(struct crypto_alg *alg, u32 fc, u32 mode)
-{
-	if (nx_check_props(NULL, fc, mode))
-		crypto_unregister_alg(alg);
-}
-
 static void nx_unregister_skcipher(struct skcipher_alg *alg, u32 fc, u32 mode)
 {
 	if (nx_check_props(NULL, fc, mode))
@@ -593,7 +581,8 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_ecb;
 
-	rc = nx_register_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
+	rc = nx_register_skcipher(&nx_ctr3686_aes_alg, NX_FC_AES,
+				  NX_MODE_AES_CTR);
 	if (rc)
 		goto out_unreg_cbc;
 
@@ -645,7 +634,7 @@ static int nx_register_algs(void)
 out_unreg_gcm:
 	nx_unregister_aead(&nx_gcm_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 out_unreg_ctr3686:
-	nx_unregister_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
+	nx_unregister_skcipher(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 out_unreg_cbc:
 	nx_unregister_skcipher(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 out_unreg_ecb:
@@ -716,9 +705,9 @@ int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm)
 				  NX_MODE_AES_GCM);
 }
 
-int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_aes_ctr_init(struct crypto_skcipher *tfm)
 {
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
+	return nx_crypto_ctx_init(crypto_skcipher_ctx(tfm), NX_FC_AES,
 				  NX_MODE_AES_CTR);
 }
 
@@ -815,8 +804,8 @@ static int nx_remove(struct vio_dev *viodev)
 				   NX_FC_AES, NX_MODE_AES_GCM);
 		nx_unregister_aead(&nx_gcm_aes_alg,
 				   NX_FC_AES, NX_MODE_AES_GCM);
-		nx_unregister_alg(&nx_ctr3686_aes_alg,
-				  NX_FC_AES, NX_MODE_AES_CTR);
+		nx_unregister_skcipher(&nx_ctr3686_aes_alg,
+				       NX_FC_AES, NX_MODE_AES_CTR);
 		nx_unregister_skcipher(&nx_cbc_aes_alg, NX_FC_AES,
 				       NX_MODE_AES_CBC);
 		nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES,
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 2e1a3e5e65cb..91c54289124a 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -145,7 +145,7 @@ struct crypto_aead;
 int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
-int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_aes_ctr_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm);
@@ -180,7 +180,7 @@ extern struct skcipher_alg nx_cbc_aes_alg;
 extern struct skcipher_alg nx_ecb_aes_alg;
 extern struct aead_alg nx_gcm_aes_alg;
 extern struct aead_alg nx_gcm4106_aes_alg;
-extern struct crypto_alg nx_ctr3686_aes_alg;
+extern struct skcipher_alg nx_ctr3686_aes_alg;
 extern struct aead_alg nx_ccm_aes_alg;
 extern struct aead_alg nx_ccm4309_aes_alg;
 extern struct shash_alg nx_shash_aes_xcbc_alg;
-- 
2.23.0

