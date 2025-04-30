Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F381D95A3
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993184; cv=none; b=gMXxvtWbntocvi4vUvenRVjoW0XkSn4SJd7h+YiglZVc+YdO9nGRgTg81N5F/6T6dEAPbXOg3q406ImlnLv5l6eiAQfjxH5PjVw7aAD9HScV2DpGEuot/hTYlpqmJPyEFT3qouLh5mI4JAs5/5EXUT2RGu0sebsQX4gSkeebfmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993184; c=relaxed/simple;
	bh=9UIOq+ac6pxWoS9B4Jv0OywJ32PS3/IvIvRs3bH/P2s=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bXCs6S3uEmdYilsrSXgM4P4Jy3ZI7NvrGOcM+IQywtDTzhHT715k5WGEuqLgsviVMozDyMp0RG/guo3vOoBoUZGSFYBIDFE0IU7O2CVJhZjOT09nG9FM8k80VcVUPdr4qgot4pDLqH8sEaRGOHaUyhgtrhCed8ZE+xDY9Vk7gGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZjnQ416p; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZjnQ416p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BQZ/Y9Cq9/ryGXITQ22xMruO1O/zDrScV3+eGc7HWAI=; b=ZjnQ416piqhYEb6ArRvHEZ9nex
	hLDaqbE240O4vHOGJ271S13gPC3N0jsxbY76jpuaYDrikyKyAD2LJGQ6TkgFvWPEULe8+Ax8QG1Fq
	H3AhvvgIiC9y5GyrUP6o8Ae+ggWrKs2KuhXlrOuXiuyweIKCVLecincjJqWP9e2N3YbfLzzQDiUWZ
	Y105diHglGx0IGkIRDnyXTpWzwmLhTVxJU1rxR+evtql3Lfj5ChpTfZXfyylOHlhCbV81FV0WqGb9
	LGSTbRvEkTeE/DjP03hx4E26NBN3oMuMudG6eMImar9SR9M8H0T28IdBvBFDFzK4poxuU4ZtDeY77
	HVrPLJQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aH-002AZg-1d;
	Wed, 30 Apr 2025 14:06:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:17 +0800
Date: Wed, 30 Apr 2025 14:06:17 +0800
Message-Id: <180c234abda77dac2a792c524f573e73b7404b0a.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 01/12] crypto: lib/sha256 - Restore lib_sha256 finup code
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The previous lib_sha256 finup code can process two blocks if needed,
restore it and put it into the sha256_finup helper so it can be
reused by the Crypto API.

Also add sha256_choose_blocks and CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
so that the Crypto API can use the SIMD block function unconditionally.
The Crypto API must not be used in hard IRQs and there is no reason
to have a fallback path for hardirqs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/sha2.h | 46 ++++++++++++++++++++++++++++++++++
 lib/crypto/Kconfig             |  8 ++++++
 lib/crypto/sha256.c            | 35 ++++++++------------------
 3 files changed, 65 insertions(+), 24 deletions(-)

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index d641c67abcbc..07e41efc6cc6 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -3,7 +3,11 @@
 #ifndef _CRYPTO_INTERNAL_SHA2_H
 #define _CRYPTO_INTERNAL_SHA2_H
 
+#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/unaligned.h>
 
 void sha256_update_generic(struct sha256_state *sctx,
 			   const u8 *data, size_t len);
@@ -24,5 +28,47 @@ void sha256_blocks_generic(u32 state[SHA256_STATE_WORDS],
 			   const u8 *data, size_t nblocks);
 void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks);
+void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
+			const u8 *data, size_t nblocks);
+
+static inline void sha256_choose_blocks(
+	u32 state[SHA256_STATE_WORDS], const u8 *data, size_t nblocks,
+	bool force_generic, bool force_simd)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) || force_generic)
+		sha256_blocks_generic(state, data, nblocks);
+	else if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD) &&
+		 (force_simd || crypto_simd_usable()))
+		sha256_blocks_simd(state, data, nblocks);
+	else
+		sha256_blocks_arch(state, data, nblocks);
+}
+
+static __always_inline void sha256_finup(
+	struct crypto_sha256_state *sctx, const u8 *src, unsigned int len,
+	u8 out[SHA256_DIGEST_SIZE], size_t digest_size, bool force_generic,
+	bool force_simd)
+{
+	unsigned int bit_offset = SHA256_BLOCK_SIZE / 8 - 1;
+	union {
+		__be64 b64[SHA256_BLOCK_SIZE / 4];
+		u8 u8[SHA256_BLOCK_SIZE * 2];
+	} block = {};
+	int blocks, i;
+
+	sctx->count += len;
+	if (len >= bit_offset * 8)
+		bit_offset += SHA256_BLOCK_SIZE / 8;
+	blocks = (bit_offset + 1) * 8 / SHA256_BLOCK_SIZE;
+	memcpy(&block, src, len);
+	block.u8[len] = 0x80;
+	block.b64[bit_offset] = cpu_to_be64(sctx->count << 3);
+	sha256_choose_blocks(sctx->state, block.u8, blocks, force_generic,
+			     force_simd);
+	memzero_explicit(&block, sizeof(block));
+
+	for (i = 0; i < digest_size; i += 4)
+		put_unaligned_be32(sctx->state[i / 4], out + i);
+}
 
 #endif /* _CRYPTO_INTERNAL_SHA2_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 6319358b38c2..1ec1466108cc 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -150,6 +150,14 @@ config CRYPTO_ARCH_HAVE_LIB_SHA256
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the SHA-256 library interface.
 
+config CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
+	bool
+	help
+	  Declares whether the architecture provides an arch-specific
+	  accelerated implementation of the SHA-256 library interface
+	  that is SIMD-based and therefore not usable in hardirq
+	  context.
+
 config CRYPTO_LIB_SHA256_GENERIC
 	tristate
 	default CRYPTO_LIB_SHA256 if !CRYPTO_ARCH_HAVE_LIB_SHA256
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 563f09c9f381..b5ffff032718 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 
 /*
  * If __DISABLE_EXPORTS is defined, then this file is being compiled for a
@@ -26,14 +25,16 @@
 #include "sha256-generic.c"
 #endif
 
+static inline bool sha256_purgatory(void)
+{
+	return __is_defined(__DISABLE_EXPORTS);
+}
+
 static inline void sha256_blocks(u32 state[SHA256_STATE_WORDS], const u8 *data,
 				 size_t nblocks, bool force_generic)
 {
-#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) && !defined(__DISABLE_EXPORTS)
-	if (!force_generic)
-		return sha256_blocks_arch(state, data, nblocks);
-#endif
-	sha256_blocks_generic(state, data, nblocks);
+	sha256_choose_blocks(state, data, nblocks,
+			     force_generic || sha256_purgatory(), false);
 }
 
 static inline void __sha256_update(struct sha256_state *sctx, const u8 *data,
@@ -79,25 +80,11 @@ EXPORT_SYMBOL(sha256_update);
 static inline void __sha256_final(struct sha256_state *sctx, u8 *out,
 				  size_t digest_size, bool force_generic)
 {
-	const size_t bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
-	__be64 *bits = (__be64 *)&sctx->buf[bit_offset];
-	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
-	size_t i;
-
-	sctx->buf[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(&sctx->buf[partial], 0, SHA256_BLOCK_SIZE - partial);
-		sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
-		partial = 0;
-	}
-
-	memset(&sctx->buf[partial], 0, bit_offset - partial);
-	*bits = cpu_to_be64(sctx->count << 3);
-	sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
-
-	for (i = 0; i < digest_size; i += 4)
-		put_unaligned_be32(sctx->state[i / 4], out + i);
+	unsigned int len = sctx->count % SHA256_BLOCK_SIZE;
 
+	sctx->count -= len;
+	sha256_finup(&sctx->ctx, sctx->buf, len, out, digest_size,
+		     force_generic || sha256_purgatory(), false);
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 
-- 
2.39.5

