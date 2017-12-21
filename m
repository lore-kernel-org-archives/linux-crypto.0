From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v3 1/2] crypto: Fix out-of-bounds access of the data buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 17:08:37 -0800
Message-ID: <20171221010838.54243-2-junaids@google.com>
References: <20171221010838.54243-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:39009 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757120AbdLUBIo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 20:08:44 -0500
Received: by mail-io0-f193.google.com with SMTP id g70so6724818ioj.6
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 17:08:44 -0800 (PST)
In-Reply-To: <20171221010838.54243-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The aesni_gcm_enc/dec functions can access memory before the start of
the data buffer if the length of the data buffer is less than 16 bytes.
This is because they perform the read via a single 16-byte load. This
can potentially result in accessing a page that is not mapped and thus
causing the machine to crash. This patch fixes that by reading the
partial block byte-by-byte and optionally an via 8-byte load if the block
was at least 8 bytes.

Fixes: 0487ccac ("crypto: aesni - make non-AVX AES-GCM work with any aadlen")
Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 87 ++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 16627fec80b2..c36b850fdc81 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -256,6 +256,37 @@ aad_shift_arr:
 	pxor      \TMP1, \GH            # result is in TMP1
 .endm
 
+# Reads DLEN bytes starting at DPTR and stores in XMMDst
+# where 0 < DLEN < 16
+# Clobbers %rax, DLEN and XMM1
+.macro READ_PARTIAL_BLOCK DPTR DLEN XMM1 XMMDst
+        cmp $8, \DLEN
+        jl _read_lt8_\@
+        mov (\DPTR), %rax
+        MOVQ_R64_XMM %rax, \XMMDst
+        sub $8, \DLEN
+        jz _done_read_partial_block_\@
+	xor %eax, %eax
+_read_next_byte_\@:
+        shl $8, %rax
+        mov 7(\DPTR, \DLEN, 1), %al
+        dec \DLEN
+        jnz _read_next_byte_\@
+        MOVQ_R64_XMM %rax, \XMM1
+	pslldq $8, \XMM1
+        por \XMM1, \XMMDst
+	jmp _done_read_partial_block_\@
+_read_lt8_\@:
+	xor %eax, %eax
+_read_next_byte_lt8_\@:
+        shl $8, %rax
+        mov -1(\DPTR, \DLEN, 1), %al
+        dec \DLEN
+        jnz _read_next_byte_lt8_\@
+        MOVQ_R64_XMM %rax, \XMMDst
+_done_read_partial_block_\@:
+.endm
+
 /*
 * if a = number of total plaintext bytes
 * b = floor(a/16)
@@ -1385,14 +1416,6 @@ _esb_loop_\@:
 *
 *                        AAD Format with 64-bit Extended Sequence Number
 *
-* aadLen:
-*       from the definition of the spec, aadLen can only be 8 or 12 bytes.
-*       The code supports 16 too but for other sizes, the code will fail.
-*
-* TLen:
-*       from the definition of the spec, TLen can only be 8, 12 or 16 bytes.
-*       For other sizes, the code will fail.
-*
 * poly = x^128 + x^127 + x^126 + x^121 + 1
 *
 *****************************************************************************/
@@ -1486,19 +1509,16 @@ _zero_cipher_left_decrypt:
 	PSHUFB_XMM %xmm10, %xmm0
 
 	ENCRYPT_SINGLE_BLOCK  %xmm0, %xmm1    # E(K, Yn)
-	sub $16, %r11
-	add %r13, %r11
-	movdqu (%arg3,%r11,1), %xmm1   # receive the last <16 byte block
-	lea SHIFT_MASK+16(%rip), %r12
-	sub %r13, %r12
-# adjust the shuffle mask pointer to be able to shift 16-%r13 bytes
-# (%r13 is the number of bytes in plaintext mod 16)
-	movdqu (%r12), %xmm2           # get the appropriate shuffle mask
-	PSHUFB_XMM %xmm2, %xmm1            # right shift 16-%r13 butes
 
+	lea (%arg3,%r11,1), %r10
+	mov %r13, %r12
+	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
+
+	lea ALL_F+16(%rip), %r12
+	sub %r13, %r12
 	movdqa  %xmm1, %xmm2
 	pxor %xmm1, %xmm0            # Ciphertext XOR E(K, Yn)
-	movdqu ALL_F-SHIFT_MASK(%r12), %xmm1
+	movdqu (%r12), %xmm1
 	# get the appropriate mask to mask out top 16-%r13 bytes of %xmm0
 	pand %xmm1, %xmm0            # mask out top 16-%r13 bytes of %xmm0
 	pand    %xmm1, %xmm2
@@ -1507,9 +1527,6 @@ _zero_cipher_left_decrypt:
 
 	pxor %xmm2, %xmm8
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
-	          # GHASH computation for the last <16 byte block
-	sub %r13, %r11
-	add $16, %r11
 
         # output %r13 bytes
 	MOVQ_R64_XMM	%xmm0, %rax
@@ -1663,14 +1680,6 @@ ENDPROC(aesni_gcm_dec)
 *
 *                         AAD Format with 64-bit Extended Sequence Number
 *
-* aadLen:
-*       from the definition of the spec, aadLen can only be 8 or 12 bytes.
-*       The code supports 16 too but for other sizes, the code will fail.
-*
-* TLen:
-*       from the definition of the spec, TLen can only be 8, 12 or 16 bytes.
-*       For other sizes, the code will fail.
-*
 * poly = x^128 + x^127 + x^126 + x^121 + 1
 ***************************************************************************/
 ENTRY(aesni_gcm_enc)
@@ -1763,19 +1772,16 @@ _zero_cipher_left_encrypt:
         movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
 
-
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
-	sub $16, %r11
-	add %r13, %r11
-	movdqu (%arg3,%r11,1), %xmm1     # receive the last <16 byte blocks
-	lea SHIFT_MASK+16(%rip), %r12
+
+	lea (%arg3,%r11,1), %r10
+	mov %r13, %r12
+	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
+
+	lea ALL_F+16(%rip), %r12
 	sub %r13, %r12
-	# adjust the shuffle mask pointer to be able to shift 16-r13 bytes
-	# (%r13 is the number of bytes in plaintext mod 16)
-	movdqu	(%r12), %xmm2           # get the appropriate shuffle mask
-	PSHUFB_XMM	%xmm2, %xmm1            # shift right 16-r13 byte
 	pxor	%xmm1, %xmm0            # Plaintext XOR Encrypt(K, Yn)
-	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
+	movdqu	(%r12), %xmm1
 	# get the appropriate mask to mask out top 16-r13 bytes of xmm0
 	pand	%xmm1, %xmm0            # mask out top 16-r13 bytes of xmm0
         movdqa SHUF_MASK(%rip), %xmm10
@@ -1784,9 +1790,6 @@ _zero_cipher_left_encrypt:
 	pxor	%xmm0, %xmm8
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	# GHASH computation for the last <16 byte block
-	sub	%r13, %r11
-	add	$16, %r11
-
 	movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
 
-- 
2.15.1.620.gb9897f4670-goog
