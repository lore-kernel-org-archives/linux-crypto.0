Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A651171D
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264297; cv=none; b=j0WIqNcGzdHRtwYmigJmcPelN7Viu3H0oXkVWhDhIndCWwfzz/elywxE3RfDYJqBNxxNl1IsUgvD68P33xVEc16FoJuxQYYJRYttM3vwYJ0PM4NLZlseeg5FiVzxLXarGvALuwLzLSWewh/ig+X/gWXOnpqmt6GLvukErRhkHOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264297; c=relaxed/simple;
	bh=k/mTYX02KvpLmDuBNEGrzMYyk+wYM9HVP9OgbxTq8PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGnkkhC6YpzQuS6ENSmJ0Z+uT17M1g9vPkikT4KxU60bwKSbG4denlSqzLHU+Pt0F5JHDeYXZPzqyaAPF/cka0MDmuruVf0sTlg2j2M3ZJr7xEfwB4oXK6pV/jUHK0mdqCuVVZNwppAdajrGg9UJaG7jpJXKzTsLRFBPc3Cx9p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lh15lw+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh15lw+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09D4C4CECF;
	Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264297;
	bh=k/mTYX02KvpLmDuBNEGrzMYyk+wYM9HVP9OgbxTq8PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh15lw+nth2TNTF9ldvf7nb2WlIoUvc8vb1ZjOmLED+AyquimRleOOX8akWMTXL7Q
	 Ke0T6c4grBvfiinb+KUu0lnekkZBT0gyKqvSkQIUfHanUsX+pcdQXbRpW3zg1Y2Cb6
	 hy+KUFjQY9VpZJWvmQSK9MzLbI6Gsui4tRn8Dqg6oB/YyN5lfl+MhwUrnQG10Re6iI
	 il3bDf+szYEMjdQnbLGYg7wklYo8O2mmQGSPlCvvmHIy+tcTliIWi9TNyXIh5j3A+f
	 gKCFcWw71wz5iUQc+psRfvlLMZX9L6TLuNrwYdNVwqbK61op4M+hwc6GSjXdPEPMW5
	 +wdQrvrPMNYwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 05/10] crypto: x86/aegis128 - optimize length block preparation using SSE4.1
Date: Sun,  6 Oct 2024 18:24:25 -0700
Message-ID: <20241007012430.163606-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
References: <20241007012430.163606-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Start using SSE4.1 instructions in the AES-NI AEGIS code, with the first
use case being preparing the length block in fewer instructions.

In practice this does not reduce the set of CPUs on which the code can
run, because all Intel and AMD CPUs with AES-NI also have SSE4.1.

Upgrade the existing SSE2 feature check to SSE4.1, though it seems this
check is not strictly necessary; the aesni-intel module has been getting
away with using SSE4.1 despite checking for AES-NI only.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Kconfig               | 4 ++--
 arch/x86/crypto/aegis128-aesni-asm.S  | 6 ++----
 arch/x86/crypto/aegis128-aesni-glue.c | 6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 7b1bebed879d..3d2e38ba5240 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -361,20 +361,20 @@ config CRYPTO_CHACHA20_X86_64
 	  - SSSE3 (Supplemental SSE3)
 	  - AVX2 (Advanced Vector Extensions 2)
 	  - AVX-512VL (Advanced Vector Extensions-512VL)
 
 config CRYPTO_AEGIS128_AESNI_SSE2
-	tristate "AEAD ciphers: AEGIS-128 (AES-NI/SSE2)"
+	tristate "AEAD ciphers: AEGIS-128 (AES-NI/SSE4.1)"
 	depends on X86 && 64BIT
 	select CRYPTO_AEAD
 	select CRYPTO_SIMD
 	help
 	  AEGIS-128 AEAD algorithm
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES New Instructions)
-	  - SSE2 (Streaming SIMD Extensions 2)
+	  - SSE4.1 (Streaming SIMD Extensions 4.1)
 
 config CRYPTO_NHPOLY1305_SSE2
 	tristate "Hash functions: NHPoly1305 (SSE2)"
 	depends on X86 && 64BIT
 	select CRYPTO_NHPOLY1305
diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 5541aca2fd0d..6ed4bc452c29 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * AES-NI + SSE2 implementation of AEGIS-128
+ * AES-NI + SSE4.1 implementation of AEGIS-128
  *
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
  */
 
@@ -636,13 +636,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_final)
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
 	/* prepare length block: */
 	movd %edx, MSG
-	movd %ecx, T0
-	pslldq $8, T0
-	pxor T0, MSG
+	pinsrd $2, %ecx, MSG
 	psllq $3, MSG /* multiply by 8 (to get bit count) */
 
 	pxor STATE3, MSG
 
 	/* update state: */
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index deb39cef0be1..4dd2d981a514 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * The AEGIS-128 Authenticated-Encryption Algorithm
- *   Glue for AES-NI + SSE2 implementation
+ *   Glue for AES-NI + SSE4.1 implementation
  *
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
  */
 
@@ -252,11 +252,11 @@ static struct aead_alg crypto_aegis128_aesni_alg = {
 
 static struct simd_aead_alg *simd_alg;
 
 static int __init crypto_aegis128_aesni_module_init(void)
 {
-	if (!boot_cpu_has(X86_FEATURE_XMM2) ||
+	if (!boot_cpu_has(X86_FEATURE_XMM4_1) ||
 	    !boot_cpu_has(X86_FEATURE_AES) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE, NULL))
 		return -ENODEV;
 
 	return simd_register_aeads_compat(&crypto_aegis128_aesni_alg, 1,
@@ -271,8 +271,8 @@ static void __exit crypto_aegis128_aesni_module_exit(void)
 module_init(crypto_aegis128_aesni_module_init);
 module_exit(crypto_aegis128_aesni_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
-MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm -- AESNI+SSE2 implementation");
+MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm -- AESNI+SSE4.1 implementation");
 MODULE_ALIAS_CRYPTO("aegis128");
 MODULE_ALIAS_CRYPTO("aegis128-aesni");
-- 
2.46.2

