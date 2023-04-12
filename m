Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF624C77B72
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDLLBS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDLLBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E50E7689
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DCC4632EB
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4949DC433EF;
        Wed, 12 Apr 2023 11:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297264;
        bh=3mcZYgQbypouEIMQmPkYqYgFzytdi22IcIznW9aErXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDH/yYtCETUgsXWoVpNSoAFbD5dYq3OdeO2Zw7q+4/5UIN1wC1dePdVyW//ibPP2W
         EFTon8mFN2mSTiYRQO0yRWK14nLdDbsqmYr5MzDAkoE9D3lZUXUCpy7bZrKw5RpjTN
         acn8gsa1yg8Ka00z502jLpM0/lq1B5kOEGGsLlEz+862+wyRtPIMAM79RkWcCQ+rbn
         ayn5SsEl4Kw94rXSriRcnW/3HtkLu7xE01GzaZFrBBYHi/vTThWjVsgwUumk2T2l6k
         JVB3GRRaRU2KXs7ZlxBcQNUtx7jGx9d3KRLI7OD52tOWLlr4WaXdBmVM2T5A+sV8TF
         Asv9QToxUs2EA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 11/13] crypto: x86/aesni - Use local .L symbols for code
Date:   Wed, 12 Apr 2023 13:00:33 +0200
Message-Id: <20230412110035.361447-12-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=33576; i=ardb@kernel.org; h=from:subject; bh=3mcZYgQbypouEIMQmPkYqYgFzytdi22IcIznW9aErXQ=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWsP8D8p12m866TbPcFfO7cY/v2vj/9adbVhrTGtNh5w e9uTirtKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNZ85jhf+Wvd05rbqTdbhFa a5YSk7SbTeNqKO+vIydeiL/+ksbdPZvhvwPXjY1zWW9Z7FXWYZQ+xL6Gy2rHjGNp/MaFaY9WHDM MZQQA
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
 arch/x86/crypto/aesni-intel_asm.S        | 196 +++++++++---------
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 218 ++++++++++----------
 2 files changed, 207 insertions(+), 207 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index ca99a2274d551015..3ac7487ecad2d3f0 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -288,53 +288,53 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	# Encrypt/Decrypt first few blocks
 
 	and	$(3<<4), %r12
-	jz	_initial_num_blocks_is_0_\@
+	jz	.L_initial_num_blocks_is_0_\@
 	cmp	$(2<<4), %r12
-	jb	_initial_num_blocks_is_1_\@
-	je	_initial_num_blocks_is_2_\@
-_initial_num_blocks_is_3_\@:
+	jb	.L_initial_num_blocks_is_1_\@
+	je	.L_initial_num_blocks_is_2_\@
+.L_initial_num_blocks_is_3_\@:
 	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, \operation
 	sub	$48, %r13
-	jmp	_initial_blocks_\@
-_initial_num_blocks_is_2_\@:
+	jmp	.L_initial_blocks_\@
+.L_initial_num_blocks_is_2_\@:
 	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, \operation
 	sub	$32, %r13
-	jmp	_initial_blocks_\@
-_initial_num_blocks_is_1_\@:
+	jmp	.L_initial_blocks_\@
+.L_initial_num_blocks_is_1_\@:
 	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, \operation
 	sub	$16, %r13
-	jmp	_initial_blocks_\@
-_initial_num_blocks_is_0_\@:
+	jmp	.L_initial_blocks_\@
+.L_initial_num_blocks_is_0_\@:
 	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, \operation
-_initial_blocks_\@:
+.L_initial_blocks_\@:
 
 	# Main loop - Encrypt/Decrypt remaining blocks
 
 	test	%r13, %r13
-	je	_zero_cipher_left_\@
+	je	.L_zero_cipher_left_\@
 	sub	$64, %r13
-	je	_four_cipher_left_\@
-_crypt_by_4_\@:
+	je	.L_four_cipher_left_\@
+.L_crypt_by_4_\@:
 	GHASH_4_ENCRYPT_4_PARALLEL_\operation	%xmm9, %xmm10, %xmm11, %xmm12, \
 	%xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, \
 	%xmm7, %xmm8, enc
 	add	$64, %r11
 	sub	$64, %r13
-	jne	_crypt_by_4_\@
-_four_cipher_left_\@:
+	jne	.L_crypt_by_4_\@
+.L_four_cipher_left_\@:
 	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, \
 %xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
-_zero_cipher_left_\@:
+.L_zero_cipher_left_\@:
 	movdqu %xmm8, AadHash(%arg2)
 	movdqu %xmm0, CurCount(%arg2)
 
 	mov	%arg5, %r13
 	and	$15, %r13			# %r13 = arg5 (mod 16)
-	je	_multiple_of_16_bytes_\@
+	je	.L_multiple_of_16_bytes_\@
 
 	mov %r13, PBlockLen(%arg2)
 
@@ -348,14 +348,14 @@ _zero_cipher_left_\@:
 	movdqu %xmm0, PBlockEncKey(%arg2)
 
 	cmp	$16, %arg5
-	jge _large_enough_update_\@
+	jge	.L_large_enough_update_\@
 
 	lea (%arg4,%r11,1), %r10
 	mov %r13, %r12
 	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
-	jmp _data_read_\@
+	jmp	.L_data_read_\@
 
-_large_enough_update_\@:
+.L_large_enough_update_\@:
 	sub	$16, %r11
 	add	%r13, %r11
 
@@ -374,7 +374,7 @@ _large_enough_update_\@:
 	# shift right 16-r13 bytes
 	pshufb  %xmm2, %xmm1
 
-_data_read_\@:
+.L_data_read_\@:
 	lea ALL_F+16(%rip), %r12
 	sub %r13, %r12
 
@@ -409,19 +409,19 @@ _data_read_\@:
 	# Output %r13 bytes
 	movq %xmm0, %rax
 	cmp $8, %r13
-	jle _less_than_8_bytes_left_\@
+	jle .L_less_than_8_bytes_left_\@
 	mov %rax, (%arg3 , %r11, 1)
 	add $8, %r11
 	psrldq $8, %xmm0
 	movq %xmm0, %rax
 	sub $8, %r13
-_less_than_8_bytes_left_\@:
+.L_less_than_8_bytes_left_\@:
 	mov %al,  (%arg3, %r11, 1)
 	add $1, %r11
 	shr $8, %rax
 	sub $1, %r13
-	jne _less_than_8_bytes_left_\@
-_multiple_of_16_bytes_\@:
+	jne .L_less_than_8_bytes_left_\@
+.L_multiple_of_16_bytes_\@:
 .endm
 
 # GCM_COMPLETE Finishes update of tag of last partial block
@@ -434,11 +434,11 @@ _multiple_of_16_bytes_\@:
 	mov PBlockLen(%arg2), %r12
 
 	test %r12, %r12
-	je _partial_done\@
+	je .L_partial_done\@
 
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 
-_partial_done\@:
+.L_partial_done\@:
 	mov AadLen(%arg2), %r12  # %r13 = aadLen (number of bytes)
 	shl	$3, %r12		  # convert into number of bits
 	movd	%r12d, %xmm15		  # len(A) in %xmm15
@@ -457,44 +457,44 @@ _partial_done\@:
 	movdqu OrigIV(%arg2), %xmm0       # %xmm0 = Y0
 	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
 	pxor	%xmm8, %xmm0
-_return_T_\@:
+.L_return_T_\@:
 	mov	\AUTHTAG, %r10                     # %r10 = authTag
 	mov	\AUTHTAGLEN, %r11                    # %r11 = auth_tag_len
 	cmp	$16, %r11
-	je	_T_16_\@
+	je	.L_T_16_\@
 	cmp	$8, %r11
-	jl	_T_4_\@
-_T_8_\@:
+	jl	.L_T_4_\@
+.L_T_8_\@:
 	movq	%xmm0, %rax
 	mov	%rax, (%r10)
 	add	$8, %r10
 	sub	$8, %r11
 	psrldq	$8, %xmm0
 	test	%r11, %r11
-	je	_return_T_done_\@
-_T_4_\@:
+	je	.L_return_T_done_\@
+.L_T_4_\@:
 	movd	%xmm0, %eax
 	mov	%eax, (%r10)
 	add	$4, %r10
 	sub	$4, %r11
 	psrldq	$4, %xmm0
 	test	%r11, %r11
-	je	_return_T_done_\@
-_T_123_\@:
+	je	.L_return_T_done_\@
+.L_T_123_\@:
 	movd	%xmm0, %eax
 	cmp	$2, %r11
-	jl	_T_1_\@
+	jl	.L_T_1_\@
 	mov	%ax, (%r10)
 	cmp	$2, %r11
-	je	_return_T_done_\@
+	je	.L_return_T_done_\@
 	add	$2, %r10
 	sar	$16, %eax
-_T_1_\@:
+.L_T_1_\@:
 	mov	%al, (%r10)
-	jmp	_return_T_done_\@
-_T_16_\@:
+	jmp	.L_return_T_done_\@
+.L_T_16_\@:
 	movdqu	%xmm0, (%r10)
-_return_T_done_\@:
+.L_return_T_done_\@:
 .endm
 
 #ifdef __x86_64__
@@ -563,30 +563,30 @@ _return_T_done_\@:
 # Clobbers %rax, DLEN and XMM1
 .macro READ_PARTIAL_BLOCK DPTR DLEN XMM1 XMMDst
         cmp $8, \DLEN
-        jl _read_lt8_\@
+        jl .L_read_lt8_\@
         mov (\DPTR), %rax
         movq %rax, \XMMDst
         sub $8, \DLEN
-        jz _done_read_partial_block_\@
+        jz .L_done_read_partial_block_\@
 	xor %eax, %eax
-_read_next_byte_\@:
+.L_read_next_byte_\@:
         shl $8, %rax
         mov 7(\DPTR, \DLEN, 1), %al
         dec \DLEN
-        jnz _read_next_byte_\@
+        jnz .L_read_next_byte_\@
         movq %rax, \XMM1
 	pslldq $8, \XMM1
         por \XMM1, \XMMDst
-	jmp _done_read_partial_block_\@
-_read_lt8_\@:
+	jmp .L_done_read_partial_block_\@
+.L_read_lt8_\@:
 	xor %eax, %eax
-_read_next_byte_lt8_\@:
+.L_read_next_byte_lt8_\@:
         shl $8, %rax
         mov -1(\DPTR, \DLEN, 1), %al
         dec \DLEN
-        jnz _read_next_byte_lt8_\@
+        jnz .L_read_next_byte_lt8_\@
         movq %rax, \XMMDst
-_done_read_partial_block_\@:
+.L_done_read_partial_block_\@:
 .endm
 
 # CALC_AAD_HASH: Calculates the hash of the data which will not be encrypted.
@@ -600,8 +600,8 @@ _done_read_partial_block_\@:
 	pxor	   \TMP6, \TMP6
 
 	cmp	   $16, %r11
-	jl	   _get_AAD_rest\@
-_get_AAD_blocks\@:
+	jl	   .L_get_AAD_rest\@
+.L_get_AAD_blocks\@:
 	movdqu	   (%r10), \TMP7
 	pshufb	   %xmm14, \TMP7 # byte-reflect the AAD data
 	pxor	   \TMP7, \TMP6
@@ -609,14 +609,14 @@ _get_AAD_blocks\@:
 	add	   $16, %r10
 	sub	   $16, %r11
 	cmp	   $16, %r11
-	jge	   _get_AAD_blocks\@
+	jge	   .L_get_AAD_blocks\@
 
 	movdqu	   \TMP6, \TMP7
 
 	/* read the last <16B of AAD */
-_get_AAD_rest\@:
+.L_get_AAD_rest\@:
 	test	   %r11, %r11
-	je	   _get_AAD_done\@
+	je	   .L_get_AAD_done\@
 
 	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, \TMP7
 	pshufb	   %xmm14, \TMP7 # byte-reflect the AAD data
@@ -624,7 +624,7 @@ _get_AAD_rest\@:
 	GHASH_MUL  \TMP7, \HASHKEY, \TMP1, \TMP2, \TMP3, \TMP4, \TMP5
 	movdqu \TMP7, \TMP6
 
-_get_AAD_done\@:
+.L_get_AAD_done\@:
 	movdqu \TMP6, AadHash(%arg2)
 .endm
 
@@ -637,21 +637,21 @@ _get_AAD_done\@:
 	AAD_HASH operation
 	mov 	PBlockLen(%arg2), %r13
 	test	%r13, %r13
-	je	_partial_block_done_\@	# Leave Macro if no partial blocks
+	je	.L_partial_block_done_\@	# Leave Macro if no partial blocks
 	# Read in input data without over reading
 	cmp	$16, \PLAIN_CYPH_LEN
-	jl	_fewer_than_16_bytes_\@
+	jl	.L_fewer_than_16_bytes_\@
 	movups	(\PLAIN_CYPH_IN), %xmm1	# If more than 16 bytes, just fill xmm
-	jmp	_data_read_\@
+	jmp	.L_data_read_\@
 
-_fewer_than_16_bytes_\@:
+.L_fewer_than_16_bytes_\@:
 	lea	(\PLAIN_CYPH_IN, \DATA_OFFSET, 1), %r10
 	mov	\PLAIN_CYPH_LEN, %r12
 	READ_PARTIAL_BLOCK %r10 %r12 %xmm0 %xmm1
 
 	mov PBlockLen(%arg2), %r13
 
-_data_read_\@:				# Finished reading in data
+.L_data_read_\@:				# Finished reading in data
 
 	movdqu	PBlockEncKey(%arg2), %xmm9
 	movdqu	HashKey(%arg2), %xmm13
@@ -674,9 +674,9 @@ _data_read_\@:				# Finished reading in data
 	sub	$16, %r10
 	# Determine if if partial block is not being filled and
 	# shift mask accordingly
-	jge	_no_extra_mask_1_\@
+	jge	.L_no_extra_mask_1_\@
 	sub	%r10, %r12
-_no_extra_mask_1_\@:
+.L_no_extra_mask_1_\@:
 
 	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
 	# get the appropriate mask to mask out bottom r13 bytes of xmm9
@@ -689,17 +689,17 @@ _no_extra_mask_1_\@:
 	pxor	%xmm3, \AAD_HASH
 
 	test	%r10, %r10
-	jl	_partial_incomplete_1_\@
+	jl	.L_partial_incomplete_1_\@
 
 	# GHASH computation for the last <16 Byte block
 	GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
 	xor	%eax, %eax
 
 	mov	%rax, PBlockLen(%arg2)
-	jmp	_dec_done_\@
-_partial_incomplete_1_\@:
+	jmp	.L_dec_done_\@
+.L_partial_incomplete_1_\@:
 	add	\PLAIN_CYPH_LEN, PBlockLen(%arg2)
-_dec_done_\@:
+.L_dec_done_\@:
 	movdqu	\AAD_HASH, AadHash(%arg2)
 .else
 	pxor	%xmm1, %xmm9			# Plaintext XOR E(K, Yn)
@@ -710,9 +710,9 @@ _dec_done_\@:
 	sub	$16, %r10
 	# Determine if if partial block is not being filled and
 	# shift mask accordingly
-	jge	_no_extra_mask_2_\@
+	jge	.L_no_extra_mask_2_\@
 	sub	%r10, %r12
-_no_extra_mask_2_\@:
+.L_no_extra_mask_2_\@:
 
 	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
 	# get the appropriate mask to mask out bottom r13 bytes of xmm9
@@ -724,17 +724,17 @@ _no_extra_mask_2_\@:
 	pxor	%xmm9, \AAD_HASH
 
 	test	%r10, %r10
-	jl	_partial_incomplete_2_\@
+	jl	.L_partial_incomplete_2_\@
 
 	# GHASH computation for the last <16 Byte block
 	GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
 	xor	%eax, %eax
 
 	mov	%rax, PBlockLen(%arg2)
-	jmp	_encode_done_\@
-_partial_incomplete_2_\@:
+	jmp	.L_encode_done_\@
+.L_partial_incomplete_2_\@:
 	add	\PLAIN_CYPH_LEN, PBlockLen(%arg2)
-_encode_done_\@:
+.L_encode_done_\@:
 	movdqu	\AAD_HASH, AadHash(%arg2)
 
 	movdqa	SHUF_MASK(%rip), %xmm10
@@ -744,32 +744,32 @@ _encode_done_\@:
 .endif
 	# output encrypted Bytes
 	test	%r10, %r10
-	jl	_partial_fill_\@
+	jl	.L_partial_fill_\@
 	mov	%r13, %r12
 	mov	$16, %r13
 	# Set r13 to be the number of bytes to write out
 	sub	%r12, %r13
-	jmp	_count_set_\@
-_partial_fill_\@:
+	jmp	.L_count_set_\@
+.L_partial_fill_\@:
 	mov	\PLAIN_CYPH_LEN, %r13
-_count_set_\@:
+.L_count_set_\@:
 	movdqa	%xmm9, %xmm0
 	movq	%xmm0, %rax
 	cmp	$8, %r13
-	jle	_less_than_8_bytes_left_\@
+	jle	.L_less_than_8_bytes_left_\@
 
 	mov	%rax, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
 	add	$8, \DATA_OFFSET
 	psrldq	$8, %xmm0
 	movq	%xmm0, %rax
 	sub	$8, %r13
-_less_than_8_bytes_left_\@:
+.L_less_than_8_bytes_left_\@:
 	movb	%al, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
 	add	$1, \DATA_OFFSET
 	shr	$8, %rax
 	sub	$1, %r13
-	jne	_less_than_8_bytes_left_\@
-_partial_block_done_\@:
+	jne	.L_less_than_8_bytes_left_\@
+.L_partial_block_done_\@:
 .endm # PARTIAL_BLOCK
 
 /*
@@ -813,14 +813,14 @@ _partial_block_done_\@:
 	shr	$2,%eax				# 128->4, 192->6, 256->8
 	add	$5,%eax			      # 128->9, 192->11, 256->13
 
-aes_loop_initial_\@:
+.Laes_loop_initial_\@:
 	MOVADQ	(%r10),\TMP1
 .irpc	index, \i_seq
 	aesenc	\TMP1, %xmm\index
 .endr
 	add	$16,%r10
 	sub	$1,%eax
-	jnz	aes_loop_initial_\@
+	jnz	.Laes_loop_initial_\@
 
 	MOVADQ	(%r10), \TMP1
 .irpc index, \i_seq
@@ -861,7 +861,7 @@ aes_loop_initial_\@:
 	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
 .endif
 	cmp	   $64, %r13
-	jl	_initial_blocks_done\@
+	jl	.L_initial_blocks_done\@
 	# no need for precomputed values
 /*
 *
@@ -908,18 +908,18 @@ aes_loop_initial_\@:
 	mov	   keysize,%eax
 	shr	   $2,%eax			# 128->4, 192->6, 256->8
 	sub	   $4,%eax			# 128->0, 192->2, 256->4
-	jz	   aes_loop_pre_done\@
+	jz	   .Laes_loop_pre_done\@
 
-aes_loop_pre_\@:
+.Laes_loop_pre_\@:
 	MOVADQ	   (%r10),\TMP2
 .irpc	index, 1234
 	aesenc	   \TMP2, %xmm\index
 .endr
 	add	   $16,%r10
 	sub	   $1,%eax
-	jnz	   aes_loop_pre_\@
+	jnz	   .Laes_loop_pre_\@
 
-aes_loop_pre_done\@:
+.Laes_loop_pre_done\@:
 	MOVADQ	   (%r10), \TMP2
 	aesenclast \TMP2, \XMM1
 	aesenclast \TMP2, \XMM2
@@ -963,7 +963,7 @@ aes_loop_pre_done\@:
 	pshufb %xmm14, \XMM3 # perform a 16 byte swap
 	pshufb %xmm14, \XMM4 # perform a 16 byte swap
 
-_initial_blocks_done\@:
+.L_initial_blocks_done\@:
 
 .endm
 
@@ -1095,18 +1095,18 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	mov	  keysize,%eax
 	shr	  $2,%eax			# 128->4, 192->6, 256->8
 	sub	  $4,%eax			# 128->0, 192->2, 256->4
-	jz	  aes_loop_par_enc_done\@
+	jz	  .Laes_loop_par_enc_done\@
 
-aes_loop_par_enc\@:
+.Laes_loop_par_enc\@:
 	MOVADQ	  (%r10),\TMP3
 .irpc	index, 1234
 	aesenc	  \TMP3, %xmm\index
 .endr
 	add	  $16,%r10
 	sub	  $1,%eax
-	jnz	  aes_loop_par_enc\@
+	jnz	  .Laes_loop_par_enc\@
 
-aes_loop_par_enc_done\@:
+.Laes_loop_par_enc_done\@:
 	MOVADQ	  (%r10), \TMP3
 	aesenclast \TMP3, \XMM1           # Round 10
 	aesenclast \TMP3, \XMM2
@@ -1303,18 +1303,18 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	mov	  keysize,%eax
 	shr	  $2,%eax		        # 128->4, 192->6, 256->8
 	sub	  $4,%eax			# 128->0, 192->2, 256->4
-	jz	  aes_loop_par_dec_done\@
+	jz	  .Laes_loop_par_dec_done\@
 
-aes_loop_par_dec\@:
+.Laes_loop_par_dec\@:
 	MOVADQ	  (%r10),\TMP3
 .irpc	index, 1234
 	aesenc	  \TMP3, %xmm\index
 .endr
 	add	  $16,%r10
 	sub	  $1,%eax
-	jnz	  aes_loop_par_dec\@
+	jnz	  .Laes_loop_par_dec\@
 
-aes_loop_par_dec_done\@:
+.Laes_loop_par_dec_done\@:
 	MOVADQ	  (%r10), \TMP3
 	aesenclast \TMP3, \XMM1           # last round
 	aesenclast \TMP3, \XMM2
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index b6ca80f188ff9418..46cddd78857bd9eb 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -278,68 +278,68 @@ VARIABLE_OFFSET = 16*8
         mov     %r13, %r12
         shr     $4, %r12
         and     $7, %r12
-        jz      _initial_num_blocks_is_0\@
+        jz      .L_initial_num_blocks_is_0\@
 
         cmp     $7, %r12
-        je      _initial_num_blocks_is_7\@
+        je      .L_initial_num_blocks_is_7\@
         cmp     $6, %r12
-        je      _initial_num_blocks_is_6\@
+        je      .L_initial_num_blocks_is_6\@
         cmp     $5, %r12
-        je      _initial_num_blocks_is_5\@
+        je      .L_initial_num_blocks_is_5\@
         cmp     $4, %r12
-        je      _initial_num_blocks_is_4\@
+        je      .L_initial_num_blocks_is_4\@
         cmp     $3, %r12
-        je      _initial_num_blocks_is_3\@
+        je      .L_initial_num_blocks_is_3\@
         cmp     $2, %r12
-        je      _initial_num_blocks_is_2\@
+        je      .L_initial_num_blocks_is_2\@
 
-        jmp     _initial_num_blocks_is_1\@
+        jmp     .L_initial_num_blocks_is_1\@
 
-_initial_num_blocks_is_7\@:
+.L_initial_num_blocks_is_7\@:
         \INITIAL_BLOCKS  \REP, 7, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*7, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_6\@:
+.L_initial_num_blocks_is_6\@:
         \INITIAL_BLOCKS  \REP, 6, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*6, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_5\@:
+.L_initial_num_blocks_is_5\@:
         \INITIAL_BLOCKS  \REP, 5, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*5, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_4\@:
+.L_initial_num_blocks_is_4\@:
         \INITIAL_BLOCKS  \REP, 4, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*4, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_3\@:
+.L_initial_num_blocks_is_3\@:
         \INITIAL_BLOCKS  \REP, 3, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*3, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_2\@:
+.L_initial_num_blocks_is_2\@:
         \INITIAL_BLOCKS  \REP, 2, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*2, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_1\@:
+.L_initial_num_blocks_is_1\@:
         \INITIAL_BLOCKS  \REP, 1, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
         sub     $16*1, %r13
-        jmp     _initial_blocks_encrypted\@
+        jmp     .L_initial_blocks_encrypted\@
 
-_initial_num_blocks_is_0\@:
+.L_initial_num_blocks_is_0\@:
         \INITIAL_BLOCKS  \REP, 0, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \ENC_DEC
 
 
-_initial_blocks_encrypted\@:
+.L_initial_blocks_encrypted\@:
         test    %r13, %r13
-        je      _zero_cipher_left\@
+        je      .L_zero_cipher_left\@
 
         sub     $128, %r13
-        je      _eight_cipher_left\@
+        je      .L_eight_cipher_left\@
 
 
 
@@ -349,9 +349,9 @@ _initial_blocks_encrypted\@:
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
 
 
-_encrypt_by_8_new\@:
+.L_encrypt_by_8_new\@:
         cmp     $(255-8), %r15d
-        jg      _encrypt_by_8\@
+        jg      .L_encrypt_by_8\@
 
 
 
@@ -359,30 +359,30 @@ _encrypt_by_8_new\@:
         \GHASH_8_ENCRYPT_8_PARALLEL      \REP, %xmm0, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm15, out_order, \ENC_DEC
         add     $128, %r11
         sub     $128, %r13
-        jne     _encrypt_by_8_new\@
+        jne     .L_encrypt_by_8_new\@
 
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        jmp     _eight_cipher_left\@
+        jmp     .L_eight_cipher_left\@
 
-_encrypt_by_8\@:
+.L_encrypt_by_8\@:
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
         add     $8, %r15b
         \GHASH_8_ENCRYPT_8_PARALLEL      \REP, %xmm0, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm15, in_order, \ENC_DEC
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
         add     $128, %r11
         sub     $128, %r13
-        jne     _encrypt_by_8_new\@
+        jne     .L_encrypt_by_8_new\@
 
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
 
 
 
 
-_eight_cipher_left\@:
+.L_eight_cipher_left\@:
         \GHASH_LAST_8    %xmm0, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8
 
 
-_zero_cipher_left\@:
+.L_zero_cipher_left\@:
         vmovdqu %xmm14, AadHash(arg2)
         vmovdqu %xmm9, CurCount(arg2)
 
@@ -390,7 +390,7 @@ _zero_cipher_left\@:
         mov     arg5, %r13
         and     $15, %r13                            # r13 = (arg5 mod 16)
 
-        je      _multiple_of_16_bytes\@
+        je      .L_multiple_of_16_bytes\@
 
         # handle the last <16 Byte block separately
 
@@ -404,7 +404,7 @@ _zero_cipher_left\@:
         vmovdqu %xmm9, PBlockEncKey(arg2)
 
         cmp $16, arg5
-        jge _large_enough_update\@
+        jge .L_large_enough_update\@
 
         lea (arg4,%r11,1), %r10
         mov %r13, %r12
@@ -416,9 +416,9 @@ _zero_cipher_left\@:
 						     # able to shift 16-r13 bytes (r13 is the
 	# number of bytes in plaintext mod 16)
 
-        jmp _final_ghash_mul\@
+        jmp .L_final_ghash_mul\@
 
-_large_enough_update\@:
+.L_large_enough_update\@:
         sub $16, %r11
         add %r13, %r11
 
@@ -437,7 +437,7 @@ _large_enough_update\@:
         # shift right 16-r13 bytes
         vpshufb  %xmm2, %xmm1, %xmm1
 
-_final_ghash_mul\@:
+.L_final_ghash_mul\@:
         .if  \ENC_DEC ==  DEC
         vmovdqa %xmm1, %xmm2
         vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, Yn)
@@ -466,7 +466,7 @@ _final_ghash_mul\@:
         # output r13 Bytes
         vmovq   %xmm9, %rax
         cmp     $8, %r13
-        jle     _less_than_8_bytes_left\@
+        jle     .L_less_than_8_bytes_left\@
 
         mov     %rax, (arg3 , %r11)
         add     $8, %r11
@@ -474,15 +474,15 @@ _final_ghash_mul\@:
         vmovq   %xmm9, %rax
         sub     $8, %r13
 
-_less_than_8_bytes_left\@:
+.L_less_than_8_bytes_left\@:
         movb    %al, (arg3 , %r11)
         add     $1, %r11
         shr     $8, %rax
         sub     $1, %r13
-        jne     _less_than_8_bytes_left\@
+        jne     .L_less_than_8_bytes_left\@
         #############################
 
-_multiple_of_16_bytes\@:
+.L_multiple_of_16_bytes\@:
 .endm
 
 
@@ -495,12 +495,12 @@ _multiple_of_16_bytes\@:
 
         mov PBlockLen(arg2), %r12
         test %r12, %r12
-        je _partial_done\@
+        je .L_partial_done\@
 
 	#GHASH computation for the last <16 Byte block
         \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
 
-_partial_done\@:
+.L_partial_done\@:
         mov AadLen(arg2), %r12                          # r12 = aadLen (number of bytes)
         shl     $3, %r12                             # convert into number of bits
         vmovd   %r12d, %xmm15                        # len(A) in xmm15
@@ -523,49 +523,49 @@ _partial_done\@:
 
 
 
-_return_T\@:
+.L_return_T\@:
         mov     \AUTH_TAG, %r10              # r10 = authTag
         mov     \AUTH_TAG_LEN, %r11              # r11 = auth_tag_len
 
         cmp     $16, %r11
-        je      _T_16\@
+        je      .L_T_16\@
 
         cmp     $8, %r11
-        jl      _T_4\@
+        jl      .L_T_4\@
 
-_T_8\@:
+.L_T_8\@:
         vmovq   %xmm9, %rax
         mov     %rax, (%r10)
         add     $8, %r10
         sub     $8, %r11
         vpsrldq $8, %xmm9, %xmm9
         test    %r11, %r11
-        je     _return_T_done\@
-_T_4\@:
+        je     .L_return_T_done\@
+.L_T_4\@:
         vmovd   %xmm9, %eax
         mov     %eax, (%r10)
         add     $4, %r10
         sub     $4, %r11
         vpsrldq     $4, %xmm9, %xmm9
         test    %r11, %r11
-        je     _return_T_done\@
-_T_123\@:
+        je     .L_return_T_done\@
+.L_T_123\@:
         vmovd     %xmm9, %eax
         cmp     $2, %r11
-        jl     _T_1\@
+        jl     .L_T_1\@
         mov     %ax, (%r10)
         cmp     $2, %r11
-        je     _return_T_done\@
+        je     .L_return_T_done\@
         add     $2, %r10
         sar     $16, %eax
-_T_1\@:
+.L_T_1\@:
         mov     %al, (%r10)
-        jmp     _return_T_done\@
+        jmp     .L_return_T_done\@
 
-_T_16\@:
+.L_T_16\@:
         vmovdqu %xmm9, (%r10)
 
-_return_T_done\@:
+.L_return_T_done\@:
 .endm
 
 .macro CALC_AAD_HASH GHASH_MUL AAD AADLEN T1 T2 T3 T4 T5 T6 T7 T8
@@ -579,8 +579,8 @@ _return_T_done\@:
 	vpxor   \T8, \T8, \T8
 	vpxor   \T7, \T7, \T7
 	cmp     $16, %r11
-	jl      _get_AAD_rest8\@
-_get_AAD_blocks\@:
+	jl      .L_get_AAD_rest8\@
+.L_get_AAD_blocks\@:
 	vmovdqu (%r10), \T7
 	vpshufb SHUF_MASK(%rip), \T7, \T7
 	vpxor   \T7, \T8, \T8
@@ -589,29 +589,29 @@ _get_AAD_blocks\@:
 	sub     $16, %r12
 	sub     $16, %r11
 	cmp     $16, %r11
-	jge     _get_AAD_blocks\@
+	jge     .L_get_AAD_blocks\@
 	vmovdqu \T8, \T7
 	test    %r11, %r11
-	je      _get_AAD_done\@
+	je      .L_get_AAD_done\@
 
 	vpxor   \T7, \T7, \T7
 
 	/* read the last <16B of AAD. since we have at least 4B of
 	data right after the AAD (the ICV, and maybe some CT), we can
 	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\@:
+.L_get_AAD_rest8\@:
 	cmp     $4, %r11
-	jle     _get_AAD_rest4\@
+	jle     .L_get_AAD_rest4\@
 	movq    (%r10), \T1
 	add     $8, %r10
 	sub     $8, %r11
 	vpslldq $8, \T1, \T1
 	vpsrldq $8, \T7, \T7
 	vpxor   \T1, \T7, \T7
-	jmp     _get_AAD_rest8\@
-_get_AAD_rest4\@:
+	jmp     .L_get_AAD_rest8\@
+.L_get_AAD_rest4\@:
 	test    %r11, %r11
-	jle      _get_AAD_rest0\@
+	jle     .L_get_AAD_rest0\@
 	mov     (%r10), %eax
 	movq    %rax, \T1
 	add     $4, %r10
@@ -619,7 +619,7 @@ _get_AAD_rest4\@:
 	vpslldq $12, \T1, \T1
 	vpsrldq $4, \T7, \T7
 	vpxor   \T1, \T7, \T7
-_get_AAD_rest0\@:
+.L_get_AAD_rest0\@:
 	/* finalize: shift out the extra bytes we read, and align
 	left. since pslldq can only shift by an immediate, we use
 	vpshufb and a pair of shuffle masks */
@@ -629,12 +629,12 @@ _get_AAD_rest0\@:
 	andq	$~3, %r11
 	vpshufb (%r11), \T7, \T7
 	vpand	\T1, \T7, \T7
-_get_AAD_rest_final\@:
+.L_get_AAD_rest_final\@:
 	vpshufb SHUF_MASK(%rip), \T7, \T7
 	vpxor   \T8, \T7, \T7
 	\GHASH_MUL       \T7, \T2, \T1, \T3, \T4, \T5, \T6
 
-_get_AAD_done\@:
+.L_get_AAD_done\@:
         vmovdqu \T7, AadHash(arg2)
 .endm
 
@@ -685,28 +685,28 @@ _get_AAD_done\@:
         vpxor \XMMDst, \XMMDst, \XMMDst
 
         cmp $8, \DLEN
-        jl _read_lt8_\@
+        jl .L_read_lt8_\@
         mov (\DPTR), %rax
         vpinsrq $0, %rax, \XMMDst, \XMMDst
         sub $8, \DLEN
-        jz _done_read_partial_block_\@
+        jz .L_done_read_partial_block_\@
         xor %eax, %eax
-_read_next_byte_\@:
+.L_read_next_byte_\@:
         shl $8, %rax
         mov 7(\DPTR, \DLEN, 1), %al
         dec \DLEN
-        jnz _read_next_byte_\@
+        jnz .L_read_next_byte_\@
         vpinsrq $1, %rax, \XMMDst, \XMMDst
-        jmp _done_read_partial_block_\@
-_read_lt8_\@:
+        jmp .L_done_read_partial_block_\@
+.L_read_lt8_\@:
         xor %eax, %eax
-_read_next_byte_lt8_\@:
+.L_read_next_byte_lt8_\@:
         shl $8, %rax
         mov -1(\DPTR, \DLEN, 1), %al
         dec \DLEN
-        jnz _read_next_byte_lt8_\@
+        jnz .L_read_next_byte_lt8_\@
         vpinsrq $0, %rax, \XMMDst, \XMMDst
-_done_read_partial_block_\@:
+.L_done_read_partial_block_\@:
 .endm
 
 # PARTIAL_BLOCK: Handles encryption/decryption and the tag partial blocks
@@ -718,21 +718,21 @@ _done_read_partial_block_\@:
         AAD_HASH ENC_DEC
         mov 	PBlockLen(arg2), %r13
         test	%r13, %r13
-        je	_partial_block_done_\@	# Leave Macro if no partial blocks
+        je	.L_partial_block_done_\@	# Leave Macro if no partial blocks
         # Read in input data without over reading
         cmp	$16, \PLAIN_CYPH_LEN
-        jl	_fewer_than_16_bytes_\@
+        jl	.L_fewer_than_16_bytes_\@
         vmovdqu	(\PLAIN_CYPH_IN), %xmm1	# If more than 16 bytes, just fill xmm
-        jmp	_data_read_\@
+        jmp	.L_data_read_\@
 
-_fewer_than_16_bytes_\@:
+.L_fewer_than_16_bytes_\@:
         lea	(\PLAIN_CYPH_IN, \DATA_OFFSET, 1), %r10
         mov	\PLAIN_CYPH_LEN, %r12
         READ_PARTIAL_BLOCK %r10 %r12 %xmm1
 
         mov PBlockLen(arg2), %r13
 
-_data_read_\@:				# Finished reading in data
+.L_data_read_\@:				# Finished reading in data
 
         vmovdqu	PBlockEncKey(arg2), %xmm9
         vmovdqu	HashKey(arg2), %xmm13
@@ -755,9 +755,9 @@ _data_read_\@:				# Finished reading in data
         sub	$16, %r10
         # Determine if if partial block is not being filled and
         # shift mask accordingly
-        jge	_no_extra_mask_1_\@
+        jge	.L_no_extra_mask_1_\@
         sub	%r10, %r12
-_no_extra_mask_1_\@:
+.L_no_extra_mask_1_\@:
 
         vmovdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
         # get the appropriate mask to mask out bottom r13 bytes of xmm9
@@ -770,17 +770,17 @@ _no_extra_mask_1_\@:
         vpxor	%xmm3, \AAD_HASH, \AAD_HASH
 
         test	%r10, %r10
-        jl	_partial_incomplete_1_\@
+        jl	.L_partial_incomplete_1_\@
 
         # GHASH computation for the last <16 Byte block
         \GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
         xor	%eax,%eax
 
         mov	%rax, PBlockLen(arg2)
-        jmp	_dec_done_\@
-_partial_incomplete_1_\@:
+        jmp	.L_dec_done_\@
+.L_partial_incomplete_1_\@:
         add	\PLAIN_CYPH_LEN, PBlockLen(arg2)
-_dec_done_\@:
+.L_dec_done_\@:
         vmovdqu	\AAD_HASH, AadHash(arg2)
 .else
         vpxor	%xmm1, %xmm9, %xmm9			# Plaintext XOR E(K, Yn)
@@ -791,9 +791,9 @@ _dec_done_\@:
         sub	$16, %r10
         # Determine if if partial block is not being filled and
         # shift mask accordingly
-        jge	_no_extra_mask_2_\@
+        jge	.L_no_extra_mask_2_\@
         sub	%r10, %r12
-_no_extra_mask_2_\@:
+.L_no_extra_mask_2_\@:
 
         vmovdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
         # get the appropriate mask to mask out bottom r13 bytes of xmm9
@@ -805,17 +805,17 @@ _no_extra_mask_2_\@:
         vpxor	%xmm9, \AAD_HASH, \AAD_HASH
 
         test	%r10, %r10
-        jl	_partial_incomplete_2_\@
+        jl	.L_partial_incomplete_2_\@
 
         # GHASH computation for the last <16 Byte block
         \GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
         xor	%eax,%eax
 
         mov	%rax, PBlockLen(arg2)
-        jmp	_encode_done_\@
-_partial_incomplete_2_\@:
+        jmp	.L_encode_done_\@
+.L_partial_incomplete_2_\@:
         add	\PLAIN_CYPH_LEN, PBlockLen(arg2)
-_encode_done_\@:
+.L_encode_done_\@:
         vmovdqu	\AAD_HASH, AadHash(arg2)
 
         vmovdqa	SHUF_MASK(%rip), %xmm10
@@ -825,32 +825,32 @@ _encode_done_\@:
 .endif
         # output encrypted Bytes
         test	%r10, %r10
-        jl	_partial_fill_\@
+        jl	.L_partial_fill_\@
         mov	%r13, %r12
         mov	$16, %r13
         # Set r13 to be the number of bytes to write out
         sub	%r12, %r13
-        jmp	_count_set_\@
-_partial_fill_\@:
+        jmp	.L_count_set_\@
+.L_partial_fill_\@:
         mov	\PLAIN_CYPH_LEN, %r13
-_count_set_\@:
+.L_count_set_\@:
         vmovdqa	%xmm9, %xmm0
         vmovq	%xmm0, %rax
         cmp	$8, %r13
-        jle	_less_than_8_bytes_left_\@
+        jle	.L_less_than_8_bytes_left_\@
 
         mov	%rax, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
         add	$8, \DATA_OFFSET
         psrldq	$8, %xmm0
         vmovq	%xmm0, %rax
         sub	$8, %r13
-_less_than_8_bytes_left_\@:
+.L_less_than_8_bytes_left_\@:
         movb	%al, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
         add	$1, \DATA_OFFSET
         shr	$8, %rax
         sub	$1, %r13
-        jne	_less_than_8_bytes_left_\@
-_partial_block_done_\@:
+        jne	.L_less_than_8_bytes_left_\@
+.L_partial_block_done_\@:
 .endm # PARTIAL_BLOCK
 
 ###############################################################################
@@ -1051,7 +1051,7 @@ _partial_block_done_\@:
         vmovdqa  \XMM8, \T3
 
         cmp     $128, %r13
-        jl      _initial_blocks_done\@                  # no need for precomputed constants
+        jl      .L_initial_blocks_done\@                  # no need for precomputed constants
 
 ###############################################################################
 # Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
@@ -1193,7 +1193,7 @@ _partial_block_done_\@:
 
 ###############################################################################
 
-_initial_blocks_done\@:
+.L_initial_blocks_done\@:
 
 .endm
 
@@ -2001,7 +2001,7 @@ SYM_FUNC_END(aesni_gcm_finalize_avx_gen2)
         vmovdqa  \XMM8, \T3
 
         cmp     $128, %r13
-        jl      _initial_blocks_done\@                  # no need for precomputed constants
+        jl      .L_initial_blocks_done\@                  # no need for precomputed constants
 
 ###############################################################################
 # Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
@@ -2145,7 +2145,7 @@ SYM_FUNC_END(aesni_gcm_finalize_avx_gen2)
 
 ###############################################################################
 
-_initial_blocks_done\@:
+.L_initial_blocks_done\@:
 
 
 .endm
-- 
2.39.2

