From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 01/14] x86/crypto: aesni: Merge INITIAL_BLOCKS_ENC/DEC
Date: Wed, 14 Feb 2018 09:38:12 -0800
Message-ID: <20180214173812.GA61794@davejwatson-mba>
References: <cover.1518628278.git.davejwatson@fb.com>
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
In-Reply-To: <cover.1518628278.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use macro operations to merge implemetations of INITIAL_BLOCKS,
since they differ by only a small handful of lines.

Use macro counter \@ to simplify implementation.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 298 ++++++--------------------------------
 1 file changed, 48 insertions(+), 250 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 76d8cd4..48911fe 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -275,234 +275,7 @@ _done_read_partial_block_\@:
 */
 
 
-.macro INITIAL_BLOCKS_DEC num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
-XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
-        MOVADQ     SHUF_MASK(%rip), %xmm14
-	mov	   arg7, %r10           # %r10 = AAD
-	mov	   arg8, %r11           # %r11 = aadLen
-	pxor	   %xmm\i, %xmm\i
-	pxor       \XMM2, \XMM2
-
-	cmp	   $16, %r11
-	jl	   _get_AAD_rest\num_initial_blocks\operation
-_get_AAD_blocks\num_initial_blocks\operation:
-	movdqu	   (%r10), %xmm\i
-	PSHUFB_XMM %xmm14, %xmm\i # byte-reflect the AAD data
-	pxor	   %xmm\i, \XMM2
-	GHASH_MUL  \XMM2, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-	add	   $16, %r10
-	sub	   $16, %r11
-	cmp	   $16, %r11
-	jge	   _get_AAD_blocks\num_initial_blocks\operation
-
-	movdqu	   \XMM2, %xmm\i
-
-	/* read the last <16B of AAD */
-_get_AAD_rest\num_initial_blocks\operation:
-	cmp	   $0, %r11
-	je	   _get_AAD_done\num_initial_blocks\operation
-
-	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, %xmm\i
-	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
-	pxor	   \XMM2, %xmm\i
-	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-
-_get_AAD_done\num_initial_blocks\operation:
-	xor	   %r11, %r11 # initialise the data pointer offset as zero
-	# start AES for num_initial_blocks blocks
-
-	mov	   %arg5, %rax                      # %rax = *Y0
-	movdqu	   (%rax), \XMM0                    # XMM0 = Y0
-	PSHUFB_XMM   %xmm14, \XMM0
-
-.if (\i == 5) || (\i == 6) || (\i == 7)
-	MOVADQ		ONE(%RIP),\TMP1
-	MOVADQ		(%arg1),\TMP2
-.irpc index, \i_seq
-	paddd	   \TMP1, \XMM0                 # INCR Y0
-	movdqa	   \XMM0, %xmm\index
-	PSHUFB_XMM   %xmm14, %xmm\index      # perform a 16 byte swap
-	pxor	   \TMP2, %xmm\index
-.endr
-	lea	0x10(%arg1),%r10
-	mov	keysize,%eax
-	shr	$2,%eax				# 128->4, 192->6, 256->8
-	add	$5,%eax			      # 128->9, 192->11, 256->13
-
-aes_loop_initial_dec\num_initial_blocks:
-	MOVADQ	(%r10),\TMP1
-.irpc	index, \i_seq
-	AESENC	\TMP1, %xmm\index
-.endr
-	add	$16,%r10
-	sub	$1,%eax
-	jnz	aes_loop_initial_dec\num_initial_blocks
-
-	MOVADQ	(%r10), \TMP1
-.irpc index, \i_seq
-	AESENCLAST \TMP1, %xmm\index         # Last Round
-.endr
-.irpc index, \i_seq
-	movdqu	   (%arg3 , %r11, 1), \TMP1
-	pxor	   \TMP1, %xmm\index
-	movdqu	   %xmm\index, (%arg2 , %r11, 1)
-	# write back plaintext/ciphertext for num_initial_blocks
-	add	   $16, %r11
-
-	movdqa     \TMP1, %xmm\index
-	PSHUFB_XMM	   %xmm14, %xmm\index
-                # prepare plaintext/ciphertext for GHASH computation
-.endr
-.endif
-
-        # apply GHASH on num_initial_blocks blocks
-
-.if \i == 5
-        pxor       %xmm5, %xmm6
-	GHASH_MUL  %xmm6, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-        pxor       %xmm6, %xmm7
-	GHASH_MUL  %xmm7, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-        pxor       %xmm7, %xmm8
-	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-.elseif \i == 6
-        pxor       %xmm6, %xmm7
-	GHASH_MUL  %xmm7, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-        pxor       %xmm7, %xmm8
-	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-.elseif \i == 7
-        pxor       %xmm7, %xmm8
-	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
-.endif
-	cmp	   $64, %r13
-	jl	_initial_blocks_done\num_initial_blocks\operation
-	# no need for precomputed values
-/*
-*
-* Precomputations for HashKey parallel with encryption of first 4 blocks.
-* Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
-*/
-	MOVADQ	   ONE(%rip), \TMP1
-	paddd	   \TMP1, \XMM0              # INCR Y0
-	MOVADQ	   \XMM0, \XMM1
-	PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap
-
-	paddd	   \TMP1, \XMM0              # INCR Y0
-	MOVADQ	   \XMM0, \XMM2
-	PSHUFB_XMM  %xmm14, \XMM2        # perform a 16 byte swap
-
-	paddd	   \TMP1, \XMM0              # INCR Y0
-	MOVADQ	   \XMM0, \XMM3
-	PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap
-
-	paddd	   \TMP1, \XMM0              # INCR Y0
-	MOVADQ	   \XMM0, \XMM4
-	PSHUFB_XMM %xmm14, \XMM4        # perform a 16 byte swap
-
-	MOVADQ	   0(%arg1),\TMP1
-	pxor	   \TMP1, \XMM1
-	pxor	   \TMP1, \XMM2
-	pxor	   \TMP1, \XMM3
-	pxor	   \TMP1, \XMM4
-	movdqa	   \TMP3, \TMP5
-	pshufd	   $78, \TMP3, \TMP1
-	pxor	   \TMP3, \TMP1
-	movdqa	   \TMP1, HashKey_k(%rsp)
-	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7
-# TMP5 = HashKey^2<<1 (mod poly)
-	movdqa	   \TMP5, HashKey_2(%rsp)
-# HashKey_2 = HashKey^2<<1 (mod poly)
-	pshufd	   $78, \TMP5, \TMP1
-	pxor	   \TMP5, \TMP1
-	movdqa	   \TMP1, HashKey_2_k(%rsp)
-.irpc index, 1234 # do 4 rounds
-	movaps 0x10*\index(%arg1), \TMP1
-	AESENC	   \TMP1, \XMM1
-	AESENC	   \TMP1, \XMM2
-	AESENC	   \TMP1, \XMM3
-	AESENC	   \TMP1, \XMM4
-.endr
-	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7
-# TMP5 = HashKey^3<<1 (mod poly)
-	movdqa	   \TMP5, HashKey_3(%rsp)
-	pshufd	   $78, \TMP5, \TMP1
-	pxor	   \TMP5, \TMP1
-	movdqa	   \TMP1, HashKey_3_k(%rsp)
-.irpc index, 56789 # do next 5 rounds
-	movaps 0x10*\index(%arg1), \TMP1
-	AESENC	   \TMP1, \XMM1
-	AESENC	   \TMP1, \XMM2
-	AESENC	   \TMP1, \XMM3
-	AESENC	   \TMP1, \XMM4
-.endr
-	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7
-# TMP5 = HashKey^3<<1 (mod poly)
-	movdqa	   \TMP5, HashKey_4(%rsp)
-	pshufd	   $78, \TMP5, \TMP1
-	pxor	   \TMP5, \TMP1
-	movdqa	   \TMP1, HashKey_4_k(%rsp)
-	lea	   0xa0(%arg1),%r10
-	mov	   keysize,%eax
-	shr	   $2,%eax			# 128->4, 192->6, 256->8
-	sub	   $4,%eax			# 128->0, 192->2, 256->4
-	jz	   aes_loop_pre_dec_done\num_initial_blocks
-
-aes_loop_pre_dec\num_initial_blocks:
-	MOVADQ	   (%r10),\TMP2
-.irpc	index, 1234
-	AESENC	   \TMP2, %xmm\index
-.endr
-	add	   $16,%r10
-	sub	   $1,%eax
-	jnz	   aes_loop_pre_dec\num_initial_blocks
-
-aes_loop_pre_dec_done\num_initial_blocks:
-	MOVADQ	   (%r10), \TMP2
-	AESENCLAST \TMP2, \XMM1
-	AESENCLAST \TMP2, \XMM2
-	AESENCLAST \TMP2, \XMM3
-	AESENCLAST \TMP2, \XMM4
-	movdqu	   16*0(%arg3 , %r11 , 1), \TMP1
-	pxor	   \TMP1, \XMM1
-	movdqu	   \XMM1, 16*0(%arg2 , %r11 , 1)
-	movdqa     \TMP1, \XMM1
-	movdqu	   16*1(%arg3 , %r11 , 1), \TMP1
-	pxor	   \TMP1, \XMM2
-	movdqu	   \XMM2, 16*1(%arg2 , %r11 , 1)
-	movdqa     \TMP1, \XMM2
-	movdqu	   16*2(%arg3 , %r11 , 1), \TMP1
-	pxor	   \TMP1, \XMM3
-	movdqu	   \XMM3, 16*2(%arg2 , %r11 , 1)
-	movdqa     \TMP1, \XMM3
-	movdqu	   16*3(%arg3 , %r11 , 1), \TMP1
-	pxor	   \TMP1, \XMM4
-	movdqu	   \XMM4, 16*3(%arg2 , %r11 , 1)
-	movdqa     \TMP1, \XMM4
-	add	   $64, %r11
-	PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
-	pxor	   \XMMDst, \XMM1
-# combine GHASHed value with the corresponding ciphertext
-	PSHUFB_XMM %xmm14, \XMM2 # perform a 16 byte swap
-	PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
-	PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap
-
-_initial_blocks_done\num_initial_blocks\operation:
-
-.endm
-
-
-/*
-* if a = number of total plaintext bytes
-* b = floor(a/16)
-* num_initial_blocks = b mod 4
-* encrypt the initial num_initial_blocks blocks and apply ghash on
-* the ciphertext
-* %r10, %r11, %r12, %rax, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9 registers
-* are clobbered
-* arg1, %arg2, %arg3, %r14 are used as a pointer only, not modified
-*/
-
-
-.macro INITIAL_BLOCKS_ENC num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
+.macro INITIAL_BLOCKS_ENC_DEC TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
 XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
         MOVADQ     SHUF_MASK(%rip), %xmm14
 	mov	   arg7, %r10           # %r10 = AAD
@@ -511,8 +284,8 @@ XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
 	pxor	   \XMM2, \XMM2
 
 	cmp	   $16, %r11
-	jl	   _get_AAD_rest\num_initial_blocks\operation
-_get_AAD_blocks\num_initial_blocks\operation:
+	jl	   _get_AAD_rest\@
+_get_AAD_blocks\@:
 	movdqu	   (%r10), %xmm\i
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
 	pxor	   %xmm\i, \XMM2
@@ -520,21 +293,21 @@ _get_AAD_blocks\num_initial_blocks\operation:
 	add	   $16, %r10
 	sub	   $16, %r11
 	cmp	   $16, %r11
-	jge	   _get_AAD_blocks\num_initial_blocks\operation
+	jge	   _get_AAD_blocks\@
 
 	movdqu	   \XMM2, %xmm\i
 
 	/* read the last <16B of AAD */
-_get_AAD_rest\num_initial_blocks\operation:
+_get_AAD_rest\@:
 	cmp	   $0, %r11
-	je	   _get_AAD_done\num_initial_blocks\operation
+	je	   _get_AAD_done\@
 
 	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, %xmm\i
 	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
 	pxor	   \XMM2, %xmm\i
 	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
 
-_get_AAD_done\num_initial_blocks\operation:
+_get_AAD_done\@:
 	xor	   %r11, %r11 # initialise the data pointer offset as zero
 	# start AES for num_initial_blocks blocks
 
@@ -548,7 +321,11 @@ _get_AAD_done\num_initial_blocks\operation:
 	MOVADQ		0(%arg1),\TMP2
 .irpc index, \i_seq
 	paddd		\TMP1, \XMM0                 # INCR Y0
+.ifc \operation, dec
+        movdqa     \XMM0, %xmm\index
+.else
 	MOVADQ		\XMM0, %xmm\index
+.endif
 	PSHUFB_XMM	%xmm14, %xmm\index      # perform a 16 byte swap
 	pxor		\TMP2, %xmm\index
 .endr
@@ -557,14 +334,14 @@ _get_AAD_done\num_initial_blocks\operation:
 	shr	$2,%eax				# 128->4, 192->6, 256->8
 	add	$5,%eax			      # 128->9, 192->11, 256->13
 
-aes_loop_initial_enc\num_initial_blocks:
+aes_loop_initial_\@:
 	MOVADQ	(%r10),\TMP1
 .irpc	index, \i_seq
 	AESENC	\TMP1, %xmm\index
 .endr
 	add	$16,%r10
 	sub	$1,%eax
-	jnz	aes_loop_initial_enc\num_initial_blocks
+	jnz	aes_loop_initial_\@
 
 	MOVADQ	(%r10), \TMP1
 .irpc index, \i_seq
@@ -576,6 +353,10 @@ aes_loop_initial_enc\num_initial_blocks:
 	movdqu	   %xmm\index, (%arg2 , %r11, 1)
 	# write back plaintext/ciphertext for num_initial_blocks
 	add	   $16, %r11
+
+.ifc \operation, dec
+	movdqa     \TMP1, %xmm\index
+.endif
 	PSHUFB_XMM	   %xmm14, %xmm\index
 
 		# prepare plaintext/ciphertext for GHASH computation
@@ -601,7 +382,7 @@ aes_loop_initial_enc\num_initial_blocks:
 	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
 .endif
 	cmp	   $64, %r13
-	jl	_initial_blocks_done\num_initial_blocks\operation
+	jl	_initial_blocks_done\@
 	# no need for precomputed values
 /*
 *
@@ -671,18 +452,18 @@ aes_loop_initial_enc\num_initial_blocks:
 	mov	   keysize,%eax
 	shr	   $2,%eax			# 128->4, 192->6, 256->8
 	sub	   $4,%eax			# 128->0, 192->2, 256->4
-	jz	   aes_loop_pre_enc_done\num_initial_blocks
+	jz	   aes_loop_pre_done\@
 
-aes_loop_pre_enc\num_initial_blocks:
+aes_loop_pre_\@:
 	MOVADQ	   (%r10),\TMP2
 .irpc	index, 1234
 	AESENC	   \TMP2, %xmm\index
 .endr
 	add	   $16,%r10
 	sub	   $1,%eax
-	jnz	   aes_loop_pre_enc\num_initial_blocks
+	jnz	   aes_loop_pre_\@
 
-aes_loop_pre_enc_done\num_initial_blocks:
+aes_loop_pre_done\@:
 	MOVADQ	   (%r10), \TMP2
 	AESENCLAST \TMP2, \XMM1
 	AESENCLAST \TMP2, \XMM2
@@ -690,16 +471,33 @@ aes_loop_pre_enc_done\num_initial_blocks:
 	AESENCLAST \TMP2, \XMM4
 	movdqu	   16*0(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM1
+.ifc \operation, dec
+	movdqu     \XMM1, 16*0(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM1
+.endif
 	movdqu	   16*1(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM2
+.ifc \operation, dec
+	movdqu     \XMM2, 16*1(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM2
+.endif
 	movdqu	   16*2(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM3
+.ifc \operation, dec
+	movdqu     \XMM3, 16*2(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM3
+.endif
 	movdqu	   16*3(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM4
+.ifc \operation, dec
+	movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM4
+.else
 	movdqu     \XMM1, 16*0(%arg2 , %r11 , 1)
 	movdqu     \XMM2, 16*1(%arg2 , %r11 , 1)
 	movdqu     \XMM3, 16*2(%arg2 , %r11 , 1)
 	movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
+.endif
 
 	add	   $64, %r11
 	PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
@@ -709,7 +507,7 @@ aes_loop_pre_enc_done\num_initial_blocks:
 	PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
 	PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap
 
-_initial_blocks_done\num_initial_blocks\operation:
+_initial_blocks_done\@:
 
 .endm
 
@@ -1378,22 +1176,22 @@ ENTRY(aesni_gcm_dec)
 	jb _initial_num_blocks_is_1_decrypt
 	je _initial_num_blocks_is_2_decrypt
 _initial_num_blocks_is_3_decrypt:
-	INITIAL_BLOCKS_DEC 3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, dec
 	sub	$48, %r13
 	jmp	_initial_blocks_decrypted
 _initial_num_blocks_is_2_decrypt:
-	INITIAL_BLOCKS_DEC	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, dec
 	sub	$32, %r13
 	jmp	_initial_blocks_decrypted
 _initial_num_blocks_is_1_decrypt:
-	INITIAL_BLOCKS_DEC	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, dec
 	sub	$16, %r13
 	jmp	_initial_blocks_decrypted
 _initial_num_blocks_is_0_decrypt:
-	INITIAL_BLOCKS_DEC	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, dec
 _initial_blocks_decrypted:
 	cmp	$0, %r13
@@ -1640,22 +1438,22 @@ ENTRY(aesni_gcm_enc)
 	jb	_initial_num_blocks_is_1_encrypt
 	je	_initial_num_blocks_is_2_encrypt
 _initial_num_blocks_is_3_encrypt:
-	INITIAL_BLOCKS_ENC	3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, enc
 	sub	$48, %r13
 	jmp	_initial_blocks_encrypted
 _initial_num_blocks_is_2_encrypt:
-	INITIAL_BLOCKS_ENC	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, enc
 	sub	$32, %r13
 	jmp	_initial_blocks_encrypted
 _initial_num_blocks_is_1_encrypt:
-	INITIAL_BLOCKS_ENC	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, enc
 	sub	$16, %r13
 	jmp	_initial_blocks_encrypted
 _initial_num_blocks_is_0_encrypt:
-	INITIAL_BLOCKS_ENC	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC_DEC	%xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, enc
 _initial_blocks_encrypted:
 
-- 
2.9.5
