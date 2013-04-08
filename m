From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 5/5] crypto: aesni_intel - add more optimized XTS mode for
 x86-64
Date: Mon, 08 Apr 2013 21:51:16 +0300
Message-ID: <20130408185116.4107.51367.stgit@localhost6.localdomain6>
References: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34837 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935636Ab3DHSvT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 14:51:19 -0400
In-Reply-To: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add more optimized XTS code for aesni_intel in 64-bit mode, for smaller stack
usage and boost for speed.

tcrypt results, with Intel i5-2450M:
256-bit key
        enc     dec
16B     0.98x   0.99x
64B     0.64x   0.63x
256B    1.29x   1.32x
1024B   1.54x   1.58x
8192B   1.57x   1.60x

512-bit key
        enc     dec
16B     0.98x   0.99x
64B     0.60x   0.59x
256B    1.24x   1.25x
1024B   1.39x   1.42x
8192B   1.38x   1.42x

I chose not to optimize smaller than block size of 256 bytes, since XTS is
practically always used with data blocks of size 512 bytes. This is why
performance is reduced in tcrypt for 64 byte long blocks.

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/aesni-intel_asm.S  |  117 ++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c |   80 +++++++++++++++++++++++++
 crypto/Kconfig                     |    1 
 3 files changed, 198 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 04b7977..62fe22c 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -34,6 +34,10 @@
 
 #ifdef __x86_64__
 .data
+.align 16
+.Lgf128mul_x_ble_mask:
+	.octa 0x00000000000000010000000000000087
+
 POLY:   .octa 0xC2000000000000000000000000000001
 TWOONE: .octa 0x00000001000000000000000000000001
 
@@ -105,6 +109,8 @@ enc:        .octa 0x2
 #define CTR	%xmm11
 #define INC	%xmm12
 
+#define GF128MUL_MASK %xmm10
+
 #ifdef __x86_64__
 #define AREG	%rax
 #define KEYP	%rdi
@@ -2636,4 +2642,115 @@ ENTRY(aesni_ctr_enc)
 .Lctr_enc_just_ret:
 	ret
 ENDPROC(aesni_ctr_enc)
+
+/*
+ * _aesni_gf128mul_x_ble:		internal ABI
+ *	Multiply in GF(2^128) for XTS IVs
+ * input:
+ *	IV:	current IV
+ *	GF128MUL_MASK == mask with 0x87 and 0x01
+ * output:
+ *	IV:	next IV
+ * changed:
+ *	CTR:	== temporary value
+ */
+#define _aesni_gf128mul_x_ble() \
+	pshufd $0x13, IV, CTR; \
+	paddq IV, IV; \
+	psrad $31, CTR; \
+	pand GF128MUL_MASK, CTR; \
+	pxor CTR, IV;
+
+/*
+ * void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *			 bool enc, u8 *iv)
+ */
+ENTRY(aesni_xts_crypt8)
+	cmpb $0, %cl
+	movl $0, %ecx
+	movl $240, %r10d
+	leaq _aesni_enc4, %r11
+	leaq _aesni_dec4, %rax
+	cmovel %r10d, %ecx
+	cmoveq %rax, %r11
+
+	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(KEYP), KLEN
+	addq %rcx, KEYP
+
+	movdqa IV, STATE1
+	pxor 0x00(INP), STATE1
+	movdqu IV, 0x00(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE2
+	pxor 0x10(INP), STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE3
+	pxor 0x20(INP), STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE4
+	pxor 0x30(INP), STATE4
+	movdqu IV, 0x30(OUTP)
+
+	call *%r11
+
+	pxor 0x00(OUTP), STATE1
+	movdqu STATE1, 0x00(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE1
+	pxor 0x40(INP), STATE1
+	movdqu IV, 0x40(OUTP)
+
+	pxor 0x10(OUTP), STATE2
+	movdqu STATE2, 0x10(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE2
+	pxor 0x50(INP), STATE2
+	movdqu IV, 0x50(OUTP)
+
+	pxor 0x20(OUTP), STATE3
+	movdqu STATE3, 0x20(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE3
+	pxor 0x60(INP), STATE3
+	movdqu IV, 0x60(OUTP)
+
+	pxor 0x30(OUTP), STATE4
+	movdqu STATE4, 0x30(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE4
+	pxor 0x70(INP), STATE4
+	movdqu IV, 0x70(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movups IV, (IVP)
+
+	call *%r11
+
+	pxor 0x40(OUTP), STATE1
+	movdqu STATE1, 0x40(OUTP)
+
+	pxor 0x50(OUTP), STATE2
+	movdqu STATE2, 0x50(OUTP)
+
+	pxor 0x60(OUTP), STATE3
+	movdqu STATE3, 0x60(OUTP)
+
+	pxor 0x70(OUTP), STATE4
+	movdqu STATE4, 0x70(OUTP)
+
+	ret
+ENDPROC(aesni_xts_crypt8)
+
 #endif
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a0795da..f80e668 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -39,6 +39,9 @@
 #include <crypto/internal/aead.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#ifdef CONFIG_X86_64
+#include <asm/crypto/glue_helper.h>
+#endif
 
 #if defined(CONFIG_CRYPTO_PCBC) || defined(CONFIG_CRYPTO_PCBC_MODULE)
 #define HAS_PCBC
@@ -102,6 +105,9 @@ void crypto_fpu_exit(void);
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
+asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
+				 const u8 *in, bool enc, u8 *iv);
+
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
  * u8 *out, Ciphertext output. Encrypt in-place is allowed.
@@ -510,6 +516,78 @@ static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
 	aesni_enc(ctx, out, in);
 }
 
+#ifdef CONFIG_X86_64
+
+static void aesni_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_enc));
+}
+
+static void aesni_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_dec));
+}
+
+static void aesni_xts_enc8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+{
+	aesni_xts_crypt8(ctx, (u8 *)dst, (const u8 *)src, true, (u8 *)iv);
+}
+
+static void aesni_xts_dec8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+{
+	aesni_xts_crypt8(ctx, (u8 *)dst, (const u8 *)src, false, (u8 *)iv);
+}
+
+static const struct common_glue_ctx aesni_enc_xts = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = 1,
+
+	.funcs = { {
+		.num_blocks = 8,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc8) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc) }
+	} }
+};
+
+static const struct common_glue_ctx aesni_dec_xts = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = 1,
+
+	.funcs = { {
+		.num_blocks = 8,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec8) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec) }
+	} }
+};
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+
+	return glue_xts_crypt_128bit(&aesni_enc_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(aesni_xts_tweak),
+				     aes_ctx(ctx->raw_tweak_ctx),
+				     aes_ctx(ctx->raw_crypt_ctx));
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct aesni_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+
+	return glue_xts_crypt_128bit(&aesni_dec_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(aesni_xts_tweak),
+				     aes_ctx(ctx->raw_tweak_ctx),
+				     aes_ctx(ctx->raw_crypt_ctx));
+}
+
+#else
+
 static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -560,6 +638,8 @@ static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return ret;
 }
 
+#endif
+
 #ifdef CONFIG_X86_64
 static int rfc4106_init(struct crypto_tfm *tfm)
 {
diff --git a/crypto/Kconfig b/crypto/Kconfig
index c1142f3..808ac37 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -678,6 +678,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_ALGAPI
+	select CRYPTO_GLUE_HELPER if 64BIT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
 	help
