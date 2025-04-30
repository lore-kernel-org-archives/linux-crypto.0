Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5BA1E5B6F
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993190; cv=none; b=hSyuyOmzZZZXw2wFqPsTQu/iAL3BIyZkFBItYxsfbl5/igc2zyzZNvWgnZIv/gDO6GX0S/66IAOTW11b0Mr6RJor+r0dgJbgVzxkXwKGt01QdVwAw2ntexbPUNr5Mt8XINqauB5q3+B3j/wJ7niXbwr8cGzyofk7K2P8g+ZuKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993190; c=relaxed/simple;
	bh=d26DE2+MaBaSso9W+AWnYvZCdQR7iLR8UycGOQTsQp0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=W+ebujSrGdp21Mx5fOK/eYDhiRKrqhsOi8KH/9wm3FWs2GVJHohcIzNVQ2rzyI7l7CAcoSG/IwO2wHIdna8rpH9gZh1IMRyRuz0gVvaUvea8v1jN4z9xcwoBUTJ5uRNWfFgKGT2K6mI4gjsIb8s57etNM/KdvftpWG0PD/DZmys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EaSb0LqA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EaSb0LqA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3UTTpn3CMilA/yWbCualpOKdcGE8Ujv2ZcYALLuAqZA=; b=EaSb0LqAL/EVIZlypc6hqSI4oh
	vu8izWHiqjqFGVCjrwhkcpz646/Bn6GiH/dxLqJaARx2y4fQjD+x6Dt7hs824DljBQzF9oW+u+GnP
	t2bzVF+YaQYfZikhGfQxo4KUB6Bhy0HBKXkgbI0Qn0WsprDJosbUUTvTzU7mxIFKI2IWe85YXvfcG
	dfiu4M1hesX4ffwDBsfhju/p315GgUtoipdu2ohmwSS4Ll9TTPbR5bBvpdob60FyNdXO46AjHbImd
	SoBy5Xp3zNffNSPzi89h9PhLMn2VK+MfEfob1G2XGfMS78wOYf8t3Gr9E9Qo4jM+fHPcx7QEVw5F1
	kXBFzbvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aO-002AaC-1P;
	Wed, 30 Apr 2025 14:06:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:24 +0800
Date: Wed, 30 Apr 2025 14:06:24 +0800
Message-Id: <6234f666563963bc867eeac37695d78fb34e971b.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 04/12] crypto: arm64/sha256 - Add simd block function
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD and a SIMD block function
so that the caller can decide whether to use SIMD.

Also export the block functions as GPL only, there is no reason
to let arbitrary modules use these internal functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha512-glue.c     |  6 +++---
 arch/arm64/lib/crypto/Kconfig       |  1 +
 arch/arm64/lib/crypto/sha2-armv8.pl |  2 +-
 arch/arm64/lib/crypto/sha256.c      | 16 ++++++++--------
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index ab2e1c13dfad..15aa9d8b7b2c 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -18,13 +18,13 @@ MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("sha384");
 MODULE_ALIAS_CRYPTO("sha512");
 
-asmlinkage void sha512_block_data_order(u64 *digest, const void *data,
-					unsigned int num_blks);
+asmlinkage void sha512_blocks_arch(u64 *digest, const void *data,
+				   unsigned int num_blks);
 
 static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
 				   int blocks)
 {
-	sha512_block_data_order(sst->state, src, blocks);
+	sha512_blocks_arch(sst->state, src, blocks);
 }
 
 static int sha512_update(struct shash_desc *desc, const u8 *data,
diff --git a/arch/arm64/lib/crypto/Kconfig b/arch/arm64/lib/crypto/Kconfig
index 49e57bfdb5b5..129a7685cb4c 100644
--- a/arch/arm64/lib/crypto/Kconfig
+++ b/arch/arm64/lib/crypto/Kconfig
@@ -17,3 +17,4 @@ config CRYPTO_SHA256_ARM64
 	tristate
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
+	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
diff --git a/arch/arm64/lib/crypto/sha2-armv8.pl b/arch/arm64/lib/crypto/sha2-armv8.pl
index 35ec9ae99fe1..4aebd20c498b 100644
--- a/arch/arm64/lib/crypto/sha2-armv8.pl
+++ b/arch/arm64/lib/crypto/sha2-armv8.pl
@@ -95,7 +95,7 @@ if ($output =~ /512/) {
 	$reg_t="w";
 }
 
-$func="sha${BITS}_block_data_order";
+$func="sha${BITS}_blocks_arch";
 
 ($ctx,$inp,$num,$Ktbl)=map("x$_",(0..2,30));
 
diff --git a/arch/arm64/lib/crypto/sha256.c b/arch/arm64/lib/crypto/sha256.c
index 2bd413c586d2..fdceb2d0899c 100644
--- a/arch/arm64/lib/crypto/sha256.c
+++ b/arch/arm64/lib/crypto/sha256.c
@@ -6,12 +6,12 @@
  */
 #include <asm/neon.h>
 #include <crypto/internal/sha2.h>
-#include <crypto/internal/simd.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-asmlinkage void sha256_block_data_order(u32 state[SHA256_STATE_WORDS],
-					const u8 *data, size_t nblocks);
+asmlinkage void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+				   const u8 *data, size_t nblocks);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 asmlinkage void sha256_block_neon(u32 state[SHA256_STATE_WORDS],
 				  const u8 *data, size_t nblocks);
 asmlinkage size_t __sha256_ce_transform(u32 state[SHA256_STATE_WORDS],
@@ -20,11 +20,11 @@ asmlinkage size_t __sha256_ce_transform(u32 state[SHA256_STATE_WORDS],
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
 
-void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && crypto_simd_usable()) {
+	    static_branch_likely(&have_neon)) {
 		if (static_branch_likely(&have_ce)) {
 			do {
 				size_t rem;
@@ -42,17 +42,17 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			kernel_neon_end();
 		}
 	} else {
-		sha256_block_data_order(state, data, nblocks);
+		sha256_blocks_arch(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_simd);
 
 bool sha256_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM64 scalar implementation. */
 	return true;
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_arm64_mod_init(void)
 {
-- 
2.39.5

