Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEFB1D88DD
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038955; cv=none; b=mYKiyB0SVujq2gvzF/q9ddTVMsSXoJqm8iu0UBspMFsZCJsPN5Y7YVl9fq38mZuKGhPRPwqBkC1TZaX0zjRPSrTmrQwTBjOXD0zbT5L1rX75lPY7DoEOpWkWva4L6u2R575LXZ71CzAJDaFi30Edl1uXmcLP8nyeK/PkcIMd3lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038955; c=relaxed/simple;
	bh=yzWMmgWBSarP35vlDb1i18NSU9mHYw/ZyjnDbn+PkMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpoGZpVu8HhPVPrjy30YQNskzbK5+rE3oBaD7fXuOMXcVZdFSDQ0sQkyIinviIDbO353JwghnB4NkxAHVevdVH2WDnbuTcPHOV7q3xUkiURGZ/TB7tzaTYcDQWxn79/ke2yWZ6fnJA6ptZA9J/DLNlKS22FBUrwgGJioTqjQdes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONoxceoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONoxceoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2A7C4CED1;
	Thu, 12 Dec 2024 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038955;
	bh=yzWMmgWBSarP35vlDb1i18NSU9mHYw/ZyjnDbn+PkMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONoxceoaZWymjULE9EJP1DnE8d2Z6OGusfHroXM80DZB6euiHFMyikmC8rbfq75Cl
	 GuL2C37gWkO7HGL1UbdxgTyD5kU9lX71stofR0dpwQS/UC+2W8pKt091nNy1HCrMiV
	 h4ePGv7n13I2HcQ+dDS/Q/1LZi3Ygh2zsZwE4Nscmh9HnmUVK8DuYS9cwUHehxkTvi
	 +CuSEvjzfMZcbsWuHvSqWrnPl/5aybVAxzDnK8J1i7lO4FJ+OYdqGGhghX6YDeJV1I
	 FAwKkOI2BP3rHPJ/WUA1slFKFfJVVA7Ki3OwkTxsrN4O9i7326coMrduLNCrD/6iHG
	 XGmPfZsLYS7Rw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 4/8] crypto: x86/aes-xts - make the register aliases per-function
Date: Thu, 12 Dec 2024 13:28:41 -0800
Message-ID: <20241212212845.40333-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212212845.40333-1-ebiggers@kernel.org>
References: <20241212212845.40333-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since aes-xts-avx-x86_64.S contains multiple functions, move the
register aliases for the parameters and local variables of the XTS
update function into the macro that generates that function.  Then add
register aliases to aes_xts_encrypt_iv() to improve readability there.
This makes aes-xts-avx-x86_64.S consistent with the GCM assembly files.

No change in the generated code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes-xts-avx-x86_64.S | 61 +++++++++++++++-------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 580e73396052..ca69e6480cb6 100644
--- a/arch/x86/crypto/aes-xts-avx-x86_64.S
+++ b/arch/x86/crypto/aes-xts-avx-x86_64.S
@@ -78,26 +78,10 @@
 	.byte	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
 	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
 .text
 
-// Function parameters
-.set	KEY,		%rdi	// Initially points to crypto_aes_ctx, then is
-				// advanced to point to 7th-from-last round key
-.set	SRC,		%rsi	// Pointer to next source data
-.set	DST,		%rdx	// Pointer to next destination data
-.set	LEN,		%ecx	// Remaining length in bytes
-.set	LEN8,		%cl
-.set	LEN64,		%rcx
-.set	TWEAK,		%r8	// Pointer to next tweak
-
-// %rax holds the AES key length in bytes.
-.set	KEYLEN,		%eax
-.set	KEYLEN64,	%rax
-
-// %r9-r11 are available as temporaries.
-
 .macro	_define_Vi	i
 .if VL == 16
 	.set	V\i,		%xmm\i
 .elseif VL == 32
 	.set	V\i,		%ymm\i
@@ -119,10 +103,26 @@
 .irp i, 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
 	_define_Vi	\i
 .endr
 .endif
 
+	// Function parameters
+	.set	KEY,		%rdi	// Initially points to crypto_aes_ctx, then is
+					// advanced to point to 7th-from-last round key
+	.set	SRC,		%rsi	// Pointer to next source data
+	.set	DST,		%rdx	// Pointer to next destination data
+	.set	LEN,		%ecx	// Remaining length in bytes
+	.set	LEN8,		%cl
+	.set	LEN64,		%rcx
+	.set	TWEAK,		%r8	// Pointer to next tweak
+
+	// %rax holds the AES key length in bytes.
+	.set	KEYLEN,		%eax
+	.set	KEYLEN64,	%rax
+
+	// %r9-r11 are available as temporaries.
+
 	// V0-V3 hold the data blocks during the main loop, or temporary values
 	// otherwise.  V4-V5 hold temporary values.
 
 	// V6-V9 hold XTS tweaks.  Each 128-bit lane holds one tweak.
 	.set	TWEAK0_XMM,	%xmm6
@@ -726,28 +726,33 @@
 .endm
 
 // void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 //			   u8 iv[AES_BLOCK_SIZE]);
 SYM_TYPED_FUNC_START(aes_xts_encrypt_iv)
-	vmovdqu		(%rsi), %xmm0
-	vpxor		(%rdi), %xmm0, %xmm0
-	movl		480(%rdi), %eax		// AES key length
-	lea		-16(%rdi, %rax, 4), %rdi
-	cmp		$24, %eax
+	.set	TWEAK_KEY,	%rdi
+	.set	IV,		%rsi
+	.set	KEYLEN,		%eax
+	.set	KEYLEN64,	%rax
+
+	vmovdqu		(IV), %xmm0
+	vpxor		(TWEAK_KEY), %xmm0, %xmm0
+	movl		480(TWEAK_KEY), KEYLEN
+	lea		-16(TWEAK_KEY, KEYLEN64, 4), TWEAK_KEY
+	cmp		$24, KEYLEN
 	jl		.Lencrypt_iv_aes128
 	je		.Lencrypt_iv_aes192
-	vaesenc		-6*16(%rdi), %xmm0, %xmm0
-	vaesenc		-5*16(%rdi), %xmm0, %xmm0
+	vaesenc		-6*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		-5*16(TWEAK_KEY), %xmm0, %xmm0
 .Lencrypt_iv_aes192:
-	vaesenc		-4*16(%rdi), %xmm0, %xmm0
-	vaesenc		-3*16(%rdi), %xmm0, %xmm0
+	vaesenc		-4*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		-3*16(TWEAK_KEY), %xmm0, %xmm0
 .Lencrypt_iv_aes128:
 .irp i, -2,-1,0,1,2,3,4,5,6
-	vaesenc		\i*16(%rdi), %xmm0, %xmm0
+	vaesenc		\i*16(TWEAK_KEY), %xmm0, %xmm0
 .endr
-	vaesenclast	7*16(%rdi), %xmm0, %xmm0
-	vmovdqu		%xmm0, (%rsi)
+	vaesenclast	7*16(TWEAK_KEY), %xmm0, %xmm0
+	vmovdqu		%xmm0, (IV)
 	RET
 SYM_FUNC_END(aes_xts_encrypt_iv)
 
 // Below are the actual AES-XTS encryption and decryption functions,
 // instantiated from the above macro.  They all have the following prototype:
-- 
2.47.1

