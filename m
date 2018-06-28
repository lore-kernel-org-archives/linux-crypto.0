From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 2/5] crypto: inside-secure - hmac(md5) support
Date: Thu, 28 Jun 2018 17:21:54 +0200
Message-ID: <20180628152157.23769-3-antoine.tenart@bootlin.com>
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

This patch adds support for the hmac(md5) algorithm in the Inside Secure
SafeXcel cryptographic engine driver.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  3 +-
 drivers/crypto/inside-secure/safexcel.h      |  1 +
 drivers/crypto/inside-secure/safexcel_hash.c | 57 ++++++++++++++++++++
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 54f5d2c131a9..ea8070c33743 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -406,7 +406,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
 		val |= EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT;
 		val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
-		val |= EIP197_ALG_MD5;
+		val |= EIP197_ALG_MD5 | EIP197_ALG_HMAC_MD5;
 		val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
 		val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
 		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
@@ -848,6 +848,7 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_sha256,
 	&safexcel_alg_sha384,
 	&safexcel_alg_sha512,
+	&safexcel_alg_hmac_md5,
 	&safexcel_alg_hmac_sha1,
 	&safexcel_alg_hmac_sha224,
 	&safexcel_alg_hmac_sha256,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index fcd26ae70166..19610b03bceb 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -698,6 +698,7 @@ extern struct safexcel_alg_template safexcel_alg_sha224;
 extern struct safexcel_alg_template safexcel_alg_sha256;
 extern struct safexcel_alg_template safexcel_alg_sha384;
 extern struct safexcel_alg_template safexcel_alg_sha512;
+extern struct safexcel_alg_template safexcel_alg_hmac_md5;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha1;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha256;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 4fec8fe07044..46aac55c0b31 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1619,3 +1619,60 @@ struct safexcel_alg_template safexcel_alg_md5 = {
 		},
 	},
 };
+
+static int safexcel_hmac_md5_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	safexcel_md5_init(areq);
+	req->digest = CONTEXT_CONTROL_DIGEST_HMAC;
+	return 0;
+}
+
+static int safexcel_hmac_md5_setkey(struct crypto_ahash *tfm, const u8 *key,
+				     unsigned int keylen)
+{
+	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-md5",
+					MD5_DIGEST_SIZE);
+}
+
+static int safexcel_hmac_md5_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_hmac_md5_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_hmac_md5 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.engines = EIP97IES | EIP197B | EIP197D,
+	.alg.ahash = {
+		.init = safexcel_hmac_md5_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_hmac_md5_digest,
+		.setkey = safexcel_hmac_md5_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "hmac(md5)",
+				.cra_driver_name = "safexcel-hmac-md5",
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
