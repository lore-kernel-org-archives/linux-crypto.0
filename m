Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0142136358
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 07:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746429325; cv=none; b=fOeUGoVKTsHANaFEYeLYltP8wrTbNCC7bwkLdhjbmbSrc5bScBHQSk5nDn2o0B8pFcQjnUUoj+kXVDjNa3QrSFWV9PLGKuftUnZCBeexcQQZAVSKXgbbGZVSkdvhOsGM9VQcluFMTHYJc7Z7Tb0RvckCneRJqlMZltPotSWjQM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746429325; c=relaxed/simple;
	bh=zMw4b8EWQpVGxTek6bJaShzDV3w3uyyJvjbHxYm3C9M=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HcbCZmm7CEIubUPj+zXEyWDgDjI9gK57l1tkJ+5zFbSG6ZL4NOaRQ+7eKN+Ve6QluBiCX1TuLzzWrTEb52Lhh93eUSmmGSi0wr77pJFyQdp8XSI5xZVV2KLo1h0bVJZmg8ND/N5eCJRrOOTLMXHHvA4pEAzdDfv1Uct81hAFH4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=d5Z8dthW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="d5Z8dthW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eH0X/X5HAkaWV6O2ktY32auDKU6u5y3hy/lgbAfrezY=; b=d5Z8dthWDTBITy+iDETEo/IjXT
	v2D7CEL5e8STtZG6KZG4OHNKR5UHjILvo++Prbs7AZDeH04HpFrcXgm5YtTawimotZDpumyuYxH/D
	MA6BDHEJjWqRgr9Bb2keBpCiqHsaoaa2JGH/mIEi9KwK8GLZU+PvGAA8g8b8y3Rewv+zq27RzLnSF
	OymvqCfkfrT7/4b/xSubF1De6YYSpGLmf229H5rtDdO5qCZyPCjYr2spFwn9m1+OjifahNRgSR5wS
	KjZ8txTp2e685vNUt7Ao52qqlU6Ribr28B/T155zlZGSwn6tyDM+876YF8qFTnlsCxcuF6mDbHrkA
	aANKobWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBq2j-003UH9-1n;
	Mon, 05 May 2025 15:15:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 15:15:13 +0800
Date: Mon, 5 May 2025 15:15:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: crypto4xx - Remove ahash-related code
Message-ID: <aBhlgbCmoVou4DI6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The hash implementation in crypto4xx has been disabled since 2009.
As nobody has tried to fix this remove all the dead code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/amcc/crypto4xx_alg.c  | 106 ---------------------------
 drivers/crypto/amcc/crypto4xx_core.c |  43 +----------
 drivers/crypto/amcc/crypto4xx_core.h |   7 --
 3 files changed, 1 insertion(+), 155 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 289750f34ccf..38e8a61e9166 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -12,9 +12,6 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock_types.h>
 #include <linux/scatterlist.h>
-#include <linux/crypto.h>
-#include <linux/hash.h>
-#include <crypto/internal/hash.h>
 #include <linux/dma-mapping.h>
 #include <crypto/algapi.h>
 #include <crypto/aead.h>
@@ -602,106 +599,3 @@ int crypto4xx_decrypt_aes_gcm(struct aead_request *req)
 {
 	return crypto4xx_crypt_aes_gcm(req, true);
 }
-
-/*
- * HASH SHA1 Functions
- */
-static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
-				   unsigned int sa_len,
-				   unsigned char ha,
-				   unsigned char hm)
-{
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct crypto4xx_alg *my_alg;
-	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct dynamic_sa_hash160 *sa;
-	int rc;
-
-	my_alg = container_of(__crypto_ahash_alg(alg), struct crypto4xx_alg,
-			      alg.u.hash);
-	ctx->dev   = my_alg->dev;
-
-	/* Create SA */
-	if (ctx->sa_in || ctx->sa_out)
-		crypto4xx_free_sa(ctx);
-
-	rc = crypto4xx_alloc_sa(ctx, sa_len);
-	if (rc)
-		return rc;
-
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct crypto4xx_ctx));
-	sa = (struct dynamic_sa_hash160 *)ctx->sa_in;
-	set_dynamic_sa_command_0(&sa->ctrl, SA_SAVE_HASH, SA_NOT_SAVE_IV,
-				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
-				 SA_NO_HEADER_PROC, ha, SA_CIPHER_ALG_NULL,
-				 SA_PAD_TYPE_ZERO, SA_OP_GROUP_BASIC,
-				 SA_OPCODE_HASH, DIR_INBOUND);
-	set_dynamic_sa_command_1(&sa->ctrl, 0, SA_HASH_MODE_HASH,
-				 CRYPTO_FEEDBACK_MODE_NO_FB, SA_EXTENDED_SN_OFF,
-				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
-				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
-				 SA_NOT_COPY_HDR);
-	/* Need to zero hash digest in SA */
-	memset(sa->inner_digest, 0, sizeof(sa->inner_digest));
-	memset(sa->outer_digest, 0, sizeof(sa->outer_digest));
-
-	return 0;
-}
-
-int crypto4xx_hash_init(struct ahash_request *req)
-{
-	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	int ds;
-	struct dynamic_sa_ctl *sa;
-
-	sa = ctx->sa_in;
-	ds = crypto_ahash_digestsize(
-			__crypto_ahash_cast(req->base.tfm));
-	sa->sa_command_0.bf.digest_len = ds >> 2;
-	sa->sa_command_0.bf.load_hash_state = SA_LOAD_HASH_FROM_SA;
-
-	return 0;
-}
-
-int crypto4xx_hash_update(struct ahash_request *req)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct scatterlist dst;
-	unsigned int ds = crypto_ahash_digestsize(ahash);
-
-	sg_init_one(&dst, req->result, ds);
-
-	return crypto4xx_build_pd(&req->base, ctx, req->src, &dst,
-				  req->nbytes, NULL, 0, ctx->sa_in,
-				  ctx->sa_len, 0, NULL);
-}
-
-int crypto4xx_hash_final(struct ahash_request *req)
-{
-	return 0;
-}
-
-int crypto4xx_hash_digest(struct ahash_request *req)
-{
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct scatterlist dst;
-	unsigned int ds = crypto_ahash_digestsize(ahash);
-
-	sg_init_one(&dst, req->result, ds);
-
-	return crypto4xx_build_pd(&req->base, ctx, req->src, &dst,
-				  req->nbytes, NULL, 0, ctx->sa_in,
-				  ctx->sa_len, 0, NULL);
-}
-
-/*
- * SHA1 Algorithm
- */
-int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
-{
-	return crypto4xx_hash_alg_init(tfm, SA_HASH160_LEN, SA_HASH_ALG_SHA1,
-				       SA_HASH_MODE_HASH);
-}
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index c77d06ddb1ec..8cdc66d520c9 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -485,18 +485,6 @@ static void crypto4xx_copy_pkt_to_dst(struct crypto4xx_device *dev,
 	}
 }
 
-static void crypto4xx_copy_digest_to_dst(void *dst,
-					struct pd_uinfo *pd_uinfo,
-					struct crypto4xx_ctx *ctx)
-{
-	struct dynamic_sa_ctl *sa = (struct dynamic_sa_ctl *) ctx->sa_in;
-
-	if (sa->sa_command_0.bf.hash_alg == SA_HASH_ALG_SHA1) {
-		memcpy(dst, pd_uinfo->sr_va->save_digest,
-		       SA_HASH_ALG_SHA1_DIGEST_SIZE);
-	}
-}
-
 static void crypto4xx_ret_sg_desc(struct crypto4xx_device *dev,
 				  struct pd_uinfo *pd_uinfo)
 {
@@ -549,23 +537,6 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 	skcipher_request_complete(req, 0);
 }
 
-static void crypto4xx_ahash_done(struct crypto4xx_device *dev,
-				struct pd_uinfo *pd_uinfo)
-{
-	struct crypto4xx_ctx *ctx;
-	struct ahash_request *ahash_req;
-
-	ahash_req = ahash_request_cast(pd_uinfo->async_req);
-	ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(ahash_req));
-
-	crypto4xx_copy_digest_to_dst(ahash_req->result, pd_uinfo, ctx);
-	crypto4xx_ret_sg_desc(dev, pd_uinfo);
-
-	if (pd_uinfo->state & PD_ENTRY_BUSY)
-		ahash_request_complete(ahash_req, -EINPROGRESS);
-	ahash_request_complete(ahash_req, 0);
-}
-
 static void crypto4xx_aead_done(struct crypto4xx_device *dev,
 				struct pd_uinfo *pd_uinfo,
 				struct ce_pd *pd)
@@ -642,9 +613,6 @@ static void crypto4xx_pd_done(struct crypto4xx_device *dev, u32 idx)
 	case CRYPTO_ALG_TYPE_AEAD:
 		crypto4xx_aead_done(dev, pd_uinfo, pd);
 		break;
-	case CRYPTO_ALG_TYPE_AHASH:
-		crypto4xx_ahash_done(dev, pd_uinfo);
-		break;
 	}
 }
 
@@ -912,8 +880,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	}
 
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
-		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) ||
-		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
+		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
 	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
 	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
@@ -1019,10 +986,6 @@ static int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
 			rc = crypto_register_aead(&alg->alg.u.aead);
 			break;
 
-		case CRYPTO_ALG_TYPE_AHASH:
-			rc = crypto_register_ahash(&alg->alg.u.hash);
-			break;
-
 		case CRYPTO_ALG_TYPE_RNG:
 			rc = crypto_register_rng(&alg->alg.u.rng);
 			break;
@@ -1048,10 +1011,6 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 	list_for_each_entry_safe(alg, tmp, &sec_dev->alg_list, entry) {
 		list_del(&alg->entry);
 		switch (alg->alg.type) {
-		case CRYPTO_ALG_TYPE_AHASH:
-			crypto_unregister_ahash(&alg->alg.u.hash);
-			break;
-
 		case CRYPTO_ALG_TYPE_AEAD:
 			crypto_unregister_aead(&alg->alg.u.aead);
 			break;
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 9c56c7ac6e4c..ee36630c670f 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -16,7 +16,6 @@
 #include <linux/ratelimit.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
@@ -135,7 +134,6 @@ struct crypto4xx_alg_common {
 	u32 type;
 	union {
 		struct skcipher_alg cipher;
-		struct ahash_alg hash;
 		struct aead_alg aead;
 		struct rng_alg rng;
 	} u;
@@ -183,11 +181,6 @@ int crypto4xx_encrypt_noiv_block(struct skcipher_request *req);
 int crypto4xx_decrypt_noiv_block(struct skcipher_request *req);
 int crypto4xx_rfc3686_encrypt(struct skcipher_request *req);
 int crypto4xx_rfc3686_decrypt(struct skcipher_request *req);
-int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
-int crypto4xx_hash_digest(struct ahash_request *req);
-int crypto4xx_hash_final(struct ahash_request *req);
-int crypto4xx_hash_update(struct ahash_request *req);
-int crypto4xx_hash_init(struct ahash_request *req);
 
 /*
  * Note: Only use this function to copy items that is word aligned.
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
