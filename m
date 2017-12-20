From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 2/2] crypto: Fix out-of-bounds access of the AAD buffer in generic-gcm-aesni
Date: Tue, 19 Dec 2017 20:42:59 -0800
Message-ID: <20171220044259.61106-3-junaids@google.com>
References: <20171220044259.61106-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33752 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbdLTEnE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 23:43:04 -0500
Received: by mail-pf0-f193.google.com with SMTP id y89so12127760pfk.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Dec 2017 20:43:04 -0800 (PST)
In-Reply-To: <20171220044259.61106-1-junaids@google.com>
In-Reply-To: <20171219221750.34148-1-junaids@google.com>
References: <20171219221750.34148-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The aesni_gcm_enc/dec functions can access memory after the end of
the AAD buffer if the AAD length is not a multiple of 4 bytes.
It didn't matter with rfc4106-gcm-aesni as in that case the AAD was
always followed by the 8 byte IV, but that is no longer the case with
generic-gcm-aesni. This can potentially result in accessing a page that
is not mapped and thus causing the machine to crash. This patch fixes
that by reading the last <16 byte block of the AAD byte-by-byte and
optionally via an 8-byte load if the block was at least 8 bytes.

Fixes: 0487ccac ("crypto: aesni - make non-AVX AES-GCM work with any aadlen")
Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 80 +++++----------------------------------
 1 file changed, 10 insertions(+), 70 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 4b16f31cb359..03846f2d32c9 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -309,7 +309,7 @@ XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
 	pxor       \XMM2, \XMM2
 
 	cmp	   $16, %r11
-	jl	   _get_AAD_rest8\num_initial_blocks\operation
+	jl	   _get_AAD_rest\num_initial_blocks\operation
 _get_AAD_blocks\num_initial_blocks\operation:
 	movdqu	   (%r10), %xmm\i
 	PSHUFB_XMM %xmm14, %xmm\i # byte-reflect the AAD data
@@ -322,43 +322,13 @@ _get_AAD_blocks\num_initial_blocks\operation:
 	jge	   _get_AAD_blocks\num_initial_blocks\operation
 
 	movdqu	   \XMM2, %xmm\i
+
+	/* read the last <16B of AAD */
+_get_AAD_rest\num_initial_blocks\operation:
 	cmp	   $0, %r11
 	je	   _get_AAD_done\num_initial_blocks\operation
 
-	pxor	   %xmm\i,%xmm\i
-
-	/* read the last <16B of AAD. since we have at least 4B of
-	data right after the AAD (the ICV, and maybe some CT), we can
-	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\num_initial_blocks\operation:
-	cmp	   $4, %r11
-	jle	   _get_AAD_rest4\num_initial_blocks\operation
-	movq	   (%r10), \TMP1
-	add	   $8, %r10
-	sub	   $8, %r11
-	pslldq	   $8, \TMP1
-	psrldq	   $8, %xmm\i
-	pxor	   \TMP1, %xmm\i
-	jmp	   _get_AAD_rest8\num_initial_blocks\operation
-_get_AAD_rest4\num_initial_blocks\operation:
-	cmp	   $0, %r11
-	jle	   _get_AAD_rest0\num_initial_blocks\operation
-	mov	   (%r10), %eax
-	movq	   %rax, \TMP1
-	add	   $4, %r10
-	sub	   $4, %r10
-	pslldq	   $12, \TMP1
-	psrldq	   $4, %xmm\i
-	pxor	   \TMP1, %xmm\i
-_get_AAD_rest0\num_initial_blocks\operation:
-	/* finalize: shift out the extra bytes we read, and align
-	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq	   %r12, %r11
-	salq	   $4, %r11
-	movdqu	   aad_shift_arr(%r11), \TMP1
-	PSHUFB_XMM \TMP1, %xmm\i
-_get_AAD_rest_final\num_initial_blocks\operation:
+	READ_PARTIAL_BLOCK %r10, %r12, %r11, \TMP1, \TMP2, %xmm\i
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
 	pxor	   \XMM2, %xmm\i
 	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
@@ -568,7 +538,7 @@ XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
 	pxor	   \XMM2, \XMM2
 
 	cmp	   $16, %r11
-	jl	   _get_AAD_rest8\num_initial_blocks\operation
+	jl	   _get_AAD_rest\num_initial_blocks\operation
 _get_AAD_blocks\num_initial_blocks\operation:
 	movdqu	   (%r10), %xmm\i
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
@@ -581,43 +551,13 @@ _get_AAD_blocks\num_initial_blocks\operation:
 	jge	   _get_AAD_blocks\num_initial_blocks\operation
 
 	movdqu	   \XMM2, %xmm\i
+
+	/* read the last <16B of AAD */
+_get_AAD_rest\num_initial_blocks\operation:
 	cmp	   $0, %r11
 	je	   _get_AAD_done\num_initial_blocks\operation
 
-	pxor	   %xmm\i,%xmm\i
-
-	/* read the last <16B of AAD. since we have at least 4B of
-	data right after the AAD (the ICV, and maybe some PT), we can
-	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\num_initial_blocks\operation:
-	cmp	   $4, %r11
-	jle	   _get_AAD_rest4\num_initial_blocks\operation
-	movq	   (%r10), \TMP1
-	add	   $8, %r10
-	sub	   $8, %r11
-	pslldq	   $8, \TMP1
-	psrldq	   $8, %xmm\i
-	pxor	   \TMP1, %xmm\i
-	jmp	   _get_AAD_rest8\num_initial_blocks\operation
-_get_AAD_rest4\num_initial_blocks\operation:
-	cmp	   $0, %r11
-	jle	   _get_AAD_rest0\num_initial_blocks\operation
-	mov	   (%r10), %eax
-	movq	   %rax, \TMP1
-	add	   $4, %r10
-	sub	   $4, %r10
-	pslldq	   $12, \TMP1
-	psrldq	   $4, %xmm\i
-	pxor	   \TMP1, %xmm\i
-_get_AAD_rest0\num_initial_blocks\operation:
-	/* finalize: shift out the extra bytes we read, and align
-	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq	   %r12, %r11
-	salq	   $4, %r11
-	movdqu	   aad_shift_arr(%r11), \TMP1
-	PSHUFB_XMM \TMP1, %xmm\i
-_get_AAD_rest_final\num_initial_blocks\operation:
+	READ_PARTIAL_BLOCK %r10, %r12, %r11, \TMP1, \TMP2, %xmm\i
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
 	pxor	   \XMM2, %xmm\i
 	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-- 
2.15.1.620.gb9897f4670-goog
