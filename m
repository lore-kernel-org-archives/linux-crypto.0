Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFDB3876AF;
	Mon, 12 Jan 2026 19:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245814; cv=none; b=U20Mgieid2cMJ8YF3rOXaIwBar7yEdP+XEGUWbDxtgHtzge+g2lUNWI/yvPyLuqhxn479WBlR07Py5ACV7z2ZzuI4aDZNGSEncSkcl5dga19MMQQyO/rh802LhnxJK7EINyWf5hmBGbrrXpOWcuv0n5QH6qnlM5n2XC6BcsMiME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245814; c=relaxed/simple;
	bh=2yX1SAnAgKA7xbLH25xiQD42E7Ke51oKK+KgmtTec0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTOuV5OcLp7suMErL5D6hb1+LeZHwZjoMunJ6a77v6uUFRFam/qa3XNsp3c6ai0JWFpaAWD5fqCKswEy2sg2Fx61DfmQ1mJoEVwo7hb0oo2YEXqylAqI0BYK2yR6Y0q1sGjezmKQSgqffSBTv6t8Su0JiT6JuX8bUtQlPyWgcxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGAY+Svh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGAY+Svh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEABC16AAE;
	Mon, 12 Jan 2026 19:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245814;
	bh=2yX1SAnAgKA7xbLH25xiQD42E7Ke51oKK+KgmtTec0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGAY+SvhLYay2TgvMrif+ANkVrcmyC25n1wXaObgxPNPKPgRoxlQESdodwyIlX2O1
	 Q7V+wgk/nfCRxUZyBdqtJpnEkJt9FZOZmB5On9rs+UHN8bgEQHxrp9E0K0lczA7srL
	 6eJ9tBw9XF+0C2b1m7/xwczEdD9UCDYr7j5hz8+y1XDiwjnH7f+y/CNqvw8lACWblO
	 sYUtSTxUN4kpurSKzm1oIDucrgK73G2ZVnm6TjcmdGSV0lvQyV+gFkFKri+6p6T7cv
	 NYuvcNGcXlDvOweSxvKR6G27MBmsS4uZWPAbKl9rJo5b+3MJJrWYwA+f9oIUhjDU+a
	 /ht13DAlXfpLg==
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
Subject: [PATCH v2 30/35] crypto: inside-secure - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:28 -0800
Message-ID: <20260112192035.10427-31-ebiggers@kernel.org>
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

This driver used crypto_aes_ctx::key_enc, but only to access the copy of
the raw key that is stored at the beginning of the expanded key.  To
eliminate the dependency on this field, instead just access the raw key
directly, which is already available in the relevant functions.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 12 +++++-------
 drivers/crypto/inside-secure/safexcel_hash.c   | 14 +++++++-------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 919e5a2cab95..27b180057417 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2505,31 +2505,29 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 				    unsigned int len)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct aes_enckey aes;
 	u32 hashkey[AES_BLOCK_SIZE >> 2];
 	int ret, i;
 
-	ret = aes_expandkey(&aes, key, len);
-	if (ret) {
-		memzero_explicit(&aes, sizeof(aes));
+	ret = aes_prepareenckey(&aes, key, len);
+	if (ret)
 		return ret;
-	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < len / sizeof(u32); i++) {
-			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
+			if (ctx->key[i] != get_unaligned((__le32 *)key + i)) {
 				ctx->base.needs_inv = true;
 				break;
 			}
 		}
 	}
 
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
+		ctx->key[i] = get_unaligned((__le32 *)key + i);
 
 	ctx->key_len = len;
 
 	/* Compute hash key by encrypting zeroes with cipher key */
 	memset(hashkey, 0, AES_BLOCK_SIZE);
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ef0ba4832928..e534b7a200cf 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -28,11 +28,11 @@ struct safexcel_ahash_ctx {
 	bool cbcmac;
 	bool do_fallback;
 	bool fb_init_done;
 	bool fb_do_setkey;
 
-	struct crypto_aes_ctx *aes;
+	struct aes_enckey *aes;
 	struct crypto_ahash *fback;
 	struct crypto_shash *shpre;
 	struct shash_desc *shdesc;
 };
 
@@ -1974,11 +1974,11 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	u32 key_tmp[3 * AES_BLOCK_SIZE / sizeof(u32)];
 	int ret, i;
 
-	ret = aes_expandkey(ctx->aes, key, len);
+	ret = aes_prepareenckey(ctx->aes, key, len);
 	if (ret)
 		return ret;
 
 	/* precompute the XCBC key material */
 	aes_encrypt(ctx->aes, (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
@@ -1988,13 +1988,13 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	aes_encrypt(ctx->aes, (u8 *)key_tmp + AES_BLOCK_SIZE,
 		    "\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 	for (i = 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
 		ctx->base.ipad.word[i] = swab32(key_tmp[i]);
 
-	ret = aes_expandkey(ctx->aes,
-			    (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
-			    AES_MIN_KEY_SIZE);
+	ret = aes_prepareenckey(ctx->aes,
+				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
+				AES_MIN_KEY_SIZE);
 	if (ret)
 		return ret;
 
 	ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
 	ctx->key_sz = AES_MIN_KEY_SIZE + 2 * AES_BLOCK_SIZE;
@@ -2060,16 +2060,16 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	u64 _const[2];
 	u8 msb_mask, gfmask;
 	int ret, i;
 
 	/* precompute the CMAC key material */
-	ret = aes_expandkey(ctx->aes, key, len);
+	ret = aes_prepareenckey(ctx->aes, key, len);
 	if (ret)
 		return ret;
 
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->base.ipad.word[i + 8] = swab32(ctx->aes->key_enc[i]);
+		ctx->base.ipad.word[i + 8] = get_unaligned_be32(&key[4 * i]);
 
 	/* code below borrowed from crypto/cmac.c */
 	/* encrypt the zero block */
 	memset(consts, 0, AES_BLOCK_SIZE);
 	aes_encrypt(ctx->aes, (u8 *)consts, (u8 *)consts);
-- 
2.52.0

