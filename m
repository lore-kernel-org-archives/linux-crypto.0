Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD11E24886C;
	Thu,  3 Apr 2025 09:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743673588; cv=none; b=MENeZZ/ToWQ6RjRuj8rhixET78Qj0cQV3+ogRynamHJgZ1s95RUQJsugvdP9CCwKDvhVVLtXH7uAb2X6cCM+eHynmPR8HViXIsrnNpc86a+ip5l1K/y/7BSyVPA9aYQyKiHqSZc9weY2VwoRAIWlYWP3+w3gfvLMiYrb+tQQpn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743673588; c=relaxed/simple;
	bh=xPrqXUFdcnsaL3wC5NMBB2R6jy8Us/tbBpApRrmKPEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRvaTP2I+wv/vKlThjREdfX0NQcTXqswtpDwXv8+nt0ZWzAUknWgOFm9VUxqC9edIp5VRwluG3Gvm+0ROoNqULd9CKo0Aerv1zVbokN0eQVgWsmfhguuvawFg0W+3A3ZvWPbFMeA5DuAiop7glZlfQAx52RcStXHuPYTJtXLnjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cufvKuY9; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cufvKuY9"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac29fd22163so114642366b.3;
        Thu, 03 Apr 2025 02:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743673585; x=1744278385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YufKWYm64t38L7ZFeMqs1RwdG11KTzwFDEJf5MFisfA=;
        b=cufvKuY9FxK7acMJycgfublq8c8jAPhrKK3GM7ugi5J2qthoVFzxKJFLA6mHtp3eFk
         2rRMX3tzoSbSlH4tdx/Jh5art8T1ctrI7LxM6yLgqzhRig0nKH20NU4kKAlCarwq0Vzo
         Ck3qWD1JfT7CwgKbnz5xOCKUx4/L3hBiRRilN/sfhXU8ci0Xyk1txXSqomW5a8Q1uFjk
         tblcVrM9PWx0DQJsRFt4oC4V5N3MukMUp0DwfH3ELlYYI3KRplzMNYe3UwqpVofb0BVk
         EmoWoZGejfWX7vflWdb76rYgd8kvoec/zt0H09Y/MkN+NfZLB3/CRaGy5zLdBYGThKqr
         j2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743673585; x=1744278385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YufKWYm64t38L7ZFeMqs1RwdG11KTzwFDEJf5MFisfA=;
        b=I9w+lhZe0VAIJdQHVwkoSGC8a6B4mo9y6cliD9HL/4PccydgrB/NxglFEG0+tsFC+6
         E+p9F788ZqjJCYmlbe6GH6m37bcyvbu0qhfB2IbbSaHat4AqkQ/3EdBPi/wsCZoiaBal
         TBYmNmC1dl5Rz47koPQPXy8oyiiL9SqwjqeUcMnNrmJaFnyJl0W/XnklzNr2ssaK0CCn
         OkVuuYN2CvEeg11/TbWPzbIXoCeG6aR8FyqM9BQMMOzkegkAyHjwhwCYKvAG4hpUCkFt
         DH51fpHUM0FKC1y2K0CbByKixm8f7eRvJTd3yIeflUXVjJqQ/nU3THqjCuksqbXwvRMB
         /w4w==
X-Forwarded-Encrypted: i=1; AJvYcCU0iHLGSxajaQnPZPDn0OYGk4Ru5cztcLTax29fFyMuL/VO5VR/KrK14G2yfk0NcGQlnVtKLRE/tlzKlck=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbpBCzIP7sJt9m8l8W3j1KDB5K6JJ3tL3mxVRNVQaQCWK2hZQE
	JONFl1QqAps5nJmp6uNWYiOljzuEAaPbiMZVx1Toc4V0AB5uIZtwxzmGePhU
X-Gm-Gg: ASbGncvnlT7PdBnJMFLhO/QS+eztzXoNO5MRLdjpE0yUp0oZg+gJYNvdOvB1dNyoi2b
	O+SGoR29iEb2XDcfkeKfDKSgfj84OP3mtFv6ngfU92BA8usVJYuSaNflwC36O+y5CAquNhAbA5F
	NrG0M4uMPjic2QVvF4KjRWKJF2Pa03ofVO7GP6VD93F55tI8gU0KwKhsFWYInAHCCTApdKvWY+k
	kK9ht5xrejSu1T9qVM4grQW4BgqkGwnnFwYw+sf63bdHPbopK2LhP+uUngt/3rHTx9iTsNIL/FF
	vibK4GfO3Dstu8Dc3yuXfKGlgUjjluyERPQpGmlBchQr8CU=
X-Google-Smtp-Source: AGHT+IGqkpBuCGUHorMsH+iIMRmDN8zo7NFMA/EpMPd7Ho7/gD5uTS1iANLJfadZSDiZ0rTAqNQ5Kg==
X-Received: by 2002:a17:907:9307:b0:ac6:d9fa:46c8 with SMTP id a640c23a62f3a-ac738be3abcmr1990951566b.39.1743673584463;
        Thu, 03 Apr 2025 02:46:24 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfeed008sm65054666b.85.2025.04.03.02.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 02:46:24 -0700 (PDT)
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
Subject: [PATCH 2/3] crypto: x86 - Remove CONFIG_AS_SHA256_NI
Date: Thu,  3 Apr 2025 11:44:40 +0200
Message-ID: <20250403094527.349526-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403094527.349526-1-ubizjak@gmail.com>
References: <20250403094527.349526-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.25,
which supports SHA-256 instruction mnemonics.

Remove check for assembler support of SHA-256 instructions
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
 arch/x86/Kconfig.assembler          |  4 ----
 arch/x86/crypto/Makefile            |  3 +--
 arch/x86/crypto/sha256_ssse3_glue.c | 10 ----------
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 70fe87bb1055..4d06fd3c8dfe 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -6,10 +6,6 @@ config AS_AVX512
 	help
 	  Supported by binutils >= 2.25 and LLVM integrated assembler
 
-config AS_SHA256_NI
-	def_bool $(as-instr,sha256msg1 %xmm0$(comma)%xmm1)
-	help
-	  Supported by binutils >= 2.24 and LLVM integrated assembler
 config AS_TPAUSE
 	def_bool $(as-instr,tpause %ecx)
 	help
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 97c1dbc3b7d6..e06b739176c9 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -59,8 +59,7 @@ obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ni_asm.o sha1_ssse3_glue.o
 
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
-sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
-sha256-ssse3-$(CONFIG_AS_SHA256_NI) += sha256_ni_asm.o
+sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ni_asm.o sha256_ssse3_glue.o
 
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index e04a43d9f7d5..429a3cefbab4 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -45,9 +45,7 @@ asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
 				       const u8 *data, int blocks);
 
 static const struct x86_cpu_id module_cpu_ids[] = {
-#ifdef CONFIG_AS_SHA256_NI
 	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
-#endif
 	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
@@ -329,7 +327,6 @@ static void unregister_sha256_avx2(void)
 				ARRAY_SIZE(sha256_avx2_algs));
 }
 
-#ifdef CONFIG_AS_SHA256_NI
 asmlinkage void sha256_ni_transform(struct sha256_state *digest,
 				    const u8 *data, int rounds);
 
@@ -403,11 +400,6 @@ static void unregister_sha256_ni(void)
 				ARRAY_SIZE(sha256_ni_algs));
 }
 
-#else
-static inline int register_sha256_ni(void) { return 0; }
-static inline void unregister_sha256_ni(void) { }
-#endif
-
 static int __init sha256_ssse3_mod_init(void)
 {
 	if (!x86_match_cpu(module_cpu_ids))
@@ -461,7 +453,5 @@ MODULE_ALIAS_CRYPTO("sha224");
 MODULE_ALIAS_CRYPTO("sha224-ssse3");
 MODULE_ALIAS_CRYPTO("sha224-avx");
 MODULE_ALIAS_CRYPTO("sha224-avx2");
-#ifdef CONFIG_AS_SHA256_NI
 MODULE_ALIAS_CRYPTO("sha256-ni");
 MODULE_ALIAS_CRYPTO("sha224-ni");
-#endif
-- 
2.49.0

