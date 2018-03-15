From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 12/12] crypto: inside-secure - hmac(sha224) support
Date: Thu, 15 Mar 2018 16:38:51 +0100
Message-ID: <20180315153851.9958-13-antoine.tenart@bootlin.com>
References: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  1 +
 drivers/crypto/inside-secure/safexcel.h      |  1 +
 drivers/crypto/inside-secure/safexcel_hash.c | 56 ++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5c19bdb28fe1..065c8ba2bd31 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -768,6 +768,7 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_sha224,
 	&safexcel_alg_sha256,
 	&safexcel_alg_hmac_sha1,
+	&safexcel_alg_hmac_sha224,
 	&safexcel_alg_hmac_sha256,
 };
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 4ada6be304f4..08b826d1d880 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -632,6 +632,7 @@ extern struct safexcel_alg_template safexcel_alg_sha1;
 extern struct safexcel_alg_template safexcel_alg_sha224;
 extern struct safexcel_alg_template safexcel_alg_sha256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha1;
+extern struct safexcel_alg_template safexcel_alg_hmac_sha224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha256;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 61c0c82add34..acca8e270bd0 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1151,6 +1151,62 @@ struct safexcel_alg_template safexcel_alg_sha224 = {
 	},
 };
 
+static int safexcel_hmac_sha224_setkey(struct crypto_ahash *tfm, const u8 *key,
+				       unsigned int keylen)
+{
+	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-sha224",
+					SHA256_DIGEST_SIZE);
+}
+
+static int safexcel_hmac_sha224_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+
+	safexcel_sha224_init(areq);
+	ctx->digest = CONTEXT_CONTROL_DIGEST_HMAC;
+	return 0;
+}
+
+static int safexcel_hmac_sha224_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_hmac_sha224_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.alg.ahash = {
+		.init = safexcel_hmac_sha224_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_hmac_sha224_digest,
+		.setkey = safexcel_hmac_sha224_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "hmac(sha224)",
+				.cra_driver_name = "safexcel-hmac-sha224",
+				.cra_priority = 300,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = SHA224_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_ahash_cra_init,
+				.cra_exit = safexcel_ahash_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
+
 static int safexcel_hmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
 				     unsigned int keylen)
 {
-- 
2.14.3
