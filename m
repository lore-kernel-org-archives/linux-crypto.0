Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D61388;
	Tue,  8 Apr 2025 02:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744078350; cv=none; b=b4W5/MeuA3xabheiHeopPzsL4+P+cJj1OCwY1vcEVyxX5ZUERUZxgLHLDINeWh4ViSPHDH7u0qIHYO4QFvLnTEs6sIKsyj7nuLpeEMSgRQ1c1sUJxTV02VEIx5wgCAB/lWA3I5it2+CL92XO8RTnprSvb0k3374hjRtv3atuYDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744078350; c=relaxed/simple;
	bh=27eWGrXMUOYFPWULHSWJemWuEdGfpL80lkj1C0l9CZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEsOyCzOpPQQgXTD4XcQep9VaP4PBDHMGnQRfhNx8arGv6xzgF/rsi0nokzikVj+yWf1yTlRbB05KY1PbtlRDxZIyG/m7elcOvCG9ZXYEaTpMigv7JTikutCWagiq6QEgCFO1Rxy7Fa6Z1z63+gUnhGx8CD27FJxWXA+ISsOcmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jmfLnJd/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jmfLnJd/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h987QYeC6HtWQC/6G+tDgn6crpIZ1JTghyzFGJ9D4j0=; b=jmfLnJd/4V6QMAdXWLYg+oVZYP
	5P5zjnWQpL1+/78rarlmM0g2BjT+qn7qfPWjEDsdQrVz2BqtnddxfqXUvbdLdjs4TM0zp1h7acCwY
	rQDrKUNuLfcCwOEro4o5cdqEyog9nzmK76yC2s+r7uEyQ/kBZx9kwpYn+h54mjBoLyfV9s4LNqamp
	Y+5V3McNmXfWR+sg3XbJnwUPHAQWWs9ENcc8pGufPB3/gC9q9nX2xmzL1xXb9MqbV/9KNP0OaRSjo
	DW8n/m85lZrEZ33DooZdpwxdz2mqyjiqW4ib8j6TVARsjVVxjr3bcjmJdZMdvAqPh6oBvj4cH27d2
	XnJDUP5A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1yRo-00Dkk6-0Y;
	Tue, 08 Apr 2025 10:12:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Apr 2025 10:12:20 +0800
Date: Tue, 8 Apr 2025 10:12:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] crypto: x86/chacha - Restore SSSE3 fallback path
Message-ID: <Z_SGBC1pgraNHprS@gondor.apana.org.au>
References: <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au>
 <20250403032008.GA129577@sol.localdomain>
 <Z-4DqsRApwQi6Xju@gondor.apana.org.au>
 <20250403035934.GB129577@sol.localdomain>
 <Z-4LOoynbEz3ZLuQ@gondor.apana.org.au>
 <20250407164842.GC2536@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407164842.GC2536@sol.localdomain>

On Mon, Apr 07, 2025 at 09:48:42AM -0700, Eric Biggers wrote:
> 
> First, there doesn't seem to be agreement yet that the library functions should
> have requirements on the calling context.

Do you have a real example of hard IRQ usage for chacha? Not some
imaginary post-crash scenario that ends up calling into generic code.

And if you really wanted to do that, it's much better to fix up
kernel_fpu_begin to support hard IRQs rather than adding useless
may_use_simd() checks all over the place.

> Second, your patch made unrelated changes that deleted the checks for SSSE3
> support.  Thus dropping support for CPUs that don't support SSSE3.

Sorry.  That was an oversight.

---8<---
The chacha_use_simd static branch is required for x86 machines that
lack SSSE3 support.  Restore it and the generic fallback code.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 9b4400215e0e ("crypto: x86/chacha - Remove SIMD fallback path")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index b7fd7a1f0e15..fcc14c006bde 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -5,11 +5,12 @@
  * Copyright (C) 2015 Martin Willi
  */
 
+#include <asm/simd.h>
 #include <crypto/chacha.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
-#include <asm/simd.h>
 
 asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
@@ -31,6 +32,7 @@ asmlinkage void chacha_4block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 asmlinkage void chacha_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					   unsigned int len, int nrounds);
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
 
@@ -117,15 +119,23 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 
 void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 {
-	kernel_fpu_begin();
-	hchacha_block_ssse3(state, stream, nrounds);
-	kernel_fpu_end();
+	if (!static_branch_likely(&chacha_use_simd)) {
+		hchacha_block_generic(state, stream, nrounds);
+	} else {
+		kernel_fpu_begin();
+		hchacha_block_ssse3(state, stream, nrounds);
+		kernel_fpu_end();
+	}
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
+	if (!static_branch_likely(&chacha_use_simd) ||
+	    bytes <= CHACHA_BLOCK_SIZE)
+		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
+
 	do {
 		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
 
@@ -142,7 +152,7 @@ EXPORT_SYMBOL(chacha_crypt_arch);
 
 bool chacha_is_arch_optimized(void)
 {
-	return true;
+	return static_key_enabled(&chacha_use_simd);
 }
 EXPORT_SYMBOL(chacha_is_arch_optimized);
 
@@ -151,6 +161,8 @@ static int __init chacha_simd_mod_init(void)
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
 		return 0;
 
+	static_branch_enable(&chacha_use_simd);
+
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_AVX2) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
