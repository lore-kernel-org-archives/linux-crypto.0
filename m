Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D4B363C45;
	Thu, 19 Mar 2026 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901164; cv=none; b=a5QQ//YmkLX9VLXMl5Zj5yicoYYY6anKeFP1c9WyxaqeNnz0Ct5N+7mFZOGUxqunntNc7y9o38CK9aT4hCEJMmTMqMH0yAOYdxsfECLQBE1qVaJ1HWrEZWgBD4hkymtPOEJGfplnKTuclpXjg2lJoDNErJ2GCcnepqPFw8UoIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901164; c=relaxed/simple;
	bh=3U+NGORzr+uh9rj8G+n62LLimEQQsU/GR7nNllucuSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek/jBPphnbE6S7Rhtv71zrc6G2HtGtcOHScdCQ0sYBQRcyAr9iJwWdSb+bfXv6jCL0ZdPVNHe3hnisjX3k9HQyhZ4+mDUacgC2Xba4G7xwUHeTPXakEp7y26j88zSXjt0ILvETQoVoMmnVzvT5VmRzZBCUEDC0KUGiuhvs25tf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2Y3GEVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2Y3GEVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B06FC2BCB2;
	Thu, 19 Mar 2026 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901163;
	bh=3U+NGORzr+uh9rj8G+n62LLimEQQsU/GR7nNllucuSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2Y3GEVLGtbsHY8WNRU+QFtRIEvKC6sgYmhQjrPtaNQJHos9ekuXQTY0AiXpp5Ygs
	 36CIJ5QSZzuwHHRdIXj6WbXCskrNNkJtG1oBpEzt4z9NgHtoD5om3QeKkjnKsG3DJG
	 olZFYsn7vYCLr4TlueikipE26Ea42XWUA11/b/XDxSNOGqi6H1NzHuQUWQOpKGm0iN
	 4+kAS02ryjXuwJez66eLP6nwrbpJuxJMs8VzC8IO0YNdj3sCyGZ4iS4Uv2hUxZZ2OW
	 MW5pYJD4e1KYvCs/nNWHL7g0aMpyDayR3GGYAzrBIms8gHhr697QWnkIQAZZH0/OBX
	 yhtS5h/NzKhMw==
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
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 19/19] lib/crypto: aesgcm: Use GHASH library API
Date: Wed, 18 Mar 2026 23:17:20 -0700
Message-ID: <20260319061723.1140720-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the AES-GCM library use the GHASH library instead of directly
calling gf128mul_lle().  This allows the architecture-optimized GHASH
implementations to be used, or the improved generic implementation if no
architecture-optimized implementation is usable.

Note: this means that <crypto/gcm.h> no longer needs to include
<crypto/gf128mul.h>.  Remove that inclusion, and include
<crypto/gf128mul.h> explicitly from arch/x86/crypto/aesni-intel_glue.c
which previously was relying on the transitive inclusion.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c |  1 +
 include/crypto/gcm.h               |  4 +--
 lib/crypto/Kconfig                 |  2 +-
 lib/crypto/aesgcm.c                | 55 +++++++++++++++---------------
 4 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e6c38d1d8a92..f522fff9231e 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -23,10 +23,11 @@
 #include <linux/err.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
+#include <crypto/gf128mul.h>
 #include <crypto/xts.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index b524e47bd4d0..1d5f39ff1dc4 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -2,11 +2,11 @@
 #define _CRYPTO_GCM_H
 
 #include <linux/errno.h>
 
 #include <crypto/aes.h>
-#include <crypto/gf128mul.h>
+#include <crypto/gf128hash.h>
 
 #define GCM_AES_IV_SIZE 12
 #define GCM_RFC4106_IV_SIZE 8
 #define GCM_RFC4543_IV_SIZE 8
 
@@ -63,11 +63,11 @@ static inline int crypto_ipsec_check_assoclen(unsigned int assoclen)
 
 	return 0;
 }
 
 struct aesgcm_ctx {
-	be128			ghash_key;
+	struct ghash_key	ghash_key;
 	struct aes_enckey	aes_key;
 	unsigned int		authsize;
 };
 
 int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index a39e7707e9ee..32fafe245f47 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -39,11 +39,11 @@ config CRYPTO_LIB_AES_CBC_MACS
 	  <crypto/aes-cbc-macs.h>.
 
 config CRYPTO_LIB_AESGCM
 	tristate
 	select CRYPTO_LIB_AES
-	select CRYPTO_LIB_GF128MUL
+	select CRYPTO_LIB_GF128HASH
 	select CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_ARC4
 	tristate
 
diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index 02f5b5f32c76..8c7e74d2d147 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -3,13 +3,12 @@
  * Minimal library implementation of GCM
  *
  * Copyright 2022 Google LLC
  */
 
-#include <crypto/algapi.h>
 #include <crypto/gcm.h>
-#include <crypto/ghash.h>
+#include <crypto/utils.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <asm/irqflags.h>
 
 static void aesgcm_encrypt_block(const struct aes_enckey *key, void *dst,
@@ -43,37 +42,26 @@ static void aesgcm_encrypt_block(const struct aes_enckey *key, void *dst,
  * that are not permitted by the GCM specification.
  */
 int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
 		     unsigned int keysize, unsigned int authsize)
 {
-	u8 kin[AES_BLOCK_SIZE] = {};
+	u8 h[AES_BLOCK_SIZE] = {};
 	int ret;
 
 	ret = crypto_gcm_check_authsize(authsize) ?:
 	      aes_prepareenckey(&ctx->aes_key, key, keysize);
 	if (ret)
 		return ret;
 
 	ctx->authsize = authsize;
-	aesgcm_encrypt_block(&ctx->aes_key, &ctx->ghash_key, kin);
-
+	aesgcm_encrypt_block(&ctx->aes_key, h, h);
+	ghash_preparekey(&ctx->ghash_key, h);
+	memzero_explicit(h, sizeof(h));
 	return 0;
 }
 EXPORT_SYMBOL(aesgcm_expandkey);
 
-static void aesgcm_ghash(be128 *ghash, const be128 *key, const void *src,
-			 int len)
-{
-	while (len > 0) {
-		crypto_xor((u8 *)ghash, src, min(len, GHASH_BLOCK_SIZE));
-		gf128mul_lle(ghash, key);
-
-		src += GHASH_BLOCK_SIZE;
-		len -= GHASH_BLOCK_SIZE;
-	}
-}
-
 /**
  * aesgcm_mac - Generates the authentication tag using AES-GCM algorithm.
  * @ctx: The data structure that will hold the AES-GCM key schedule
  * @src: The input source data.
  * @src_len: Length of the source data.
@@ -86,24 +74,37 @@ static void aesgcm_ghash(be128 *ghash, const be128 *key, const void *src,
  * and an output buffer for the authentication tag.
  */
 static void aesgcm_mac(const struct aesgcm_ctx *ctx, const u8 *src, int src_len,
 		       const u8 *assoc, int assoc_len, __be32 *ctr, u8 *authtag)
 {
-	be128 tail = { cpu_to_be64(assoc_len * 8), cpu_to_be64(src_len * 8) };
-	u8 buf[AES_BLOCK_SIZE];
-	be128 ghash = {};
+	static const u8 zeroes[GHASH_BLOCK_SIZE];
+	__be64 tail[2] = {
+		cpu_to_be64((u64)assoc_len * 8),
+		cpu_to_be64((u64)src_len * 8),
+	};
+	struct ghash_ctx ghash;
+	u8 ghash_out[AES_BLOCK_SIZE];
+	u8 enc_ctr[AES_BLOCK_SIZE];
+
+	ghash_init(&ghash, &ctx->ghash_key);
+
+	ghash_update(&ghash, assoc, assoc_len);
+	ghash_update(&ghash, zeroes, -assoc_len & (GHASH_BLOCK_SIZE - 1));
 
-	aesgcm_ghash(&ghash, &ctx->ghash_key, assoc, assoc_len);
-	aesgcm_ghash(&ghash, &ctx->ghash_key, src, src_len);
-	aesgcm_ghash(&ghash, &ctx->ghash_key, &tail, sizeof(tail));
+	ghash_update(&ghash, src, src_len);
+	ghash_update(&ghash, zeroes, -src_len & (GHASH_BLOCK_SIZE - 1));
+
+	ghash_update(&ghash, (const u8 *)&tail, sizeof(tail));
+
+	ghash_final(&ghash, ghash_out);
 
 	ctr[3] = cpu_to_be32(1);
-	aesgcm_encrypt_block(&ctx->aes_key, buf, ctr);
-	crypto_xor_cpy(authtag, buf, (u8 *)&ghash, ctx->authsize);
+	aesgcm_encrypt_block(&ctx->aes_key, enc_ctr, ctr);
+	crypto_xor_cpy(authtag, ghash_out, enc_ctr, ctx->authsize);
 
-	memzero_explicit(&ghash, sizeof(ghash));
-	memzero_explicit(buf, sizeof(buf));
+	memzero_explicit(ghash_out, sizeof(ghash_out));
+	memzero_explicit(enc_ctr, sizeof(enc_ctr));
 }
 
 static void aesgcm_crypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
 			 int len, __be32 *ctr)
 {
-- 
2.53.0

