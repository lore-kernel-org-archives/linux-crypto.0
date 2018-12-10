Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54176 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727515AbeLJT5k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:57:40 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 03/12] x86/crypto: aesni: Macro-ify func save/restore
Date: Mon, 10 Dec 2018 19:57:12 +0000
Message-ID: <08b21e5705b45fe799463d4fa708c7b73fa24625.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2071F740F9B0A45A8419830921FF4EC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Macro-ify function save and restore.  These will be used in new functions
added for scatter/gather update operations.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 94 +++++++++---------------
 1 file changed, 36 insertions(+), 58 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 284f1b8b88fc..dd895f69399b 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -247,6 +247,30 @@ VARIABLE_OFFSET =3D 16*8
 # Utility Macros
 ################################
=20
+.macro FUNC_SAVE
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
+        sub     $VARIABLE_OFFSET, %rsp
+        and     $~63, %rsp                    # align rsp to 64 bytes
+.endm
+
+.macro FUNC_RESTORE
+        mov     %r14, %rsp
+
+        pop     %r15
+        pop     %r14
+        pop     %r13
+        pop     %r12
+.endm
+
 # Encryption of a single block
 .macro ENCRYPT_SINGLE_BLOCK XMM0
                 vpxor    (arg1), \XMM0, \XMM0
@@ -264,22 +288,6 @@ VARIABLE_OFFSET =3D 16*8
 # clobbering all xmm registers
 # clobbering r10, r11, r12, r13, r14, r15
 .macro  GCM_ENC_DEC INITIAL_BLOCKS GHASH_8_ENCRYPT_8_PARALLEL GHASH_LAST_8=
 GHASH_MUL ENC_DEC
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
         vmovdqu  HashKey(arg2), %xmm13      # xmm13 =3D HashKey
=20
         mov     arg5, %r13                  # save the number of bytes of =
plaintext/ciphertext
@@ -566,12 +574,6 @@ _T_16\@:
         vmovdqu %xmm9, (%r10)
=20
 _return_T_done\@:
-        mov     %r14, %rsp
-
-        pop     %r15
-        pop     %r14
-        pop     %r13
-        pop     %r12
 .endm
=20
 #ifdef CONFIG_AS_AVX
@@ -1511,18 +1513,7 @@ _initial_blocks_done\@:
 #        u8     *hash_subkey)# /* H, the Hash sub key input. Data starts o=
n a 16-byte boundary. */
 #############################################################
 ENTRY(aesni_gcm_precomp_avx_gen2)
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
-        sub     $VARIABLE_OFFSET, %rsp
-        and     $~63, %rsp                  # align rsp to 64 bytes
+        FUNC_SAVE
=20
         vmovdqu  (arg3), %xmm6              # xmm6 =3D HashKey
=20
@@ -1546,12 +1537,7 @@ ENTRY(aesni_gcm_precomp_avx_gen2)
=20
         PRECOMPUTE_AVX  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
=20
-        mov     %r14, %rsp
-
-        pop     %r15
-        pop     %r14
-        pop     %r13
-        pop     %r12
+        FUNC_RESTORE
         ret
 ENDPROC(aesni_gcm_precomp_avx_gen2)
=20
@@ -1573,7 +1559,9 @@ ENDPROC(aesni_gcm_precomp_avx_gen2)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_enc_avx_gen2)
+        FUNC_SAVE
         GCM_ENC_DEC INITIAL_BLOCKS_AVX GHASH_8_ENCRYPT_8_PARALLEL_AVX GHAS=
H_LAST_8_AVX GHASH_MUL_AVX ENC
+        FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_enc_avx_gen2)
=20
@@ -1595,7 +1583,9 @@ ENDPROC(aesni_gcm_enc_avx_gen2)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_dec_avx_gen2)
+        FUNC_SAVE
         GCM_ENC_DEC INITIAL_BLOCKS_AVX GHASH_8_ENCRYPT_8_PARALLEL_AVX GHAS=
H_LAST_8_AVX GHASH_MUL_AVX DEC
+        FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_dec_avx_gen2)
 #endif /* CONFIG_AS_AVX */
@@ -2525,18 +2515,7 @@ _initial_blocks_done\@:
 #				Data starts on a 16-byte boundary. */
 #############################################################
 ENTRY(aesni_gcm_precomp_avx_gen4)
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
-        sub     $VARIABLE_OFFSET, %rsp
-        and     $~63, %rsp                    # align rsp to 64 bytes
+        FUNC_SAVE
=20
         vmovdqu  (arg3), %xmm6                # xmm6 =3D HashKey
=20
@@ -2560,12 +2539,7 @@ ENTRY(aesni_gcm_precomp_avx_gen4)
=20
         PRECOMPUTE_AVX2  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
=20
-        mov     %r14, %rsp
-
-        pop     %r15
-        pop     %r14
-        pop     %r13
-        pop     %r12
+        FUNC_RESTORE
         ret
 ENDPROC(aesni_gcm_precomp_avx_gen4)
=20
@@ -2588,7 +2562,9 @@ ENDPROC(aesni_gcm_precomp_avx_gen4)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_enc_avx_gen4)
+        FUNC_SAVE
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2 GHASH_8_ENCRYPT_8_PARALLEL_AVX2 GH=
ASH_LAST_8_AVX2 GHASH_MUL_AVX2 ENC
+        FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_enc_avx_gen4)
=20
@@ -2610,7 +2586,9 @@ ENDPROC(aesni_gcm_enc_avx_gen4)
 #				Valid values are 16 (most likely), 12 or 8. */
 ##########################################################################=
#####
 ENTRY(aesni_gcm_dec_avx_gen4)
+        FUNC_SAVE
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2 GHASH_8_ENCRYPT_8_PARALLEL_AVX2 GH=
ASH_LAST_8_AVX2 GHASH_MUL_AVX2 DEC
+        FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_dec_avx_gen4)
=20
--=20
2.17.1
