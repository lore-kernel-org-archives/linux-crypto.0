Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201B1E5B6D
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993204; cv=none; b=McNAPhtt65vbjwX+du42sxT/hVDMTdHdUC5ky2j6YJ1Qcz7lIWT8UmD95fdClYDk90Qli3qJxwa0cpRLzr2GUKY3rYWm/1COuvofx64UDHfgVsNCFbRO2CahNx6noPMQwAaG7TFjdC3FkKIA6292ixeNevswFuEuM/dd/DkQiCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993204; c=relaxed/simple;
	bh=5ox3KLbXNCDca1zuLt98SnRIfOMOBiJSOa6+4bjrTVQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=p/kQuWnCZG5x2uVQODN8osMGHcX4w9Obwh50astVs9NUWbM33GAao5+GWDMDepscLpY2fsz9rxYvaJxGXd/9HhtGN8/LLepO6eYiqvkm/V9/3llt0Sni6XegP68jcM0XPnifY5D4DP9YnXzSqk4xYF7RE6TioXbZRGoZD6Y/hnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GtDNqn6b; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GtDNqn6b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ExLMK/FQ2Dd1O5WsZt+CKxQ6qoCxwUJAIpFqnQMQqw8=; b=GtDNqn6brmzw5ffe7TXVC7AGL3
	qIjo5Scl2+IdspTAFGKlwI9ZE4fqUaveQWYsGBN7crqeR9zWTVkTpSi0AJ5SbbMkSNLzCVVAKrD4m
	LUGEvRtDWrbYCjlnXT/AXAOCcND2vz5ep2v6Cee35Jqgu4o/+5OJPHS93F9cAI9bTom42vlDFxZGT
	Q+nVV8BfoZrRjc11jOHnh0t/Az+2EWypnp2PPNVO8/pRpM4JSqK3/ei9tNrm8X1DorRatME2SvAm8
	qWIDVeWipXVCzhVhGmC2+TYaN6tQkG/RkfrQK2mpa91BQyKyd6AkrbT0JfJ9kIX4djbzdrVpSSiaO
	6sIGn6Ag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0ac-002Abf-0u;
	Wed, 30 Apr 2025 14:06:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:38 +0800
Date: Wed, 30 Apr 2025 14:06:38 +0800
Message-Id: <76d7987e6f1498eebf75f77b891d7428e273a6b1.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/12] crypto: x86/sha256 - Add simd block function
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
 arch/x86/lib/crypto/Kconfig  |  1 +
 arch/x86/lib/crypto/sha256.c | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

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
index 47865b5cd94b..cdd88497eedf 100644
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
@@ -35,13 +34,20 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		sha256_blocks_generic(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_simd);
+
+void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+			const u8 *data, size_t nblocks)
+{
+	sha256_blocks_generic(state, data, nblocks);
+}
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_sha256_x86);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_x86_mod_init(void)
 {
-- 
2.39.5

