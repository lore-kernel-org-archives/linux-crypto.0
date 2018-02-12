From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 05/14] x86/crypto: aesni: Merge encode and decode to
 GCM_ENC_DEC macro
Date: Mon, 12 Feb 2018 11:49:02 -0800
Message-ID: <20180212194902.GA60735@davejwatson-mba.local>
References: <cover.1518211765.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47774 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752277AbeBLTvy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 14:51:54 -0500
Content-Disposition: inline
In-Reply-To: <cover.1518211765.git.davejwatson@fb.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make a macro for the main encode/decode routine.  Only a small handful
of lines differ for enc and dec.   This will also become the main
scatter/gather update routine.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 293 +++++++++++++++-----------------------
 1 file changed, 114 insertions(+), 179 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 529c542..8021fd1 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -222,6 +222,118 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	mov	%r13, %r12
 .endm
 
+# GCM_ENC_DEC Encodes/Decodes given data. Assumes that the passed gcm_context
+# struct has been initialized by GCM_INIT.
+# Requires the input data be at least 1 byte long because of READ_PARTIAL_BLOCK
+# Clobbers rax, r10-r13, and xmm0-xmm15
+.macro GCM_ENC_DEC operation
+	# Encrypt/Decrypt first few blocks
+
+	and	$(3<<4), %r12
+	jz	_initial_num_blocks_is_0_\@
+	cmp	$(2<<4), %r12
+	jb	_initial_num_blocks_is_1_\@
+	je	_initial_num_blocks_is_2_\@
+_initial_num_blocks_is_3_\@:
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, \operation
+	sub	$48, %r13
+	jmp	_initial_blocks_\@
+_initial_num_blocks_is_2_\@:
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, \operation
+	sub	$32, %r13
+	jmp	_initial_blocks_\@
+_initial_num_blocks_is_1_\@:
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, \operation
+	sub	$16, %r13
+	jmp	_initial_blocks_\@
+_initial_num_blocks_is_0_\@:
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, \operation
+_initial_blocks_\@:
+
+	# Main loop - Encrypt/Decrypt remaining blocks
+
+	cmp	$0, %r13
+	je	_zero_cipher_left_\@
+	sub	$64, %r13
+	je	_four_cipher_left_\@
+_crypt_by_4_\@:
+	GHASH_4_ENCRYPT_4_PARALLEL_\operation	%xmm9, %xmm10, %xmm11, %xmm12, \
+	%xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, \
+	%xmm7, %xmm8, enc
+	add	$64, %r11
+	sub	$64, %r13
+	jne	_crypt_by_4_\@
+_four_cipher_left_\@:
+	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, \
+%xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
+_zero_cipher_left_\@:
+	mov	%arg4, %r13
+	and	$15, %r13			# %r13 = arg4 (mod 16)
+	je	_multiple_of_16_bytes_\@
+
+	# Handle the last <16 Byte block separately
+	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm0
+
+	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
+
+	lea (%arg3,%r11,1), %r10
+	mov %r13, %r12
+	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
+
+	lea ALL_F+16(%rip), %r12
+	sub %r13, %r12
+.ifc \operation, dec
+	movdqa  %xmm1, %xmm2
+.endif
+	pxor	%xmm1, %xmm0            # XOR Encrypt(K, Yn)
+	movdqu	(%r12), %xmm1
+	# get the appropriate mask to mask out top 16-r13 bytes of xmm0
+	pand	%xmm1, %xmm0            # mask out top 16-r13 bytes of xmm0
+.ifc \operation, dec
+	pand    %xmm1, %xmm2
+	movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10 ,%xmm2
+
+	pxor %xmm2, %xmm8
+.else
+	movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10,%xmm0
+
+	pxor	%xmm0, %xmm8
+.endif
+
+	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
+.ifc \operation, enc
+	# GHASH computation for the last <16 byte block
+	movdqa SHUF_MASK(%rip), %xmm10
+	# shuffle xmm0 back to output as ciphertext
+	PSHUFB_XMM %xmm10, %xmm0
+.endif
+
+	# Output %r13 bytes
+	MOVQ_R64_XMM %xmm0, %rax
+	cmp $8, %r13
+	jle _less_than_8_bytes_left_\@
+	mov %rax, (%arg2 , %r11, 1)
+	add $8, %r11
+	psrldq $8, %xmm0
+	MOVQ_R64_XMM %xmm0, %rax
+	sub $8, %r13
+_less_than_8_bytes_left_\@:
+	mov %al,  (%arg2, %r11, 1)
+	add $1, %r11
+	shr $8, %rax
+	sub $1, %r13
+	jne _less_than_8_bytes_left_\@
+_multiple_of_16_bytes_\@:
+.endm
+
 # GCM_COMPLETE Finishes update of tag of last partial block
 # Output: Authorization Tag (AUTH_TAG)
 # Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
@@ -1245,93 +1357,7 @@ ENTRY(aesni_gcm_dec)
 	FUNC_SAVE
 
 	GCM_INIT
-
-        # Decrypt first few blocks
-
-	and $(3<<4), %r12
-	jz _initial_num_blocks_is_0_decrypt
-	cmp $(2<<4), %r12
-	jb _initial_num_blocks_is_1_decrypt
-	je _initial_num_blocks_is_2_decrypt
-_initial_num_blocks_is_3_decrypt:
-	INITIAL_BLOCKS_ENC_DEC %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, dec
-	sub	$48, %r13
-	jmp	_initial_blocks_decrypted
-_initial_num_blocks_is_2_decrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, dec
-	sub	$32, %r13
-	jmp	_initial_blocks_decrypted
-_initial_num_blocks_is_1_decrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, dec
-	sub	$16, %r13
-	jmp	_initial_blocks_decrypted
-_initial_num_blocks_is_0_decrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, dec
-_initial_blocks_decrypted:
-	cmp	$0, %r13
-	je	_zero_cipher_left_decrypt
-	sub	$64, %r13
-	je	_four_cipher_left_decrypt
-_decrypt_by_4:
-	GHASH_4_ENCRYPT_4_PARALLEL_DEC	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, \
-%xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, dec
-	add	$64, %r11
-	sub	$64, %r13
-	jne	_decrypt_by_4
-_four_cipher_left_decrypt:
-	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, \
-%xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
-_zero_cipher_left_decrypt:
-	mov	%arg4, %r13
-	and	$15, %r13				# %r13 = arg4 (mod 16)
-	je	_multiple_of_16_bytes_decrypt
-
-        # Handle the last <16 byte block separately
-
-	paddd ONE(%rip), %xmm0         # increment CNT to get Yn
-        movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm0
-
-	ENCRYPT_SINGLE_BLOCK  %xmm0, %xmm1    # E(K, Yn)
-
-	lea (%arg3,%r11,1), %r10
-	mov %r13, %r12
-	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
-
-	lea ALL_F+16(%rip), %r12
-	sub %r13, %r12
-	movdqa  %xmm1, %xmm2
-	pxor %xmm1, %xmm0            # Ciphertext XOR E(K, Yn)
-	movdqu (%r12), %xmm1
-	# get the appropriate mask to mask out top 16-%r13 bytes of %xmm0
-	pand %xmm1, %xmm0            # mask out top 16-%r13 bytes of %xmm0
-	pand    %xmm1, %xmm2
-        movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10 ,%xmm2
-
-	pxor %xmm2, %xmm8
-	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
-
-        # output %r13 bytes
-	MOVQ_R64_XMM	%xmm0, %rax
-	cmp	$8, %r13
-	jle	_less_than_8_bytes_left_decrypt
-	mov	%rax, (%arg2 , %r11, 1)
-	add	$8, %r11
-	psrldq	$8, %xmm0
-	MOVQ_R64_XMM	%xmm0, %rax
-	sub	$8, %r13
-_less_than_8_bytes_left_decrypt:
-	mov	%al,  (%arg2, %r11, 1)
-	add	$1, %r11
-	shr	$8, %rax
-	sub	$1, %r13
-	jne	_less_than_8_bytes_left_decrypt
-_multiple_of_16_bytes_decrypt:
+	GCM_ENC_DEC dec
 	GCM_COMPLETE
 	FUNC_RESTORE
 	ret
@@ -1417,98 +1443,7 @@ ENTRY(aesni_gcm_enc)
 	FUNC_SAVE
 
 	GCM_INIT
-        # Encrypt first few blocks
-
-	and	$(3<<4), %r12
-	jz	_initial_num_blocks_is_0_encrypt
-	cmp	$(2<<4), %r12
-	jb	_initial_num_blocks_is_1_encrypt
-	je	_initial_num_blocks_is_2_encrypt
-_initial_num_blocks_is_3_encrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, enc
-	sub	$48, %r13
-	jmp	_initial_blocks_encrypted
-_initial_num_blocks_is_2_encrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, enc
-	sub	$32, %r13
-	jmp	_initial_blocks_encrypted
-_initial_num_blocks_is_1_encrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, enc
-	sub	$16, %r13
-	jmp	_initial_blocks_encrypted
-_initial_num_blocks_is_0_encrypt:
-	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
-%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, enc
-_initial_blocks_encrypted:
-
-        # Main loop - Encrypt remaining blocks
-
-	cmp	$0, %r13
-	je	_zero_cipher_left_encrypt
-	sub	$64, %r13
-	je	_four_cipher_left_encrypt
-_encrypt_by_4_encrypt:
-	GHASH_4_ENCRYPT_4_PARALLEL_ENC	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, \
-%xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
-	add	$64, %r11
-	sub	$64, %r13
-	jne	_encrypt_by_4_encrypt
-_four_cipher_left_encrypt:
-	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, \
-%xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
-_zero_cipher_left_encrypt:
-	mov	%arg4, %r13
-	and	$15, %r13			# %r13 = arg4 (mod 16)
-	je	_multiple_of_16_bytes_encrypt
-
-         # Handle the last <16 Byte block separately
-	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
-        movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm0
-
-	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
-
-	lea (%arg3,%r11,1), %r10
-	mov %r13, %r12
-	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
-
-	lea ALL_F+16(%rip), %r12
-	sub %r13, %r12
-	pxor	%xmm1, %xmm0            # Plaintext XOR Encrypt(K, Yn)
-	movdqu	(%r12), %xmm1
-	# get the appropriate mask to mask out top 16-r13 bytes of xmm0
-	pand	%xmm1, %xmm0            # mask out top 16-r13 bytes of xmm0
-        movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10,%xmm0
-
-	pxor	%xmm0, %xmm8
-	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
-	# GHASH computation for the last <16 byte block
-	movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm0
-
-	# shuffle xmm0 back to output as ciphertext
-
-        # Output %r13 bytes
-	MOVQ_R64_XMM %xmm0, %rax
-	cmp $8, %r13
-	jle _less_than_8_bytes_left_encrypt
-	mov %rax, (%arg2 , %r11, 1)
-	add $8, %r11
-	psrldq $8, %xmm0
-	MOVQ_R64_XMM %xmm0, %rax
-	sub $8, %r13
-_less_than_8_bytes_left_encrypt:
-	mov %al,  (%arg2, %r11, 1)
-	add $1, %r11
-	shr $8, %rax
-	sub $1, %r13
-	jne _less_than_8_bytes_left_encrypt
-_multiple_of_16_bytes_encrypt:
-_return_T_encrypt:
+	GCM_ENC_DEC enc
 	GCM_COMPLETE
 	FUNC_RESTORE
 	ret
-- 
2.9.5
