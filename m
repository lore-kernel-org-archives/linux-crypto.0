Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52584 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727596AbeLJUAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 15:00:06 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 11/12] x86/crypto: aesni: Introduce partial block macro
Date: Mon, 10 Dec 2018 19:59:38 +0000
Message-ID: <67137103e3a6b4ac0f20fe94eef0575536b11af8.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE772F2144BDCA44A208FC5231E0D859@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Before this diff, multiple calls to GCM_ENC_DEC will
succeed, but only if all calls are a multiple of 16 bytes.

Handle partial blocks at the start of GCM_ENC_DEC, and update
aadhash as appropriate.

The data offset %r11 is also updated after the partial block.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 156 ++++++++++++++++++++++-
 1 file changed, 150 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index ff00ad19064d..af45fc57db90 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -301,6 +301,12 @@ VARIABLE_OFFSET =3D 16*8
         vmovdqu  HashKey(arg2), %xmm13      # xmm13 =3D HashKey
         add arg5, InLen(arg2)
=20
+        # initialize the data pointer offset as zero
+        xor     %r11d, %r11d
+
+        PARTIAL_BLOCK \GHASH_MUL, arg3, arg4, arg5, %r11, %xmm8, \ENC_DEC
+        sub %r11, arg5
+
         mov     arg5, %r13                  # save the number of bytes of =
plaintext/ciphertext
         and     $-16, %r13                  # r13 =3D r13 - (r13 mod 16)
=20
@@ -737,6 +743,150 @@ _read_next_byte_lt8_\@:
 _done_read_partial_block_\@:
 .endm
=20
+# PARTIAL_BLOCK: Handles encryption/decryption and the tag partial blocks
+# between update calls.
+# Requires the input data be at least 1 byte long due to READ_PARTIAL_BLOC=
K
+# Outputs encrypted bytes, and updates hash and partial info in gcm_data_c=
ontext
+# Clobbers rax, r10, r12, r13, xmm0-6, xmm9-13
+.macro PARTIAL_BLOCK GHASH_MUL CYPH_PLAIN_OUT PLAIN_CYPH_IN PLAIN_CYPH_LEN=
 DATA_OFFSET \
+        AAD_HASH ENC_DEC
+        mov 	PBlockLen(arg2), %r13
+        cmp	$0, %r13
+        je	_partial_block_done_\@	# Leave Macro if no partial blocks
+        # Read in input data without over reading
+        cmp	$16, \PLAIN_CYPH_LEN
+        jl	_fewer_than_16_bytes_\@
+        vmovdqu	(\PLAIN_CYPH_IN), %xmm1	# If more than 16 bytes, just fill=
 xmm
+        jmp	_data_read_\@
+
+_fewer_than_16_bytes_\@:
+        lea	(\PLAIN_CYPH_IN, \DATA_OFFSET, 1), %r10
+        mov	\PLAIN_CYPH_LEN, %r12
+        READ_PARTIAL_BLOCK %r10 %r12 %xmm1
+
+        mov PBlockLen(arg2), %r13
+
+_data_read_\@:				# Finished reading in data
+
+        vmovdqu	PBlockEncKey(arg2), %xmm9
+        vmovdqu	HashKey(arg2), %xmm13
+
+        lea	SHIFT_MASK(%rip), %r12
+
+        # adjust the shuffle mask pointer to be able to shift r13 bytes
+        # r16-r13 is the number of bytes in plaintext mod 16)
+        add	%r13, %r12
+        vmovdqu	(%r12), %xmm2		# get the appropriate shuffle mask
+        vpshufb %xmm2, %xmm9, %xmm9		# shift right r13 bytes
+
+.if  \ENC_DEC =3D=3D  DEC
+        vmovdqa	%xmm1, %xmm3
+        pxor	%xmm1, %xmm9		# Cyphertext XOR E(K, Yn)
+
+        mov	\PLAIN_CYPH_LEN, %r10
+        add	%r13, %r10
+        # Set r10 to be the amount of data left in CYPH_PLAIN_IN after fil=
ling
+        sub	$16, %r10
+        # Determine if if partial block is not being filled and
+        # shift mask accordingly
+        jge	_no_extra_mask_1_\@
+        sub	%r10, %r12
+_no_extra_mask_1_\@:
+
+        vmovdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
+        # get the appropriate mask to mask out bottom r13 bytes of xmm9
+        vpand	%xmm1, %xmm9, %xmm9		# mask out bottom r13 bytes of xmm9
+
+        vpand	%xmm1, %xmm3, %xmm3
+        vmovdqa	SHUF_MASK(%rip), %xmm10
+        vpshufb	%xmm10, %xmm3, %xmm3
+        vpshufb	%xmm2, %xmm3, %xmm3
+        vpxor	%xmm3, \AAD_HASH, \AAD_HASH
+
+        cmp	$0, %r10
+        jl	_partial_incomplete_1_\@
+
+        # GHASH computation for the last <16 Byte block
+        \GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
+        xor	%eax,%eax
+
+        mov	%rax, PBlockLen(arg2)
+        jmp	_dec_done_\@
+_partial_incomplete_1_\@:
+        add	\PLAIN_CYPH_LEN, PBlockLen(arg2)
+_dec_done_\@:
+        vmovdqu	\AAD_HASH, AadHash(arg2)
+.else
+        vpxor	%xmm1, %xmm9, %xmm9			# Plaintext XOR E(K, Yn)
+
+        mov	\PLAIN_CYPH_LEN, %r10
+        add	%r13, %r10
+        # Set r10 to be the amount of data left in CYPH_PLAIN_IN after fil=
ling
+        sub	$16, %r10
+        # Determine if if partial block is not being filled and
+        # shift mask accordingly
+        jge	_no_extra_mask_2_\@
+        sub	%r10, %r12
+_no_extra_mask_2_\@:
+
+        vmovdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
+        # get the appropriate mask to mask out bottom r13 bytes of xmm9
+        vpand	%xmm1, %xmm9, %xmm9
+
+        vmovdqa	SHUF_MASK(%rip), %xmm1
+        vpshufb %xmm1, %xmm9, %xmm9
+        vpshufb %xmm2, %xmm9, %xmm9
+        vpxor	%xmm9, \AAD_HASH, \AAD_HASH
+
+        cmp	$0, %r10
+        jl	_partial_incomplete_2_\@
+
+        # GHASH computation for the last <16 Byte block
+        \GHASH_MUL \AAD_HASH, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xmm6
+        xor	%eax,%eax
+
+        mov	%rax, PBlockLen(arg2)
+        jmp	_encode_done_\@
+_partial_incomplete_2_\@:
+        add	\PLAIN_CYPH_LEN, PBlockLen(arg2)
+_encode_done_\@:
+        vmovdqu	\AAD_HASH, AadHash(arg2)
+
+        vmovdqa	SHUF_MASK(%rip), %xmm10
+        # shuffle xmm9 back to output as ciphertext
+        vpshufb	%xmm10, %xmm9, %xmm9
+        vpshufb	%xmm2, %xmm9, %xmm9
+.endif
+        # output encrypted Bytes
+        cmp	$0, %r10
+        jl	_partial_fill_\@
+        mov	%r13, %r12
+        mov	$16, %r13
+        # Set r13 to be the number of bytes to write out
+        sub	%r12, %r13
+        jmp	_count_set_\@
+_partial_fill_\@:
+        mov	\PLAIN_CYPH_LEN, %r13
+_count_set_\@:
+        vmovdqa	%xmm9, %xmm0
+        vmovq	%xmm0, %rax
+        cmp	$8, %r13
+        jle	_less_than_8_bytes_left_\@
+
+        mov	%rax, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
+        add	$8, \DATA_OFFSET
+        psrldq	$8, %xmm0
+        vmovq	%xmm0, %rax
+        sub	$8, %r13
+_less_than_8_bytes_left_\@:
+        movb	%al, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
+        add	$1, \DATA_OFFSET
+        shr	$8, %rax
+        sub	$1, %r13
+        jne	_less_than_8_bytes_left_\@
+_partial_block_done_\@:
+.endm # PARTIAL_BLOCK
+
 #ifdef CONFIG_AS_AVX
 ##########################################################################=
#####
 # GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
@@ -856,9 +1006,6 @@ _done_read_partial_block_\@:
 	setreg
         vmovdqu AadHash(arg2), reg_i
=20
-	# initialize the data pointer offset as zero
-	xor     %r11d, %r11d
-
 	# start AES for num_initial_blocks blocks
 	vmovdqu CurCount(arg2), \CTR
=20
@@ -1798,9 +1945,6 @@ ENDPROC(aesni_gcm_dec_avx_gen2)
 	setreg
 	vmovdqu AadHash(arg2), reg_i
=20
-	# initialize the data pointer offset as zero
-	xor     %r11d, %r11d
-
 	# start AES for num_initial_blocks blocks
 	vmovdqu CurCount(arg2), \CTR
=20
--=20
2.17.1
