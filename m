Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55845FA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5D121848
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UHIb+UWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503386AbfJQTKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40056 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503380AbfJQTKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id o28so3588151wro.7
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AUoltb6iRwrhSEIPG0CZSg/o4Bl9tPnFU17hnSJB5ig=;
        b=UHIb+UWqyjZvOqbdI2xLWdlrybs3gRttjN9O+aiM3VehjzAAx3IT2jySwrtgnCU3L7
         I4TfBXvFzY0tU32cmEFLcUVRY1N567hxH0D7IHk6o2zQqClMHMkoColH92i+A4+0AYKr
         iZaqcdSEFQsFSpmg8dFb0Fa9fkK78/f548FKuJZ+1fKyE7++EhcUVBvDUJ/8xM+v56c0
         a11jKKcM2ViHYbsOiP5zktmw4nQKFDgW7v5Q48RnQK0DtI7k94QJpXElN5SxQj8e2x5J
         VLpLrP/P9SbNSjxhnUTWoYFUIuWu5m52VgThlf/05I1zegLBupC7Zor+7Zq4UJbF3f24
         365A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AUoltb6iRwrhSEIPG0CZSg/o4Bl9tPnFU17hnSJB5ig=;
        b=F3hIQ4DJTMHlLBdWh/iBHlqBUIKR/5KmVVdio2AXgUYrwwkZ41Di0iAGyrHt9rOKf4
         hzWVfGgQqiYZUx9vUL1ASdwBy+o+o5oXUjLXDepZdjFAbI0PZrPnCEPXMlXZl6K7nXJP
         XXGy70NzvYRwTqwqxO/GOAd0bFDql08nyKmPVmCIjJdUgZSLbjFY1tRcf9qUBoCvgu0l
         L81owbJ3kkDIA1z+n/7DAGMvs3PWcS2v9h9JMlAZLJJgdrP0WRho1G2XH73k4/NUN1I3
         42wUs2vvQ1YeuoBsDUhPHbLqngddM8xK3Hi/DNg2mXsu5CVyj97HIgsTRVwK+ESBQe7j
         z3Eg==
X-Gm-Message-State: APjAAAXt/mcUiiTqBjnuF5bKVRM1v9XZ0SR64RPbsbqvHdEzs480yTmg
        5lRJfJwLnhT87iqJIEDCDesQSrLuIf7BMEvn
X-Google-Smtp-Source: APXvYqxXvVqvZnFIGRpUZ87JOsUtR/08RwFmwmPNMFQyabBgzNWpKG8ZRbpL3jQWYoOifw3M28XgyQ==
X-Received: by 2002:adf:e747:: with SMTP id c7mr4363099wrn.384.1571339396697;
        Thu, 17 Oct 2019 12:09:56 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.09.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:09:55 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 04/35] crypto: x86/chacha - expose SIMD ChaCha routine as library function
Date:   Thu, 17 Oct 2019 21:09:01 +0200
Message-Id: <20191017190932.1947-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
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
 arch/x86/crypto/chacha_glue.c | 91 ++++++++++++++------
 crypto/Kconfig                |  1 +
 include/crypto/chacha.h       |  6 ++
 3 files changed, 73 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index a264dcc64679..b788260a1243 100644
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
@@ -258,18 +296,21 @@ static struct skcipher_alg algs[] = {
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
index 9da4b67ac8e2..4f7212fa0170 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1418,6 +1418,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 78cb9d549b1b..33034b69b087 100644
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

