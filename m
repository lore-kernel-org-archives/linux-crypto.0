Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC081917E3;
	Sat, 17 May 2025 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448719; cv=none; b=Da0LMM3AP9Xw3euszd8xCqZahP9xoeTEWHVWsatVbAbKtpH+jc3xx1lrxkYTKIBpCiOJSwDSXUniy7nsh1Nbeth26qL5pK9FjgD0ifHC1Df5tnQbgDUwi/AxkYzQdO/9WE5Eu4ak+Hxfk4vtn6kkpybFkLwu1VT+fpcaQ+78G2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448719; c=relaxed/simple;
	bh=gUUxjIgDrRMsYzb7G3k3d2wphMLjs03o+vzyCoM8US0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT7hfBmsDMXwLbziFm0YxCJmXbQmkopIv3cq61S0zQKojxwAp4M5mir6U4T06RccECsNw+wBcQLXkt6OijNP15Nmo1E7i3TM2l0DNK69a2/6V1IpFtO7hRzPYq+4Lq5jbuzLGbZ0uK0eE3sR2Dv26eOMIIy7hwc9aaTTfloDIXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JofceYRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JofceYRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E465AC4CEED;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448718;
	bh=gUUxjIgDrRMsYzb7G3k3d2wphMLjs03o+vzyCoM8US0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JofceYRedR4KKMmWWK2UdkTiGZryBVX5oeS8Z2nUEoeezPsU6MPL9xeFnsiuuHikW
	 CvHrylhrWgono/CkurcSWIBK+iA7W9DD2gmzzzyxa8paJ4g6Oee8ancYIJiLyux+Jw
	 u663COUXKo0v0ov9sEL1zyqNc5uwZwk8TCoGmK1H/6oJw633iCRg7g00LckNkTIgoI
	 htL45QQCFPFKC7TrLQK6ucEZWQxX6Fj4xH4a6EAfN1U/lnx0E1bYAZnwG1/Y+2NFxY
	 /VFKKtSnTZZiyCW5afXbhkALdEd7SIjk+6l6z0cn6qq9ghT/O0ryk44NVQ7qVfCUq/
	 d0L2UDmSYvoMA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Revert "crypto: arm64/sha256 - Add simd block function"
Date: Fri, 16 May 2025 19:24:25 -0700
Message-ID: <20250517022428.401622-6-ebiggers@kernel.org>
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

This reverts commit adcb9e32e5e28935ec1148e1a314282a7367428d which got
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
 arch/arm64/crypto/sha512-glue.c     |  6 +++---
 arch/arm64/lib/crypto/Kconfig       |  1 -
 arch/arm64/lib/crypto/sha2-armv8.pl |  2 +-
 arch/arm64/lib/crypto/sha256.c      | 14 +++++++-------
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index 15aa9d8b7b2c4..ab2e1c13dfadc 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -16,17 +16,17 @@ MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("sha384");
 MODULE_ALIAS_CRYPTO("sha512");
 
-asmlinkage void sha512_blocks_arch(u64 *digest, const void *data,
-				   unsigned int num_blks);
+asmlinkage void sha512_block_data_order(u64 *digest, const void *data,
+					unsigned int num_blks);
 
 static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
 				   int blocks)
 {
-	sha512_blocks_arch(sst->state, src, blocks);
+	sha512_block_data_order(sst->state, src, blocks);
 }
 
 static int sha512_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
diff --git a/arch/arm64/lib/crypto/Kconfig b/arch/arm64/lib/crypto/Kconfig
index 129a7685cb4c1..49e57bfdb5b52 100644
--- a/arch/arm64/lib/crypto/Kconfig
+++ b/arch/arm64/lib/crypto/Kconfig
@@ -15,6 +15,5 @@ config CRYPTO_POLY1305_NEON
 
 config CRYPTO_SHA256_ARM64
 	tristate
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
-	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
diff --git a/arch/arm64/lib/crypto/sha2-armv8.pl b/arch/arm64/lib/crypto/sha2-armv8.pl
index 4aebd20c498bc..35ec9ae99fe16 100644
--- a/arch/arm64/lib/crypto/sha2-armv8.pl
+++ b/arch/arm64/lib/crypto/sha2-armv8.pl
@@ -93,11 +93,11 @@ if ($output =~ /512/) {
 	@sigma1=(17,19,10);
 	$rounds=64;
 	$reg_t="w";
 }
 
-$func="sha${BITS}_blocks_arch";
+$func="sha${BITS}_block_data_order";
 
 ($ctx,$inp,$num,$Ktbl)=map("x$_",(0..2,30));
 
 @X=map("$reg_t$_",(3..15,0..2));
 @V=($A,$B,$C,$D,$E,$F,$G,$H)=map("$reg_t$_",(20..27));
diff --git a/arch/arm64/lib/crypto/sha256.c b/arch/arm64/lib/crypto/sha256.c
index bcf7a3adc0c46..fb9bff40357be 100644
--- a/arch/arm64/lib/crypto/sha256.c
+++ b/arch/arm64/lib/crypto/sha256.c
@@ -4,29 +4,29 @@
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
 asmlinkage void sha256_block_neon(u32 state[SHA256_STATE_WORDS],
 				  const u8 *data, size_t nblocks);
 asmlinkage size_t __sha256_ce_transform(u32 state[SHA256_STATE_WORDS],
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
 		if (static_branch_likely(&have_ce)) {
 			do {
 				size_t rem;
 
 				kernel_neon_begin();
@@ -40,14 +40,14 @@ void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
 			kernel_neon_begin();
 			sha256_block_neon(state, data, nblocks);
 			kernel_neon_end();
 		}
 	} else {
-		sha256_blocks_arch(state, data, nblocks);
+		sha256_block_data_order(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL_GPL(sha256_blocks_simd);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM64 scalar implementation. */
 	return true;
-- 
2.49.0

