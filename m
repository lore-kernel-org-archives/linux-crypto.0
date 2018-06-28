From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 1/5] crypto: inside-secure - md5 support
Date: Thu, 28 Jun 2018 17:21:53 +0200
Message-ID: <20180628152157.23769-2-antoine.tenart@bootlin.com>
References: <20180628152157.23769-1-antoine.tenart@bootlin.com>
Cc: Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, igall@marvell.com,
        Antoine Tenart <antoine.tenart@bootlin.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628152157.23769-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Ofer Heifetz <oferh@marvell.com>

This patch adds the MD5 algorithm support to the Inside Secure SafeXcel
cryptographic engine driver.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/Kconfig                       |  1 +
 drivers/crypto/inside-secure/safexcel.c      |  2 +
 drivers/crypto/inside-secure/safexcel.h      |  2 +
 drivers/crypto/inside-secure/safexcel_hash.c | 69 +++++++++++++++++++-
 4 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 43cccf6aff61..265f987a969b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -691,6 +691,7 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_HMAC
+	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 75befdc24062..54f5d2c131a9 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -406,6 +406,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
 		val |= EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT;
 		val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
+		val |= EIP197_ALG_MD5;
 		val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
 		val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
 		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
@@ -841,6 +842,7 @@ static int safexcel_request_ring_irq(struct platform_device *pdev, const char *n
 static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_ecb_aes,
 	&safexcel_alg_cbc_aes,
+	&safexcel_alg_md5,
 	&safexcel_alg_sha1,
 	&safexcel_alg_sha224,
 	&safexcel_alg_sha256,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 95095cb95ba4..fcd26ae70166 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -316,6 +316,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES256	(0x7 << 17)
 #define CONTEXT_CONTROL_DIGEST_PRECOMPUTED	(0x1 << 21)
 #define CONTEXT_CONTROL_DIGEST_HMAC		(0x3 << 21)
+#define CONTEXT_CONTROL_CRYPTO_ALG_MD5		(0x0 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA1		(0x2 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA224	(0x4 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA256	(0x3 << 23)
@@ -691,6 +692,7 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 /* available algorithms */
 extern struct safexcel_alg_template safexcel_alg_ecb_aes;
 extern struct safexcel_alg_template safexcel_alg_cbc_aes;
+extern struct safexcel_alg_template safexcel_alg_md5;
 extern struct safexcel_alg_template safexcel_alg_sha1;
 extern struct safexcel_alg_template safexcel_alg_sha224;
 extern struct safexcel_alg_template safexcel_alg_sha256;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index c266398647bc..4fec8fe07044 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/hmac.h>
+#include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
@@ -91,7 +92,9 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 
 	if (req->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED) {
 		if (req->processed[0] || req->processed[1]) {
-			if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA1)
+			if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_MD5)
+				cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(5);
+			else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA1)
 				cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(6);
 			else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA224 ||
 				 ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA256)
@@ -652,7 +655,10 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 
 	/* If we have an overall 0 length request */
 	if (!req->len[0] && !req->len[1] && !areq->nbytes) {
-		if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA1)
+		if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_MD5)
+			memcpy(areq->result, md5_zero_message_hash,
+			       MD5_DIGEST_SIZE);
+		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA1)
 			memcpy(areq->result, sha1_zero_message_hash,
 			       SHA1_DIGEST_SIZE);
 		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA224)
@@ -1554,3 +1560,62 @@ struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
 		},
 	},
 };
+
+static int safexcel_md5_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	req->state[0] = MD5_H0;
+	req->state[1] = MD5_H1;
+	req->state[2] = MD5_H2;
+	req->state[3] = MD5_H3;
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_MD5;
+	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
+	req->state_sz = MD5_DIGEST_SIZE;
+
+	return 0;
+}
+
+static int safexcel_md5_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_md5_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_md5 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.engines = EIP97IES | EIP197B | EIP197D,
+	.alg.ahash = {
+		.init = safexcel_md5_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_md5_digest,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "md5",
+				.cra_driver_name = "safexcel-md5",
+				.cra_priority = 300,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_ahash_cra_init,
+				.cra_exit = safexcel_ahash_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
2.17.1
