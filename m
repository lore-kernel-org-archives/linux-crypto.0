From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/4] crypto: ccree: drop useless type flag during reg
Date: Tue, 24 Jul 2018 15:12:43 +0100
Message-ID: <1532441567-11694-2-git-send-email-gilad@benyossef.com>
References: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Drop the explicit setting of CRYPTO_ALG_TYPE_AEAD or
CRYPTO_ALG_TYPE_SKCIPHER flags during alg registration as they are
set anyway by the framework.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c   | 16 +---------------
 drivers/crypto/ccree/cc_cipher.c | 14 --------------
 drivers/crypto/ccree/cc_driver.h |  1 -
 3 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 03f4b9f..01b82b8 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2344,7 +2344,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(hmac(sha1),cbc(aes))",
 		.driver_name = "authenc-hmac-sha1-cbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2364,7 +2363,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha1-cbc-des3-ccree",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2384,7 +2382,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(hmac(sha256),cbc(aes))",
 		.driver_name = "authenc-hmac-sha256-cbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2404,7 +2401,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(hmac(sha256),cbc(des3_ede))",
 		.driver_name = "authenc-hmac-sha256-cbc-des3-ccree",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2424,7 +2420,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(xcbc(aes),cbc(aes))",
 		.driver_name = "authenc-xcbc-aes-cbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2444,7 +2439,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
 		.driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2464,7 +2458,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
 		.driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2484,7 +2477,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
 		.driver_name = "authenc-xcbc-aes-rfc3686-ctr-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
@@ -2504,7 +2496,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "ccm(aes)",
 		.driver_name = "ccm-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_ccm_setauthsize,
@@ -2524,7 +2515,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "rfc4309(ccm(aes))",
 		.driver_name = "rfc4309-ccm-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_rfc4309_ccm_setkey,
 			.setauthsize = cc_rfc4309_ccm_setauthsize,
@@ -2544,7 +2534,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "gcm(aes)",
 		.driver_name = "gcm-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_aead_setkey,
 			.setauthsize = cc_gcm_setauthsize,
@@ -2564,7 +2553,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "rfc4106(gcm(aes))",
 		.driver_name = "rfc4106-gcm-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_rfc4106_gcm_setkey,
 			.setauthsize = cc_rfc4106_gcm_setauthsize,
@@ -2584,7 +2572,6 @@ static struct cc_alg_template aead_algs[] = {
 		.name = "rfc4543(gcm(aes))",
 		.driver_name = "rfc4543-gcm-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
 			.setkey = cc_rfc4543_gcm_setkey,
 			.setauthsize = cc_rfc4543_gcm_setauthsize,
@@ -2621,8 +2608,7 @@ static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
 	alg->base.cra_priority = CC_CRA_PRIO;
 
 	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			 tmpl->type;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->init = cc_aead_init;
 	alg->exit = cc_aead_exit;
 
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 1100185..eb99633 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -968,7 +968,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ecb(paes)",
 		.driver_name = "ecb-paes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -985,7 +984,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "cbc(paes)",
 		.driver_name = "cbc-paes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1002,7 +1000,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ofb(paes)",
 		.driver_name = "ofb-paes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1019,7 +1016,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "cts(cbc(paes))",
 		.driver_name = "cts-cbc-paes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1036,7 +1032,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ctr(paes)",
 		.driver_name = "ctr-paes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1203,7 +1198,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ecb(aes)",
 		.driver_name = "ecb-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1220,7 +1214,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "cbc(aes)",
 		.driver_name = "cbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1237,7 +1230,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ofb(aes)",
 		.driver_name = "ofb-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1254,7 +1246,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "cts(cbc(aes))",
 		.driver_name = "cts-cbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1271,7 +1262,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ctr(aes)",
 		.driver_name = "ctr-aes-ccree",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1288,7 +1278,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "cbc(des3_ede)",
 		.driver_name = "cbc-3des-ccree",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1305,7 +1294,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ecb(des3_ede)",
 		.driver_name = "ecb-3des-ccree",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1322,7 +1310,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "cbc(des)",
 		.driver_name = "cbc-des-ccree",
 		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1339,7 +1326,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.name = "ecb(des)",
 		.driver_name = "ecb-des-ccree",
 		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 95f82b2..d608a4f 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -148,7 +148,6 @@ struct cc_alg_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int blocksize;
-	u32 type;
 	union {
 		struct skcipher_alg skcipher;
 		struct aead_alg aead;
-- 
2.7.4
