Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143ED1E47CA
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993188; cv=none; b=muTtcw3N9ljFvUc8F7VfZJJQVw3oZuMqzAjNxJ3XJz9XeIIAzX3l7yPxKmDd0obt0nEQThXvES0vlQ+XwzJwFTiwVccxQzj9LQ1G44fd1RmVMgPSPYhadvmmuh6Je/kGg/Dt+kH6pbC9ELRFi0FEu654dejDIHYksXoc/3+IpI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993188; c=relaxed/simple;
	bh=SnfFNTNRS4DeNhseIsZiesceRHxkBIlH44nvFe101vA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=TabFIgdZ6duDLfkDiJvntl8JC7LI8mPNoqUpAdt0TFmvlM7I2pqBMWkkFrj7aRl55OS3PIUCXOaQWnw9uSFS5Yj73CCOIuOHIBB+DkBNKhr5RYAESrEKGQABiXoSn5eh2xNK1QgFaBN2hT3NzGpN/tUn+HVHJA/u4uFvdawy0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=M1hLa5JV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="M1hLa5JV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ILY4WouKeRnZQPS9+T8beaJejQOoiybMKQ4Lpkk4TcQ=; b=M1hLa5JVdC3VgzNa9GtiRENkSp
	tw+CQZF7ukSEX+secu8KorRUqoomj95VBFbot6OD53oam6+MUnBjz3It+Kd9qzbrULTgyTHb4FH65
	FHEMlcuAnMfaUcEhhF0SoOwZMKnaHVveXHwsPtwK5FNOwOC9qpllr7v4jIKEATF6iwppbnwXHXhDH
	bNyk0WorUsWCgRPGPjaqMzYdb1tea7AMYuJG5MZJCmdQB62LJZESJBVfbw0d9Oks/zXGcah0uK9Pm
	pLvc5HZS06xiHuHoE4NPH18b1c9gd4bGWL340cYChdudkxPnNJd+NQ1GXpXqHpAQISYP44F3kjznP
	lAboe6sw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aM-002Aa1-0Q;
	Wed, 30 Apr 2025 14:06:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:22 +0800
Date: Wed, 30 Apr 2025 14:06:22 +0800
Message-Id: <a02673d5d73a0b523e683ce8ed316873912c4ebe.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 03/12] crypto: arm/sha256 - Add simd block function
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
 arch/arm/lib/crypto/Kconfig         |  1 +
 arch/arm/lib/crypto/sha256-armv4.pl | 20 ++++++++++----------
 arch/arm/lib/crypto/sha256.c        | 16 ++++++++--------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/arm/lib/crypto/Kconfig b/arch/arm/lib/crypto/Kconfig
index 9f3ff30f4032..d1ad664f0c67 100644
--- a/arch/arm/lib/crypto/Kconfig
+++ b/arch/arm/lib/crypto/Kconfig
@@ -28,3 +28,4 @@ config CRYPTO_SHA256_ARM
 	depends on !CPU_V7M
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
+	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
diff --git a/arch/arm/lib/crypto/sha256-armv4.pl b/arch/arm/lib/crypto/sha256-armv4.pl
index f3a2b54efd4e..8122db7fd599 100644
--- a/arch/arm/lib/crypto/sha256-armv4.pl
+++ b/arch/arm/lib/crypto/sha256-armv4.pl
@@ -204,18 +204,18 @@ K256:
 .word	0				@ terminator
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 .LOPENSSL_armcap:
-.word	OPENSSL_armcap_P-sha256_block_data_order
+.word	OPENSSL_armcap_P-sha256_blocks_arch
 #endif
 .align	5
 
-.global	sha256_block_data_order
-.type	sha256_block_data_order,%function
-sha256_block_data_order:
-.Lsha256_block_data_order:
+.global	sha256_blocks_arch
+.type	sha256_blocks_arch,%function
+sha256_blocks_arch:
+.Lsha256_blocks_arch:
 #if __ARM_ARCH__<7
-	sub	r3,pc,#8		@ sha256_block_data_order
+	sub	r3,pc,#8		@ sha256_blocks_arch
 #else
-	adr	r3,.Lsha256_block_data_order
+	adr	r3,.Lsha256_blocks_arch
 #endif
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 	ldr	r12,.LOPENSSL_armcap
@@ -282,7 +282,7 @@ $code.=<<___;
 	moveq	pc,lr			@ be binary compatible with V4, yet
 	bx	lr			@ interoperable with Thumb ISA:-)
 #endif
-.size	sha256_block_data_order,.-sha256_block_data_order
+.size	sha256_blocks_arch,.-sha256_blocks_arch
 ___
 ######################################################################
 # NEON stuff
@@ -470,8 +470,8 @@ sha256_block_data_order_neon:
 	stmdb	sp!,{r4-r12,lr}
 
 	sub	$H,sp,#16*4+16
-	adr	$Ktbl,.Lsha256_block_data_order
-	sub	$Ktbl,$Ktbl,#.Lsha256_block_data_order-K256
+	adr	$Ktbl,.Lsha256_blocks_arch
+	sub	$Ktbl,$Ktbl,#.Lsha256_blocks_arch-K256
 	bic	$H,$H,#15		@ align for 128-bit stores
 	mov	$t2,sp
 	mov	sp,$H			@ alloca
diff --git a/arch/arm/lib/crypto/sha256.c b/arch/arm/lib/crypto/sha256.c
index 3a8dfc304807..1dd71b8fd611 100644
--- a/arch/arm/lib/crypto/sha256.c
+++ b/arch/arm/lib/crypto/sha256.c
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
 asmlinkage void sha256_block_data_order_neon(u32 state[SHA256_STATE_WORDS],
 					     const u8 *data, size_t nblocks);
 asmlinkage void sha256_ce_transform(u32 state[SHA256_STATE_WORDS],
@@ -20,11 +20,11 @@ asmlinkage void sha256_ce_transform(u32 state[SHA256_STATE_WORDS],
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ce);
 
-void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && crypto_simd_usable()) {
+	    static_branch_likely(&have_neon)) {
 		kernel_neon_begin();
 		if (static_branch_likely(&have_ce))
 			sha256_ce_transform(state, data, nblocks);
@@ -32,17 +32,17 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			sha256_block_data_order_neon(state, data, nblocks);
 		kernel_neon_end();
 	} else {
-		sha256_block_data_order(state, data, nblocks);
+		sha256_blocks_arch(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_simd);
 
 bool sha256_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM scalar implementation. */
 	return true;
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_arm_mod_init(void)
 {
-- 
2.39.5

