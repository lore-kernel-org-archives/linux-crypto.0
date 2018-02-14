From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 06/14] x86/crypto: aesni: Introduce gcm_context_data
Date: Wed, 14 Feb 2018 09:39:23 -0800
Message-ID: <20180214173923.GA61995@davejwatson-mba>
References: <cover.1518628278.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Sabrina Dubroca" <sd@queasysnail.net>,
        <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1161212AbeBNRkO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 12:40:14 -0500
Content-Disposition: inline
In-Reply-To: <cover.1518628278.git.davejwatson@fb.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce a gcm_context_data struct that will be used to pass
context data between scatter/gather update calls.  It is passed
as the second argument (after crypto keys), other args are
renumbered.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S  | 115 +++++++++++++++++++++----------------
 arch/x86/crypto/aesni-intel_glue.c |  81 ++++++++++++++++++--------
 2 files changed, 121 insertions(+), 75 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 8021fd1..6c5a80d 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -111,6 +111,14 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 				// (for Karatsuba purposes)
 #define	VARIABLE_OFFSET	16*8
 
+#define AadHash 16*0
+#define AadLen 16*1
+#define InLen (16*1)+8
+#define PBlockEncKey 16*2
+#define OrigIV 16*3
+#define CurCount 16*4
+#define PBlockLen 16*5
+
 #define arg1 rdi
 #define arg2 rsi
 #define arg3 rdx
@@ -121,6 +129,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 #define arg8 STACK_OFFSET+16(%r14)
 #define arg9 STACK_OFFSET+24(%r14)
 #define arg10 STACK_OFFSET+32(%r14)
+#define arg11 STACK_OFFSET+40(%r14)
 #define keysize 2*15*16(%arg1)
 #endif
 
@@ -195,9 +204,9 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 # GCM_INIT initializes a gcm_context struct to prepare for encoding/decoding.
 # Clobbers rax, r10-r13 and xmm0-xmm6, %xmm13
 .macro GCM_INIT
-	mov	%arg6, %r12
+	mov	arg7, %r12
 	movdqu	(%r12), %xmm13
-	movdqa  SHUF_MASK(%rip), %xmm2
+	movdqa	SHUF_MASK(%rip), %xmm2
 	PSHUFB_XMM %xmm2, %xmm13
 
 	# precompute HashKey<<1 mod poly from the HashKey (required for GHASH)
@@ -217,7 +226,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	pand	POLY(%rip), %xmm2
 	pxor	%xmm2, %xmm13
 	movdqa	%xmm13, HashKey(%rsp)
-	mov	%arg4, %r13			# %xmm13 holds HashKey<<1 (mod poly)
+	mov	%arg5, %r13		# %xmm13 holds HashKey<<1 (mod poly)
 	and	$-16, %r13
 	mov	%r13, %r12
 .endm
@@ -271,18 +280,18 @@ _four_cipher_left_\@:
 	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, \
 %xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
 _zero_cipher_left_\@:
-	mov	%arg4, %r13
-	and	$15, %r13			# %r13 = arg4 (mod 16)
+	mov	%arg5, %r13
+	and	$15, %r13			# %r13 = arg5 (mod 16)
 	je	_multiple_of_16_bytes_\@
 
 	# Handle the last <16 Byte block separately
 	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
-        movdqa SHUF_MASK(%rip), %xmm10
+	movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm0
 
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
 
-	lea (%arg3,%r11,1), %r10
+	lea (%arg4,%r11,1), %r10
 	mov %r13, %r12
 	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
 
@@ -320,13 +329,13 @@ _zero_cipher_left_\@:
 	MOVQ_R64_XMM %xmm0, %rax
 	cmp $8, %r13
 	jle _less_than_8_bytes_left_\@
-	mov %rax, (%arg2 , %r11, 1)
+	mov %rax, (%arg3 , %r11, 1)
 	add $8, %r11
 	psrldq $8, %xmm0
 	MOVQ_R64_XMM %xmm0, %rax
 	sub $8, %r13
 _less_than_8_bytes_left_\@:
-	mov %al,  (%arg2, %r11, 1)
+	mov %al,  (%arg3, %r11, 1)
 	add $1, %r11
 	shr $8, %rax
 	sub $1, %r13
@@ -338,11 +347,11 @@ _multiple_of_16_bytes_\@:
 # Output: Authorization Tag (AUTH_TAG)
 # Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
 .macro GCM_COMPLETE
-	mov	arg8, %r12		  # %r13 = aadLen (number of bytes)
+	mov	arg9, %r12		  # %r13 = aadLen (number of bytes)
 	shl	$3, %r12		  # convert into number of bits
 	movd	%r12d, %xmm15		  # len(A) in %xmm15
-	shl	$3, %arg4		  # len(C) in bits (*128)
-	MOVQ_R64_XMM	%arg4, %xmm1
+	shl	$3, %arg5		  # len(C) in bits (*128)
+	MOVQ_R64_XMM	%arg5, %xmm1
 	pslldq	$8, %xmm15		  # %xmm15 = len(A)||0x0000000000000000
 	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
 	pxor	%xmm15, %xmm8
@@ -351,13 +360,13 @@ _multiple_of_16_bytes_\@:
 	movdqa SHUF_MASK(%rip), %xmm10
 	PSHUFB_XMM %xmm10, %xmm8
 
-	mov	%arg5, %rax		  # %rax = *Y0
+	mov	%arg6, %rax		  # %rax = *Y0
 	movdqu	(%rax), %xmm0		  # %xmm0 = Y0
 	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
 	pxor	%xmm8, %xmm0
 _return_T_\@:
-	mov	arg9, %r10                     # %r10 = authTag
-	mov	arg10, %r11                    # %r11 = auth_tag_len
+	mov	arg10, %r10                     # %r10 = authTag
+	mov	arg11, %r11                    # %r11 = auth_tag_len
 	cmp	$16, %r11
 	je	_T_16_\@
 	cmp	$8, %r11
@@ -495,15 +504,15 @@ _done_read_partial_block_\@:
 * the ciphertext
 * %r10, %r11, %r12, %rax, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9 registers
 * are clobbered
-* arg1, %arg2, %arg3, %r14 are used as a pointer only, not modified
+* arg1, %arg3, %arg4, %r14 are used as a pointer only, not modified
 */
 
 
 .macro INITIAL_BLOCKS_ENC_DEC TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
 XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
         MOVADQ     SHUF_MASK(%rip), %xmm14
-	mov	   arg7, %r10           # %r10 = AAD
-	mov	   arg8, %r11           # %r11 = aadLen
+	mov	   arg8, %r10           # %r10 = AAD
+	mov	   arg9, %r11           # %r11 = aadLen
 	pxor	   %xmm\i, %xmm\i
 	pxor	   \XMM2, \XMM2
 
@@ -535,7 +544,7 @@ _get_AAD_done\@:
 	xor	   %r11, %r11 # initialise the data pointer offset as zero
 	# start AES for num_initial_blocks blocks
 
-	mov	   %arg5, %rax                      # %rax = *Y0
+	mov	   %arg6, %rax                      # %rax = *Y0
 	movdqu	   (%rax), \XMM0                    # XMM0 = Y0
 	PSHUFB_XMM   %xmm14, \XMM0
 
@@ -572,9 +581,9 @@ aes_loop_initial_\@:
 	AESENCLAST \TMP1, %xmm\index         # Last Round
 .endr
 .irpc index, \i_seq
-	movdqu	   (%arg3 , %r11, 1), \TMP1
+	movdqu	   (%arg4 , %r11, 1), \TMP1
 	pxor	   \TMP1, %xmm\index
-	movdqu	   %xmm\index, (%arg2 , %r11, 1)
+	movdqu	   %xmm\index, (%arg3 , %r11, 1)
 	# write back plaintext/ciphertext for num_initial_blocks
 	add	   $16, %r11
 
@@ -693,34 +702,34 @@ aes_loop_pre_done\@:
 	AESENCLAST \TMP2, \XMM2
 	AESENCLAST \TMP2, \XMM3
 	AESENCLAST \TMP2, \XMM4
-	movdqu	   16*0(%arg3 , %r11 , 1), \TMP1
+	movdqu	   16*0(%arg4 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM1
 .ifc \operation, dec
-	movdqu     \XMM1, 16*0(%arg2 , %r11 , 1)
+	movdqu     \XMM1, 16*0(%arg3 , %r11 , 1)
 	movdqa     \TMP1, \XMM1
 .endif
-	movdqu	   16*1(%arg3 , %r11 , 1), \TMP1
+	movdqu	   16*1(%arg4 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM2
 .ifc \operation, dec
-	movdqu     \XMM2, 16*1(%arg2 , %r11 , 1)
+	movdqu     \XMM2, 16*1(%arg3 , %r11 , 1)
 	movdqa     \TMP1, \XMM2
 .endif
-	movdqu	   16*2(%arg3 , %r11 , 1), \TMP1
+	movdqu	   16*2(%arg4 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM3
 .ifc \operation, dec
-	movdqu     \XMM3, 16*2(%arg2 , %r11 , 1)
+	movdqu     \XMM3, 16*2(%arg3 , %r11 , 1)
 	movdqa     \TMP1, \XMM3
 .endif
-	movdqu	   16*3(%arg3 , %r11 , 1), \TMP1
+	movdqu	   16*3(%arg4 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM4
 .ifc \operation, dec
-	movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
+	movdqu     \XMM4, 16*3(%arg3 , %r11 , 1)
 	movdqa     \TMP1, \XMM4
 .else
-	movdqu     \XMM1, 16*0(%arg2 , %r11 , 1)
-	movdqu     \XMM2, 16*1(%arg2 , %r11 , 1)
-	movdqu     \XMM3, 16*2(%arg2 , %r11 , 1)
-	movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
+	movdqu     \XMM1, 16*0(%arg3 , %r11 , 1)
+	movdqu     \XMM2, 16*1(%arg3 , %r11 , 1)
+	movdqu     \XMM3, 16*2(%arg3 , %r11 , 1)
+	movdqu     \XMM4, 16*3(%arg3 , %r11 , 1)
 .endif
 
 	add	   $64, %r11
@@ -738,7 +747,7 @@ _initial_blocks_done\@:
 /*
 * encrypt 4 blocks at a time
 * ghash the 4 previously encrypted ciphertext blocks
-* arg1, %arg2, %arg3 are used as pointers only, not modified
+* arg1, %arg3, %arg4 are used as pointers only, not modified
 * %r11 is the data offset value
 */
 .macro GHASH_4_ENCRYPT_4_PARALLEL_ENC TMP1 TMP2 TMP3 TMP4 TMP5 \
@@ -882,18 +891,18 @@ aes_loop_par_enc_done:
 	AESENCLAST \TMP3, \XMM4
 	movdqa    HashKey_k(%rsp), \TMP5
 	PCLMULQDQ 0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
-	movdqu	  (%arg3,%r11,1), \TMP3
+	movdqu	  (%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
-	movdqu	  16(%arg3,%r11,1), \TMP3
+	movdqu	  16(%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM2                 # Ciphertext/Plaintext XOR EK
-	movdqu	  32(%arg3,%r11,1), \TMP3
+	movdqu	  32(%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM3                 # Ciphertext/Plaintext XOR EK
-	movdqu	  48(%arg3,%r11,1), \TMP3
+	movdqu	  48(%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM4                 # Ciphertext/Plaintext XOR EK
-        movdqu    \XMM1, (%arg2,%r11,1)        # Write to the ciphertext buffer
-        movdqu    \XMM2, 16(%arg2,%r11,1)      # Write to the ciphertext buffer
-        movdqu    \XMM3, 32(%arg2,%r11,1)      # Write to the ciphertext buffer
-        movdqu    \XMM4, 48(%arg2,%r11,1)      # Write to the ciphertext buffer
+        movdqu    \XMM1, (%arg3,%r11,1)        # Write to the ciphertext buffer
+        movdqu    \XMM2, 16(%arg3,%r11,1)      # Write to the ciphertext buffer
+        movdqu    \XMM3, 32(%arg3,%r11,1)      # Write to the ciphertext buffer
+        movdqu    \XMM4, 48(%arg3,%r11,1)      # Write to the ciphertext buffer
 	PSHUFB_XMM %xmm15, \XMM1        # perform a 16 byte swap
 	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
 	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
@@ -946,7 +955,7 @@ aes_loop_par_enc_done:
 /*
 * decrypt 4 blocks at a time
 * ghash the 4 previously decrypted ciphertext blocks
-* arg1, %arg2, %arg3 are used as pointers only, not modified
+* arg1, %arg3, %arg4 are used as pointers only, not modified
 * %r11 is the data offset value
 */
 .macro GHASH_4_ENCRYPT_4_PARALLEL_DEC TMP1 TMP2 TMP3 TMP4 TMP5 \
@@ -1090,21 +1099,21 @@ aes_loop_par_dec_done:
 	AESENCLAST \TMP3, \XMM4
 	movdqa    HashKey_k(%rsp), \TMP5
 	PCLMULQDQ 0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
-	movdqu	  (%arg3,%r11,1), \TMP3
+	movdqu	  (%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
-	movdqu	  \XMM1, (%arg2,%r11,1)        # Write to plaintext buffer
+	movdqu	  \XMM1, (%arg3,%r11,1)        # Write to plaintext buffer
 	movdqa    \TMP3, \XMM1
-	movdqu	  16(%arg3,%r11,1), \TMP3
+	movdqu	  16(%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM2                 # Ciphertext/Plaintext XOR EK
-	movdqu	  \XMM2, 16(%arg2,%r11,1)      # Write to plaintext buffer
+	movdqu	  \XMM2, 16(%arg3,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM2
-	movdqu	  32(%arg3,%r11,1), \TMP3
+	movdqu	  32(%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM3                 # Ciphertext/Plaintext XOR EK
-	movdqu	  \XMM3, 32(%arg2,%r11,1)      # Write to plaintext buffer
+	movdqu	  \XMM3, 32(%arg3,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM3
-	movdqu	  48(%arg3,%r11,1), \TMP3
+	movdqu	  48(%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM4                 # Ciphertext/Plaintext XOR EK
-	movdqu	  \XMM4, 48(%arg2,%r11,1)      # Write to plaintext buffer
+	movdqu	  \XMM4, 48(%arg3,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM4
 	PSHUFB_XMM %xmm15, \XMM1        # perform a 16 byte swap
 	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
@@ -1277,6 +1286,8 @@ _esb_loop_\@:
 .endm
 /*****************************************************************************
 * void aesni_gcm_dec(void *aes_ctx,    // AES Key schedule. Starts on a 16 byte boundary.
+*                   struct gcm_context_data *data
+*                                      // Context data
 *                   u8 *out,           // Plaintext output. Encrypt in-place is allowed.
 *                   const u8 *in,      // Ciphertext input
 *                   u64 plaintext_len, // Length of data in bytes for decryption.
@@ -1366,6 +1377,8 @@ ENDPROC(aesni_gcm_dec)
 
 /*****************************************************************************
 * void aesni_gcm_enc(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
+*                    struct gcm_context_data *data
+*                                        // Context data
 *                    u8 *out,            // Ciphertext output. Encrypt in-place is allowed.
 *                    const u8 *in,       // Plaintext input
 *                    u64 plaintext_len,  // Length of data in bytes for encryption.
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 34cf1c1..4dd5b9b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -72,6 +72,21 @@ struct aesni_xts_ctx {
 	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx)] AESNI_ALIGN_ATTR;
 };
 
+#define GCM_BLOCK_LEN 16
+
+struct gcm_context_data {
+	/* init, update and finalize context data */
+	u8 aad_hash[GCM_BLOCK_LEN];
+	u64 aad_length;
+	u64 in_length;
+	u8 partial_block_enc_key[GCM_BLOCK_LEN];
+	u8 orig_IV[GCM_BLOCK_LEN];
+	u8 current_counter[GCM_BLOCK_LEN];
+	u64 partial_block_len;
+	u64 unused;
+	u8 hash_keys[GCM_BLOCK_LEN * 8];
+};
+
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
 asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
@@ -105,6 +120,7 @@ asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
 
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
+ * struct gcm_context_data.  May be uninitialized.
  * u8 *out, Ciphertext output. Encrypt in-place is allowed.
  * const u8 *in, Plaintext input
  * unsigned long plaintext_len, Length of data in bytes for encryption.
@@ -117,13 +133,15 @@ asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
  * unsigned long auth_tag_len), Authenticated Tag Length in bytes.
  *          Valid values are 16 (most likely), 12 or 8.
  */
-asmlinkage void aesni_gcm_enc(void *ctx, u8 *out,
+asmlinkage void aesni_gcm_enc(void *ctx,
+			struct gcm_context_data *gdata, u8 *out,
 			const u8 *in, unsigned long plaintext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
 /* asmlinkage void aesni_gcm_dec()
  * void *ctx, AES Key schedule. Starts on a 16 byte boundary.
+ * struct gcm_context_data.  May be uninitialized.
  * u8 *out, Plaintext output. Decrypt in-place is allowed.
  * const u8 *in, Ciphertext input
  * unsigned long ciphertext_len, Length of data in bytes for decryption.
@@ -137,7 +155,8 @@ asmlinkage void aesni_gcm_enc(void *ctx, u8 *out,
  * unsigned long auth_tag_len) Authenticated Tag Length in bytes.
  * Valid values are 16 (most likely), 12 or 8.
  */
-asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
+asmlinkage void aesni_gcm_dec(void *ctx,
+			struct gcm_context_data *gdata, u8 *out,
 			const u8 *in, unsigned long ciphertext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
@@ -167,15 +186,17 @@ asmlinkage void aesni_gcm_dec_avx_gen2(void *ctx, u8 *out,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-static void aesni_gcm_enc_avx(void *ctx, u8 *out,
+static void aesni_gcm_enc_avx(void *ctx,
+			struct gcm_context_data *data, u8 *out,
 			const u8 *in, unsigned long plaintext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
         struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
 	if ((plaintext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)){
-		aesni_gcm_enc(ctx, out, in, plaintext_len, iv, hash_subkey, aad,
-				aad_len, auth_tag, auth_tag_len);
+		aesni_gcm_enc(ctx, data, out, in,
+			plaintext_len, iv, hash_subkey, aad,
+			aad_len, auth_tag, auth_tag_len);
 	} else {
 		aesni_gcm_precomp_avx_gen2(ctx, hash_subkey);
 		aesni_gcm_enc_avx_gen2(ctx, out, in, plaintext_len, iv, aad,
@@ -183,15 +204,17 @@ static void aesni_gcm_enc_avx(void *ctx, u8 *out,
 	}
 }
 
-static void aesni_gcm_dec_avx(void *ctx, u8 *out,
+static void aesni_gcm_dec_avx(void *ctx,
+			struct gcm_context_data *data, u8 *out,
 			const u8 *in, unsigned long ciphertext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
         struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
 	if ((ciphertext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)) {
-		aesni_gcm_dec(ctx, out, in, ciphertext_len, iv, hash_subkey, aad,
-				aad_len, auth_tag, auth_tag_len);
+		aesni_gcm_dec(ctx, data, out, in,
+			ciphertext_len, iv, hash_subkey, aad,
+			aad_len, auth_tag, auth_tag_len);
 	} else {
 		aesni_gcm_precomp_avx_gen2(ctx, hash_subkey);
 		aesni_gcm_dec_avx_gen2(ctx, out, in, ciphertext_len, iv, aad,
@@ -218,15 +241,17 @@ asmlinkage void aesni_gcm_dec_avx_gen4(void *ctx, u8 *out,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-static void aesni_gcm_enc_avx2(void *ctx, u8 *out,
+static void aesni_gcm_enc_avx2(void *ctx,
+			struct gcm_context_data *data, u8 *out,
 			const u8 *in, unsigned long plaintext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
        struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
 	if ((plaintext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)) {
-		aesni_gcm_enc(ctx, out, in, plaintext_len, iv, hash_subkey, aad,
-				aad_len, auth_tag, auth_tag_len);
+		aesni_gcm_enc(ctx, data, out, in,
+			      plaintext_len, iv, hash_subkey, aad,
+			      aad_len, auth_tag, auth_tag_len);
 	} else if (plaintext_len < AVX_GEN4_OPTSIZE) {
 		aesni_gcm_precomp_avx_gen2(ctx, hash_subkey);
 		aesni_gcm_enc_avx_gen2(ctx, out, in, plaintext_len, iv, aad,
@@ -238,15 +263,17 @@ static void aesni_gcm_enc_avx2(void *ctx, u8 *out,
 	}
 }
 
-static void aesni_gcm_dec_avx2(void *ctx, u8 *out,
+static void aesni_gcm_dec_avx2(void *ctx,
+	struct gcm_context_data *data, u8 *out,
 			const u8 *in, unsigned long ciphertext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len)
 {
        struct crypto_aes_ctx *aes_ctx = (struct crypto_aes_ctx*)ctx;
 	if ((ciphertext_len < AVX_GEN2_OPTSIZE) || (aes_ctx-> key_length != AES_KEYSIZE_128)) {
-		aesni_gcm_dec(ctx, out, in, ciphertext_len, iv, hash_subkey,
-				aad, aad_len, auth_tag, auth_tag_len);
+		aesni_gcm_dec(ctx, data, out, in,
+			      ciphertext_len, iv, hash_subkey,
+			      aad, aad_len, auth_tag, auth_tag_len);
 	} else if (ciphertext_len < AVX_GEN4_OPTSIZE) {
 		aesni_gcm_precomp_avx_gen2(ctx, hash_subkey);
 		aesni_gcm_dec_avx_gen2(ctx, out, in, ciphertext_len, iv, aad,
@@ -259,15 +286,19 @@ static void aesni_gcm_dec_avx2(void *ctx, u8 *out,
 }
 #endif
 
-static void (*aesni_gcm_enc_tfm)(void *ctx, u8 *out,
-			const u8 *in, unsigned long plaintext_len, u8 *iv,
-			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
+static void (*aesni_gcm_enc_tfm)(void *ctx,
+				 struct gcm_context_data *data, u8 *out,
+				 const u8 *in, unsigned long plaintext_len,
+				 u8 *iv, u8 *hash_subkey, const u8 *aad,
+				 unsigned long aad_len, u8 *auth_tag,
+				 unsigned long auth_tag_len);
 
-static void (*aesni_gcm_dec_tfm)(void *ctx, u8 *out,
-			const u8 *in, unsigned long ciphertext_len, u8 *iv,
-			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
-			u8 *auth_tag, unsigned long auth_tag_len);
+static void (*aesni_gcm_dec_tfm)(void *ctx,
+				 struct gcm_context_data *data, u8 *out,
+				 const u8 *in, unsigned long ciphertext_len,
+				 u8 *iv, u8 *hash_subkey, const u8 *aad,
+				 unsigned long aad_len, u8 *auth_tag,
+				 unsigned long auth_tag_len);
 
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
@@ -753,6 +784,7 @@ static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
 	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	struct scatter_walk src_sg_walk;
 	struct scatter_walk dst_sg_walk = {};
+	struct gcm_context_data data AESNI_ALIGN_ATTR;
 
 	if (sg_is_last(req->src) &&
 	    (!PageHighMem(sg_page(req->src)) ||
@@ -782,7 +814,7 @@ static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
 	}
 
 	kernel_fpu_begin();
-	aesni_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
+	aesni_gcm_enc_tfm(aes_ctx, &data, dst, src, req->cryptlen, iv,
 			  hash_subkey, assoc, assoclen,
 			  dst + req->cryptlen, auth_tag_len);
 	kernel_fpu_end();
@@ -817,6 +849,7 @@ static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
 	u8 authTag[16];
 	struct scatter_walk src_sg_walk;
 	struct scatter_walk dst_sg_walk = {};
+	struct gcm_context_data data AESNI_ALIGN_ATTR;
 	int retval = 0;
 
 	tempCipherLen = (unsigned long)(req->cryptlen - auth_tag_len);
@@ -849,7 +882,7 @@ static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
 
 
 	kernel_fpu_begin();
-	aesni_gcm_dec_tfm(aes_ctx, dst, src, tempCipherLen, iv,
+	aesni_gcm_dec_tfm(aes_ctx, &data, dst, src, tempCipherLen, iv,
 			  hash_subkey, assoc, assoclen,
 			  authTag, auth_tag_len);
 	kernel_fpu_end();
-- 
2.9.5
