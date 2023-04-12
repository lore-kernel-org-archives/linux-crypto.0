Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A014C77B71
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDLLBT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjDLLBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB527680
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D2263256
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F030C4339E;
        Wed, 12 Apr 2023 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297267;
        bh=52LINBgS3GLlIA5zBqsuswDWcuMBpD6xa5rGbvxGo5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZYgnng/Kgp++RGyTQl9dKrzzekbmtn5C2+qYxmUv23GMFxyx9f8YkAbjAQuE7M7E
         VnE93uZZeBhC+noBSFiDBxMRfh2r0Ba+FmEdHkX2v4HwgihEE7T35TKxSmiqlmJ6xA
         n9tTfiSwlQazjMa/BY5TsZssUX+FridgmGf/rsYGLkFe63l+bf9IbA5RVeyTK5fhfF
         JmuB9xO8A7PF637KANaXiX/hOJxyI/D0F0wfFvyI2t6IZl5iyrI926IJMS0lOWJYtK
         e4voMra2kZDCUDsKvd3BSqHPBaAV23292yij6ynTSJfaO6aEeEuPS8jDizdtt5fGGo
         hrubSQRBvSD7w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 13/13] crypto: x86/sha - Use local .L symbols for code
Date:   Wed, 12 Apr 2023 13:00:35 +0200
Message-Id: <20230412110035.361447-14-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11505; i=ardb@kernel.org; h=from:subject; bh=52LINBgS3GLlIA5zBqsuswDWcuMBpD6xa5rGbvxGo5I=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWsP7hbVljxfMKO1Jttdqx8Czz3LWhSWismP3193GWFS wsn3rzYUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACay5h4jwxKd9jeS56Na+w15 lS5VKZv4Le/TMe197/f7/+mcO03sPgz/qw/ds3jQ0jGLcU/A2fcWyxSO59yIlb8z27DqlMuay89 TGQA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Avoid cluttering up the kallsyms symbol table with entries that should
not end up in things like backtraces, as they have undescriptive and
generated identifiers.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S | 25 ++++----------
 arch/x86/crypto/sha256-avx-asm.S       | 16 ++++-----
 arch/x86/crypto/sha256-avx2-asm.S      | 36 ++++++++++----------
 arch/x86/crypto/sha256-ssse3-asm.S     | 16 ++++-----
 arch/x86/crypto/sha512-avx-asm.S       |  8 ++---
 arch/x86/crypto/sha512-avx2-asm.S      | 16 ++++-----
 arch/x86/crypto/sha512-ssse3-asm.S     |  8 ++---
 7 files changed, 57 insertions(+), 68 deletions(-)

diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index a96b2fd26dab4bb5..4b49bdc9526583d6 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -485,18 +485,18 @@
 	xchg	WK_BUF, PRECALC_BUF
 
 	.align 32
-_loop:
+.L_loop:
 	/*
 	 * code loops through more than one block
 	 * we use K_BASE value as a signal of a last block,
 	 * it is set below by: cmovae BUFFER_PTR, K_BASE
 	 */
 	test BLOCKS_CTR, BLOCKS_CTR
-	jnz _begin
+	jnz .L_begin
 	.align 32
-	jmp	_end
+	jmp	.L_end
 	.align 32
-_begin:
+.L_begin:
 
 	/*
 	 * Do first block
@@ -508,9 +508,6 @@ _begin:
 		.set j, j+2
 	.endr
 
-	jmp _loop0
-_loop0:
-
 	/*
 	 * rounds:
 	 * 10,12,14,16,18
@@ -545,7 +542,7 @@ _loop0:
 	UPDATE_HASH	16(HASH_PTR), E
 
 	test	BLOCKS_CTR, BLOCKS_CTR
-	jz	_loop
+	jz	.L_loop
 
 	mov	TB, B
 
@@ -562,8 +559,6 @@ _loop0:
 		.set j, j+2
 	.endr
 
-	jmp	_loop1
-_loop1:
 	/*
 	 * rounds
 	 * 20+80,22+80,24+80,26+80,28+80
@@ -574,9 +569,6 @@ _loop1:
 		.set j, j+2
 	.endr
 
-	jmp	_loop2
-_loop2:
-
 	/*
 	 * rounds
 	 * 40+80,42+80,44+80,46+80,48+80
@@ -592,9 +584,6 @@ _loop2:
 	/* Move to the next block only if needed*/
 	ADD_IF_GE BUFFER_PTR2, BLOCKS_CTR, 4, 128
 
-	jmp	_loop3
-_loop3:
-
 	/*
 	 * rounds
 	 * 60+80,62+80,64+80,66+80,68+80
@@ -623,10 +612,10 @@ _loop3:
 
 	xchg	WK_BUF, PRECALC_BUF
 
-	jmp	_loop
+	jmp	.L_loop
 
 	.align 32
-	_end:
+.L_end:
 
 .endm
 /*
diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 5555b5d5215a449e..53de72bdd851ec8d 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -360,7 +360,7 @@ SYM_TYPED_FUNC_START(sha256_transform_avx)
 	and	$~15, %rsp		# align stack pointer
 
 	shl     $6, NUM_BLKS		# convert to bytes
-	jz      done_hash
+	jz      .Ldone_hash
 	add     INP, NUM_BLKS		# pointer to end of data
 	mov     NUM_BLKS, _INP_END(%rsp)
 
@@ -377,7 +377,7 @@ SYM_TYPED_FUNC_START(sha256_transform_avx)
 	vmovdqa  PSHUFFLE_BYTE_FLIP_MASK(%rip), BYTE_FLIP_MASK
 	vmovdqa  _SHUF_00BA(%rip), SHUF_00BA
 	vmovdqa  _SHUF_DC00(%rip), SHUF_DC00
-loop0:
+.Lloop0:
 	lea     K256(%rip), TBL
 
 	## byte swap first 16 dwords
@@ -391,7 +391,7 @@ loop0:
 	## schedule 48 input dwords, by doing 3 rounds of 16 each
 	mov     $3, SRND
 .align 16
-loop1:
+.Lloop1:
 	vpaddd  (TBL), X0, XFER
 	vmovdqa XFER, _XFER(%rsp)
 	FOUR_ROUNDS_AND_SCHED
@@ -410,10 +410,10 @@ loop1:
 	FOUR_ROUNDS_AND_SCHED
 
 	sub     $1, SRND
-	jne     loop1
+	jne     .Lloop1
 
 	mov     $2, SRND
-loop2:
+.Lloop2:
 	vpaddd  (TBL), X0, XFER
 	vmovdqa XFER, _XFER(%rsp)
 	DO_ROUND        0
@@ -433,7 +433,7 @@ loop2:
 	vmovdqa X3, X1
 
 	sub     $1, SRND
-	jne     loop2
+	jne     .Lloop2
 
 	addm    (4*0)(CTX),a
 	addm    (4*1)(CTX),b
@@ -447,9 +447,9 @@ loop2:
 	mov     _INP(%rsp), INP
 	add     $64, INP
 	cmp     _INP_END(%rsp), INP
-	jne     loop0
+	jne     .Lloop0
 
-done_hash:
+.Ldone_hash:
 
 	mov	%rbp, %rsp
 	popq	%rbp
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index e2a4024fb0a3f5d5..9918212faf914ffc 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -538,12 +538,12 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	and	$-32, %rsp	# align rsp to 32 byte boundary
 
 	shl	$6, NUM_BLKS	# convert to bytes
-	jz	done_hash
+	jz	.Ldone_hash
 	lea	-64(INP, NUM_BLKS), NUM_BLKS # pointer to last block
 	mov	NUM_BLKS, _INP_END(%rsp)
 
 	cmp	NUM_BLKS, INP
-	je	only_one_block
+	je	.Lonly_one_block
 
 	## load initial digest
 	mov	(CTX), a
@@ -561,7 +561,7 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 
 	mov	CTX, _CTX(%rsp)
 
-loop0:
+.Lloop0:
 	## Load first 16 dwords from two blocks
 	VMOVDQ	0*32(INP),XTMP0
 	VMOVDQ	1*32(INP),XTMP1
@@ -580,7 +580,7 @@ loop0:
 	vperm2i128	$0x20, XTMP3, XTMP1, X2
 	vperm2i128	$0x31, XTMP3, XTMP1, X3
 
-last_block_enter:
+.Llast_block_enter:
 	add	$64, INP
 	mov	INP, _INP(%rsp)
 
@@ -588,7 +588,7 @@ last_block_enter:
 	xor	SRND, SRND
 
 .align 16
-loop1:
+.Lloop1:
 	leaq	K256+0*32(%rip), INP		## reuse INP as scratch reg
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
@@ -611,9 +611,9 @@ loop1:
 
 	add	$4*32, SRND
 	cmp	$3*4*32, SRND
-	jb	loop1
+	jb	.Lloop1
 
-loop2:
+.Lloop2:
 	## Do last 16 rounds with no scheduling
 	leaq	K256+0*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
@@ -630,7 +630,7 @@ loop2:
 	vmovdqa	X3, X1
 
 	cmp	$4*4*32, SRND
-	jb	loop2
+	jb	.Lloop2
 
 	mov	_CTX(%rsp), CTX
 	mov	_INP(%rsp), INP
@@ -645,17 +645,17 @@ loop2:
 	addm    (4*7)(CTX),h
 
 	cmp	_INP_END(%rsp), INP
-	ja	done_hash
+	ja	.Ldone_hash
 
 	#### Do second block using previously scheduled results
 	xor	SRND, SRND
 .align 16
-loop3:
+.Lloop3:
 	DO_4ROUNDS	 _XFER + 0*32 + 16
 	DO_4ROUNDS	 _XFER + 1*32 + 16
 	add	$2*32, SRND
 	cmp	$4*4*32, SRND
-	jb	loop3
+	jb	.Lloop3
 
 	mov	_CTX(%rsp), CTX
 	mov	_INP(%rsp), INP
@@ -671,10 +671,10 @@ loop3:
 	addm    (4*7)(CTX),h
 
 	cmp	_INP_END(%rsp), INP
-	jb	loop0
-	ja	done_hash
+	jb	.Lloop0
+	ja	.Ldone_hash
 
-do_last_block:
+.Ldo_last_block:
 	VMOVDQ	0*16(INP),XWORD0
 	VMOVDQ	1*16(INP),XWORD1
 	VMOVDQ	2*16(INP),XWORD2
@@ -685,9 +685,9 @@ do_last_block:
 	vpshufb	X_BYTE_FLIP_MASK, XWORD2, XWORD2
 	vpshufb	X_BYTE_FLIP_MASK, XWORD3, XWORD3
 
-	jmp	last_block_enter
+	jmp	.Llast_block_enter
 
-only_one_block:
+.Lonly_one_block:
 
 	## load initial digest
 	mov	(4*0)(CTX),a
@@ -704,9 +704,9 @@ only_one_block:
 	vmovdqa	_SHUF_DC00(%rip), SHUF_DC00
 
 	mov	CTX, _CTX(%rsp)
-	jmp	do_last_block
+	jmp	.Ldo_last_block
 
-done_hash:
+.Ldone_hash:
 
 	mov	%rbp, %rsp
 	pop	%rbp
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index 959288eecc689891..93264ee4454325b9 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -369,7 +369,7 @@ SYM_TYPED_FUNC_START(sha256_transform_ssse3)
 	and	$~15, %rsp
 
 	shl     $6, NUM_BLKS		 # convert to bytes
-	jz      done_hash
+	jz      .Ldone_hash
 	add     INP, NUM_BLKS
 	mov     NUM_BLKS, _INP_END(%rsp) # pointer to end of data
 
@@ -387,7 +387,7 @@ SYM_TYPED_FUNC_START(sha256_transform_ssse3)
 	movdqa  _SHUF_00BA(%rip), SHUF_00BA
 	movdqa  _SHUF_DC00(%rip), SHUF_DC00
 
-loop0:
+.Lloop0:
 	lea     K256(%rip), TBL
 
 	## byte swap first 16 dwords
@@ -401,7 +401,7 @@ loop0:
 	## schedule 48 input dwords, by doing 3 rounds of 16 each
 	mov     $3, SRND
 .align 16
-loop1:
+.Lloop1:
 	movdqa  (TBL), XFER
 	paddd   X0, XFER
 	movdqa  XFER, _XFER(%rsp)
@@ -424,10 +424,10 @@ loop1:
 	FOUR_ROUNDS_AND_SCHED
 
 	sub     $1, SRND
-	jne     loop1
+	jne     .Lloop1
 
 	mov     $2, SRND
-loop2:
+.Lloop2:
 	paddd   (TBL), X0
 	movdqa  X0, _XFER(%rsp)
 	DO_ROUND        0
@@ -446,7 +446,7 @@ loop2:
 	movdqa  X3, X1
 
 	sub     $1, SRND
-	jne     loop2
+	jne     .Lloop2
 
 	addm    (4*0)(CTX),a
 	addm    (4*1)(CTX),b
@@ -460,9 +460,9 @@ loop2:
 	mov     _INP(%rsp), INP
 	add     $64, INP
 	cmp     _INP_END(%rsp), INP
-	jne     loop0
+	jne     .Lloop0
 
-done_hash:
+.Ldone_hash:
 
 	mov	%rbp, %rsp
 	popq	%rbp
diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index b0984f19fdb408e9..d902b8ea07218467 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -276,7 +276,7 @@ frame_size = frame_WK + WK_SIZE
 ########################################################################
 SYM_TYPED_FUNC_START(sha512_transform_avx)
 	test msglen, msglen
-	je nowork
+	je .Lnowork
 
 	# Save GPRs
 	push	%rbx
@@ -291,7 +291,7 @@ SYM_TYPED_FUNC_START(sha512_transform_avx)
 	sub     $frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
-updateblock:
+.Lupdateblock:
 
 	# Load state variables
 	mov     DIGEST(0), a_64
@@ -348,7 +348,7 @@ updateblock:
 	# Advance to next message block
 	add     $16*8, msg
 	dec     msglen
-	jnz     updateblock
+	jnz     .Lupdateblock
 
 	# Restore Stack Pointer
 	mov	%rbp, %rsp
@@ -361,7 +361,7 @@ updateblock:
 	pop	%r12
 	pop	%rbx
 
-nowork:
+.Lnowork:
 	RET
 SYM_FUNC_END(sha512_transform_avx)
 
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index b1ca99055ef994f5..f08496cd68708fde 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -581,7 +581,7 @@ SYM_TYPED_FUNC_START(sha512_transform_rorx)
 	and	$~(0x20 - 1), %rsp
 
 	shl	$7, NUM_BLKS	# convert to bytes
-	jz	done_hash
+	jz	.Ldone_hash
 	add	INP, NUM_BLKS	# pointer to end of data
 	mov	NUM_BLKS, frame_INPEND(%rsp)
 
@@ -600,7 +600,7 @@ SYM_TYPED_FUNC_START(sha512_transform_rorx)
 
 	vmovdqa	PSHUFFLE_BYTE_FLIP_MASK(%rip), BYTE_FLIP_MASK
 
-loop0:
+.Lloop0:
 	lea	K512(%rip), TBL
 
 	## byte swap first 16 dwords
@@ -615,7 +615,7 @@ loop0:
 	movq	$4, frame_SRND(%rsp)
 
 .align 16
-loop1:
+.Lloop1:
 	vpaddq	(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
 	FOUR_ROUNDS_AND_SCHED
@@ -634,10 +634,10 @@ loop1:
 	FOUR_ROUNDS_AND_SCHED
 
 	subq	$1, frame_SRND(%rsp)
-	jne	loop1
+	jne	.Lloop1
 
 	movq	$2, frame_SRND(%rsp)
-loop2:
+.Lloop2:
 	vpaddq	(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
 	DO_4ROUNDS
@@ -650,7 +650,7 @@ loop2:
 	vmovdqa	Y_3, Y_1
 
 	subq	$1, frame_SRND(%rsp)
-	jne	loop2
+	jne	.Lloop2
 
 	mov	frame_CTX(%rsp), CTX2
 	addm	8*0(CTX2), a
@@ -665,9 +665,9 @@ loop2:
 	mov	frame_INP(%rsp), INP
 	add	$128, INP
 	cmp	frame_INPEND(%rsp), INP
-	jne	loop0
+	jne	.Lloop0
 
-done_hash:
+.Ldone_hash:
 
 	# Restore Stack Pointer
 	mov	%rbp, %rsp
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index c06afb5270e5f578..65be301568162654 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -278,7 +278,7 @@ frame_size = frame_WK + WK_SIZE
 SYM_TYPED_FUNC_START(sha512_transform_ssse3)
 
 	test msglen, msglen
-	je nowork
+	je .Lnowork
 
 	# Save GPRs
 	push	%rbx
@@ -293,7 +293,7 @@ SYM_TYPED_FUNC_START(sha512_transform_ssse3)
 	sub	$frame_size, %rsp
 	and	$~(0x20 - 1), %rsp
 
-updateblock:
+.Lupdateblock:
 
 # Load state variables
 	mov	DIGEST(0), a_64
@@ -350,7 +350,7 @@ updateblock:
 	# Advance to next message block
 	add	$16*8, msg
 	dec	msglen
-	jnz	updateblock
+	jnz	.Lupdateblock
 
 	# Restore Stack Pointer
 	mov	%rbp, %rsp
@@ -363,7 +363,7 @@ updateblock:
 	pop	%r12
 	pop	%rbx
 
-nowork:
+.Lnowork:
 	RET
 SYM_FUNC_END(sha512_transform_ssse3)
 
-- 
2.39.2

