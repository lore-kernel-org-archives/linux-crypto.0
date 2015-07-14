From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/5] crypto: nx - Convert ccm to new AEAD interface
Date: Tue, 14 Jul 2015 16:53:21 +0800
Message-ID: <E1ZEvxp-0005di-7y@gondolin.me.apana.org.au>
References: <20150714084547.GA21551@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45165 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbGNIxZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 04:53:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the nx ccm and 4309 implementations to the
new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/nx/nx-aes-ccm.c |  153 +++++++++++++++++++----------------------
 drivers/crypto/nx/nx.c         |   21 ++---
 drivers/crypto/nx/nx.h         |    6 -
 3 files changed, 85 insertions(+), 95 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index e4311ce..195c920 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -94,8 +94,6 @@ static int ccm_aes_nx_setauthsize(struct crypto_aead *tfm,
 		return -EINVAL;
 	}
 
-	crypto_aead_crt(tfm)->authsize = authsize;
-
 	return 0;
 }
 
@@ -111,8 +109,6 @@ static int ccm4309_aes_nx_setauthsize(struct crypto_aead *tfm,
 		return -EINVAL;
 	}
 
-	crypto_aead_crt(tfm)->authsize = authsize;
-
 	return 0;
 }
 
@@ -174,6 +170,7 @@ static int generate_pat(u8                   *iv,
 			struct nx_crypto_ctx *nx_ctx,
 			unsigned int          authsize,
 			unsigned int          nbytes,
+			unsigned int	      assoclen,
 			u8                   *out)
 {
 	struct nx_sg *nx_insg = nx_ctx->in_sg;
@@ -200,16 +197,16 @@ static int generate_pat(u8                   *iv,
 	 * greater than 2^32.
 	 */
 
-	if (!req->assoclen) {
+	if (!assoclen) {
 		b0 = nx_ctx->csbcpb->cpb.aes_ccm.in_pat_or_b0;
-	} else if (req->assoclen <= 14) {
+	} else if (assoclen <= 14) {
 		/* if associated data is 14 bytes or less, we do 1 GCM
 		 * operation on 2 AES blocks, B0 (stored in the csbcpb) and B1,
 		 * which is fed in through the source buffers here */
 		b0 = nx_ctx->csbcpb->cpb.aes_ccm.in_pat_or_b0;
 		b1 = nx_ctx->priv.ccm.iauth_tag;
-		iauth_len = req->assoclen;
-	} else if (req->assoclen <= 65280) {
+		iauth_len = assoclen;
+	} else if (assoclen <= 65280) {
 		/* if associated data is less than (2^16 - 2^8), we construct
 		 * B1 differently and feed in the associated data to a CCA
 		 * operation */
@@ -223,7 +220,7 @@ static int generate_pat(u8                   *iv,
 	}
 
 	/* generate B0 */
-	rc = generate_b0(iv, req->assoclen, authsize, nbytes, b0);
+	rc = generate_b0(iv, assoclen, authsize, nbytes, b0);
 	if (rc)
 		return rc;
 
@@ -233,22 +230,22 @@ static int generate_pat(u8                   *iv,
 	 */
 	if (b1) {
 		memset(b1, 0, 16);
-		if (req->assoclen <= 65280) {
-			*(u16 *)b1 = (u16)req->assoclen;
-			scatterwalk_map_and_copy(b1 + 2, req->assoc, 0,
+		if (assoclen <= 65280) {
+			*(u16 *)b1 = assoclen;
+			scatterwalk_map_and_copy(b1 + 2, req->src, 0,
 					 iauth_len, SCATTERWALK_FROM_SG);
 		} else {
 			*(u16 *)b1 = (u16)(0xfffe);
-			*(u32 *)&b1[2] = (u32)req->assoclen;
-			scatterwalk_map_and_copy(b1 + 6, req->assoc, 0,
+			*(u32 *)&b1[2] = assoclen;
+			scatterwalk_map_and_copy(b1 + 6, req->src, 0,
 					 iauth_len, SCATTERWALK_FROM_SG);
 		}
 	}
 
 	/* now copy any remaining AAD to scatterlist and call nx... */
-	if (!req->assoclen) {
+	if (!assoclen) {
 		return rc;
-	} else if (req->assoclen <= 14) {
+	} else if (assoclen <= 14) {
 		unsigned int len = 16;
 
 		nx_insg = nx_build_sg_list(nx_insg, b1, &len, nx_ctx->ap->sglen);
@@ -280,7 +277,7 @@ static int generate_pat(u8                   *iv,
 			return rc;
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+		atomic64_add(assoclen, &nx_ctx->stats->aes_bytes);
 
 	} else {
 		unsigned int processed = 0, to_process;
@@ -294,15 +291,15 @@ static int generate_pat(u8                   *iv,
 				nx_ctx->ap->databytelen/NX_PAGE_SIZE);
 
 		do {
-			to_process = min_t(u32, req->assoclen - processed,
+			to_process = min_t(u32, assoclen - processed,
 					   nx_ctx->ap->databytelen);
 
 			nx_insg = nx_walk_and_build(nx_ctx->in_sg,
 						    nx_ctx->ap->sglen,
-						    req->assoc, processed,
+						    req->src, processed,
 						    &to_process);
 
-			if ((to_process + processed) < req->assoclen) {
+			if ((to_process + processed) < assoclen) {
 				NX_CPB_FDM(nx_ctx->csbcpb_aead) |=
 					NX_FDM_INTERMEDIATE;
 			} else {
@@ -328,11 +325,10 @@ static int generate_pat(u8                   *iv,
 			NX_CPB_FDM(nx_ctx->csbcpb_aead) |= NX_FDM_CONTINUATION;
 
 			atomic_inc(&(nx_ctx->stats->aes_ops));
-			atomic64_add(req->assoclen,
-					&(nx_ctx->stats->aes_bytes));
+			atomic64_add(assoclen, &nx_ctx->stats->aes_bytes);
 
 			processed += to_process;
-		} while (processed < req->assoclen);
+		} while (processed < assoclen);
 
 		result = nx_ctx->csbcpb_aead->cpb.aes_cca.out_pat_or_b0;
 	}
@@ -343,7 +339,8 @@ static int generate_pat(u8                   *iv,
 }
 
 static int ccm_nx_decrypt(struct aead_request   *req,
-			  struct blkcipher_desc *desc)
+			  struct blkcipher_desc *desc,
+			  unsigned int assoclen)
 {
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
@@ -360,10 +357,10 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 
 	/* copy out the auth tag to compare with later */
 	scatterwalk_map_and_copy(priv->oauth_tag,
-				 req->src, nbytes, authsize,
+				 req->src, nbytes + req->assoclen, authsize,
 				 SCATTERWALK_FROM_SG);
 
-	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes,
+	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes, assoclen,
 			  csbcpb->cpb.aes_ccm.in_pat_or_b0);
 	if (rc)
 		goto out;
@@ -383,8 +380,8 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 		NX_CPB_FDM(nx_ctx->csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
 		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
-					&to_process, processed,
-					csbcpb->cpb.aes_ccm.iv_or_ctr);
+				       &to_process, processed + req->assoclen,
+				       csbcpb->cpb.aes_ccm.iv_or_ctr);
 		if (rc)
 			goto out;
 
@@ -420,7 +417,8 @@ out:
 }
 
 static int ccm_nx_encrypt(struct aead_request   *req,
-			  struct blkcipher_desc *desc)
+			  struct blkcipher_desc *desc,
+			  unsigned int assoclen)
 {
 	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
@@ -432,7 +430,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
-	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes,
+	rc = generate_pat(desc->info, req, nx_ctx, authsize, nbytes, assoclen,
 			  csbcpb->cpb.aes_ccm.in_pat_or_b0);
 	if (rc)
 		goto out;
@@ -451,7 +449,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
 
 		rc = nx_build_sg_lists(nx_ctx, desc, req->dst, req->src,
-					&to_process, processed,
+				       &to_process, processed + req->assoclen,
 				       csbcpb->cpb.aes_ccm.iv_or_ctr);
 		if (rc)
 			goto out;
@@ -483,7 +481,7 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 
 	/* copy out the auth tag */
 	scatterwalk_map_and_copy(csbcpb->cpb.aes_ccm.out_pat_or_mac,
-				 req->dst, nbytes, authsize,
+				 req->dst, nbytes + req->assoclen, authsize,
 				 SCATTERWALK_TO_SG);
 
 out:
@@ -503,9 +501,8 @@ static int ccm4309_aes_nx_encrypt(struct aead_request *req)
 	memcpy(iv + 4, req->iv, 8);
 
 	desc.info = iv;
-	desc.tfm = (struct crypto_blkcipher *)req->base.tfm;
 
-	return ccm_nx_encrypt(req, &desc);
+	return ccm_nx_encrypt(req, &desc, req->assoclen - 8);
 }
 
 static int ccm_aes_nx_encrypt(struct aead_request *req)
@@ -514,13 +511,12 @@ static int ccm_aes_nx_encrypt(struct aead_request *req)
 	int rc;
 
 	desc.info = req->iv;
-	desc.tfm = (struct crypto_blkcipher *)req->base.tfm;
 
 	rc = crypto_ccm_check_iv(desc.info);
 	if (rc)
 		return rc;
 
-	return ccm_nx_encrypt(req, &desc);
+	return ccm_nx_encrypt(req, &desc, req->assoclen);
 }
 
 static int ccm4309_aes_nx_decrypt(struct aead_request *req)
@@ -535,9 +531,8 @@ static int ccm4309_aes_nx_decrypt(struct aead_request *req)
 	memcpy(iv + 4, req->iv, 8);
 
 	desc.info = iv;
-	desc.tfm = (struct crypto_blkcipher *)req->base.tfm;
 
-	return ccm_nx_decrypt(req, &desc);
+	return ccm_nx_decrypt(req, &desc, req->assoclen - 8);
 }
 
 static int ccm_aes_nx_decrypt(struct aead_request *req)
@@ -546,13 +541,12 @@ static int ccm_aes_nx_decrypt(struct aead_request *req)
 	int rc;
 
 	desc.info = req->iv;
-	desc.tfm = (struct crypto_blkcipher *)req->base.tfm;
 
 	rc = crypto_ccm_check_iv(desc.info);
 	if (rc)
 		return rc;
 
-	return ccm_nx_decrypt(req, &desc);
+	return ccm_nx_decrypt(req, &desc, req->assoclen);
 }
 
 /* tell the block cipher walk routines that this is a stream cipher by
@@ -560,47 +554,44 @@ static int ccm_aes_nx_decrypt(struct aead_request *req)
  * during encrypt/decrypt doesn't solve this problem, because it calls
  * blkcipher_walk_done under the covers, which doesn't use walk->blocksize,
  * but instead uses this tfm->blocksize. */
-struct crypto_alg nx_ccm_aes_alg = {
-	.cra_name        = "ccm(aes)",
-	.cra_driver_name = "ccm-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_AEAD |
-			   CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize   = 1,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_aead_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_ccm_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_aead = {
-		.ivsize      = AES_BLOCK_SIZE,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setkey      = ccm_aes_nx_set_key,
-		.setauthsize = ccm_aes_nx_setauthsize,
-		.encrypt     = ccm_aes_nx_encrypt,
-		.decrypt     = ccm_aes_nx_decrypt,
-	}
+struct aead_alg nx_ccm_aes_alg = {
+	.base = {
+		.cra_name        = "ccm(aes)",
+		.cra_driver_name = "ccm-aes-nx",
+		.cra_priority    = 300,
+		.cra_flags       = CRYPTO_ALG_NEED_FALLBACK |
+				   CRYPTO_ALG_AEAD_NEW,
+		.cra_blocksize   = 1,
+		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+		.cra_module      = THIS_MODULE,
+	},
+	.init        = nx_crypto_ctx_aes_ccm_init,
+	.exit        = nx_crypto_ctx_aead_exit,
+	.ivsize      = AES_BLOCK_SIZE,
+	.maxauthsize = AES_BLOCK_SIZE,
+	.setkey      = ccm_aes_nx_set_key,
+	.setauthsize = ccm_aes_nx_setauthsize,
+	.encrypt     = ccm_aes_nx_encrypt,
+	.decrypt     = ccm_aes_nx_decrypt,
 };
 
-struct crypto_alg nx_ccm4309_aes_alg = {
-	.cra_name        = "rfc4309(ccm(aes))",
-	.cra_driver_name = "rfc4309-ccm-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_AEAD |
-			   CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize   = 1,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_nivaead_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_ccm_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_aead = {
-		.ivsize      = 8,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setkey      = ccm4309_aes_nx_set_key,
-		.setauthsize = ccm4309_aes_nx_setauthsize,
-		.encrypt     = ccm4309_aes_nx_encrypt,
-		.decrypt     = ccm4309_aes_nx_decrypt,
-		.geniv       = "seqiv",
-	}
+struct aead_alg nx_ccm4309_aes_alg = {
+	.base = {
+		.cra_name        = "rfc4309(ccm(aes))",
+		.cra_driver_name = "rfc4309-ccm-aes-nx",
+		.cra_priority    = 300,
+		.cra_flags       = CRYPTO_ALG_NEED_FALLBACK |
+				   CRYPTO_ALG_AEAD_NEW,
+		.cra_blocksize   = 1,
+		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+		.cra_module      = THIS_MODULE,
+	},
+	.init        = nx_crypto_ctx_aes_ccm_init,
+	.exit        = nx_crypto_ctx_aead_exit,
+	.ivsize      = 8,
+	.maxauthsize = AES_BLOCK_SIZE,
+	.setkey      = ccm4309_aes_nx_set_key,
+	.setauthsize = ccm4309_aes_nx_setauthsize,
+	.encrypt     = ccm4309_aes_nx_encrypt,
+	.decrypt     = ccm4309_aes_nx_decrypt,
 };
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 4369713..9a5e643 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -612,11 +612,11 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_gcm;
 
-	rc = nx_register_alg(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
+	rc = nx_register_aead(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 	if (rc)
 		goto out_unreg_gcm4106;
 
-	rc = nx_register_alg(&nx_ccm4309_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
+	rc = nx_register_aead(&nx_ccm4309_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 	if (rc)
 		goto out_unreg_ccm;
 
@@ -644,9 +644,9 @@ out_unreg_s256:
 	nx_unregister_shash(&nx_shash_sha256_alg, NX_FC_SHA, NX_MODE_SHA,
 			    NX_PROPS_SHA256);
 out_unreg_ccm4309:
-	nx_unregister_alg(&nx_ccm4309_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
+	nx_unregister_aead(&nx_ccm4309_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 out_unreg_ccm:
-	nx_unregister_alg(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
+	nx_unregister_aead(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 out_unreg_gcm4106:
 	nx_unregister_aead(&nx_gcm4106_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 out_unreg_gcm:
@@ -711,11 +711,10 @@ static int nx_crypto_ctx_init(struct nx_crypto_ctx *nx_ctx, u32 fc, u32 mode)
 }
 
 /* entry points from the crypto tfm initializers */
-int nx_crypto_ctx_aes_ccm_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm)
 {
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-				sizeof(struct nx_ccm_rctx));
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
+	crypto_aead_set_reqsize(tfm, sizeof(struct nx_ccm_rctx));
+	return nx_crypto_ctx_init(crypto_aead_ctx(tfm), NX_FC_AES,
 				  NX_MODE_AES_CCM);
 }
 
@@ -813,9 +812,9 @@ static int nx_remove(struct vio_dev *viodev)
 				    NX_FC_SHA, NX_MODE_SHA, NX_PROPS_SHA256);
 		nx_unregister_shash(&nx_shash_sha256_alg,
 				    NX_FC_SHA, NX_MODE_SHA, NX_PROPS_SHA512);
-		nx_unregister_alg(&nx_ccm4309_aes_alg,
-				  NX_FC_AES, NX_MODE_AES_CCM);
-		nx_unregister_alg(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
+		nx_unregister_aead(&nx_ccm4309_aes_alg,
+				   NX_FC_AES, NX_MODE_AES_CCM);
+		nx_unregister_aead(&nx_ccm_aes_alg, NX_FC_AES, NX_MODE_AES_CCM);
 		nx_unregister_aead(&nx_gcm4106_aes_alg,
 				   NX_FC_AES, NX_MODE_AES_GCM);
 		nx_unregister_aead(&nx_gcm_aes_alg,
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index cdff03a..8a4d1fd 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -150,7 +150,7 @@ struct nx_crypto_ctx {
 };
 
 /* prototypes */
-int nx_crypto_ctx_aes_ccm_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm);
@@ -189,8 +189,8 @@ extern struct aead_alg nx_gcm_aes_alg;
 extern struct aead_alg nx_gcm4106_aes_alg;
 extern struct crypto_alg nx_ctr_aes_alg;
 extern struct crypto_alg nx_ctr3686_aes_alg;
-extern struct crypto_alg nx_ccm_aes_alg;
-extern struct crypto_alg nx_ccm4309_aes_alg;
+extern struct aead_alg nx_ccm_aes_alg;
+extern struct aead_alg nx_ccm4309_aes_alg;
 extern struct shash_alg nx_shash_aes_xcbc_alg;
 extern struct shash_alg nx_shash_sha512_alg;
 extern struct shash_alg nx_shash_sha256_alg;
