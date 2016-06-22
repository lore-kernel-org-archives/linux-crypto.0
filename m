From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: KEYS: Use skcipher for big keys
Date: Wed, 22 Jun 2016 22:13:53 +0800
Message-ID: <20160622141353.GA456@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Kirill Marinushkin <k.marinushkin@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46853 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcFVOPZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:15:25 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I'm in the process of removing blkcipher/ablkcipher which have
been replaced with skcipher.  It would be nice if we stop adding
new users of these two interfaces :)

Anyway, if you guys are OK with this patch I'd like to push it
through cryptodev so I can carry on with the removal of blkcipher.

Thanks,

---8<--
This patch replaces use of the obsolete blkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 9e443fc..c0b3030 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -18,6 +18,7 @@
 #include <keys/user-type.h>
 #include <keys/big_key-type.h>
 #include <crypto/rng.h>
+#include <crypto/skcipher.h>
 
 /*
  * Layout of key payload words.
@@ -74,7 +75,7 @@ static const char big_key_alg_name[] = "ecb(aes)";
  * Crypto algorithms for big_key data encryption
  */
 static struct crypto_rng *big_key_rng;
-static struct crypto_blkcipher *big_key_blkcipher;
+static struct crypto_skcipher *big_key_skcipher;
 
 /*
  * Generate random key to encrypt big_key data
@@ -91,22 +92,26 @@ static int big_key_crypt(enum big_key_op op, u8 *data, size_t datalen, u8 *key)
 {
 	int ret = -EINVAL;
 	struct scatterlist sgio;
-	struct blkcipher_desc desc;
+	SKCIPHER_REQUEST_ON_STACK(req, big_key_skcipher);
 
-	if (crypto_blkcipher_setkey(big_key_blkcipher, key, ENC_KEY_SIZE)) {
+	if (crypto_skcipher_setkey(big_key_skcipher, key, ENC_KEY_SIZE)) {
 		ret = -EAGAIN;
 		goto error;
 	}
 
-	desc.flags = 0;
-	desc.tfm = big_key_blkcipher;
+	skcipher_request_set_tfm(req, big_key_skcipher);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
+				      NULL, NULL);
 
 	sg_init_one(&sgio, data, datalen);
+	skcipher_request_set_crypt(req, &sgio, &sgio, datalen, NULL);
 
 	if (op == BIG_KEY_ENC)
-		ret = crypto_blkcipher_encrypt(&desc, &sgio, &sgio, datalen);
+		ret = crypto_skcipher_encrypt(req);
 	else
-		ret = crypto_blkcipher_decrypt(&desc, &sgio, &sgio, datalen);
+		ret = crypto_skcipher_decrypt(req);
+
+	skcipher_request_zero(req);
 
 error:
 	return ret;
@@ -140,7 +145,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
 		 *
 		 * File content is stored encrypted with randomly generated key.
 		 */
-		size_t enclen = ALIGN(datalen, crypto_blkcipher_blocksize(big_key_blkcipher));
+		size_t enclen = ALIGN(datalen, crypto_skcipher_blocksize(big_key_skcipher));
 
 		/* prepare aligned data to encrypt */
 		data = kmalloc(enclen, GFP_KERNEL);
@@ -288,7 +293,7 @@ long big_key_read(const struct key *key, char __user *buffer, size_t buflen)
 		struct file *file;
 		u8 *data;
 		u8 *enckey = (u8 *)key->payload.data[big_key_data];
-		size_t enclen = ALIGN(datalen, crypto_blkcipher_blocksize(big_key_blkcipher));
+		size_t enclen = ALIGN(datalen, crypto_skcipher_blocksize(big_key_skcipher));
 
 		data = kmalloc(enclen, GFP_KERNEL);
 		if (!data)
@@ -359,9 +364,10 @@ static int __init big_key_crypto_init(void)
 		goto error;
 
 	/* init block cipher */
-	big_key_blkcipher = crypto_alloc_blkcipher(big_key_alg_name, 0, 0);
-	if (IS_ERR(big_key_blkcipher)) {
-		big_key_blkcipher = NULL;
+	big_key_skcipher = crypto_alloc_skcipher(big_key_alg_name,
+						 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(big_key_skcipher)) {
+		big_key_skcipher = NULL;
 		ret = -EFAULT;
 		goto error;
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
