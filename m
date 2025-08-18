Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783CC1ADC83
	for <linux-crypto@vger.kernel.org>; Mon, 18 Aug 2025 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755557496; cv=none; b=f07dWKuS70Rp7GeFsyiX6qJQ6tJ5Cp0qzCa1LRUZBQ/soeio89yrXmeL7Y1IiQxR8A6qrSKViC4XEEYipzDt9px/yadWFQXCmdWAAQWbJyWuiGIexBTajiWZSUkTM0edTT+8r71LFs5N6KtKFFz5ElWYilwmD2uw43hEqg6A430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755557496; c=relaxed/simple;
	bh=2w26WXZcX+WzHaGO9KCdtfoKGa0Vl7NF2YKuWgbitUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PhVX3SgZBuV6S86f57nkXA5QUm6T44ZNfIzonOxhezX8HcnfghKv1Vs92qhYZ+EKJlNu815WI962VbSP2Z1L2cY8UJrRrT7YbMidZuNnCSFlxti5GwuD45Qh6nHY3WmnmSBVc3vo19qBvk03EwXS0EPd5L9WzC5bcI5XgQPazRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/qFzAaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/qFzAaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A268C4CEEB;
	Mon, 18 Aug 2025 22:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755557496;
	bh=2w26WXZcX+WzHaGO9KCdtfoKGa0Vl7NF2YKuWgbitUQ=;
	h=From:To:Cc:Subject:Date:From;
	b=a/qFzAaLGA4buMMVNyDbxG/IK1vMAmoj+cSFh9clUknW66c0VGbThNdc5RYUwUVGL
	 MXFPFhb+FO8VHUKNfdaZwEuN+krMjXQAOIq9srTk6onSiMe3RW205LvE/jlYhAjMGO
	 fWmK0ebWzv3gupmQ+FieujXoLrepHOBUYNktsgCLumAKxXpD/6g7+k6IFMJ2x2+0I+
	 kc9SqpJ4VO+o2D3J9Vyhl6FWf1fGMG/p2ewjmVEsEbhn1ran+7mM3s9Yy+xwESL1rO
	 l7k9h2LdSGtaWcCyenW/OQlOcbn28hwWglMjAStj2YXlOgsTuU5/G73+cwnQMF5KXt
	 NxjKDuuNcTM0w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: arm64/aes - use SHA-256 library instead of crypto_shash
Date: Mon, 18 Aug 2025 15:47:40 -0700
Message-ID: <20250818224740.103925-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In essiv_cbc_set_key(), just use the SHA-256 library instead of
crypto_shash.  This is simpler and also slightly faster.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/Kconfig    |  1 +
 arch/arm64/crypto/aes-glue.c | 21 +--------------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 3bb5b513d5ae2..91f3093eee6ab 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -69,10 +69,11 @@ config CRYPTO_POLYVAL_ARM64_CE
 	  - ARMv8 Crypto Extensions
 
 config CRYPTO_AES_ARM64
 	tristate "Ciphers: AES, modes: ECB, CBC, CTR, CTS, XCTR, XTS"
 	select CRYPTO_AES
+	select CRYPTO_LIB_SHA256
 	help
 	  Block ciphers: AES cipher algorithms (FIPS-197)
 	  Length-preserving ciphers: AES with ECB, CBC, CTR, CTS,
 	    XCTR, and XTS modes
 	  AEAD cipher: AES with CBC, ESSIV, and SHA-256
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 81560f722b9de..5e207ff34482f 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -120,11 +120,10 @@ struct crypto_aes_xts_ctx {
 };
 
 struct crypto_aes_essiv_cbc_ctx {
 	struct crypto_aes_ctx key1;
 	struct crypto_aes_ctx __aligned(8) key2;
-	struct crypto_shash *hash;
 };
 
 struct mac_tfm_ctx {
 	struct crypto_aes_ctx key;
 	u8 __aligned(8) consts[];
@@ -169,11 +168,11 @@ static int __maybe_unused essiv_cbc_set_key(struct crypto_skcipher *tfm,
 
 	ret = aes_expandkey(&ctx->key1, in_key, key_len);
 	if (ret)
 		return ret;
 
-	crypto_shash_tfm_digest(ctx->hash, in_key, key_len, digest);
+	sha256(in_key, key_len, digest);
 
 	return aes_expandkey(&ctx->key2, digest, sizeof(digest));
 }
 
 static int __maybe_unused ecb_encrypt(struct skcipher_request *req)
@@ -386,26 +385,10 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	kernel_neon_end();
 
 	return skcipher_walk_done(&walk, 0);
 }
 
-static int __maybe_unused essiv_cbc_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->hash = crypto_alloc_shash("sha256", 0, 0);
-
-	return PTR_ERR_OR_ZERO(ctx->hash);
-}
-
-static void __maybe_unused essiv_cbc_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_shash(ctx->hash);
-}
-
 static int __maybe_unused essiv_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err, rounds = 6 + ctx->key1.key_length / 4;
@@ -791,12 +774,10 @@ static struct skcipher_alg aes_algs[] = { {
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
 	.setkey		= essiv_cbc_set_key,
 	.encrypt	= essiv_cbc_encrypt,
 	.decrypt	= essiv_cbc_decrypt,
-	.init		= essiv_cbc_init_tfm,
-	.exit		= essiv_cbc_exit_tfm,
 } };
 
 static int cbcmac_setkey(struct crypto_shash *tfm, const u8 *in_key,
 			 unsigned int key_len)
 {

base-commit: 34c065fe1d0dbb08073d83559d3173bb4f17dcc5
-- 
2.50.1

