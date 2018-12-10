Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727434AbeLJUAJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 15:00:09 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 07/12] x86/crypto: aesni: Merge avx precompute functions
Date: Mon, 10 Dec 2018 19:58:38 +0000
Message-ID: <f2b870d980ed5c7fdabd1c4746ab94a145fa9807.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6B142CDB14D114E973E598D4DA0A361@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The precompute functions differ only by the sub-macros
they call, merge them to a single macro.   Later diffs
add more code to fill in the gcm_context_data structure,
this allows changes in a single place.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 76 +++++++++---------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 305abece93ad..e347ba61db65 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -661,6 +661,31 @@ _get_AAD_done\@:
         vmovdqu \T7, AadHash(arg2)
 .endm
=20
+.macro INIT GHASH_MUL PRECOMPUTE
+        vmovdqu  (arg3), %xmm6              # xmm6 =3D HashKey
+
+        vpshufb  SHUF_MASK(%rip), %xmm6, %xmm6
+        ###############  PRECOMPUTATION of HashKey<<1 mod poly from the Ha=
shKey
+        vmovdqa  %xmm6, %xmm2
+        vpsllq   $1, %xmm6, %xmm6
+        vpsrlq   $63, %xmm2, %xmm2
+        vmovdqa  %xmm2, %xmm1
+        vpslldq  $8, %xmm2, %xmm2
+        vpsrldq  $8, %xmm1, %xmm1
+        vpor     %xmm2, %xmm6, %xmm6
+        #reduction
+        vpshufd  $0b00100100, %xmm1, %xmm2
+        vpcmpeqd TWOONE(%rip), %xmm2, %xmm2
+        vpand    POLY(%rip), %xmm2, %xmm2
+        vpxor    %xmm2, %xmm6, %xmm6        # xmm6 holds the HashKey<<1 mo=
d poly
+        ##################################################################=
#####
+        vmovdqu  %xmm6, HashKey(arg2)       # store HashKey<<1 mod poly
+
+        CALC_AAD_HASH \GHASH_MUL, arg5, arg6, %xmm2, %xmm6, %xmm3, %xmm4, =
%xmm5, %xmm7, %xmm1, %xmm0
+
+        \PRECOMPUTE  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
+.endm
+
 #ifdef CONFIG_AS_AVX
 ##########################################################################=
#####
 # GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
@@ -1558,31 +1583,7 @@ _initial_blocks_done\@:
 #############################################################
 ENTRY(aesni_gcm_precomp_avx_gen2)
         FUNC_SAVE
-
-        vmovdqu  (arg3), %xmm6              # xmm6 =3D HashKey
-
-        vpshufb  SHUF_MASK(%rip), %xmm6, %xmm6
-        ###############  PRECOMPUTATION of HashKey<<1 mod poly from the Ha=
shKey
-        vmovdqa  %xmm6, %xmm2
-        vpsllq   $1, %xmm6, %xmm6
-        vpsrlq   $63, %xmm2, %xmm2
-        vmovdqa  %xmm2, %xmm1
-        vpslldq  $8, %xmm2, %xmm2
-        vpsrldq  $8, %xmm1, %xmm1
-        vpor     %xmm2, %xmm6, %xmm6
-        #reduction
-        vpshufd  $0b00100100, %xmm1, %xmm2
-        vpcmpeqd TWOONE(%rip), %xmm2, %xmm2
-        vpand    POLY(%rip), %xmm2, %xmm2
-        vpxor    %xmm2, %xmm6, %xmm6        # xmm6 holds the HashKey<<1 mo=
d poly
-        ##################################################################=
#####
-        vmovdqu  %xmm6, HashKey(arg2)       # store HashKey<<1 mod poly
-
-
-        CALC_AAD_HASH GHASH_MUL_AVX, arg5, arg6, %xmm2, %xmm6, %xmm3, %xmm=
4, %xmm5, %xmm7, %xmm1, %xmm0
-
-        PRECOMPUTE_AVX  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
-
+        INIT GHASH_MUL_AVX, PRECOMPUTE_AVX
         FUNC_RESTORE
         ret
 ENDPROC(aesni_gcm_precomp_avx_gen2)
@@ -2547,30 +2548,7 @@ _initial_blocks_done\@:
 #############################################################
 ENTRY(aesni_gcm_precomp_avx_gen4)
         FUNC_SAVE
-
-        vmovdqu  (arg3), %xmm6                # xmm6 =3D HashKey
-
-        vpshufb  SHUF_MASK(%rip), %xmm6, %xmm6
-        ###############  PRECOMPUTATION of HashKey<<1 mod poly from the Ha=
shKey
-        vmovdqa  %xmm6, %xmm2
-        vpsllq   $1, %xmm6, %xmm6
-        vpsrlq   $63, %xmm2, %xmm2
-        vmovdqa  %xmm2, %xmm1
-        vpslldq  $8, %xmm2, %xmm2
-        vpsrldq  $8, %xmm1, %xmm1
-        vpor     %xmm2, %xmm6, %xmm6
-        #reduction
-        vpshufd  $0b00100100, %xmm1, %xmm2
-        vpcmpeqd TWOONE(%rip), %xmm2, %xmm2
-        vpand    POLY(%rip), %xmm2, %xmm2
-        vpxor    %xmm2, %xmm6, %xmm6          # xmm6 holds the HashKey<<1 =
mod poly
-        ##################################################################=
#####
-        vmovdqu  %xmm6, HashKey(arg2)         # store HashKey<<1 mod poly
-
-        CALC_AAD_HASH GHASH_MUL_AVX2, arg5, arg6, %xmm2, %xmm6, %xmm3, %xm=
m4, %xmm5, %xmm7, %xmm1, %xmm0
-
-        PRECOMPUTE_AVX2  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
-
+        INIT GHASH_MUL_AVX2, PRECOMPUTE_AVX2
         FUNC_RESTORE
         ret
 ENDPROC(aesni_gcm_precomp_avx_gen4)
--=20
2.17.1
