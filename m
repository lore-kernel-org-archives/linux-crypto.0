From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 04/14] x86/crypto: aesni: Add GCM_COMPLETE macro
Date: Mon, 12 Feb 2018 11:48:48 -0800
Message-ID: <20180212194848.GA60699@davejwatson-mba.local>
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
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932252AbeBLTtP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 14:49:15 -0500
Content-Disposition: inline
In-Reply-To: <cover.1518211765.git.davejwatson@fb.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Merge encode and decode tag calculations in GCM_COMPLETE macro.
Scatter/gather routines will call this once at the end of encryption
or decryption.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 172 ++++++++++++++------------------------
 1 file changed, 63 insertions(+), 109 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index b9fe2ab..529c542 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -222,6 +222,67 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	mov	%r13, %r12
 .endm
 
+# GCM_COMPLETE Finishes update of tag of last partial block
+# Output: Authorization Tag (AUTH_TAG)
+# Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
+.macro GCM_COMPLETE
+	mov	arg8, %r12		  # %r13 = aadLen (number of bytes)
+	shl	$3, %r12		  # convert into number of bits
+	movd	%r12d, %xmm15		  # len(A) in %xmm15
+	shl	$3, %arg4		  # len(C) in bits (*128)
+	MOVQ_R64_XMM	%arg4, %xmm1
+	pslldq	$8, %xmm15		  # %xmm15 = len(A)||0x0000000000000000
+	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
+	pxor	%xmm15, %xmm8
+	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
+	# final GHASH computation
+	movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm8
+
+	mov	%arg5, %rax		  # %rax = *Y0
+	movdqu	(%rax), %xmm0		  # %xmm0 = Y0
+	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
+	pxor	%xmm8, %xmm0
+_return_T_\@:
+	mov	arg9, %r10                     # %r10 = authTag
+	mov	arg10, %r11                    # %r11 = auth_tag_len
+	cmp	$16, %r11
+	je	_T_16_\@
+	cmp	$8, %r11
+	jl	_T_4_\@
+_T_8_\@:
+	MOVQ_R64_XMM	%xmm0, %rax
+	mov	%rax, (%r10)
+	add	$8, %r10
+	sub	$8, %r11
+	psrldq	$8, %xmm0
+	cmp	$0, %r11
+	je	_return_T_done_\@
+_T_4_\@:
+	movd	%xmm0, %eax
+	mov	%eax, (%r10)
+	add	$4, %r10
+	sub	$4, %r11
+	psrldq	$4, %xmm0
+	cmp	$0, %r11
+	je	_return_T_done_\@
+_T_123_\@:
+	movd	%xmm0, %eax
+	cmp	$2, %r11
+	jl	_T_1_\@
+	mov	%ax, (%r10)
+	cmp	$2, %r11
+	je	_return_T_done_\@
+	add	$2, %r10
+	sar	$16, %eax
+_T_1_\@:
+	mov	%al, (%r10)
+	jmp	_return_T_done_\@
+_T_16_\@:
+	movdqu	%xmm0, (%r10)
+_return_T_done_\@:
+.endm
+
 #ifdef __x86_64__
 /* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
 *
@@ -1271,61 +1332,7 @@ _less_than_8_bytes_left_decrypt:
 	sub	$1, %r13
 	jne	_less_than_8_bytes_left_decrypt
 _multiple_of_16_bytes_decrypt:
-	mov	arg8, %r12		  # %r13 = aadLen (number of bytes)
-	shl	$3, %r12		  # convert into number of bits
-	movd	%r12d, %xmm15		  # len(A) in %xmm15
-	shl	$3, %arg4		  # len(C) in bits (*128)
-	MOVQ_R64_XMM	%arg4, %xmm1
-	pslldq	$8, %xmm15		  # %xmm15 = len(A)||0x0000000000000000
-	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
-	pxor	%xmm15, %xmm8
-	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
-	         # final GHASH computation
-        movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm8
-
-	mov	%arg5, %rax		  # %rax = *Y0
-	movdqu	(%rax), %xmm0		  # %xmm0 = Y0
-	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
-	pxor	%xmm8, %xmm0
-_return_T_decrypt:
-	mov	arg9, %r10                # %r10 = authTag
-	mov	arg10, %r11               # %r11 = auth_tag_len
-	cmp	$16, %r11
-	je	_T_16_decrypt
-	cmp	$8, %r11
-	jl	_T_4_decrypt
-_T_8_decrypt:
-	MOVQ_R64_XMM	%xmm0, %rax
-	mov	%rax, (%r10)
-	add	$8, %r10
-	sub	$8, %r11
-	psrldq	$8, %xmm0
-	cmp	$0, %r11
-	je	_return_T_done_decrypt
-_T_4_decrypt:
-	movd	%xmm0, %eax
-	mov	%eax, (%r10)
-	add	$4, %r10
-	sub	$4, %r11
-	psrldq	$4, %xmm0
-	cmp	$0, %r11
-	je	_return_T_done_decrypt
-_T_123_decrypt:
-	movd	%xmm0, %eax
-	cmp	$2, %r11
-	jl	_T_1_decrypt
-	mov	%ax, (%r10)
-	cmp	$2, %r11
-	je	_return_T_done_decrypt
-	add	$2, %r10
-	sar	$16, %eax
-_T_1_decrypt:
-	mov	%al, (%r10)
-	jmp	_return_T_done_decrypt
-_T_16_decrypt:
-	movdqu	%xmm0, (%r10)
-_return_T_done_decrypt:
+	GCM_COMPLETE
 	FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_dec)
@@ -1501,61 +1508,8 @@ _less_than_8_bytes_left_encrypt:
 	sub $1, %r13
 	jne _less_than_8_bytes_left_encrypt
 _multiple_of_16_bytes_encrypt:
-	mov	arg8, %r12    # %r12 = addLen (number of bytes)
-	shl	$3, %r12
-	movd	%r12d, %xmm15       # len(A) in %xmm15
-	shl	$3, %arg4               # len(C) in bits (*128)
-	MOVQ_R64_XMM	%arg4, %xmm1
-	pslldq	$8, %xmm15          # %xmm15 = len(A)||0x0000000000000000
-	pxor	%xmm1, %xmm15       # %xmm15 = len(A)||len(C)
-	pxor	%xmm15, %xmm8
-	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
-	# final GHASH computation
-        movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm8         # perform a 16 byte swap
-
-	mov	%arg5, %rax		       # %rax  = *Y0
-	movdqu	(%rax), %xmm0		       # %xmm0 = Y0
-	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm15         # Encrypt(K, Y0)
-	pxor	%xmm8, %xmm0
 _return_T_encrypt:
-	mov	arg9, %r10                     # %r10 = authTag
-	mov	arg10, %r11                    # %r11 = auth_tag_len
-	cmp	$16, %r11
-	je	_T_16_encrypt
-	cmp	$8, %r11
-	jl	_T_4_encrypt
-_T_8_encrypt:
-	MOVQ_R64_XMM	%xmm0, %rax
-	mov	%rax, (%r10)
-	add	$8, %r10
-	sub	$8, %r11
-	psrldq	$8, %xmm0
-	cmp	$0, %r11
-	je	_return_T_done_encrypt
-_T_4_encrypt:
-	movd	%xmm0, %eax
-	mov	%eax, (%r10)
-	add	$4, %r10
-	sub	$4, %r11
-	psrldq	$4, %xmm0
-	cmp	$0, %r11
-	je	_return_T_done_encrypt
-_T_123_encrypt:
-	movd	%xmm0, %eax
-	cmp	$2, %r11
-	jl	_T_1_encrypt
-	mov	%ax, (%r10)
-	cmp	$2, %r11
-	je	_return_T_done_encrypt
-	add	$2, %r10
-	sar	$16, %eax
-_T_1_encrypt:
-	mov	%al, (%r10)
-	jmp	_return_T_done_encrypt
-_T_16_encrypt:
-	movdqu	%xmm0, (%r10)
-_return_T_done_encrypt:
+	GCM_COMPLETE
 	FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_enc)
-- 
2.9.5
