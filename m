Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851ED1C4623
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784630; cv=none; b=XmoHN1TPBCcdXceizHaLQXvJByh9Jrq2qtURURAZhPISqJNFC7b/LFcuR8bBA09sQ+SATSSCSmsYn2zUODk7d4MPyvf41+ACIG9Je1GrvAqRuSlKA3pL7tmnu+5v8AdsesGQiNSKiQm+qrqp3JZOj6r5MKSGho381VYx+xv0igs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784630; c=relaxed/simple;
	bh=lO6oBz8F+JLDitPwAQRjYCldOeflcpaDAiJnMhqg67Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XxLiKODIMOppldgh8RWGlXEubybUR1JRqJ/WhvZdqpOHorILXevPHo8BeZlIlyh7ELVGAy3Yu2USE+swghccL6soCve/hs0j+oz9+hB2spSnVkiLGnEID0KB8pgaE32+GnTOVXHBkPWusi3GQlLbRhX8rSXo/hq0bJPQoA8EOq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hl71/cGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hl71/cGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031F8C55DF5
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784630;
	bh=lO6oBz8F+JLDitPwAQRjYCldOeflcpaDAiJnMhqg67Q=;
	h=From:To:Subject:Date:From;
	b=hl71/cGlUdNqrVgu9CtaXBkXKLc7HUktERY/l9vAh+WH1w2K3PcyiUGPzfm7WluWx
	 fjS5ko2vm402qs39z/+ZvN6lAMtitrLxr14icxucndLk96zfqWsedA3gcbVjmh/b9V
	 j8c5Wa8j0caKuXUP+LwhnlP0XB9cta5AAxUfIa1ExVGH9unsnPtpfS6wrflN5gZng4
	 31XyQVg841DeSo0aU3d2C3FDqvj+kDarlmFMumI/mtBJHGZtLXwnLws2dR627E1901
	 VR2UYcBrKrgs2I8JasbrJNYPWBhnBx7IfWy6M8XmBOotN92FIo2gnHVyhvlSGz4qrj
	 ViNnwvcSKprtw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: x86/aesni - update docs for aesni-intel module
Date: Tue, 27 Aug 2024 11:50:01 -0700
Message-ID: <20240827185001.71699-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Update the kconfig help and module description to reflect that VAES
instructions are now used in some cases.  Also fix XTR => XCTR.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Kconfig            | 8 ++++++--
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 24875e6295f2d..7b1bebed879df 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -12,25 +12,29 @@ config CRYPTO_CURVE25519_X86
 
 	  Architecture: x86_64 using:
 	  - ADX (large integer arithmetic)
 
 config CRYPTO_AES_NI_INTEL
-	tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XTR, XTS, GCM (AES-NI)"
+	tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XCTR, XTS, GCM (AES-NI/VAES)"
 	depends on X86
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_ALGAPI
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
 	help
 	  Block cipher: AES cipher algorithms
 	  AEAD cipher: AES with GCM
-	  Length-preserving ciphers: AES with ECB, CBC, CTS, CTR, XTR, XTS
+	  Length-preserving ciphers: AES with ECB, CBC, CTS, CTR, XCTR, XTS
 
 	  Architecture: x86 (32-bit and 64-bit) using:
 	  - AES-NI (AES new instructions)
+	  - VAES (Vector AES)
+
+	  Some algorithm implementations are supported only in 64-bit builds,
+	  and some have additional prerequisites such as AVX2 or AVX512.
 
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Ciphers: Blowfish, modes: ECB, CBC"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index d63ba9eaba3e4..b0dd835554997 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1748,8 +1748,8 @@ static void __exit aesni_exit(void)
 }
 
 late_initcall(aesni_init);
 module_exit(aesni_exit);
 
-MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, Intel AES-NI instructions optimized");
+MODULE_DESCRIPTION("AES cipher and modes, optimized with AES-NI or VAES instructions");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("aes");

base-commit: 3c44d31cb34ce4eb8311a2e73634d57702948230
-- 
2.46.0

