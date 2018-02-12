From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 08/14] x86/crypto: aesni: Fill in new context data structures
Date: Mon, 12 Feb 2018 11:49:58 -0800
Message-ID: <20180212194958.GA60868@davejwatson-mba.local>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1518211765.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fill in aadhash, aadlen, pblocklen, curcount with appropriate values.
pblocklen, aadhash, and pblockenckey are also updated at the end
of each scatter/gather operation, to be carried over to the next
operation.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 51 ++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 58bbfac..aa82493 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -204,6 +204,21 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 # GCM_INIT initializes a gcm_context struct to prepare for encoding/decoding.
 # Clobbers rax, r10-r13 and xmm0-xmm6, %xmm13
 .macro GCM_INIT
+
+	mov arg9, %r11
+	mov %r11, AadLen(%arg2) # ctx_data.aad_length = aad_length
+	xor %r11, %r11
+	mov %r11, InLen(%arg2) # ctx_data.in_length = 0
+	mov %r11, PBlockLen(%arg2) # ctx_data.partial_block_length = 0
+	mov %r11, PBlockEncKey(%arg2) # ctx_data.partial_block_enc_key = 0
+	mov %arg6, %rax
+	movdqu (%rax), %xmm0
+	movdqu %xmm0, OrigIV(%arg2) # ctx_data.orig_IV = iv
+
+	movdqa  SHUF_MASK(%rip), %xmm2
+	PSHUFB_XMM %xmm2, %xmm0
+	movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
+
 	mov	arg7, %r12
 	movdqu	(%r12), %xmm13
 	movdqa	SHUF_MASK(%rip), %xmm2
@@ -226,13 +241,9 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	pand	POLY(%rip), %xmm2
 	pxor	%xmm2, %xmm13
 	movdqa	%xmm13, HashKey(%rsp)
-	mov	%arg5, %r13		# %xmm13 holds HashKey<<1 (mod poly)
-	and	$-16, %r13
-	mov	%r13, %r12
 
 	CALC_AAD_HASH %xmm13 %xmm0 %xmm1 %xmm2 %xmm3 %xmm4 \
 	%xmm5 %xmm6
-	mov %r13, %r12
 .endm
 
 # GCM_ENC_DEC Encodes/Decodes given data. Assumes that the passed gcm_context
@@ -240,6 +251,12 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 # Requires the input data be at least 1 byte long because of READ_PARTIAL_BLOCK
 # Clobbers rax, r10-r13, and xmm0-xmm15
 .macro GCM_ENC_DEC operation
+	movdqu AadHash(%arg2), %xmm8
+	movdqu HashKey(%rsp), %xmm13
+	add %arg5, InLen(%arg2)
+	mov %arg5, %r13		# save the number of bytes
+	and $-16, %r13		# %r13 = %r13 - (%r13 mod 16)
+	mov %r13, %r12
 	# Encrypt/Decrypt first few blocks
 
 	and	$(3<<4), %r12
@@ -284,16 +301,23 @@ _four_cipher_left_\@:
 	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, \
 %xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
 _zero_cipher_left_\@:
+	movdqu %xmm8, AadHash(%arg2)
+	movdqu %xmm0, CurCount(%arg2)
+
 	mov	%arg5, %r13
 	and	$15, %r13			# %r13 = arg5 (mod 16)
 	je	_multiple_of_16_bytes_\@
 
+	mov %r13, PBlockLen(%arg2)
+
 	# Handle the last <16 Byte block separately
 	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
+	movdqu %xmm0, CurCount(%arg2)
 	movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
 
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
+	movdqu %xmm0, PBlockEncKey(%arg2)
 
 	lea (%arg4,%r11,1), %r10
 	mov %r13, %r12
@@ -322,6 +346,7 @@ _zero_cipher_left_\@:
 .endif
 
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
+	movdqu %xmm8, AadHash(%arg2)
 .ifc \operation, enc
 	# GHASH computation for the last <16 byte block
 	movdqa SHUF_MASK(%rip), %xmm10
@@ -351,11 +376,15 @@ _multiple_of_16_bytes_\@:
 # Output: Authorization Tag (AUTH_TAG)
 # Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
 .macro GCM_COMPLETE
-	mov	arg9, %r12		  # %r13 = aadLen (number of bytes)
+	movdqu AadHash(%arg2), %xmm8
+	movdqu HashKey(%rsp), %xmm13
+	mov AadLen(%arg2), %r12  # %r13 = aadLen (number of bytes)
 	shl	$3, %r12		  # convert into number of bits
 	movd	%r12d, %xmm15		  # len(A) in %xmm15
-	shl	$3, %arg5		  # len(C) in bits (*128)
-	MOVQ_R64_XMM	%arg5, %xmm1
+	mov InLen(%arg2), %r12
+	shl     $3, %r12                  # len(C) in bits (*128)
+	MOVQ_R64_XMM    %r12, %xmm1
+
 	pslldq	$8, %xmm15		  # %xmm15 = len(A)||0x0000000000000000
 	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
 	pxor	%xmm15, %xmm8
@@ -364,8 +393,7 @@ _multiple_of_16_bytes_\@:
 	movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm8
 
-	mov	%arg6, %rax		  # %rax = *Y0
-	movdqu	(%rax), %xmm0		  # %xmm0 = Y0
+	movdqu OrigIV(%arg2), %xmm0       # %xmm0 = Y0
 	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
 	pxor	%xmm8, %xmm0
 _return_T_\@:
@@ -553,15 +581,14 @@ _get_AAD_done\@:
 
 .macro INITIAL_BLOCKS_ENC_DEC TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
 	XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
+	MOVADQ		SHUF_MASK(%rip), %xmm14
 
 	movdqu AadHash(%arg2), %xmm\i		    # XMM0 = Y0
 
 	xor	   %r11, %r11 # initialise the data pointer offset as zero
 	# start AES for num_initial_blocks blocks
 
-	mov	   %arg6, %rax                      # %rax = *Y0
-	movdqu	   (%rax), \XMM0                    # XMM0 = Y0
-	PSHUFB_XMM   %xmm14, \XMM0
+	movdqu CurCount(%arg2), \XMM0                # XMM0 = Y0
 
 .if (\i == 5) || (\i == 6) || (\i == 7)
 
-- 
2.9.5
