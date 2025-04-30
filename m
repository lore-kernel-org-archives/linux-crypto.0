Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E11E5202
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993196; cv=none; b=EBBIm0yS5Mw9D7KlHVq0se+jiqIzpJ3BYmqDhw8GuXgM8WgBIAOcYfbubK8lSM7gXZslV022IsQc7lMv2AgBym1zq7YPQUt59ghQO/mCt/yndjSg3ISaZcRihChNfLBFxrJ4JLaRNOAKHWIpWQV4HI+TCrA7lEg7eIeol4UYmcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993196; c=relaxed/simple;
	bh=9C5AlP+0JOAVckKu9yzZroUZmw3t35uNOwh0xGMIQVg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=EEFcdxiBiIcoJk5+FM7OWI2kN00PXDDBDA9IrHMklOaSRdeLtyBTSRiCyo0BxdfnnVULJ9sfo2nMKGB7zABMPZrnisz3jpVytQz07nMVOKsKqby14TmmWhow8xTAUCuj0eKSP2DbAkTHktpVh9pM2wKS+x6yJdk+OEppilWajWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GpvfeQga; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GpvfeQga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XIgD6WLqlklGPrcffZ4WIDwIGvz6Jsht4742RTzQMdg=; b=GpvfeQgaNVyCwg1sYMcDPzje/J
	3pAcIAEU0+l/33FXbedxgGL6zDsPalLwHE81usdKf7yNkpsKIr1E6IC/HTFAYPi3gXefWqhBVVe2W
	8N1bXe8FucQV0nwxDp0ydNeWWE56DHB3gt/SoR86iR/Z5xFlPaVk4G4YqbuSzgdTJdKydLI48KD0e
	p8Z+e56hB36xI+UqrxyRZrLFNuZjjzwG7s3K/A50qVWv8JREYf/avWnwNIogrNtYVcrrGmrhmonmK
	XqS3hWGjW30zJmHNPF4Fm9Qk9RjYIBXQsJm8cQX0dUiiTGhmD7aVE6VqOqRlvRxco1fTorPLlD0w7
	chfkNCUg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aV-002Aaj-15;
	Wed, 30 Apr 2025 14:06:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:31 +0800
Date: Wed, 30 Apr 2025 14:06:31 +0800
Message-Id: <8005266d4512f0c8f8eb45619e2530992b130ce3.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 07/12] crypto: riscv/sha256 - Add simd block function
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
 arch/riscv/lib/crypto/Kconfig  |  1 +
 arch/riscv/lib/crypto/sha256.c | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/lib/crypto/Kconfig b/arch/riscv/lib/crypto/Kconfig
index c100571feb7e..47c99ea97ce2 100644
--- a/arch/riscv/lib/crypto/Kconfig
+++ b/arch/riscv/lib/crypto/Kconfig
@@ -12,4 +12,5 @@ config CRYPTO_SHA256_RISCV64
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
 	default CRYPTO_LIB_SHA256
 	select CRYPTO_ARCH_HAVE_LIB_SHA256
+	select CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD
 	select CRYPTO_LIB_SHA256_GENERIC
diff --git a/arch/riscv/lib/crypto/sha256.c b/arch/riscv/lib/crypto/sha256.c
index 18b84030f0b3..c1358eafc2ad 100644
--- a/arch/riscv/lib/crypto/sha256.c
+++ b/arch/riscv/lib/crypto/sha256.c
@@ -9,10 +9,8 @@
  * Author: Jerry Shih <jerry.shih@sifive.com>
  */
 
-#include <asm/simd.h>
 #include <asm/vector.h>
 #include <crypto/internal/sha2.h>
-#include <crypto/internal/simd.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -21,10 +19,10 @@ asmlinkage void sha256_transform_zvknha_or_zvknhb_zvkb(
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_extensions);
 
-void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
+void sha256_blocks_simd(u32 state[SHA256_STATE_WORDS],
 			const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_extensions) && crypto_simd_usable()) {
+	if (static_branch_likely(&have_extensions)) {
 		kernel_vector_begin();
 		sha256_transform_zvknha_or_zvknhb_zvkb(state, data, nblocks);
 		kernel_vector_end();
@@ -32,13 +30,20 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
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
 	return static_key_enabled(&have_extensions);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init riscv64_sha256_mod_init(void)
 {
-- 
2.39.5

