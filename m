From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 15/16] crypto/x86: move SHA-224/256 SSSE3 implementation to base layer
Date: Thu,  9 Apr 2015 12:55:47 +0200
Message-ID: <1428576948-23863-16-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34180 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288AbbDIK4h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:37 -0400
Received: by wgso17 with SMTP id o17so4066513wgs.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:36 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This removes all the boilerplate from the existing implementation,
and replaces it with calls into the base layer. It also changes the
prototypes of the core asm functions to be compatible with the base
prototype

  void (sha256_block_fn)(struct sha256_state *sst, u8 const *src, int blocks)

so that they can be passed to the base layer directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha256-avx-asm.S    |  10 +-
 arch/x86/crypto/sha256-avx2-asm.S   |  10 +-
 arch/x86/crypto/sha256-ssse3-asm.S  |  10 +-
 arch/x86/crypto/sha256_ssse3_glue.c | 193 +++++++-----------------------------
 4 files changed, 50 insertions(+), 173 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 642f15687a0a..92b3b5d75ba9 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -96,10 +96,10 @@ SHUF_DC00 = %xmm12      # shuffle xDxC -> DC00
 BYTE_FLIP_MASK = %xmm13
 
 NUM_BLKS = %rdx   # 3rd arg
-CTX = %rsi        # 2nd arg
-INP = %rdi        # 1st arg
+INP = %rsi        # 2nd arg
+CTX = %rdi        # 1st arg
 
-SRND = %rdi       # clobbers INP
+SRND = %rsi       # clobbers INP
 c = %ecx
 d = %r8d
 e = %edx
@@ -342,8 +342,8 @@ a = TMP_
 
 ########################################################################
 ## void sha256_transform_avx(void *input_data, UINT32 digest[8], UINT64 num_blks)
-## arg 1 : pointer to input data
-## arg 2 : pointer to digest
+## arg 1 : pointer to digest
+## arg 2 : pointer to input data
 ## arg 3 : Num blocks
 ########################################################################
 .text
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9e86944c539d..570ec5ec62d7 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -91,12 +91,12 @@ BYTE_FLIP_MASK = %ymm13
 X_BYTE_FLIP_MASK = %xmm13 # XMM version of BYTE_FLIP_MASK
 
 NUM_BLKS = %rdx	# 3rd arg
-CTX	= %rsi  # 2nd arg
-INP	= %rdi	# 1st arg
+INP	= %rsi  # 2nd arg
+CTX	= %rdi	# 1st arg
 c	= %ecx
 d	= %r8d
 e       = %edx	# clobbers NUM_BLKS
-y3	= %edi	# clobbers INP
+y3	= %esi	# clobbers INP
 
 
 TBL	= %rbp
@@ -523,8 +523,8 @@ STACK_SIZE	= _RSP      + _RSP_SIZE
 
 ########################################################################
 ## void sha256_transform_rorx(void *input_data, UINT32 digest[8], UINT64 num_blks)
-## arg 1 : pointer to input data
-## arg 2 : pointer to digest
+## arg 1 : pointer to digest
+## arg 2 : pointer to input data
 ## arg 3 : Num blocks
 ########################################################################
 .text
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index f833b74d902b..2cedc44e8121 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -88,10 +88,10 @@ SHUF_DC00 = %xmm11      # shuffle xDxC -> DC00
 BYTE_FLIP_MASK = %xmm12
 
 NUM_BLKS = %rdx   # 3rd arg
-CTX = %rsi        # 2nd arg
-INP = %rdi        # 1st arg
+INP = %rsi        # 2nd arg
+CTX = %rdi        # 1st arg
 
-SRND = %rdi       # clobbers INP
+SRND = %rsi       # clobbers INP
 c = %ecx
 d = %r8d
 e = %edx
@@ -348,8 +348,8 @@ a = TMP_
 
 ########################################################################
 ## void sha256_transform_ssse3(void *input_data, UINT32 digest[8], UINT64 num_blks)
-## arg 1 : pointer to input data
-## arg 2 : pointer to digest
+## arg 1 : pointer to digest
+## arg 2 : pointer to input data
 ## arg 3 : Num blocks
 ########################################################################
 .text
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 8fad72f4dfd2..ccc338881ee8 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -36,195 +36,74 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha256_base.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <linux/string.h>
 
-asmlinkage void sha256_transform_ssse3(const char *data, u32 *digest,
-				     u64 rounds);
+asmlinkage void sha256_transform_ssse3(u32 *digest, const char *data,
+				       u64 rounds);
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha256_transform_avx(const char *data, u32 *digest,
+asmlinkage void sha256_transform_avx(u32 *digest, const char *data,
 				     u64 rounds);
 #endif
 #ifdef CONFIG_AS_AVX2
-asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
-				     u64 rounds);
+asmlinkage void sha256_transform_rorx(u32 *digest, const char *data,
+				      u64 rounds);
 #endif
 
-static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
-
-
-static int sha256_ssse3_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA256_H0;
-	sctx->state[1] = SHA256_H1;
-	sctx->state[2] = SHA256_H2;
-	sctx->state[3] = SHA256_H3;
-	sctx->state[4] = SHA256_H4;
-	sctx->state[5] = SHA256_H5;
-	sctx->state[6] = SHA256_H6;
-	sctx->state[7] = SHA256_H7;
-	sctx->count = 0;
-
-	return 0;
-}
-
-static int __sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, unsigned int partial)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA256_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha256_transform_asm(sctx->buf, sctx->state, 1);
-	}
-
-	if (len - done >= SHA256_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
-
-		sha256_transform_asm(data + done, sctx->state, (u64) rounds);
-
-		done += rounds * SHA256_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buf, data + done, len - done);
-
-	return 0;
-}
+static void (*sha256_transform_asm)(u32 *, const char *, u64);
 
 static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-	int res;
 
-	/* Handle the fast case right here */
-	if (partial + len < SHA256_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buf + partial, data, len);
+	if (!irq_fpu_usable() ||
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_update(desc, data, len);
 
-		return 0;
-	}
-
-	if (!irq_fpu_usable()) {
-		res = crypto_sha256_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha256_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
-
-	return res;
-}
+	/* make sure casting to sha256_block_fn() is safe */
+	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
 
-
-/* Add padding and return the message digest. */
-static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA256_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56)-index);
-
-	if (!irq_fpu_usable()) {
-		crypto_sha256_update(desc, padding, padlen);
-		crypto_sha256_update(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_fpu_begin();
-		/* We need to fill a whole block for __sha256_ssse3_update() */
-		if (padlen <= 56) {
-			sctx->count += padlen;
-			memcpy(sctx->buf + index, padding, padlen);
-		} else {
-			__sha256_ssse3_update(desc, padding, padlen, index);
-		}
-		__sha256_ssse3_update(desc, (const u8 *)&bits,
-					sizeof(bits), 56);
-		kernel_fpu_end();
-	}
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
+	kernel_fpu_begin();
+	sha256_base_do_update(desc, data, len,
+			      (sha256_block_fn *)sha256_transform_asm);
+	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha256_ssse3_export(struct shash_desc *desc, void *out)
+static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	if (!irq_fpu_usable())
+		return crypto_sha256_finup(desc, data, len, out);
 
-	memcpy(out, sctx, sizeof(*sctx));
+	kernel_fpu_begin();
+	if (len)
+		sha256_base_do_update(desc, data, len,
+				      (sha256_block_fn *)sha256_transform_asm);
+	sha256_base_do_finalize(desc, (sha256_block_fn *)sha256_transform_asm);
+	kernel_fpu_end();
 
-	return 0;
+	return sha256_base_finish(desc, out);
 }
 
-static int sha256_ssse3_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha224_ssse3_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA224_H0;
-	sctx->state[1] = SHA224_H1;
-	sctx->state[2] = SHA224_H2;
-	sctx->state[3] = SHA224_H3;
-	sctx->state[4] = SHA224_H4;
-	sctx->state[5] = SHA224_H5;
-	sctx->state[6] = SHA224_H6;
-	sctx->state[7] = SHA224_H7;
-	sctx->count = 0;
-
-	return 0;
-}
-
-static int sha224_ssse3_final(struct shash_desc *desc, u8 *hash)
+/* Add padding and return the message digest. */
+static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
 {
-	u8 D[SHA256_DIGEST_SIZE];
-
-	sha256_ssse3_final(desc, D);
-
-	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
+	return sha256_ssse3_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_ssse3_init,
+	.init		=	sha256_base_init,
 	.update		=	sha256_ssse3_update,
 	.final		=	sha256_ssse3_final,
-	.export		=	sha256_ssse3_export,
-	.import		=	sha256_ssse3_import,
+	.finup		=	sha256_ssse3_finup,
 	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-ssse3",
@@ -235,13 +114,11 @@ static struct shash_alg algs[] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_ssse3_init,
+	.init		=	sha224_base_init,
 	.update		=	sha256_ssse3_update,
-	.final		=	sha224_ssse3_final,
-	.export		=	sha256_ssse3_export,
-	.import		=	sha256_ssse3_import,
+	.final		=	sha256_ssse3_final,
+	.finup		=	sha256_ssse3_finup,
 	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name =	"sha224-ssse3",
-- 
1.8.3.2
