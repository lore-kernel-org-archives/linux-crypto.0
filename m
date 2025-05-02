Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A9F1A0BE1
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163867; cv=none; b=L9INkiOrsKcf8gOqc6atYU9S9qxWg/NDW3lyup1TcHTCE/s9BvsmFpZF4lb2JYF+upd24FnAn90HB6DPh3ceGdk4/gMd47ge1f8StTpB6mGahOcpmV4+j9cVTQcF3pivHxyHd2h1AjS6w7fw8/dA4RBWSy5U4cqWhDyVwo3WDpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163867; c=relaxed/simple;
	bh=cDazNFoLe44oaflsagIfz5Onx9azSypdeFvQ4McUelo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Qni2OGgFuw7Np9FbK6nK7J5XQIrUBheQoyXNW/WIB7He7eK2Y/ykLeVlzNqFDqbMrfeLkbgFFQ7VtjEfRtNjgbRhcZOli8qra4tGyngWFt3PdV7Q+qcJqdE+OVePA8VxSL8sQjoqxxX7YL35I1AAmVGkY01/P50Yh2QiHQi4WHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZCkaN9Cy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZCkaN9Cy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k9sl7qjwQFuFnOZAVeNzZtey0UxsJlT+8LG0yANeKv8=; b=ZCkaN9CyDY9fSJ1txgPFrxr/hN
	DMRs168/fuyy3+dX5OC7hEPwFOoF2OynExIXsWUrMgRCVNlj6dJyNLRYlH3uN+JlQ1WtEJGa3iYPl
	hWiXty+4/kubidAPZ9S5q2+vHtDz7tq+HLgOGSTq4OCWt6s0BR7TuIbOmojvgz4jllLgXxXy3qp/h
	/pKe47AcH1wgc4wEvhpUvg2y9Ka8+ej4geW15ZbduUR1X0iuzlhDA85Oh6lck06XrtpOjvPmbormj
	nJHHoh/afj2rlYOyM015X6YYIReI+3015lp7YSV9AjMGhwM3f3AIU5IfOMDra2mGSKuipmZhVOdlG
	WsoduSkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAizE-002lKl-2a;
	Fri, 02 May 2025 13:31:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:31:00 +0800
Date: Fri, 02 May 2025 13:31:00 +0800
Message-Id: <11573e030c689c70c634c7eceef48a5fa25a8507.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 4/9] crypto: arm/sha256 - Add simd block function
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD and a SIMD block function
so that the caller can decide whether to use SIMD.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/lib/crypto/Kconfig         |  1 +
 arch/arm/lib/crypto/sha256-armv4.pl | 20 ++++++++++----------
 arch/arm/lib/crypto/sha256.c        | 14 +++++++-------
 3 files changed, 18 insertions(+), 17 deletions(-)

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
index e2fae3664428..1dd71b8fd611 100644
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
@@ -32,10 +32,10 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 			sha256_block_data_order_neon(state, data, nblocks);
 		kernel_neon_end();
 	} else {
-		sha256_block_data_order(state, data, nblocks);
+		sha256_blocks_arch(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL_GPL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_simd);
 
 bool sha256_is_arch_optimized(void)
 {
-- 
2.39.5

