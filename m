From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 06/14] crypto: marvell/CESA: add DES support
Date: Tue, 16 Jun 2015 11:59:00 +0200
Message-ID: <1434448748-10828-7-git-send-email-boris.brezillon@free-electrons.com>
References: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"Imre Kaloz" <kaloz@openwrt.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:56547 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932416AbbFPJ7h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 05:59:37 -0400
In-Reply-To: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for DES operations.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
---
 drivers/crypto/marvell/cesa.c   |   2 +
 drivers/crypto/marvell/cesa.h   |   2 +
 drivers/crypto/marvell/cipher.c | 150 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 986f024..212840e 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -169,6 +169,8 @@ static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
 }
 
 static struct crypto_alg *armada_370_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
 	&mv_cesa_ecb_aes_alg,
 	&mv_cesa_cbc_aes_alg,
 };
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 1a48323..2ee48fe 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -777,6 +777,8 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 extern struct ahash_alg mv_sha1_alg;
 extern struct ahash_alg mv_ahmac_sha1_alg;
 
+extern struct crypto_alg mv_cesa_ecb_des_alg;
+extern struct crypto_alg mv_cesa_cbc_des_alg;
 extern struct crypto_alg mv_cesa_ecb_aes_alg;
 extern struct crypto_alg mv_cesa_cbc_aes_alg;
 
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 233f5bf..31b9311 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -13,9 +13,15 @@
  */
 
 #include <crypto/aes.h>
+#include <crypto/des.h>
 
 #include "cesa.h"
 
+struct mv_cesa_des_ctx {
+	struct mv_cesa_ctx base;
+	u8 key[DES_KEY_SIZE];
+};
+
 struct mv_cesa_aes_ctx {
 	struct mv_cesa_ctx base;
 	struct crypto_aes_ctx aes;
@@ -231,6 +237,30 @@ static int mv_cesa_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	return 0;
 }
 
+static int mv_cesa_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			      unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 tmp[DES_EXPKEY_WORDS];
+	int ret;
+
+	if (len != DES_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	ret = des_ekey(tmp, key);
+	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, DES_KEY_SIZE);
+
+	return 0;
+}
+
 static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 				const struct mv_cesa_op_ctx *op_templ)
 {
@@ -351,6 +381,126 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
 	return ret;
 }
 
+static int mv_cesa_des_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES_KEY_SIZE);
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
+static int mv_cesa_ecb_des_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_des_op(req, &tmpl);
+}
+
+static int mv_cesa_ecb_des_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl,
+			   CESA_SA_DESC_CFG_CRYPTCM_ECB |
+			   CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_des_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_ecb_des_alg = {
+	.cra_name = "ecb(des)",
+	.cra_driver_name = "mv-ecb-des",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.setkey = mv_cesa_des_setkey,
+			.encrypt = mv_cesa_ecb_des_encrypt,
+			.decrypt = mv_cesa_ecb_des_decrypt,
+		},
+	},
+};
+
+static int mv_cesa_cbc_des_op(struct ablkcipher_request *req,
+			      struct mv_cesa_op_ctx *tmpl)
+{
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
+			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.iv, req->info, DES_BLOCK_SIZE);
+
+	return mv_cesa_des_op(req, tmpl);
+}
+
+static int mv_cesa_cbc_des_encrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_ENC);
+
+	return mv_cesa_cbc_des_op(req, &tmpl);
+}
+
+static int mv_cesa_cbc_des_decrypt(struct ablkcipher_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_DIR_DEC);
+
+	return mv_cesa_cbc_des_op(req, &tmpl);
+}
+
+struct crypto_alg mv_cesa_cbc_des_alg = {
+	.cra_name = "cbc(des)",
+	.cra_driver_name = "mv-cbc-des",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+		     CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = mv_cesa_ablkcipher_cra_init,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize	     = DES_BLOCK_SIZE,
+			.setkey = mv_cesa_des_setkey,
+			.encrypt = mv_cesa_cbc_des_encrypt,
+			.decrypt = mv_cesa_cbc_des_decrypt,
+		},
+	},
+};
+
 static int mv_cesa_aes_op(struct ablkcipher_request *req,
 			  struct mv_cesa_op_ctx *tmpl)
 {
-- 
1.9.1
