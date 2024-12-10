Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1994222C373
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875150; cv=none; b=DT70+497ovuuU/ly0+ps3DGQnwXRDysuDyuTpHacCqfgWAhZPsN46Jk5MubZyHEUZVrhrHsnIIhb5lPgrv2VmH8GYhfFYncanUf/lrjhhP4OSy9NFrm9UmjnbnsDzGD11RJGQMdbR8r/Q0tEWKeDohHX4ZCYh8nbAo18NzhGLD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875150; c=relaxed/simple;
	bh=3+JQ8eJTH3/H9N0HSJTtmwt577Uamy2X18dOOOn248E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azMAmLbvrnUHG6vLoCZk5OvJyiRwxwoJs/Cccvt4NOt+37yC88kfo35+sY+kNFolc7BEGClT/JZgq/boYPUqphbywyThJfUG0CbmN3XFhq/lWUOhVKsF1Qmofo065DstMFPx75GnYF6zg+bpvhm6N7jGSK/SM3S8h4k4rgbgKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9kbndy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9kbndy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5E1C4CEE5;
	Tue, 10 Dec 2024 23:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875149;
	bh=3+JQ8eJTH3/H9N0HSJTtmwt577Uamy2X18dOOOn248E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9kbndy/2jJHiGQw0GkRLg1PLL5geah5goDYAnxMUBxxoSpLOHvtHL9t/LL3Wrzs5
	 Ykp3omMUd4OfeZ8Zore73MkGjGa8AXO5phOqUGnrNIQBDbqDSO+X+cfncO1PfTB9NB
	 VVoAZSz76K7OEOMduTS1RFCmgl/XbWmVadXAqsGrQKd7/8iKKSs6xV48BcgeSKpiIp
	 aFJDD27COjBCCsRaEexf074H8Z+p2bG6S9UwKHsWVhTyttdGS6/R5q1NwLgvIa6Mtc
	 jLagzPLYz+GC6kgPizPqsKVb/EcrFNn22pOsTnW0dCxtcUC6012OEaQqLzU3812Rw8
	 NCXfCu38Bh1MQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 4/7] crypto: x86/aes-xts - make the register aliases per-function
Date: Tue, 10 Dec 2024 15:58:31 -0800
Message-ID: <20241210235834.40862-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210235834.40862-1-ebiggers@kernel.org>
References: <20241210235834.40862-1-ebiggers@kernel.org>
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
 arch/x86/crypto/aes-xts-avx-x86_64.S | 77 +++++++++++++++-------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/arch/x86/crypto/aes-xts-avx-x86_64.S b/arch/x86/crypto/aes-xts-avx-x86_64.S
index 63e5d3b3e77f5..77b3c265be30b 100644
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
@@ -732,34 +732,39 @@
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
-	vaesenc		-2*16(%rdi), %xmm0, %xmm0
-	vaesenc		-1*16(%rdi), %xmm0, %xmm0
-	vaesenc		0*16(%rdi), %xmm0, %xmm0
-	vaesenc		1*16(%rdi), %xmm0, %xmm0
-	vaesenc		2*16(%rdi), %xmm0, %xmm0
-	vaesenc		3*16(%rdi), %xmm0, %xmm0
-	vaesenc		4*16(%rdi), %xmm0, %xmm0
-	vaesenc		5*16(%rdi), %xmm0, %xmm0
-	vaesenc		6*16(%rdi), %xmm0, %xmm0
-	vaesenclast	7*16(%rdi), %xmm0, %xmm0
-	vmovdqu		%xmm0, (%rsi)
+	vaesenc		-2*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		-1*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		0*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		1*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		2*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		3*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		4*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		5*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenc		6*16(TWEAK_KEY), %xmm0, %xmm0
+	vaesenclast	7*16(TWEAK_KEY), %xmm0, %xmm0
+	vmovdqu		%xmm0, (IV)
 	RET
 SYM_FUNC_END(aes_xts_encrypt_iv)
 
 // Below are the actual AES-XTS encryption and decryption functions,
 // instantiated from the above macro.  They all have the following prototype:
-- 
2.47.1

