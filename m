From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] crypto: talitos - fix setkey to check key weakness
Date: Mon, 25 Sep 2017 14:57:21 +0200 (CEST)
Message-ID: <20170925125721.388826896D@po15668-vm-win7.idsi0.si.c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Crypto manager test report the following failures:
[    3.061081] alg: skcipher: setkey failed on test 5 for ecb-des-talitos: flags=100
[    3.069342] alg: skcipher-ddst: setkey failed on test 5 for ecb-des-talitos: flags=100
[    3.077754] alg: skcipher-ddst: setkey failed on test 5 for ecb-des-talitos: flags=100

This is due to setkey being expected to detect weak keys.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e7e31f8fd3d1..09a2cd3a31d2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1494,12 +1494,20 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 tmp[DES_EXPKEY_WORDS];
 
 	if (keylen > TALITOS_MAX_KEY_SIZE) {
 		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
+	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
+		     CRYPTO_TFM_REQ_WEAK_KEY) &&
+	    !des_ekey(tmp, key)) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
+		return -EINVAL;
+	}
+
 	memcpy(&ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
-- 
2.13.3
