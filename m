From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/5 RESEND] crypto: talitos - scaffolding for new algorithm
 types
Date: Fri, 27 Mar 2009 22:48:54 -0500
Message-ID: <20090327224854.cdf51c5e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Lee Nipper <lee.nipper@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:44104 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZC1Dhe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 23:37:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lee Nipper <lee.nipper@gmail.com>

This patch is preparation for adding new algorithm types.

Some elements which are AEAD specific were renamed.
The algorithm template structure was changed to
use crypto_alg, and talitos_alg_alloc was made
more general with respect to algorithm types.
ipsec_esp_edesc is renamed to talitos_edesc
to use it in the upcoming ablkcipher routines.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
resending 1-2/5 on behalf of Lee; please consider for inclusion in 2.6.30.

this patch doesn't contain any change since Lee's original submission.

 drivers/crypto/talitos.c |  245 ++++++++++++++++++++++++----------------------
 1 files changed, 129 insertions(+), 116 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a3918c1..9833961 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -684,8 +684,8 @@ struct talitos_ctx {
 	unsigned int authsize;
 };
 
-static int aead_authenc_setauthsize(struct crypto_aead *authenc,
-						 unsigned int authsize)
+static int aead_setauthsize(struct crypto_aead *authenc,
+			    unsigned int authsize)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 
@@ -694,8 +694,8 @@ static int aead_authenc_setauthsize(struct crypto_aead *authenc,
 	return 0;
 }
 
-static int aead_authenc_setkey(struct crypto_aead *authenc,
-					    const u8 *key, unsigned int keylen)
+static int aead_setkey(struct crypto_aead *authenc,
+		       const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct rtattr *rta = (void *)key;
@@ -740,7 +740,7 @@ badkey:
 }
 
 /*
- * ipsec_esp_edesc - s/w-extended ipsec_esp descriptor
+ * talitos_edesc - s/w-extended descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
  * @dma_len: length of dma mapped link_tbl space
@@ -752,7 +752,7 @@ badkey:
  * is greater than 1, an integrity check value is concatenated to the end
  * of link_tbl data
  */
-struct ipsec_esp_edesc {
+struct talitos_edesc {
 	int src_nents;
 	int dst_nents;
 	int dma_len;
@@ -762,7 +762,7 @@ struct ipsec_esp_edesc {
 };
 
 static void ipsec_esp_unmap(struct device *dev,
-			    struct ipsec_esp_edesc *edesc,
+			    struct talitos_edesc *edesc,
 			    struct aead_request *areq)
 {
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6], DMA_FROM_DEVICE);
@@ -795,8 +795,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 				   int err)
 {
 	struct aead_request *areq = context;
-	struct ipsec_esp_edesc *edesc =
-		 container_of(desc, struct ipsec_esp_edesc, desc);
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct scatterlist *sg;
@@ -823,8 +823,8 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 				   int err)
 {
 	struct aead_request *req = context;
-	struct ipsec_esp_edesc *edesc =
-		 container_of(desc, struct ipsec_esp_edesc, desc);
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct scatterlist *sg;
@@ -855,8 +855,8 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
 				   int err)
 {
 	struct aead_request *req = context;
-	struct ipsec_esp_edesc *edesc =
-		 container_of(desc, struct ipsec_esp_edesc, desc);
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
 
 	ipsec_esp_unmap(dev, edesc, req);
 
@@ -910,7 +910,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 /*
  * fill in and submit ipsec_esp descriptor
  */
-static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
+static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		     u8 *giv, u64 seq,
 		     void (*callback) (struct device *dev,
 				       struct talitos_desc *desc,
@@ -1052,14 +1052,14 @@ static int sg_count(struct scatterlist *sg_list, int nbytes)
 }
 
 /*
- * allocate and map the ipsec_esp extended descriptor
+ * allocate and map the extended descriptor
  */
-static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
+static struct talitos_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 						     int icv_stashing)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct ipsec_esp_edesc *edesc;
+	struct talitos_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len;
 	gfp_t flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
@@ -1084,7 +1084,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	 * allowing for two separate entries for ICV and generated ICV (+ 2),
 	 * and the ICV data itself
 	 */
-	alloc_len = sizeof(struct ipsec_esp_edesc);
+	alloc_len = sizeof(struct talitos_edesc);
 	if (src_nents || dst_nents) {
 		dma_len = (src_nents + dst_nents + 2) *
 				 sizeof(struct talitos_ptr) + ctx->authsize;
@@ -1109,11 +1109,11 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	return edesc;
 }
 
-static int aead_authenc_encrypt(struct aead_request *req)
+static int aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct ipsec_esp_edesc *edesc;
+	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
 	edesc = ipsec_esp_edesc_alloc(req, 0);
@@ -1128,13 +1128,13 @@ static int aead_authenc_encrypt(struct aead_request *req)
 
 
 
-static int aead_authenc_decrypt(struct aead_request *req)
+static int aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int authsize = ctx->authsize;
 	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	struct ipsec_esp_edesc *edesc;
+	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
 	void *icvdata;
 
@@ -1180,13 +1180,12 @@ static int aead_authenc_decrypt(struct aead_request *req)
 	}
 }
 
-static int aead_authenc_givencrypt(
-	struct aead_givcrypt_request *req)
+static int aead_givencrypt(struct aead_givcrypt_request *req)
 {
 	struct aead_request *areq = &req->areq;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct ipsec_esp_edesc *edesc;
+	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
 	edesc = ipsec_esp_edesc_alloc(areq, 0);
@@ -1205,30 +1204,30 @@ static int aead_authenc_givencrypt(
 }
 
 struct talitos_alg_template {
-	char name[CRYPTO_MAX_ALG_NAME];
-	char driver_name[CRYPTO_MAX_ALG_NAME];
-	unsigned int blocksize;
-	struct aead_alg aead;
-	struct device *dev;
+	struct crypto_alg alg;
 	__be32 desc_hdr_template;
 };
 
 static struct talitos_alg_template driver_algs[] = {
-	/* single-pass ipsec_esp descriptor */
+	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
 	{
-		.name = "authenc(hmac(sha1),cbc(aes))",
-		.driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
-		.blocksize = AES_BLOCK_SIZE,
-		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			},
+		.alg = {
+			.cra_name = "authenc(hmac(sha1),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA1_DIGEST_SIZE,
+			}
+		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
 		                     DESC_HDR_MODE0_AESU_CBC |
@@ -1238,19 +1237,23 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{
-		.name = "authenc(hmac(sha1),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			},
+		.alg = {
+			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.maxauthsize = SHA1_DIGEST_SIZE,
+			}
+		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
 		                     DESC_HDR_MODE0_DEU_CBC |
@@ -1261,19 +1264,23 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{
-		.name = "authenc(hmac(sha256),cbc(aes))",
-		.driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
-		.blocksize = AES_BLOCK_SIZE,
-		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			},
+		.alg = {
+			.cra_name = "authenc(hmac(sha256),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA256_DIGEST_SIZE,
+			}
+		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
 		                     DESC_HDR_MODE0_AESU_CBC |
@@ -1283,19 +1290,23 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{
-		.name = "authenc(hmac(sha256),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			},
+		.alg = {
+			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.maxauthsize = SHA256_DIGEST_SIZE,
+			}
+		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
 		                     DESC_HDR_MODE0_DEU_CBC |
@@ -1306,19 +1317,23 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{
-		.name = "authenc(hmac(md5),cbc(aes))",
-		.driver_name = "authenc-hmac-md5-cbc-aes-talitos",
-		.blocksize = AES_BLOCK_SIZE,
-		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			},
+		.alg = {
+			.cra_name = "authenc(hmac(md5),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = MD5_DIGEST_SIZE,
+			}
+		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_AESU |
 		                     DESC_HDR_MODE0_AESU_CBC |
@@ -1328,19 +1343,23 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{
-		.name = "authenc(hmac(md5),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-md5-cbc-3des-talitos",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.aead = {
-			.setkey = aead_authenc_setkey,
-			.setauthsize = aead_authenc_setauthsize,
-			.encrypt = aead_authenc_encrypt,
-			.decrypt = aead_authenc_decrypt,
-			.givencrypt = aead_authenc_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			},
+		.alg = {
+			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_aead_type,
+			.cra_aead = {
+				.setkey = aead_setkey,
+				.setauthsize = aead_setauthsize,
+				.encrypt = aead_encrypt,
+				.decrypt = aead_decrypt,
+				.givencrypt = aead_givencrypt,
+				.geniv = "<built-in>",
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+				.maxauthsize = MD5_DIGEST_SIZE,
+			}
+		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
 			             DESC_HDR_SEL0_DEU |
 		                     DESC_HDR_MODE0_DEU_CBC |
@@ -1453,19 +1472,13 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	alg = &t_alg->crypto_alg;
+	*alg = template->alg;
 
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 template->driver_name);
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = talitos_cra_init;
 	alg->cra_priority = TALITOS_CRA_PRIORITY;
-	alg->cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
-	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_type = &crypto_aead_type;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
-	alg->cra_u.aead = template->aead;
 
 	t_alg->desc_hdr_template = template->desc_hdr_template;
 	t_alg->dev = dev;
-- 
1.6.1.3

