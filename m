From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 05/13] crypto: marvell/CESA: add DES support
Date: Thu, 11 Jun 2015 19:36:28 +0200
Message-ID: <1434044206-10459-10-git-send-email-boris.brezillon@free-electrons.com>
References: <1434044206-10459-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Ian Campbell <ijc+devicetree@hellion.org.uk>,
 Jason Cooper <jason@lakedaemon.net>, Tawfik Bayouk <tawfik@marvell.com>,
 Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
 linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
 Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
 devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 Mark Rutland <mark.rutland@arm.com>, Imre Kaloz <kaloz@openwrt.org>,
 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1434044206-10459-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Add support for DES operations.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
---
 drivers/crypto/marvell/cesa.c   |   2 +
 drivers/crypto/marvell/cesa.h   |   2 +
 drivers/crypto/marvell/cipher.c | 150 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 5a226c4..47c9ef8 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -165,6 +165,8 @@ static void mv_cesa_remove_algs(struct mv_cesa_dev *cesa)
 }
 
 static struct crypto_alg *armada_370_cipher_algs[] = {
+	&mv_cesa_ecb_des_alg,
+	&mv_cesa_cbc_des_alg,
 	&mv_cesa_ecb_aes_alg,
 	&mv_cesa_cbc_aes_alg,
 };
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index fcacc70..5d91da3 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -790,6 +790,8 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 extern struct ahash_alg mv_sha1_alg;
 extern struct ahash_alg mv_ahmac_sha1_alg;
 
+extern struct crypto_alg mv_cesa_ecb_des_alg;
+extern struct crypto_alg mv_cesa_cbc_des_alg;
 extern struct crypto_alg mv_cesa_ecb_aes_alg;
 extern struct crypto_alg mv_cesa_cbc_aes_alg;
 
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 8188fc2..2094a9e 100644
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
@@ -223,6 +229,30 @@ static int mv_cesa_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
@@ -341,6 +371,126 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
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
+	memcpy(tmpl->ctx.blkcipher.iv, req->info, 8);
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
