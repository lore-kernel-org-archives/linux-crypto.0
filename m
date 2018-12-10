Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54978 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727721AbeLJT7e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:59:34 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 06/12] x86/crypto: aesni: Split AAD hash calculation to
 separate macro
Date: Mon, 10 Dec 2018 19:58:19 +0000
Message-ID: <12ee6b81fee1d5a112b81537f52b87b23a39caac.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6862799116472045B2319D6FE51A36BE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AAD hash only needs to be calculated once for each scatter/gather operation=
.
Move it to its own macro, and call it from GCM_INIT instead of
INITIAL_BLOCKS.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 228 ++++++++++-------------
 arch/x86/crypto/aesni-intel_glue.c       |  28 ++-
 2 files changed, 115 insertions(+), 141 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 8e9ae4b26118..305abece93ad 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -182,6 +182,14 @@ aad_shift_arr:
 .text
=20
=20
+#define AadHash 16*0
+#define AadLen 16*1
+#define InLen (16*1)+8
+#define PBlockEncKey 16*2
+#define OrigIV 16*3
+#define CurCount 16*4
+#define PBlockLen 16*5
+
 HashKey        =3D 16*6   # store HashKey <<1 mod poly here
 HashKey_2      =3D 16*7   # store HashKey^2 <<1 mod poly here
 HashKey_3      =3D 16*8   # store HashKey^3 <<1 mod poly here
@@ -585,6 +593,74 @@ _T_16\@:
 _return_T_done\@:
 .endm
=20
+.macro CALC_AAD_HASH GHASH_MUL AAD AADLEN T1 T2 T3 T4 T5 T6 T7 T8
+
+	mov     \AAD, %r10                      # r10 =3D AAD
+	mov     \AADLEN, %r12                      # r12 =3D aadLen
+
+
+	mov     %r12, %r11
+
+	vpxor   \T8, \T8, \T8
+	vpxor   \T7, \T7, \T7
+	cmp     $16, %r11
+	jl      _get_AAD_rest8\@
+_get_AAD_blocks\@:
+	vmovdqu (%r10), \T7
+	vpshufb SHUF_MASK(%rip), \T7, \T7
+	vpxor   \T7, \T8, \T8
+	\GHASH_MUL       \T8, \T2, \T1, \T3, \T4, \T5, \T6
+	add     $16, %r10
+	sub     $16, %r12
+	sub     $16, %r11
+	cmp     $16, %r11
+	jge     _get_AAD_blocks\@
+	vmovdqu \T8, \T7
+	cmp     $0, %r11
+	je      _get_AAD_done\@
+
+	vpxor   \T7, \T7, \T7
+
+	/* read the last <16B of AAD. since we have at least 4B of
+	data right after the AAD (the ICV, and maybe some CT), we can
+	read 4B/8B blocks safely, and then get rid of the extra stuff */
+_get_AAD_rest8\@:
+	cmp     $4, %r11
+	jle     _get_AAD_rest4\@
+	movq    (%r10), \T1
+	add     $8, %r10
+	sub     $8, %r11
+	vpslldq $8, \T1, \T1
+	vpsrldq $8, \T7, \T7
+	vpxor   \T1, \T7, \T7
+	jmp     _get_AAD_rest8\@
+_get_AAD_rest4\@:
+	cmp     $0, %r11
+	jle      _get_AAD_rest0\@
+	mov     (%r10), %eax
+	movq    %rax, \T1
+	add     $4, %r10
+	sub     $4, %r11
+	vpslldq $12, \T1, \T1
+	vpsrldq $4, \T7, \T7
+	vpxor   \T1, \T7, \T7
+_get_AAD_rest0\@:
+	/* finalize: shift out the extra bytes we read, and align
+	left. since pslldq can only shift by an immediate, we use
+	vpshufb and an array of shuffle masks */
+	movq    %r12, %r11
+	salq    $4, %r11
+	vmovdqu  aad_shift_arr(%r11), \T1
+	vpshufb \T1, \T7, \T7
+_get_AAD_rest_final\@:
+	vpshufb SHUF_MASK(%rip), \T7, \T7
+	vpxor   \T8, \T7, \T7
+	\GHASH_MUL       \T7, \T2, \T1, \T3, \T4, \T5, \T6
+
+_get_AAD_done\@:
+        vmovdqu \T7, AadHash(arg2)
+.endm
+
 #ifdef CONFIG_AS_AVX
 ##########################################################################=
#####
 # GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
@@ -701,72 +777,9 @@ _return_T_done\@:
=20
 .macro INITIAL_BLOCKS_AVX REP num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 X=
MM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC
 	i =3D (8-\num_initial_blocks)
-	j =3D 0
 	setreg
+        vmovdqu AadHash(arg2), reg_i
=20
-	mov     arg7, %r10                      # r10 =3D AAD
-	mov     arg8, %r12                      # r12 =3D aadLen
-
-
-	mov     %r12, %r11
-
-	vpxor   reg_j, reg_j, reg_j
-	vpxor   reg_i, reg_i, reg_i
-	cmp     $16, %r11
-	jl      _get_AAD_rest8\@
-_get_AAD_blocks\@:
-	vmovdqu (%r10), reg_i
-	vpshufb SHUF_MASK(%rip), reg_i, reg_i
-	vpxor   reg_i, reg_j, reg_j
-	GHASH_MUL_AVX       reg_j, \T2, \T1, \T3, \T4, \T5, \T6
-	add     $16, %r10
-	sub     $16, %r12
-	sub     $16, %r11
-	cmp     $16, %r11
-	jge     _get_AAD_blocks\@
-	vmovdqu reg_j, reg_i
-	cmp     $0, %r11
-	je      _get_AAD_done\@
-
-	vpxor   reg_i, reg_i, reg_i
-
-	/* read the last <16B of AAD. since we have at least 4B of
-	data right after the AAD (the ICV, and maybe some CT), we can
-	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\@:
-	cmp     $4, %r11
-	jle     _get_AAD_rest4\@
-	movq    (%r10), \T1
-	add     $8, %r10
-	sub     $8, %r11
-	vpslldq $8, \T1, \T1
-	vpsrldq $8, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-	jmp     _get_AAD_rest8\@
-_get_AAD_rest4\@:
-	cmp     $0, %r11
-	jle      _get_AAD_rest0\@
-	mov     (%r10), %eax
-	movq    %rax, \T1
-	add     $4, %r10
-	sub     $4, %r11
-	vpslldq $12, \T1, \T1
-	vpsrldq $4, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-_get_AAD_rest0\@:
-	/* finalize: shift out the extra bytes we read, and align
-	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq    %r12, %r11
-	salq    $4, %r11
-	movdqu  aad_shift_arr(%r11), \T1
-	vpshufb \T1, reg_i, reg_i
-_get_AAD_rest_final\@:
-	vpshufb SHUF_MASK(%rip), reg_i, reg_i
-	vpxor   reg_j, reg_i, reg_i
-	GHASH_MUL_AVX       reg_i, \T2, \T1, \T3, \T4, \T5, \T6
-
-_get_AAD_done\@:
 	# initialize the data pointer offset as zero
 	xor     %r11d, %r11d
=20
@@ -1535,7 +1548,13 @@ _initial_blocks_done\@:
 #void   aesni_gcm_precomp_avx_gen2
 #        (gcm_data     *my_ctx_data,
 #         gcm_context_data *data,
-#        u8     *hash_subkey)# /* H, the Hash sub key input. Data starts o=
n a 16-byte boundary. */
+#        u8     *hash_subkey# /* H, the Hash sub key input. Data starts on=
 a 16-byte boundary. */
+#        u8      *iv, /* Pre-counter block j0: 4 byte salt
+#			(from Security Association) concatenated with 8 byte
+#			Initialisation Vector (from IPSec ESP Payload)
+#			concatenated with 0x00000001. 16-byte aligned pointer. */
+#        const   u8 *aad, /* Additional Authentication Data (AAD)*/
+#        u64     aad_len) /* Length of AAD in bytes. With RFC4106 this is =
going to be 8 or 12 Bytes */
 #############################################################
 ENTRY(aesni_gcm_precomp_avx_gen2)
         FUNC_SAVE
@@ -1560,6 +1579,8 @@ ENTRY(aesni_gcm_precomp_avx_gen2)
         vmovdqu  %xmm6, HashKey(arg2)       # store HashKey<<1 mod poly
=20
=20
+        CALC_AAD_HASH GHASH_MUL_AVX, arg5, arg6, %xmm2, %xmm6, %xmm3, %xmm=
4, %xmm5, %xmm7, %xmm1, %xmm0
+
         PRECOMPUTE_AVX  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
=20
         FUNC_RESTORE
@@ -1716,7 +1737,6 @@ ENDPROC(aesni_gcm_dec_avx_gen2)
=20
 .endm
=20
-
 ## if a =3D number of total plaintext bytes
 ## b =3D floor(a/16)
 ## num_initial_blocks =3D b mod 4#
@@ -1726,73 +1746,9 @@ ENDPROC(aesni_gcm_dec_avx_gen2)
=20
 .macro INITIAL_BLOCKS_AVX2 REP num_initial_blocks T1 T2 T3 T4 T5 CTR XMM1 =
XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 T6 T_key ENC_DEC VER
 	i =3D (8-\num_initial_blocks)
-	j =3D 0
 	setreg
+        vmovdqu AadHash(arg2), reg_i
=20
-	mov     arg7, %r10                       # r10 =3D AAD
-	mov     arg8, %r12                       # r12 =3D aadLen
-
-
-	mov     %r12, %r11
-
-	vpxor   reg_j, reg_j, reg_j
-	vpxor   reg_i, reg_i, reg_i
-
-	cmp     $16, %r11
-	jl      _get_AAD_rest8\@
-_get_AAD_blocks\@:
-	vmovdqu (%r10), reg_i
-	vpshufb SHUF_MASK(%rip), reg_i, reg_i
-	vpxor   reg_i, reg_j, reg_j
-	GHASH_MUL_AVX2      reg_j, \T2, \T1, \T3, \T4, \T5, \T6
-	add     $16, %r10
-	sub     $16, %r12
-	sub     $16, %r11
-	cmp     $16, %r11
-	jge     _get_AAD_blocks\@
-	vmovdqu reg_j, reg_i
-	cmp     $0, %r11
-	je      _get_AAD_done\@
-
-	vpxor   reg_i, reg_i, reg_i
-
-	/* read the last <16B of AAD. since we have at least 4B of
-	data right after the AAD (the ICV, and maybe some CT), we can
-	read 4B/8B blocks safely, and then get rid of the extra stuff */
-_get_AAD_rest8\@:
-	cmp     $4, %r11
-	jle     _get_AAD_rest4\@
-	movq    (%r10), \T1
-	add     $8, %r10
-	sub     $8, %r11
-	vpslldq $8, \T1, \T1
-	vpsrldq $8, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-	jmp     _get_AAD_rest8\@
-_get_AAD_rest4\@:
-	cmp     $0, %r11
-	jle     _get_AAD_rest0\@
-	mov     (%r10), %eax
-	movq    %rax, \T1
-	add     $4, %r10
-	sub     $4, %r11
-	vpslldq $12, \T1, \T1
-	vpsrldq $4, reg_i, reg_i
-	vpxor   \T1, reg_i, reg_i
-_get_AAD_rest0\@:
-	/* finalize: shift out the extra bytes we read, and align
-	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq    %r12, %r11
-	salq    $4, %r11
-	movdqu  aad_shift_arr(%r11), \T1
-	vpshufb \T1, reg_i, reg_i
-_get_AAD_rest_final\@:
-	vpshufb SHUF_MASK(%rip), reg_i, reg_i
-	vpxor   reg_j, reg_i, reg_i
-	GHASH_MUL_AVX2      reg_i, \T2, \T1, \T3, \T4, \T5, \T6
-
-_get_AAD_done\@:
 	# initialize the data pointer offset as zero
 	xor     %r11d, %r11d
=20
@@ -2581,8 +2537,13 @@ _initial_blocks_done\@:
 #void   aesni_gcm_precomp_avx_gen4
 #        (gcm_data     *my_ctx_data,
 #         gcm_context_data *data,
-#        u8     *hash_subkey)# /* H, the Hash sub key input.
-#				Data starts on a 16-byte boundary. */
+#        u8     *hash_subkey# /* H, the Hash sub key input. Data starts on=
 a 16-byte boundary. */
+#        u8      *iv, /* Pre-counter block j0: 4 byte salt
+#			(from Security Association) concatenated with 8 byte
+#			Initialisation Vector (from IPSec ESP Payload)
+#			concatenated with 0x00000001. 16-byte aligned pointer. */
+#        const   u8 *aad, /* Additional Authentication Data (AAD)*/
+#        u64     aad_len) /* Length of AAD in bytes. With RFC4106 this is =
going to be 8 or 12 Bytes */
 #############################################################
 ENTRY(aesni_gcm_precomp_avx_gen4)
         FUNC_SAVE
@@ -2606,6 +2567,7 @@ ENTRY(aesni_gcm_precomp_avx_gen4)
         ##################################################################=
#####
         vmovdqu  %xmm6, HashKey(arg2)         # store HashKey<<1 mod poly
=20
+        CALC_AAD_HASH GHASH_MUL_AVX2, arg5, arg6, %xmm2, %xmm6, %xmm3, %xm=
m4, %xmm5, %xmm7, %xmm1, %xmm0
=20
         PRECOMPUTE_AVX2  %xmm6, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5
=20
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-int=
el_glue.c
index 7d1259feb0f9..2648842f1c3f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -189,7 +189,10 @@ asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, =
u8 *iv,
  */
 asmlinkage void aesni_gcm_precomp_avx_gen2(void *my_ctx_data,
 					   struct gcm_context_data *gdata,
-					   u8 *hash_subkey);
+					   u8 *hash_subkey,
+					   u8 *iv,
+					   const u8 *aad,
+					   unsigned long aad_len);
=20
 asmlinkage void aesni_gcm_enc_avx_gen2(void *ctx,
 				struct gcm_context_data *gdata, u8 *out,
@@ -214,7 +217,8 @@ static void aesni_gcm_enc_avx(void *ctx,
 			plaintext_len, iv, hash_subkey, aad,
 			aad_len, auth_tag, auth_tag_len);
 	} else {
-		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey);
+		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey, iv,
+					   aad, aad_len);
 		aesni_gcm_enc_avx_gen2(ctx, data, out, in, plaintext_len, iv,
 				       aad, aad_len, auth_tag, auth_tag_len);
 	}
@@ -231,7 +235,8 @@ static void aesni_gcm_dec_avx(void *ctx,
 			ciphertext_len, iv, hash_subkey, aad,
 			aad_len, auth_tag, auth_tag_len);
 	} else {
-		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey);
+		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey, iv,
+					   aad, aad_len);
 		aesni_gcm_dec_avx_gen2(ctx, data, out, in, ciphertext_len, iv,
 				       aad, aad_len, auth_tag, auth_tag_len);
 	}
@@ -246,7 +251,10 @@ static void aesni_gcm_dec_avx(void *ctx,
  */
 asmlinkage void aesni_gcm_precomp_avx_gen4(void *my_ctx_data,
 					   struct gcm_context_data *gdata,
-					   u8 *hash_subkey);
+					   u8 *hash_subkey,
+					   u8 *iv,
+					   const u8 *aad,
+					   unsigned long aad_len);
=20
 asmlinkage void aesni_gcm_enc_avx_gen4(void *ctx,
 				struct gcm_context_data *gdata, u8 *out,
@@ -271,11 +279,13 @@ static void aesni_gcm_enc_avx2(void *ctx,
 			      plaintext_len, iv, hash_subkey, aad,
 			      aad_len, auth_tag, auth_tag_len);
 	} else if (plaintext_len < AVX_GEN4_OPTSIZE) {
-		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey);
+		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey, iv,
+					   aad, aad_len);
 		aesni_gcm_enc_avx_gen2(ctx, data, out, in, plaintext_len, iv,
 				       aad, aad_len, auth_tag, auth_tag_len);
 	} else {
-		aesni_gcm_precomp_avx_gen4(ctx, data, hash_subkey);
+		aesni_gcm_precomp_avx_gen4(ctx, data, hash_subkey, iv,
+					   aad, aad_len);
 		aesni_gcm_enc_avx_gen4(ctx, data, out, in, plaintext_len, iv,
 				       aad, aad_len, auth_tag, auth_tag_len);
 	}
@@ -292,11 +302,13 @@ static void aesni_gcm_dec_avx2(void *ctx,
 			      ciphertext_len, iv, hash_subkey,
 			      aad, aad_len, auth_tag, auth_tag_len);
 	} else if (ciphertext_len < AVX_GEN4_OPTSIZE) {
-		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey);
+		aesni_gcm_precomp_avx_gen2(ctx, data, hash_subkey, iv,
+					   aad, aad_len);
 		aesni_gcm_dec_avx_gen2(ctx, data, out, in, ciphertext_len, iv,
 				       aad, aad_len, auth_tag, auth_tag_len);
 	} else {
-		aesni_gcm_precomp_avx_gen4(ctx, data, hash_subkey);
+		aesni_gcm_precomp_avx_gen4(ctx, data, hash_subkey, iv,
+					   aad, aad_len);
 		aesni_gcm_dec_avx_gen4(ctx, data, out, in, ciphertext_len, iv,
 				       aad, aad_len, auth_tag, auth_tag_len);
 	}
--=20
2.17.1
