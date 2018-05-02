From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 10/10] crypto: inside-secure - authenc(hmac(sha1),cbc(aes)) support
Date: Wed,  2 May 2018 11:57:25 +0200
Message-ID: <20180502095725.31935-11-antoine.tenart@bootlin.com>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the authenc(hmac(sha1),cbc(aes)) AEAD algorithm
support to the Inside Secure SafeXcel driver.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c       |  1 +
 drivers/crypto/inside-secure/safexcel.h       |  1 +
 .../crypto/inside-secure/safexcel_cipher.c    | 39 +++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 0f061c3757e9..46ab2d0eb3fd 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -793,6 +793,7 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_hmac_sha1,
 	&safexcel_alg_hmac_sha224,
 	&safexcel_alg_hmac_sha256,
+	&safexcel_alg_authenc_hmac_sha1_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha224_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha256_cbc_aes,
 };
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 4637f7b00c1d..0177d82f972f 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -657,6 +657,7 @@ extern struct safexcel_alg_template safexcel_alg_sha256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha1;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha256;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes;
 
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 207026fe997c..87438cfce64e 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -185,6 +185,11 @@ static int safexcel_aead_aes_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	/* Auth key */
 	switch (ctx->alg) {
+	case CONTEXT_CONTROL_CRYPTO_ALG_SHA1:
+		if (safexcel_hmac_setkey("safexcel-sha1", keys.authkey,
+					 keys.authkeylen, &istate, &ostate))
+			goto badkey;
+		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA224:
 		if (safexcel_hmac_setkey("safexcel-sha224", keys.authkey,
 					 keys.authkeylen, &istate, &ostate))
@@ -916,6 +921,40 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int safexcel_aead_sha1_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_cra_init(tfm);
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA1;
+	ctx->state_sz = SHA1_DIGEST_SIZE;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_aes_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = AES_BLOCK_SIZE,
+		.maxauthsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha1),cbc(aes))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-aes",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha1_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha256_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
2.17.0
