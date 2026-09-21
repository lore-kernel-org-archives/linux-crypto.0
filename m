Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2B352037;
	Mon, 21 Sep 2026 05:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967771; cv=none; b=QUJvSArtpMKSyn/odU+bkZp1y2nkKgflZvj8OQ4eDTTuqEFzFgpixNMvbU3kzXY5XAcZzByXlb0bdnYjsAeliY451yH/ULHE/A0KTW2G949FduinH68u+GfeB9YqQQJ98CxHjKk0LIjsA4sQxTl077oq4WJ4fr0FzxxRM/t7C7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967771; c=relaxed/simple;
	bh=E0J9wHC77t4UpencBzutAp+L2Z6ppNGrwmHZay+nn4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfEmZX92YsAwVEoPVszkbroi6qwrMtRu40Ay1EN5DaIZ4Yrdxp111peKCHPkDvj6U1fyyhDwrNPZVqXGLf3DDmfoU2SO5SVX4pGOX0EJOu7wRsnlla38z+QGn1CvIvmDfWP9Zd1X2wRR6ZDJ1TfztQXf2QWCBdoyXK6mJx35FmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BINuyM1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BINuyM1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CF01F0089C;
	Mon, 21 Sep 2026 05:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967767;
	bh=KCaFQVHPwizlKMhoDceW3K55+bEOnSGiOzgLrGQHS1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BINuyM1A2ZumFTiaDfJewtdw72fRb2Zst6tJ+kn7GgKU6Ys6qAOLta7IZRn0RaL9N
	 T4OGouHjJx1bDcBISGVTPZHpaYv75siMneHZRWRFIsP8ZNHvjG36v/vf394rK2qDgK
	 GpIGp0J6AFn7eUtDThqqXz2xGn2nvyGx7qZ72pByQ6dRa2F5qKfky/yM46sVzyd5mx
	 O8UHJjJVWxvtjk+0LqIyNxfti7IhWvyJoK3Dtly6XA5YZCjHlwsaBJh0dvdtn/Ezxi
	 DQTdD5IuRgf6xdrqXCkXxPgOvSqWeaoYpbb8NV/IfJi8PiqcFW4Mc3nrfm5TZ+eG9G
	 A0wFGbIz1+8Bw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/20] crypto: x86/aes-xts - Remove superseded XTS skcipher
Date: Sun, 20 Sep 2026 22:08:57 -0700
Message-ID: <20260921050910.296144-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the crypto library's AES-XTS support is optimized with AES-NI
(without AVX), the similar code in aesni-intel is redundant.  Remove it.

This only affects the non-AVX implementation ("xts-aes-aesni"), not
aes-xts-avx-x86_64.S which is handled later.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S  | 617 -----------------------------
 arch/x86/crypto/aesni-intel_glue.c |  69 +---
 2 files changed, 1 insertion(+), 685 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index c4d54c4a2c23..b12a0f2bf006 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -20,30 +20,11 @@
 #include <linux/objtool.h>
 #include <asm/frame.h>
 
-#define STATE1	%xmm0
-#define STATE2	%xmm4
-#define STATE3	%xmm5
-#define STATE4	%xmm6
-#define STATE	STATE1
-#define IN1	%xmm1
-#define IN2	%xmm7
-#define IN3	%xmm8
-#define IN4	%xmm9
-#define IN	IN1
-#define KEY	%xmm2
-#define IV	%xmm3
-
-#define GF128MUL_MASK %xmm7
-
 #ifdef __x86_64__
 #define AREG	%rax
 #define KEYP	%rdi
 #define OUTP	%rsi
 #define UKEYP	OUTP
-#define INP	%rdx
-#define LEN	%rcx
-#define IVP	%r8
-#define KLEN	%r9d
 #define T1	%r10
 #define TKEYP	T1
 #define T2	%r11
@@ -52,10 +33,6 @@
 #define KEYP	%edi
 #define OUTP	AREG
 #define UKEYP	OUTP
-#define INP	%edx
-#define LEN	%esi
-#define IVP	%ebp
-#define KLEN	%ebx
 #define T1	%ecx
 #define TKEYP	T1
 #endif
@@ -241,597 +218,3 @@ SYM_FUNC_START(aesni_set_key)
 	FRAME_END
 	RET
 SYM_FUNC_END(aesni_set_key)
-
-/*
- * void aesni_enc(const void *ctx, u8 *dst, const u8 *src)
- */
-SYM_FUNC_START(aesni_enc)
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+12)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+16)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+20)(%esp), INP	# src
-#endif
-	movl 480(KEYP), KLEN		# key length
-	movups (INP), STATE		# input
-	call _aesni_enc1
-	movups STATE, (OUTP)		# output
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-#endif
-	FRAME_END
-	RET
-SYM_FUNC_END(aesni_enc)
-
-/*
- * _aesni_enc1:		internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		round count
- *	STATE:		initial state (input)
- * output:
- *	STATE:		finial state (output)
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-SYM_FUNC_START_LOCAL(_aesni_enc1)
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE		# round 0
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .Lenc128
-	lea 0x20(TKEYP), TKEYP
-	je .Lenc192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps -0x50(TKEYP), KEY
-	aesenc KEY, STATE
-.align 4
-.Lenc192:
-	movaps -0x40(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps -0x30(TKEYP), KEY
-	aesenc KEY, STATE
-.align 4
-.Lenc128:
-	movaps -0x20(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps -0x10(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps (TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x10(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x20(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x30(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x40(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x50(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x60(TKEYP), KEY
-	aesenc KEY, STATE
-	movaps 0x70(TKEYP), KEY
-	aesenclast KEY, STATE
-	RET
-SYM_FUNC_END(_aesni_enc1)
-
-/*
- * _aesni_enc4:	internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		round count
- *	STATE1:		initial state (input)
- *	STATE2
- *	STATE3
- *	STATE4
- * output:
- *	STATE1:		finial state (output)
- *	STATE2
- *	STATE3
- *	STATE4
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-SYM_FUNC_START_LOCAL(_aesni_enc4)
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE1		# round 0
-	pxor KEY, STATE2
-	pxor KEY, STATE3
-	pxor KEY, STATE4
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .L4enc128
-	lea 0x20(TKEYP), TKEYP
-	je .L4enc192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps -0x50(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-#.align 4
-.L4enc192:
-	movaps -0x40(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps -0x30(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-#.align 4
-.L4enc128:
-	movaps -0x20(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps -0x10(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps (TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x10(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x20(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x30(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x40(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x50(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x60(TKEYP), KEY
-	aesenc KEY, STATE1
-	aesenc KEY, STATE2
-	aesenc KEY, STATE3
-	aesenc KEY, STATE4
-	movaps 0x70(TKEYP), KEY
-	aesenclast KEY, STATE1		# last round
-	aesenclast KEY, STATE2
-	aesenclast KEY, STATE3
-	aesenclast KEY, STATE4
-	RET
-SYM_FUNC_END(_aesni_enc4)
-
-/*
- * _aesni_dec1:		internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		key length
- *	STATE:		initial state (input)
- * output:
- *	STATE:		finial state (output)
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-SYM_FUNC_START_LOCAL(_aesni_dec1)
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE		# round 0
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .Ldec128
-	lea 0x20(TKEYP), TKEYP
-	je .Ldec192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps -0x50(TKEYP), KEY
-	aesdec KEY, STATE
-.align 4
-.Ldec192:
-	movaps -0x40(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps -0x30(TKEYP), KEY
-	aesdec KEY, STATE
-.align 4
-.Ldec128:
-	movaps -0x20(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps -0x10(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps (TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x10(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x20(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x30(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x40(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x50(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x60(TKEYP), KEY
-	aesdec KEY, STATE
-	movaps 0x70(TKEYP), KEY
-	aesdeclast KEY, STATE
-	RET
-SYM_FUNC_END(_aesni_dec1)
-
-/*
- * _aesni_dec4:	internal ABI
- * input:
- *	KEYP:		key struct pointer
- *	KLEN:		key length
- *	STATE1:		initial state (input)
- *	STATE2
- *	STATE3
- *	STATE4
- * output:
- *	STATE1:		finial state (output)
- *	STATE2
- *	STATE3
- *	STATE4
- * changed:
- *	KEY
- *	TKEYP (T1)
- */
-SYM_FUNC_START_LOCAL(_aesni_dec4)
-	movaps (KEYP), KEY		# key
-	mov KEYP, TKEYP
-	pxor KEY, STATE1		# round 0
-	pxor KEY, STATE2
-	pxor KEY, STATE3
-	pxor KEY, STATE4
-	add $0x30, TKEYP
-	cmp $24, KLEN
-	jb .L4dec128
-	lea 0x20(TKEYP), TKEYP
-	je .L4dec192
-	add $0x20, TKEYP
-	movaps -0x60(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps -0x50(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-.align 4
-.L4dec192:
-	movaps -0x40(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps -0x30(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-.align 4
-.L4dec128:
-	movaps -0x20(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps -0x10(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps (TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x10(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x20(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x30(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x40(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x50(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x60(TKEYP), KEY
-	aesdec KEY, STATE1
-	aesdec KEY, STATE2
-	aesdec KEY, STATE3
-	aesdec KEY, STATE4
-	movaps 0x70(TKEYP), KEY
-	aesdeclast KEY, STATE1		# last round
-	aesdeclast KEY, STATE2
-	aesdeclast KEY, STATE3
-	aesdeclast KEY, STATE4
-	RET
-SYM_FUNC_END(_aesni_dec4)
-
-.pushsection .rodata
-.align 16
-.Lcts_permute_table:
-	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
-	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
-	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-	.byte		0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
-.popsection
-
-.section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
-.align 16
-.Lgf128mul_x_ble_mask:
-	.octa 0x00000000000000010000000000000087
-.previous
-
-/*
- * _aesni_gf128mul_x_ble: Multiply in GF(2^128) for XTS IVs
- * input:
- *	IV:	current IV
- *	GF128MUL_MASK == mask with 0x87 and 0x01
- * output:
- *	IV:	next IV
- * changed:
- *	KEY:	== temporary value
- */
-.macro _aesni_gf128mul_x_ble
-	pshufd $0x13, IV, KEY
-	paddq IV, IV
-	psrad $31, KEY
-	pand GF128MUL_MASK, KEY
-	pxor KEY, IV
-.endm
-
-.macro	_aesni_xts_crypt	enc
-	FRAME_BEGIN
-#ifndef __x86_64__
-	pushl IVP
-	pushl LEN
-	pushl KEYP
-	pushl KLEN
-	movl (FRAME_OFFSET+20)(%esp), KEYP	# ctx
-	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
-	movl (FRAME_OFFSET+28)(%esp), INP	# src
-	movl (FRAME_OFFSET+32)(%esp), LEN	# len
-	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
-	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
-#else
-	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
-#endif
-	movups (IVP), IV
-
-	mov 480(KEYP), KLEN
-.if !\enc
-	add $240, KEYP
-
-	test $15, LEN
-	jz .Lxts_loop4\@
-	sub $16, LEN
-.endif
-
-.Lxts_loop4\@:
-	sub $64, LEN
-	jl .Lxts_1x\@
-
-	movdqa IV, STATE1
-	movdqu 0x00(INP), IN
-	pxor IN, STATE1
-	movdqu IV, 0x00(OUTP)
-
-	_aesni_gf128mul_x_ble
-	movdqa IV, STATE2
-	movdqu 0x10(INP), IN
-	pxor IN, STATE2
-	movdqu IV, 0x10(OUTP)
-
-	_aesni_gf128mul_x_ble
-	movdqa IV, STATE3
-	movdqu 0x20(INP), IN
-	pxor IN, STATE3
-	movdqu IV, 0x20(OUTP)
-
-	_aesni_gf128mul_x_ble
-	movdqa IV, STATE4
-	movdqu 0x30(INP), IN
-	pxor IN, STATE4
-	movdqu IV, 0x30(OUTP)
-
-.if \enc
-	call _aesni_enc4
-.else
-	call _aesni_dec4
-.endif
-
-	movdqu 0x00(OUTP), IN
-	pxor IN, STATE1
-	movdqu STATE1, 0x00(OUTP)
-
-	movdqu 0x10(OUTP), IN
-	pxor IN, STATE2
-	movdqu STATE2, 0x10(OUTP)
-
-	movdqu 0x20(OUTP), IN
-	pxor IN, STATE3
-	movdqu STATE3, 0x20(OUTP)
-
-	movdqu 0x30(OUTP), IN
-	pxor IN, STATE4
-	movdqu STATE4, 0x30(OUTP)
-
-	_aesni_gf128mul_x_ble
-
-	add $64, INP
-	add $64, OUTP
-	test LEN, LEN
-	jnz .Lxts_loop4\@
-
-.Lxts_ret_iv\@:
-	movups IV, (IVP)
-
-.Lxts_ret\@:
-#ifndef __x86_64__
-	popl KLEN
-	popl KEYP
-	popl LEN
-	popl IVP
-#endif
-	FRAME_END
-	RET
-
-.Lxts_1x\@:
-	add $64, LEN
-	jz .Lxts_ret_iv\@
-.if \enc
-	sub $16, LEN
-	jl .Lxts_cts4\@
-.endif
-
-.Lxts_loop1\@:
-	movdqu (INP), STATE
-.if \enc
-	pxor IV, STATE
-	call _aesni_enc1
-.else
-	add $16, INP
-	sub $16, LEN
-	jl .Lxts_cts1\@
-	pxor IV, STATE
-	call _aesni_dec1
-.endif
-	pxor IV, STATE
-	_aesni_gf128mul_x_ble
-
-	test LEN, LEN
-	jz .Lxts_out\@
-
-.if \enc
-	add $16, INP
-	sub $16, LEN
-	jl .Lxts_cts1\@
-.endif
-
-	movdqu STATE, (OUTP)
-	add $16, OUTP
-	jmp .Lxts_loop1\@
-
-.Lxts_out\@:
-	movdqu STATE, (OUTP)
-	jmp .Lxts_ret_iv\@
-
-.if \enc
-.Lxts_cts4\@:
-	movdqa STATE4, STATE
-	sub $16, OUTP
-.Lxts_cts1\@:
-.else
-.Lxts_cts1\@:
-	movdqa IV, STATE4
-	_aesni_gf128mul_x_ble
-
-	pxor IV, STATE
-	call _aesni_dec1
-	pxor IV, STATE
-.endif
-#ifndef __x86_64__
-	lea .Lcts_permute_table, T1
-#else
-	lea .Lcts_permute_table(%rip), T1
-#endif
-	add LEN, INP		/* rewind input pointer */
-	add $16, LEN		/* # bytes in final block */
-	movups (INP), IN1
-
-	mov T1, IVP
-	add $32, IVP
-	add LEN, T1
-	sub LEN, IVP
-	add OUTP, LEN
-
-	movups (T1), %xmm4
-	movaps STATE, IN2
-	pshufb %xmm4, STATE
-	movups STATE, (LEN)
-
-	movups (IVP), %xmm0
-	pshufb %xmm0, IN1
-	pblendvb IN2, IN1
-	movaps IN1, STATE
-
-.if \enc
-	pxor IV, STATE
-	call _aesni_enc1
-	pxor IV, STATE
-.else
-	pxor STATE4, STATE
-	call _aesni_dec1
-	pxor STATE4, STATE
-.endif
-
-	movups STATE, (OUTP)
-	jmp .Lxts_ret\@
-.endm
-
-/*
- * void aesni_xts_enc(const struct crypto_aes_ctx *ctx, u8 *dst,
- *		      const u8 *src, unsigned int len, le128 *iv)
- */
-SYM_FUNC_START(aesni_xts_enc)
-	_aesni_xts_crypt	1
-SYM_FUNC_END(aesni_xts_enc)
-
-/*
- * void aesni_xts_dec(const struct crypto_aes_ctx *ctx, u8 *dst,
- *		      const u8 *src, unsigned int len, le128 *iv)
- */
-SYM_FUNC_START(aesni_xts_dec)
-	_aesni_xts_crypt	0
-SYM_FUNC_END(aesni_xts_dec)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 7d248f2719c2..6acb1fa32c6e 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -60,13 +60,6 @@ static inline void *aes_align_addr(void *addr)
 
 asmlinkage void aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			      unsigned int key_len);
-asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
-
-asmlinkage void aesni_xts_enc(const struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
-
-asmlinkage void aesni_xts_dec(const struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
@@ -228,56 +221,6 @@ xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
 	return xts_crypt_slowpath(req, crypt_func);
 }
 
-static void aesni_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
-				 u8 iv[AES_BLOCK_SIZE])
-{
-	aesni_enc(tweak_key, iv, iv);
-}
-
-static void aesni_xts_encrypt(const struct crypto_aes_ctx *key,
-			      const u8 *src, u8 *dst, int len,
-			      u8 tweak[AES_BLOCK_SIZE])
-{
-	aesni_xts_enc(key, dst, src, len, tweak);
-}
-
-static void aesni_xts_decrypt(const struct crypto_aes_ctx *key,
-			      const u8 *src, u8 *dst, int len,
-			      u8 tweak[AES_BLOCK_SIZE])
-{
-	aesni_xts_dec(key, dst, src, len, tweak);
-}
-
-static int xts_encrypt_aesni(struct skcipher_request *req)
-{
-	return xts_crypt(req, aesni_xts_encrypt_iv, aesni_xts_encrypt);
-}
-
-static int xts_decrypt_aesni(struct skcipher_request *req)
-{
-	return xts_crypt(req, aesni_xts_encrypt_iv, aesni_xts_decrypt);
-}
-
-static struct skcipher_alg aesni_skciphers[] = {
-	{
-		.base = {
-			.cra_name		= "xts(aes)",
-			.cra_driver_name	= "xts-aes-aesni",
-			.cra_priority		= 401,
-			.cra_blocksize		= AES_BLOCK_SIZE,
-			.cra_ctxsize		= XTS_AES_CTX_SIZE,
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
-		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
-		.walksize	= 2 * AES_BLOCK_SIZE,
-		.setkey		= xts_setkey_aesni,
-		.encrypt	= xts_encrypt_aesni,
-		.decrypt	= xts_decrypt_aesni,
-	}
-};
-
 #ifdef CONFIG_X86_64
 asmlinkage void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 				   u8 iv[AES_BLOCK_SIZE]);
@@ -1314,15 +1257,10 @@ static int __init aesni_init(void)
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
 
-	err = crypto_register_skciphers(aesni_skciphers,
-					ARRAY_SIZE(aesni_skciphers));
-	if (err)
-		return err;
-
 	err = crypto_register_aeads(aes_gcm_algs_aesni,
 				    ARRAY_SIZE(aes_gcm_algs_aesni));
 	if (err)
-		goto unregister_skciphers;
+		return err;
 
 	err = register_avx_algs();
 	if (err)
@@ -1334,9 +1272,6 @@ static int __init aesni_init(void)
 	unregister_avx_algs();
 	crypto_unregister_aeads(aes_gcm_algs_aesni,
 				ARRAY_SIZE(aes_gcm_algs_aesni));
-unregister_skciphers:
-	crypto_unregister_skciphers(aesni_skciphers,
-				    ARRAY_SIZE(aesni_skciphers));
 	return err;
 }
 
@@ -1344,8 +1279,6 @@ static void __exit aesni_exit(void)
 {
 	crypto_unregister_aeads(aes_gcm_algs_aesni,
 				ARRAY_SIZE(aes_gcm_algs_aesni));
-	crypto_unregister_skciphers(aesni_skciphers,
-				    ARRAY_SIZE(aesni_skciphers));
 	unregister_avx_algs();
 }
 
-- 
2.55.0

