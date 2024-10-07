Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51651400A
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264297; cv=none; b=Kvj9PnrLFIrIBxgk8CUFZ6Zo2X/Y/s3fWGRa8WqhzBLrWU0MzpUzN7hF/LuS2E/uSnsB+T735uVsewb48kKgAKU85TjpvBGu64ee6XWuBlvTdOgElcIq1RhxN71dfpLE8ZRQN7e87OgkqSqcQ5tWm8TpEZf4411z2gNJGR0hs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264297; c=relaxed/simple;
	bh=FXaqnIAcJV0N/u6qISeo3QSKQe4ZIHKKUs0+RYVsROo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NETEhA4zV2mOdLfulKXqd0HY6pd7y9lFrRAkaU9Q6J/c9P1BD21n2l1DSc3R2ObG9BMkbmowemPq2wJSfOmp2fINu6AkpCBSpHhycALjRk38IaOROZhJiWnjcQDvOS5NnKsjKAAEWkGeED6Gnttcwj/UtoyrMMFSwgo+pDlPYr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwW+4si7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwW+4si7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FCEC4CECF;
	Mon,  7 Oct 2024 01:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264297;
	bh=FXaqnIAcJV0N/u6qISeo3QSKQe4ZIHKKUs0+RYVsROo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwW+4si7BuZ1e/P9jb6orFFaJ4ulAG9OgWzSXi/sM+wU40jVCFGuHwF8XUrVuUnDF
	 +Q4pV/9A8pguddscDYl9B9tfY3HlF79MbUZqIwhsHMJAmwTOTW4s03k+yoDR58anoa
	 9gQtuR1qNjkNk3zR++6rM4ERpQREDaUxFJHZBPzWHAlCdhXM2Z8iP7T0V5pdwMsIC4
	 ARtdOpzZSDfyYQPKL+jjJV6iyUxwwXpWn3sVIDKQzT1w7hUjfr4KgHia1V1wDuDrKw
	 DjYPE35zedXj3jsM3kDPj/AShaySTWe7JTH59vfwmnz2zFJAk1Ut6J0ilQ2Ijb4Ak0
	 W2ynl57SA+gXw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 07/10] crypto: x86/aegis128 - optimize partial block handling using SSE4.1
Date: Sun,  6 Oct 2024 18:24:27 -0700
Message-ID: <20241007012430.163606-8-ebiggers@kernel.org>
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

Optimize the code that loads and stores partial blocks, taking advantage
of SSE4.1.  The code is adapted from that in aes-gcm-aesni-x86_64.S.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 236 +++++++++++----------------
 1 file changed, 95 insertions(+), 141 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 8131903cc7ff..b5c7abc9a0d4 100644
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
2.46.2

