Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA24932E125;
	Mon,  5 Jan 2026 05:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590110; cv=none; b=OIOA7daTamRgv6fy5VhWGDC5gw6BJTeDff59+v0uDn4dMkx5VWZGuRHySrp6TnTQdEFwPlXA9SOR03YT9LGV6OYI0AXaU+iaJCU4RrkyZc30KLpMUdmxyxIVpiCGz0WdcwhPeLNNrKr1NdQMJtxVXkbuNoUqSx6DSybLSfpEMdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590110; c=relaxed/simple;
	bh=wJDXqC34yYbvhYsjXLh3aBT4XgX45/Dw2oMXNDtWJxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ca8TLvshx9IrN6ofLC5accSxlTQXDmHcdG5PMU69p5559ZUFpRqj2J6JdG0NhlE+jzBzMCi0H8VkhhU1FKqZMksbslyUuShylmYoWz54VsKcT3w9R4nLLoifB+RDghKnNVorKQ1c8gSp1H8SVAZujzXUjI0GNyTvkoNbPI+qCRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugWHcdh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugWHcdh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E8FC16AAE;
	Mon,  5 Jan 2026 05:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590110;
	bh=wJDXqC34yYbvhYsjXLh3aBT4XgX45/Dw2oMXNDtWJxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugWHcdh9H6hslbELP/jQ/VQWg2OOEnEpq/0dOSFZZZEme57Vm3GP3y/p2XJG0opYU
	 n1fhH4gacjYDS+yJC/HYO2wpAbLsrEqTfS6Lku2oj2LNYuKriMPCaGuv76SbJI1hXP
	 EgzM01ml3xAxLOBfVDnB+N3ALk3bOZaZS8q9E50zodYv6ZzmXuETAgi0QsyWt1noMF
	 gqhTG8KhKYOIFzVmbjF0XCmfP4MTjihuoEnxAZXSotq6Bm0jxoMw/wtpNKyD3isWjo
	 ASrD95sschq8Acya4r1tH0D2sej5xmER57xSb61zGzWVPy/WuaR3bROzCQU2MtI4dF
	 KtK7n14G/QxeA==
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
Subject: [PATCH 30/36] crypto: inside-secure - Use new AES library API
Date: Sun,  4 Jan 2026 21:13:03 -0800
Message-ID: <20260105051311.1607207-31-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
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

Note that this driver used crypto_aes_ctx::key_enc, but only to access
the copy of the raw key that is stored at the beginning of the expanded
key.  To eliminate the dependency on this field, instead just access the
raw key directly, which is already available in the relevant functions.

Note: aes_encrypt_new() will be renamed to aes_encrypt() once all
callers of the old aes_encrypt() have been updated.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 14 ++++-----
 drivers/crypto/inside-secure/safexcel_hash.c  | 30 +++++++++----------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 919e5a2cab95..eb4e0dc38b7f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2505,37 +2505,35 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
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
-	aes_encrypt(&aes, (u8 *)hashkey, (u8 *)hashkey);
+	aes_encrypt_new(&aes, (u8 *)hashkey, (u8 *)hashkey);
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++) {
 			if (be32_to_cpu(ctx->base.ipad.be[i]) != hashkey[i]) {
 				ctx->base.needs_inv = true;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ef0ba4832928..dae10d0066d7 100644
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
 
@@ -820,11 +820,11 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 
 			/* K3 */
 			result[i] = swab32(ctx->base.ipad.word[i + 4]);
 		}
 		areq->result[0] ^= 0x80;			// 10- padding
-		aes_encrypt(ctx->aes, areq->result, areq->result);
+		aes_encrypt_new(ctx->aes, areq->result, areq->result);
 		return 0;
 	} else if (unlikely(req->hmac &&
 			    (req->len == req->block_sz) &&
 			    !areq->nbytes)) {
 		/*
@@ -1974,27 +1974,27 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	u32 key_tmp[3 * AES_BLOCK_SIZE / sizeof(u32)];
 	int ret, i;
 
-	ret = aes_expandkey(ctx->aes, key, len);
+	ret = aes_prepareenckey(ctx->aes, key, len);
 	if (ret)
 		return ret;
 
 	/* precompute the XCBC key material */
-	aes_encrypt(ctx->aes, (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
-		    "\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1");
-	aes_encrypt(ctx->aes, (u8 *)key_tmp,
-		    "\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2");
-	aes_encrypt(ctx->aes, (u8 *)key_tmp + AES_BLOCK_SIZE,
-		    "\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
+	aes_encrypt_new(ctx->aes, (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
+			"\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1\x1");
+	aes_encrypt_new(ctx->aes, (u8 *)key_tmp,
+			"\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2\x2");
+	aes_encrypt_new(ctx->aes, (u8 *)key_tmp + AES_BLOCK_SIZE,
+			"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
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
@@ -2060,21 +2060,21 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
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
-	aes_encrypt(ctx->aes, (u8 *)consts, (u8 *)consts);
+	aes_encrypt_new(ctx->aes, (u8 *)consts, (u8 *)consts);
 
 	gfmask = 0x87;
 	_const[0] = be64_to_cpu(consts[1]);
 	_const[1] = be64_to_cpu(consts[0]);
 
-- 
2.52.0

