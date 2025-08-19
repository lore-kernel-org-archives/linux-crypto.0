Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2861A3176F1;
	Tue, 19 Aug 2025 08:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755593963; cv=none; b=neelRd14l6rjCUM24dgCP1Nz5bGKqpFFBSMIyPXhXtMBGY+DBX95ZyE+Yy/yYLt8jTvzx1yr6HxplXdJhg1xGpUD+LOYbQyiZckTkBqu1uA2e7ibaOi72I+/Fye+9Syzn9spPY3oE2UrN4w9Yq+7bdfwZjscwbdXLkVPPPccJUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755593963; c=relaxed/simple;
	bh=l/59L3DFg+zbY4u95GvcBY+44hQSY5kmPWhulv2k4MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd3QRfPyZQrcSTMdU1qpRuxfOYlDYuDMxhEHNwCj1nQbxmWJmtwIarFOpev1fJNigRvJQyFv5jXn8KXq5P1IPArbDHrwGoXu3j83WE92uWSN7EQVoGZQX7V+jaMSILZuw5ZU1ytxbOUIRoVF2l1/JF73th7jah/bXw7UL4v9BJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akOrG1M5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akOrG1M5"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b04f8b5so25361055e9.1;
        Tue, 19 Aug 2025 01:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755593957; x=1756198757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2xOmcCWB8kNy+JTQ2tRnWmHZJzgpiQEdD2/3xegNjbU=;
        b=akOrG1M5nAAmoj+1bZhlSbyPHvKTgEpa6h7CwCmB/nGALoGJRZossIbmrPWsiit390
         0/gnrvOGrJICGRqMGeno1yTVYcfPHo/SeQl7+KEThypqAlYC4K1k66Smme03eQN1xb3A
         PFnNI6cJlX65TVyMEnhHKYOGUbIOlMUOkgCjrI9gt9FDGBIH0atWw/Ukl4+NwByO+mwr
         FUkTJRkXmRWLjd0flq3Ck5CiGaTvQvkD0TkunApvHWoYCppYC2unFugxtBU9E040EM7w
         af5QGjmskQSfFs91In/A1fqZe042qs+BuE6CGCHWE8ZF6YXSh/W7U7J1yPcdXNOWrhq9
         z0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593957; x=1756198757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2xOmcCWB8kNy+JTQ2tRnWmHZJzgpiQEdD2/3xegNjbU=;
        b=vW8il70PnHwWS6ie+prXJ5G7cY/YObpTym6e1pMVZV6PbaRwvHNvap2LHihym2Dytv
         8BFN/7+JAqf2lsqmWMfem7X0kK3VbY3iqPE8MJmc5oSyl8Wee8epNZLSgevlIsji7Ywp
         XNjVmSwHLPk4EQz/trgt+8SHx61os5IXYhusTQnHP4b1LJ9D2OksXvzjuDNGZQtrlhK3
         8n9blF6/iBGcPaNy6J5s3X2E2YwbS3rjW3eiVx6mKk1dgrHPC8uOX7u3NpRX2hm0fOYi
         wMgHRGv09AA+lnH5atz7C47Z3Ho2KKCpPWOELO+H6Fv0wSNSItdgmraK0ynAKlXHtfTd
         oiVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0KtLDBA30eyBEXghB4YGHMgJRQCY08oUjNbZj37zZ2iq3/vpPIIyWBA8TckXpEXTRNoBMSgWhumv6Xqc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEBQGScXVxcAifAnNqrj4JlnWvHvITZNRDSgibDY9DIhSp4KOt
	gIsd8Gj2fSqtk2VNC7goIn8x/nUCYU93ef9s2MccWAt8/pLAMHroBv6WMjNMNg==
X-Gm-Gg: ASbGncs26L9R4Jsgd7YXZJfN+o4pJ2RCRSljQx8F67ouMaa9qly3iZKlj2F73QwJuC6
	0O0a7eU2EQ9CNzFzlHuxVsfHgAvQpj+BeVqLhIL0QffuBeo9BUKkpUxaVCxnSvzLQ5M03XNwn+r
	d6sEYbaOj93GhscuFtonwARs10Iy/jxRZO2NzXasg0Xz6k+Jv+H0ocvdS4i/zL1sxwOxMHjGy7U
	4ysz1KsyUoh01zMiXV4vI+McErR1eKU9/vkg+2IeID09JONiI2FS2nd6xh+J0tAR4/Wnzs1vmEM
	nyLw5/WZlR5PtEbbOyeG1Vh/XbQ4LVbSLMd8r52phLfS3nD7JnMSnds2eKEtRYU3gNEa5yLcRTc
	cXDsWQ0tNxhUmApxqCB6pWg==
X-Google-Smtp-Source: AGHT+IGQ7eVBn1vWt3pM5FjkNp7G0KASttNLZNgOc3stCR/qfzuNFfUIt1tyyEoaXLRGx5+oE1UNcg==
X-Received: by 2002:a05:6000:178b:b0:3b7:6804:9362 with SMTP id ffacd0b85a97d-3c0ea0e9b45mr1266034f8f.26.1755593957293;
        Tue, 19 Aug 2025 01:59:17 -0700 (PDT)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c166bsm2819758f8f.33.2025.08.19.01.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 01:59:16 -0700 (PDT)
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
Subject: [PATCH 2/4] crypto:x86 - Remove CONFIG_AS_VAES
Date: Tue, 19 Aug 2025 10:57:50 +0200
Message-ID: <20250819085855.333380-2-ubizjak@gmail.com>
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
which supports VAES instruction mnemonics.

Remove check for assembler support of VAES instructions
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
 arch/x86/crypto/Makefile             |  2 +-
 arch/x86/crypto/aes-ctr-avx-x86_64.S |  4 ++--
 arch/x86/crypto/aes-xts-avx-x86_64.S |  4 ++--
 arch/x86/crypto/aesni-intel_glue.c   | 14 +++++++-------
 5 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 6b95be002465..8d1808407674 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -6,11 +6,6 @@ config AS_AVX512
 	help
 	  Supported by binutils >= 2.25 and LLVM integrated assembler
 
-config AS_VAES
-	def_bool $(as-instr,vaesenc %ymm0$(comma)%ymm1$(comma)%ymm2)
-	help
-	  Supported by binutils >= 2.30 and LLVM integrated assembler
-
 config AS_VPCLMULQDQ
 	def_bool $(as-instr,vpclmulqdq \$0x10$(comma)%ymm0$(comma)%ymm1$(comma)%ymm2)
 	help
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index aa289a9e0153..c08eff1e83a7 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -47,7 +47,7 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 			       aes-gcm-aesni-x86_64.o \
 			       aes-xts-avx-x86_64.o
-ifeq ($(CONFIG_AS_VAES)$(CONFIG_AS_VPCLMULQDQ),yy)
+ifeq ($(CONFIG_AS_VPCLMULQDQ),y)
 aesni-intel-$(CONFIG_64BIT) += aes-gcm-avx10-x86_64.o
 endif
 
diff --git a/arch/x86/crypto/aes-ctr-avx-x86_64.S b/arch/x86/crypto/aes-ctr-avx-x86_64.S
index bbbfd80f5a50..ec957b25b062 100644
--- a/arch/x86/crypto/aes-ctr-avx-x86_64.S
+++ b/arch/x86/crypto/aes-ctr-avx-x86_64.S
@@ -552,7 +552,7 @@ SYM_TYPED_FUNC_START(aes_xctr_crypt_aesni_avx)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_aesni_avx)
 
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 .set	VL, 32
 .set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx2)
@@ -570,4 +570,4 @@ SYM_FUNC_END(aes_ctr64_crypt_vaes_avx512)
 SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx512)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_vaes_avx512)
-#endif // CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ
+#endif // CONFIG_AS_VPCLMULQDQ
diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index db79cdf81588..e44e56817d82 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -886,7 +886,7 @@ SYM_TYPED_FUNC_START(aes_xts_decrypt_aesni_avx)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_aesni_avx)
 
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 .set	VL, 32
 .set	USE_AVX512, 0
 SYM_TYPED_FUNC_START(aes_xts_encrypt_vaes_avx2)
@@ -904,4 +904,4 @@ SYM_FUNC_END(aes_xts_encrypt_vaes_avx512)
 SYM_TYPED_FUNC_START(aes_xts_decrypt_vaes_avx512)
 	_aes_xts_crypt	0
 SYM_FUNC_END(aes_xts_decrypt_vaes_avx512)
-#endif /* CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ */
+#endif /* CONFIG_AS_VPCLMULQDQ */
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 061b1ced93c5..d5a2f5b2c01b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -828,7 +828,7 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
 }}
 
 DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx2, "vaes-avx2", 600);
 DEFINE_AVX_SKCIPHER_ALGS(vaes_avx512, "vaes-avx512", 800);
 #endif
@@ -912,7 +912,7 @@ struct aes_gcm_key_avx10 {
 #define FLAG_RFC4106	BIT(0)
 #define FLAG_ENC	BIT(1)
 #define FLAG_AVX	BIT(2)
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 #  define FLAG_AVX10_256	BIT(3)
 #  define FLAG_AVX10_512	BIT(4)
 #else
@@ -1519,7 +1519,7 @@ DEFINE_GCM_ALGS(aesni_avx, FLAG_AVX,
 		"generic-gcm-aesni-avx", "rfc4106-gcm-aesni-avx",
 		AES_GCM_KEY_AESNI_SIZE, 500);
 
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 /* aes_gcm_algs_vaes_avx10_256 */
 DEFINE_GCM_ALGS(vaes_avx10_256, FLAG_AVX10_256,
 		"generic-gcm-vaes-avx10_256", "rfc4106-gcm-vaes-avx10_256",
@@ -1529,7 +1529,7 @@ DEFINE_GCM_ALGS(vaes_avx10_256, FLAG_AVX10_256,
 DEFINE_GCM_ALGS(vaes_avx10_512, FLAG_AVX10_512,
 		"generic-gcm-vaes-avx10_512", "rfc4106-gcm-vaes-avx10_512",
 		AES_GCM_KEY_AVX10_SIZE, 800);
-#endif /* CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ */
+#endif /* CONFIG_AS_VPCLMULQDQ */
 
 static int __init register_avx_algs(void)
 {
@@ -1551,7 +1551,7 @@ static int __init register_avx_algs(void)
 	 * Similarly, the assembler support was added at about the same time.
 	 * For simplicity, just always check for VAES and VPCLMULQDQ together.
 	 */
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
 	    !boot_cpu_has(X86_FEATURE_VAES) ||
 	    !boot_cpu_has(X86_FEATURE_VPCLMULQDQ) ||
@@ -1592,7 +1592,7 @@ static int __init register_avx_algs(void)
 				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_512));
 	if (err)
 		return err;
-#endif /* CONFIG_AS_VAES && CONFIG_AS_VPCLMULQDQ */
+#endif /* CONFIG_AS_VPCLMULQDQ */
 	return 0;
 }
 
@@ -1607,7 +1607,7 @@ static void unregister_avx_algs(void)
 {
 	unregister_skciphers(skcipher_algs_aesni_avx);
 	unregister_aeads(aes_gcm_algs_aesni_avx);
-#if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
+#if defined(CONFIG_AS_VPCLMULQDQ)
 	unregister_skciphers(skcipher_algs_vaes_avx2);
 	unregister_skciphers(skcipher_algs_vaes_avx512);
 	unregister_aeads(aes_gcm_algs_vaes_avx10_256);
-- 
2.50.1

