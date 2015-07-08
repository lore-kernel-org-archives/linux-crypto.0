From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/14] crypto: nx - Use new IV convention
Date: Thu, 09 Jul 2015 07:17:31 +0800
Message-ID: <E1ZCyap-0007ag-GT@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35549 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbGHXRf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts rfc4106 to the new calling convention where
the IV is now part of the AD and needs to be skipped.  This patch
also makes use of type-safe AEAD functions where possible.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/nx/nx-aes-gcm.c |   66 ++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 92c993f..5719638 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -21,11 +21,9 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/crypto.h>
 #include <asm/vio.h>
 
 #include "nx_csbcpb.h"
@@ -36,7 +34,7 @@ static int gcm_aes_nx_set_key(struct crypto_aead *tfm,
 			      const u8           *in_key,
 			      unsigned int        key_len)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&tfm->base);
+	struct nx_crypto_ctx *nx_ctx = crypto_aead_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_csbcpb *csbcpb_aead = nx_ctx->csbcpb_aead;
 
@@ -75,7 +73,7 @@ static int gcm4106_aes_nx_set_key(struct crypto_aead *tfm,
 				  const u8           *in_key,
 				  unsigned int        key_len)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(&tfm->base);
+	struct nx_crypto_ctx *nx_ctx = crypto_aead_ctx(tfm);
 	char *nonce = nx_ctx->priv.gcm.nonce;
 	int rc;
 
@@ -110,13 +108,14 @@ static int gcm4106_aes_nx_setauthsize(struct crypto_aead *tfm,
 
 static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 		  struct aead_request   *req,
-		  u8                    *out)
+		  u8                    *out,
+		  unsigned int assoclen)
 {
 	int rc;
 	struct nx_csbcpb *csbcpb_aead = nx_ctx->csbcpb_aead;
 	struct scatter_walk walk;
 	struct nx_sg *nx_sg = nx_ctx->in_sg;
-	unsigned int nbytes = req->assoclen;
+	unsigned int nbytes = assoclen;
 	unsigned int processed = 0, to_process;
 	unsigned int max_sg_len;
 
@@ -167,7 +166,7 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 		NX_CPB_FDM(csbcpb_aead) |= NX_FDM_CONTINUATION;
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+		atomic64_add(assoclen, &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
 	} while (processed < nbytes);
@@ -177,13 +176,15 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 	return rc;
 }
 
-static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
+static int gmac(struct aead_request *req, struct blkcipher_desc *desc,
+		unsigned int assoclen)
 {
 	int rc;
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_crypto_ctx *nx_ctx =
+		crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct nx_sg *nx_sg;
-	unsigned int nbytes = req->assoclen;
+	unsigned int nbytes = assoclen;
 	unsigned int processed = 0, to_process;
 	unsigned int max_sg_len;
 
@@ -238,7 +239,7 @@ static int gmac(struct aead_request *req, struct blkcipher_desc *desc)
 		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		atomic_inc(&(nx_ctx->stats->aes_ops));
-		atomic64_add(req->assoclen, &(nx_ctx->stats->aes_bytes));
+		atomic64_add(assoclen, &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
 	} while (processed < nbytes);
@@ -253,7 +254,8 @@ static int gcm_empty(struct aead_request *req, struct blkcipher_desc *desc,
 		     int enc)
 {
 	int rc;
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_crypto_ctx *nx_ctx =
+		crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	char out[AES_BLOCK_SIZE];
 	struct nx_sg *in_sg, *out_sg;
@@ -314,9 +316,11 @@ out:
 	return rc;
 }
 
-static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
+static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
+			    unsigned int assoclen)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_crypto_ctx *nx_ctx =
+		crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	struct blkcipher_desc desc;
@@ -332,10 +336,10 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	*(u32 *)(desc.info + NX_GCM_CTR_OFFSET) = 1;
 
 	if (nbytes == 0) {
-		if (req->assoclen == 0)
+		if (assoclen == 0)
 			rc = gcm_empty(req, &desc, enc);
 		else
-			rc = gmac(req, &desc);
+			rc = gmac(req, &desc, assoclen);
 		if (rc)
 			goto out;
 		else
@@ -343,9 +347,10 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 	}
 
 	/* Process associated data */
-	csbcpb->cpb.aes_gcm.bit_length_aad = req->assoclen * 8;
-	if (req->assoclen) {
-		rc = nx_gca(nx_ctx, req, csbcpb->cpb.aes_gcm.in_pat_or_aad);
+	csbcpb->cpb.aes_gcm.bit_length_aad = assoclen * 8;
+	if (assoclen) {
+		rc = nx_gca(nx_ctx, req, csbcpb->cpb.aes_gcm.in_pat_or_aad,
+			    assoclen);
 		if (rc)
 			goto out;
 	}
@@ -363,7 +368,6 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 		to_process = nbytes - processed;
 
 		csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
-		desc.tfm = (struct crypto_blkcipher *) req->base.tfm;
 		rc = nx_build_sg_lists(nx_ctx, &desc, req->dst,
 				       req->src, &to_process,
 				       processed + req->assoclen,
@@ -430,7 +434,7 @@ static int gcm_aes_nx_encrypt(struct aead_request *req)
 
 	memcpy(iv, req->iv, 12);
 
-	return gcm_aes_nx_crypt(req, 1);
+	return gcm_aes_nx_crypt(req, 1, req->assoclen);
 }
 
 static int gcm_aes_nx_decrypt(struct aead_request *req)
@@ -440,12 +444,13 @@ static int gcm_aes_nx_decrypt(struct aead_request *req)
 
 	memcpy(iv, req->iv, 12);
 
-	return gcm_aes_nx_crypt(req, 0);
+	return gcm_aes_nx_crypt(req, 0, req->assoclen);
 }
 
 static int gcm4106_aes_nx_encrypt(struct aead_request *req)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_crypto_ctx *nx_ctx =
+		crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	char *iv = rctx->iv;
 	char *nonce = nx_ctx->priv.gcm.nonce;
@@ -453,12 +458,16 @@ static int gcm4106_aes_nx_encrypt(struct aead_request *req)
 	memcpy(iv, nonce, NX_GCM4106_NONCE_LEN);
 	memcpy(iv + NX_GCM4106_NONCE_LEN, req->iv, 8);
 
-	return gcm_aes_nx_crypt(req, 1);
+	if (req->assoclen < 8)
+		return -EINVAL;
+
+	return gcm_aes_nx_crypt(req, 1, req->assoclen - 8);
 }
 
 static int gcm4106_aes_nx_decrypt(struct aead_request *req)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(req->base.tfm);
+	struct nx_crypto_ctx *nx_ctx =
+		crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	char *iv = rctx->iv;
 	char *nonce = nx_ctx->priv.gcm.nonce;
@@ -466,7 +475,10 @@ static int gcm4106_aes_nx_decrypt(struct aead_request *req)
 	memcpy(iv, nonce, NX_GCM4106_NONCE_LEN);
 	memcpy(iv + NX_GCM4106_NONCE_LEN, req->iv, 8);
 
-	return gcm_aes_nx_crypt(req, 0);
+	if (req->assoclen < 8)
+		return -EINVAL;
+
+	return gcm_aes_nx_crypt(req, 0, req->assoclen - 8);
 }
 
 /* tell the block cipher walk routines that this is a stream cipher by
@@ -478,6 +490,7 @@ struct aead_alg nx_gcm_aes_alg = {
 	.base = {
 		.cra_name        = "gcm(aes)",
 		.cra_driver_name = "gcm-aes-nx",
+		.cra_flags	 = CRYPTO_ALG_AEAD_NEW,
 		.cra_priority    = 300,
 		.cra_blocksize   = 1,
 		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
@@ -496,6 +509,7 @@ struct aead_alg nx_gcm4106_aes_alg = {
 	.base = {
 		.cra_name        = "rfc4106(gcm(aes))",
 		.cra_driver_name = "rfc4106-gcm-aes-nx",
+		.cra_flags	 = CRYPTO_ALG_AEAD_NEW,
 		.cra_priority    = 300,
 		.cra_blocksize   = 1,
 		.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
