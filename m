Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5BAC47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3977720700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZ8dO/Ua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfJGQq1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40507 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbfJGQq1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so183767wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wwVTHx/uxqTNeI2feMnpQSCB2HGMhBizq3okKGq7I/c=;
        b=dZ8dO/UakmNEoJ0en9MpDEhEBIBKX1KCuWVoE+6Ph/GJhVsqdJMFomS1uOzK++iLaW
         V7Er30mpcDgJzml8oUxAiw5yJUt4zLKIzlkACMyywnlopPq94ehfak5kh471xINdhHA0
         Pn7hY+2cyNKFcXm9gt6qxfGjIxXlfM3LmLDEIhQjBjOTH+KWQiFVNHgD5rcYFSjvmAoK
         1CsLrc7X3+0XRzGLa+zw6qHf1J30he8vpwFsqz6aC3XbvJnmGMmJ2LiqEmcueXzlCNBB
         2C2aq267ekCdKFL88hBbCn+clnGXOcPz4jkRTqnTidb2lhiI662ofWwHitNYBXWdTmdY
         1Grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wwVTHx/uxqTNeI2feMnpQSCB2HGMhBizq3okKGq7I/c=;
        b=kXRWqZfSemtCFURI3ViggiigWRIO+4gtPR6PM/uitNtDGJKQqEriumKcUJGJEW0eSe
         71FZIJTrVOv7oHtsonWERptis3SMcc6Iqq68siLDtCD78rdJEBodRhuZW78U72ILYA1w
         MQ/5yE1N+ULOiCs6HtdxAJAxdfb/8XheHjuWn5A4aF6V58ILRLAXoIE7BpzmCryV9J0J
         FUl/+GJVydcWJZaQ44m9C6Ig13Rmgzq8dI+gVCHalTF60GkkRbGS8bPiPNfp8xjHo+Qk
         PjiY3Q2n13EFX+PmW10hJwx/Tk4C2p++zwWgBgMCFUCi++U0Z/bFsiDlx5Ltr8FwH/bD
         0BLA==
X-Gm-Message-State: APjAAAWllR/e8mKJgGUOqc+axNs9VS1IXaFhO/E5NHWw++/jZF83Mk0W
        r/S97kdU/tAlbZ6J/3W5r2e+Jp3i+NH/0A==
X-Google-Smtp-Source: APXvYqwlroVsE8JZ3T9J5JOAF8B98DIoVT00Z0C7stkGiAmKauZjtK60B3z8yb14qNlj72X9sb+08A==
X-Received: by 2002:a7b:c098:: with SMTP id r24mr200369wmh.8.1570466783225;
        Mon, 07 Oct 2019 09:46:23 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:22 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 03/29] crypto: x86/chacha - expose SIMD ChaCha routine as library function
Date:   Mon,  7 Oct 2019 18:45:44 +0200
Message-Id: <20191007164610.6881-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/chacha_glue.c | 90 ++++++++++++++------
 crypto/Kconfig                |  1 +
 include/crypto/chacha.h       |  6 ++
 3 files changed, 72 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 3a1a11a4326d..e50e6e7d0c38 100644
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
 
+void hchacha_block(const u32 *state, u32 *stream, int nrounds)
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
+EXPORT_SYMBOL(hchacha_block);
+
+void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init);
+
+void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		  int nrounds)
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
+EXPORT_SYMBOL(chacha_crypt);
+
 static int chacha_simd_stream_xor(struct skcipher_walk *walk,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -142,7 +179,7 @@ static int chacha_simd_stream_xor(struct skcipher_walk *walk,
 		if (nbytes < walk->total)
 			nbytes = round_down(nbytes, walk->stride);
 
-		if (!do_simd) {
+		if (!static_branch_likely(&chacha_use_simd) || !do_simd) {
 			chacha_crypt_generic(state, walk->dst.virt.addr,
 					     walk->src.virt.addr, nbytes,
 					     ctx->nrounds);
@@ -267,18 +304,21 @@ static struct skcipher_alg algs[] = {
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
index 86732709b171..3e5a6febc7ef 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1440,6 +1440,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 3b63cda7a994..2cc4031e3461 100644
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

