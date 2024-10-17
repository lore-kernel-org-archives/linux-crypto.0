Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F3B18E3F;
	Thu, 17 Oct 2024 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123335; cv=none; b=kR96i9mEYl9YBGql91iaJOWwcV7n3RMxx6UR8Xpw00ChwmYQjzGWTg1KOmYAR47XUbqLs3dhFOghud/JxMdjGRckZOyq7jPmGr8px0GGoLeyzTL+QYW99iiV5keElHoYmZgKTpLwbS7erH2AB7KO8onyIuf6EmW5JMXRofv+umA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123335; c=relaxed/simple;
	bh=9a54tPMqOVZMyr0Ex0zfIp+tWVsw6jMjfj7xf1MVcY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzXmBixp7ak6cjpmDp7Tn6tNUdf2wP+w50RUE8UuIypgbtfdm+HE+s/XP0ZLui0xW6DFD5KVPTKX9x7vUUM/cDOs8EGSXeqhZgo1PHXQN53rzu9U3u2ljGFEvA4Oge+2AGLVQFqJ9z2oJF2LvVUVvMt2CR3VCzmYviIHmTW7C0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbLl0XXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbLl0XXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF310C4AF0E;
	Thu, 17 Oct 2024 00:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729123334;
	bh=9a54tPMqOVZMyr0Ex0zfIp+tWVsw6jMjfj7xf1MVcY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbLl0XXfROI2OlJXgtzuHNJzwwp+GnbkbgNq6MftbxlcT9Q9MJZ9KorHkQlsW6AKH
	 RmJV6Sx1b0pE07vZZ+YF54vxfev7nAhoscXhvn4Cx/I0g4osBN3omN0+itOUuqxNdu
	 ne0v+Mocp5hw1HqGubqVdvsGB0yXGKeB7FanplRIkSjfuIV23/7wnmFJaVxoLFwpGi
	 7lz/XiiFwa1lQh4LO6hxAlsWb3O5+rUnejc3LwxJdfSacDCNA+0b4WrbIfaEe5q8Oh
	 Ap7Hp+/V9Uyy8htBf2bR1LrujHt5y9pj2gVBYBd2HcmhoiGkP03XcM9ZEU83ihM80N
	 Sh57S4TzJ6BJg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/10] crypto: x86/aegis128 - optimize partial block handling using SSE4.1
Date: Wed, 16 Oct 2024 17:00:48 -0700
Message-ID: <20241017000051.228294-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241017000051.228294-1-ebiggers@kernel.org>
References: <20241017000051.228294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Optimize the code that loads and stores partial blocks, taking advantage
of SSE4.1.  The code is adapted from that in aes-gcm-aesni-x86_64.S.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 236 +++++++++++----------------
 1 file changed, 95 insertions(+), 141 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 9dfdbe0b1fb83..e650330ef6951 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -2,10 +2,11 @@
 /*
  * AES-NI + SSE4.1 implementation of AEGIS-128
  *
  * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
+ * Copyright 2024 Google LLC
  */
 
 #include <linux/linkage.h>
 #include <asm/frame.h>
 
@@ -26,15 +27,15 @@
 	.byte 0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62
 .Laegis128_const_1:
 	.byte 0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1
 	.byte 0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd
 
-.section .rodata.cst16.aegis128_counter, "aM", @progbits, 16
-.align 16
-.Laegis128_counter:
-	.byte 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
-	.byte 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+.section .rodata.cst32.zeropad_mask, "aM", @progbits, 32
+.align 32
+.Lzeropad_mask:
+	.octa 0xffffffffffffffffffffffffffffffff
+	.octa 0
 
 .text
 
 /*
  * aegis128_update
@@ -53,136 +54,90 @@
 	aesenc STATE3, STATE2
 	aesenc T0,     STATE3
 .endm
 
 /*
- * __load_partial: internal ABI
- * input:
- *   LEN - bytes
- *   SRC - src
- * output:
- *   MSG  - message block
- * changed:
- *   T0
- *   %r8
- *   %r9
+ * Load 1 <= LEN (%ecx) <= 15 bytes from the pointer SRC into the xmm register
+ * MSG and zeroize any remaining bytes.  Clobbers %rax, %rcx, and %r8.
  */
-SYM_FUNC_START_LOCAL(__load_partial)
-	.set LEN, %ecx
-	.set SRC, %rsi
-	xor %r9d, %r9d
-	pxor MSG, MSG
-
-	mov LEN, %r8d
-	and $0x1, %r8
-	jz .Lld_partial_1
-
-	mov LEN, %r8d
-	and $0x1E, %r8
-	add SRC, %r8
-	mov (%r8), %r9b
-
-.Lld_partial_1:
-	mov LEN, %r8d
-	and $0x2, %r8
-	jz .Lld_partial_2
-
-	mov LEN, %r8d
-	and $0x1C, %r8
-	add SRC, %r8
-	shl $0x10, %r9
-	mov (%r8), %r9w
-
-.Lld_partial_2:
-	mov LEN, %r8d
-	and $0x4, %r8
-	jz .Lld_partial_4
-
-	mov LEN, %r8d
-	and $0x18, %r8
-	add SRC, %r8
-	shl $32, %r9
-	mov (%r8), %r8d
-	xor %r8, %r9
-
-.Lld_partial_4:
-	movq %r9, MSG
-
-	mov LEN, %r8d
-	and $0x8, %r8
-	jz .Lld_partial_8
-
-	mov LEN, %r8d
-	and $0x10, %r8
-	add SRC, %r8
-	pslldq $8, MSG
-	movq (%r8), T0
-	pxor T0, MSG
-
-.Lld_partial_8:
-	RET
-SYM_FUNC_END(__load_partial)
+.macro load_partial
+	sub $8, %ecx			/* LEN - 8 */
+	jle .Lle8\@
+
+	/* Load 9 <= LEN <= 15 bytes: */
+	movq (SRC), MSG			/* Load first 8 bytes */
+	mov (SRC, %rcx), %rax		/* Load last 8 bytes */
+	neg %ecx
+	shl $3, %ecx
+	shr %cl, %rax			/* Discard overlapping bytes */
+	pinsrq $1, %rax, MSG
+	jmp .Ldone\@
+
+.Lle8\@:
+	add $4, %ecx			/* LEN - 4 */
+	jl .Llt4\@
+
+	/* Load 4 <= LEN <= 8 bytes: */
+	mov (SRC), %eax			/* Load first 4 bytes */
+	mov (SRC, %rcx), %r8d		/* Load last 4 bytes */
+	jmp .Lcombine\@
+
+.Llt4\@:
+	/* Load 1 <= LEN <= 3 bytes: */
+	add $2, %ecx			/* LEN - 2 */
+	movzbl (SRC), %eax		/* Load first byte */
+	jl .Lmovq\@
+	movzwl (SRC, %rcx), %r8d	/* Load last 2 bytes */
+.Lcombine\@:
+	shl $3, %ecx
+	shl %cl, %r8
+	or %r8, %rax			/* Combine the two parts */
+.Lmovq\@:
+	movq %rax, MSG
+.Ldone\@:
+.endm
 
 /*
- * __store_partial: internal ABI
- * input:
- *   LEN - bytes
- *   DST - dst
- * output:
- *   T0   - message block
- * changed:
- *   %r8
- *   %r9
- *   %r10
+ * Store 1 <= LEN (%ecx) <= 15 bytes from the xmm register \msg to the pointer
+ * DST.  Clobbers %rax, %rcx, and %r8.
  */
-SYM_FUNC_START_LOCAL(__store_partial)
-	.set LEN, %ecx
-	.set DST, %rdx
-	mov LEN, %r8d
-	mov DST, %r9
-
-	movq T0, %r10
-
-	cmp $8, %r8
-	jl .Lst_partial_8
-
-	mov %r10, (%r9)
-	psrldq $8, T0
-	movq T0, %r10
-
-	sub $8, %r8
-	add $8, %r9
-
-.Lst_partial_8:
-	cmp $4, %r8
-	jl .Lst_partial_4
-
-	mov %r10d, (%r9)
-	shr $32, %r10
-
-	sub $4, %r8
-	add $4, %r9
-
-.Lst_partial_4:
-	cmp $2, %r8
-	jl .Lst_partial_2
-
-	mov %r10w, (%r9)
-	shr $0x10, %r10
-
-	sub $2, %r8
-	add $2, %r9
-
-.Lst_partial_2:
-	cmp $1, %r8
-	jl .Lst_partial_1
-
-	mov %r10b, (%r9)
-
-.Lst_partial_1:
-	RET
-SYM_FUNC_END(__store_partial)
+.macro store_partial msg
+	sub $8, %ecx			/* LEN - 8 */
+	jl .Llt8\@
+
+	/* Store 8 <= LEN <= 15 bytes: */
+	pextrq $1, \msg, %rax
+	mov %ecx, %r8d
+	shl $3, %ecx
+	ror %cl, %rax
+	mov %rax, (DST, %r8)		/* Store last LEN - 8 bytes */
+	movq \msg, (DST)		/* Store first 8 bytes */
+	jmp .Ldone\@
+
+.Llt8\@:
+	add $4, %ecx			/* LEN - 4 */
+	jl .Llt4\@
+
+	/* Store 4 <= LEN <= 7 bytes: */
+	pextrd $1, \msg, %eax
+	mov %ecx, %r8d
+	shl $3, %ecx
+	ror %cl, %eax
+	mov %eax, (DST, %r8)		/* Store last LEN - 4 bytes */
+	movd \msg, (DST)		/* Store first 4 bytes */
+	jmp .Ldone\@
+
+.Llt4\@:
+	/* Store 1 <= LEN <= 3 bytes: */
+	pextrb $0, \msg, 0(DST)
+	cmp $-2, %ecx			/* LEN - 4 == -2, i.e. LEN == 2? */
+	jl .Ldone\@
+	pextrb $1, \msg, 1(DST)
+	je .Ldone\@
+	pextrb $2, \msg, 2(DST)
+.Ldone\@:
+.endm
 
 /*
  * void aegis128_aesni_init(struct aegis_state *state,
  *			    const struct aegis_block *key,
  *			    const u8 iv[AEGIS128_NONCE_SIZE]);
@@ -451,31 +406,33 @@ SYM_FUNC_END(aegis128_aesni_enc)
  */
 SYM_FUNC_START(aegis128_aesni_enc_tail)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
-	.set LEN, %ecx
+	.set LEN, %ecx	/* {load,store}_partial rely on this being %ecx */
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
 	/* encrypt message: */
-	call __load_partial
+	mov LEN, %r9d
+	load_partial
 
 	movdqa MSG, T0
 	pxor STATE1, T0
 	pxor STATE4, T0
 	movdqa STATE2, T1
 	pand STATE3, T1
 	pxor T1, T0
 
-	call __store_partial
+	mov %r9d, LEN
+	store_partial T0
 
 	aegis128_update
 	pxor MSG, STATE4
 
 	/* store the state: */
@@ -596,40 +553,37 @@ SYM_FUNC_END(aegis128_aesni_dec)
  */
 SYM_FUNC_START(aegis128_aesni_dec_tail)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
-	.set LEN, %ecx
+	.set LEN, %ecx	/* {load,store}_partial rely on this being %ecx */
 	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
 	/* decrypt message: */
-	call __load_partial
+	mov LEN, %r9d
+	load_partial
 
 	pxor STATE1, MSG
 	pxor STATE4, MSG
 	movdqa STATE2, T1
 	pand STATE3, T1
 	pxor T1, MSG
 
-	movdqa MSG, T0
-	call __store_partial
+	mov %r9d, LEN
+	store_partial MSG
 
 	/* mask with byte count: */
-	movd LEN, T0
-	punpcklbw T0, T0
-	punpcklbw T0, T0
-	punpcklbw T0, T0
-	punpcklbw T0, T0
-	movdqa .Laegis128_counter(%rip), T1
-	pcmpgtb T1, T0
+	lea .Lzeropad_mask+16(%rip), %rax
+	sub %r9, %rax
+	movdqu (%rax), T0
 	pand T0, MSG
 
 	aegis128_update
 	pxor MSG, STATE4
 
-- 
2.47.0

