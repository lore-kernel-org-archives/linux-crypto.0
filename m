Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C8A13DDAE;
	Fri,  4 Apr 2025 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743752505; cv=none; b=d5IWXFc/nkOA4m3bEUVQkjb1M5AKo79j+KOcSrMtn+7qXSyLE6i1PkiDtvt6yGvCFG0HjgWiCsU7jpUHfo97j3YrnQxXOfRobR/9lzjrvd/0I5pB+Nfqhi5Ys5wVleGse4BP6Lwckgzol67y9TaZVcBYUwAkpPIaYqT4G44/bbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743752505; c=relaxed/simple;
	bh=nCdrSPEwfHmckB0A3LMnC+8HMuE5B1ZJit5/MiMABxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zmika6URLGIV64u20wOTWwv3LYBM9Nyc3b69qGGvm/vDhpPwjGzO7qq1cSbJmZFXh1zyc9ToGObWpwVswp88b9MojWVqSf+wvu1PJaGak8n/IhqKKxqGW8dlN2yWmVZrL7rsvpwEUgUmBjqedK5QelePn6PQ9a3XJ6DqcrRgByU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BngJXezr; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BngJXezr"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e5e8274a74so2799722a12.1;
        Fri, 04 Apr 2025 00:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743752501; x=1744357301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwsoGQMtp/SFNV621Z0EdCAQuSOQaCMz7aQpyqT8ds8=;
        b=BngJXezrG3TNQ762ujcIvkVTSwj07/P2MQ0AC+F5XqMbVKR0G6A5+6j2MYfRWaigIq
         LGi40CTE8UPVkWaeT5nl2/o8F1xC8r+Avu3U+i3FunDsCRNjDKZA1z4W0uugNztlv2P7
         CoshXl/0ALCgK9ggV6TJC9GJmrQ4p7PVaCl2wAWwlun98ATFMNTrI/Abtw5CZOAD8pGh
         5YfoemvxOufSQDVrcplcWCUt6lYRjatH/EBWCgsV3MtGK0gyxN1DvCaaoaKG9zDfsnkb
         FnlhRCZXUxpfIjEfl/rqxnmCOi+mC+TOphxzOVlWjM7O2DZ7O9MQeWsu7o5JXZZr1cme
         qNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743752501; x=1744357301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwsoGQMtp/SFNV621Z0EdCAQuSOQaCMz7aQpyqT8ds8=;
        b=C/+oQMHq6nKGHbM2Yy8Q2S6uR0oyMRo7eGrfh0iRnZi5DNF5m3GtU56dRt4EerBSxh
         HL9H59QTorZgyRw1RPM9OKk9bzFTpejO7gppmXYInRBStMKWQtpDQEK6D7DLB+fcaikY
         awxPW1YDNtOX8rXwbvC1+4P+RD5kTWMy3QmpklrHWhifDNz3uDGybmyX7Y+rmo5PlBne
         7OJQ3Yx5TKqJss8P2D47H3HVQ1v6ukJf/U1Zqx8XdltYVNpDzwR5vE6o5GdYrbyqBUlc
         wsgaU+cq0jxUvcj6PN6NACm/POEP+6pXXk9HTdD6nwKwGyAgyfREBVpqE92He35UyMLu
         B0Tw==
X-Forwarded-Encrypted: i=1; AJvYcCULSRskYnvh4uokwbk3UMGIme8tQXxZ+A7KgpBv5Q/LC/LFTuZuJLEQ/yXK3R/ACF+lKyerZOt9PMf7pIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqSvLfvNZ9U3sZ+94Y/bLNRzFksl0tP15GbACnN9kapOFR3fZA
	4t3lRp7EXBPMw8sDLZnnzlv8ywOVK+moPuUtezxHAwr1tibXw+nKQ2M37Kft
X-Gm-Gg: ASbGncvW3v0Hn63MsnQO+a80LPRagK71QtNMH2KjBJKWk/6QTBxgmU/M4je1vi/qSoC
	ynQ4Hdtjz6IWFxpfQDUTbEYpSR0dFVs9AJUdPPwx+PagJpRmx5SdKeLTqn5KbOc4mbWztU4HbCM
	lahNeeErctLnKMefJrwyFG1Ws8PCNsAVXLSd6cB356a5bTmHGtFwLzNrCTrCd7gYLDdKlZ5xu1s
	usFgvwDJb5CTDA8FF6BL9kQrZ9L3z+ZSHPTBf2pJny8gHAAnt6wVzWb3HbD6i+SLF/VB8lfQ6fp
	BHa5WfnhZv/Idv8kb7txq9wD1iEV7e+hC9wQ
X-Google-Smtp-Source: AGHT+IGPoHmIuP7Ur5xbx68j2uyiC5ErX/eQ+rvU9QqRKXIr6wC1gUOERKlGcpC+QKcu6iEcdY7UCg==
X-Received: by 2002:a17:907:1ca7:b0:ac4:85b:f973 with SMTP id a640c23a62f3a-ac7d1819306mr169686666b.34.1743752501086;
        Fri, 04 Apr 2025 00:41:41 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9aa4esm211739266b.54.2025.04.04.00.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 00:41:40 -0700 (PDT)
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
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/3] crypto: x86 - Remove CONFIG_AS_SHA256_NI
Date: Fri,  4 Apr 2025 09:41:01 +0200
Message-ID: <20250404074135.520812-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404074135.520812-1-ubizjak@gmail.com>
References: <20250404074135.520812-1-ubizjak@gmail.com>
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
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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

