From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH 1/3] crypto: talitos - scaffolding for new algorithm types
Date: Sun, 15 Mar 2009 20:21:48 -0500
Message-ID: <1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
Cc: kim.phillips@freescale.com, Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:4988 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbZCPBV7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Mar 2009 21:21:59 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2399696qwi.37
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2009 18:21:57 -0700 (PDT)
In-Reply-To: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch is preparation for adding new algorithm types.

Some elements which are AEAD specific were renamed.
The algorithm template structure was changed to
use crypto_alg, and talitos_alg_alloc was made
more general with respect to algorithm types.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |  245 ++++++++++++++++++++++++----------------------
 1 files changed, 129 insertions(+), 116 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d853530..d53e2eb 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -688,8 +688,8 @@ struct talitos_ctx {
 	unsigned int authsize;
 };
 
-static int aead_authenc_setauthsize(struct crypto_aead *authenc,
-						 unsigned int authsize)
+static int aead_setauthsize(struct crypto_aead *authenc,
+			    unsigned int authsize)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 
@@ -698,8 +698,8 @@ static int aead_authenc_setauthsize(struct crypto_aead *authenc,
 	return 0;
 }
 
-static int aead_authenc_setkey(struct crypto_aead *authenc,
-					    const u8 *key, unsigned int keylen)
+static int aead_setkey(struct crypto_aead *authenc,
+		       const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct rtattr *rta = (void *)key;
@@ -744,7 +744,7 @@ badkey:
 }
 
 /*
- * ipsec_esp_edesc - s/w-extended ipsec_esp descriptor
+ * talitos_edesc - s/w-extended descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
  * @dma_len: length of dma mapped link_tbl space
@@ -756,7 +756,7 @@ badkey:
  * is greater than 1, an integrity check value is concatenated to the end
  * of link_tbl data
  */
-struct ipsec_esp_edesc {
+struct talitos_edesc {
 	int src_nents;
 	int dst_nents;
 	int dma_len;
@@ -766,7 +766,7 @@ struct ipsec_esp_edesc {
 };
 
 static void ipsec_esp_unmap(struct device *dev,
-			    struct ipsec_esp_edesc *edesc,
+			    struct talitos_edesc *edesc,
 			    struct aead_request *areq)
 {
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6], DMA_FROM_DEVICE);
@@ -799,8 +799,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
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
@@ -827,8 +827,8 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
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
@@ -859,8 +859,8 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
 				   int err)
 {
 	struct aead_request *req = context;
-	struct ipsec_esp_edesc *edesc =
-		 container_of(desc, struct ipsec_esp_edesc, desc);
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
 
 	ipsec_esp_unmap(dev, edesc, req);
 
@@ -914,7 +914,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 /*
  * fill in and submit ipsec_esp descriptor
  */
-static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
+static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		     u8 *giv, u64 seq,
 		     void (*callback) (struct device *dev,
 				       struct talitos_desc *desc,
@@ -1056,14 +1056,14 @@ static int sg_count(struct scatterlist *sg_list, int nbytes)
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
@@ -1088,7 +1088,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	 * allowing for two separate entries for ICV and generated ICV (+ 2),
 	 * and the ICV data itself
 	 */
-	alloc_len = sizeof(struct ipsec_esp_edesc);
+	alloc_len = sizeof(struct talitos_edesc);
 	if (src_nents || dst_nents) {
 		dma_len = (src_nents + dst_nents + 2) *
 				 sizeof(struct talitos_ptr) + ctx->authsize;
@@ -1113,11 +1113,11 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
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
@@ -1132,13 +1132,13 @@ static int aead_authenc_encrypt(struct aead_request *req)
 
 
 
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
 
@@ -1184,13 +1184,12 @@ static int aead_authenc_decrypt(struct aead_request *req)
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
@@ -1209,30 +1208,30 @@ static int aead_authenc_givencrypt(
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
@@ -1242,19 +1241,23 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -1265,19 +1268,23 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -1287,19 +1294,23 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -1310,19 +1321,23 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -1332,19 +1347,23 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -1457,19 +1476,13 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
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
1.5.6.3

