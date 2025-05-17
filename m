Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB0017B418;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448718; cv=none; b=M0EncSOzbnu7dUf3llKRof2x10UZJNLouQxyDJUqbtOSgHvh8jgXoF+dZ7RhW9S3UsWYmAcOknVc6RqWn1JUQsTRM7uvnEzfOqGeNIeIPwAbqL21nCJaGqoA5wFSmfoeaLbaXVbj4LRrznwyPwYkSgJhPeBZF65JdDuL8xjS9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448718; c=relaxed/simple;
	bh=zFcS6uR/dj+Xz3GyEef0LushmVtjQgiIhaKrPjHNxPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Spo12R7tcGjS9EEt3TMg2FPqyizEy2Xs8aPc3nFDOv0UqxDLgpUSEbZOtMtP6vI2zt3WYcIWt+hbxcsetaBpu1g6hEhHIdTOQLAPP8UgtP7v1v596iirjgHfYpO6fvQJ0/a8Lc27WHmD4JslTbNuB47PRle1k/ov1tlgOVZFyA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjk/HbXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjk/HbXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A797C4CEF0;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448718;
	bh=zFcS6uR/dj+Xz3GyEef0LushmVtjQgiIhaKrPjHNxPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjk/HbXwyKzKwudbiPupxPDvIRdSBB13izcj3mHKpTZT6+6ZmDrbq4MZ67OEgsPXG
	 U/9sDvGp7gvd2laSlHF+RvBOiFpVanpmbNaiMql+BwVGw1+HoYXflCrHY5smrSXsF6
	 OkqPCiX7qGwmEsAUogDDse6GXoit8QrTVCJNgOjx3FPfhTFYxkxPyiy/b5sB9tCSIQ
	 Bo+LM/QyojDUhCvLGZ0acrbP/DtTZFM2/LTj5a2movkrAWgypEDO28e2e+92JIBGIs
	 0r93ikIEKBQXjvKnaF5CwTRAkZtDGb3gubz9XwuiThTQoG9mTugaTK9V5jPIMo9QEZ
	 EVdUA+fvsOSQw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Revert "crypto: lib/sha256 - Add helpers for block-based shash"
Date: Fri, 16 May 2025 19:24:28 -0700
Message-ID: <20250517022428.401622-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517022428.401622-1-ebiggers@kernel.org>
References: <20250517022428.401622-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This reverts commit 5b90a779bc547939421bfeb333e470658ba94fb6 which got
pushed out despite being nacked.

That commit added a special low-level interface to allow the
crypto_shash API to bypass the safety check for using vector or SIMD
registers.  It could give a marginal performance benefit for
crypto_shash, but just is not worth the complexity and footgun.
Moreover, the distinction between "arch" and "simd" is confusing and is
not something that really should exist in generic code, given that
different architectures can mean different things by "simd".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/sha2.h | 45 ----------------------------------
 lib/crypto/Kconfig             |  8 ------
 lib/crypto/sha256.c            | 32 +++++++++++++++++-------
 3 files changed, 23 insertions(+), 62 deletions(-)

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index fff156f66edc3..d641c67abcbc3 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -1,16 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 
 #ifndef _CRYPTO_INTERNAL_SHA2_H
 #define _CRYPTO_INTERNAL_SHA2_H
 
-#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
-#include <linux/compiler_attributes.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/unaligned.h>
 
 void sha256_update_generic(struct sha256_state *sctx,
 			   const u8 *data, size_t len);
 void sha256_final_generic(struct sha256_state *sctx,
 			  u8 out[SHA256_DIGEST_SIZE]);
@@ -27,47 +22,7 @@ static inline bool sha256_is_arch_optimized(void)
 #endif
 void sha256_blocks_generic(u32 state[SHA256_STATE_WORDS],
 			   const u8 *data, size_t nblocks);
 void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks);
-void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
-			const u8 *data, size_t nblocks);
-
-static inline void sha256_choose_blocks(
-	u32 state[SHA256_STATE_WORDS], const u8 *data, size_t nblocks,
-	bool force_generic, bool force_simd)
-{
-	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) || force_generic)
-		sha256_blocks_generic(state, data, nblocks);
-	else if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD) &&
-		 (force_simd || crypto_simd_usable()))
-		sha256_blocks_simd(state, data, nblocks);
-	else
-		sha256_blocks_arch(state, data, nblocks);
-}
-
-static __always_inline void sha256_finup(
-	struct crypto_sha256_state *sctx, u8 buf[SHA256_BLOCK_SIZE],
-	size_t len, u8 out[SHA256_DIGEST_SIZE], size_t digest_size,
-	bool force_generic, bool force_simd)
-{
-	const size_t bit_offset = SHA256_BLOCK_SIZE - 8;
-	__be64 *bits = (__be64 *)&buf[bit_offset];
-	int i;
-
-	buf[len++] = 0x80;
-	if (len > bit_offset) {
-		memset(&buf[len], 0, SHA256_BLOCK_SIZE - len);
-		sha256_choose_blocks(sctx->state, buf, 1, force_generic,
-				     force_simd);
-		len = 0;
-	}
-
-	memset(&buf[len], 0, bit_offset - len);
-	*bits = cpu_to_be64(sctx->count << 3);
-	sha256_choose_blocks(sctx->state, buf, 1, force_generic, force_simd);
-
-	for (i = 0; i < digest_size; i += 4)
-		put_unaligned_be32(sctx->state[i / 4], out + i);
-}
 
 #endif /* _CRYPTO_INTERNAL_SHA2_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 1ec1466108ccd..6319358b38c20 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -148,18 +148,10 @@ config CRYPTO_ARCH_HAVE_LIB_SHA256
 	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the SHA-256 library interface.
 
-config CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
-	bool
-	help
-	  Declares whether the architecture provides an arch-specific
-	  accelerated implementation of the SHA-256 library interface
-	  that is SIMD-based and therefore not usable in hardirq
-	  context.
-
 config CRYPTO_LIB_SHA256_GENERIC
 	tristate
 	default CRYPTO_LIB_SHA256 if !CRYPTO_ARCH_HAVE_LIB_SHA256
 	help
 	  This symbol can be selected by arch implementations of the SHA-256
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 2ced29efa181c..563f09c9f3815 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -13,30 +13,29 @@
 
 #include <crypto/internal/sha2.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/unaligned.h>
 
 /*
  * If __DISABLE_EXPORTS is defined, then this file is being compiled for a
  * pre-boot environment.  In that case, ignore the kconfig options, pull the
  * generic code into the same translation unit, and use that only.
  */
 #ifdef __DISABLE_EXPORTS
 #include "sha256-generic.c"
 #endif
 
-static inline bool sha256_purgatory(void)
-{
-	return __is_defined(__DISABLE_EXPORTS);
-}
-
 static inline void sha256_blocks(u32 state[SHA256_STATE_WORDS], const u8 *data,
 				 size_t nblocks, bool force_generic)
 {
-	sha256_choose_blocks(state, data, nblocks,
-			     force_generic || sha256_purgatory(), false);
+#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) && !defined(__DISABLE_EXPORTS)
+	if (!force_generic)
+		return sha256_blocks_arch(state, data, nblocks);
+#endif
+	sha256_blocks_generic(state, data, nblocks);
 }
 
 static inline void __sha256_update(struct sha256_state *sctx, const u8 *data,
 				   size_t len, bool force_generic)
 {
@@ -78,14 +77,29 @@ void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len)
 EXPORT_SYMBOL(sha256_update);
 
 static inline void __sha256_final(struct sha256_state *sctx, u8 *out,
 				  size_t digest_size, bool force_generic)
 {
+	const size_t bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
+	__be64 *bits = (__be64 *)&sctx->buf[bit_offset];
 	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
+	size_t i;
+
+	sctx->buf[partial++] = 0x80;
+	if (partial > bit_offset) {
+		memset(&sctx->buf[partial], 0, SHA256_BLOCK_SIZE - partial);
+		sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
+		partial = 0;
+	}
+
+	memset(&sctx->buf[partial], 0, bit_offset - partial);
+	*bits = cpu_to_be64(sctx->count << 3);
+	sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
+
+	for (i = 0; i < digest_size; i += 4)
+		put_unaligned_be32(sctx->state[i / 4], out + i);
 
-	sha256_finup(&sctx->ctx, sctx->buf, partial, out, digest_size,
-		     force_generic || sha256_purgatory(), false);
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 
 void sha256_final(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
 {
-- 
2.49.0

