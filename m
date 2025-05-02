Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B193CA4E
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163873; cv=none; b=b+a+oSLpzPoWd3+M3b+/UzfHaNXQjZxyCFqZmzFzPVI27jW7axpG7mmUoCGdxRjlljAOPH6UKuJ5H3Cp7+WuJWIGI+97f/WeF3bjefGmTi786JXQf0Oeax5uqbTRR8+YGK0aNljpNofFIc0NY5iCI5s6QXXbecIbhR8PUeZspro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163873; c=relaxed/simple;
	bh=0V3RbGaWepEn6I/fNWDPUJ8EHbUxbND1FQBWMkMRUn8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=lM6YFVzCEVFzqS8mDA+b2xt/iQJgI1lGSCxHX79WYlQDtwkvN05isIqYKB/HOonrKNL2GTyM1N2WgMF75zIt/F/pzlWQ2VFHqWQP+zR7kQzE+jOukDD81MpJI14hoZwD2zEwoKWcztBpvNAf6w0IZCzH3p9hvQ3Ls/hOPZB0lIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=S098thkE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="S098thkE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3Kihjh3Dao1W0H4HWvNSr/f9amAEH4iBqCZwvVRT000=; b=S098thkEe3dVHl4+zBopegBDaL
	HGCMCv0i5IT80In7tpSuCuAqkk4t6R9nJOGEbkUvdSvLqpIZOpVbUOIH35sDy9Nc5dI1DZydNKNJN
	Q8i86JDYyQOU1AnWqgYmi67+yjQMvASVXMHu414wGvNF473iSB/gmNUEMpdb7dJoVNoXik1bPRX01
	lf+XGA2KH0cmSr6xKme61LuuGxTW5Gk/P/hjLI2XqS0ikBX7itqITPpROwgkhT/1he6avfuuKJXlI
	JSrjNCkTDVtrx/4C8wB5CIF6nw66iFFAGhtz+THE4mo7ZVtm1KhK4M0sdFAEWcFcLME9zqjYUnSLW
	0Z/Ebu8A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAizL-002lLJ-2F;
	Fri, 02 May 2025 13:31:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:31:07 +0800
Date: Fri, 02 May 2025 13:31:07 +0800
Message-Id: <7ac4f761c7526b75d17b3d5bcc4467e68c46da21.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 7/9] crypto: x86/sha256 - Add simd block function
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
 arch/x86/lib/crypto/Kconfig  |  1 +
 arch/x86/lib/crypto/sha256.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/crypto/Kconfig b/arch/x86/lib/crypto/Kconfig
index e344579db3d8..5e94cdee492c 100644
--- a/arch/x86/lib/crypto/Kconfig
+++ b/arch/x86/lib/crypto/Kconfig
@@ -30,4 +30,5 @@ config CRYPTO_SHA256_X86_64
 	depends on 64BIT
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
+	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
 	select CRYPTO_LIB_SHA256_GENERIC
diff --git a/arch/x86/lib/crypto/sha256.c b/arch/x86/lib/crypto/sha256.c
index 8735ec871f86..cdd88497eedf 100644
--- a/arch/x86/lib/crypto/sha256.c
+++ b/arch/x86/lib/crypto/sha256.c
@@ -6,7 +6,6 @@
  */
 #include <asm/fpu/api.h>
 #include <crypto/internal/sha2.h>
-#include <crypto/internal/simd.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/static_call.h>
@@ -24,10 +23,10 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha256_x86);
 
 DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_transform_ssse3);
 
-void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_sha256_x86) && crypto_simd_usable()) {
+	if (static_branch_likely(&have_sha256_x86)) {
 		kernel_fpu_begin();
 		static_call(sha256_blocks_x86)(state, data, nblocks);
 		kernel_fpu_end();
@@ -35,6 +34,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		sha256_blocks_generic(state, data, nblocks);
 	}
 }
+EXPORT_SYMBOL_GPL(sha256_blocks_simd);
+
+void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+			const u8 *data, size_t nblocks)
+{
+	sha256_blocks_generic(state, data, nblocks);
+}
 EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
-- 
2.39.5

