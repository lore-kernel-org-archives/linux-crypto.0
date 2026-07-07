Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6723E38F920;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402646; cv=none; b=WcZFDc+8Mnia/QtHvQzxJp1zQ1YKOnk24VW+uDneqMI5MvXWyZ9pMJCqsuOdZTKYaGNkI1W7DehMZVIUKs03IFEuBiO5XfBgmO+YF7qhu4grOwPOw1T+xpo/OSDru/ocKFdFq+UlfmWUbuVVRISch/MHAlWWnL5MslSeC9VdCMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402646; c=relaxed/simple;
	bh=Dz8yKB26vG2HnPMvp+igSccZwAGUjL1gOgnhflaRqDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0n2QGJ+hUZuQ9WoH77h1/yuuZuugcFV/zwW80WZGIjjmFftFcDaYH1wslUWsVHl04zuMw+7M/M/GFIeqVM31kJM1biXGF9+M+h7F1RQNjkAJAeW2m7DlRq0L+82FGcK0hRhkGBCHzhGDZ+00g+gmPAubN9V7RME3fWmloE4izY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ib1m2yY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ib1m2yY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361F91F00ADB;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402641;
	bh=5EkEAif+4g9CrWQBgUR9FUyTjayBDRMHvyMvzlM9cOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib1m2yY19QrR11R/q52qV8nndgOV6bgRU/t0Bw1yfsmGnruBBDYCRH9vnQYulrs/t
	 MyerAIfBjiSbI1FFuWrUuZhcfjMGMM0Z8K/sGh2SBe52LdYn1V3zOmXLIuCYewX125
	 RCTStMUL8rLue4yIAnNJyJSirsa73ZY7wJWv4cxWoVyv7btHs/FKf4jy05muMMvMDG
	 TaNoQsRX7nKI/plXHtXmotbHr4feyvJJ8LvZymb7RrYcF6aI064a3mOCgI6rMtrie7
	 m5ybHewDOJFhPVaOBpY0bGqQWJjajVZ3NbJPeG/BoA1hqeWEoGBqlJzraQ3ueieWMV
	 zuS0bsbBzwPhw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 19/33] KEYS: encrypted: Use AES-CBC library instead of crypto_skcipher
Date: Mon,  6 Jul 2026 22:34:49 -0700
Message-ID: <20260707053503.209874-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there's a library API for AES-CBC, use it instead of a
"cbc(aes)" crypto_skcipher.  This significantly simplifies the code.

Note that this use of AES-CBC remains questionable (an AEAD should be
used instead), but it remains for backwards compatibility.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 security/keys/Kconfig                    |   4 +-
 security/keys/encrypted-keys/encrypted.c | 194 +++++++----------------
 2 files changed, 62 insertions(+), 136 deletions(-)

diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index f4510d8cb485..d482f632791a 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -83,9 +83,7 @@ endif
 
 config ENCRYPTED_KEYS
 	tristate "ENCRYPTED KEYS"
-	select CRYPTO
-	select CRYPTO_AES
-	select CRYPTO_CBC
+	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_SHA256
 	help
 	  This option provides support for create/encrypting/decrypting keys
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 59cb77b237b3..3dae2c29496b 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -25,11 +25,9 @@
 #include <linux/key-type.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
-#include <linux/scatterlist.h>
 #include <linux/ctype.h>
-#include <crypto/aes.h>
+#include <crypto/aes-cbc.h>
 #include <crypto/sha2.h>
-#include <crypto/skcipher.h>
 #include <crypto/utils.h>
 
 #include "encrypted.h"
@@ -37,17 +35,15 @@
 
 static const char KEY_TRUSTED_PREFIX[] = "trusted:";
 static const char KEY_USER_PREFIX[] = "user:";
-static const char blkcipher_alg[] = "cbc(aes)";
 static const char key_format_default[] = "default";
 static const char key_format_ecryptfs[] = "ecryptfs";
 static const char key_format_enc32[] = "enc32";
-static unsigned int ivsize;
-static int blksize;
 
 #define KEY_TRUSTED_PREFIX_LEN (sizeof (KEY_TRUSTED_PREFIX) - 1)
 #define KEY_USER_PREFIX_LEN (sizeof (KEY_USER_PREFIX) - 1)
 #define KEY_ECRYPTFS_DESC_LEN 16
 #define HASH_SIZE SHA256_DIGEST_SIZE
+#define IV_SIZE AES_BLOCK_SIZE /* AES-CBC initialization vector size in bytes */
 #define MAX_DATA_SIZE 4096
 #define MIN_DATA_SIZE  20
 #define KEY_ENC32_PAYLOAD_LEN 32
@@ -79,22 +75,6 @@ module_param(user_decrypted_data, bool, 0);
 MODULE_PARM_DESC(user_decrypted_data,
 	"Allow instantiation of encrypted keys using provided decrypted data");
 
-static int aes_get_sizes(void)
-{
-	struct crypto_skcipher *tfm;
-
-	tfm = crypto_alloc_skcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm)) {
-		pr_err("encrypted_key: failed to alloc_cipher (%ld)\n",
-		       PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-	ivsize = crypto_skcipher_ivsize(tfm);
-	blksize = crypto_skcipher_blocksize(tfm);
-	crypto_free_skcipher(tfm);
-	return 0;
-}
-
 /*
  * valid_ecryptfs_desc - verify the description of a new/loaded encrypted key
  *
@@ -354,39 +334,6 @@ static int get_derived_key(u8 *derived_key, enum derived_key_type key_type,
 	return 0;
 }
 
-static struct skcipher_request *init_skcipher_req(const u8 *key,
-						  unsigned int key_len)
-{
-	struct skcipher_request *req;
-	struct crypto_skcipher *tfm;
-	int ret;
-
-	tfm = crypto_alloc_skcipher(blkcipher_alg, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm)) {
-		pr_err("encrypted_key: failed to load %s transform (%ld)\n",
-		       blkcipher_alg, PTR_ERR(tfm));
-		return ERR_CAST(tfm);
-	}
-
-	ret = crypto_skcipher_setkey(tfm, key, key_len);
-	if (ret < 0) {
-		pr_err("encrypted_key: failed to setkey (%d)\n", ret);
-		crypto_free_skcipher(tfm);
-		return ERR_PTR(ret);
-	}
-
-	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		pr_err("encrypted_key: failed to allocate request for %s\n",
-		       blkcipher_alg);
-		crypto_free_skcipher(tfm);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	return req;
-}
-
 static struct key *request_master_key(struct encrypted_key_payload *epayload,
 				      const u8 **master_key, size_t *master_keylen)
 {
@@ -427,42 +374,35 @@ static int derived_key_encrypt(struct encrypted_key_payload *epayload,
 			       const u8 *derived_key,
 			       unsigned int derived_keylen)
 {
-	struct scatterlist sg_in[2];
-	struct scatterlist sg_out[1];
-	struct crypto_skcipher *tfm;
-	struct skcipher_request *req;
+	struct aes_enckey key;
 	unsigned int encrypted_datalen;
-	u8 iv[AES_BLOCK_SIZE];
+	u8 iv[IV_SIZE];
 	int ret;
 
-	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
+	ret = aes_prepareenckey(&key, derived_key, derived_keylen);
+	if (ret < 0) /* Should never fail here, since a valid length was used */
+		return ret;
 
-	req = init_skcipher_req(derived_key, derived_keylen);
-	ret = PTR_ERR(req);
-	if (IS_ERR(req))
-		goto out;
 	dump_decrypted_data(epayload);
 
-	sg_init_table(sg_in, 2);
-	sg_set_buf(&sg_in[0], epayload->decrypted_data,
-		   epayload->decrypted_datalen);
-	sg_set_page(&sg_in[1], ZERO_PAGE(0), AES_BLOCK_SIZE, 0);
-
-	sg_init_table(sg_out, 1);
-	sg_set_buf(sg_out, epayload->encrypted_data, encrypted_datalen);
-
+	/*
+	 * Pad the plaintext with zeros up to the next multiple of
+	 * AES_BLOCK_SIZE, to make it have a valid length for AES-CBC.
+	 * To do this without needing a temporary buffer, copy the plaintext
+	 * into ->encrypted_data, pad it, and encrypt it in-place.
+	 */
+	encrypted_datalen =
+		roundup(epayload->decrypted_datalen, AES_BLOCK_SIZE);
+	memset(epayload->encrypted_data, 0, encrypted_datalen);
+	memcpy(epayload->encrypted_data, epayload->decrypted_data,
+	       epayload->decrypted_datalen);
 	memcpy(iv, epayload->iv, sizeof(iv));
-	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen, iv);
-	ret = crypto_skcipher_encrypt(req);
-	tfm = crypto_skcipher_reqtfm(req);
-	skcipher_request_free(req);
-	crypto_free_skcipher(tfm);
-	if (ret < 0)
-		pr_err("encrypted_key: failed to encrypt (%d)\n", ret);
-	else
-		dump_encrypted_data(epayload, encrypted_datalen);
-out:
-	return ret;
+	aes_cbc_encrypt(epayload->encrypted_data, epayload->encrypted_data,
+			encrypted_datalen, iv, &key);
+	dump_encrypted_data(epayload, encrypted_datalen);
+
+	memzero_explicit(&key, sizeof(key));
+	return 0;
 }
 
 static int datablob_hmac_append(struct encrypted_key_payload *epayload,
@@ -528,45 +468,37 @@ static int derived_key_decrypt(struct encrypted_key_payload *epayload,
 			       const u8 *derived_key,
 			       unsigned int derived_keylen)
 {
-	struct scatterlist sg_in[1];
-	struct scatterlist sg_out[2];
-	struct crypto_skcipher *tfm;
-	struct skcipher_request *req;
+	struct aes_key key;
 	unsigned int encrypted_datalen;
-	u8 iv[AES_BLOCK_SIZE];
-	u8 *pad;
+	u8 iv[IV_SIZE];
+	u8 *tmp;
 	int ret;
 
-	/* Throwaway buffer to hold the unused zero padding at the end */
-	pad = kmalloc(AES_BLOCK_SIZE, GFP_KERNEL);
-	if (!pad)
-		return -ENOMEM;
+	ret = aes_preparekey(&key, derived_key, derived_keylen);
+	if (ret < 0) /* Should never fail here, since a valid length was used */
+		return ret;
 
-	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
-	req = init_skcipher_req(derived_key, derived_keylen);
-	ret = PTR_ERR(req);
-	if (IS_ERR(req))
+	/*
+	 * The plaintext was padded before encryption, so decrypt it into a
+	 * temporary buffer that has space for the padding.
+	 */
+	encrypted_datalen =
+		roundup(epayload->decrypted_datalen, AES_BLOCK_SIZE);
+	tmp = kmalloc(encrypted_datalen, GFP_KERNEL);
+	if (!tmp) {
+		ret = -ENOMEM;
 		goto out;
+	}
 	dump_encrypted_data(epayload, encrypted_datalen);
-
-	sg_init_table(sg_in, 1);
-	sg_init_table(sg_out, 2);
-	sg_set_buf(sg_in, epayload->encrypted_data, encrypted_datalen);
-	sg_set_buf(&sg_out[0], epayload->decrypted_data,
-		   epayload->decrypted_datalen);
-	sg_set_buf(&sg_out[1], pad, AES_BLOCK_SIZE);
-
 	memcpy(iv, epayload->iv, sizeof(iv));
-	skcipher_request_set_crypt(req, sg_in, sg_out, encrypted_datalen, iv);
-	ret = crypto_skcipher_decrypt(req);
-	tfm = crypto_skcipher_reqtfm(req);
-	skcipher_request_free(req);
-	crypto_free_skcipher(tfm);
-	if (ret < 0)
-		goto out;
+	aes_cbc_decrypt(tmp, epayload->encrypted_data, encrypted_datalen, iv,
+			&key);
+	memcpy(epayload->decrypted_data, tmp, epayload->decrypted_datalen);
 	dump_decrypted_data(epayload);
+	ret = 0;
 out:
-	kfree(pad);
+	kfree_sensitive(tmp);
+	memzero_explicit(&key, sizeof(key));
 	return ret;
 }
 
@@ -630,10 +562,10 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 		}
 	}
 
-	encrypted_datalen = roundup(decrypted_datalen, blksize);
+	encrypted_datalen = roundup(decrypted_datalen, AES_BLOCK_SIZE);
 
-	datablob_len = format_len + 1 + strlen(master_desc) + 1
-	    + strlen(datalen) + 1 + ivsize + 1 + encrypted_datalen;
+	datablob_len = format_len + 1 + strlen(master_desc) + 1 +
+		       strlen(datalen) + 1 + IV_SIZE + 1 + encrypted_datalen;
 
 	ret = key_payload_reserve(key, payload_datalen + datablob_len
 				  + HASH_SIZE + 1);
@@ -664,13 +596,14 @@ static int encrypted_key_decrypt(struct encrypted_key_payload *epayload,
 	size_t asciilen;
 	int ret;
 
-	encrypted_datalen = roundup(epayload->decrypted_datalen, blksize);
-	asciilen = (ivsize + 1 + encrypted_datalen + HASH_SIZE) * 2;
+	encrypted_datalen =
+		roundup(epayload->decrypted_datalen, AES_BLOCK_SIZE);
+	asciilen = (IV_SIZE + 1 + encrypted_datalen + HASH_SIZE) * 2;
 	if (strlen(hex_encoded_iv) != asciilen)
 		return -EINVAL;
 
-	hex_encoded_data = hex_encoded_iv + (2 * ivsize) + 2;
-	ret = hex2bin(epayload->iv, hex_encoded_iv, ivsize);
+	hex_encoded_data = hex_encoded_iv + (2 * IV_SIZE) + 2;
+	ret = hex2bin(epayload->iv, hex_encoded_iv, IV_SIZE);
 	if (ret < 0)
 		return -EINVAL;
 	ret = hex2bin(epayload->encrypted_data, hex_encoded_data,
@@ -719,7 +652,7 @@ static void __ekey_init(struct encrypted_key_payload *epayload,
 	epayload->master_desc = epayload->format + format_len + 1;
 	epayload->datalen = epayload->master_desc + strlen(master_desc) + 1;
 	epayload->iv = epayload->datalen + strlen(datalen) + 1;
-	epayload->encrypted_data = epayload->iv + ivsize + 1;
+	epayload->encrypted_data = epayload->iv + IV_SIZE + 1;
 	epayload->decrypted_data = epayload->payload_data;
 
 	if (!format)
@@ -763,11 +696,11 @@ static int encrypted_init(struct encrypted_key_payload *epayload,
 	if (hex_encoded_iv) {
 		ret = encrypted_key_decrypt(epayload, format, hex_encoded_iv);
 	} else if (decrypted_data) {
-		get_random_bytes(epayload->iv, ivsize);
+		get_random_bytes(epayload->iv, IV_SIZE);
 		ret = hex2bin(epayload->decrypted_data, decrypted_data,
 			      epayload->decrypted_datalen);
 	} else {
-		get_random_bytes(epayload->iv, ivsize);
+		get_random_bytes(epayload->iv, IV_SIZE);
 		get_random_bytes(epayload->decrypted_data, epayload->decrypted_datalen);
 	}
 	return ret;
@@ -884,7 +817,7 @@ static int encrypted_update(struct key *key, struct key_preparsed_payload *prep)
 	__ekey_init(new_epayload, epayload->format, new_master_desc,
 		    epayload->datalen);
 
-	memcpy(new_epayload->iv, epayload->iv, ivsize);
+	memcpy(new_epayload->iv, epayload->iv, IV_SIZE);
 	memcpy(new_epayload->payload_data, epayload->payload_data,
 	       epayload->payload_datalen);
 
@@ -918,9 +851,9 @@ static long encrypted_read(const struct key *key, char *buffer,
 	epayload = dereference_key_locked(key);
 
 	/* returns the hex encoded iv, encrypted-data, and hmac as ascii */
-	asciiblob_len = epayload->datablob_len + ivsize + 1
-	    + roundup(epayload->decrypted_datalen, blksize)
-	    + (HASH_SIZE * 2);
+	asciiblob_len = epayload->datablob_len + IV_SIZE + 1 +
+			roundup(epayload->decrypted_datalen, AES_BLOCK_SIZE) +
+			(HASH_SIZE * 2);
 
 	if (!buffer || buflen < asciiblob_len)
 		return asciiblob_len;
@@ -982,11 +915,6 @@ EXPORT_SYMBOL_GPL(key_type_encrypted);
 
 static int __init init_encrypted(void)
 {
-	int ret;
-
-	ret = aes_get_sizes();
-	if (ret < 0)
-		return ret;
 	return register_key_type(&key_type_encrypted);
 }
 
-- 
2.54.0

