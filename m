Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402531E2858
	for <linux-crypto@vger.kernel.org>; Thu, 31 Jul 2025 22:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754001445; cv=none; b=MK0zwD/LbNb5qMJy72tVPVsLJv4ZjowJmv1VbOt/dKNx/lKfOB6hT/FW+qNXGQWo+qHl7mCtB9XWGOYoEhQRMChtOetlOeyDm/s7YyGc3xUKLz3ubFtsTIjuGWZqfn9LGLoyID7uOlhVh9u1xXHR4NomMch7T30kg9prJXsXWAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754001445; c=relaxed/simple;
	bh=CauOauOILBwmnNP8cXVBP+lwt1iK/V6xZqh8kjU0UhY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KcniH1h0ai1RbrLm5zIsy/xmWKTdZODvG6Uln5UQ9OEpGaDjCg7IvtQK/I8XIrqIoknM+e+ureW2FDpdndUAp17yX3MrrG3XNiy667ay/5jYPbFQHVAHk7uBdfB8cE5OoFLwm5waoiVIQVz+N7PxQ7C72XVX43cxAcJSUcrmovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7+tEwTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7+tEwTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD620C4CEEF;
	Thu, 31 Jul 2025 22:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754001445;
	bh=CauOauOILBwmnNP8cXVBP+lwt1iK/V6xZqh8kjU0UhY=;
	h=From:To:Cc:Subject:Date:From;
	b=K7+tEwTjZMEZG8u1bUe43JKuXAPk8C7uvzSGis06SCONoivnAX+iU9vBG9VWKA6yo
	 76s7ibUlhEJf8FPGHfIYf3huexhfVdib84EEVgA9zW7/TtQ2Z6HPJIbES4n0GgHroW
	 8gduKeDV+TDV+2KgSbcA1IHCmJvOGhhEpankhj6//vxgD447Yq2pq0fggZd9z1L/ze
	 LNaQdiQQ/oo5xUy0bQDpNBsSSt1IxTltpspkzNi012n9NGvB4bNiCHXvelKTfcoU4r
	 HQVRt1o0Dy6cvTWhx8T5Kyi5qe9sDmFqfaZp9S0Mv+4MHEQpz3fnV7OiOmowZn2fBw
	 FUmtF3Mghm9qQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: sha512: Use underlying functions instead of crypto_simd_usable()
Date: Thu, 31 Jul 2025 15:36:51 -0700
Message-ID: <20250731223651.136939-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since sha512_kunit tests the fallback code paths without using
crypto_simd_disabled_for_test, make the SHA-512 code just use the
underlying may_use_simd() and irq_fpu_usable() functions directly
instead of crypto_simd_usable().  This eliminates an unnecessary layer.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/sha512.h   | 5 ++---
 lib/crypto/arm64/sha512.h | 5 ++---
 lib/crypto/riscv/sha512.h | 4 +---
 lib/crypto/x86/sha512.h   | 4 +---
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/lib/crypto/arm/sha512.h b/lib/crypto/arm/sha512.h
index f147b6490d6cd..cc2447acd5621 100644
--- a/lib/crypto/arm/sha512.h
+++ b/lib/crypto/arm/sha512.h
@@ -2,13 +2,12 @@
 /*
  * arm32-optimized SHA-512 block function
  *
  * Copyright 2025 Google LLC
  */
-
 #include <asm/neon.h>
-#include <crypto/internal/simd.h>
+#include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 asmlinkage void sha512_block_data_order(struct sha512_block_state *state,
 					const u8 *data, size_t nblocks);
@@ -17,11 +16,11 @@ asmlinkage void sha512_block_data_order_neon(struct sha512_block_state *state,
 
 static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && likely(crypto_simd_usable())) {
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		kernel_neon_begin();
 		sha512_block_data_order_neon(state, data, nblocks);
 		kernel_neon_end();
 	} else {
 		sha512_block_data_order(state, data, nblocks);
diff --git a/lib/crypto/arm64/sha512.h b/lib/crypto/arm64/sha512.h
index 6abb40b467f2e..7539ea3fef10d 100644
--- a/lib/crypto/arm64/sha512.h
+++ b/lib/crypto/arm64/sha512.h
@@ -2,13 +2,12 @@
 /*
  * arm64-optimized SHA-512 block function
  *
  * Copyright 2025 Google LLC
  */
-
 #include <asm/neon.h>
-#include <crypto/internal/simd.h>
+#include <asm/simd.h>
 #include <linux/cpufeature.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha512_insns);
 
 asmlinkage void sha512_block_data_order(struct sha512_block_state *state,
@@ -19,11 +18,11 @@ asmlinkage size_t __sha512_ce_transform(struct sha512_block_state *state,
 static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_sha512_insns) &&
-	    likely(crypto_simd_usable())) {
+	    likely(may_use_simd())) {
 		do {
 			size_t rem;
 
 			kernel_neon_begin();
 			rem = __sha512_ce_transform(state, data, nblocks);
diff --git a/lib/crypto/riscv/sha512.h b/lib/crypto/riscv/sha512.h
index 9d0abede322f7..59dc0294a9a7e 100644
--- a/lib/crypto/riscv/sha512.h
+++ b/lib/crypto/riscv/sha512.h
@@ -9,22 +9,20 @@
  * Author: Jerry Shih <jerry.shih@sifive.com>
  */
 
 #include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_extensions);
 
 asmlinkage void sha512_transform_zvknhb_zvkb(struct sha512_block_state *state,
 					     const u8 *data, size_t nblocks);
 
 static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_extensions) &&
-	    likely(crypto_simd_usable())) {
+	if (static_branch_likely(&have_extensions) && likely(may_use_simd())) {
 		kernel_vector_begin();
 		sha512_transform_zvknhb_zvkb(state, data, nblocks);
 		kernel_vector_end();
 	} else {
 		sha512_blocks_generic(state, data, nblocks);
diff --git a/lib/crypto/x86/sha512.h b/lib/crypto/x86/sha512.h
index c13503d9d57d9..be2c8fc122469 100644
--- a/lib/crypto/x86/sha512.h
+++ b/lib/crypto/x86/sha512.h
@@ -2,24 +2,22 @@
 /*
  * x86-optimized SHA-512 block function
  *
  * Copyright 2025 Google LLC
  */
-
 #include <asm/fpu/api.h>
-#include <crypto/internal/simd.h>
 #include <linux/static_call.h>
 
 DEFINE_STATIC_CALL(sha512_blocks_x86, sha512_blocks_generic);
 
 #define DEFINE_X86_SHA512_FN(c_fn, asm_fn)                                 \
 	asmlinkage void asm_fn(struct sha512_block_state *state,           \
 			       const u8 *data, size_t nblocks);            \
 	static void c_fn(struct sha512_block_state *state, const u8 *data, \
 			 size_t nblocks)                                   \
 	{                                                                  \
-		if (likely(crypto_simd_usable())) {                        \
+		if (likely(irq_fpu_usable())) {                            \
 			kernel_fpu_begin();                                \
 			asm_fn(state, data, nblocks);                      \
 			kernel_fpu_end();                                  \
 		} else {                                                   \
 			sha512_blocks_generic(state, data, nblocks);       \

base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1

