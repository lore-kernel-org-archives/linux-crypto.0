From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 13/14] x86/crypto: aesni: Introduce scatter/gather asm
 function stubs
Date: Mon, 12 Feb 2018 11:51:14 -0800
Message-ID: <20180212195114.GA61055@davejwatson-mba.local>
References: <cover.1518211765.git.davejwatson@fb.com>
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
In-Reply-To: <cover.1518211765.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The asm macros are all set up now, introduce entry points.

GCM_INIT and GCM_COMPLETE have arguments supplied, so that
the new scatter/gather entry points don't have to take all the
arguments, and only the ones they need.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S  | 116 ++++++++++++++++++++++++++++---------
 arch/x86/crypto/aesni-intel_glue.c |  16 +++++
 2 files changed, 106 insertions(+), 26 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index b941952..311b2de 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -200,8 +200,8 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 # Output: HashKeys stored in gcm_context_data.  Only needs to be called
 # once per key.
 # clobbers r12, and tmp xmm registers.
-.macro PRECOMPUTE TMP1 TMP2 TMP3 TMP4 TMP5 TMP6 TMP7
-	mov	arg7, %r12
+.macro PRECOMPUTE SUBKEY TMP1 TMP2 TMP3 TMP4 TMP5 TMP6 TMP7
+	mov	\SUBKEY, %r12
 	movdqu	(%r12), \TMP3
 	movdqa	SHUF_MASK(%rip), \TMP2
 	PSHUFB_XMM \TMP2, \TMP3
@@ -254,14 +254,14 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 
 # GCM_INIT initializes a gcm_context struct to prepare for encoding/decoding.
 # Clobbers rax, r10-r13 and xmm0-xmm6, %xmm13
-.macro GCM_INIT
-	mov arg9, %r11
+.macro GCM_INIT Iv SUBKEY AAD AADLEN
+	mov \AADLEN, %r11
 	mov %r11, AadLen(%arg2) # ctx_data.aad_length = aad_length
 	xor %r11, %r11
 	mov %r11, InLen(%arg2) # ctx_data.in_length = 0
 	mov %r11, PBlockLen(%arg2) # ctx_data.partial_block_length = 0
 	mov %r11, PBlockEncKey(%arg2) # ctx_data.partial_block_enc_key = 0
-	mov %arg6, %rax
+	mov \Iv, %rax
 	movdqu (%rax), %xmm0
 	movdqu %xmm0, OrigIV(%arg2) # ctx_data.orig_IV = iv
 
@@ -269,11 +269,11 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	PSHUFB_XMM %xmm2, %xmm0
 	movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
 
-	PRECOMPUTE %xmm1 %xmm2 %xmm3 %xmm4 %xmm5 %xmm6 %xmm7
+	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 	movdqa HashKey(%arg2), %xmm13
 
-	CALC_AAD_HASH %xmm13 %xmm0 %xmm1 %xmm2 %xmm3 %xmm4 \
-	%xmm5 %xmm6
+	CALC_AAD_HASH %xmm13, \AAD, \AADLEN, %xmm0, %xmm1, %xmm2, %xmm3, \
+	%xmm4, %xmm5, %xmm6
 .endm
 
 # GCM_ENC_DEC Encodes/Decodes given data. Assumes that the passed gcm_context
@@ -435,7 +435,7 @@ _multiple_of_16_bytes_\@:
 # GCM_COMPLETE Finishes update of tag of last partial block
 # Output: Authorization Tag (AUTH_TAG)
 # Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
-.macro GCM_COMPLETE
+.macro GCM_COMPLETE AUTHTAG AUTHTAGLEN
 	movdqu AadHash(%arg2), %xmm8
 	movdqu HashKey(%arg2), %xmm13
 
@@ -466,8 +466,8 @@ _partial_done\@:
 	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
 	pxor	%xmm8, %xmm0
 _return_T_\@:
-	mov	arg10, %r10                     # %r10 = authTag
-	mov	arg11, %r11                    # %r11 = auth_tag_len
+	mov	\AUTHTAG, %r10                     # %r10 = authTag
+	mov	\AUTHTAGLEN, %r11                    # %r11 = auth_tag_len
 	cmp	$16, %r11
 	je	_T_16_\@
 	cmp	$8, %r11
@@ -599,11 +599,11 @@ _done_read_partial_block_\@:
 
 # CALC_AAD_HASH: Calculates the hash of the data which will not be encrypted.
 # clobbers r10-11, xmm14
-.macro CALC_AAD_HASH HASHKEY TMP1 TMP2 TMP3 TMP4 TMP5 \
+.macro CALC_AAD_HASH HASHKEY AAD AADLEN TMP1 TMP2 TMP3 TMP4 TMP5 \
 	TMP6 TMP7
 	MOVADQ	   SHUF_MASK(%rip), %xmm14
-	mov	   arg8, %r10		# %r10 = AAD
-	mov	   arg9, %r11		# %r11 = aadLen
+	mov	   \AAD, %r10		# %r10 = AAD
+	mov	   \AADLEN, %r11		# %r11 = aadLen
 	pxor	   \TMP7, \TMP7
 	pxor	   \TMP6, \TMP6
 
@@ -1103,18 +1103,18 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	mov	  keysize,%eax
 	shr	  $2,%eax			# 128->4, 192->6, 256->8
 	sub	  $4,%eax			# 128->0, 192->2, 256->4
-	jz	  aes_loop_par_enc_done
+	jz	  aes_loop_par_enc_done\@
 
-aes_loop_par_enc:
+aes_loop_par_enc\@:
 	MOVADQ	  (%r10),\TMP3
 .irpc	index, 1234
 	AESENC	  \TMP3, %xmm\index
 .endr
 	add	  $16,%r10
 	sub	  $1,%eax
-	jnz	  aes_loop_par_enc
+	jnz	  aes_loop_par_enc\@
 
-aes_loop_par_enc_done:
+aes_loop_par_enc_done\@:
 	MOVADQ	  (%r10), \TMP3
 	AESENCLAST \TMP3, \XMM1           # Round 10
 	AESENCLAST \TMP3, \XMM2
@@ -1311,18 +1311,18 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	mov	  keysize,%eax
 	shr	  $2,%eax		        # 128->4, 192->6, 256->8
 	sub	  $4,%eax			# 128->0, 192->2, 256->4
-	jz	  aes_loop_par_dec_done
+	jz	  aes_loop_par_dec_done\@
 
-aes_loop_par_dec:
+aes_loop_par_dec\@:
 	MOVADQ	  (%r10),\TMP3
 .irpc	index, 1234
 	AESENC	  \TMP3, %xmm\index
 .endr
 	add	  $16,%r10
 	sub	  $1,%eax
-	jnz	  aes_loop_par_dec
+	jnz	  aes_loop_par_dec\@
 
-aes_loop_par_dec_done:
+aes_loop_par_dec_done\@:
 	MOVADQ	  (%r10), \TMP3
 	AESENCLAST \TMP3, \XMM1           # last round
 	AESENCLAST \TMP3, \XMM2
@@ -1598,9 +1598,9 @@ _esb_loop_\@:
 ENTRY(aesni_gcm_dec)
 	FUNC_SAVE
 
-	GCM_INIT
+	GCM_INIT %arg6, arg7, arg8, arg9
 	GCM_ENC_DEC dec
-	GCM_COMPLETE
+	GCM_COMPLETE arg10, arg11
 	FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_dec)
@@ -1686,13 +1686,77 @@ ENDPROC(aesni_gcm_dec)
 ENTRY(aesni_gcm_enc)
 	FUNC_SAVE
 
-	GCM_INIT
+	GCM_INIT %arg6, arg7, arg8, arg9
 	GCM_ENC_DEC enc
-	GCM_COMPLETE
+
+	GCM_COMPLETE arg10, arg11
 	FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_enc)
 
+/*****************************************************************************
+* void aesni_gcm_init(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
+*                     struct gcm_context_data *data,
+*                                         // context data
+*                     u8 *iv,             // Pre-counter block j0: 4 byte salt (from Security Association)
+*                                         // concatenated with 8 byte Initialisation Vector (from IPSec ESP Payload)
+*                                         // concatenated with 0x00000001. 16-byte aligned pointer.
+*                     u8 *hash_subkey,    // H, the Hash sub key input. Data starts on a 16-byte boundary.
+*                     const u8 *aad,      // Additional Authentication Data (AAD)
+*                     u64 aad_len)        // Length of AAD in bytes.
+*/
+ENTRY(aesni_gcm_init)
+	FUNC_SAVE
+	GCM_INIT %arg3, %arg4,%arg5, %arg6
+	FUNC_RESTORE
+	ret
+ENDPROC(aesni_gcm_init)
+
+/*****************************************************************************
+* void aesni_gcm_enc_update(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
+*                    struct gcm_context_data *data,
+*                                        // context data
+*                    u8 *out,            // Ciphertext output. Encrypt in-place is allowed.
+*                    const u8 *in,       // Plaintext input
+*                    u64 plaintext_len,  // Length of data in bytes for encryption.
+*/
+ENTRY(aesni_gcm_enc_update)
+	FUNC_SAVE
+	GCM_ENC_DEC enc
+	FUNC_RESTORE
+	ret
+ENDPROC(aesni_gcm_enc_update)
+
+/*****************************************************************************
+* void aesni_gcm_dec_update(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
+*                    struct gcm_context_data *data,
+*                                        // context data
+*                    u8 *out,            // Ciphertext output. Encrypt in-place is allowed.
+*                    const u8 *in,       // Plaintext input
+*                    u64 plaintext_len,  // Length of data in bytes for encryption.
+*/
+ENTRY(aesni_gcm_dec_update)
+	FUNC_SAVE
+	GCM_ENC_DEC dec
+	FUNC_RESTORE
+	ret
+ENDPROC(aesni_gcm_dec_update)
+
+/*****************************************************************************
+* void aesni_gcm_finalize(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
+*                    struct gcm_context_data *data,
+*                                        // context data
+*                    u8 *auth_tag,       // Authenticated Tag output.
+*                    u64 auth_tag_len);  // Authenticated Tag Length in bytes. Valid values are 16 (most likely),
+*                                        // 12 or 8.
+*/
+ENTRY(aesni_gcm_finalize)
+	FUNC_SAVE
+	GCM_COMPLETE %arg3 %arg4
+	FUNC_RESTORE
+	ret
+ENDPROC(aesni_gcm_finalize)
+
 #endif
 
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 4dd5b9b..de986f9 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -161,6 +161,22 @@ asmlinkage void aesni_gcm_dec(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
+/* Scatter / Gather routines, with args similar to above */
+asmlinkage void aesni_gcm_init(void *ctx,
+			       struct gcm_context_data *gdata,
+			       u8 *iv,
+			       u8 *hash_subkey, const u8 *aad,
+			       unsigned long aad_len);
+asmlinkage void aesni_gcm_enc_update(void *ctx,
+				     struct gcm_context_data *gdata, u8 *out,
+				     const u8 *in, unsigned long plaintext_len);
+asmlinkage void aesni_gcm_dec_update(void *ctx,
+				     struct gcm_context_data *gdata, u8 *out,
+				     const u8 *in,
+				     unsigned long ciphertext_len);
+asmlinkage void aesni_gcm_finalize(void *ctx,
+				   struct gcm_context_data *gdata,
+				   u8 *auth_tag, unsigned long auth_tag_len);
 
 #ifdef CONFIG_AS_AVX
 asmlinkage void aes_ctr_enc_128_avx_by8(const u8 *in, u8 *iv,
-- 
2.9.5
