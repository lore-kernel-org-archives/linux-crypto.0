Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E0F26C39B;
	Tue, 19 Aug 2025 08:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755593960; cv=none; b=LQTS54KhjX8F6jzHkrlMxnPPp7gxrjhu3CasY7jgyAu44rkVoWq6xlzBHNhIr8O41AehLLSH3bOpEOkUbPFZ2jQ/DdxYEVkhf80TfWC/rT1qA5W0efdkzoQcnfzBe1PbMt7C3teA2CcyVngfG9dyEL9jeVs2ByfxzTrbPHMyLDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755593960; c=relaxed/simple;
	bh=chAu0GrhkcxCxA1sjWn/UMxVrM7ztLgeRUboRQUR8tA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QAAHu3moappjOwkxSRxchLfTFP246/7x2w/H2jZjGQO86z+9kC26F3G6YS7eMvIe/r3WQzOzzjUkCjTEVlnlRKmkWpoCDcugC6lEieuiKzo8VeN6P8ALe6MrCJaxLqClFMNa9qpjPd+PEGz8990WSTGHNdHFYGdA2OgbmzCoRLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cz5tXPVT; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cz5tXPVT"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b0c52f3so24506185e9.3;
        Tue, 19 Aug 2025 01:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755593956; x=1756198756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gXjafq9CYDnqKVKuVRURPdCwd6IUn/LDjZM2NDTFeLo=;
        b=Cz5tXPVTW0mrTb1gQXRJkTZYzQBUFTfb/ZP2i56INBtTigKxfFLKheFZ6oPtaYC3wu
         dijNPobhnZx2dyq0tpbLUjF0UQNEG3W4wYduoryfoUgqz8NtxGOuTz774lyYJU842WkF
         SolHOt1cusxgfHBDF3Ku1J26JJiZxvmoQmtF674XJEBGxCnR1yAhqqBM0f46aTA+cPz4
         rx/gBnt3tolR1WFXQaPCMls3SMj9Cz6bGK12lKnT98RLCRml6PEMIHaDt9XfcKcVscvX
         qiitIHuT4KjG19V9I0Dd7joAx56HXqBw1n/gtpcOoj0H9LqploG0xfsqG8bC4oMlMw8G
         m7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593956; x=1756198756;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXjafq9CYDnqKVKuVRURPdCwd6IUn/LDjZM2NDTFeLo=;
        b=qiXF7Nn+mblMTNi6nmFnZLon98phG68PzrDntmxurjZZ6/1PCEfUrJ3aT2IrcfdBoD
         A2Bw060ZOLfYgFwJnDBorxpSutZSo4WXsJim8brnm6ErVVzubG6gatntp0UIFEM6qbX7
         Z4wfsf/70NkA6nL+KuIjnV7PRIrAQi8QV1hZKWeDyuh5yrxbhXAeKzdxBPcWOmoyRmN0
         wRJme8RIARM05wIaPCR5pRhZ2i4N6Ui4g/rN7bW0k4lST+fLiJ4tof/SqXiYqhmZ/Blp
         oJzEipCJD6mB4+paOCXpJy8KFXXGzD+3JKp3YDqQAHtoB4ErJ8yYcYavey7wTDsU7w3V
         wy2g==
X-Forwarded-Encrypted: i=1; AJvYcCVITXlAyYsAzJHoz07A00euzfh14nSiGmyzXlK6ACpfDxys6QYVL8ZVO5Iq5v4mMHYaKPlJb4jAUIIU6ag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsFD+ZKpZlqSA5gVfjrTwSYtes9sLkFMXUgrYMQL60vwQ/pUIS
	SOPua3XKZO6GyaEyQ3JpTX4SIm3+ul+3pZDmHFeHmNUJSefA3bhnKBYeu8GCXA==
X-Gm-Gg: ASbGnctk4oMnaqa+oJFMF+qIes6Y/PBqjCjhywQZ7X9snVdU4fn01o0GtAeGo0OY/nZ
	OfWG/8SsyxvYXdvSJyAcBpTO5BHEwqSc05YOBh6MPMvAdXyUX9cAO8A0MTchXnpnnJ7/xZK+Xvy
	yx6oaOk5A+BleLqaXZIwF/M5BcOiBkWSv7O+PmZOviNwy3Gfliv4QX6x/nCGEWhEMsT+P9AQdWq
	BZQRfmprqI7dziOgVYglrKgVq1HTmR0jYb8EW7u/GE9VzUNzcwRCY5+RCDXN/B3trrkXYBAUiCt
	h/zI5irNWLdpjITz+D6p7lqagARzlhRU94UWmBPDHaQD5ZeqT6NNy5mPy8a9OtktBtyHpa6WzVO
	HlD5TXraAAMh+9I5mRi4alg==
X-Google-Smtp-Source: AGHT+IE4KHn9EHm3mjx//o39RtWN+GC7s80yVecrd+nrZ/3d1NrIMw+5D4d+Rsz69I4lFrFa1/fPOA==
X-Received: by 2002:a05:6000:178b:b0:3b7:6804:9362 with SMTP id ffacd0b85a97d-3c0ea0e9b45mr1265963f8f.26.1755593955715;
        Tue, 19 Aug 2025 01:59:15 -0700 (PDT)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c166bsm2819758f8f.33.2025.08.19.01.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 01:59:15 -0700 (PDT)
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
Subject: [PATCH 1/4] crypto:x86 - Remove CONFIG_AS_GFNI
Date: Tue, 19 Aug 2025 10:57:49 +0200
Message-ID: <20250819085855.333380-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.30,
which supports GFNI instruction mnemonics.

Remove check for assembler support of GFNI instructions
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
 arch/x86/Kconfig.assembler               |  5 -----
 arch/x86/crypto/Kconfig                  |  2 +-
 arch/x86/crypto/aria-aesni-avx-asm_64.S  | 10 ----------
 arch/x86/crypto/aria-aesni-avx2-asm_64.S | 10 +---------
 arch/x86/crypto/aria_aesni_avx2_glue.c   |  4 +---
 arch/x86/crypto/aria_aesni_avx_glue.c    |  4 +---
 6 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index c827f694fb72..6b95be002465 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -6,11 +6,6 @@ config AS_AVX512
 	help
 	  Supported by binutils >= 2.25 and LLVM integrated assembler
 
-config AS_GFNI
-	def_bool $(as-instr,vgf2p8mulb %xmm0$(comma)%xmm1$(comma)%xmm2)
-	help
-	  Supported by binutils >= 2.30 and LLVM integrated assembler
-
 config AS_VAES
 	def_bool $(as-instr,vaesenc %ymm0$(comma)%ymm1$(comma)%ymm2)
 	help
diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 56cfdc79e2c6..e35f4cd7071d 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -319,7 +319,7 @@ config CRYPTO_ARIA_AESNI_AVX2_X86_64
 
 config CRYPTO_ARIA_GFNI_AVX512_X86_64
 	tristate "Ciphers: ARIA with modes: ECB, CTR (AVX512/GFNI)"
-	depends on 64BIT && AS_GFNI
+	depends on 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ALGAPI
 	select CRYPTO_ARIA
diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index 9556dacd9841..932fb17308e7 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -295,7 +295,6 @@
 	vpshufb t1, t0, t2;				\
 	vpxor t2, x7, x7;
 
-#ifdef CONFIG_AS_GFNI
 #define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
@@ -318,8 +317,6 @@
 	vgf2p8affineinvqb $0, t2, x3, x3;		\
 	vgf2p8affineinvqb $0, t2, x7, x7
 
-#endif /* CONFIG_AS_GFNI */
-
 #define aria_sbox_8way(x0, x1, x2, x3,            	\
 		       x4, x5, x6, x7,			\
 		       t0, t1, t2, t3,			\
@@ -561,7 +558,6 @@
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
 
-#ifdef CONFIG_AS_GFNI
 #define aria_fe_gfni(x0, x1, x2, x3,			\
 		     x4, x5, x6, x7,			\
 		     y0, y1, y2, y3,			\
@@ -719,8 +715,6 @@
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
 
-#endif /* CONFIG_AS_GFNI */
-
 /* NB: section is mergeable, all elements must be aligned 16-byte blocks */
 .section	.rodata.cst16, "aM", @progbits, 16
 .align 16
@@ -772,7 +766,6 @@
 .Ltf_hi__x2__and__fwd_aff:
 	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
 
-#ifdef CONFIG_AS_GFNI
 /* AES affine: */
 #define tf_aff_const BV8(1, 1, 0, 0, 0, 1, 1, 0)
 .Ltf_aff_bitmatrix:
@@ -871,7 +864,6 @@
 		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
-#endif /* CONFIG_AS_GFNI */
 
 /* 4-bit mask */
 .section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
@@ -1140,7 +1132,6 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_ctr_crypt_16way)
 
-#ifdef CONFIG_AS_GFNI
 SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 	/* input:
 	*      %r9: rk
@@ -1359,4 +1350,3 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_ctr_crypt_16way)
-#endif /* CONFIG_AS_GFNI */
diff --git a/arch/x86/crypto/aria-aesni-avx2-asm_64.S b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
index c60fa2980630..ed53d4f46bd7 100644
--- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
@@ -302,7 +302,6 @@
 	vpbroadcastb ((round * 16) + idx + 4)(rk), t0;	\
 	vpxor t0, x7, x7;
 
-#ifdef CONFIG_AS_GFNI
 #define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
@@ -325,7 +324,6 @@
 	vgf2p8affineinvqb $0, t2, x3, x3;		\
 	vgf2p8affineinvqb $0, t2, x7, x7
 
-#endif /* CONFIG_AS_GFNI */
 #define aria_sbox_8way(x0, x1, x2, x3,			\
 		       x4, x5, x6, x7,			\
 		       t0, t1, t2, t3,			\
@@ -598,7 +596,7 @@
 	aria_load_state_8way(y0, y1, y2, y3,		\
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
-#ifdef CONFIG_AS_GFNI
+
 #define aria_fe_gfni(x0, x1, x2, x3,			\
 		     x4, x5, x6, x7,			\
 		     y0, y1, y2, y3,			\
@@ -752,7 +750,6 @@
 	aria_load_state_8way(y0, y1, y2, y3,		\
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
-#endif /* CONFIG_AS_GFNI */
 
 .section        .rodata.cst32.shufb_16x16b, "aM", @progbits, 32
 .align 32
@@ -806,7 +803,6 @@
 .Ltf_hi__x2__and__fwd_aff:
 	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
 
-#ifdef CONFIG_AS_GFNI
 .section	.rodata.cst8, "aM", @progbits, 8
 .align 8
 /* AES affine: */
@@ -868,8 +864,6 @@
 		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
 
-#endif /* CONFIG_AS_GFNI */
-
 /* 4-bit mask */
 .section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
 .align 4
@@ -1219,7 +1213,6 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_ctr_crypt_32way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_ctr_crypt_32way)
 
-#ifdef CONFIG_AS_GFNI
 SYM_FUNC_START_LOCAL(__aria_aesni_avx2_gfni_crypt_32way)
 	/* input:
 	 *      %r9: rk
@@ -1438,4 +1431,3 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_ctr_crypt_32way)
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)
-#endif /* CONFIG_AS_GFNI */
diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index 007b250f774c..1487a49bfbac 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -26,7 +26,6 @@ asmlinkage void aria_aesni_avx2_ctr_crypt_32way(const void *ctx, u8 *dst,
 						const u8 *src,
 						u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_ctr_crypt_32way);
-#ifdef CONFIG_AS_GFNI
 asmlinkage void aria_aesni_avx2_gfni_encrypt_32way(const void *ctx, u8 *dst,
 						   const u8 *src);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_gfni_encrypt_32way);
@@ -37,7 +36,6 @@ asmlinkage void aria_aesni_avx2_gfni_ctr_crypt_32way(const void *ctx, u8 *dst,
 						     const u8 *src,
 						     u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_gfni_ctr_crypt_32way);
-#endif /* CONFIG_AS_GFNI */
 
 static struct aria_avx_ops aria_ops;
 
@@ -213,7 +211,7 @@ static int __init aria_avx2_init(void)
 		return -ENODEV;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_GFNI) && IS_ENABLED(CONFIG_AS_GFNI)) {
+	if (boot_cpu_has(X86_FEATURE_GFNI)) {
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index 4c88ef4eba82..e4e3d78915a5 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -26,7 +26,6 @@ asmlinkage void aria_aesni_avx_ctr_crypt_16way(const void *ctx, u8 *dst,
 					       const u8 *src,
 					       u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx_ctr_crypt_16way);
-#ifdef CONFIG_AS_GFNI
 asmlinkage void aria_aesni_avx_gfni_encrypt_16way(const void *ctx, u8 *dst,
 						  const u8 *src);
 EXPORT_SYMBOL_GPL(aria_aesni_avx_gfni_encrypt_16way);
@@ -37,7 +36,6 @@ asmlinkage void aria_aesni_avx_gfni_ctr_crypt_16way(const void *ctx, u8 *dst,
 						    const u8 *src,
 						    u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx_gfni_ctr_crypt_16way);
-#endif /* CONFIG_AS_GFNI */
 
 static struct aria_avx_ops aria_ops;
 
@@ -199,7 +197,7 @@ static int __init aria_avx_init(void)
 		return -ENODEV;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_GFNI) && IS_ENABLED(CONFIG_AS_GFNI)) {
+	if (boot_cpu_has(X86_FEATURE_GFNI)) {
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
-- 
2.50.1

