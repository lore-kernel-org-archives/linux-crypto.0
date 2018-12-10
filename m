Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52098 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727330AbeLJT6m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:58:42 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 04/12] x86/crypto: aesni: support 256 byte keys in avx asm
Date: Mon, 10 Dec 2018 19:57:36 +0000
Message-ID: <01b7ee2e738b5014d58b60489d831235bcc5f424.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4BA9702F574DE948943F4B1F13FDA14B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for 192/256-bit keys using the avx gcm/aes routines.
The sse routines were previously updated in e31ac32d3b (Add support
for 192 & 256 bit keys to AESNI RFC4106).

Instead of adding an additional loop in the hotpath as in e31ac32d3b,
this diff instead generates separate versions of the code using macros,
and the entry routines choose which version once.   This results
in a 5% performance improvement vs. adding a loop to the hot path.
This is the same strategy chosen by the intel isa-l_crypto library.

The key size checks are removed from the c code where appropriate.

Note that this diff depends on using gcm_context_data - 256 bit keys
require 16 HashKeys + 15 expanded keys, which is larger than
struct crypto_aes_ctx, so they are stored in struct gcm_context_data.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 188 +++++++++++++++++------
 arch/x86/crypto/aesni-intel_glue.c       |  18 +--
 2 files changed, 145 insertions(+), 61 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index dd895f69399b..2aa11c503bb9 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -209,6 +209,7 @@ HashKey_8_k    =3D 16*21   # store XOR of HashKey^8 <<1=
 mod poly here (for Karatsu
 #define arg8 STACK_OFFSET+8*2(%r14)
 #define arg9 STACK_OFFSET+8*3(%r14)
 #define arg10 STACK_OFFSET+8*4(%r14)
+#define keysize 2*15*16(arg1)
=20
 i =3D 0
 j =3D 0
@@ -272,22 +273,22 @@ VARIABLE_OFFSET =3D 16*8
 .endm
=20
 # Encryption of a single block
-.macro ENCRYPT_SINGLE_BLOCK XMM0
+.macro ENCRYPT_SINGLE_BLOCK REP XMM0
                 vpxor    (arg1), \XMM0, \XMM0
-		i =3D 1
-		setreg
-.rep 9
+               i =3D 1
+               setreg
+.rep \REP
                 vaesenc  16*i(arg1), \XMM0, \XMM0
-		i =3D (i+1)
-		setreg
+               i =3D (i+1)
+               setreg
 .endr
-                vaesenclast 16*10(arg1), \XMM0, \XMM0
+                vaesenclast 16*i(arg1), \XMM0, \XMM0
 .endm
=20
 # combined for GCM encrypt and decrypt functions
 # clobbering all xmm registers
 # clobbering r10, r11, r12, r13, r14, r15
-.macro  GCM_ENC_DEC INITIAL_BLOCKS GHASH_8_ENCRYPT_8_PARALLEL GHASH_LAST_8=
 GHASH_MUL ENC_DEC
+.macro  GCM_ENC_DEC INITIAL_BLOCKS GHASH_8_ENCRYPT_8_PARALLEL GHASH_LAST_8=
 GHASH_MUL ENC_DEC REP
         vmovdqu  HashKey(arg2), %xmm13      # xmm13 =3D HashKey
=20
         mov     arg5, %r13                  # save the number of bytes of =
plaintext/ciphertext
@@ -314,42 +315,42 @@ VARIABLE_OFFSET =3D 16*8
         jmp     _initial_num_blocks_is_1\@
=20
 _initial_num_blocks_is_7\@:
-        \INITIAL_BLOCKS  7, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 7, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*7, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_6\@:
-        \INITIAL_BLOCKS  6, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 6, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*6, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_5\@:
-        \INITIAL_BLOCKS  5, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 5, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*5, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_4\@:
-        \INITIAL_BLOCKS  4, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 4, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*4, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_3\@:
-        \INITIAL_BLOCKS  3, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 3, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*3, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_2\@:
-        \INITIAL_BLOCKS  2, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 2, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*2, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_1\@:
-        \INITIAL_BLOCKS  1, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 1, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
         sub     $16*1, %r13
         jmp     _initial_blocks_encrypted\@
=20
 _initial_num_blocks_is_0\@:
-        \INITIAL_BLOCKS  0, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        \INITIAL_BLOCKS  \REP, 0, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, =
%xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm=
0, \ENC_DEC
=20
=20
 _initial_blocks_encrypted\@:
@@ -374,7 +375,7 @@ _encrypt_by_8_new\@:
=20
=20
         add     $8, %r15b
-        \GHASH_8_ENCRYPT_8_PARALLEL      %xmm0, %xmm10, %xmm11, %xmm12, %x=
mm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8=
, %xmm15, out_order, \ENC_DEC
+        \GHASH_8_ENCRYPT_8_PARALLEL      \REP, %xmm0, %xmm10, %xmm11, %xmm=
12, %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,=
 %xmm8, %xmm15, out_order, \ENC_DEC
         add     $128, %r11
         sub     $128, %r13
         jne     _encrypt_by_8_new\@
@@ -385,7 +386,7 @@ _encrypt_by_8_new\@:
 _encrypt_by_8\@:
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
         add     $8, %r15b
-        \GHASH_8_ENCRYPT_8_PARALLEL      %xmm0, %xmm10, %xmm11, %xmm12, %x=
mm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8=
, %xmm15, in_order, \ENC_DEC
+        \GHASH_8_ENCRYPT_8_PARALLEL      \REP, %xmm0, %xmm10, %xmm11, %xmm=
12, %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,=
 %xmm8, %xmm15, in_order, \ENC_DEC
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
         add     $128, %r11
         sub     $128, %r13
@@ -414,7 +415,7 @@ _zero_cipher_left\@:
=20
         vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
+        ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Yn)
=20
         sub     $16, %r11
         add     %r13, %r11
@@ -440,7 +441,7 @@ _only_less_than_16\@:
=20
         vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
+        ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Yn)
=20
=20
         lea     SHIFT_MASK+16(%rip), %r12
@@ -525,7 +526,7 @@ _multiple_of_16_bytes\@:
         mov     arg6, %rax                           # rax =3D *Y0
         vmovdqu (%rax), %xmm9                        # xmm9 =3D Y0
=20
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Y0)
+        ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Y0)
=20
         vpxor   %xmm14, %xmm9, %xmm9
=20
@@ -690,7 +691,7 @@ _return_T_done\@:
 ## r10, r11, r12, rax are clobbered
 ## arg1, arg3, arg4, r14 are used as a pointer only, not modified
=20
-.macro INITIAL_BLOCKS_AVX num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 XMM2 =
XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC
+.macro INITIAL_BLOCKS_AVX REP num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 X=
MM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC
 	i =3D (8-\num_initial_blocks)
 	j =3D 0
 	setreg
@@ -786,10 +787,10 @@ _get_AAD_done\@:
 	setreg
 .endr
=20
-	j =3D 1
-	setreg
-.rep 9
-	vmovdqa  16*j(arg1), \T_key
+       j =3D 1
+       setreg
+.rep \REP
+       vmovdqa  16*j(arg1), \T_key
 	i =3D (9-\num_initial_blocks)
 	setreg
 .rep \num_initial_blocks
@@ -798,12 +799,11 @@ _get_AAD_done\@:
 	setreg
 .endr
=20
-	j =3D (j+1)
-	setreg
+       j =3D (j+1)
+       setreg
 .endr
=20
-
-	vmovdqa  16*10(arg1), \T_key
+	vmovdqa  16*j(arg1), \T_key
 	i =3D (9-\num_initial_blocks)
 	setreg
 .rep \num_initial_blocks
@@ -891,9 +891,9 @@ _get_AAD_done\@:
                 vpxor    \T_key, \XMM7, \XMM7
                 vpxor    \T_key, \XMM8, \XMM8
=20
-		i =3D 1
-		setreg
-.rep    9       # do 9 rounds
+               i =3D 1
+               setreg
+.rep    \REP       # do REP rounds
                 vmovdqa  16*i(arg1), \T_key
                 vaesenc  \T_key, \XMM1, \XMM1
                 vaesenc  \T_key, \XMM2, \XMM2
@@ -903,11 +903,10 @@ _get_AAD_done\@:
                 vaesenc  \T_key, \XMM6, \XMM6
                 vaesenc  \T_key, \XMM7, \XMM7
                 vaesenc  \T_key, \XMM8, \XMM8
-		i =3D (i+1)
-		setreg
+               i =3D (i+1)
+               setreg
 .endr
=20
-
                 vmovdqa  16*i(arg1), \T_key
                 vaesenclast  \T_key, \XMM1, \XMM1
                 vaesenclast  \T_key, \XMM2, \XMM2
@@ -996,7 +995,7 @@ _initial_blocks_done\@:
 # ghash the 8 previously encrypted ciphertext blocks
 # arg1, arg3, arg4 are used as pointers only, not modified
 # r11 is the data offset value
-.macro GHASH_8_ENCRYPT_8_PARALLEL_AVX T1 T2 T3 T4 T5 T6 CTR XMM1 XMM2 XMM3=
 XMM4 XMM5 XMM6 XMM7 XMM8 T7 loop_idx ENC_DEC
+.macro GHASH_8_ENCRYPT_8_PARALLEL_AVX REP T1 T2 T3 T4 T5 T6 CTR XMM1 XMM2 =
XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T7 loop_idx ENC_DEC
=20
         vmovdqa \XMM1, \T2
         vmovdqa \XMM2, TMP2(%rsp)
@@ -1262,6 +1261,24 @@ _initial_blocks_done\@:
=20
                 vmovdqu 16*10(arg1), \T5
=20
+        i =3D 11
+        setreg
+.rep (\REP-9)
+
+        vaesenc \T5, \XMM1, \XMM1
+        vaesenc \T5, \XMM2, \XMM2
+        vaesenc \T5, \XMM3, \XMM3
+        vaesenc \T5, \XMM4, \XMM4
+        vaesenc \T5, \XMM5, \XMM5
+        vaesenc \T5, \XMM6, \XMM6
+        vaesenc \T5, \XMM7, \XMM7
+        vaesenc \T5, \XMM8, \XMM8
+
+        vmovdqu 16*i(arg1), \T5
+        i =3D i + 1
+        setreg
+.endr
+
 	i =3D 0
 	j =3D 1
 	setreg
@@ -1560,9 +1577,23 @@ ENDPROC(aesni_gcm_precomp_avx_gen2)
 ##########################################################################=
#####
 ENTRY(aesni_gcm_enc_avx_gen2)
         FUNC_SAVE
-        GCM_ENC_DEC INITIAL_BLOCKS_AVX GHASH_8_ENCRYPT_8_PARALLEL_AVX GHAS=
H_LAST_8_AVX GHASH_MUL_AVX ENC
+        mov     keysize, %eax
+        cmp     $32, %eax
+        je      key_256_enc
+        cmp     $16, %eax
+        je      key_128_enc
+        # must be 192
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GH=
ASH_LAST_8_AVX, GHASH_MUL_AVX, ENC, 11
         FUNC_RESTORE
-	ret
+        ret
+key_128_enc:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GH=
ASH_LAST_8_AVX, GHASH_MUL_AVX, ENC, 9
+        FUNC_RESTORE
+        ret
+key_256_enc:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GH=
ASH_LAST_8_AVX, GHASH_MUL_AVX, ENC, 13
+        FUNC_RESTORE
+        ret
 ENDPROC(aesni_gcm_enc_avx_gen2)
=20
 ##########################################################################=
#####
@@ -1584,9 +1615,23 @@ ENDPROC(aesni_gcm_enc_avx_gen2)
 ##########################################################################=
#####
 ENTRY(aesni_gcm_dec_avx_gen2)
         FUNC_SAVE
-        GCM_ENC_DEC INITIAL_BLOCKS_AVX GHASH_8_ENCRYPT_8_PARALLEL_AVX GHAS=
H_LAST_8_AVX GHASH_MUL_AVX DEC
+        mov     keysize,%eax
+        cmp     $32, %eax
+        je      key_256_dec
+        cmp     $16, %eax
+        je      key_128_dec
+        # must be 192
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GH=
ASH_LAST_8_AVX, GHASH_MUL_AVX, DEC, 11
         FUNC_RESTORE
-	ret
+        ret
+key_128_dec:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GH=
ASH_LAST_8_AVX, GHASH_MUL_AVX, DEC, 9
+        FUNC_RESTORE
+        ret
+key_256_dec:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GH=
ASH_LAST_8_AVX, GHASH_MUL_AVX, DEC, 13
+        FUNC_RESTORE
+        ret
 ENDPROC(aesni_gcm_dec_avx_gen2)
 #endif /* CONFIG_AS_AVX */
=20
@@ -1671,7 +1716,7 @@ ENDPROC(aesni_gcm_dec_avx_gen2)
 ## r10, r11, r12, rax are clobbered
 ## arg1, arg3, arg4, r14 are used as a pointer only, not modified
=20
-.macro INITIAL_BLOCKS_AVX2 num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 XMM2=
 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC VER
+.macro INITIAL_BLOCKS_AVX2 REP num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 =
XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC VER
 	i =3D (8-\num_initial_blocks)
 	j =3D 0
 	setreg
@@ -1770,7 +1815,7 @@ _get_AAD_done\@:
=20
 	j =3D 1
 	setreg
-.rep 9
+.rep \REP
 	vmovdqa  16*j(arg1), \T_key
 	i =3D (9-\num_initial_blocks)
 	setreg
@@ -1785,7 +1830,7 @@ _get_AAD_done\@:
 .endr
=20
=20
-	vmovdqa  16*10(arg1), \T_key
+	vmovdqa  16*j(arg1), \T_key
 	i =3D (9-\num_initial_blocks)
 	setreg
 .rep \num_initial_blocks
@@ -1876,7 +1921,7 @@ _get_AAD_done\@:
=20
 		i =3D 1
 		setreg
-.rep    9       # do 9 rounds
+.rep    \REP       # do REP rounds
                 vmovdqa  16*i(arg1), \T_key
                 vaesenc  \T_key, \XMM1, \XMM1
                 vaesenc  \T_key, \XMM2, \XMM2
@@ -1983,7 +2028,7 @@ _initial_blocks_done\@:
 # ghash the 8 previously encrypted ciphertext blocks
 # arg1, arg3, arg4 are used as pointers only, not modified
 # r11 is the data offset value
-.macro GHASH_8_ENCRYPT_8_PARALLEL_AVX2 T1 T2 T3 T4 T5 T6 CTR XMM1 XMM2 XMM=
3 XMM4 XMM5 XMM6 XMM7 XMM8 T7 loop_idx ENC_DEC
+.macro GHASH_8_ENCRYPT_8_PARALLEL_AVX2 REP T1 T2 T3 T4 T5 T6 CTR XMM1 XMM2=
 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T7 loop_idx ENC_DEC
=20
         vmovdqa \XMM1, \T2
         vmovdqa \XMM2, TMP2(%rsp)
@@ -2252,6 +2297,23 @@ _initial_blocks_done\@:
=20
                 vmovdqu 16*10(arg1), \T5
=20
+        i =3D 11
+        setreg
+.rep (\REP-9)
+        vaesenc \T5, \XMM1, \XMM1
+        vaesenc \T5, \XMM2, \XMM2
+        vaesenc \T5, \XMM3, \XMM3
+        vaesenc \T5, \XMM4, \XMM4
+        vaesenc \T5, \XMM5, \XMM5
+        vaesenc \T5, \XMM6, \XMM6
+        vaesenc \T5, \XMM7, \XMM7
+        vaesenc \T5, \XMM8, \XMM8
+
+        vmovdqu 16*i(arg1), \T5
+        i =3D i + 1
+        setreg
+.endr
+
 	i =3D 0
 	j =3D 1
 	setreg
@@ -2563,7 +2625,21 @@ ENDPROC(aesni_gcm_precomp_avx_gen4)
 ##########################################################################=
#####
 ENTRY(aesni_gcm_enc_avx_gen4)
         FUNC_SAVE
-        GCM_ENC_DEC INITIAL_BLOCKS_AVX2 GHASH_8_ENCRYPT_8_PARALLEL_AVX2 GH=
ASH_LAST_8_AVX2 GHASH_MUL_AVX2 ENC
+        mov     keysize,%eax
+        cmp     $32, %eax
+        je      key_256_enc4
+        cmp     $16, %eax
+        je      key_128_enc4
+        # must be 192
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, =
GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, ENC, 11
+        FUNC_RESTORE
+	ret
+key_128_enc4:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, =
GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, ENC, 9
+        FUNC_RESTORE
+	ret
+key_256_enc4:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, =
GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, ENC, 13
         FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_enc_avx_gen4)
@@ -2587,9 +2663,23 @@ ENDPROC(aesni_gcm_enc_avx_gen4)
 ##########################################################################=
#####
 ENTRY(aesni_gcm_dec_avx_gen4)
         FUNC_SAVE
-        GCM_ENC_DEC INITIAL_BLOCKS_AVX2 GHASH_8_ENCRYPT_8_PARALLEL_AVX2 GH=
ASH_LAST_8_AVX2 GHASH_MUL_AVX2 DEC
+        mov     keysize,%eax
+        cmp     $32, %eax
+        je      key_256_dec4
+        cmp     $16, %eax
+        je      key_128_dec4
+        # must be 192
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, =
GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, DEC, 11
         FUNC_RESTORE
-	ret
+        ret
+key_128_dec4:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, =
GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, DEC, 9
+        FUNC_RESTORE
+        ret
+key_256_dec4:
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, =
GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, DEC, 13
+        FUNC_RESTORE
+        ret
 ENDPROC(aesni_gcm_dec_avx_gen4)
=20
 #endif /* CONFIG_AS_AVX2 */
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-int=
el_glue.c
index d8b8cb33f608..7d1259feb0f9 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -209,8 +209,7 @@ static void aesni_gcm_enc_avx(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-        struct crypto_aes_ctx *aes_ctx =3D (struct crypto_aes_ctx*)ctx;
-	if ((plaintext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length !=3D AES_=
KEYSIZE_128)){
+	if (plaintext_len < AVX_GEN2_OPTSIZE) {
 		aesni_gcm_enc(ctx, data, out, in,
 			plaintext_len, iv, hash_subkey, aad,
 			aad_len, auth_tag, auth_tag_len);
@@ -227,8 +226,7 @@ static void aesni_gcm_dec_avx(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-        struct crypto_aes_ctx *aes_ctx =3D (struct crypto_aes_ctx*)ctx;
-	if ((ciphertext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length !=3D AES=
_KEYSIZE_128)) {
+	if (ciphertext_len < AVX_GEN2_OPTSIZE) {
 		aesni_gcm_dec(ctx, data, out, in,
 			ciphertext_len, iv, hash_subkey, aad,
 			aad_len, auth_tag, auth_tag_len);
@@ -268,8 +266,7 @@ static void aesni_gcm_enc_avx2(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-       struct crypto_aes_ctx *aes_ctx =3D (struct crypto_aes_ctx*)ctx;
-	if ((plaintext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length !=3D AES_=
KEYSIZE_128)) {
+	if (plaintext_len < AVX_GEN2_OPTSIZE) {
 		aesni_gcm_enc(ctx, data, out, in,
 			      plaintext_len, iv, hash_subkey, aad,
 			      aad_len, auth_tag, auth_tag_len);
@@ -290,8 +287,7 @@ static void aesni_gcm_dec_avx2(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
-       struct crypto_aes_ctx *aes_ctx =3D (struct crypto_aes_ctx*)ctx;
-	if ((ciphertext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length !=3D AES=
_KEYSIZE_128)) {
+	if (ciphertext_len < AVX_GEN2_OPTSIZE) {
 		aesni_gcm_dec(ctx, data, out, in,
 			      ciphertext_len, iv, hash_subkey,
 			      aad, aad_len, auth_tag, auth_tag_len);
@@ -928,8 +924,7 @@ static int gcmaes_encrypt(struct aead_request *req, uns=
igned int assoclen,
 	struct scatter_walk dst_sg_walk =3D {};
 	struct gcm_context_data data AESNI_ALIGN_ATTR;
=20
-	if (((struct crypto_aes_ctx *)aes_ctx)->key_length !=3D AES_KEYSIZE_128 |=
|
-		aesni_gcm_enc_tfm =3D=3D aesni_gcm_enc ||
+	if (aesni_gcm_enc_tfm =3D=3D aesni_gcm_enc ||
 		req->cryptlen < AVX_GEN2_OPTSIZE) {
 		return gcmaes_crypt_by_sg(true, req, assoclen, hash_subkey, iv,
 					  aes_ctx);
@@ -1000,8 +995,7 @@ static int gcmaes_decrypt(struct aead_request *req, un=
signed int assoclen,
 	struct gcm_context_data data AESNI_ALIGN_ATTR;
 	int retval =3D 0;
=20
-	if (((struct crypto_aes_ctx *)aes_ctx)->key_length !=3D AES_KEYSIZE_128 |=
|
-		aesni_gcm_enc_tfm =3D=3D aesni_gcm_enc ||
+	if (aesni_gcm_enc_tfm =3D=3D aesni_gcm_enc ||
 		req->cryptlen < AVX_GEN2_OPTSIZE) {
 		return gcmaes_crypt_by_sg(false, req, assoclen, hash_subkey, iv,
 					  aes_ctx);
--=20
2.17.1
