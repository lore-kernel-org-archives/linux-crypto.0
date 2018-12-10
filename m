Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727515AbeLJT5I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:57:08 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 01/12] x86/crypto: aesni: Merge GCM_ENC_DEC
Date: Mon, 10 Dec 2018 19:56:45 +0000
Message-ID: <17695fd0e5b88220bf69e130497d88a7ef799ba6.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B4C8641B0C51A441A01D972A58CEECBC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The GCM_ENC_DEC routines for AVX and AVX2 are identical, except they
call separate sub-macros.  Pass the macros as arguments, and merge them.
This facilitates additional refactoring, by requiring changes in only
one place.

The GCM_ENC_DEC macro was moved above the CONFIG_AS_AVX* ifdefs,
since it will be used by both AVX and AVX2.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 951 ++++++++---------------
 1 file changed, 318 insertions(+), 633 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 1985ea0b551b..318135a77975 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -280,6 +280,320 @@ VARIABLE_OFFSET =3D 16*8
                 vaesenclast 16*10(arg1), \XMM0, \XMM0
 .endm
=20
+# combined for GCM encrypt and decrypt functions
+# clobbering all xmm registers
+# clobbering r10, r11, r12, r13, r14, r15
+.macro  GCM_ENC_DEC INITIAL_BLOCKS GHASH_8_ENCRYPT_8_PARALLEL GHASH_LAST_8=
 GHASH_MUL ENC_DEC
+
+        #the number of pushes must equal STACK_OFFSET
+        push    %r12
+        push    %r13
+        push    %r14
+        push    %r15
+
+        mov     %rsp, %r14
+
+
+
+
+        sub     $VARIABLE_OFFSET, %rsp
+        and     $~63, %rsp                  # align rsp to 64 bytes
+
+
+        vmovdqu  HashKey(arg1), %xmm13      # xmm13 =3D HashKey
+
+        mov     arg4, %r13                  # save the number of bytes of =
plaintext/ciphertext
+        and     $-16, %r13                  # r13 =3D r13 - (r13 mod 16)
+
+        mov     %r13, %r12
+        shr     $4, %r12
+        and     $7, %r12
+        jz      _initial_num_blocks_is_0\@
+
+        cmp     $7, %r12
+        je      _initial_num_blocks_is_7\@
+        cmp     $6, %r12
+        je      _initial_num_blocks_is_6\@
+        cmp     $5, %r12
+        je      _initial_num_blocks_is_5\@
+        cmp     $4, %r12
+        je      _initial_num_blocks_is_4\@
+        cmp     $3, %r12
+        je      _initial_num_blocks_is_3\@
+        cmp     $2, %r12
+        je      _initial_num_blocks_is_2\@
+
+        jmp     _initial_num_blocks_is_1\@
+
+_initial_num_blocks_is_7\@:
+        \INITIAL_BLOCKS  7, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*7, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_6\@:
+        \INITIAL_BLOCKS  6, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*6, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_5\@:
+        \INITIAL_BLOCKS  5, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*5, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_4\@:
+        \INITIAL_BLOCKS  4, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*4, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_3\@:
+        \INITIAL_BLOCKS  3, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*3, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_2\@:
+        \INITIAL_BLOCKS  2, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*2, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_1\@:
+        \INITIAL_BLOCKS  1, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+        sub     $16*1, %r13
+        jmp     _initial_blocks_encrypted\@
+
+_initial_num_blocks_is_0\@:
+        \INITIAL_BLOCKS  0, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xmm9,=
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, \EN=
C_DEC
+
+
+_initial_blocks_encrypted\@:
+        cmp     $0, %r13
+        je      _zero_cipher_left\@
+
+        sub     $128, %r13
+        je      _eight_cipher_left\@
+
+
+
+
+        vmovd   %xmm9, %r15d
+        and     $255, %r15d
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+
+
+_encrypt_by_8_new\@:
+        cmp     $(255-8), %r15d
+        jg      _encrypt_by_8\@
+
+
+
+        add     $8, %r15b
+        \GHASH_8_ENCRYPT_8_PARALLEL      %xmm0, %xmm10, %xmm11, %xmm12, %x=
mm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8=
, %xmm15, out_order, \ENC_DEC
+        add     $128, %r11
+        sub     $128, %r13
+        jne     _encrypt_by_8_new\@
+
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+        jmp     _eight_cipher_left\@
+
+_encrypt_by_8\@:
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+        add     $8, %r15b
+        \GHASH_8_ENCRYPT_8_PARALLEL      %xmm0, %xmm10, %xmm11, %xmm12, %x=
mm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8=
, %xmm15, in_order, \ENC_DEC
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+        add     $128, %r11
+        sub     $128, %r13
+        jne     _encrypt_by_8_new\@
+
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+
+
+
+
+_eight_cipher_left\@:
+        \GHASH_LAST_8    %xmm0, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %x=
mm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8
+
+
+_zero_cipher_left\@:
+        cmp     $16, arg4
+        jl      _only_less_than_16\@
+
+        mov     arg4, %r13
+        and     $15, %r13                            # r13 =3D (arg4 mod 1=
6)
+
+        je      _multiple_of_16_bytes\@
+
+        # handle the last <16 Byte block seperately
+
+
+        vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
+
+        sub     $16, %r11
+        add     %r13, %r11
+        vmovdqu (arg3, %r11), %xmm1                  # receive the last <1=
6 Byte block
+
+        lea     SHIFT_MASK+16(%rip), %r12
+        sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
+						     # able to shift 16-r13 bytes (r13 is the
+						     # number of bytes in plaintext mod 16)
+        vmovdqu (%r12), %xmm2                        # get the appropriate=
 shuffle mask
+        vpshufb %xmm2, %xmm1, %xmm1                  # shift right 16-r13 =
bytes
+        jmp     _final_ghash_mul\@
+
+_only_less_than_16\@:
+        # check for 0 length
+        mov     arg4, %r13
+        and     $15, %r13                            # r13 =3D (arg4 mod 1=
6)
+
+        je      _multiple_of_16_bytes\@
+
+        # handle the last <16 Byte block separately
+
+
+        vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
+
+
+        lea     SHIFT_MASK+16(%rip), %r12
+        sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
+						     # able to shift 16-r13 bytes (r13 is the
+						     # number of bytes in plaintext mod 16)
+
+_get_last_16_byte_loop\@:
+        movb    (arg3, %r11),  %al
+        movb    %al,  TMP1 (%rsp , %r11)
+        add     $1, %r11
+        cmp     %r13,  %r11
+        jne     _get_last_16_byte_loop\@
+
+        vmovdqu  TMP1(%rsp), %xmm1
+
+        sub     $16, %r11
+
+_final_ghash_mul\@:
+        .if  \ENC_DEC =3D=3D  DEC
+        vmovdqa %xmm1, %xmm2
+        vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
+        vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to
+						     # mask out top 16-r13 bytes of xmm9
+        vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
+        vpand   %xmm1, %xmm2, %xmm2
+        vpshufb SHUF_MASK(%rip), %xmm2, %xmm2
+        vpxor   %xmm2, %xmm14, %xmm14
+	#GHASH computation for the last <16 Byte block
+        \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+        sub     %r13, %r11
+        add     $16, %r11
+        .else
+        vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
+        vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to
+						     # mask out top 16-r13 bytes of xmm9
+        vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
+        vpxor   %xmm9, %xmm14, %xmm14
+	#GHASH computation for the last <16 Byte block
+        \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+        sub     %r13, %r11
+        add     $16, %r11
+        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9        # shuffle xmm9 back t=
o output as ciphertext
+        .endif
+
+
+        #############################
+        # output r13 Bytes
+        vmovq   %xmm9, %rax
+        cmp     $8, %r13
+        jle     _less_than_8_bytes_left\@
+
+        mov     %rax, (arg2 , %r11)
+        add     $8, %r11
+        vpsrldq $8, %xmm9, %xmm9
+        vmovq   %xmm9, %rax
+        sub     $8, %r13
+
+_less_than_8_bytes_left\@:
+        movb    %al, (arg2 , %r11)
+        add     $1, %r11
+        shr     $8, %rax
+        sub     $1, %r13
+        jne     _less_than_8_bytes_left\@
+        #############################
+
+_multiple_of_16_bytes\@:
+        mov     arg7, %r12                           # r12 =3D aadLen (num=
ber of bytes)
+        shl     $3, %r12                             # convert into number=
 of bits
+        vmovd   %r12d, %xmm15                        # len(A) in xmm15
+
+        shl     $3, arg4                             # len(C) in bits  (*1=
28)
+        vmovq   arg4, %xmm1
+        vpslldq $8, %xmm15, %xmm15                   # xmm15 =3D len(A)|| =
0x0000000000000000
+        vpxor   %xmm1, %xmm15, %xmm15                # xmm15 =3D len(A)||l=
en(C)
+
+        vpxor   %xmm15, %xmm14, %xmm14
+        \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6    # final GHASH computation
+        vpshufb SHUF_MASK(%rip), %xmm14, %xmm14      # perform a 16Byte sw=
ap
+
+        mov     arg5, %rax                           # rax =3D *Y0
+        vmovdqu (%rax), %xmm9                        # xmm9 =3D Y0
+
+        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Y0)
+
+        vpxor   %xmm14, %xmm9, %xmm9
+
+
+
+_return_T\@:
+        mov     arg8, %r10              # r10 =3D authTag
+        mov     arg9, %r11              # r11 =3D auth_tag_len
+
+        cmp     $16, %r11
+        je      _T_16\@
+
+        cmp     $8, %r11
+        jl      _T_4\@
+
+_T_8\@:
+        vmovq   %xmm9, %rax
+        mov     %rax, (%r10)
+        add     $8, %r10
+        sub     $8, %r11
+        vpsrldq $8, %xmm9, %xmm9
+        cmp     $0, %r11
+        je     _return_T_done\@
+_T_4\@:
+        vmovd   %xmm9, %eax
+        mov     %eax, (%r10)
+        add     $4, %r10
+        sub     $4, %r11
+        vpsrldq     $4, %xmm9, %xmm9
+        cmp     $0, %r11
+        je     _return_T_done\@
+_T_123\@:
+        vmovd     %xmm9, %eax
+        cmp     $2, %r11
+        jl     _T_1\@
+        mov     %ax, (%r10)
+        cmp     $2, %r11
+        je     _return_T_done\@
+        add     $2, %r10
+        sar     $16, %eax
+_T_1\@:
+        mov     %al, (%r10)
+        jmp     _return_T_done\@
+
+_T_16\@:
+        vmovdqu %xmm9, (%r10)
+
+_return_T_done\@:
+        mov     %r14, %rsp
+
+        pop     %r15
+        pop     %r14
+        pop     %r13
+        pop     %r12
+.endm
+
 #ifdef CONFIG_AS_AVX
 ##########################################################################=
#####
 # GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
@@ -1210,322 +1524,6 @@ _initial_blocks_done\@:
=20
 .endm
=20
-
-# combined for GCM encrypt and decrypt functions
-# clobbering all xmm registers
-# clobbering r10, r11, r12, r13, r14, r15
-.macro  GCM_ENC_DEC_AVX     ENC_DEC
-
-        #the number of pushes must equal STACK_OFFSET
-        push    %r12
-        push    %r13
-        push    %r14
-        push    %r15
-
-        mov     %rsp, %r14
-
-
-
-
-        sub     $VARIABLE_OFFSET, %rsp
-        and     $~63, %rsp                  # align rsp to 64 bytes
-
-
-        vmovdqu  HashKey(arg1), %xmm13      # xmm13 =3D HashKey
-
-        mov     arg4, %r13                  # save the number of bytes of =
plaintext/ciphertext
-        and     $-16, %r13                  # r13 =3D r13 - (r13 mod 16)
-
-        mov     %r13, %r12
-        shr     $4, %r12
-        and     $7, %r12
-        jz      _initial_num_blocks_is_0\@
-
-        cmp     $7, %r12
-        je      _initial_num_blocks_is_7\@
-        cmp     $6, %r12
-        je      _initial_num_blocks_is_6\@
-        cmp     $5, %r12
-        je      _initial_num_blocks_is_5\@
-        cmp     $4, %r12
-        je      _initial_num_blocks_is_4\@
-        cmp     $3, %r12
-        je      _initial_num_blocks_is_3\@
-        cmp     $2, %r12
-        je      _initial_num_blocks_is_2\@
-
-        jmp     _initial_num_blocks_is_1\@
-
-_initial_num_blocks_is_7\@:
-        INITIAL_BLOCKS_AVX  7, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*7, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_6\@:
-        INITIAL_BLOCKS_AVX  6, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*6, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_5\@:
-        INITIAL_BLOCKS_AVX  5, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*5, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_4\@:
-        INITIAL_BLOCKS_AVX  4, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*4, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_3\@:
-        INITIAL_BLOCKS_AVX  3, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*3, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_2\@:
-        INITIAL_BLOCKS_AVX  2, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*2, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_1\@:
-        INITIAL_BLOCKS_AVX  1, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-        sub     $16*1, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_0\@:
-        INITIAL_BLOCKS_AVX  0, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %xm=
m9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0, =
\ENC_DEC
-
-
-_initial_blocks_encrypted\@:
-        cmp     $0, %r13
-        je      _zero_cipher_left\@
-
-        sub     $128, %r13
-        je      _eight_cipher_left\@
-
-
-
-
-        vmovd   %xmm9, %r15d
-        and     $255, %r15d
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-
-
-_encrypt_by_8_new\@:
-        cmp     $(255-8), %r15d
-        jg      _encrypt_by_8\@
-
-
-
-        add     $8, %r15b
-        GHASH_8_ENCRYPT_8_PARALLEL_AVX      %xmm0, %xmm10, %xmm11, %xmm12,=
 %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %x=
mm8, %xmm15, out_order, \ENC_DEC
-        add     $128, %r11
-        sub     $128, %r13
-        jne     _encrypt_by_8_new\@
-
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        jmp     _eight_cipher_left\@
-
-_encrypt_by_8\@:
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        add     $8, %r15b
-        GHASH_8_ENCRYPT_8_PARALLEL_AVX      %xmm0, %xmm10, %xmm11, %xmm12,=
 %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %x=
mm8, %xmm15, in_order, \ENC_DEC
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        add     $128, %r11
-        sub     $128, %r13
-        jne     _encrypt_by_8_new\@
-
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-
-
-
-
-_eight_cipher_left\@:
-        GHASH_LAST_8_AVX    %xmm0, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,=
 %xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8
-
-
-_zero_cipher_left\@:
-        cmp     $16, arg4
-        jl      _only_less_than_16\@
-
-        mov     arg4, %r13
-        and     $15, %r13                            # r13 =3D (arg4 mod 1=
6)
-
-        je      _multiple_of_16_bytes\@
-
-        # handle the last <16 Byte block seperately
-
-
-        vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
-
-        sub     $16, %r11
-        add     %r13, %r11
-        vmovdqu (arg3, %r11), %xmm1                  # receive the last <1=
6 Byte block
-
-        lea     SHIFT_MASK+16(%rip), %r12
-        sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
-						     # able to shift 16-r13 bytes (r13 is the
-						     # number of bytes in plaintext mod 16)
-        vmovdqu (%r12), %xmm2                        # get the appropriate=
 shuffle mask
-        vpshufb %xmm2, %xmm1, %xmm1                  # shift right 16-r13 =
bytes
-        jmp     _final_ghash_mul\@
-
-_only_less_than_16\@:
-        # check for 0 length
-        mov     arg4, %r13
-        and     $15, %r13                            # r13 =3D (arg4 mod 1=
6)
-
-        je      _multiple_of_16_bytes\@
-
-        # handle the last <16 Byte block seperately
-
-
-        vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
-
-
-        lea     SHIFT_MASK+16(%rip), %r12
-        sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
-						     # able to shift 16-r13 bytes (r13 is the
-						     # number of bytes in plaintext mod 16)
-
-_get_last_16_byte_loop\@:
-        movb    (arg3, %r11),  %al
-        movb    %al,  TMP1 (%rsp , %r11)
-        add     $1, %r11
-        cmp     %r13,  %r11
-        jne     _get_last_16_byte_loop\@
-
-        vmovdqu  TMP1(%rsp), %xmm1
-
-        sub     $16, %r11
-
-_final_ghash_mul\@:
-        .if  \ENC_DEC =3D=3D  DEC
-        vmovdqa %xmm1, %xmm2
-        vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
-        vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to
-						     # mask out top 16-r13 bytes of xmm9
-        vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
-        vpand   %xmm1, %xmm2, %xmm2
-        vpshufb SHUF_MASK(%rip), %xmm2, %xmm2
-        vpxor   %xmm2, %xmm14, %xmm14
-	#GHASH computation for the last <16 Byte block
-        GHASH_MUL_AVX       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, =
%xmm6
-        sub     %r13, %r11
-        add     $16, %r11
-        .else
-        vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
-        vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to
-						     # mask out top 16-r13 bytes of xmm9
-        vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        vpxor   %xmm9, %xmm14, %xmm14
-	#GHASH computation for the last <16 Byte block
-        GHASH_MUL_AVX       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, =
%xmm6
-        sub     %r13, %r11
-        add     $16, %r11
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9        # shuffle xmm9 back t=
o output as ciphertext
-        .endif
-
-
-        #############################
-        # output r13 Bytes
-        vmovq   %xmm9, %rax
-        cmp     $8, %r13
-        jle     _less_than_8_bytes_left\@
-
-        mov     %rax, (arg2 , %r11)
-        add     $8, %r11
-        vpsrldq $8, %xmm9, %xmm9
-        vmovq   %xmm9, %rax
-        sub     $8, %r13
-
-_less_than_8_bytes_left\@:
-        movb    %al, (arg2 , %r11)
-        add     $1, %r11
-        shr     $8, %rax
-        sub     $1, %r13
-        jne     _less_than_8_bytes_left\@
-        #############################
-
-_multiple_of_16_bytes\@:
-        mov     arg7, %r12                           # r12 =3D aadLen (num=
ber of bytes)
-        shl     $3, %r12                             # convert into number=
 of bits
-        vmovd   %r12d, %xmm15                        # len(A) in xmm15
-
-        shl     $3, arg4                             # len(C) in bits  (*1=
28)
-        vmovq   arg4, %xmm1
-        vpslldq $8, %xmm15, %xmm15                   # xmm15 =3D len(A)|| =
0x0000000000000000
-        vpxor   %xmm1, %xmm15, %xmm15                # xmm15 =3D len(A)||l=
en(C)
-
-        vpxor   %xmm15, %xmm14, %xmm14
-        GHASH_MUL_AVX       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, =
%xmm6    # final GHASH computation
-        vpshufb SHUF_MASK(%rip), %xmm14, %xmm14      # perform a 16Byte sw=
ap
-
-        mov     arg5, %rax                           # rax =3D *Y0
-        vmovdqu (%rax), %xmm9                        # xmm9 =3D Y0
-
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Y0)
-
-        vpxor   %xmm14, %xmm9, %xmm9
-
-
-
-_return_T\@:
-        mov     arg8, %r10              # r10 =3D authTag
-        mov     arg9, %r11              # r11 =3D auth_tag_len
-
-        cmp     $16, %r11
-        je      _T_16\@
-
-        cmp     $8, %r11
-        jl      _T_4\@
-
-_T_8\@:
-        vmovq   %xmm9, %rax
-        mov     %rax, (%r10)
-        add     $8, %r10
-        sub     $8, %r11
-        vpsrldq $8, %xmm9, %xmm9
-        cmp     $0, %r11
-        je     _return_T_done\@
-_T_4\@:
-        vmovd   %xmm9, %eax
-        mov     %eax, (%r10)
-        add     $4, %r10
-        sub     $4, %r11
-        vpsrldq     $4, %xmm9, %xmm9
-        cmp     $0, %r11
-        je     _return_T_done\@
-_T_123\@:
-        vmovd     %xmm9, %eax
-        cmp     $2, %r11
-        jl     _T_1\@
-        mov     %ax, (%r10)
-        cmp     $2, %r11
-        je     _return_T_done\@
-        add     $2, %r10
-        sar     $16, %eax
-_T_1\@:
-        mov     %al, (%r10)
-        jmp     _return_T_done\@
-
-_T_16\@:
-        vmovdqu %xmm9, (%r10)
-
-_return_T_done\@:
-        mov     %r14, %rsp
-
-        pop     %r15
-        pop     %r14
-        pop     %r13
-        pop     %r12
-.endm
-
-
 #############################################################
 #void   aesni_gcm_precomp_avx_gen2
 #        (gcm_data     *my_ctx_data,
@@ -1593,7 +1591,7 @@ ENDPROC(aesni_gcm_precomp_avx_gen2)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_enc_avx_gen2)
-        GCM_ENC_DEC_AVX     ENC
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX GHASH_8_ENCRYPT_8_PARALLEL_AVX GHAS=
H_LAST_8_AVX GHASH_MUL_AVX ENC
 	ret
 ENDPROC(aesni_gcm_enc_avx_gen2)
=20
@@ -1614,7 +1612,7 @@ ENDPROC(aesni_gcm_enc_avx_gen2)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_dec_avx_gen2)
-        GCM_ENC_DEC_AVX     DEC
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX GHASH_8_ENCRYPT_8_PARALLEL_AVX GHAS=
H_LAST_8_AVX GHASH_MUL_AVX DEC
 	ret
 ENDPROC(aesni_gcm_dec_avx_gen2)
 #endif /* CONFIG_AS_AVX */
@@ -2536,319 +2534,6 @@ _initial_blocks_done\@:
=20
=20
=20
-# combined for GCM encrypt and decrypt functions
-# clobbering all xmm registers
-# clobbering r10, r11, r12, r13, r14, r15
-.macro  GCM_ENC_DEC_AVX2     ENC_DEC
-
-        #the number of pushes must equal STACK_OFFSET
-        push    %r12
-        push    %r13
-        push    %r14
-        push    %r15
-
-        mov     %rsp, %r14
-
-
-
-
-        sub     $VARIABLE_OFFSET, %rsp
-        and     $~63, %rsp                         # align rsp to 64 bytes
-
-
-        vmovdqu  HashKey(arg1), %xmm13             # xmm13 =3D HashKey
-
-        mov     arg4, %r13                         # save the number of by=
tes of plaintext/ciphertext
-        and     $-16, %r13                         # r13 =3D r13 - (r13 mo=
d 16)
-
-        mov     %r13, %r12
-        shr     $4, %r12
-        and     $7, %r12
-        jz      _initial_num_blocks_is_0\@
-
-        cmp     $7, %r12
-        je      _initial_num_blocks_is_7\@
-        cmp     $6, %r12
-        je      _initial_num_blocks_is_6\@
-        cmp     $5, %r12
-        je      _initial_num_blocks_is_5\@
-        cmp     $4, %r12
-        je      _initial_num_blocks_is_4\@
-        cmp     $3, %r12
-        je      _initial_num_blocks_is_3\@
-        cmp     $2, %r12
-        je      _initial_num_blocks_is_2\@
-
-        jmp     _initial_num_blocks_is_1\@
-
-_initial_num_blocks_is_7\@:
-        INITIAL_BLOCKS_AVX2  7, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*7, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_6\@:
-        INITIAL_BLOCKS_AVX2  6, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*6, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_5\@:
-        INITIAL_BLOCKS_AVX2  5, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*5, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_4\@:
-        INITIAL_BLOCKS_AVX2  4, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*4, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_3\@:
-        INITIAL_BLOCKS_AVX2  3, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*3, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_2\@:
-        INITIAL_BLOCKS_AVX2  2, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*2, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_1\@:
-        INITIAL_BLOCKS_AVX2  1, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-        sub     $16*1, %r13
-        jmp     _initial_blocks_encrypted\@
-
-_initial_num_blocks_is_0\@:
-        INITIAL_BLOCKS_AVX2  0, %xmm12, %xmm13, %xmm14, %xmm15, %xmm11, %x=
mm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, %xmm10, %xmm0,=
 \ENC_DEC
-
-
-_initial_blocks_encrypted\@:
-        cmp     $0, %r13
-        je      _zero_cipher_left\@
-
-        sub     $128, %r13
-        je      _eight_cipher_left\@
-
-
-
-
-        vmovd   %xmm9, %r15d
-        and     $255, %r15d
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-
-
-_encrypt_by_8_new\@:
-        cmp     $(255-8), %r15d
-        jg      _encrypt_by_8\@
-
-
-
-        add     $8, %r15b
-        GHASH_8_ENCRYPT_8_PARALLEL_AVX2      %xmm0, %xmm10, %xmm11, %xmm12=
, %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %=
xmm8, %xmm15, out_order, \ENC_DEC
-        add     $128, %r11
-        sub     $128, %r13
-        jne     _encrypt_by_8_new\@
-
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        jmp     _eight_cipher_left\@
-
-_encrypt_by_8\@:
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        add     $8, %r15b
-        GHASH_8_ENCRYPT_8_PARALLEL_AVX2      %xmm0, %xmm10, %xmm11, %xmm12=
, %xmm13, %xmm14, %xmm9, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %=
xmm8, %xmm15, in_order, \ENC_DEC
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        add     $128, %r11
-        sub     $128, %r13
-        jne     _encrypt_by_8_new\@
-
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-
-
-
-
-_eight_cipher_left\@:
-        GHASH_LAST_8_AVX2    %xmm0, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14=
, %xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8
-
-
-_zero_cipher_left\@:
-        cmp     $16, arg4
-        jl      _only_less_than_16\@
-
-        mov     arg4, %r13
-        and     $15, %r13                            # r13 =3D (arg4 mod 1=
6)
-
-        je      _multiple_of_16_bytes\@
-
-        # handle the last <16 Byte block seperately
-
-
-        vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
-
-        sub     $16, %r11
-        add     %r13, %r11
-        vmovdqu (arg3, %r11), %xmm1                  # receive the last <1=
6 Byte block
-
-        lea     SHIFT_MASK+16(%rip), %r12
-        sub     %r13, %r12                           # adjust the shuffle =
mask pointer
-						     # to be able to shift 16-r13 bytes
-						     # (r13 is the number of bytes in plaintext mod 16)
-        vmovdqu (%r12), %xmm2                        # get the appropriate=
 shuffle mask
-        vpshufb %xmm2, %xmm1, %xmm1                  # shift right 16-r13 =
bytes
-        jmp     _final_ghash_mul\@
-
-_only_less_than_16\@:
-        # check for 0 length
-        mov     arg4, %r13
-        and     $15, %r13                            # r13 =3D (arg4 mod 1=
6)
-
-        je      _multiple_of_16_bytes\@
-
-        # handle the last <16 Byte block seperately
-
-
-        vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Yn)
-
-
-        lea     SHIFT_MASK+16(%rip), %r12
-        sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
-						     # able to shift 16-r13 bytes (r13 is the
-						     # number of bytes in plaintext mod 16)
-
-_get_last_16_byte_loop\@:
-        movb    (arg3, %r11),  %al
-        movb    %al,  TMP1 (%rsp , %r11)
-        add     $1, %r11
-        cmp     %r13,  %r11
-        jne     _get_last_16_byte_loop\@
-
-        vmovdqu  TMP1(%rsp), %xmm1
-
-        sub     $16, %r11
-
-_final_ghash_mul\@:
-        .if  \ENC_DEC =3D=3D  DEC
-        vmovdqa %xmm1, %xmm2
-        vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
-        vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to mask out top 16-r13 bytes of xmm9
-        vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
-        vpand   %xmm1, %xmm2, %xmm2
-        vpshufb SHUF_MASK(%rip), %xmm2, %xmm2
-        vpxor   %xmm2, %xmm14, %xmm14
-	#GHASH computation for the last <16 Byte block
-        GHASH_MUL_AVX2       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5,=
 %xmm6
-        sub     %r13, %r11
-        add     $16, %r11
-        .else
-        vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
-        vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to mask out top 16-r13 bytes of xmm9
-        vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        vpxor   %xmm9, %xmm14, %xmm14
-	#GHASH computation for the last <16 Byte block
-        GHASH_MUL_AVX2       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5,=
 %xmm6
-        sub     %r13, %r11
-        add     $16, %r11
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9        # shuffle xmm9 back t=
o output as ciphertext
-        .endif
-
-
-        #############################
-        # output r13 Bytes
-        vmovq   %xmm9, %rax
-        cmp     $8, %r13
-        jle     _less_than_8_bytes_left\@
-
-        mov     %rax, (arg2 , %r11)
-        add     $8, %r11
-        vpsrldq $8, %xmm9, %xmm9
-        vmovq   %xmm9, %rax
-        sub     $8, %r13
-
-_less_than_8_bytes_left\@:
-        movb    %al, (arg2 , %r11)
-        add     $1, %r11
-        shr     $8, %rax
-        sub     $1, %r13
-        jne     _less_than_8_bytes_left\@
-        #############################
-
-_multiple_of_16_bytes\@:
-        mov     arg7, %r12                           # r12 =3D aadLen (num=
ber of bytes)
-        shl     $3, %r12                             # convert into number=
 of bits
-        vmovd   %r12d, %xmm15                        # len(A) in xmm15
-
-        shl     $3, arg4                             # len(C) in bits  (*1=
28)
-        vmovq   arg4, %xmm1
-        vpslldq $8, %xmm15, %xmm15                   # xmm15 =3D len(A)|| =
0x0000000000000000
-        vpxor   %xmm1, %xmm15, %xmm15                # xmm15 =3D len(A)||l=
en(C)
-
-        vpxor   %xmm15, %xmm14, %xmm14
-        GHASH_MUL_AVX2       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5,=
 %xmm6    # final GHASH computation
-        vpshufb SHUF_MASK(%rip), %xmm14, %xmm14              # perform a 1=
6Byte swap
-
-        mov     arg5, %rax                           # rax =3D *Y0
-        vmovdqu (%rax), %xmm9                        # xmm9 =3D Y0
-
-        ENCRYPT_SINGLE_BLOCK    %xmm9                # E(K, Y0)
-
-        vpxor   %xmm14, %xmm9, %xmm9
-
-
-
-_return_T\@:
-        mov     arg8, %r10              # r10 =3D authTag
-        mov     arg9, %r11              # r11 =3D auth_tag_len
-
-        cmp     $16, %r11
-        je      _T_16\@
-
-        cmp     $8, %r11
-        jl      _T_4\@
-
-_T_8\@:
-        vmovq   %xmm9, %rax
-        mov     %rax, (%r10)
-        add     $8, %r10
-        sub     $8, %r11
-        vpsrldq $8, %xmm9, %xmm9
-        cmp     $0, %r11
-        je     _return_T_done\@
-_T_4\@:
-        vmovd   %xmm9, %eax
-        mov     %eax, (%r10)
-        add     $4, %r10
-        sub     $4, %r11
-        vpsrldq     $4, %xmm9, %xmm9
-        cmp     $0, %r11
-        je     _return_T_done\@
-_T_123\@:
-        vmovd     %xmm9, %eax
-        cmp     $2, %r11
-        jl     _T_1\@
-        mov     %ax, (%r10)
-        cmp     $2, %r11
-        je     _return_T_done\@
-        add     $2, %r10
-        sar     $16, %eax
-_T_1\@:
-        mov     %al, (%r10)
-        jmp     _return_T_done\@
-
-_T_16\@:
-        vmovdqu %xmm9, (%r10)
-
-_return_T_done\@:
-        mov     %r14, %rsp
-
-        pop     %r15
-        pop     %r14
-        pop     %r13
-        pop     %r12
-.endm
-
-
 #############################################################
 #void   aesni_gcm_precomp_avx_gen4
 #        (gcm_data     *my_ctx_data,
@@ -2918,7 +2603,7 @@ ENDPROC(aesni_gcm_precomp_avx_gen4)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_enc_avx_gen4)
-        GCM_ENC_DEC_AVX2     ENC
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2 GHASH_8_ENCRYPT_8_PARALLEL_AVX2 GH=
ASH_LAST_8_AVX2 GHASH_MUL_AVX2 ENC
 	ret
 ENDPROC(aesni_gcm_enc_avx_gen4)
=20
@@ -2939,7 +2624,7 @@ ENDPROC(aesni_gcm_enc_avx_gen4)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_dec_avx_gen4)
-        GCM_ENC_DEC_AVX2     DEC
+        GCM_ENC_DEC INITIAL_BLOCKS_AVX2 GHASH_8_ENCRYPT_8_PARALLEL_AVX2 GH=
ASH_LAST_8_AVX2 GHASH_MUL_AVX2 DEC
 	ret
 ENDPROC(aesni_gcm_dec_avx_gen4)
=20
--=20
2.17.1
