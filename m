Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B819638BDC6;
	Mon, 12 Jan 2026 19:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245816; cv=none; b=BeyeYXxEBNgF6oDgmWD8aYil2Q+zfvces4nqqBOuqGmjVmjUVwo22hx7mzSjrSKmphrrEJMwGR9cjsAvMrbYi0gUPdgc3OwK+/JWenntQt4GuPSfxN6hRshcc+1CMD43OzpP4YL3vZooKnWssDiYfqbSab76rfkiNcbDsRKJJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245816; c=relaxed/simple;
	bh=mfz4ZYJt3AWopKXA9rY3STkyUZNi7LKRSY3PzscIMgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar2zPtQutYBkBYVv3rib9Wy9UDpyOLVpi60QsTZwBhpyLEk7CsTZ4Y7NbFpztkeXCarj+E85yQEXbk85+rDMad7xA0MrvteKGmwE5P2QsjB1r822tINpx5bFtLFKhEc6wpM+CFSiUzotmuq8z8RhgWf4tVsByPCOQ30iYpaspgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5lc6/Cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5lc6/Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAD0C116D0;
	Mon, 12 Jan 2026 19:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245816;
	bh=mfz4ZYJt3AWopKXA9rY3STkyUZNi7LKRSY3PzscIMgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5lc6/CxW55D01F0aZkD+PpuXbQ9StZLbSb19NcR2aqc19iwx8bcvLzBfQ2CKBbZJ
	 HOlQVgOo0A0p3dcfR9pfL28aHxro8jtR8J1k1gz0siRRVvSHhqV+06riALpifHyreK
	 +7x4fvIO/pjiW73W7mRwy+SAgN7G6DetbTBuowmpxmOmJCngNDg1+brp3NTQ4Q8ZTq
	 y9UISG3fG9brsVPgnRsCMacDt1gC4gj+/+tEq0vqu6ly4tFHEkbHQq+JHsoT4TB1id
	 XF/JhUpiBUqMtw4pXp6qkhYYHUWX7OQX334WULSjKnFEtawqAABSXhB/gGH6fcJUwX
	 7BkQZJQJixr1Q==
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
Subject: [PATCH v2 34/35] lib/crypto: aes: Remove old AES en/decryption functions
Date: Mon, 12 Jan 2026 11:20:32 -0800
Message-ID: <20260112192035.10427-35-ebiggers@kernel.org>
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

Now that all callers of the aes_encrypt() and aes_decrypt() type-generic
macros are using the new types, remove the old functions.

Then, replace the macro with direct calls to the new functions, dropping
the "_new" suffix from them.

This completes the change in the type of the key struct that is passed
to aes_encrypt() and aes_decrypt().

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/aes.h |  24 ++-------
 lib/crypto/aes.c     | 118 +++----------------------------------------
 2 files changed, 10 insertions(+), 132 deletions(-)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 4cb3c27d1bf5..cbf1cc96db52 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -306,39 +306,23 @@ typedef union {
  * @out: Buffer to store the ciphertext block
  * @in: Buffer containing the plaintext block
  *
  * Context: Any context.
  */
-#define aes_encrypt(key, out, in) \
-	_Generic((key), \
-		 struct crypto_aes_ctx *: aes_encrypt_old((const struct crypto_aes_ctx *)(key), (out), (in)), \
-		 const struct crypto_aes_ctx *: aes_encrypt_old((const struct crypto_aes_ctx *)(key), (out), (in)), \
-		 struct aes_enckey *: aes_encrypt_new((const struct aes_enckey *)(key), (out), (in)), \
-		 const struct aes_enckey *: aes_encrypt_new((const struct aes_enckey *)(key), (out), (in)), \
-		 struct aes_key *: aes_encrypt_new((const struct aes_key *)(key), (out), (in)), \
-		 const struct aes_key *: aes_encrypt_new((const struct aes_key *)(key), (out), (in)))
-void aes_encrypt_old(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
-void aes_encrypt_new(aes_encrypt_arg key, u8 out[at_least AES_BLOCK_SIZE],
-		     const u8 in[at_least AES_BLOCK_SIZE]);
+void aes_encrypt(aes_encrypt_arg key, u8 out[at_least AES_BLOCK_SIZE],
+		 const u8 in[at_least AES_BLOCK_SIZE]);
 
 /**
  * aes_decrypt() - Decrypt a single AES block
  * @key: The AES key, previously initialized by aes_preparekey()
  * @out: Buffer to store the plaintext block
  * @in: Buffer containing the ciphertext block
  *
  * Context: Any context.
  */
-#define aes_decrypt(key, out, in) \
-	_Generic((key), \
-		 struct crypto_aes_ctx *: aes_decrypt_old((const struct crypto_aes_ctx *)(key), (out), (in)), \
-		 const struct crypto_aes_ctx *: aes_decrypt_old((const struct crypto_aes_ctx *)(key), (out), (in)), \
-		 struct aes_key *: aes_decrypt_new((const struct aes_key *)(key), (out), (in)), \
-		 const struct aes_key *: aes_decrypt_new((const struct aes_key *)(key), (out), (in)))
-void aes_decrypt_old(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
-void aes_decrypt_new(const struct aes_key *key, u8 out[at_least AES_BLOCK_SIZE],
-		     const u8 in[at_least AES_BLOCK_SIZE]);
+void aes_decrypt(const struct aes_key *key, u8 out[at_least AES_BLOCK_SIZE],
+		 const u8 in[at_least AES_BLOCK_SIZE]);
 
 extern const u8 crypto_aes_sbox[];
 extern const u8 crypto_aes_inv_sbox[];
 extern const u32 aes_enc_tab[256];
 extern const u32 aes_dec_tab[256];
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 88da68dcf5a8..b7ab2d0c4e59 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -249,26 +249,10 @@ static u32 inv_mix_columns(u32 x)
 	u32 y = mul_by_x2(x);
 
 	return mix_columns(x ^ y ^ ror32(y, 16));
 }
 
-static __always_inline u32 subshift(u32 in[], int pos)
-{
-	return (aes_sbox[in[pos] & 0xff]) ^
-	       (aes_sbox[(in[(pos + 1) % 4] >>  8) & 0xff] <<  8) ^
-	       (aes_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
-	       (aes_sbox[(in[(pos + 3) % 4] >> 24) & 0xff] << 24);
-}
-
-static __always_inline u32 inv_subshift(u32 in[], int pos)
-{
-	return (aes_inv_sbox[in[pos] & 0xff]) ^
-	       (aes_inv_sbox[(in[(pos + 3) % 4] >>  8) & 0xff] <<  8) ^
-	       (aes_inv_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
-	       (aes_inv_sbox[(in[(pos + 1) % 4] >> 24) & 0xff] << 24);
-}
-
 static u32 subw(u32 in)
 {
 	return (aes_sbox[in & 0xff]) ^
 	       (aes_sbox[(in >>  8) & 0xff] <<  8) ^
 	       (aes_sbox[(in >> 16) & 0xff] << 16) ^
@@ -343,55 +327,10 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 	aes_expandkey_generic(ctx->key_enc, ctx->key_dec, in_key, key_len);
 	return 0;
 }
 EXPORT_SYMBOL(aes_expandkey);
 
-void aes_encrypt_old(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
-{
-	const u32 *rkp = ctx->key_enc + 4;
-	int rounds = 6 + ctx->key_length / 4;
-	u32 st0[4], st1[4];
-	int round;
-
-	st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
-	st0[1] = ctx->key_enc[1] ^ get_unaligned_le32(in + 4);
-	st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
-	st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
-
-	/*
-	 * Force the compiler to emit data independent Sbox references,
-	 * by xoring the input with Sbox values that are known to add up
-	 * to zero. This pulls the entire Sbox into the D-cache before any
-	 * data dependent lookups are done.
-	 */
-	st0[0] ^= aes_sbox[ 0] ^ aes_sbox[ 64] ^ aes_sbox[134] ^ aes_sbox[195];
-	st0[1] ^= aes_sbox[16] ^ aes_sbox[ 82] ^ aes_sbox[158] ^ aes_sbox[221];
-	st0[2] ^= aes_sbox[32] ^ aes_sbox[ 96] ^ aes_sbox[160] ^ aes_sbox[234];
-	st0[3] ^= aes_sbox[48] ^ aes_sbox[112] ^ aes_sbox[186] ^ aes_sbox[241];
-
-	for (round = 0;; round += 2, rkp += 8) {
-		st1[0] = mix_columns(subshift(st0, 0)) ^ rkp[0];
-		st1[1] = mix_columns(subshift(st0, 1)) ^ rkp[1];
-		st1[2] = mix_columns(subshift(st0, 2)) ^ rkp[2];
-		st1[3] = mix_columns(subshift(st0, 3)) ^ rkp[3];
-
-		if (round == rounds - 2)
-			break;
-
-		st0[0] = mix_columns(subshift(st1, 0)) ^ rkp[4];
-		st0[1] = mix_columns(subshift(st1, 1)) ^ rkp[5];
-		st0[2] = mix_columns(subshift(st1, 2)) ^ rkp[6];
-		st0[3] = mix_columns(subshift(st1, 3)) ^ rkp[7];
-	}
-
-	put_unaligned_le32(subshift(st1, 0) ^ rkp[4], out);
-	put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
-	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
-	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
-}
-EXPORT_SYMBOL(aes_encrypt_old);
-
 static __always_inline u32 enc_quarterround(const u32 w[4], int i, u32 rk)
 {
 	return rk ^ aes_enc_tab[(u8)w[i]] ^
 	       rol32(aes_enc_tab[(u8)(w[(i + 1) % 4] >> 8)], 8) ^
 	       rol32(aes_enc_tab[(u8)(w[(i + 2) % 4] >> 16)], 16) ^
@@ -496,55 +435,10 @@ static void __maybe_unused aes_decrypt_generic(const u32 inv_rndkeys[],
 	put_unaligned_le32(declast_quarterround(w, 1, *rkp++), &out[4]);
 	put_unaligned_le32(declast_quarterround(w, 2, *rkp++), &out[8]);
 	put_unaligned_le32(declast_quarterround(w, 3, *rkp++), &out[12]);
 }
 
-void aes_decrypt_old(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
-{
-	const u32 *rkp = ctx->key_dec + 4;
-	int rounds = 6 + ctx->key_length / 4;
-	u32 st0[4], st1[4];
-	int round;
-
-	st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
-	st0[1] = ctx->key_dec[1] ^ get_unaligned_le32(in + 4);
-	st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
-	st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
-
-	/*
-	 * Force the compiler to emit data independent Sbox references,
-	 * by xoring the input with Sbox values that are known to add up
-	 * to zero. This pulls the entire Sbox into the D-cache before any
-	 * data dependent lookups are done.
-	 */
-	st0[0] ^= aes_inv_sbox[ 0] ^ aes_inv_sbox[ 64] ^ aes_inv_sbox[129] ^ aes_inv_sbox[200];
-	st0[1] ^= aes_inv_sbox[16] ^ aes_inv_sbox[ 83] ^ aes_inv_sbox[150] ^ aes_inv_sbox[212];
-	st0[2] ^= aes_inv_sbox[32] ^ aes_inv_sbox[ 96] ^ aes_inv_sbox[160] ^ aes_inv_sbox[236];
-	st0[3] ^= aes_inv_sbox[48] ^ aes_inv_sbox[112] ^ aes_inv_sbox[187] ^ aes_inv_sbox[247];
-
-	for (round = 0;; round += 2, rkp += 8) {
-		st1[0] = inv_mix_columns(inv_subshift(st0, 0)) ^ rkp[0];
-		st1[1] = inv_mix_columns(inv_subshift(st0, 1)) ^ rkp[1];
-		st1[2] = inv_mix_columns(inv_subshift(st0, 2)) ^ rkp[2];
-		st1[3] = inv_mix_columns(inv_subshift(st0, 3)) ^ rkp[3];
-
-		if (round == rounds - 2)
-			break;
-
-		st0[0] = inv_mix_columns(inv_subshift(st1, 0)) ^ rkp[4];
-		st0[1] = inv_mix_columns(inv_subshift(st1, 1)) ^ rkp[5];
-		st0[2] = inv_mix_columns(inv_subshift(st1, 2)) ^ rkp[6];
-		st0[3] = inv_mix_columns(inv_subshift(st1, 3)) ^ rkp[7];
-	}
-
-	put_unaligned_le32(inv_subshift(st1, 0) ^ rkp[4], out);
-	put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
-	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
-	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
-}
-EXPORT_SYMBOL(aes_decrypt_old);
-
 /*
  * Note: the aes_prepare*key_* names reflect the fact that the implementation
  * might not actually expand the key.  (The s390 code for example doesn't.)
  * Where the key is expanded we use the more specific names aes_expandkey_*.
  *
@@ -606,23 +500,23 @@ int aes_prepareenckey(struct aes_enckey *key, const u8 *in_key, size_t key_len)
 {
 	return __aes_preparekey(key, NULL, in_key, key_len);
 }
 EXPORT_SYMBOL(aes_prepareenckey);
 
-void aes_encrypt_new(aes_encrypt_arg key, u8 out[AES_BLOCK_SIZE],
-		     const u8 in[AES_BLOCK_SIZE])
+void aes_encrypt(aes_encrypt_arg key, u8 out[AES_BLOCK_SIZE],
+		 const u8 in[AES_BLOCK_SIZE])
 {
 	aes_encrypt_arch(key.enc_key, out, in);
 }
-EXPORT_SYMBOL(aes_encrypt_new);
+EXPORT_SYMBOL(aes_encrypt);
 
-void aes_decrypt_new(const struct aes_key *key, u8 out[AES_BLOCK_SIZE],
-		     const u8 in[AES_BLOCK_SIZE])
+void aes_decrypt(const struct aes_key *key, u8 out[AES_BLOCK_SIZE],
+		 const u8 in[AES_BLOCK_SIZE])
 {
 	aes_decrypt_arch(key, out, in);
 }
-EXPORT_SYMBOL(aes_decrypt_new);
+EXPORT_SYMBOL(aes_decrypt);
 
 #ifdef aes_mod_init_arch
 static int __init aes_mod_init(void)
 {
 	aes_mod_init_arch();
-- 
2.52.0

