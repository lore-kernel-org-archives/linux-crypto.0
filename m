From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v3 1/4] crypto: aesni - Fix out-of-bounds access of the AAD buffer in AVX gcm-aesni
Date: Wed, 31 Jan 2018 12:27:19 -0800
Message-ID: <20180131202722.212273-2-junaids@google.com>
References: <20180131202722.212273-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com,
        smueller@chronox.de
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46308 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbeAaU12 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 15:27:28 -0500
Received: by mail-pf0-f193.google.com with SMTP id w69so354768pfd.13
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2018 12:27:27 -0800 (PST)
In-Reply-To: <20180131202722.212273-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AVX/AVX2 versions of gcm-aes encryption/decryption functions can
access memory after the end of the AAD buffer if the AAD length is
not a multiple of 4 bytes. It didn't matter as long as the AAD and
data buffers were always contiguous, since the AVX version are not used
for small data sizes and hence enough data bytes were always present to
cover the over-run. However, now that we have support for non-contiguous
AAD and data buffers, that is no longer the case. This can potentially
result in accessing a page that is not mapped and thus causing the
machine to crash. This patch fixes that by reading the last <16 byte
block of the AAD byte-by-byte and optionally via an 8-byte load if the
block was at least 8 bytes.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 154 +++++++++----------------------
 1 file changed, 42 insertions(+), 112 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index faecb1518bf8..97029059dc1a 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -106,14 +106,6 @@
 ##
 ##        AAD Format with 64-bit Extended Sequence Number
 ##
-##
-## aadLen:
-##       from the definition of the spec, aadLen can only be 8 or 12 bytes.
-##	 The code additionally supports aadLen of length 16 bytes.
-##
-## TLen:
-##       from the definition of the spec, TLen can only be 8, 12 or 16 bytes.
-##
 ## poly = x^128 + x^127 + x^126 + x^121 + 1
 ## throughout the code, one tab and two tab indentations are used. one tab is
 ## for GHASH part, two tabs is for AES part.
@@ -155,30 +147,6 @@ SHIFT_MASK:      .octa     0x0f0e0d0c0b0a09080706050403020100
 ALL_F:           .octa     0xffffffffffffffffffffffffffffffff
                  .octa     0x00000000000000000000000000000000
 
-.section .rodata
-.align 16
-.type aad_shift_arr, @object
-.size aad_shift_arr, 272
-aad_shift_arr:
-        .octa     0xffffffffffffffffffffffffffffffff
-        .octa     0xffffffffffffffffffffffffffffff0C
-        .octa     0xffffffffffffffffffffffffffff0D0C
-        .octa     0xffffffffffffffffffffffffff0E0D0C
-        .octa     0xffffffffffffffffffffffff0F0E0D0C
-        .octa     0xffffffffffffffffffffff0C0B0A0908
-        .octa     0xffffffffffffffffffff0D0C0B0A0908
-        .octa     0xffffffffffffffffff0E0D0C0B0A0908
-        .octa     0xffffffffffffffff0F0E0D0C0B0A0908
-        .octa     0xffffffffffffff0C0B0A090807060504
-        .octa     0xffffffffffff0D0C0B0A090807060504
-        .octa     0xffffffffff0E0D0C0B0A090807060504
-        .octa     0xffffffff0F0E0D0C0B0A090807060504
-        .octa     0xffffff0C0B0A09080706050403020100
-        .octa     0xffff0D0C0B0A09080706050403020100
-        .octa     0xff0E0D0C0B0A09080706050403020100
-        .octa     0x0F0E0D0C0B0A09080706050403020100
-
-
 .text
 
 
@@ -280,6 +248,36 @@ VARIABLE_OFFSET = 16*8
                 vaesenclast 16*10(arg1), \XMM0, \XMM0
 .endm
 
+# Reads DLEN bytes starting at DPTR and stores in XMMDst
+# where 0 < DLEN < 16
+# Clobbers %rax, DLEN and XMM1
+.macro READ_PARTIAL_BLOCK DPTR DLEN XMM1 XMMDst
+        cmp $8, \DLEN
+        jl _read_lt8_\@
+        movq (\DPTR), \XMMDst
+        sub $8, \DLEN
+        jz _done_read_partial_block_\@
+	xor %eax, %eax
+_read_next_byte_\@:
+        shl $8, %rax
+        mov 7(\DPTR, \DLEN, 1), %al
+        dec \DLEN
+        jnz _read_next_byte_\@
+        movq %rax, \XMM1
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
+        movq %rax, \XMMDst
+_done_read_partial_block_\@:
+.endm
+
 #ifdef CONFIG_AS_AVX
 ###############################################################################
 # GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
@@ -400,63 +398,29 @@ VARIABLE_OFFSET = 16*8
 	setreg
 
 	mov     arg6, %r10                      # r10 = AAD
-	mov     arg7, %r12                      # r12 = aadLen
-
-
-	mov     %r12, %r11
+	mov     arg7, %r11                      # r11 = aadLen
 
 	vpxor   reg_j, reg_j, reg_j
 	vpxor   reg_i, reg_i, reg_i
 	cmp     $16, %r11
-	jl      _get_AAD_rest8\@
+	jl      _get_AAD_rest\@
 _get_AAD_blocks\@:
 	vmovdqu (%r10), reg_i
 	vpshufb SHUF_MASK(%rip), reg_i, reg_i
 	vpxor   reg_i, reg_j, reg_j
 	GHASH_MUL_AVX       reg_j, \T2, \T1, \T3, \T4, \T5, \T6
 	add     $16, %r10
-	sub     $16, %r12
 	sub     $16, %r11
 	cmp     $16, %r11
 	jge     _get_AAD_blocks\@
 	vmovdqu reg_j, reg_i
+
+	/* read the last <16B of AAD. */
+_get_AAD_rest\@:
 	cmp     $0, %r11
 	je      _get_AAD_done\@
 
-	vpxor   reg_i, reg_i, reg_i
-
-	/* read the last <16B of AAD. since we have at least 4B of
-	data right after the AAD (the ICV, and maybe some CT), we can
-	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\@:
-	cmp     $4, %r11
-	jle     _get_AAD_rest4\@
-	movq    (%r10), \T1
-	add     $8, %r10
-	sub     $8, %r11
-	vpslldq $8, \T1, \T1
-	vpsrldq $8, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-	jmp     _get_AAD_rest8\@
-_get_AAD_rest4\@:
-	cmp     $0, %r11
-	jle      _get_AAD_rest0\@
-	mov     (%r10), %eax
-	movq    %rax, \T1
-	add     $4, %r10
-	sub     $4, %r11
-	vpslldq $12, \T1, \T1
-	vpsrldq $4, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-_get_AAD_rest0\@:
-	/* finalize: shift out the extra bytes we read, and align
-	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq    %r12, %r11
-	salq    $4, %r11
-	movdqu  aad_shift_arr(%r11), \T1
-	vpshufb \T1, reg_i, reg_i
-_get_AAD_rest_final\@:
+	READ_PARTIAL_BLOCK %r10, %r11, \T1, reg_i
 	vpshufb SHUF_MASK(%rip), reg_i, reg_i
 	vpxor   reg_j, reg_i, reg_i
 	GHASH_MUL_AVX       reg_i, \T2, \T1, \T3, \T4, \T5, \T6
@@ -1706,64 +1670,30 @@ ENDPROC(aesni_gcm_dec_avx_gen2)
 	setreg
 
 	mov     arg6, %r10                       # r10 = AAD
-	mov     arg7, %r12                       # r12 = aadLen
-
-
-	mov     %r12, %r11
+	mov     arg7, %r11                       # r11 = aadLen
 
 	vpxor   reg_j, reg_j, reg_j
 	vpxor   reg_i, reg_i, reg_i
 
 	cmp     $16, %r11
-	jl      _get_AAD_rest8\@
+	jl      _get_AAD_rest\@
 _get_AAD_blocks\@:
 	vmovdqu (%r10), reg_i
 	vpshufb SHUF_MASK(%rip), reg_i, reg_i
 	vpxor   reg_i, reg_j, reg_j
 	GHASH_MUL_AVX2      reg_j, \T2, \T1, \T3, \T4, \T5, \T6
 	add     $16, %r10
-	sub     $16, %r12
 	sub     $16, %r11
 	cmp     $16, %r11
 	jge     _get_AAD_blocks\@
 	vmovdqu reg_j, reg_i
+
+	/* read the last <16B of AAD. */
+_get_AAD_rest\@:
 	cmp     $0, %r11
 	je      _get_AAD_done\@
 
-	vpxor   reg_i, reg_i, reg_i
-
-	/* read the last <16B of AAD. since we have at least 4B of
-	data right after the AAD (the ICV, and maybe some CT), we can
-	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\@:
-	cmp     $4, %r11
-	jle     _get_AAD_rest4\@
-	movq    (%r10), \T1
-	add     $8, %r10
-	sub     $8, %r11
-	vpslldq $8, \T1, \T1
-	vpsrldq $8, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-	jmp     _get_AAD_rest8\@
-_get_AAD_rest4\@:
-	cmp     $0, %r11
-	jle     _get_AAD_rest0\@
-	mov     (%r10), %eax
-	movq    %rax, \T1
-	add     $4, %r10
-	sub     $4, %r11
-	vpslldq $12, \T1, \T1
-	vpsrldq $4, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-_get_AAD_rest0\@:
-	/* finalize: shift out the extra bytes we read, and align
-	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq    %r12, %r11
-	salq    $4, %r11
-	movdqu  aad_shift_arr(%r11), \T1
-	vpshufb \T1, reg_i, reg_i
-_get_AAD_rest_final\@:
+	READ_PARTIAL_BLOCK %r10, %r11, \T1, reg_i
 	vpshufb SHUF_MASK(%rip), reg_i, reg_i
 	vpxor   reg_j, reg_i, reg_i
 	GHASH_MUL_AVX2      reg_i, \T2, \T1, \T3, \T4, \T5, \T6
-- 
2.16.0.rc1.238.g530d649a79-goog
