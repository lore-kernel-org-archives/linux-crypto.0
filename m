From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 11/14] x86/crypto: aesni: Introduce partial block macro
Date: Wed, 14 Feb 2018 09:40:19 -0800
Message-ID: <20180214174019.GA62159@davejwatson-mba>
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

Before this diff, multiple calls to GCM_ENC_DEC will
succeed, but only if all calls are a multiple of 16 bytes.

Handle partial blocks at the start of GCM_ENC_DEC, and update
aadhash as appropriate.

The data offset %r11 is also updated after the partial block.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 151 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 150 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 3ada06b..398bd2237f 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -284,7 +284,13 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	movdqu AadHash(%arg2), %xmm8
 	movdqu HashKey(%arg2), %xmm13
 	add %arg5, InLen(%arg2)
+
+	xor %r11, %r11 # initialise the data pointer offset as zero
+	PARTIAL_BLOCK %arg3 %arg4 %arg5 %r11 %xmm8 \operation
+
+	sub %r11, %arg5		# sub partial block data used
 	mov %arg5, %r13		# save the number of bytes
+
 	and $-16, %r13		# %r13 = %r13 - (%r13 mod 16)
 	mov %r13, %r12
 	# Encrypt/Decrypt first few blocks
@@ -605,6 +611,150 @@ _get_AAD_done\@:
 	movdqu \TMP6, AadHash(%arg2)
 .endm
 
+# PARTIAL_BLOCK: Handles encryption/decryption and the tag partial blocks
+# between update calls.
+# Requires the input data be at least 1 byte long due to READ_PARTIAL_BLOCK
+# Outputs encrypted bytes, and updates hash and partial info in gcm_data_context
+# Clobbers rax, r10, r12, r13, xmm0-6, xmm9-13
+.macro PARTIAL_BLOCK CYPH_PLAIN_OUT PLAIN_CYPH_IN PLAIN_CYPH_LEN DATA_OFFSET \
+	AAD_HASH operation
+	mov 	PBlockLen(%arg2), %r13
+	cmp	$0, %r13
+	je	_partial_block_done_\@	# Leave Macro if no partial blocks
+	# Read in input data without over reading
+	cmp	$16, \PLAIN_CYPH_LEN
+	jl	_fewer_than_16_bytes_\@
+	movups	(\PLAIN_CYPH_IN), %xmm1	# If more than 16 bytes, just fill xmm
+	jmp	_data_read_\@
+
+_fewer_than_16_bytes_\@:
+	lea	(\PLAIN_CYPH_IN, \DATA_OFFSET, 1), %r10
+	mov	\PLAIN_CYPH_LEN, %r12
+	READ_PARTIAL_BLOCK %r10 %r12 %xmm0 %xmm1
+
+	mov PBlockLen(%arg2), %r13
+
+_data_read_\@:				# Finished reading in data
+
+	movdqu	PBlockEncKey(%arg2), %xmm9
+	movdqu	HashKey(%arg2), %xmm13
+
+	lea	SHIFT_MASK(%rip), %r12
+
+	# adjust the shuffle mask pointer to be able to shift r13 bytes
+	# r16-r13 is the number of bytes in plaintext mod 16)
+	add	%r13, %r12
+	movdqu	(%r12), %xmm2		# get the appropriate shuffle mask
+	PSHUFB_XMM %xmm2, %xmm9		# shift right r13 bytes
+
+.ifc \operation, dec
+	movdqa	%xmm1, %xmm3
+	pxor	%xmm1, %xmm9		# Cyphertext XOR E(K, Yn)
+
+	mov	\PLAIN_CYPH_LEN, %r10
+	add	%r13, %r10
+	# Set r10 to be the amount of data left in CYPH_PLAIN_IN after filling
+	sub	$16, %r10
+	# Determine if if partial block is not being filled and
+	# shift mask accordingly
+	jge	_no_extra_mask_1_\@
+	sub	%r10, %r12
+_no_extra_mask_1_\@:
+
+	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
+	# get the appropriate mask to mask out bottom r13 bytes of xmm9
+	pand	%xmm1, %xmm9		# mask out bottom r13 bytes of xmm9
+
+	pand	%xmm1, %xmm3
+	movdqa	SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM	%xmm10, %xmm3
+	PSHUFB_XMM	%xmm2, %xmm3
+	pxor	%xmm3, \AAD_HASH
+
+	cmp	$0, %r10
+	jl	_partial_incomplete_1_\@
+
+	# GHASH computation for the last <16 Byte block
+	GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
+	xor	%rax,%rax
+
+	mov	%rax, PBlockLen(%arg2)
+	jmp	_dec_done_\@
+_partial_incomplete_1_\@:
+	add	\PLAIN_CYPH_LEN, PBlockLen(%arg2)
+_dec_done_\@:
+	movdqu	\AAD_HASH, AadHash(%arg2)
+.else
+	pxor	%xmm1, %xmm9			# Plaintext XOR E(K, Yn)
+
+	mov	\PLAIN_CYPH_LEN, %r10
+	add	%r13, %r10
+	# Set r10 to be the amount of data left in CYPH_PLAIN_IN after filling
+	sub	$16, %r10
+	# Determine if if partial block is not being filled and
+	# shift mask accordingly
+	jge	_no_extra_mask_2_\@
+	sub	%r10, %r12
+_no_extra_mask_2_\@:
+
+	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
+	# get the appropriate mask to mask out bottom r13 bytes of xmm9
+	pand	%xmm1, %xmm9
+
+	movdqa	SHUF_MASK(%rip), %xmm1
+	PSHUFB_XMM %xmm1, %xmm9
+	PSHUFB_XMM %xmm2, %xmm9
+	pxor	%xmm9, \AAD_HASH
+
+	cmp	$0, %r10
+	jl	_partial_incomplete_2_\@
+
+	# GHASH computation for the last <16 Byte block
+	GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
+	xor	%rax,%rax
+
+	mov	%rax, PBlockLen(%arg2)
+	jmp	_encode_done_\@
+_partial_incomplete_2_\@:
+	add	\PLAIN_CYPH_LEN, PBlockLen(%arg2)
+_encode_done_\@:
+	movdqu	\AAD_HASH, AadHash(%arg2)
+
+	movdqa	SHUF_MASK(%rip), %xmm10
+	# shuffle xmm9 back to output as ciphertext
+	PSHUFB_XMM	%xmm10, %xmm9
+	PSHUFB_XMM	%xmm2, %xmm9
+.endif
+	# output encrypted Bytes
+	cmp	$0, %r10
+	jl	_partial_fill_\@
+	mov	%r13, %r12
+	mov	$16, %r13
+	# Set r13 to be the number of bytes to write out
+	sub	%r12, %r13
+	jmp	_count_set_\@
+_partial_fill_\@:
+	mov	\PLAIN_CYPH_LEN, %r13
+_count_set_\@:
+	movdqa	%xmm9, %xmm0
+	MOVQ_R64_XMM	%xmm0, %rax
+	cmp	$8, %r13
+	jle	_less_than_8_bytes_left_\@
+
+	mov	%rax, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
+	add	$8, \DATA_OFFSET
+	psrldq	$8, %xmm0
+	MOVQ_R64_XMM	%xmm0, %rax
+	sub	$8, %r13
+_less_than_8_bytes_left_\@:
+	movb	%al, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
+	add	$1, \DATA_OFFSET
+	shr	$8, %rax
+	sub	$1, %r13
+	jne	_less_than_8_bytes_left_\@
+_partial_block_done_\@:
+.endm # PARTIAL_BLOCK
+
 /*
 * if a = number of total plaintext bytes
 * b = floor(a/16)
@@ -623,7 +773,6 @@ _get_AAD_done\@:
 
 	movdqu AadHash(%arg2), %xmm\i		    # XMM0 = Y0
 
-	xor	   %r11, %r11 # initialise the data pointer offset as zero
 	# start AES for num_initial_blocks blocks
 
 	movdqu CurCount(%arg2), \XMM0                # XMM0 = Y0
-- 
2.9.5
