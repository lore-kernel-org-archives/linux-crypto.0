From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 11/12] crypto: inside-secure - hmac(sha256) support
Date: Thu, 15 Mar 2018 16:38:50 +0100
Message-ID: <20180315153851.9958-12-antoine.tenart@bootlin.com>
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
 drivers/crypto/inside-secure/safexcel.c      |  3 +-
 drivers/crypto/inside-secure/safexcel.h      |  1 +
 drivers/crypto/inside-secure/safexcel_hash.c | 80 +++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 7b291068222f..5c19bdb28fe1 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -354,7 +354,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
 	val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
 	val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
-	val |= EIP197_ALG_SHA2;
+	val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
 	writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN);
 
 	/* Command Descriptor Rings prepare */
@@ -768,6 +768,7 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_sha224,
 	&safexcel_alg_sha256,
 	&safexcel_alg_hmac_sha1,
+	&safexcel_alg_hmac_sha256,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 8c139b98a580..4ada6be304f4 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -632,5 +632,6 @@ extern struct safexcel_alg_template safexcel_alg_sha1;
 extern struct safexcel_alg_template safexcel_alg_sha224;
 extern struct safexcel_alg_template safexcel_alg_sha256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha1;
+extern struct safexcel_alg_template safexcel_alg_hmac_sha256;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 845a5ebf25b4..61c0c82add34 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -22,8 +22,8 @@ struct safexcel_ahash_ctx {
 
 	u32 alg;
 
-	u32 ipad[SHA1_DIGEST_SIZE / sizeof(u32)];
-	u32 opad[SHA1_DIGEST_SIZE / sizeof(u32)];
+	u32 ipad[SHA256_DIGEST_SIZE / sizeof(u32)];
+	u32 opad[SHA256_DIGEST_SIZE / sizeof(u32)];
 };
 
 struct safexcel_ahash_req {
@@ -961,20 +961,21 @@ static int safexcel_hmac_setkey(const char *alg, const u8 *key,
 	return ret;
 }
 
-static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
-				     unsigned int keylen)
+static int safexcel_hmac_alg_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen, const char *alg,
+				    unsigned int state_sz)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct safexcel_ahash_export_state istate, ostate;
 	int ret, i;
 
-	ret = safexcel_hmac_setkey("safexcel-sha1", key, keylen, &istate, &ostate);
+	ret = safexcel_hmac_setkey(alg, key, keylen, &istate, &ostate);
 	if (ret)
 		return ret;
 
 	if (priv->version == EIP197 && ctx->base.ctxr) {
-		for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++) {
+		for (i = 0; i < state_sz / sizeof(u32); i++) {
 			if (ctx->ipad[i] != le32_to_cpu(istate.state[i]) ||
 			    ctx->opad[i] != le32_to_cpu(ostate.state[i])) {
 				ctx->base.needs_inv = true;
@@ -983,12 +984,19 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 		}
 	}
 
-	memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
-	memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
+	memcpy(ctx->ipad, &istate.state, state_sz);
+	memcpy(ctx->opad, &ostate.state, state_sz);
 
 	return 0;
 }
 
+static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
+				     unsigned int keylen)
+{
+	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-sha1",
+					SHA1_DIGEST_SIZE);
+}
+
 struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
 	.alg.ahash = {
@@ -1142,3 +1150,59 @@ struct safexcel_alg_template safexcel_alg_sha224 = {
 		},
 	},
 };
+
+static int safexcel_hmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
+				     unsigned int keylen)
+{
+	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-sha256",
+					SHA256_DIGEST_SIZE);
+}
+
+static int safexcel_hmac_sha256_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+
+	safexcel_sha256_init(areq);
+	ctx->digest = CONTEXT_CONTROL_DIGEST_HMAC;
+	return 0;
+}
+
+static int safexcel_hmac_sha256_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_hmac_sha256_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.alg.ahash = {
+		.init = safexcel_hmac_sha256_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_hmac_sha256_digest,
+		.setkey = safexcel_hmac_sha256_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "hmac(sha256)",
+				.cra_driver_name = "safexcel-hmac-sha256",
+				.cra_priority = 300,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_ahash_cra_init,
+				.cra_exit = safexcel_ahash_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
2.14.3
