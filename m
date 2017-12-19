From: Junaid Shahid <junaids@google.com>
Subject: [PATCH] crypto: Fix out-of-bounds memory access in generic-gcm-aesni
Date: Tue, 19 Dec 2017 14:17:50 -0800
Message-ID: <20171219221750.34148-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32938 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752653AbdLSWRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 17:17:54 -0500
Received: by mail-pf0-f196.google.com with SMTP id y89so11741087pfk.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Dec 2017 14:17:54 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The aesni_gcm_enc/dec functions can access memory before the start of
the data buffer if the length of the data buffer is less than 16 bytes.
This is because they perform the read via a single 16-byte load. It
didn't matter with rfc4106-gcm-aesni as in that case there was always at
least 16 bytes preceding the data buffer in the form of AAD+IV, but that
is no longer the case with generic-gcm-aesni. This can potentially result
in accessing a page that is not mapped and thus causing the machine to
crash. This patch fixes that by reading the partial block byte-by-byte and
optionally via an 8-byte load if the block was at least 8 bytes.

Fixes: 0487ccac ("crypto: aesni - make non-AVX AES-GCM work with any aadlen")
Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 85 ++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 16627fec80b2..a442d4645e91 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -85,6 +85,7 @@ enc:        .octa 0x2
 # and zero should follow ALL_F
 .section	.rodata, "a", @progbits
 .align 16
+            .octa 0xffffffffffffffffffffffffffffffff
 SHIFT_MASK: .octa 0x0f0e0d0c0b0a09080706050403020100
 ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
             .octa 0x00000000000000000000000000000000
@@ -1310,6 +1311,40 @@ _esb_loop_\@:
 	MOVADQ		(%r10),\TMP1
 	AESENCLAST	\TMP1,\XMM0
 .endm
+
+# read the last <16 byte block
+# %r11 is the data offset value
+# %r13 is the length of the partial block
+# Clobbers %rax, TMP1-2 and XMM1-2
+.macro READ_PARTIAL_BLOCK TMP1, TMP2, XMM1, XMM2, XMMDst
+        pxor \XMMDst, \XMMDst
+	lea -1(%arg3,%r11,1), \TMP1
+        mov %r13, \TMP2
+        cmp $8, %r13
+        jl _read_last_lt8_encrypt_\@
+        mov 1(\TMP1), %rax
+        MOVQ_R64_XMM %rax, \XMMDst
+        add $8, \TMP1
+        sub $8, \TMP2
+        jz _done_read_last_partial_block_encrypt_\@
+_read_last_lt8_encrypt_\@:
+	shl $8, %rax
+        mov (\TMP1, \TMP2, 1), %al
+        dec \TMP2
+        jnz _read_last_lt8_encrypt_\@
+        MOVQ_R64_XMM %rax, \XMM1
+	# adjust the shuffle mask pointer to be able to shift either 0 or 8
+	# bytes depending on whether the last block is <8 bytes or not
+        mov %r13, \TMP1
+        and $8, \TMP1
+	lea SHIFT_MASK(%rip), %rax
+	sub \TMP1, %rax
+	movdqu (%rax), \XMM2		# get the appropriate shuffle mask
+	PSHUFB_XMM \XMM2, \XMM1		# shift left either 0 or 8 bytes
+	por \XMM1, \XMMDst
+_done_read_last_partial_block_encrypt_\@:
+.endm
+
 /*****************************************************************************
 * void aesni_gcm_dec(void *aes_ctx,    // AES Key schedule. Starts on a 16 byte boundary.
 *                   u8 *out,           // Plaintext output. Encrypt in-place is allowed.
@@ -1385,14 +1420,6 @@ _esb_loop_\@:
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
@@ -1486,19 +1513,13 @@ _zero_cipher_left_decrypt:
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
+	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm3 %xmm1
 
+	lea ALL_F+16(%rip), %r12
+	sub %r13, %r12
 	movdqa  %xmm1, %xmm2
 	pxor %xmm1, %xmm0            # Ciphertext XOR E(K, Yn)
-	movdqu ALL_F-SHIFT_MASK(%r12), %xmm1
+	movdqu (%r12), %xmm1
 	# get the appropriate mask to mask out top 16-%r13 bytes of %xmm0
 	pand %xmm1, %xmm0            # mask out top 16-%r13 bytes of %xmm0
 	pand    %xmm1, %xmm2
@@ -1507,9 +1528,6 @@ _zero_cipher_left_decrypt:
 
 	pxor %xmm2, %xmm8
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
-	          # GHASH computation for the last <16 byte block
-	sub %r13, %r11
-	add $16, %r11
 
         # output %r13 bytes
 	MOVQ_R64_XMM	%xmm0, %rax
@@ -1663,14 +1681,6 @@ ENDPROC(aesni_gcm_dec)
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
@@ -1763,19 +1773,13 @@ _zero_cipher_left_encrypt:
         movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
 
-
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
-	sub $16, %r11
-	add %r13, %r11
-	movdqu (%arg3,%r11,1), %xmm1     # receive the last <16 byte blocks
-	lea SHIFT_MASK+16(%rip), %r12
+	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm3 %xmm1
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
@@ -1784,9 +1788,6 @@ _zero_cipher_left_encrypt:
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
