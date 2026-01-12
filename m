Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B147338A9D5;
	Mon, 12 Jan 2026 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245815; cv=none; b=gtQMoUEYwTvkG+TOT+eHY0jrGm4bJfew2tCA0tpB0T4elq/z8/hNONF0IFf879o8BPTuH4p7o4aEShUu2fOU35ky1un9f3WnJy5m4TcWgDAkf+ZRIJYT1unwqye3o9zcUhrB52K2gJD6fwbWRYIB8DAtExCOWJ+7U4dCHlNgVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245815; c=relaxed/simple;
	bh=JLs8bq0ROpmCEQjkpHCQ8d/SpuKsQOsr6NwPCgnihKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPF4w7CTONlp+EWWrdI2TpDtbM8R9cbNhw0sbewkk4kPcuCauXospV6xldAS5xdXbNfEoVH5iElYv11HOZbPSy/b8kUMWoLpby6wCFrFDGUDy4OrTSCd5/beB8Ozo8aaY458XeF6EcyhgTE1mkUahlkO6ApPI3m7wjGkOViSlj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0RBfUzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0RBfUzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27044C19424;
	Mon, 12 Jan 2026 19:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245815;
	bh=JLs8bq0ROpmCEQjkpHCQ8d/SpuKsQOsr6NwPCgnihKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0RBfUzQys2ZqJtm4Gnsyo+LFtO49H/4V1vBcG0UFdcL3d4er81g2SKeTPRBUfXlD
	 m4M0CH0sjlKOMYmu5MKQUxxNNhgjBkXhlxsEJWsyOMNw/H5cz+0C/Ps+oieOmtIsnf
	 42oOgGWrCU2dcQWgW9oaLQ2GOJT0MjnsdRT7AGxdEQdlwoJHzPSgRrGn+bi8VRh99V
	 4KSB/CeMRewIeb8S1zLPd6/900w117IawjI2VbypbiXJ+dWaHngCbGCS57sol6Vy9F
	 PmtGWO6L8nZLLtYShrJjmWS/Q0DYQ/3ba+J/FyOtwkWnRCotaa8rKeBIPbKmTpxzYr
	 klHjBpXQvod3w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 32/35] lib/crypto: aescfb: Use new AES library API
Date: Mon, 12 Jan 2026 11:20:30 -0800
Message-ID: <20260112192035.10427-33-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/char/tpm/tpm2-sessions.c | 10 +++++-----
 include/crypto/aes.h             |  4 ++--
 lib/crypto/aescfb.c              | 30 +++++++++++++++---------------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 4149379665c4..09df6353ef04 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -124,11 +124,11 @@ struct tpm2_auth {
 	 * session_key and passphrase.
 	 */
 	u8 session_key[SHA256_DIGEST_SIZE];
 	u8 passphrase[SHA256_DIGEST_SIZE];
 	int passphrase_len;
-	struct crypto_aes_ctx aes_ctx;
+	struct aes_enckey aes_key;
 	/* saved session attributes: */
 	u8 attrs;
 	__be32 ordinal;
 
 	/*
@@ -675,12 +675,12 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf)
 			  + auth->passphrase_len, "CFB", auth->our_nonce,
 			  auth->tpm_nonce, AES_KEY_BYTES + AES_BLOCK_SIZE,
 			  auth->scratch);
 
 		len = tpm_buf_read_u16(buf, &offset_p);
-		aes_expandkey(&auth->aes_ctx, auth->scratch, AES_KEY_BYTES);
-		aescfb_encrypt(&auth->aes_ctx, &buf->data[offset_p],
+		aes_prepareenckey(&auth->aes_key, auth->scratch, AES_KEY_BYTES);
+		aescfb_encrypt(&auth->aes_key, &buf->data[offset_p],
 			       &buf->data[offset_p], len,
 			       auth->scratch + AES_KEY_BYTES);
 		/* reset p to beginning of parameters for HMAC */
 		offset_p -= 2;
 	}
@@ -856,12 +856,12 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 			  + auth->passphrase_len, "CFB", auth->tpm_nonce,
 			  auth->our_nonce, AES_KEY_BYTES + AES_BLOCK_SIZE,
 			  auth->scratch);
 
 		len = tpm_buf_read_u16(buf, &offset_p);
-		aes_expandkey(&auth->aes_ctx, auth->scratch, AES_KEY_BYTES);
-		aescfb_decrypt(&auth->aes_ctx, &buf->data[offset_p],
+		aes_prepareenckey(&auth->aes_key, auth->scratch, AES_KEY_BYTES);
+		aescfb_decrypt(&auth->aes_key, &buf->data[offset_p],
 			       &buf->data[offset_p], len,
 			       auth->scratch + AES_KEY_BYTES);
 	}
 
  out:
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 4a56aed59973..4cb3c27d1bf5 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -341,11 +341,11 @@ void aes_decrypt_new(const struct aes_key *key, u8 out[at_least AES_BLOCK_SIZE],
 extern const u8 crypto_aes_sbox[];
 extern const u8 crypto_aes_inv_sbox[];
 extern const u32 aes_enc_tab[256];
 extern const u32 aes_dec_tab[256];
 
-void aescfb_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+void aescfb_encrypt(const struct aes_enckey *key, u8 *dst, const u8 *src,
 		    int len, const u8 iv[AES_BLOCK_SIZE]);
-void aescfb_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+void aescfb_decrypt(const struct aes_enckey *key, u8 *dst, const u8 *src,
 		    int len, const u8 iv[AES_BLOCK_SIZE]);
 
 #endif
diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index 0f294c8cbf3c..147e5211728f 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -9,11 +9,11 @@
 #include <crypto/algapi.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <asm/irqflags.h>
 
-static void aescfb_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
+static void aescfb_encrypt_block(const struct aes_enckey *key, void *dst,
 				 const void *src)
 {
 	unsigned long flags;
 
 	/*
@@ -23,31 +23,31 @@ static void aescfb_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
 	 * extent by pulling the entire S-box into the caches before doing any
 	 * substitutions, but this strategy is more effective when running with
 	 * interrupts disabled.
 	 */
 	local_irq_save(flags);
-	aes_encrypt(ctx, dst, src);
+	aes_encrypt(key, dst, src);
 	local_irq_restore(flags);
 }
 
 /**
  * aescfb_encrypt - Perform AES-CFB encryption on a block of data
  *
- * @ctx:	The AES-CFB key schedule
+ * @key:	The AES-CFB key schedule
  * @dst:	Pointer to the ciphertext output buffer
  * @src:	Pointer the plaintext (may equal @dst for encryption in place)
  * @len:	The size in bytes of the plaintext and ciphertext.
  * @iv:		The initialization vector (IV) to use for this block of data
  */
-void aescfb_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+void aescfb_encrypt(const struct aes_enckey *key, u8 *dst, const u8 *src,
 		    int len, const u8 iv[AES_BLOCK_SIZE])
 {
 	u8 ks[AES_BLOCK_SIZE];
 	const u8 *v = iv;
 
 	while (len > 0) {
-		aescfb_encrypt_block(ctx, ks, v);
+		aescfb_encrypt_block(key, ks, v);
 		crypto_xor_cpy(dst, src, ks, min(len, AES_BLOCK_SIZE));
 		v = dst;
 
 		dst += AES_BLOCK_SIZE;
 		src += AES_BLOCK_SIZE;
@@ -59,31 +59,31 @@ void aescfb_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
 EXPORT_SYMBOL(aescfb_encrypt);
 
 /**
  * aescfb_decrypt - Perform AES-CFB decryption on a block of data
  *
- * @ctx:	The AES-CFB key schedule
+ * @key:	The AES-CFB key schedule
  * @dst:	Pointer to the plaintext output buffer
  * @src:	Pointer the ciphertext (may equal @dst for decryption in place)
  * @len:	The size in bytes of the plaintext and ciphertext.
  * @iv:		The initialization vector (IV) to use for this block of data
  */
-void aescfb_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+void aescfb_decrypt(const struct aes_enckey *key, u8 *dst, const u8 *src,
 		    int len, const u8 iv[AES_BLOCK_SIZE])
 {
 	u8 ks[2][AES_BLOCK_SIZE];
 
-	aescfb_encrypt_block(ctx, ks[0], iv);
+	aescfb_encrypt_block(key, ks[0], iv);
 
 	for (int i = 0; len > 0; i ^= 1) {
 		if (len > AES_BLOCK_SIZE)
 			/*
 			 * Generate the keystream for the next block before
 			 * performing the XOR, as that may update in place and
 			 * overwrite the ciphertext.
 			 */
-			aescfb_encrypt_block(ctx, ks[!i], src);
+			aescfb_encrypt_block(key, ks[!i], src);
 
 		crypto_xor_cpy(dst, src, ks[i], min(len, AES_BLOCK_SIZE));
 
 		dst += AES_BLOCK_SIZE;
 		src += AES_BLOCK_SIZE;
@@ -212,34 +212,34 @@ static struct {
 };
 
 static int __init libaescfb_init(void)
 {
 	for (int i = 0; i < ARRAY_SIZE(aescfb_tv); i++) {
-		struct crypto_aes_ctx ctx;
+		struct aes_enckey key;
 		u8 buf[64];
 
-		if (aes_expandkey(&ctx, aescfb_tv[i].key, aescfb_tv[i].klen)) {
-			pr_err("aes_expandkey() failed on vector %d\n", i);
+		if (aes_prepareenckey(&key, aescfb_tv[i].key, aescfb_tv[i].klen)) {
+			pr_err("aes_prepareenckey() failed on vector %d\n", i);
 			return -ENODEV;
 		}
 
-		aescfb_encrypt(&ctx, buf, aescfb_tv[i].ptext, aescfb_tv[i].len,
+		aescfb_encrypt(&key, buf, aescfb_tv[i].ptext, aescfb_tv[i].len,
 			       aescfb_tv[i].iv);
 		if (memcmp(buf, aescfb_tv[i].ctext, aescfb_tv[i].len)) {
 			pr_err("aescfb_encrypt() #1 failed on vector %d\n", i);
 			return -ENODEV;
 		}
 
 		/* decrypt in place */
-		aescfb_decrypt(&ctx, buf, buf, aescfb_tv[i].len, aescfb_tv[i].iv);
+		aescfb_decrypt(&key, buf, buf, aescfb_tv[i].len, aescfb_tv[i].iv);
 		if (memcmp(buf, aescfb_tv[i].ptext, aescfb_tv[i].len)) {
 			pr_err("aescfb_decrypt() failed on vector %d\n", i);
 			return -ENODEV;
 		}
 
 		/* encrypt in place */
-		aescfb_encrypt(&ctx, buf, buf, aescfb_tv[i].len, aescfb_tv[i].iv);
+		aescfb_encrypt(&key, buf, buf, aescfb_tv[i].len, aescfb_tv[i].iv);
 		if (memcmp(buf, aescfb_tv[i].ctext, aescfb_tv[i].len)) {
 			pr_err("aescfb_encrypt() #2 failed on vector %d\n", i);
 
 			return -ENODEV;
 		}
-- 
2.52.0

