From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 05/16] crypto: marvell/CESA: add Triple-DES support
Date: Fri, 22 May 2015 15:33:51 +0200
Message-ID: <1432301642-11470-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>

Add support for Triple-DES operations.

Signed-off-by: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/crypto/marvell/cesa.c   |   2 +
 drivers/crypto/marvell/cesa.h   |   2 +
 drivers/crypto/marvell/cipher.c | 147 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 3e9aca5..b1f7d38 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -167,6 +167,8 @@ static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
 static struct crypto_alg *armada_370_cipher_algs[] = {
 	&mv_cesa_ecb_des_alg,
 	&mv_cesa_cbc_des_alg,
+	&mv_cesa_ecb_des3_ede_alg,
+	&mv_cesa_cbc_des3_ede_alg,
 	&mv_cesa_ecb_aes_alg,
 	&mv_cesa_cbc_aes_alg,
 };
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 5d91da3..d886280 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -792,6 +792,8 @@ extern struct ahash_alg mv_ahmac_sha1_alg;
 
 extern struct crypto_alg mv_cesa_ecb_des_alg;
 extern struct crypto_alg mv_cesa_cbc_des_alg;
+extern struct crypto_alg mv_cesa_ecb_des3_ede_alg;
+extern struct crypto_alg mv_cesa_cbc_des3_ede_alg;
 extern struct crypto_alg mv_cesa_ecb_aes_alg;
 extern struct crypto_alg mv_cesa_cbc_aes_alg;
 
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 0169fd7..8378c87 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -22,6 +22,11 @@ struct mv_cesa_des_ctx {
 	u8 key[DES_KEY_SIZE];
 };
 
+struct mv_cesa_des3_ctx {
+	struct mv_cesa_ctx base;
+	u8 key[DES3_EDE_KEY_SIZE];
+};
+
 struct mv_cesa_aes_ctx {
 	struct mv_cesa_ctx base;
 	struct crypto_aes_ctx aes;
@@ -253,6 +258,22 @@ static int mv_cesa_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	return 0;
 }
 
+static int mv_cesa_des3_ede_setkey(struct crypto_ablkcipher *cipher,
+				   const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (len != DES3_EDE_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
+
+	return 0;
+}
+
 static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 				const struct mv_cesa_op_ctx *op_templ)
 {
@@ -486,6 +507,132 @@ struct crypto_alg mv_cesa_cbc_des_alg = {
 	},
 };
 
+static int mv_cesa_des3_op(struct ablkcipher_request *req,
+			   struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des3_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
+
+	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
+	if (ret)
+		return ret;
+
+	ret = mv_cesa_queue_req(&req->base);
+	if (ret && ret != -EINPROGRESS)
+		mv_cesa_ablkcipher_cleanup(req);
+
+	return ret;
+}
+
+static int mv_cesa_ecb_des3_ede_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_des3_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_des3_ede_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_des3_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_ecb_des3_ede_alg = {
+	.cra_name = "ecb(des3_ede)",
+	.cra_driver_name = "mv-ecb-des3-ede",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize	     = DES3_EDE_BLOCK_SIZE,
+			.setkey = mv_cesa_des3_ede_setkey,
+			.encrypt = mv_cesa_ecb_des3_ede_encrypt,
+			.decrypt = mv_cesa_ecb_des3_ede_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_cbc_des3_op(struct ablkcipher_request *req,
+			       struct mv_cesa_op_ctx *tmpl)
+{
+	memcpy(tmpl->ctx.blkcipher.iv, req->info, DES3_EDE_BLOCK_SIZE);
+
+	return mv_cesa_des3_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_des3_ede_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_des3_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_des3_ede_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_CBC |
+			   CESA_SA_DESC_CFG_3DES_EDE |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_des3_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_cbc_des3_ede_alg = {
+	.cra_name = "cbc(des3_ede)",
+	.cra_driver_name = "mv-cbc-des3-ede",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize	     = DES3_EDE_BLOCK_SIZE,
+			.setkey = mv_cesa_des3_ede_setkey,
+			.encrypt = mv_cesa_cbc_des3_ede_encrypt,
+			.decrypt = mv_cesa_cbc_des3_ede_decrypt,
+		},
+	},
+};
+
 static int mv_cesa_aes_op(struct ablkcipher_request *req,
 			  struct mv_cesa_op_ctx *tmpl)
 {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
