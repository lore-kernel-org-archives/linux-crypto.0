Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B541A326945;
	Mon,  5 Jan 2026 05:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590092; cv=none; b=KkZ9phHDyL0/FF63PDZ2MQOW5mXjx1sgz+aTl7nyIxOzQ0Ad2MdNjWdhLQog8BTawF4ooD8lSoBltu1W+0G3uTlnsEkm9cJzQkQFG4efSb5di5cSTnmdtGrObcC+JKhrMSvEKVcP7ZjQVjZ7/bxANvhgj2hrJAbPBYsLVzcF+rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590092; c=relaxed/simple;
	bh=sjr1LNH55w8tXq7TOAnk/6ASa4fxzCykdmQPIr1QCnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F05SNSpIdQYgI6d2BW5kZBFBOP2aSYV6Oi1Bis6e8bYBHhY7Khha6T/fhyciFbeooXkbINg0sX98JxGorFuxnPJl9rBgYyBbe2qdMMzoMxDJ6cSqKbACZqP3a0zVavfxFUfgRlBRmtNvahBQy11meBBv6ysQuqZlGZ3rB9IEyvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wx/1ZWnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wx/1ZWnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87F4C19421;
	Mon,  5 Jan 2026 05:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590092;
	bh=sjr1LNH55w8tXq7TOAnk/6ASa4fxzCykdmQPIr1QCnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx/1ZWnd+5vR3tQazOiTH2P5Sa/qguyk4xTWxRkBivOacstp9/wKZhhdpSAhkNHug
	 IMfu1o8ZlhrYKBEtdmwBa8mGbIrmEz7tEdmkESEIhnnYX/HQYE2XALQ4ZSfllMkum5
	 MOGBlZtRvXGgnP3WOaQ0gwqQx5XwnDjyPPznxesxl87UHnS5/4HBhX9n2XX4jWsrwL
	 lJOoNRpp7eyVRfJ0yuYe+XeuxcqmzZCiUbYKaQZHyebdqt0Du+bqKnF9YdLMKDbls2
	 Tg+VR+4kEpdDTPThATP2UzLanpkPfTPenaEX/sAjjBzndwhsEKdeEIhLKobRE22mL+
	 A089RXla3a9hA==
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
Subject: [PATCH 03/36] crypto: arm/aes-neonbs - Use AES library for single blocks
Date: Sun,  4 Jan 2026 21:12:36 -0800
Message-ID: <20260105051311.1607207-4-ebiggers@kernel.org>
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

aes-neonbs-glue.c calls __aes_arm_encrypt() and __aes_arm_decrypt() to
en/decrypt single blocks for CBC encryption, XTS tweak encryption, and
XTS ciphertext stealing.  In preparation for making the AES library use
this same ARM-optimized single-block AES en/decryption code and making
it an internal implementation detail of the AES library, replace the
calls to these functions with calls to the AES library.

Note that this reduces the size of the aesbs_cbc_ctx and aesbs_xts_ctx
structs, since unnecessary decryption round keys are no longer included.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/Kconfig           |  1 -
 arch/arm/crypto/aes-neonbs-glue.c | 29 ++++++++++++++++-------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 3eb5071bea14..167a648a9def 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -42,11 +42,10 @@ config CRYPTO_AES_ARM
 	  such attacks very difficult.
 
 config CRYPTO_AES_ARM_BS
 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS (bit-sliced NEON)"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_AES_ARM
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	  with block cipher modes:
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index df5afe601e4a..f892f281b441 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -10,11 +10,10 @@
 #include <crypto/aes.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <linux/module.h>
-#include "aes-cipher.h"
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_DESCRIPTION("Bit sliced AES using NEON instructions");
 MODULE_LICENSE("GPL v2");
 
@@ -46,17 +45,17 @@ struct aesbs_ctx {
 	u8	rk[13 * (8 * AES_BLOCK_SIZE) + 32] __aligned(AES_BLOCK_SIZE);
 };
 
 struct aesbs_cbc_ctx {
 	struct aesbs_ctx	key;
-	struct crypto_aes_ctx	fallback;
+	struct aes_enckey	fallback;
 };
 
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
-	struct crypto_aes_ctx	fallback;
-	struct crypto_aes_ctx	tweak_key;
+	struct aes_key		fallback;
+	struct aes_enckey	tweak_key;
 };
 
 static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
@@ -120,18 +119,23 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = aes_expandkey(&ctx->fallback, in_key, key_len);
+	err = aes_prepareenckey(&ctx->fallback, in_key, key_len);
 	if (err)
 		return err;
 
 	ctx->key.rounds = 6 + key_len / 4;
 
+	/*
+	 * Note: this assumes that the arm implementation of the AES library
+	 * stores the standard round keys in k.rndkeys.
+	 */
 	kernel_neon_begin();
-	aesbs_convert_key(ctx->key.rk, ctx->fallback.key_enc, ctx->key.rounds);
+	aesbs_convert_key(ctx->key.rk, ctx->fallback.k.rndkeys,
+			  ctx->key.rounds);
 	kernel_neon_end();
 
 	return 0;
 }
 
@@ -150,12 +154,11 @@ static int cbc_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 		u8 *prev = walk.iv;
 
 		do {
 			crypto_xor_cpy(dst, src, prev, AES_BLOCK_SIZE);
-			__aes_arm_encrypt(ctx->fallback.key_enc,
-					  ctx->key.rounds, dst, dst);
+			aes_encrypt_new(&ctx->fallback, dst, dst);
 			prev = dst;
 			src += AES_BLOCK_SIZE;
 			dst += AES_BLOCK_SIZE;
 			nbytes -= AES_BLOCK_SIZE;
 		} while (nbytes >= AES_BLOCK_SIZE);
@@ -237,14 +240,14 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	err = xts_verify_key(tfm, in_key, key_len);
 	if (err)
 		return err;
 
 	key_len /= 2;
-	err = aes_expandkey(&ctx->fallback, in_key, key_len);
+	err = aes_preparekey(&ctx->fallback, in_key, key_len);
 	if (err)
 		return err;
-	err = aes_expandkey(&ctx->tweak_key, in_key + key_len, key_len);
+	err = aes_prepareenckey(&ctx->tweak_key, in_key + key_len, key_len);
 	if (err)
 		return err;
 
 	return aesbs_setkey(tfm, in_key, key_len);
 }
@@ -277,11 +280,11 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 
 	err = skcipher_walk_virt(&walk, req, true);
 	if (err)
 		return err;
 
-	__aes_arm_encrypt(ctx->tweak_key.key_enc, rounds, walk.iv, walk.iv);
+	aes_encrypt_new(&ctx->tweak_key, walk.iv, walk.iv);
 
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 		int reorder_last_tweak = !encrypt && tail > 0;
 
@@ -309,13 +312,13 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 	scatterwalk_map_and_copy(buf, req->src, req->cryptlen, tail, 0);
 
 	crypto_xor(buf, req->iv, AES_BLOCK_SIZE);
 
 	if (encrypt)
-		__aes_arm_encrypt(ctx->fallback.key_enc, rounds, buf, buf);
+		aes_encrypt_new(&ctx->fallback, buf, buf);
 	else
-		__aes_arm_decrypt(ctx->fallback.key_dec, rounds, buf, buf);
+		aes_decrypt_new(&ctx->fallback, buf, buf);
 
 	crypto_xor(buf, req->iv, AES_BLOCK_SIZE);
 
 	scatterwalk_map_and_copy(buf, req->dst, req->cryptlen - AES_BLOCK_SIZE,
 				 AES_BLOCK_SIZE + tail, 1);
-- 
2.52.0

