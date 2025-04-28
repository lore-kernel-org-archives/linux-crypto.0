Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AEA19E96A
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 04:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745816184; cv=none; b=ZAfBrjB1pujrxXWqqDXcaZQF6vN3U+/jDkh++vaKoS2DHnXNGKX1/MkY0JvbcrgMil8Xj638leNELBxOqX+/BXPQnKNMS+QXozCbEocpvUw/oNPlEouT+8/q8iSzf+Ih5kdONTLXT+r7SjD0qBVBdGb4uwVdzFsguMVgbWMTMFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745816184; c=relaxed/simple;
	bh=gFDaWU2hJrMuAwJEO+WZsrrmUC48ymN1Q2mpg6//LW8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bDjTjdrGMKTC381ZmJpLhauOjFKIRJovPp1jjr0iITRJUlwIdRnnbcAy+LOpj6ovIaYEyRXccy2s+8kmjODjTHG4VKHBylShm+wJ8q7m833WkJzxItWlr2xXKCdR6wODQH+ZG58Ft2rqMJMKacax/c1F8fQuv9i5Iz1dg2pgnwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XtFIu0E4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XtFIu0E4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UiYCkScihZICtMn0+xj8oA0rXCmJg83l75mteihl5jA=; b=XtFIu0E4xcEpzHXHy6C47zFD28
	G4JztWC1PRx2qCLkTLmXE8Ebm8u8oC+CzaEJ+BnXt7O92yLc6mUHhaDv4m4QO3XIs/uNvwwSbEDA1
	JOka0ZbrsD9QRG+EhVOs7iidDgkhZct5M0umI/CejdGHpcm7ky9O53Hdaf1zWp2b3CyXrYRkjK8WE
	suTnuGPZZ67PROXvpxJoajvyZvo+0tRWdKb+h8Bd63Q6HnCJ6MDlMqWhgYBY9S9/tPX6F6ABWf/4L
	xIfK65pGFzBb9cpoUvHBwzaDVybd/X/FJPRfG5KCjglikQ7rO6432i0ReYH+sQewQ76Vrb9VAxL0A
	tt9qER5Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9GXS-001WFo-2q;
	Mon, 28 Apr 2025 12:56:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 12:56:18 +0800
Date: Mon, 28 Apr 2025 12:56:18 +0800
Message-Id: <1b73e8066d6f37a5b1ae332e9ab354ea3ba35de4.1745815528.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745815528.git.herbert@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 07/11] crypto: x86/poly1305 - Add block-only interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add block-only interface.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 .../lib/crypto/poly1305-x86_64-cryptogams.pl  |  33 +++--
 arch/x86/lib/crypto/poly1305_glue.c           | 125 +++++++-----------
 2 files changed, 71 insertions(+), 87 deletions(-)

diff --git a/arch/x86/lib/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/lib/crypto/poly1305-x86_64-cryptogams.pl
index 409ec6955733..501827254fed 100644
--- a/arch/x86/lib/crypto/poly1305-x86_64-cryptogams.pl
+++ b/arch/x86/lib/crypto/poly1305-x86_64-cryptogams.pl
@@ -118,6 +118,19 @@ sub declare_function() {
 	}
 }
 
+sub declare_typed_function() {
+	my ($name, $align, $nargs) = @_;
+	if($kernel) {
+		$code .= "SYM_TYPED_FUNC_START($name)\n";
+		$code .= ".L$name:\n";
+	} else {
+		$code .= ".globl	$name\n";
+		$code .= ".type	$name,\@function,$nargs\n";
+		$code .= ".align	$align\n";
+		$code .= "$name:\n";
+	}
+}
+
 sub end_function() {
 	my ($name) = @_;
 	if($kernel) {
@@ -128,7 +141,7 @@ sub end_function() {
 }
 
 $code.=<<___ if $kernel;
-#include <linux/linkage.h>
+#include <linux/cfi_types.h>
 ___
 
 if ($avx) {
@@ -236,14 +249,14 @@ ___
 $code.=<<___ if (!$kernel);
 .extern	OPENSSL_ia32cap_P
 
-.globl	poly1305_init_x86_64
-.hidden	poly1305_init_x86_64
+.globl	poly1305_block_init_arch
+.hidden	poly1305_block_init_arch
 .globl	poly1305_blocks_x86_64
 .hidden	poly1305_blocks_x86_64
 .globl	poly1305_emit_x86_64
 .hidden	poly1305_emit_x86_64
 ___
-&declare_function("poly1305_init_x86_64", 32, 3);
+&declare_typed_function("poly1305_block_init_arch", 32, 3);
 $code.=<<___;
 	xor	%eax,%eax
 	mov	%rax,0($ctx)		# initialize hash value
@@ -298,7 +311,7 @@ $code.=<<___;
 .Lno_key:
 	RET
 ___
-&end_function("poly1305_init_x86_64");
+&end_function("poly1305_block_init_arch");
 
 &declare_function("poly1305_blocks_x86_64", 32, 4);
 $code.=<<___;
@@ -4105,9 +4118,9 @@ avx_handler:
 
 .section	.pdata
 .align	4
-	.rva	.LSEH_begin_poly1305_init_x86_64
-	.rva	.LSEH_end_poly1305_init_x86_64
-	.rva	.LSEH_info_poly1305_init_x86_64
+	.rva	.LSEH_begin_poly1305_block_init_arch
+	.rva	.LSEH_end_poly1305_block_init_arch
+	.rva	.LSEH_info_poly1305_block_init_arch
 
 	.rva	.LSEH_begin_poly1305_blocks_x86_64
 	.rva	.LSEH_end_poly1305_blocks_x86_64
@@ -4155,10 +4168,10 @@ ___
 $code.=<<___;
 .section	.xdata
 .align	8
-.LSEH_info_poly1305_init_x86_64:
+.LSEH_info_poly1305_block_init_arch:
 	.byte	9,0,0,0
 	.rva	se_handler
-	.rva	.LSEH_begin_poly1305_init_x86_64,.LSEH_begin_poly1305_init_x86_64
+	.rva	.LSEH_begin_poly1305_block_init_arch,.LSEH_begin_poly1305_block_init_arch
 
 .LSEH_info_poly1305_blocks_x86_64:
 	.byte	9,0,0,0
diff --git a/arch/x86/lib/crypto/poly1305_glue.c b/arch/x86/lib/crypto/poly1305_glue.c
index cff35ca5822a..d98764ec3b47 100644
--- a/arch/x86/lib/crypto/poly1305_glue.c
+++ b/arch/x86/lib/crypto/poly1305_glue.c
@@ -3,34 +3,15 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#include <crypto/internal/simd.h>
-#include <crypto/poly1305.h>
+#include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
+#include <crypto/internal/poly1305.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
-#include <asm/cpu_device_id.h>
-#include <asm/simd.h>
-
-asmlinkage void poly1305_init_x86_64(void *ctx,
-				     const u8 key[POLY1305_BLOCK_SIZE]);
-asmlinkage void poly1305_blocks_x86_64(void *ctx, const u8 *inp,
-				       const size_t len, const u32 padbit);
-asmlinkage void poly1305_emit_x86_64(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
-				     const u32 nonce[4]);
-asmlinkage void poly1305_emit_avx(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
-				  const u32 nonce[4]);
-asmlinkage void poly1305_blocks_avx(void *ctx, const u8 *inp, const size_t len,
-				    const u32 padbit);
-asmlinkage void poly1305_blocks_avx2(void *ctx, const u8 *inp, const size_t len,
-				     const u32 padbit);
-asmlinkage void poly1305_blocks_avx512(void *ctx, const u8 *inp,
-				       const size_t len, const u32 padbit);
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx);
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx2);
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx512);
 
 struct poly1305_arch_internal {
 	union {
@@ -45,64 +26,50 @@ struct poly1305_arch_internal {
 	struct { u32 r2, r1, r4, r3; } rn[9];
 };
 
-/* The AVX code uses base 2^26, while the scalar code uses base 2^64. If we hit
- * the unfortunate situation of using AVX and then having to go back to scalar
- * -- because the user is silly and has called the update function from two
- * separate contexts -- then we need to convert back to the original base before
- * proceeding. It is possible to reason that the initial reduction below is
- * sufficient given the implementation invariants. However, for an avoidance of
- * doubt and because this is not performance critical, we do the full reduction
- * anyway. Z3 proof of below function: https://xn--4db.cc/ltPtHCKN/py
- */
-static void convert_to_base2_64(void *ctx)
+asmlinkage void poly1305_block_init_arch(
+	struct poly1305_block_state *state,
+	const u8 raw_key[POLY1305_BLOCK_SIZE]);
+EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
+asmlinkage void poly1305_blocks_x86_64(struct poly1305_arch_internal *ctx,
+				       const u8 *inp,
+				       const size_t len, const u32 padbit);
+asmlinkage void poly1305_emit_x86_64(const struct poly1305_state *ctx,
+				     u8 mac[POLY1305_DIGEST_SIZE],
+				     const u32 nonce[4]);
+asmlinkage void poly1305_emit_avx(const struct poly1305_state *ctx,
+				  u8 mac[POLY1305_DIGEST_SIZE],
+				  const u32 nonce[4]);
+asmlinkage void poly1305_blocks_avx(struct poly1305_arch_internal *ctx,
+				    const u8 *inp, const size_t len,
+				    const u32 padbit);
+asmlinkage void poly1305_blocks_avx2(struct poly1305_arch_internal *ctx,
+				     const u8 *inp, const size_t len,
+				     const u32 padbit);
+asmlinkage void poly1305_blocks_avx512(struct poly1305_arch_internal *ctx,
+				       const u8 *inp,
+				       const size_t len, const u32 padbit);
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx2);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx512);
+
+void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *inp,
+			  unsigned int len, u32 padbit)
 {
-	struct poly1305_arch_internal *state = ctx;
-	u32 cy;
-
-	if (!state->is_base2_26)
-		return;
-
-	cy = state->h[0] >> 26; state->h[0] &= 0x3ffffff; state->h[1] += cy;
-	cy = state->h[1] >> 26; state->h[1] &= 0x3ffffff; state->h[2] += cy;
-	cy = state->h[2] >> 26; state->h[2] &= 0x3ffffff; state->h[3] += cy;
-	cy = state->h[3] >> 26; state->h[3] &= 0x3ffffff; state->h[4] += cy;
-	state->hs[0] = ((u64)state->h[2] << 52) | ((u64)state->h[1] << 26) | state->h[0];
-	state->hs[1] = ((u64)state->h[4] << 40) | ((u64)state->h[3] << 14) | (state->h[2] >> 12);
-	state->hs[2] = state->h[4] >> 24;
-#define ULT(a, b) ((a ^ ((a ^ b) | ((a - b) ^ b))) >> (sizeof(a) * 8 - 1))
-	cy = (state->hs[2] >> 2) + (state->hs[2] & ~3ULL);
-	state->hs[2] &= 3;
-	state->hs[0] += cy;
-	state->hs[1] += (cy = ULT(state->hs[0], cy));
-	state->hs[2] += ULT(state->hs[1], cy);
-#undef ULT
-	state->is_base2_26 = 0;
-}
-
-static void poly1305_simd_init(void *ctx, const u8 key[POLY1305_BLOCK_SIZE])
-{
-	poly1305_init_x86_64(ctx, key);
-}
-
-static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
-				 const u32 padbit)
-{
-	struct poly1305_arch_internal *state = ctx;
+	struct poly1305_arch_internal *ctx =
+		container_of(&state->h.h, struct poly1305_arch_internal, h);
 
 	/* SIMD disables preemption, so relax after processing each page. */
 	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
 		     SZ_4K % POLY1305_BLOCK_SIZE);
 
-	if (!static_branch_likely(&poly1305_use_avx) ||
-	    (len < (POLY1305_BLOCK_SIZE * 18) && !state->is_base2_26) ||
-	    !crypto_simd_usable()) {
-		convert_to_base2_64(ctx);
+	if (!static_branch_likely(&poly1305_use_avx)) {
 		poly1305_blocks_x86_64(ctx, inp, len, padbit);
 		return;
 	}
 
 	do {
-		const size_t bytes = min_t(size_t, len, SZ_4K);
+		const unsigned int bytes = min(len, SZ_4K);
 
 		kernel_fpu_begin();
 		if (static_branch_likely(&poly1305_use_avx512))
@@ -117,24 +84,26 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
 		inp += bytes;
 	} while (len);
 }
+EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
-static void poly1305_simd_emit(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
-			       const u32 nonce[4])
+void poly1305_emit_arch(const struct poly1305_state *ctx,
+			u8 mac[POLY1305_DIGEST_SIZE], const u32 nonce[4])
 {
 	if (!static_branch_likely(&poly1305_use_avx))
 		poly1305_emit_x86_64(ctx, mac, nonce);
 	else
 		poly1305_emit_avx(ctx, mac, nonce);
 }
+EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
 void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
-	poly1305_simd_init(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(&key[16]);
 	dctx->s[1] = get_unaligned_le32(&key[20]);
 	dctx->s[2] = get_unaligned_le32(&key[24]);
 	dctx->s[3] = get_unaligned_le32(&key[28]);
 	dctx->buflen = 0;
+	poly1305_block_init_arch(&dctx->state, key);
 }
 EXPORT_SYMBOL(poly1305_init_arch);
 
@@ -151,14 +120,15 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_simd_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 1);
+			poly1305_blocks_arch(&dctx->state, dctx->buf,
+					     POLY1305_BLOCK_SIZE, 1);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
 		bytes = round_down(srclen, POLY1305_BLOCK_SIZE);
-		poly1305_simd_blocks(&dctx->h, src, bytes, 1);
+		poly1305_blocks_arch(&dctx->state, src, bytes, 1);
 		src += bytes;
 		srclen -= bytes;
 	}
@@ -176,10 +146,11 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_simd_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+		poly1305_blocks_arch(&dctx->state, dctx->buf,
+				     POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_simd_emit(&dctx->h, dst, dctx->s);
+	poly1305_emit_arch(&dctx->h, dst, dctx->s);
 	memzero_explicit(dctx, sizeof(*dctx));
 }
 EXPORT_SYMBOL(poly1305_final_arch);
-- 
2.39.5

