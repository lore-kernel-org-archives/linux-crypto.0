From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 1/2] crypto: Fix out-of-bounds access of the data buffer in generic-gcm-aesni
Date: Tue, 19 Dec 2017 20:42:58 -0800
Message-ID: <20171220044259.61106-2-junaids@google.com>
References: <20171220044259.61106-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46531 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754098AbdLTEnD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 23:43:03 -0500
Received: by mail-pf0-f194.google.com with SMTP id c204so12102836pfc.13
        for <linux-crypto@vger.kernel.org>; Tue, 19 Dec 2017 20:43:03 -0800 (PST)
In-Reply-To: <20171220044259.61106-1-junaids@google.com>
In-Reply-To: <20171219221750.34148-1-junaids@google.com>
References: <20171219221750.34148-1-junaids@google.com>
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
 arch/x86/crypto/aesni-intel_asm.S | 86 ++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 42 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 16627fec80b2..4b16f31cb359 100644
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
@@ -256,6 +257,36 @@ aad_shift_arr:
 	pxor      \TMP1, \GH            # result is in TMP1
 .endm
 
+# read the last <16 byte block
+# Clobbers %rax, DPTR, TMP1 and XMM1-2
+.macro READ_PARTIAL_BLOCK DPTR DLEN TMP1 XMM1 XMM2 XMMDst
+        pxor \XMMDst, \XMMDst
+        mov \DLEN, \TMP1
+        cmp $8, \DLEN
+        jl _read_last_lt8_\@
+        mov (\DPTR), %rax
+        MOVQ_R64_XMM %rax, \XMMDst
+	add $8, \DPTR
+        sub $8, \TMP1
+        jz _done_read_last_partial_block_\@
+_read_last_lt8_\@:
+	shl $8, %rax
+        mov -1(\DPTR, \TMP1, 1), %al
+        dec \TMP1
+        jnz _read_last_lt8_\@
+        MOVQ_R64_XMM %rax, \XMM1
+	# adjust the shuffle mask pointer to be able to shift either 0 or 8
+	# bytes depending on whether the last block is <8 bytes or not
+        mov \DLEN, \TMP1
+        and $8, \TMP1
+	lea SHIFT_MASK(%rip), %rax
+	sub \TMP1, %rax
+	movdqu (%rax), \XMM2		# get the appropriate shuffle mask
+	PSHUFB_XMM \XMM2, \XMM1		# shift left either 0 or 8 bytes
+	por \XMM1, \XMMDst
+_done_read_last_partial_block_\@:
+.endm
+
 /*
 * if a = number of total plaintext bytes
 * b = floor(a/16)
@@ -1310,6 +1341,7 @@ _esb_loop_\@:
 	MOVADQ		(%r10),\TMP1
 	AESENCLAST	\TMP1,\XMM0
 .endm
+
 /*****************************************************************************
 * void aesni_gcm_dec(void *aes_ctx,    // AES Key schedule. Starts on a 16 byte boundary.
 *                   u8 *out,           // Plaintext output. Encrypt in-place is allowed.
@@ -1385,14 +1417,6 @@ _esb_loop_\@:
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
@@ -1486,19 +1510,15 @@ _zero_cipher_left_decrypt:
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
+	READ_PARTIAL_BLOCK %r10 %r13 %r12 %xmm2 %xmm3 %xmm1
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
@@ -1763,19 +1772,15 @@ _zero_cipher_left_encrypt:
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
+	READ_PARTIAL_BLOCK %r10 %r13 %r12 %xmm2 %xmm3 %xmm1
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
@@ -1784,9 +1789,6 @@ _zero_cipher_left_encrypt:
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
