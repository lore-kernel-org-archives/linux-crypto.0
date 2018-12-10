Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54974 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbeLJT7b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:59:31 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 08/12] x86/crypto: aesni: Fill in new context data structures
Date: Mon, 10 Dec 2018 19:58:56 +0000
Message-ID: <8104eaf3639f9c70ced8d4867e572d6a1182afd2.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D83259952139E418754B441A59A0A77@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fill in aadhash, aadlen, pblocklen, curcount with appropriate values.
pblocklen, aadhash, and pblockenckey are also updated at the end
of each scatter/gather operation, to be carried over to the next
operation.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 51 +++++++++++++++++-------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index e347ba61db65..0a9cdcfdd987 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -297,7 +297,9 @@ VARIABLE_OFFSET =3D 16*8
 # clobbering all xmm registers
 # clobbering r10, r11, r12, r13, r14, r15
 .macro  GCM_ENC_DEC INITIAL_BLOCKS GHASH_8_ENCRYPT_8_PARALLEL GHASH_LAST_8=
 GHASH_MUL ENC_DEC REP
+        vmovdqu AadHash(arg2), %xmm8
         vmovdqu  HashKey(arg2), %xmm13      # xmm13 =3D HashKey
+        add arg5, InLen(arg2)
=20
         mov     arg5, %r13                  # save the number of bytes of =
plaintext/ciphertext
         and     $-16, %r13                  # r13 =3D r13 - (r13 mod 16)
@@ -410,6 +412,9 @@ _eight_cipher_left\@:
=20
=20
 _zero_cipher_left\@:
+        vmovdqu %xmm14, AadHash(arg2)
+        vmovdqu %xmm9, CurCount(arg2)
+
         cmp     $16, arg5
         jl      _only_less_than_16\@
=20
@@ -420,10 +425,14 @@ _zero_cipher_left\@:
=20
         # handle the last <16 Byte block seperately
=20
+        mov %r13, PBlockLen(arg2)
=20
         vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
+        vmovdqu %xmm9, CurCount(arg2)
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+
         ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Yn)
+        vmovdqu %xmm9, PBlockEncKey(arg2)
=20
         sub     $16, %r11
         add     %r13, %r11
@@ -451,6 +460,7 @@ _only_less_than_16\@:
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
         ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Yn)
=20
+        vmovdqu %xmm9, PBlockEncKey(arg2)
=20
         lea     SHIFT_MASK+16(%rip), %r12
         sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
@@ -480,6 +490,7 @@ _final_ghash_mul\@:
         vpxor   %xmm2, %xmm14, %xmm14
 	#GHASH computation for the last <16 Byte block
         \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+        vmovdqu %xmm14, AadHash(arg2)
         sub     %r13, %r11
         add     $16, %r11
         .else
@@ -491,6 +502,7 @@ _final_ghash_mul\@:
         vpxor   %xmm9, %xmm14, %xmm14
 	#GHASH computation for the last <16 Byte block
         \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+        vmovdqu %xmm14, AadHash(arg2)
         sub     %r13, %r11
         add     $16, %r11
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9        # shuffle xmm9 back t=
o output as ciphertext
@@ -526,12 +538,16 @@ _multiple_of_16_bytes\@:
 # Output: Authorization Tag (AUTH_TAG)
 # Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
 .macro GCM_COMPLETE GHASH_MUL REP
-        mov     arg8, %r12                           # r12 =3D aadLen (num=
ber of bytes)
+        vmovdqu AadHash(arg2), %xmm14
+        vmovdqu HashKey(arg2), %xmm13
+
+        mov AadLen(arg2), %r12                          # r12 =3D aadLen (=
number of bytes)
         shl     $3, %r12                             # convert into number=
 of bits
         vmovd   %r12d, %xmm15                        # len(A) in xmm15
=20
-        shl     $3, arg5                             # len(C) in bits  (*1=
28)
-        vmovq   arg5, %xmm1
+        mov InLen(arg2), %r12
+        shl     $3, %r12                        # len(C) in bits  (*128)
+        vmovq   %r12, %xmm1
         vpslldq $8, %xmm15, %xmm15                   # xmm15 =3D len(A)|| =
0x0000000000000000
         vpxor   %xmm1, %xmm15, %xmm15                # xmm15 =3D len(A)||l=
en(C)
=20
@@ -539,8 +555,7 @@ _multiple_of_16_bytes\@:
         \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6    # final GHASH computation
         vpshufb SHUF_MASK(%rip), %xmm14, %xmm14      # perform a 16Byte sw=
ap
=20
-        mov     arg6, %rax                           # rax =3D *Y0
-        vmovdqu (%rax), %xmm9                        # xmm9 =3D Y0
+        vmovdqu OrigIV(arg2), %xmm9
=20
         ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Y0)
=20
@@ -662,6 +677,20 @@ _get_AAD_done\@:
 .endm
=20
 .macro INIT GHASH_MUL PRECOMPUTE
+        mov arg6, %r11
+        mov %r11, AadLen(arg2) # ctx_data.aad_length =3D aad_length
+        xor %r11d, %r11d
+        mov %r11, InLen(arg2) # ctx_data.in_length =3D 0
+
+        mov %r11, PBlockLen(arg2) # ctx_data.partial_block_length =3D 0
+        mov %r11, PBlockEncKey(arg2) # ctx_data.partial_block_enc_key =3D =
0
+        mov arg4, %rax
+        movdqu (%rax), %xmm0
+        movdqu %xmm0, OrigIV(arg2) # ctx_data.orig_IV =3D iv
+
+        vpshufb SHUF_MASK(%rip), %xmm0, %xmm0
+        movdqu %xmm0, CurCount(arg2) # ctx_data.current_counter =3D iv
+
         vmovdqu  (arg3), %xmm6              # xmm6 =3D HashKey
=20
         vpshufb  SHUF_MASK(%rip), %xmm6, %xmm6
@@ -809,10 +838,7 @@ _get_AAD_done\@:
 	xor     %r11d, %r11d
=20
 	# start AES for num_initial_blocks blocks
-	mov     arg6, %rax                     # rax =3D *Y0
-	vmovdqu (%rax), \CTR                   # CTR =3D Y0
-	vpshufb SHUF_MASK(%rip), \CTR, \CTR
-
+	vmovdqu CurCount(arg2), \CTR
=20
 	i =3D (9-\num_initial_blocks)
 	setreg
@@ -1748,16 +1774,13 @@ ENDPROC(aesni_gcm_dec_avx_gen2)
 .macro INITIAL_BLOCKS_AVX2 REP num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 =
XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC VER
 	i =3D (8-\num_initial_blocks)
 	setreg
-        vmovdqu AadHash(arg2), reg_i
+	vmovdqu AadHash(arg2), reg_i
=20
 	# initialize the data pointer offset as zero
 	xor     %r11d, %r11d
=20
 	# start AES for num_initial_blocks blocks
-	mov     arg6, %rax                     # rax =3D *Y0
-	vmovdqu (%rax), \CTR                   # CTR =3D Y0
-	vpshufb SHUF_MASK(%rip), \CTR, \CTR
-
+	vmovdqu CurCount(arg2), \CTR
=20
 	i =3D (9-\num_initial_blocks)
 	setreg
--=20
2.17.1
