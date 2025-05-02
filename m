Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF4E19FA8D
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163871; cv=none; b=aJ6SDDoolD7WV2p6I07/CyLRLN+U8ovIKsZ25GGyobiG+8lyrQJ6M4czWK/aRgR10zhQ7cmtpCV3Gs39mRDuMyx8UWY/IgL+81NKlunkQ06dHbRV2BV7lBEiOu5TeMjWFD60JMPUv271C361TBm/g+nHvtRS70FCMFqmuQLu//Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163871; c=relaxed/simple;
	bh=xecfdc8aVC7Q4f5sVsF3XnUYRBQ96xKxSrcjKbBVxII=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Lg4O9EbBJBLVt3pzGHin70PuO8CsnowjIN4UeUgxvu+jqAl0teNTSu9QrBxcuDnMpWRvQhDlZO8bBnoveC+WsPmyBE9S8QCAmvQpq2uFaHsdeOS9etzbC9IkaP0ViwczCS0cLqWIYNL2la0yv7egjiJPzOgnuw9chCoQB23s31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b9ZG+74A; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b9ZG+74A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=t4ss7E4zqQoTfvbDhmZeIpLXN+A/1mFSTgtWDtQF/Sw=; b=b9ZG+74ACWK+KXrWfc+Is49maH
	lhykouvAbc2Op7ieG/+OKTTf3QbtBei7CRNVScw6am+3f6qT3KtDXM3FqCxCK/8G3rBuEZx1XUG4i
	pAO8SWths17YdPlqBLj3x2XHdY64aEQqri1eGPgjO0Cd3idEnybUhIwptFJGaeWXIqMxKqURqUyqE
	G46mkHCwfyH3xCXv+LvzpEhVHMUNO/yZIfk/mPqsjc+01JbDPFwUdyS1tWSfXfnmZUDtBtnvfWuHx
	S7ACfbbywH1uG82wTtea/rXaHYOh3wz3IpcRAha5bol2sbj6QqFnUQRnZBoCz4+Ti7kydHt7D7p5Z
	ETFtPPSg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAizJ-002lL7-1M;
	Fri, 02 May 2025 13:31:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:31:05 +0800
Date: Fri, 02 May 2025 13:31:05 +0800
Message-Id: <a2522c76d1d7911275bfcb222d689b4e2e793499.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 6/9] crypto: riscv/sha256 - Add simd block function
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
 arch/riscv/lib/crypto/Kconfig  |  1 +
 arch/riscv/lib/crypto/sha256.c | 13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

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
index 2905a6dbb485..c1358eafc2ad 100644
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
@@ -32,6 +30,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
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

