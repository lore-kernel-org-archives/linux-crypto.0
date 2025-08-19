Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A93176EE;
	Tue, 19 Aug 2025 08:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755593963; cv=none; b=P8psTRm+kruagauK1tJR1d/f28virGpVXhAakeC4HiibJFQ06UkFC9ZARUTIZBdnQcdKmfrGiY5uhKHQvH8dxO5oZyp4UaQnnH/gXCg0zxiMM98mjWuevcOpEGp/MFDve4pI6O7yT9QWCBfp21dU8xtbBkE9g8v0gqXWo0nQNL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755593963; c=relaxed/simple;
	bh=u8o2O5nDbA+YawSFWKI7OOLmT0dTbfNM0/06QZCkf8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHjiuM5uKGC+5AiD0Ics7L5r22orYEk2XQeHqPYL0V2RIbsAOlSW+e17BWWn8x1YIMLf3Ciis+WEKPx57xkgSBqzrj7zsf8EGViVHsW01a7jZBIv9fTn5/TIDbP8hBZ2ekkpnitlTjRbIEttmxV9Inj/VQVAgC3dEjJk2iuGers=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O0vSiU0R; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0vSiU0R"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b0bd237so40285245e9.2;
        Tue, 19 Aug 2025 01:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755593959; x=1756198759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5JfnzftSpCK5+Y17iw9EJ/6V8BotfR0MyR4qnrJZa0Y=;
        b=O0vSiU0RcQY8qDdVv3TixAsIOX8H7mDwOj1R/vptuIx0LiDfXoPzXMylEJTNDkht3f
         Xyrg8fHyQx3kS9p5o0bu+fWJFp8NQpvJHcugHTBwfO+6ns+6kPUuTcdC+xFu/Ui+PDe9
         99PxuqDw/fMJ9PTTIHu8LGOA6FiLYiIQzhiRHYvkoCOcWq+EmDwPK+OvBbLnkkCZJab1
         n/10QUW8CmtLu3Bj9I7mkOMuJ+A0sBXFdCt5osf/CtATP0B1JJkWm9oen9zgNF53+CZN
         XQosMH0r//kWZohCT2gFuyDa/J21wukQNHxrHSZBdOGvWh5aeP25c6JX3g3WJ8TmKWDs
         KHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593959; x=1756198759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5JfnzftSpCK5+Y17iw9EJ/6V8BotfR0MyR4qnrJZa0Y=;
        b=iRwKDGX/G2BY2flkcRh6OFY3htvTnETMM7enqUpPI5m6MzOwDBME2XVBzxaEwwk6KY
         Olnu2D2BRBb93ph1pftJM/255NdXdZ7o6FgOfL9u/0AiThq+q9Nz6QhKgtKICQbyrwJC
         7EJdaPrtpks8qMT8CKwwnuSHDw9PtJqKx5MzH2yu63Fkkm4R2NjXTl1OWxR/JOUcAStR
         hU+0ipJKRliosI4Avn8Qyvm86SIc/9t8+D45LAxvQlVK5n4YLKiCWzXJe/3eGg8vVpU1
         +irVfGYrfSupIElLtyDVW+6LRb+X96Cw0/Wm/WDVDcOcPySLnkXu4BKKAXAkw6mIz2Hr
         SEyg==
X-Forwarded-Encrypted: i=1; AJvYcCXdWaIHkra9rJIXup44MOhMLUZ7qNo2GwBOohqD7hKGs5QlI2cQxUqvfScLWbefQRcV+tzl+OxQ/esfHAI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPbU9iCXV4nGyH6FaqBS59yhbwFxUK6rXvrHgZH1OMXY1D3gRx
	SoapQryEY5fZXIeeJPNIUwFwrb/ZK3kL/4m2/IAvOM9pcd270rNElkqB6dHAew==
X-Gm-Gg: ASbGncuOVLbfQvJVIiE6OKpyab8vYJ05TF3MKbGfPU+hOaUb9KZVtM8gVmw5ZW1gXfR
	syVxAHcai9pGxVmlZ97lOfEyV6+e8CHjO1Sp64pwcGXx6fSE6R6hAXKgNBeuOYtPhcJuzKPpq3z
	X6ujaExQYrwQq28KkfTMIttlwBK5V4jKvoYownfJs/GfYL/CF8g2H1aPxsYL99cQGK//cM9Kd95
	VGjRVoTYPmgTMKlUpxupH7oP4uz8+gF0aYwTtMVZ8u8j6GTESlSN7C31HkIo8/r4j5DQRKAPFMZ
	D/+MJcMTts9kyyWtA0tMpLfPjtQ8Z+o6yO4kUrjPYJAu4ReXsm1IWqC7a9YFDgJ72a/lvucd5j/
	67Ch+C66j+08Knmp54WbHRQ==
X-Google-Smtp-Source: AGHT+IFAJMMooURz3GQFCjKG+hXNb5a8DvQSoN3zM5fgqtX6X3q0Rb5hspEQpkn1C9NSpM6bSorEbQ==
X-Received: by 2002:a05:600c:1c06:b0:459:ddd6:1cc7 with SMTP id 5b1f17b1804b1-45b443be6cbmr14252285e9.0.1755593958876;
        Tue, 19 Aug 2025 01:59:18 -0700 (PDT)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c166bsm2819758f8f.33.2025.08.19.01.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 01:59:17 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] crypto:x86 - Remove CONFIG_AS_VPCLMULQDQ
Date: Tue, 19 Aug 2025 10:57:51 +0200
Message-ID: <20250819085855.333380-3-ubizjak@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819085855.333380-1-ubizjak@gmail.com>
References: <20250819085855.333380-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.30,
which supports VPCLMULQDQ instruction mnemonics.

Remove check for assembler support of VPCLMULQDQ instructions
and all relevant macros for conditional compilation.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig.assembler           |  5 -----
 arch/x86/crypto/Makefile             |  6 ++----
 arch/x86/crypto/aes-ctr-avx-x86_64.S |  2 --
 arch/x86/crypto/aes-xts-avx-x86_64.S |  2 --
 arch/x86/crypto/aesni-intel_glue.c   | 22 +++-------------------
 5 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 8d1808407674..ea0e9dfdfc5c 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -6,11 +6,6 @@ config AS_AVX512
 	help
 	  Supported by binutils >= 2.25 and LLVM integrated assembler
 
-config AS_VPCLMULQDQ
-	def_bool $(as-instr,vpclmulqdq \$0x10$(comma)%ymm0$(comma)%ymm1$(comma)%ymm2)
-	help
-	  Supported by binutils >= 2.30 and LLVM integrated assembler
-
 config AS_WRUSS
 	def_bool $(as-instr64,wrussq %rax$(comma)(%rbx))
 	help
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index c08eff1e83a7..320508be9a37 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -46,10 +46,8 @@ obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 			       aes-gcm-aesni-x86_64.o \
-			       aes-xts-avx-x86_64.o
-ifeq ($(CONFIG_AS_VPCLMULQDQ),y)
-aesni-intel-$(CONFIG_64BIT) += aes-gcm-avx10-x86_64.o
-endif
+			       aes-xts-avx-x86_64.o \
+			       aes-gcm-avx10-x86_64.o
 
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ni_asm.o sha1_ssse3_glue.o
diff --git a/arch/x86/crypto/aes-ctr-avx-x86_64.S b/arch/x86/crypto/aes-ctr-avx-x86_64.S
index ec957b25b062..2745918f68ee 100644
--- a/arch/x86/crypto/aes-ctr-avx-x86_64.S
+++ b/arch/x86/crypto/aes-ctr-avx-x86_64.S
@@ -552,7 +552,6 @@ SYM_TYPED_FUNC_START(aes_xctr_crypt_aesni_avx)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_aesni_avx)
 
-#if defined(CONFIG_AS_VPCLMULQDQ)
 .set	VL, 32
 .set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx2)
@@ -570,4 +569,3 @@ SYM_FUNC_END(aes_ctr64_crypt_vaes_avx512)
 SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx512)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_vaes_avx512)
-#endif // CONFIG_AS_VPCLMULQDQ
diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index e44e56817d82..a30753a3e207 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -886,7 +886,6 @@ SYM_TYPED_FUNC_START(aes_xts_decrypt_aesni_avx)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_aesni_avx)
 
-#if defined(CONFIG_AS_VPCLMULQDQ)
 .set	VL, 32
 .set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx2)
@@ -904,4 +903,3 @@ SYM_FUNC_END(aes_xts_encrypt_vaes_avx512)
 SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx512)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_vaes_avx512)
-#endif /* CONFIG_AS_VPCLMULQDQ */
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index d5a2f5b2c01b..d953ac470aae 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -828,10 +828,8 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
 }}
 
 DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
-#if defined(CONFIG_AS_VPCLMULQDQ)
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx2, "vaes-avx2", 600);
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx512, "vaes-avx512", 800);
-#endif
 
 /* The common part of the x86_64 AES-GCM key struct */
 struct aes_gcm_key {
@@ -912,17 +910,8 @@ struct aes_gcm_key_avx10 {
 #define FLAG_RFC4106	BIT(0)
 #define FLAG_ENC	BIT(1)
 #define FLAG_AVX	BIT(2)
-#if defined(CONFIG_AS_VPCLMULQDQ)
-#  define FLAG_AVX10_256	BIT(3)
-#  define FLAG_AVX10_512	BIT(4)
-#else
-   /*
-    * This should cause all calls to the AVX10 assembly functions to be
-    * optimized out, avoiding the need to ifdef each call individually.
-    */
-#  define FLAG_AVX10_256	0
-#  define FLAG_AVX10_512	0
-#endif
+#define FLAG_AVX10_256	BIT(3)
+#define FLAG_AVX10_512	BIT(4)
 
 static inline struct aes_gcm_key *
 aes_gcm_key_get(struct crypto_aead *tfm, int flags)
@@ -1519,7 +1508,6 @@ DEFINE_GCM_ALGS(aesni_avx, FLAG_AVX,
 		"generic-gcm-aesni-avx", "rfc4106-gcm-aesni-avx",
 		AES_GCM_KEY_AESNI_SIZE, 500);
 
-#if defined(CONFIG_AS_VPCLMULQDQ)
 /* aes_gcm_algs_vaes_avx10_256 */
 DEFINE_GCM_ALGS(vaes_avx10_256, FLAG_AVX10_256,
 		"generic-gcm-vaes-avx10_256", "rfc4106-gcm-vaes-avx10_256",
@@ -1529,7 +1517,6 @@ DEFINE_GCM_ALGS(vaes_avx10_256, FLAG_AVX10_256,
 DEFINE_GCM_ALGS(vaes_avx10_512, FLAG_AVX10_512,
 		"generic-gcm-vaes-avx10_512", "rfc4106-gcm-vaes-avx10_512",
 		AES_GCM_KEY_AVX10_SIZE, 800);
-#endif /* CONFIG_AS_VPCLMULQDQ */
 
 static int __init register_avx_algs(void)
 {
@@ -1551,7 +1538,6 @@ static int __init register_avx_algs(void)
 	 * Similarly, the assembler support was added at about the same time.
 	 * For simplicity, just always check for VAES and VPCLMULQDQ together.
 	 */
-#if defined(CONFIG_AS_VPCLMULQDQ)
 	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
 	    !boot_cpu_has(X86_FEATURE_VAES) ||
 	    !boot_cpu_has(X86_FEATURE_VPCLMULQDQ) ||
@@ -1592,7 +1578,7 @@ static int __init register_avx_algs(void)
 				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512));
 	if (err)
 		return err;
-#endif /* CONFIG_AS_VPCLMULQDQ */
+
 	return 0;
 }
 
@@ -1607,12 +1593,10 @@ static void unregister_avx_algs(void)
 {
 	unregister_skciphers(skcipher_algs_aesni_avx);
 	unregister_aeads(aes_gcm_algs_aesni_avx);
-#if defined(CONFIG_AS_VPCLMULQDQ)
 	unregister_skciphers(skcipher_algs_vaes_avx2);
 	unregister_skciphers(skcipher_algs_vaes_avx512);
 	unregister_aeads(aes_gcm_algs_vaes_avx10_256);
 	unregister_aeads(aes_gcm_algs_vaes_avx10_512);
-#endif
 }
 #else /* CONFIG_X86_64 */
 static struct aead_alg aes_gcm_algs_aesni[0];
-- 
2.50.1

