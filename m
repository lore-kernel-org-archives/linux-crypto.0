Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBBC1917D6;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448719; cv=none; b=Mhsdr1f2i0ICmeM1Cj1S7nKeUSrgDxVpMI0w8FyBR7LAyWIImsXI+JnHi0AHUSu4beicLNCQdzIVzn8MS4hTFGRHtXRUeSm+SI7MN9yh07nw7F7SepuN5rYPVlB9D8PNd9raQVscdqo6uizmxsqOfwfH8eubj14GLiVDhqrEEBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448719; c=relaxed/simple;
	bh=XXmV0q88v0oxfMFM0WBoheMAne6q7Vmr/cC9Ycy/h/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBRSknrUSM9IRCCNTqvkRfvc8f/sV7CXwOpGkKx/IW+RS/e1lQzUpfLGDHF32K3+hF05ocJ4Q+R0hD+P5Pmx+UU0nJqgYBYLRlB2FzTlh3BKe37HiqcFr64uhop1A1/nWCsQpNm2yUnzBqAoXW6cehyOg9/aBib8iPaYhTDM+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbsDb+Ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbsDb+Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2366DC4CEF7;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448718;
	bh=XXmV0q88v0oxfMFM0WBoheMAne6q7Vmr/cC9Ycy/h/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbsDb+EyeGdD5IFUZxcSfeMjmMFLVf9z4vgyaYEOeoRZ0CwE/Kdn759lTNGuYS+MO
	 x7GPcQE+IRTj55Q8xPdTruecGzcITYbdcBgwEcNiGiRGwHiYce0zFawqqTNADwPeDl
	 KF12WMTAMLj4dwQWXAbJnEdoTIVBCpOcglrAiTxSzUUA0am3m850hCY0SVJgU5S6cS
	 HnnXkkR3j+pxyyQK7KQvnPbuSprX9WVPQTvDQ25srEBFY7M2wEIDRnAdW0+KwiP6fT
	 hUvfxt/S1ukmCwWQxsGEYa/I1w24KcnYGpcYk0x5O5OV/jNpjwgjq1NIPnZyIcvjOp
	 3g4cBAJkdaV4Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Revert "crypto: arm/sha256 - Add simd block function"
Date: Fri, 16 May 2025 19:24:26 -0700
Message-ID: <20250517022428.401622-7-ebiggers@kernel.org>
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

This reverts commit 2e43fc6d79cb24e0fe34aa4c2229ab6c414d852a which got
pushed out despite being nacked.

That commit added a special low-level interface to allow the
crypto_shash API to bypass the safety check for using kernel-mode NEON.
It could give a marginal performance benefit for crypto_shash, but just
is not worth the complexity and footgun.  Moreover, the distinction
between "arch" and "simd" is confusing and is not something that really
should exist in generic code, given that different architectures can
mean different things by "simd".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/lib/crypto/Kconfig         |  1 -
 arch/arm/lib/crypto/sha256-armv4.pl | 20 ++++++++++----------
 arch/arm/lib/crypto/sha256.c        | 14 +++++++-------
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm/lib/crypto/Kconfig b/arch/arm/lib/crypto/Kconfig
index d1ad664f0c674..9f3ff30f40328 100644
--- a/arch/arm/lib/crypto/Kconfig
+++ b/arch/arm/lib/crypto/Kconfig
@@ -26,6 +26,5 @@ config CRYPTO_POLY1305_ARM
 config CRYPTO_SHA256_ARM
 	tristate
 	depends on !CPU_V7M
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
-	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
diff --git a/arch/arm/lib/crypto/sha256-armv4.pl b/arch/arm/lib/crypto/sha256-armv4.pl
index 8122db7fd5990..f3a2b54efd4ee 100644
--- a/arch/arm/lib/crypto/sha256-armv4.pl
+++ b/arch/arm/lib/crypto/sha256-armv4.pl
@@ -202,22 +202,22 @@ K256:
 .word	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
 .size	K256,.-K256
 .word	0				@ terminator
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 .LOPENSSL_armcap:
-.word	OPENSSL_armcap_P-sha256_blocks_arch
+.word	OPENSSL_armcap_P-sha256_block_data_order
 #endif
 .align	5
 
-.global	sha256_blocks_arch
-.type	sha256_blocks_arch,%function
-sha256_blocks_arch:
-.Lsha256_blocks_arch:
+.global	sha256_block_data_order
+.type	sha256_block_data_order,%function
+sha256_block_data_order:
+.Lsha256_block_data_order:
 #if __ARM_ARCH__<7
-	sub	r3,pc,#8		@ sha256_blocks_arch
+	sub	r3,pc,#8		@ sha256_block_data_order
 #else
-	adr	r3,.Lsha256_blocks_arch
+	adr	r3,.Lsha256_block_data_order
 #endif
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 	ldr	r12,.LOPENSSL_armcap
 	ldr	r12,[r3,r12]		@ OPENSSL_armcap_P
 	tst	r12,#ARMV8_SHA256
@@ -280,11 +280,11 @@ $code.=<<___;
 	ldmia	sp!,{r4-r11,lr}
 	tst	lr,#1
 	moveq	pc,lr			@ be binary compatible with V4, yet
 	bx	lr			@ interoperable with Thumb ISA:-)
 #endif
-.size	sha256_blocks_arch,.-sha256_blocks_arch
+.size	sha256_block_data_order,.-sha256_block_data_order
 ___
 ######################################################################
 # NEON stuff
 #
 {{{
@@ -468,12 +468,12 @@ $code.=<<___;
 sha256_block_data_order_neon:
 .LNEON:
 	stmdb	sp!,{r4-r12,lr}
 
 	sub	$H,sp,#16*4+16
-	adr	$Ktbl,.Lsha256_blocks_arch
-	sub	$Ktbl,$Ktbl,#.Lsha256_blocks_arch-K256
+	adr	$Ktbl,.Lsha256_block_data_order
+	sub	$Ktbl,$Ktbl,#.Lsha256_block_data_order-K256
 	bic	$H,$H,#15		@ align for 128-bit stores
 	mov	$t2,sp
 	mov	sp,$H			@ alloca
 	add	$len,$inp,$len,lsl#6	@ len to point at the end of inp
 
diff --git a/arch/arm/lib/crypto/sha256.c b/arch/arm/lib/crypto/sha256.c
index 109192e54b0f0..2c9cfdaaa0691 100644
--- a/arch/arm/lib/crypto/sha256.c
+++ b/arch/arm/lib/crypto/sha256.c
@@ -4,40 +4,40 @@
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/neon.h>
 #include <crypto/internal/sha2.h>
+#include <crypto/internal/simd.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-asmlinkage void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
-				   const u8 *data, size_t nblocks);
-EXPORT_SYMBOL_GPL(sha256_blocks_arch);
+asmlinkage void sha256_block_data_order(u32 state[SHA256_STATE_WORDS],
+					const u8 *data, size_t nblocks);
 asmlinkage void sha256_block_data_order_neon(u32 state[SHA256_STATE_WORDS],
 					     const u8 *data, size_t nblocks);
 asmlinkage void sha256_ce_transform(u32 state[SHA256_STATE_WORDS],
 				    const u8 *data, size_t nblocks);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
 
-void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon)) {
+	    static_branch_likely(&have_neon) && crypto_simd_usable()) {
 		kernel_neon_begin();
 		if (static_branch_likely(&have_ce))
 			sha256_ce_transform(state, data, nblocks);
 		else
 			sha256_block_data_order_neon(state, data, nblocks);
 		kernel_neon_end();
 	} else {
-		sha256_blocks_arch(state, data, nblocks);
+		sha256_block_data_order(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL_GPL(sha256_blocks_simd);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM scalar implementation. */
 	return true;
-- 
2.49.0

