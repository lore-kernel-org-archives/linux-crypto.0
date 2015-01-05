From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: qat - Fix incorrect uses of memzero_explicit
Date: Tue, 6 Jan 2015 07:54:41 +1100
Message-ID: <20150105205441.GB10985@gondor.apana.org.au>
References: <20150105054813.GA23110@gondor.apana.org.au>
 <54AACE91.7070904@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46827 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbAEUyr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 15:54:47 -0500
Content-Disposition: inline
In-Reply-To: <54AACE91.7070904@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 05, 2015 at 09:49:05AM -0800, Tadeusz Struk wrote:
> On 01/04/2015 09:48 PM, Herbert Xu wrote:
> > memzero_explicit should only be used on stack variables that get
> > zapped just before they go out of scope.
> > 
> > This patch replaces all unnecessary uses of memzero_explicit with
> > memset, removes two memzero_explicit calls altogether as the tfm
> > context comes pre-zeroed, and adds a missing memzero_explicit of
> > the stack variable buff in qat_alg_do_precomputes.  The memzeros
> > on ipad/opad + digest_size/auth_keylen are also removed as the
> > entire auth_state is already zeroed on entry.
> 
> Hi Herbert,
> Except the bad indentation in lines 1176 & 1183 :) this looks ok to me.
> Thanks.

Thanks, here is the fixed version.

-- >8 --
memzero_explicit should only be used on stack variables that get
zapped just before they go out of scope.

This patch replaces all unnecessary uses of memzero_explicit with
memset, removes two memzero_explicit calls altogether as the tfm
context comes pre-zeroed, and adds a missing memzero_explicit of
the stack variable buff in qat_alg_do_precomputes.  The memzeros
on ipad/opad + digest_size/auth_keylen are also removed as the
entire auth_state is already zeroed on entry.
  
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f32d0a5..a0d95f3 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -173,7 +173,7 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	__be64 *hash512_state_out;
 	int i, offset;
 
-	memzero_explicit(auth_state.data, MAX_AUTH_STATE_SIZE + 64);
+	memset(auth_state.data, 0, sizeof(auth_state.data));
 	shash->tfm = ctx->hash_tfm;
 	shash->flags = 0x0;
 
@@ -186,13 +186,10 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 		memcpy(ipad, buff, digest_size);
 		memcpy(opad, buff, digest_size);
-		memzero_explicit(ipad + digest_size, block_size - digest_size);
-		memzero_explicit(opad + digest_size, block_size - digest_size);
+		memzero_explicit(buff, sizeof(buff));
 	} else {
 		memcpy(ipad, auth_key, auth_keylen);
 		memcpy(opad, auth_key, auth_keylen);
-		memzero_explicit(ipad + auth_keylen, block_size - auth_keylen);
-		memzero_explicit(opad + auth_keylen, block_size - auth_keylen);
 	}
 
 	for (i = 0; i < block_size; i++) {
@@ -582,10 +579,10 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	if (ctx->enc_cd) {
 		/* rekeying */
 		dev = &GET_DEV(ctx->inst->accel_dev);
-		memzero_explicit(ctx->enc_cd, sizeof(*ctx->enc_cd));
-		memzero_explicit(ctx->dec_cd, sizeof(*ctx->dec_cd));
-		memzero_explicit(&ctx->enc_fw_req, sizeof(ctx->enc_fw_req));
-		memzero_explicit(&ctx->dec_fw_req, sizeof(ctx->dec_fw_req));
+		memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
+		memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
+		memset(&ctx->enc_fw_req, 0, sizeof(ctx->enc_fw_req));
+		memset(&ctx->dec_fw_req, 0, sizeof(ctx->dec_fw_req));
 	} else {
 		/* new key */
 		int node = get_current_node();
@@ -620,12 +617,12 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	return 0;
 
 out_free_all:
-	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
+	memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
 out_free_enc:
-	memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
+	memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
@@ -969,10 +966,10 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	if (ctx->enc_cd) {
 		/* rekeying */
 		dev = &GET_DEV(ctx->inst->accel_dev);
-		memzero_explicit(ctx->enc_cd, sizeof(*ctx->enc_cd));
-		memzero_explicit(ctx->dec_cd, sizeof(*ctx->dec_cd));
-		memzero_explicit(&ctx->enc_fw_req, sizeof(ctx->enc_fw_req));
-		memzero_explicit(&ctx->dec_fw_req, sizeof(ctx->dec_fw_req));
+		memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
+		memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
+		memset(&ctx->enc_fw_req, 0, sizeof(ctx->enc_fw_req));
+		memset(&ctx->dec_fw_req, 0, sizeof(ctx->dec_fw_req));
 	} else {
 		/* new key */
 		int node = get_current_node();
@@ -1007,12 +1004,12 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	return 0;
 
 out_free_all:
-	memzero_explicit(ctx->dec_cd, sizeof(*ctx->enc_cd));
+	memset(ctx->dec_cd, 0, sizeof(*ctx->enc_cd));
 	dma_free_coherent(dev, sizeof(*ctx->enc_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
 out_free_enc:
-	memzero_explicit(ctx->enc_cd, sizeof(*ctx->dec_cd));
+	memset(ctx->enc_cd, 0, sizeof(*ctx->dec_cd));
 	dma_free_coherent(dev, sizeof(*ctx->dec_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
@@ -1101,7 +1098,6 @@ static int qat_alg_aead_init(struct crypto_tfm *tfm,
 {
 	struct qat_alg_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	memzero_explicit(ctx, sizeof(*ctx));
 	ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
 	if (IS_ERR(ctx->hash_tfm))
 		return -EFAULT;
@@ -1142,12 +1138,12 @@ static void qat_alg_aead_exit(struct crypto_tfm *tfm)
 
 	dev = &GET_DEV(inst->accel_dev);
 	if (ctx->enc_cd) {
-		memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
+		memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->enc_cd, ctx->enc_cd_paddr);
 	}
 	if (ctx->dec_cd) {
-		memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
+		memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
 	}
@@ -1158,7 +1154,6 @@ static int qat_alg_ablkcipher_init(struct crypto_tfm *tfm)
 {
 	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	memzero_explicit(ctx, sizeof(*ctx));
 	spin_lock_init(&ctx->lock);
 	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
 					sizeof(struct qat_crypto_request);
@@ -1177,15 +1172,15 @@ static void qat_alg_ablkcipher_exit(struct crypto_tfm *tfm)
 
 	dev = &GET_DEV(inst->accel_dev);
 	if (ctx->enc_cd) {
-		memzero_explicit(ctx->enc_cd,
-				 sizeof(struct icp_qat_hw_cipher_algo_blk));
+		memset(ctx->enc_cd, 0,
+		       sizeof(struct icp_qat_hw_cipher_algo_blk));
 		dma_free_coherent(dev,
 				  sizeof(struct icp_qat_hw_cipher_algo_blk),
 				  ctx->enc_cd, ctx->enc_cd_paddr);
 	}
 	if (ctx->dec_cd) {
-		memzero_explicit(ctx->dec_cd,
-				 sizeof(struct icp_qat_hw_cipher_algo_blk));
+		memset(ctx->dec_cd, 0,
+		       sizeof(struct icp_qat_hw_cipher_algo_blk));
 		dma_free_coherent(dev,
 				  sizeof(struct icp_qat_hw_cipher_algo_blk),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
