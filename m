Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170D1C77B76
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDLLBT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjDLLBO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD772BE
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B55A762889
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066C3C4339B;
        Wed, 12 Apr 2023 11:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297266;
        bh=5OVijsRVQVtqmMk0R5SCMF+TcfjOykH+XE0rrmzmn+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LT0lH7d+1EOQ537YAhmnobGOrnO5Z0TOPJxRCHOIDltu9hGN8VXyGEk+8aDbDtFuQ
         cgx6fIqTFhVhCXHsT3l6cbAgX2UVPnHfAwidld/TSZssLPdbYK5BGNoXrZ81gTmQmy
         G2bJcrQDl7lsv/7P5FtmhILdbKdDFZgnPko6kMUD9gQMx3NDeHULKD3yP88mEWaq3Y
         wmO9A4WNyiGCxcKYerrQwTcdOOSZ2joh6HPn6Ev7ZOJWvRn6Jn4jaIHtKaSXWxiWGv
         v2hiKzbAmFRzb+hirw1mZXJtWGny37LBz/75zNKrvL5BBplLclOAyReaFWo8I0fV4E
         /2B83cPFCLgtQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 12/13] crypto: x86/crc32 - Use local .L symbols for code
Date:   Wed, 12 Apr 2023 13:00:34 +0200
Message-Id: <20230412110035.361447-13-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7697; i=ardb@kernel.org; h=from:subject; bh=5OVijsRVQVtqmMk0R5SCMF+TcfjOykH+XE0rrmzmn+U=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWsP1BA9Om/x9uPVakWtEXxfr+7S6jzyNfNd8Tqfi7YW uC9Yt2BjlIWBjEOBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARqQBGhk72N/nH5poe4qhy ZGfw4V4Vyex/8J/Xy9TVd8RPbi8wnszwP6d0ydXOqdedkkvtT2za4L5U2ptxlVyKuq2XhE7zlQg eJgA=
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
 arch/x86/crypto/crc32-pclmul_asm.S        | 16 ++---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 67 ++++++++++----------
 2 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index ca53e96996ac2143..5d31137e2c7dfca0 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -90,7 +90,7 @@ SYM_FUNC_START(crc32_pclmul_le_16) /* buffer and buffer size are 16 bytes aligne
 	sub     $0x40, LEN
 	add     $0x40, BUF
 	cmp     $0x40, LEN
-	jb      less_64
+	jb      .Lless_64
 
 #ifdef __x86_64__
 	movdqa .Lconstant_R2R1(%rip), CONSTANT
@@ -98,7 +98,7 @@ SYM_FUNC_START(crc32_pclmul_le_16) /* buffer and buffer size are 16 bytes aligne
 	movdqa .Lconstant_R2R1, CONSTANT
 #endif
 
-loop_64:/*  64 bytes Full cache line folding */
+.Lloop_64:/*  64 bytes Full cache line folding */
 	prefetchnta    0x40(BUF)
 	movdqa  %xmm1, %xmm5
 	movdqa  %xmm2, %xmm6
@@ -139,8 +139,8 @@ loop_64:/*  64 bytes Full cache line folding */
 	sub     $0x40, LEN
 	add     $0x40, BUF
 	cmp     $0x40, LEN
-	jge     loop_64
-less_64:/*  Folding cache line into 128bit */
+	jge     .Lloop_64
+.Lless_64:/*  Folding cache line into 128bit */
 #ifdef __x86_64__
 	movdqa  .Lconstant_R4R3(%rip), CONSTANT
 #else
@@ -167,8 +167,8 @@ less_64:/*  Folding cache line into 128bit */
 	pxor    %xmm4, %xmm1
 
 	cmp     $0x10, LEN
-	jb      fold_64
-loop_16:/* Folding rest buffer into 128bit */
+	jb      .Lfold_64
+.Lloop_16:/* Folding rest buffer into 128bit */
 	movdqa  %xmm1, %xmm5
 	pclmulqdq $0x00, CONSTANT, %xmm1
 	pclmulqdq $0x11, CONSTANT, %xmm5
@@ -177,9 +177,9 @@ loop_16:/* Folding rest buffer into 128bit */
 	sub     $0x10, LEN
 	add     $0x10, BUF
 	cmp     $0x10, LEN
-	jge     loop_16
+	jge     .Lloop_16
 
-fold_64:
+.Lfold_64:
 	/* perform the last 64 bit fold, also adds 32 zeroes
 	 * to the input stream */
 	pclmulqdq $0x01, %xmm1, CONSTANT /* R4 * xmm1.low */
diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 5f843dce77f1de66..81ce0f4db555ce03 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -49,15 +49,15 @@
 ## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
 
 .macro LABEL prefix n
-\prefix\n\():
+.L\prefix\n\():
 .endm
 
 .macro JMPTBL_ENTRY i
-.quad crc_\i
+.quad .Lcrc_\i
 .endm
 
 .macro JNC_LESS_THAN j
-	jnc less_than_\j
+	jnc .Lless_than_\j
 .endm
 
 # Define threshold where buffers are considered "small" and routed to more
@@ -108,30 +108,30 @@ SYM_FUNC_START(crc_pcl)
 	neg     %bufp
 	and     $7, %bufp		# calculate the unalignment amount of
 					# the address
-	je      proc_block		# Skip if aligned
+	je      .Lproc_block		# Skip if aligned
 
 	## If len is less than 8 and we're unaligned, we need to jump
 	## to special code to avoid reading beyond the end of the buffer
 	cmp     $8, len
-	jae     do_align
+	jae     .Ldo_align
 	# less_than_8 expects length in upper 3 bits of len_dw
 	# less_than_8_post_shl1 expects length = carryflag * 8 + len_dw[31:30]
 	shl     $32-3+1, len_dw
-	jmp     less_than_8_post_shl1
+	jmp     .Lless_than_8_post_shl1
 
-do_align:
+.Ldo_align:
 	#### Calculate CRC of unaligned bytes of the buffer (if any)
 	movq    (bufptmp), tmp		# load a quadward from the buffer
 	add     %bufp, bufptmp		# align buffer pointer for quadword
 					# processing
 	sub     %bufp, len		# update buffer length
-align_loop:
+.Lalign_loop:
 	crc32b  %bl, crc_init_dw 	# compute crc32 of 1-byte
 	shr     $8, tmp			# get next byte
 	dec     %bufp
-	jne     align_loop
+	jne     .Lalign_loop
 
-proc_block:
+.Lproc_block:
 
 	################################################################
 	## 2) PROCESS  BLOCKS:
@@ -141,11 +141,11 @@ proc_block:
 	movq    len, tmp		# save num bytes in tmp
 
 	cmpq    $128*24, len
-	jae     full_block
+	jae     .Lfull_block
 
-continue_block:
+.Lcontinue_block:
 	cmpq    $SMALL_SIZE, len
-	jb      small
+	jb      .Lsmall
 
 	## len < 128*24
 	movq    $2731, %rax		# 2731 = ceil(2^16 / 24)
@@ -175,7 +175,7 @@ continue_block:
 	################################################################
 	## 2a) PROCESS FULL BLOCKS:
 	################################################################
-full_block:
+.Lfull_block:
 	movl    $128,%eax
 	lea     128*8*2(block_0), block_1
 	lea     128*8*3(block_0), block_2
@@ -190,7 +190,6 @@ full_block:
 	## 3) CRC Array:
 	################################################################
 
-crc_array:
 	i=128
 .rept 128-1
 .altmacro
@@ -243,28 +242,28 @@ LABEL crc_ 0
 	ENDBR
 	mov     tmp, len
 	cmp     $128*24, tmp
-	jae     full_block
+	jae     .Lfull_block
 	cmp     $24, tmp
-	jae     continue_block
+	jae     .Lcontinue_block
 
-less_than_24:
+.Lless_than_24:
 	shl     $32-4, len_dw			# less_than_16 expects length
 						# in upper 4 bits of len_dw
-	jnc     less_than_16
+	jnc     .Lless_than_16
 	crc32q  (bufptmp), crc_init
 	crc32q  8(bufptmp), crc_init
-	jz      do_return
+	jz      .Ldo_return
 	add     $16, bufptmp
 	# len is less than 8 if we got here
 	# less_than_8 expects length in upper 3 bits of len_dw
 	# less_than_8_post_shl1 expects length = carryflag * 8 + len_dw[31:30]
 	shl     $2, len_dw
-	jmp     less_than_8_post_shl1
+	jmp     .Lless_than_8_post_shl1
 
 	#######################################################################
 	## 6) LESS THAN 256-bytes REMAIN AT THIS POINT (8-bits of len are full)
 	#######################################################################
-small:
+.Lsmall:
 	shl $32-8, len_dw		# Prepare len_dw for less_than_256
 	j=256
 .rept 5					# j = {256, 128, 64, 32, 16}
@@ -280,32 +279,32 @@ LABEL less_than_ %j			# less_than_j: Length should be in
 	crc32q  i(bufptmp), crc_init	# Compute crc32 of 8-byte data
 	i=i+8
 .endr
-	jz      do_return		# Return if remaining length is zero
+	jz      .Ldo_return		# Return if remaining length is zero
 	add     $j, bufptmp		# Advance buf
 .endr
 
-less_than_8:				# Length should be stored in
+.Lless_than_8:				# Length should be stored in
 					# upper 3 bits of len_dw
 	shl     $1, len_dw
-less_than_8_post_shl1:
-	jnc     less_than_4
+.Lless_than_8_post_shl1:
+	jnc     .Lless_than_4
 	crc32l  (bufptmp), crc_init_dw	# CRC of 4 bytes
-	jz      do_return		# return if remaining data is zero
+	jz      .Ldo_return		# return if remaining data is zero
 	add     $4, bufptmp
-less_than_4:				# Length should be stored in
+.Lless_than_4:				# Length should be stored in
 					# upper 2 bits of len_dw
 	shl     $1, len_dw
-	jnc     less_than_2
+	jnc     .Lless_than_2
 	crc32w  (bufptmp), crc_init_dw	# CRC of 2 bytes
-	jz      do_return		# return if remaining data is zero
+	jz      .Ldo_return		# return if remaining data is zero
 	add     $2, bufptmp
-less_than_2:				# Length should be stored in the MSB
+.Lless_than_2:				# Length should be stored in the MSB
 					# of len_dw
 	shl     $1, len_dw
-	jnc     less_than_1
+	jnc     .Lless_than_1
 	crc32b  (bufptmp), crc_init_dw	# CRC of 1 byte
-less_than_1:				# Length should be zero
-do_return:
+.Lless_than_1:				# Length should be zero
+.Ldo_return:
 	movq    crc_init, %rax
 	popq    %rsi
 	popq    %rdi
-- 
2.39.2

