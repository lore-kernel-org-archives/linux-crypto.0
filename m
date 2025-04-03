Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3762CA6;
	Thu,  3 Apr 2025 04:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743653697; cv=none; b=lcgxwIE782sNVepI4UjhrN7OFg9yzRIp/k3vmwbrLSjuPDBjpX8Cbsv+1naZDdFEESIjNKPMUvFrI7GwVb3KgOIumDx8lGKE/+ebWxNeHQrQdpNaTzMV+ogYT3DhvrZm1TTM/I9qCF0SVnwb+Mqb6nCwXwGIQHBjPJvLZu3YXWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743653697; c=relaxed/simple;
	bh=Rs5xl/Fyj2FcHnsISZfJGogORfTq3Uov3CoDy4mk1DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M49x5Ayr69LbzuCj736NfZmQAYSUYsOwrEKV3EnvQfAvg4aIX7MFQjWRWf+gIImDVvwqi90owqpe93Qz2XcDc1L8x1vYtROlbhQA59Mrn1qSfsMEEL3yBYFY0FTXhmTZBNfljKt+EC5IbNs0ZLKuyctTjzSLJ+B0coGrn8Gd+6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jNW1JteO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jNW1JteO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W3IphvtrVw1WmLcdmbuxX8EIK6/vZzV10y7MlPqZZiA=; b=jNW1JteORzIMfXMrXgAxOE9GFs
	mFybB3aVOGNSAWNxqUNGf3fg2sQW9a2Vo9S9YLlpUAEUTIgkrs6M/bgyh7B3A8JLWlFDFg/3laSIB
	S2p/ewjwt/WOPFF3st72djDaEK+PRNEV0UkvUX2IG7ZP4ytSyyjTQ6smj5I5Ucj08B3vn0oheXDjx
	4qbv1bfYO5yVScRAw1/JBZw+7N4efS+a1OtL50HoY3ovBP3IQMS+eGjqGIxWYwc6AEq88LWh1+sTQ
	5hXg/yV3UojWcocS+BI6brXGB819ZwF6hl3dWoCVqT8MpRkW7+eZei8c4aFBB9ayXdf0+JHdwrtYp
	UxlyLrdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0Byc-00CMNF-0m;
	Thu, 03 Apr 2025 12:14:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 12:14:50 +0800
Date: Thu, 3 Apr 2025 12:14:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] crypto: x86/chacha - Remove SIMD fallback path
Message-ID: <Z-4LOoynbEz3ZLuQ@gondor.apana.org.au>
References: <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au>
 <20250403032008.GA129577@sol.localdomain>
 <Z-4DqsRApwQi6Xju@gondor.apana.org.au>
 <20250403035934.GB129577@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403035934.GB129577@sol.localdomain>

On Wed, Apr 02, 2025 at 08:59:34PM -0700, Eric Biggers wrote:
>
> But in a lot of cases there is also no reason to even add that restriction.  I'm
> not sure why you're so eager to make the library functions harder to use.

I have no intention of making any changes to siphash.  It doesn't
even use SIMD.

All I want to do is get rid of the crypto_simd_usable() fallback
paths that we currently have in arch/x86/crypto.  This code is
never used in hardirq context (and should never be).

For example:

---8<---
Get rid of the fallback path as SIMD is now always usable in softirq
context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 8bb74a272879..6a3d60cf3192 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -6,9 +6,7 @@
  * Copyright (C) 2015 Martin Willi
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/chacha.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -35,7 +33,6 @@ asmlinkage void chacha_4block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 asmlinkage void chacha_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					   unsigned int len, int nrounds);
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
 
@@ -123,23 +120,15 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 
 void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
 {
-	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable()) {
-		hchacha_block_generic(state, stream, nrounds);
-	} else {
-		kernel_fpu_begin();
-		hchacha_block_ssse3(state, stream, nrounds);
-		kernel_fpu_end();
-	}
+	kernel_fpu_begin();
+	hchacha_block_ssse3(state, stream, nrounds);
+	kernel_fpu_end();
 }
 EXPORT_SYMBOL(hchacha_block_arch);
 
 void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		       int nrounds)
 {
-	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
-	    bytes <= CHACHA_BLOCK_SIZE)
-		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
-
 	do {
 		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
 
@@ -171,18 +160,11 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		if (!static_branch_likely(&chacha_use_simd) ||
-		    !crypto_simd_usable()) {
-			chacha_crypt_generic(state, walk.dst.virt.addr,
-					     walk.src.virt.addr, nbytes,
-					     ctx->nrounds);
-		} else {
-			kernel_fpu_begin();
-			chacha_dosimd(state, walk.dst.virt.addr,
-				      walk.src.virt.addr, nbytes,
-				      ctx->nrounds);
-			kernel_fpu_end();
-		}
+		kernel_fpu_begin();
+		chacha_dosimd(state, walk.dst.virt.addr,
+			      walk.src.virt.addr, nbytes,
+			      ctx->nrounds);
+		kernel_fpu_end();
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
@@ -207,13 +189,9 @@ static int xchacha_simd(struct skcipher_request *req)
 
 	chacha_init(state, ctx->key, req->iv);
 
-	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
-		kernel_fpu_begin();
-		hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
-		kernel_fpu_end();
-	} else {
-		hchacha_block_generic(state, subctx.key, ctx->nrounds);
-	}
+	kernel_fpu_begin();
+	hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
+	kernel_fpu_end();
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
@@ -275,8 +253,6 @@ static int __init chacha_simd_mod_init(void)
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
 		return 0;
 
-	static_branch_enable(&chacha_use_simd);
-
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_AVX2) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
