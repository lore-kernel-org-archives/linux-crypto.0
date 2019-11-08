Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70144C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7E821D6C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215794;
	bh=RtKVtJGNdQ7rb7Xkl3C5Z4EtLccIsTyEgY2LQ5jU4Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=clb8er4gRp3ab8k4y8UZCFHy+ayRceMFiCIcEriD+xYSYrfEjw1JspJvKDAPwZqEU
	 3at83xB6HMNx8uyYGCFdB4UZKqa4smLrNv3kJfKinElJE3Aq3lo77cyPlmhnbhT+Qs
	 O+wS6dp4eZ1YRXNXM75444KyCenah541eAG/81N8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbfKHMXN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:13 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C455C21D7E;
        Fri,  8 Nov 2019 12:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215792;
        bh=RtKVtJGNdQ7rb7Xkl3C5Z4EtLccIsTyEgY2LQ5jU4Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUaEhsMMx+iDZeup9kzzecHa/u1wSxXoInX0YSj54z+GxhhO/DX7UTtHTKeOvZ+/d
         G/M2xststMU/zRDzDOAUOPbgpiBhR+8PItkdNvEIFWNSdAWdAduqvPjRDmFFUw3oez
         DQByUQ53vTYTvx2LMieDtAFm8Dw70+9dElnQxdaE=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 04/34] crypto: x86/chacha - expose SIMD ChaCha routine as library function
Date:   Fri,  8 Nov 2019 13:22:10 +0100
Message-Id: <20191108122240.28479-5-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wire the existing x86 SIMD ChaCha code into the new ChaCha library
interface, so that users of the library interface will get the
accelerated version when available.

Given that calls into the library API will always go through the
routines in this module if it is enabled, switch to static keys
to select the optimal implementation available (which may be none
at all, in which case we defer to the generic implementation for
all invocations).

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/chacha_glue.c | 91 ++++++++++++++------
 crypto/Kconfig                |  1 +
 include/crypto/chacha.h       |  6 ++
 3 files changed, 73 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 0aabb382edce..b391e13a9e41 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -21,24 +21,24 @@ asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 asmlinkage void chacha_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 					unsigned int len, int nrounds);
 asmlinkage void hchacha_block_ssse3(const u32 *state, u32 *out, int nrounds);
-#ifdef CONFIG_AS_AVX2
+
 asmlinkage void chacha_2block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
 asmlinkage void chacha_4block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
 asmlinkage void chacha_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
-static bool chacha_use_avx2;
-#ifdef CONFIG_AS_AVX512
+
 asmlinkage void chacha_2block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					   unsigned int len, int nrounds);
 asmlinkage void chacha_4block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					   unsigned int len, int nrounds);
 asmlinkage void chacha_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
 					   unsigned int len, int nrounds);
-static bool chacha_use_avx512vl;
-#endif
-#endif
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
 
 static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 {
@@ -49,9 +49,8 @@ static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
 {
-#ifdef CONFIG_AS_AVX2
-#ifdef CONFIG_AS_AVX512
-	if (chacha_use_avx512vl) {
+	if (IS_ENABLED(CONFIG_AS_AVX512) &&
+	    static_branch_likely(&chacha_use_avx512vl)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
 			chacha_8block_xor_avx512vl(state, dst, src, bytes,
 						   nrounds);
@@ -79,8 +78,9 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 			return;
 		}
 	}
-#endif
-	if (chacha_use_avx2) {
+
+	if (IS_ENABLED(CONFIG_AS_AVX2) &&
+	    static_branch_likely(&chacha_use_avx2)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
 			chacha_8block_xor_avx2(state, dst, src, bytes, nrounds);
 			bytes -= CHACHA_BLOCK_SIZE * 8;
@@ -104,7 +104,7 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 			return;
 		}
 	}
-#endif
+
 	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
 		chacha_4block_xor_ssse3(state, dst, src, bytes, nrounds);
 		bytes -= CHACHA_BLOCK_SIZE * 4;
@@ -123,6 +123,43 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
+void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable()) {
+		hchacha_block_generic(state, stream, nrounds);
+	} else {
+		kernel_fpu_begin();
+		hchacha_block_ssse3(state, stream, nrounds);
+		kernel_fpu_end();
+	}
+}
+EXPORT_SYMBOL(hchacha_block_arch);
+
+void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init_arch);
+
+void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		       int nrounds)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
+	    bytes <= CHACHA_BLOCK_SIZE)
+		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
+
+	kernel_fpu_begin();
+	chacha_dosimd(state, dst, src, bytes, nrounds);
+	kernel_fpu_end();
+}
+EXPORT_SYMBOL(chacha_crypt_arch);
+
 static int chacha_simd_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -143,7 +180,8 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		if (!crypto_simd_usable()) {
+		if (!static_branch_likely(&chacha_use_simd) ||
+		    !crypto_simd_usable()) {
 			chacha_crypt_generic(state, walk.dst.virt.addr,
 					     walk.src.virt.addr, nbytes,
 					     ctx->nrounds);
@@ -246,18 +284,21 @@ static struct skcipher_alg algs[] = {
 static int __init chacha_simd_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
-		return -ENODEV;
-
-#ifdef CONFIG_AS_AVX2
-	chacha_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
-			  boot_cpu_has(X86_FEATURE_AVX2) &&
-			  cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-#ifdef CONFIG_AS_AVX512
-	chacha_use_avx512vl = chacha_use_avx2 &&
-			      boot_cpu_has(X86_FEATURE_AVX512VL) &&
-			      boot_cpu_has(X86_FEATURE_AVX512BW); /* kmovq */
-#endif
-#endif
+		return 0;
+
+	static_branch_enable(&chacha_use_simd);
+
+	if (IS_ENABLED(CONFIG_AS_AVX2) &&
+	    boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_AVX2) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
+		static_branch_enable(&chacha_use_avx2);
+
+		if (IS_ENABLED(CONFIG_AS_AVX512) &&
+		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
+		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
+			static_branch_enable(&chacha_use_avx512vl);
+	}
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1abca30ed6ae..07762de1237f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1437,6 +1437,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 5c662f8fecac..2676f4fbd4c1 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -25,6 +25,12 @@
 #define CHACHA_BLOCK_SIZE	64
 #define CHACHAPOLY_IV_SIZE	12
 
+#ifdef CONFIG_X86_64
+#define CHACHA_STATE_WORDS	((CHACHA_BLOCK_SIZE + 12) / sizeof(u32))
+#else
+#define CHACHA_STATE_WORDS	(CHACHA_BLOCK_SIZE / sizeof(u32))
+#endif
+
 /* 192-bit nonce, then 64-bit stream position */
 #define XCHACHA_IV_SIZE		32
 
-- 
2.20.1

