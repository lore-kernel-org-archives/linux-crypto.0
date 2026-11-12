Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794502068;
	b=CP5RtT4l1BCzKmYrHjsXPyKgHqJZkg+2htsay+Rf3xN86ATIuEFF/5VaxXl8wX1wzxls
	 SDmL/lb/Ip9HChvS1X8Gvguamo0AM8WC6ySs3dCWNIN1y988rumgBA4TBbCRw1SxnF/E/
	 2jSo9Uf817vWU2+JT8ftWwqC93EbXGsFSAeUnQB6Od4H2MRGcOk4ybtOZMci0nL//+I8A
	 GejR2cZJVwYQTnHo9fdcS6t8dasFULYOgK/fjgejG2kMG2ZeyrLdBsygZyvmhBmnYJXQe
	 Jd0aUMpMZjXMxVF0iNkI2q5g8OvWFCQEzkXLSJmu0NnHOUajEQ84nWkgxHo5p5/wNBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=dcMqW/ntTLMMwJ48nIGVpjU8IT/s9YT+F9UwGlhq5MA=;
	b=M5YrFXRLNRu2oZon3pXIOp4r3A0+RBDJkpCiY5c5dMHpiDgto7AoUmwRGPz+s53paKTd
	 ruPOlzO57Y4A6OwofWTwG3f4bS7c72WKQUwvU1xiHl5JsHU9C1fI9klUTE2OvoV2Z7rCd
	 THKXDbRqkaHQ+qzUgpFizzK16dBHLrunemTytu9TKL0bnLC1gpiNoi5d/ZjrwdNOhFs5A
	 i3XYR6o1qHeIdGJwQixOCtd2tXCdSsbm9Pn8qxthFdBkOpPbm4pg86StvhLh2s9hS+fVK
	 qzlWlCVqGEDZjQHobwP1d7hXw1rHMAM7mIwjmndM0g3YeTwD7vw7plaqIxmYZ7kGcUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="BQN/Ijl2";
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2A606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56C2A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BQN/Ijl2
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a4654add56so38154355e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794502066; x=1795106866; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dcMqW/ntTLMMwJ48nIGVpjU8IT/s9YT+F9UwGlhq5MA=;
        b=BQN/Ijl2kWQUbGNjzzXbnwePTXvhc/avxqugn2YDIRfpGup7vf8X3uVgLzat0TKH5b
         RjAo5jYhZ1OTeu7joYDC/UDzns13o8rvL01lSVtX3EUfOJGBpmiy75hUuLa9QyqQlmbX
         oLourUVb/HdVOgFm1HnUQkM7UJxNCul6FhPNEm3eOBr6HZ3gisg0gu2mToG9I34zTjth
         /cRFC7MDwm0B1D90CbwmEDe49H3I4BkQO6yY8gs2alhqcSYviOwbXDGJA01Y3gR8tE+i
         VbHV6nbIqBGD2TlcSlw6/aA+QnHWaMSThrgd1KwO7RlOk7PgAN6AKWvQQM/fFwQTslGH
         uVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502066; x=1795106866;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dcMqW/ntTLMMwJ48nIGVpjU8IT/s9YT+F9UwGlhq5MA=;
        b=zir+ZZKngXZ2HPZ2Sh4WHnXmKbAdKSQXJAG8/ZiFM3gall1gH2OdQNEQrPMR7TP0pd
         iPUBFv3dValUzyysc0iby8p+AcwqPoX6K1pHodNpjSRA6QnkkujsSjWf/5QodD3caejE
         1NlFOABgCFo6QsZ02bAJNiLtgaYWE9roXXXqJGJ3pup4GCs4XtGR4KRNBP5wl5d2gSzE
         kCpSi/TwtCjHOnF5F7512EL4O7KDfhGGeY9lF83s3rzV+nQnpLyOCfydpRDGXe2opNW3
         XH0NJzjroWdrX7wgPJAN3caSnYwhbwQa1N6S0wyectGuc7Nag8/1J+meYhBNA+ofuhlb
         zLeA==
X-Gm-Message-State: APuU4Z856x65uFBLCPaE6zfFdgEk1frdGFUHgBoXtmmipFeUvyGIQDDm
	tNiiSODWyWh/KGC4W4QDM3F7et2etpKnsXlNDWYuqkYAPzCvBMxMsQAI6jIQxD0dV/uHz5p8THP
	tBbJQ3SI527fofhUVioVKk9Q5W0X8SazDLwCiWrCWrPwK0xVsw1AGgUlJdfBa8pk4at2oHaW4mX
	A/p4yhtxDymNmn3mow8u7LcCJnjCjdJpUpeg==
X-Received: from wmbh5.prod.google.com ([2002:a05:600c:a105:b0:4a2:11fa:1981])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f09:b0:4a2:d99:3171
 with SMTP id 5b1f17b1804b1-4ba09383b92mr124143075e9.23.1794502065405; Thu, 12
 Nov 2026 08:47:45 -0800 (PST)
Date: Thu, 12 Nov 2026 17:44:17 +0100
In-Reply-To: <20261112164419.1769428-4-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112164419.1769428-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=24408; i=ardb@kernel.org;
 h=from:subject; bh=9e6NHDs+b7W4ySjn5gzv+Ewl8UQuxq7/wt4ugGHtfis=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevrm6fz7c54akvf8F9v+ff8Xf1LWq+vq7E+a4m6oivzv
 vh2f+KyjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRMEdGhuuTK6wE7wZeqalt
 5GN4IBeVEHDO0mCC6XWtoifKiSq7JzD8s5/z7dRxo0WP+i6LrBLesfBveHLzswLtwn1m2ictJbt UeQE=
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112164419.1769428-5-ardb+git@google.com>
Subject: [PATCH 1/2] crypto: x86 - remove aegis128 support
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Antonio Quartulli <antonio@mandelbit.com>, 
	"=?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?=" <omosnacek@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Even the people that are invested in Aegis appear to have lost interest
in aegis128: it did win the CAESAR competition but is no longer covered
by RFC 10032, which does list some other variants that competed as well.

So let's delete it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/Kconfig               |  11 -
 arch/x86/crypto/Makefile              |   3 -
 arch/x86/crypto/aegis128-aesni-asm.S  | 602 --------------------
 arch/x86/crypto/aegis128-aesni-glue.c | 286 ----------
 4 files changed, 902 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 20f5e2a17e45..7988d4aa1d6d 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -314,15 +314,4 @@ config CRYPTO_ARIA_GFNI_AVX512_X86_64
 
 	  Processes 64 blocks in parallel.
 
-config CRYPTO_AEGIS128_AESNI_SSE2
-	tristate "AEAD ciphers: AEGIS-128 (AES-NI/SSE4.1)"
-	depends on 64BIT
-	select CRYPTO_AEAD
-	help
-	  AEGIS-128 AEAD algorithm
-
-	  Architecture: x86_64 using:
-	  - AES-NI (AES New Instructions)
-	  - SSE4.1 (Streaming SIMD Extensions 4.1)
-
 endmenu
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 09bdea45bc3e..dc1b819c27de 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -36,9 +36,6 @@ cast5-avx-x86_64-y := cast5-avx-x86_64-asm_64.o cast5_avx_glue.o
 obj-$(CONFIG_CRYPTO_CAST6_AVX_X86_64) += cast6-avx-x86_64.o
 cast6-avx-x86_64-y := cast6-avx-x86_64-asm_64.o cast6_avx_glue.o
 
-obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
-aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
-
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_glue.o \
 		 aes-gcm-aesni-x86_64.o \
diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
deleted file mode 100644
index 7294dc0ee7ba..000000000000
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ /dev/null
@@ -1,602 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * AES-NI + SSE4.1 implementation of AEGIS-128
- *
- * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
- * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
- * Copyright 2024 Google LLC
- */
-
-#include <linux/linkage.h>
-
-#define STATE0	%xmm0
-#define STATE1	%xmm1
-#define STATE2	%xmm2
-#define STATE3	%xmm3
-#define STATE4	%xmm4
-#define KEY	%xmm5
-#define MSG	%xmm5
-#define T0	%xmm6
-#define T1	%xmm7
-
-.section .rodata.cst16.aegis128_const, "aM", @progbits, 32
-.align 16
-.Laegis128_const_0:
-	.byte 0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d
-	.byte 0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62
-.Laegis128_const_1:
-	.byte 0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1
-	.byte 0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd
-
-.section .rodata.cst32.zeropad_mask, "aM", @progbits, 32
-.align 32
-.Lzeropad_mask:
-	.octa 0xffffffffffffffffffffffffffffffff
-	.octa 0
-
-.text
-
-/*
- * aegis128_update
- * input:
- *   STATE[0-4] - input state
- * output:
- *   STATE[0-4] - output state (shifted positions)
- * changed:
- *   T0
- */
-.macro aegis128_update
-	movdqa STATE4, T0
-	aesenc STATE0, STATE4
-	aesenc STATE1, STATE0
-	aesenc STATE2, STATE1
-	aesenc STATE3, STATE2
-	aesenc T0,     STATE3
-.endm
-
-/*
- * Load 1 <= LEN (%ecx) <= 15 bytes from the pointer SRC into the xmm register
- * MSG and zeroize any remaining bytes.  Clobbers %rax, %rcx, and %r8.
- */
-.macro load_partial
-	sub $8, %ecx			/* LEN - 8 */
-	jle .Lle8\@
-
-	/* Load 9 <= LEN <= 15 bytes: */
-	movq (SRC), MSG			/* Load first 8 bytes */
-	mov (SRC, %rcx), %rax		/* Load last 8 bytes */
-	neg %ecx
-	shl $3, %ecx
-	shr %cl, %rax			/* Discard overlapping bytes */
-	pinsrq $1, %rax, MSG
-	jmp .Ldone\@
-
-.Lle8\@:
-	add $4, %ecx			/* LEN - 4 */
-	jl .Llt4\@
-
-	/* Load 4 <= LEN <= 8 bytes: */
-	mov (SRC), %eax			/* Load first 4 bytes */
-	mov (SRC, %rcx), %r8d		/* Load last 4 bytes */
-	jmp .Lcombine\@
-
-.Llt4\@:
-	/* Load 1 <= LEN <= 3 bytes: */
-	add $2, %ecx			/* LEN - 2 */
-	movzbl (SRC), %eax		/* Load first byte */
-	jl .Lmovq\@
-	movzwl (SRC, %rcx), %r8d	/* Load last 2 bytes */
-.Lcombine\@:
-	shl $3, %ecx
-	shl %cl, %r8
-	or %r8, %rax			/* Combine the two parts */
-.Lmovq\@:
-	movq %rax, MSG
-.Ldone\@:
-.endm
-
-/*
- * Store 1 <= LEN (%ecx) <= 15 bytes from the xmm register \msg to the pointer
- * DST.  Clobbers %rax, %rcx, and %r8.
- */
-.macro store_partial msg
-	sub $8, %ecx			/* LEN - 8 */
-	jl .Llt8\@
-
-	/* Store 8 <= LEN <= 15 bytes: */
-	pextrq $1, \msg, %rax
-	mov %ecx, %r8d
-	shl $3, %ecx
-	ror %cl, %rax
-	mov %rax, (DST, %r8)		/* Store last LEN - 8 bytes */
-	movq \msg, (DST)		/* Store first 8 bytes */
-	jmp .Ldone\@
-
-.Llt8\@:
-	add $4, %ecx			/* LEN - 4 */
-	jl .Llt4\@
-
-	/* Store 4 <= LEN <= 7 bytes: */
-	pextrd $1, \msg, %eax
-	mov %ecx, %r8d
-	shl $3, %ecx
-	ror %cl, %eax
-	mov %eax, (DST, %r8)		/* Store last LEN - 4 bytes */
-	movd \msg, (DST)		/* Store first 4 bytes */
-	jmp .Ldone\@
-
-.Llt4\@:
-	/* Store 1 <= LEN <= 3 bytes: */
-	pextrb $0, \msg, 0(DST)
-	cmp $-2, %ecx			/* LEN - 4 == -2, i.e. LEN == 2? */
-	jl .Ldone\@
-	pextrb $1, \msg, 1(DST)
-	je .Ldone\@
-	pextrb $2, \msg, 2(DST)
-.Ldone\@:
-.endm
-
-/*
- * void aegis128_aesni_init(struct aegis_state *state,
- *			    const struct aegis_block *key,
- *			    const u8 iv[AEGIS128_NONCE_SIZE]);
- */
-SYM_FUNC_START(aegis128_aesni_init)
-	.set STATEP, %rdi
-	.set KEYP, %rsi
-	.set IVP, %rdx
-
-	/* load IV: */
-	movdqu (IVP), T1
-
-	/* load key: */
-	movdqa (KEYP), KEY
-	pxor KEY, T1
-	movdqa T1, STATE0
-	movdqa KEY, STATE3
-	movdqa KEY, STATE4
-
-	/* load the constants: */
-	movdqa .Laegis128_const_0(%rip), STATE2
-	movdqa .Laegis128_const_1(%rip), STATE1
-	pxor STATE2, STATE3
-	pxor STATE1, STATE4
-
-	/* update 10 times with KEY / KEY xor IV: */
-	aegis128_update; pxor KEY, STATE4
-	aegis128_update; pxor T1,  STATE3
-	aegis128_update; pxor KEY, STATE2
-	aegis128_update; pxor T1,  STATE1
-	aegis128_update; pxor KEY, STATE0
-	aegis128_update; pxor T1,  STATE4
-	aegis128_update; pxor KEY, STATE3
-	aegis128_update; pxor T1,  STATE2
-	aegis128_update; pxor KEY, STATE1
-	aegis128_update; pxor T1,  STATE0
-
-	/* store the state: */
-	movdqu STATE0, 0x00(STATEP)
-	movdqu STATE1, 0x10(STATEP)
-	movdqu STATE2, 0x20(STATEP)
-	movdqu STATE3, 0x30(STATEP)
-	movdqu STATE4, 0x40(STATEP)
-	RET
-SYM_FUNC_END(aegis128_aesni_init)
-
-/*
- * void aegis128_aesni_ad(struct aegis_state *state, const u8 *data,
- *			  unsigned int len);
- *
- * len must be a multiple of 16.
- */
-SYM_FUNC_START(aegis128_aesni_ad)
-	.set STATEP, %rdi
-	.set SRC, %rsi
-	.set LEN, %edx
-
-	test LEN, LEN
-	jz .Lad_out
-
-	/* load the state: */
-	movdqu 0x00(STATEP), STATE0
-	movdqu 0x10(STATEP), STATE1
-	movdqu 0x20(STATEP), STATE2
-	movdqu 0x30(STATEP), STATE3
-	movdqu 0x40(STATEP), STATE4
-
-.align 8
-.Lad_loop:
-	movdqu 0x00(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE4
-	sub $0x10, LEN
-	jz .Lad_out_1
-
-	movdqu 0x10(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE3
-	sub $0x10, LEN
-	jz .Lad_out_2
-
-	movdqu 0x20(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE2
-	sub $0x10, LEN
-	jz .Lad_out_3
-
-	movdqu 0x30(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE1
-	sub $0x10, LEN
-	jz .Lad_out_4
-
-	movdqu 0x40(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE0
-	sub $0x10, LEN
-	jz .Lad_out_0
-
-	add $0x50, SRC
-	jmp .Lad_loop
-
-	/* store the state: */
-.Lad_out_0:
-	movdqu STATE0, 0x00(STATEP)
-	movdqu STATE1, 0x10(STATEP)
-	movdqu STATE2, 0x20(STATEP)
-	movdqu STATE3, 0x30(STATEP)
-	movdqu STATE4, 0x40(STATEP)
-	RET
-
-.Lad_out_1:
-	movdqu STATE4, 0x00(STATEP)
-	movdqu STATE0, 0x10(STATEP)
-	movdqu STATE1, 0x20(STATEP)
-	movdqu STATE2, 0x30(STATEP)
-	movdqu STATE3, 0x40(STATEP)
-	RET
-
-.Lad_out_2:
-	movdqu STATE3, 0x00(STATEP)
-	movdqu STATE4, 0x10(STATEP)
-	movdqu STATE0, 0x20(STATEP)
-	movdqu STATE1, 0x30(STATEP)
-	movdqu STATE2, 0x40(STATEP)
-	RET
-
-.Lad_out_3:
-	movdqu STATE2, 0x00(STATEP)
-	movdqu STATE3, 0x10(STATEP)
-	movdqu STATE4, 0x20(STATEP)
-	movdqu STATE0, 0x30(STATEP)
-	movdqu STATE1, 0x40(STATEP)
-	RET
-
-.Lad_out_4:
-	movdqu STATE1, 0x00(STATEP)
-	movdqu STATE2, 0x10(STATEP)
-	movdqu STATE3, 0x20(STATEP)
-	movdqu STATE4, 0x30(STATEP)
-	movdqu STATE0, 0x40(STATEP)
-.Lad_out:
-	RET
-SYM_FUNC_END(aegis128_aesni_ad)
-
-.macro encrypt_block s0 s1 s2 s3 s4 i
-	movdqu (\i * 0x10)(SRC), MSG
-	movdqa MSG, T0
-	pxor \s1, T0
-	pxor \s4, T0
-	movdqa \s2, T1
-	pand \s3, T1
-	pxor T1, T0
-	movdqu T0, (\i * 0x10)(DST)
-
-	aegis128_update
-	pxor MSG, \s4
-
-	sub $0x10, LEN
-	jz .Lenc_out_\i
-.endm
-
-/*
- * void aegis128_aesni_enc(struct aegis_state *state, const u8 *src, u8 *dst,
- *			   unsigned int len);
- *
- * len must be nonzero and a multiple of 16.
- */
-SYM_FUNC_START(aegis128_aesni_enc)
-	.set STATEP, %rdi
-	.set SRC, %rsi
-	.set DST, %rdx
-	.set LEN, %ecx
-
-	/* load the state: */
-	movdqu 0x00(STATEP), STATE0
-	movdqu 0x10(STATEP), STATE1
-	movdqu 0x20(STATEP), STATE2
-	movdqu 0x30(STATEP), STATE3
-	movdqu 0x40(STATEP), STATE4
-
-.align 8
-.Lenc_loop:
-	encrypt_block STATE0 STATE1 STATE2 STATE3 STATE4 0
-	encrypt_block STATE4 STATE0 STATE1 STATE2 STATE3 1
-	encrypt_block STATE3 STATE4 STATE0 STATE1 STATE2 2
-	encrypt_block STATE2 STATE3 STATE4 STATE0 STATE1 3
-	encrypt_block STATE1 STATE2 STATE3 STATE4 STATE0 4
-
-	add $0x50, SRC
-	add $0x50, DST
-	jmp .Lenc_loop
-
-	/* store the state: */
-.Lenc_out_0:
-	movdqu STATE4, 0x00(STATEP)
-	movdqu STATE0, 0x10(STATEP)
-	movdqu STATE1, 0x20(STATEP)
-	movdqu STATE2, 0x30(STATEP)
-	movdqu STATE3, 0x40(STATEP)
-	RET
-
-.Lenc_out_1:
-	movdqu STATE3, 0x00(STATEP)
-	movdqu STATE4, 0x10(STATEP)
-	movdqu STATE0, 0x20(STATEP)
-	movdqu STATE1, 0x30(STATEP)
-	movdqu STATE2, 0x40(STATEP)
-	RET
-
-.Lenc_out_2:
-	movdqu STATE2, 0x00(STATEP)
-	movdqu STATE3, 0x10(STATEP)
-	movdqu STATE4, 0x20(STATEP)
-	movdqu STATE0, 0x30(STATEP)
-	movdqu STATE1, 0x40(STATEP)
-	RET
-
-.Lenc_out_3:
-	movdqu STATE1, 0x00(STATEP)
-	movdqu STATE2, 0x10(STATEP)
-	movdqu STATE3, 0x20(STATEP)
-	movdqu STATE4, 0x30(STATEP)
-	movdqu STATE0, 0x40(STATEP)
-	RET
-
-.Lenc_out_4:
-	movdqu STATE0, 0x00(STATEP)
-	movdqu STATE1, 0x10(STATEP)
-	movdqu STATE2, 0x20(STATEP)
-	movdqu STATE3, 0x30(STATEP)
-	movdqu STATE4, 0x40(STATEP)
-.Lenc_out:
-	RET
-SYM_FUNC_END(aegis128_aesni_enc)
-
-/*
- * void aegis128_aesni_enc_tail(struct aegis_state *state, const u8 *src,
- *				u8 *dst, unsigned int len);
- */
-SYM_FUNC_START(aegis128_aesni_enc_tail)
-	.set STATEP, %rdi
-	.set SRC, %rsi
-	.set DST, %rdx
-	.set LEN, %ecx	/* {load,store}_partial rely on this being %ecx */
-
-	/* load the state: */
-	movdqu 0x00(STATEP), STATE0
-	movdqu 0x10(STATEP), STATE1
-	movdqu 0x20(STATEP), STATE2
-	movdqu 0x30(STATEP), STATE3
-	movdqu 0x40(STATEP), STATE4
-
-	/* encrypt message: */
-	mov LEN, %r9d
-	load_partial
-
-	movdqa MSG, T0
-	pxor STATE1, T0
-	pxor STATE4, T0
-	movdqa STATE2, T1
-	pand STATE3, T1
-	pxor T1, T0
-
-	mov %r9d, LEN
-	store_partial T0
-
-	aegis128_update
-	pxor MSG, STATE4
-
-	/* store the state: */
-	movdqu STATE4, 0x00(STATEP)
-	movdqu STATE0, 0x10(STATEP)
-	movdqu STATE1, 0x20(STATEP)
-	movdqu STATE2, 0x30(STATEP)
-	movdqu STATE3, 0x40(STATEP)
-	RET
-SYM_FUNC_END(aegis128_aesni_enc_tail)
-
-.macro decrypt_block s0 s1 s2 s3 s4 i
-	movdqu (\i * 0x10)(SRC), MSG
-	pxor \s1, MSG
-	pxor \s4, MSG
-	movdqa \s2, T1
-	pand \s3, T1
-	pxor T1, MSG
-	movdqu MSG, (\i * 0x10)(DST)
-
-	aegis128_update
-	pxor MSG, \s4
-
-	sub $0x10, LEN
-	jz .Ldec_out_\i
-.endm
-
-/*
- * void aegis128_aesni_dec(struct aegis_state *state, const u8 *src, u8 *dst,
- *			   unsigned int len);
- *
- * len must be nonzero and a multiple of 16.
- */
-SYM_FUNC_START(aegis128_aesni_dec)
-	.set STATEP, %rdi
-	.set SRC, %rsi
-	.set DST, %rdx
-	.set LEN, %ecx
-
-	/* load the state: */
-	movdqu 0x00(STATEP), STATE0
-	movdqu 0x10(STATEP), STATE1
-	movdqu 0x20(STATEP), STATE2
-	movdqu 0x30(STATEP), STATE3
-	movdqu 0x40(STATEP), STATE4
-
-.align 8
-.Ldec_loop:
-	decrypt_block STATE0 STATE1 STATE2 STATE3 STATE4 0
-	decrypt_block STATE4 STATE0 STATE1 STATE2 STATE3 1
-	decrypt_block STATE3 STATE4 STATE0 STATE1 STATE2 2
-	decrypt_block STATE2 STATE3 STATE4 STATE0 STATE1 3
-	decrypt_block STATE1 STATE2 STATE3 STATE4 STATE0 4
-
-	add $0x50, SRC
-	add $0x50, DST
-	jmp .Ldec_loop
-
-	/* store the state: */
-.Ldec_out_0:
-	movdqu STATE4, 0x00(STATEP)
-	movdqu STATE0, 0x10(STATEP)
-	movdqu STATE1, 0x20(STATEP)
-	movdqu STATE2, 0x30(STATEP)
-	movdqu STATE3, 0x40(STATEP)
-	RET
-
-.Ldec_out_1:
-	movdqu STATE3, 0x00(STATEP)
-	movdqu STATE4, 0x10(STATEP)
-	movdqu STATE0, 0x20(STATEP)
-	movdqu STATE1, 0x30(STATEP)
-	movdqu STATE2, 0x40(STATEP)
-	RET
-
-.Ldec_out_2:
-	movdqu STATE2, 0x00(STATEP)
-	movdqu STATE3, 0x10(STATEP)
-	movdqu STATE4, 0x20(STATEP)
-	movdqu STATE0, 0x30(STATEP)
-	movdqu STATE1, 0x40(STATEP)
-	RET
-
-.Ldec_out_3:
-	movdqu STATE1, 0x00(STATEP)
-	movdqu STATE2, 0x10(STATEP)
-	movdqu STATE3, 0x20(STATEP)
-	movdqu STATE4, 0x30(STATEP)
-	movdqu STATE0, 0x40(STATEP)
-	RET
-
-.Ldec_out_4:
-	movdqu STATE0, 0x00(STATEP)
-	movdqu STATE1, 0x10(STATEP)
-	movdqu STATE2, 0x20(STATEP)
-	movdqu STATE3, 0x30(STATEP)
-	movdqu STATE4, 0x40(STATEP)
-.Ldec_out:
-	RET
-SYM_FUNC_END(aegis128_aesni_dec)
-
-/*
- * void aegis128_aesni_dec_tail(struct aegis_state *state, const u8 *src,
- *				u8 *dst, unsigned int len);
- */
-SYM_FUNC_START(aegis128_aesni_dec_tail)
-	.set STATEP, %rdi
-	.set SRC, %rsi
-	.set DST, %rdx
-	.set LEN, %ecx	/* {load,store}_partial rely on this being %ecx */
-
-	/* load the state: */
-	movdqu 0x00(STATEP), STATE0
-	movdqu 0x10(STATEP), STATE1
-	movdqu 0x20(STATEP), STATE2
-	movdqu 0x30(STATEP), STATE3
-	movdqu 0x40(STATEP), STATE4
-
-	/* decrypt message: */
-	mov LEN, %r9d
-	load_partial
-
-	pxor STATE1, MSG
-	pxor STATE4, MSG
-	movdqa STATE2, T1
-	pand STATE3, T1
-	pxor T1, MSG
-
-	mov %r9d, LEN
-	store_partial MSG
-
-	/* mask with byte count: */
-	lea .Lzeropad_mask+16(%rip), %rax
-	sub %r9, %rax
-	movdqu (%rax), T0
-	pand T0, MSG
-
-	aegis128_update
-	pxor MSG, STATE4
-
-	/* store the state: */
-	movdqu STATE4, 0x00(STATEP)
-	movdqu STATE0, 0x10(STATEP)
-	movdqu STATE1, 0x20(STATEP)
-	movdqu STATE2, 0x30(STATEP)
-	movdqu STATE3, 0x40(STATEP)
-	RET
-SYM_FUNC_END(aegis128_aesni_dec_tail)
-
-/*
- * void aegis128_aesni_final(struct aegis_state *state,
- *			     struct aegis_block *tag_xor,
- *			     unsigned int assoclen, unsigned int cryptlen);
- */
-SYM_FUNC_START(aegis128_aesni_final)
-	.set STATEP, %rdi
-	.set TAG_XOR, %rsi
-	.set ASSOCLEN, %edx
-	.set CRYPTLEN, %ecx
-
-	/* load the state: */
-	movdqu 0x00(STATEP), STATE0
-	movdqu 0x10(STATEP), STATE1
-	movdqu 0x20(STATEP), STATE2
-	movdqu 0x30(STATEP), STATE3
-	movdqu 0x40(STATEP), STATE4
-
-	/* prepare length block: */
-	movd ASSOCLEN, MSG
-	pinsrd $2, CRYPTLEN, MSG
-	psllq $3, MSG /* multiply by 8 (to get bit count) */
-
-	pxor STATE3, MSG
-
-	/* update state: */
-	aegis128_update; pxor MSG, STATE4
-	aegis128_update; pxor MSG, STATE3
-	aegis128_update; pxor MSG, STATE2
-	aegis128_update; pxor MSG, STATE1
-	aegis128_update; pxor MSG, STATE0
-	aegis128_update; pxor MSG, STATE4
-	aegis128_update; pxor MSG, STATE3
-
-	/* xor tag: */
-	movdqu (TAG_XOR), MSG
-
-	pxor STATE0, MSG
-	pxor STATE1, MSG
-	pxor STATE2, MSG
-	pxor STATE3, MSG
-	pxor STATE4, MSG
-
-	movdqu MSG, (TAG_XOR)
-	RET
-SYM_FUNC_END(aegis128_aesni_final)
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
deleted file mode 100644
index 09fc0b15b0e9..000000000000
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ /dev/null
@@ -1,286 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * The AEGIS-128 Authenticated-Encryption Algorithm
- *   Glue for AES-NI + SSE4.1 implementation
- *
- * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
- * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
- */
-
-#include <crypto/internal/aead.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
-#include <linux/module.h>
-#include <asm/fpu/api.h>
-#include <asm/cpu_device_id.h>
-
-#define AEGIS128_BLOCK_ALIGN 16
-#define AEGIS128_BLOCK_SIZE 16
-#define AEGIS128_NONCE_SIZE 16
-#define AEGIS128_STATE_BLOCKS 5
-#define AEGIS128_KEY_SIZE 16
-#define AEGIS128_MIN_AUTH_SIZE 8
-#define AEGIS128_MAX_AUTH_SIZE 16
-
-struct aegis_block {
-	u8 bytes[AEGIS128_BLOCK_SIZE] __aligned(AEGIS128_BLOCK_ALIGN);
-};
-
-struct aegis_state {
-	struct aegis_block blocks[AEGIS128_STATE_BLOCKS];
-};
-
-struct aegis_ctx {
-	struct aegis_block key;
-};
-
-asmlinkage void aegis128_aesni_init(struct aegis_state *state,
-				    const struct aegis_block *key,
-				    const u8 iv[AEGIS128_NONCE_SIZE]);
-
-asmlinkage void aegis128_aesni_ad(struct aegis_state *state, const u8 *data,
-				  unsigned int len);
-
-asmlinkage void aegis128_aesni_enc(struct aegis_state *state, const u8 *src,
-				   u8 *dst, unsigned int len);
-
-asmlinkage void aegis128_aesni_dec(struct aegis_state *state, const u8 *src,
-				   u8 *dst, unsigned int len);
-
-asmlinkage void aegis128_aesni_enc_tail(struct aegis_state *state,
-					const u8 *src, u8 *dst,
-					unsigned int len);
-
-asmlinkage void aegis128_aesni_dec_tail(struct aegis_state *state,
-					const u8 *src, u8 *dst,
-					unsigned int len);
-
-asmlinkage void aegis128_aesni_final(struct aegis_state *state,
-				     struct aegis_block *tag_xor,
-				     unsigned int assoclen,
-				     unsigned int cryptlen);
-
-static void crypto_aegis128_aesni_process_ad(
-		struct aegis_state *state, struct scatterlist *sg_src,
-		unsigned int assoclen)
-{
-	struct scatter_walk walk;
-	struct aegis_block buf;
-	unsigned int pos = 0;
-
-	scatterwalk_start(&walk, sg_src);
-	while (assoclen != 0) {
-		unsigned int size = scatterwalk_next(&walk, assoclen);
-		const u8 *src = walk.addr;
-		unsigned int left = size;
-
-		if (pos + size >= AEGIS128_BLOCK_SIZE) {
-			if (pos > 0) {
-				unsigned int fill = AEGIS128_BLOCK_SIZE - pos;
-				memcpy(buf.bytes + pos, src, fill);
-				aegis128_aesni_ad(state, buf.bytes,
-						  AEGIS128_BLOCK_SIZE);
-				pos = 0;
-				left -= fill;
-				src += fill;
-			}
-
-			aegis128_aesni_ad(state, src,
-					  left & ~(AEGIS128_BLOCK_SIZE - 1));
-			src += left & ~(AEGIS128_BLOCK_SIZE - 1);
-			left &= AEGIS128_BLOCK_SIZE - 1;
-		}
-
-		memcpy(buf.bytes + pos, src, left);
-		pos += left;
-		assoclen -= size;
-
-		scatterwalk_done_src(&walk, size);
-	}
-
-	if (pos > 0) {
-		memset(buf.bytes + pos, 0, AEGIS128_BLOCK_SIZE - pos);
-		aegis128_aesni_ad(state, buf.bytes, AEGIS128_BLOCK_SIZE);
-	}
-}
-
-static __always_inline int
-crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
-				    struct skcipher_walk *walk, bool enc)
-{
-	int err = 0;
-
-	while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
-		if (enc)
-			aegis128_aesni_enc(state, walk->src.virt.addr,
-					   walk->dst.virt.addr,
-					   round_down(walk->nbytes,
-						      AEGIS128_BLOCK_SIZE));
-		else
-			aegis128_aesni_dec(state, walk->src.virt.addr,
-					   walk->dst.virt.addr,
-					   round_down(walk->nbytes,
-						      AEGIS128_BLOCK_SIZE));
-		kernel_fpu_end();
-		err = skcipher_walk_done(walk,
-					 walk->nbytes % AEGIS128_BLOCK_SIZE);
-		kernel_fpu_begin();
-	}
-
-	if (walk->nbytes) {
-		if (enc)
-			aegis128_aesni_enc_tail(state, walk->src.virt.addr,
-						walk->dst.virt.addr,
-						walk->nbytes);
-		else
-			aegis128_aesni_dec_tail(state, walk->src.virt.addr,
-						walk->dst.virt.addr,
-						walk->nbytes);
-		kernel_fpu_end();
-		err = skcipher_walk_done(walk, 0);
-		kernel_fpu_begin();
-	}
-	return err;
-}
-
-static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *aead)
-{
-	u8 *ctx = crypto_aead_ctx(aead);
-	ctx = PTR_ALIGN(ctx, __alignof__(struct aegis_ctx));
-	return (void *)ctx;
-}
-
-static int crypto_aegis128_aesni_setkey(struct crypto_aead *aead, const u8 *key,
-					unsigned int keylen)
-{
-	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(aead);
-
-	if (keylen != AEGIS128_KEY_SIZE)
-		return -EINVAL;
-
-	memcpy(ctx->key.bytes, key, AEGIS128_KEY_SIZE);
-
-	return 0;
-}
-
-static int crypto_aegis128_aesni_setauthsize(struct crypto_aead *tfm,
-						unsigned int authsize)
-{
-	if (authsize > AEGIS128_MAX_AUTH_SIZE)
-		return -EINVAL;
-	if (authsize < AEGIS128_MIN_AUTH_SIZE)
-		return -EINVAL;
-	return 0;
-}
-
-static __always_inline int
-crypto_aegis128_aesni_crypt(struct aead_request *req,
-			    struct aegis_block *tag_xor,
-			    unsigned int cryptlen, bool enc)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
-	struct skcipher_walk walk;
-	struct aegis_state state;
-	int err;
-
-	if (enc)
-		err = skcipher_walk_aead_encrypt(&walk, req, false);
-	else
-		err = skcipher_walk_aead_decrypt(&walk, req, false);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-
-	aegis128_aesni_init(&state, &ctx->key, req->iv);
-	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
-	err = crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
-	if (err == 0)
-		aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
-	kernel_fpu_end();
-	return err;
-}
-
-static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aegis_block tag = {};
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	unsigned int cryptlen = req->cryptlen;
-	int err;
-
-	err = crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
-	if (err)
-		return err;
-
-	scatterwalk_map_and_copy(tag.bytes, req->dst,
-				 req->assoclen + cryptlen, authsize, 1);
-	return 0;
-}
-
-static int crypto_aegis128_aesni_decrypt(struct aead_request *req)
-{
-	static const struct aegis_block zeros = {};
-
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct aegis_block tag;
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	unsigned int cryptlen = req->cryptlen - authsize;
-	int err;
-
-	scatterwalk_map_and_copy(tag.bytes, req->src,
-				 req->assoclen + cryptlen, authsize, 0);
-
-	err = crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
-	if (err)
-		return err;
-
-	return crypto_memneq(tag.bytes, zeros.bytes, authsize) ? -EBADMSG : 0;
-}
-
-static struct aead_alg crypto_aegis128_aesni_alg = {
-	.setkey = crypto_aegis128_aesni_setkey,
-	.setauthsize = crypto_aegis128_aesni_setauthsize,
-	.encrypt = crypto_aegis128_aesni_encrypt,
-	.decrypt = crypto_aegis128_aesni_decrypt,
-
-	.ivsize = AEGIS128_NONCE_SIZE,
-	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
-	.chunksize = AEGIS128_BLOCK_SIZE,
-
-	.base = {
-		.cra_blocksize = 1,
-		.cra_ctxsize = sizeof(struct aegis_ctx) +
-			       __alignof__(struct aegis_ctx),
-		.cra_priority = 400,
-
-		.cra_name = "aegis128",
-		.cra_driver_name = "aegis128-aesni",
-
-		.cra_module = THIS_MODULE,
-	}
-};
-
-static int __init crypto_aegis128_aesni_module_init(void)
-{
-	if (!boot_cpu_has(X86_FEATURE_XMM4_1) ||
-	    !boot_cpu_has(X86_FEATURE_AES))
-		return -ENODEV;
-
-	return crypto_register_aead(&crypto_aegis128_aesni_alg);
-}
-
-static void __exit crypto_aegis128_aesni_module_exit(void)
-{
-	crypto_unregister_aead(&crypto_aegis128_aesni_alg);
-}
-
-module_init(crypto_aegis128_aesni_module_init);
-module_exit(crypto_aegis128_aesni_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
-MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm -- AESNI+SSE4.1 implementation");
-MODULE_ALIAS_CRYPTO("aegis128");
-MODULE_ALIAS_CRYPTO("aegis128-aesni");
-- 
2.56.0.567.gdb80ae8cd5-goog

