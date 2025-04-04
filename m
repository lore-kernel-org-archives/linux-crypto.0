Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465572E62B4;
	Fri,  4 Apr 2025 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743752505; cv=none; b=nyXoA02L6z4Lmgz4xtOk5neAztT4o8wFS7yCSlcLihXQEEVxj3MwMr8U31Yxxi4FiyV7cHJSBAtJdIh/OmJFqwseeYeYXvFodWRnJfC20C6n6LZ5S5mady7wc33+KU8mi27XMXWCx5Yz+mw/onAy7AbpAH85N+DTeUlO+nEg3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743752505; c=relaxed/simple;
	bh=QtI5mAhCQ4oBglBAqTcS+F8Kx0lQtqASZjb2lyjSxiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GK10w0IssqdEjU2sFEJkYKqhJEv+mBUzxuQXPLGKOgxy845u4I4LmOqhEAlmiOWzPHYiXSdjWN8/96MpVoYK05WXjPysB1/HQ0d8C5hCT4fIJ+N/Yy1fsOy9dF2G6NMY4t5ZkMOKiRwyZs1KabkT9SssAlExz1wtxc9wA2xi67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjOZdj9i; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjOZdj9i"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac298c8fa50so289361066b.1;
        Fri, 04 Apr 2025 00:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743752500; x=1744357300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lly+kjhQe3HfD5fcXZQKDpjf1ygVZ2JZkJ3aEDIZba0=;
        b=IjOZdj9i9HK31yrnKvsj7AyK+H1gsE1LYEphHouhhRmoa1Vd/ReNkNlq1XwA6Evomb
         ECybeLwAi0EL7mbepeycV1ai2nx/29CAQE5C0W/Z3EnYbCWc+Ddybb46fP6ZBqt1rimv
         K35xI00YSIMHifiVovjBOYtCSB0MYLlTeyTqHWcVDn7yaRv7h76hFQlu6eSh5LZ3ds0l
         Gewh5bHjc0s0MKydQoUIBQllse+2A3h8zQM8acNmYnjusPBhgbj1cqJ6guxxXCRrWnRr
         bDwBrEYBDeENsTS5seeFq7fXJMIHSHc40M1IsLiXmC8oo+W15sC3Y/1mJPT+iU/svnYi
         CgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743752500; x=1744357300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lly+kjhQe3HfD5fcXZQKDpjf1ygVZ2JZkJ3aEDIZba0=;
        b=hFYmyf9VQcuMUUDx4YvdAH5Qd1EvmANSXwIxigDz6tTTstq0e1pDBYMwBisZGdm2wS
         hVdasBECXRBtdEh1+ks1rC/m6Qstg/vKf8Lvsrs1R2f3BUp3Ta8G49Et+vZbhJv5G7Dy
         39l5iBurph0W3IlGhV9FFREDNQCqflr1o3HCJ9XzX2xemjLtps5ZCakU/ATjxrsmYfPi
         rEh7QIyGdNhnrlNZ1fy4sSwsNARSe4alIFsFb8ItU3k6N2cpeB9k/dYqQRGMlsoFHr7O
         5AKzaOPQKh63Zx0KzW+phxhppMuwOFkVwF0gzvz/O059syTMfTJufTko5I7Hxfwh1JB6
         w6uw==
X-Forwarded-Encrypted: i=1; AJvYcCXFL0JQLii/vNqdx0NbgNkmNTLa59boE6+/wJANnqkASP6y//GHvskyMDDhcYI+RrTG/8tFqrIF46X52Dk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEw2z561/Hha9JS9rMWeYXdwGbf6AtLPE8F7V7NRZ7xDrxSy33
	MoPRLvGIv92dWH7S1COCRWnvXv+v2/wpHSgr5V6fVycBgRmHXpibOLPIcIlO
X-Gm-Gg: ASbGncsYIGIP1/mSIu3jOilbVfWmoNAmOoFStmqM0KYRNE6llQgx8tVMrjxxKUudMst
	7i2BIBAHFuiXaqw1xmIoZFjAhguKI2iKo2hF3Jna+0ilxJfpf7c0OdwMiGkGatUgZ45W2Se2+ps
	5TW5IkKI9JUDS3wPuWqhzg7Vy+c1gTybeVXjgBz5YzRm7kJpFuhLuaVSeODviUD9CH/VWAsCclQ
	/ha0+t8022UU6F6Pjyar+KTtVjf+q/TY9tAi2Kxw829O+Da7CzRGxKDLTi3YQ+RBLHfdmiUavDN
	Ikfn21KL4RirDYchuAx9Mnj6Bcj9K8Nhkf1d
X-Google-Smtp-Source: AGHT+IFT10eQ2xVHj2yD9WYDa3kzYBAICk4Ygr72KUmPcjmv4S0OnHvrF3EA3ZG5EYlkf8mnMBlaTg==
X-Received: by 2002:a17:907:608d:b0:ac7:82b3:7ad with SMTP id a640c23a62f3a-ac7d198fe5fmr183967166b.46.1743752500118;
        Fri, 04 Apr 2025 00:41:40 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9aa4esm211739266b.54.2025.04.04.00.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 00:41:39 -0700 (PDT)
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
Subject: [PATCH v2 1/3] crypto: x86 - Remove CONFIG_AS_SHA1_NI
Date: Fri,  4 Apr 2025 09:41:00 +0200
Message-ID: <20250404074135.520812-1-ubizjak@gmail.com>
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
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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

