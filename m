From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 07/14] x86/crypto: aesni: Split AAD hash calculation to
 separate macro
Date: Mon, 12 Feb 2018 11:49:42 -0800
Message-ID: <20180212194942.GA60838@davejwatson-mba.local>
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
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751208AbeBLTuO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 14:50:14 -0500
Content-Disposition: inline
In-Reply-To: <cover.1518211765.git.davejwatson@fb.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AAD hash only needs to be calculated once for each scatter/gather operation.
Move it to its own macro, and call it from GCM_INIT instead of
INITIAL_BLOCKS.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 71 ++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 6c5a80d..58bbfac 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -229,6 +229,10 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	mov	%arg5, %r13		# %xmm13 holds HashKey<<1 (mod poly)
 	and	$-16, %r13
 	mov	%r13, %r12
+
+	CALC_AAD_HASH %xmm13 %xmm0 %xmm1 %xmm2 %xmm3 %xmm4 \
+	%xmm5 %xmm6
+	mov %r13, %r12
 .endm
 
 # GCM_ENC_DEC Encodes/Decodes given data. Assumes that the passed gcm_context
@@ -496,51 +500,62 @@ _read_next_byte_lt8_\@:
 _done_read_partial_block_\@:
 .endm
 
-/*
-* if a = number of total plaintext bytes
-* b = floor(a/16)
-* num_initial_blocks = b mod 4
-* encrypt the initial num_initial_blocks blocks and apply ghash on
-* the ciphertext
-* %r10, %r11, %r12, %rax, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9 registers
-* are clobbered
-* arg1, %arg3, %arg4, %r14 are used as a pointer only, not modified
-*/
-
-
-.macro INITIAL_BLOCKS_ENC_DEC TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
-XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
-        MOVADQ     SHUF_MASK(%rip), %xmm14
-	mov	   arg8, %r10           # %r10 = AAD
-	mov	   arg9, %r11           # %r11 = aadLen
-	pxor	   %xmm\i, %xmm\i
-	pxor	   \XMM2, \XMM2
+# CALC_AAD_HASH: Calculates the hash of the data which will not be encrypted.
+# clobbers r10-11, xmm14
+.macro CALC_AAD_HASH HASHKEY TMP1 TMP2 TMP3 TMP4 TMP5 \
+	TMP6 TMP7
+	MOVADQ	   SHUF_MASK(%rip), %xmm14
+	mov	   arg8, %r10		# %r10 = AAD
+	mov	   arg9, %r11		# %r11 = aadLen
+	pxor	   \TMP7, \TMP7
+	pxor	   \TMP6, \TMP6
 
 	cmp	   $16, %r11
 	jl	   _get_AAD_rest\@
 _get_AAD_blocks\@:
-	movdqu	   (%r10), %xmm\i
-	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
-	pxor	   %xmm\i, \XMM2
-	GHASH_MUL  \XMM2, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+	movdqu	   (%r10), \TMP7
+	PSHUFB_XMM   %xmm14, \TMP7 # byte-reflect the AAD data
+	pxor	   \TMP7, \TMP6
+	GHASH_MUL  \TMP6, \HASHKEY, \TMP1, \TMP2, \TMP3, \TMP4, \TMP5
 	add	   $16, %r10
 	sub	   $16, %r11
 	cmp	   $16, %r11
 	jge	   _get_AAD_blocks\@
 
-	movdqu	   \XMM2, %xmm\i
+	movdqu	   \TMP6, \TMP7
 
 	/* read the last <16B of AAD */
 _get_AAD_rest\@:
 	cmp	   $0, %r11
 	je	   _get_AAD_done\@
 
-	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, %xmm\i
-	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
-	pxor	   \XMM2, %xmm\i
-	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, \TMP7
+	PSHUFB_XMM   %xmm14, \TMP7 # byte-reflect the AAD data
+	pxor	   \TMP6, \TMP7
+	GHASH_MUL  \TMP7, \HASHKEY, \TMP1, \TMP2, \TMP3, \TMP4, \TMP5
+	movdqu \TMP7, \TMP6
 
 _get_AAD_done\@:
+	movdqu \TMP6, AadHash(%arg2)
+.endm
+
+/*
+* if a = number of total plaintext bytes
+* b = floor(a/16)
+* num_initial_blocks = b mod 4
+* encrypt the initial num_initial_blocks blocks and apply ghash on
+* the ciphertext
+* %r10, %r11, %r12, %rax, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9 registers
+* are clobbered
+* arg1, %arg2, %arg3, %r14 are used as a pointer only, not modified
+*/
+
+
+.macro INITIAL_BLOCKS_ENC_DEC TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
+	XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
+
+	movdqu AadHash(%arg2), %xmm\i		    # XMM0 = Y0
+
 	xor	   %r11, %r11 # initialise the data pointer offset as zero
 	# start AES for num_initial_blocks blocks
 
-- 
2.9.5
