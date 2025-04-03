Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDCD246348;
	Thu,  3 Apr 2025 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743673587; cv=none; b=tRjqxVpS3y+YW19C9PUIHWNczGrapFYpu20AXfwm/6om6ET+VD9NC1zcM/z8qaKhD6HzByHFlGneKLho0TXyvfDzHbHMo0Mhr/g0s8crILFs555xAAm6kowJlABslhhJ3f5aEUUyW197ospXaRlqzKpar6cREziQvIz9wViuA2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743673587; c=relaxed/simple;
	bh=f7/JdFZweTL9sZCJ3WX6y1bZJitz0ltdKba9U93IM8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VTICrpVzr/V9XwACd8LUm5qyQDM7VSYWJHo/drXbMvZMSfMJ5a3oGcbD0VKUp7vzm56G8NPfplmXI5BF0w5ek5tYgn0hZ4aMaqgwxpmUJQRgWXNXlftVgc0iIiSW0MmeIsJ4mfPyWL4qWx6RzpA4z1r1xDGBqwEZX6J/jcmA1GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JUJdLl/o; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUJdLl/o"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac41514a734so117034366b.2;
        Thu, 03 Apr 2025 02:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743673584; x=1744278384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LZH3Z5u0O8jlyrpJi+WGB/bJYyOlKyywTUoHDeURBX8=;
        b=JUJdLl/o4c40J5tBTNyEHCS68uZDH20qVGJFlQBZrLIsXQoeDzaEwsOiRIrNKJxiEW
         4izg8CPXEzNnIaj5Onyd/3hQxH3YssZxE/uRy37Xkx1vWQxyVS1uGaHCXpQ3uG1ZGGDa
         7T4vJxE4q/TyoOXlie8MwLfsdO/NhuBZgfYemVgJ8H1OhibZ2SC5OZQ3FYkk74VRE6FK
         RLSLOEGnbWA8u/DZIXl1beFV27C3SWtOBS5WmcIz8eqDFWQprYCHrUvhP7WQndOUopGE
         3yCsA7p3q2eikXQWqCZUhHJfB46VgJBOqVjEs0chnxcsefdoeIiDlz8IZpnG4YsBNQFN
         PjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743673584; x=1744278384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZH3Z5u0O8jlyrpJi+WGB/bJYyOlKyywTUoHDeURBX8=;
        b=V45y5kdnQdxqpE1gwT846P2vWdQ2cpKx4Z1wtA5iWoFheT5CEW9uo1rnLQRZbBpL+W
         gksfvBcAPYGXpOlgnCa4PB9Ds+riOs8pCSHWvxhOawJE7fZ3ZLKiZYu7UMqLPymVyJY8
         DopUtTeOF84ZJTWskleXIJbkEh/uNioHoozBUDjGDw7X4L11ws001Whe0We0m9SPNdvp
         VwACODyAr2x+o0bZHpRBcfbDfQ6OK9V/b2DREqEKNrYZM5T66biJERcFCNUicykfgnnP
         Md+YFr8yTN9c4ljTmEN7K0mvcuJaNhAwJVqUVyaW3x+qU/RFJSrUJO2SHZUhMtGajEIY
         bVgg==
X-Forwarded-Encrypted: i=1; AJvYcCUzTaWJaRmV1wyun0cv+Icc2ELHYtBTn64yqfB+GrD0Z2jBM8ui82xZzvk2qpVjmrtVG1lEOHznOwVQOKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTe7kL282DTPEPw27CBuq4ZrwEXeUXdd2c2ll1hSA1u4f9Jcq5
	5sza6CkVUhPtiI6JOp76Ufb1Jw/IdWDa12xVPZRTZlr53Wc3ewQqHZkaD8iQ
X-Gm-Gg: ASbGncsubpqOyO55OjfzjiqRNHk0Sj7YXDFCrCVge+cRjxnuMpNksBUj5U6wryQyygY
	Pj6JM5le7w/18TsYl0tCWKE4m8ItJTgiOQkoCJjYiqVSrmmB9bcPsWQJ/4YqZvqACW6M6ZFBSRS
	A3gbdilsgCzgDSIGbZDZWOVmDyH1Z2o71oq7btTQAHoVnw1kNPPhMFyavvikdNDA1YLUkdCdo5+
	a75OXL9rqh4zVWI3Mqsjzax2bVZ1h3ECPgqJiIM4ryrdp+eW8ahDEkrrKNwSVZrm5lsPd5RINMA
	CqRGfKNIDjSQ3KKS1spq+uaHYwt4RwBgfhThH2JpIcynGEA=
X-Google-Smtp-Source: AGHT+IGFqWnPl0sjgbK7qmDHo/YasyrcTXdwfvqMVUVFqFJFGq1uTP5FIsQzrRjpUhqbs46QGD6xog==
X-Received: by 2002:a17:906:478c:b0:abf:7776:7e0c with SMTP id a640c23a62f3a-ac7a173d2a7mr457970766b.33.1743673583593;
        Thu, 03 Apr 2025 02:46:23 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfeed008sm65054666b.85.2025.04.03.02.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 02:46:23 -0700 (PDT)
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
Subject: [PATCH 1/3] crypto: x86 - Remove CONFIG_AS_SHA1_NI
Date: Thu,  3 Apr 2025 11:44:39 +0200
Message-ID: <20250403094527.349526-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.25,
which supports SHA-1 instruction mnemonics.

Remove check for assembler support of SHA-1 instructions
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
 arch/x86/Kconfig.assembler        |  5 -----
 arch/x86/crypto/Makefile          |  3 +--
 arch/x86/crypto/sha1_ssse3_glue.c | 10 ----------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 6d20a6ce0507..70fe87bb1055 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -6,11 +6,6 @@ config AS_AVX512
 	help
 	  Supported by binutils >= 2.25 and LLVM integrated assembler
 
-config AS_SHA1_NI
-	def_bool $(as-instr,sha1msg1 %xmm0$(comma)%xmm1)
-	help
-	  Supported by binutils >= 2.24 and LLVM integrated assembler
-
 config AS_SHA256_NI
 	def_bool $(as-instr,sha256msg1 %xmm0$(comma)%xmm1)
 	help
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 5d19f41bde58..97c1dbc3b7d6 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -56,8 +56,7 @@ aesni-intel-$(CONFIG_64BIT) += aes-gcm-avx10-x86_64.o
 endif
 
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
-sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
-sha1-ssse3-$(CONFIG_AS_SHA1_NI) += sha1_ni_asm.o
+sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ni_asm.o sha1_ssse3_glue.o
 
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 sha256-ssse3-y := sha256-ssse3-asm.o sha256-avx-asm.o sha256-avx2-asm.o sha256_ssse3_glue.o
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index ab8bc54f254d..abb793cbad01 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -28,9 +28,7 @@
 #include <asm/simd.h>
 
 static const struct x86_cpu_id module_cpu_ids[] = {
-#ifdef CONFIG_AS_SHA1_NI
 	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
-#endif
 	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
@@ -256,7 +254,6 @@ static void unregister_sha1_avx2(void)
 		crypto_unregister_shash(&sha1_avx2_alg);
 }
 
-#ifdef CONFIG_AS_SHA1_NI
 asmlinkage void sha1_ni_transform(struct sha1_state *digest, const u8 *data,
 				  int rounds);
 
@@ -306,11 +303,6 @@ static void unregister_sha1_ni(void)
 		crypto_unregister_shash(&sha1_ni_alg);
 }
 
-#else
-static inline int register_sha1_ni(void) { return 0; }
-static inline void unregister_sha1_ni(void) { }
-#endif
-
 static int __init sha1_ssse3_mod_init(void)
 {
 	if (!x86_match_cpu(module_cpu_ids))
@@ -360,6 +352,4 @@ MODULE_ALIAS_CRYPTO("sha1");
 MODULE_ALIAS_CRYPTO("sha1-ssse3");
 MODULE_ALIAS_CRYPTO("sha1-avx");
 MODULE_ALIAS_CRYPTO("sha1-avx2");
-#ifdef CONFIG_AS_SHA1_NI
 MODULE_ALIAS_CRYPTO("sha1-ni");
-#endif
-- 
2.49.0

