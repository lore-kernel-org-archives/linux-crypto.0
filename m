Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727764AbeLJUAS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 15:00:18 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 10/12] x86/crypto: aesni: Introduce READ_PARTIAL_BLOCK macro
Date: Mon, 10 Dec 2018 19:59:26 +0000
Message-ID: <1b813c4617813c08bea79ff57f3497ea2d32df24.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CECA8052A795CB45BBA55D51003D6040@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce READ_PARTIAL_BLOCK macro, and use it in the two existing
partial block cases: AAD and the end of ENC_DEC.   In particular,
the ENC_DEC case should be faster, since we read by 8/4 bytes if
possible.

This macro will also be used to read partial blocks between
enc_update and dec_update calls.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 102 +++++++++++++----------
 1 file changed, 59 insertions(+), 43 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 44a4a8b43ca4..ff00ad19064d 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -415,68 +415,56 @@ _zero_cipher_left\@:
         vmovdqu %xmm14, AadHash(arg2)
         vmovdqu %xmm9, CurCount(arg2)
=20
-        cmp     $16, arg5
-        jl      _only_less_than_16\@
-
+        # check for 0 length
         mov     arg5, %r13
         and     $15, %r13                            # r13 =3D (arg5 mod 1=
6)
=20
         je      _multiple_of_16_bytes\@
=20
-        # handle the last <16 Byte block seperately
+        # handle the last <16 Byte block separately
=20
         mov %r13, PBlockLen(arg2)
=20
-        vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
+        vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
         vmovdqu %xmm9, CurCount(arg2)
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
=20
         ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Yn)
         vmovdqu %xmm9, PBlockEncKey(arg2)
=20
-        sub     $16, %r11
-        add     %r13, %r11
-        vmovdqu (arg4, %r11), %xmm1                  # receive the last <1=
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
-        mov     arg5, %r13
-        and     $15, %r13                            # r13 =3D (arg5 mod 1=
6)
+        cmp $16, arg5
+        jge _large_enough_update\@
=20
-        je      _multiple_of_16_bytes\@
+        lea (arg4,%r11,1), %r10
+        mov %r13, %r12
=20
-        # handle the last <16 Byte block separately
-
-
-        vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
-        vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
-        ENCRYPT_SINGLE_BLOCK    \REP, %xmm9                # E(K, Yn)
-
-        vmovdqu %xmm9, PBlockEncKey(arg2)
+        READ_PARTIAL_BLOCK %r10 %r12 %xmm1
=20
         lea     SHIFT_MASK+16(%rip), %r12
         sub     %r13, %r12                           # adjust the shuffle =
mask pointer to be
 						     # able to shift 16-r13 bytes (r13 is the
-						     # number of bytes in plaintext mod 16)
+	# number of bytes in plaintext mod 16)
=20
-_get_last_16_byte_loop\@:
-        movb    (arg4, %r11),  %al
-        movb    %al,  TMP1 (%rsp , %r11)
-        add     $1, %r11
-        cmp     %r13,  %r11
-        jne     _get_last_16_byte_loop\@
+        jmp _final_ghash_mul\@
+
+_large_enough_update\@:
+        sub $16, %r11
+        add %r13, %r11
+
+        # receive the last <16 Byte block
+        vmovdqu	(arg4, %r11, 1), %xmm1
=20
-        vmovdqu  TMP1(%rsp), %xmm1
+        sub	%r13, %r11
+        add	$16, %r11
=20
-        sub     $16, %r11
+        lea	SHIFT_MASK+16(%rip), %r12
+        # adjust the shuffle mask pointer to be able to shift 16-r13 bytes
+        # (r13 is the number of bytes in plaintext mod 16)
+        sub	%r13, %r12
+        # get the appropriate shuffle mask
+        vmovdqu	(%r12), %xmm2
+        # shift right 16-r13 bytes
+        vpshufb  %xmm2, %xmm1, %xmm1
=20
 _final_ghash_mul\@:
         .if  \ENC_DEC =3D=3D  DEC
@@ -490,8 +478,6 @@ _final_ghash_mul\@:
         vpxor   %xmm2, %xmm14, %xmm14
=20
         vmovdqu %xmm14, AadHash(arg2)
-        sub     %r13, %r11
-        add     $16, %r11
         .else
         vpxor   %xmm1, %xmm9, %xmm9                  # Plaintext XOR E(K, =
Yn)
         vmovdqu ALL_F-SHIFT_MASK(%r12), %xmm1        # get the appropriate=
 mask to
@@ -501,8 +487,6 @@ _final_ghash_mul\@:
         vpxor   %xmm9, %xmm14, %xmm14
=20
         vmovdqu %xmm14, AadHash(arg2)
-        sub     %r13, %r11
-        add     $16, %r11
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9        # shuffle xmm9 back t=
o output as ciphertext
         .endif
=20
@@ -721,6 +705,38 @@ _get_AAD_done\@:
         \PRECOMPUTE  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
 .endm
=20
+
+# Reads DLEN bytes starting at DPTR and stores in XMMDst
+# where 0 < DLEN < 16
+# Clobbers %rax, DLEN
+.macro READ_PARTIAL_BLOCK DPTR DLEN XMMDst
+        vpxor \XMMDst, \XMMDst, \XMMDst
+
+        cmp $8, \DLEN
+        jl _read_lt8_\@
+        mov (\DPTR), %rax
+        vpinsrq $0, %rax, \XMMDst, \XMMDst
+        sub $8, \DLEN
+        jz _done_read_partial_block_\@
+        xor %eax, %eax
+_read_next_byte_\@:
+        shl $8, %rax
+        mov 7(\DPTR, \DLEN, 1), %al
+        dec \DLEN
+        jnz _read_next_byte_\@
+        vpinsrq $1, %rax, \XMMDst, \XMMDst
+        jmp _done_read_partial_block_\@
+_read_lt8_\@:
+        xor %eax, %eax
+_read_next_byte_lt8_\@:
+        shl $8, %rax
+        mov -1(\DPTR, \DLEN, 1), %al
+        dec \DLEN
+        jnz _read_next_byte_lt8_\@
+        vpinsrq $0, %rax, \XMMDst, \XMMDst
+_done_read_partial_block_\@:
+.endm
+
 #ifdef CONFIG_AS_AVX
 ##########################################################################=
#####
 # GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
--=20
2.17.1
