From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 16/16] crypto/x86: move SHA-384/512 SSSE3 implementation to base layer
Date: Thu,  9 Apr 2015 12:55:48 +0200
Message-ID: <1428576948-23863-17-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36870 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbbDIK4k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:40 -0400
Received: by wiaa2 with SMTP id a2so93261641wia.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:38 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This removes all the boilerplate from the existing implementation,
and replaces it with calls into the base layer.  It also changes the
prototypes of the core asm functions to be compatible with the base
prototype

  void (sha512_block_fn)(struct sha256_state *sst, u8 const *src, int blocks)

so that they can be passed to the base layer directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha512-avx-asm.S    |   6 +-
 arch/x86/crypto/sha512-avx2-asm.S   |   6 +-
 arch/x86/crypto/sha512-ssse3-asm.S  |   6 +-
 arch/x86/crypto/sha512_ssse3_glue.c | 202 +++++++-----------------------------
 4 files changed, 44 insertions(+), 176 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 974dde9bc6cd..565274d6a641 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -54,9 +54,9 @@
 
 # Virtual Registers
 # ARG1
-msg	= %rdi
+digest	= %rdi
 # ARG2
-digest	= %rsi
+msg	= %rsi
 # ARG3
 msglen	= %rdx
 T1	= %rcx
@@ -271,7 +271,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 .endm
 
 ########################################################################
-# void sha512_transform_avx(const void* M, void* D, u64 L)
+# void sha512_transform_avx(void* D, const void* M, u64 L)
 # Purpose: Updates the SHA512 digest stored at D with the message stored in M.
 # The size of the message pointed to by M must be an integer multiple of SHA512
 # message blocks.
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 568b96105f5c..a4771dcd1fcf 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -70,9 +70,9 @@ XFER  = YTMP0
 BYTE_FLIP_MASK  = %ymm9
 
 # 1st arg
-INP         = %rdi
+CTX         = %rdi
 # 2nd arg
-CTX         = %rsi
+INP         = %rsi
 # 3rd arg
 NUM_BLKS    = %rdx
 
@@ -562,7 +562,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 .endm
 
 ########################################################################
-# void sha512_transform_rorx(const void* M, void* D, uint64_t L)#
+# void sha512_transform_rorx(void* D, const void* M, uint64_t L)#
 # Purpose: Updates the SHA512 digest stored at D with the message stored in M.
 # The size of the message pointed to by M must be an integer multiple of SHA512
 #   message blocks.
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index fb56855d51f5..e610e29cbc81 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -53,9 +53,9 @@
 
 # Virtual Registers
 # ARG1
-msg =		%rdi
+digest =	%rdi
 # ARG2
-digest =	%rsi
+msg =		%rsi
 # ARG3
 msglen =	%rdx
 T1 =		%rcx
@@ -269,7 +269,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 .endm
 
 ########################################################################
-# void sha512_transform_ssse3(const void* M, void* D, u64 L)#
+# void sha512_transform_ssse3(void* D, const void* M, u64 L)#
 # Purpose: Updates the SHA512 digest stored at D with the message stored in M.
 # The size of the message pointed to by M must be an integer multiple of SHA512
 #   message blocks.
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 0b6af26832bf..d9fa4c1e063f 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -34,205 +34,75 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha512_base.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 
 #include <linux/string.h>
 
-asmlinkage void sha512_transform_ssse3(const char *data, u64 *digest,
-				     u64 rounds);
+asmlinkage void sha512_transform_ssse3(u64 *digest, const char *data,
+				       u64 rounds);
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha512_transform_avx(const char *data, u64 *digest,
+asmlinkage void sha512_transform_avx(u64 *digest, const char *data,
 				     u64 rounds);
 #endif
 #ifdef CONFIG_AS_AVX2
-asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
-				     u64 rounds);
+asmlinkage void sha512_transform_rorx(u64 *digest, const char *data,
+				      u64 rounds);
 #endif
 
-static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
-
-
-static int sha512_ssse3_init(struct shash_desc *desc)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA512_H0;
-	sctx->state[1] = SHA512_H1;
-	sctx->state[2] = SHA512_H2;
-	sctx->state[3] = SHA512_H3;
-	sctx->state[4] = SHA512_H4;
-	sctx->state[5] = SHA512_H5;
-	sctx->state[6] = SHA512_H6;
-	sctx->state[7] = SHA512_H7;
-	sctx->count[0] = sctx->count[1] = 0;
-
-	return 0;
-}
+static void (*sha512_transform_asm)(u64 *, const char *, u64);
 
-static int __sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, unsigned int partial)
+static int sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count[0] += len;
-	if (sctx->count[0] < len)
-		sctx->count[1]++;
 
-	if (partial) {
-		done = SHA512_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha512_transform_asm(sctx->buf, sctx->state, 1);
-	}
-
-	if (len - done >= SHA512_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA512_BLOCK_SIZE;
+	if (!irq_fpu_usable() ||
+	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
+		return crypto_sha512_update(desc, data, len);
 
-		sha512_transform_asm(data + done, sctx->state, (u64) rounds);
-
-		done += rounds * SHA512_BLOCK_SIZE;
-	}
+	/* make sure casting to sha512_block_fn() is safe */
+	BUILD_BUG_ON(offsetof(struct sha512_state, state) != 0);
 
-	memcpy(sctx->buf, data + done, len - done);
+	kernel_fpu_begin();
+	sha512_base_do_update(desc, data, len,
+			      (sha512_block_fn *)sha512_transform_asm);
+	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len)
+static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
-	int res;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA512_BLOCK_SIZE) {
-		sctx->count[0] += len;
-		if (sctx->count[0] < len)
-			sctx->count[1]++;
-		memcpy(sctx->buf + partial, data, len);
-
-		return 0;
-	}
+	if (!irq_fpu_usable())
+		return crypto_sha512_finup(desc, data, len, out);
 
-	if (!irq_fpu_usable()) {
-		res = crypto_sha512_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha512_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
+	kernel_fpu_begin();
+	if (len)
+		sha512_base_do_update(desc, data, len,
+				      (sha512_block_fn *)sha512_transform_asm);
+	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_transform_asm);
+	kernel_fpu_end();
 
-	return res;
+	return sha512_base_finish(desc, out);
 }
 
-
 /* Add padding and return the message digest. */
 static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be64 *dst = (__be64 *)out;
-	__be64 bits[2];
-	static const u8 padding[SHA512_BLOCK_SIZE] = { 0x80, };
-
-	/* save number of bits */
-	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
-
-	/* Pad out to 112 mod 128 and append length */
-	index = sctx->count[0] & 0x7f;
-	padlen = (index < 112) ? (112 - index) : ((128+112) - index);
-
-	if (!irq_fpu_usable()) {
-		crypto_sha512_update(desc, padding, padlen);
-		crypto_sha512_update(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_fpu_begin();
-		/* We need to fill a whole block for __sha512_ssse3_update() */
-		if (padlen <= 112) {
-			sctx->count[0] += padlen;
-			if (sctx->count[0] < padlen)
-				sctx->count[1]++;
-			memcpy(sctx->buf + index, padding, padlen);
-		} else {
-			__sha512_ssse3_update(desc, padding, padlen, index);
-		}
-		__sha512_ssse3_update(desc, (const u8 *)&bits,
-					sizeof(bits), 112);
-		kernel_fpu_end();
-	}
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be64(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha512_ssse3_export(struct shash_desc *desc, void *out)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha512_ssse3_import(struct shash_desc *desc, const void *in)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha384_ssse3_init(struct shash_desc *desc)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA384_H0;
-	sctx->state[1] = SHA384_H1;
-	sctx->state[2] = SHA384_H2;
-	sctx->state[3] = SHA384_H3;
-	sctx->state[4] = SHA384_H4;
-	sctx->state[5] = SHA384_H5;
-	sctx->state[6] = SHA384_H6;
-	sctx->state[7] = SHA384_H7;
-
-	sctx->count[0] = sctx->count[1] = 0;
-
-	return 0;
-}
-
-static int sha384_ssse3_final(struct shash_desc *desc, u8 *hash)
-{
-	u8 D[SHA512_DIGEST_SIZE];
-
-	sha512_ssse3_final(desc, D);
-
-	memcpy(hash, D, SHA384_DIGEST_SIZE);
-	memzero_explicit(D, SHA512_DIGEST_SIZE);
-
-	return 0;
+	return sha512_ssse3_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
-	.init		=	sha512_ssse3_init,
+	.init		=	sha512_base_init,
 	.update		=	sha512_ssse3_update,
 	.final		=	sha512_ssse3_final,
-	.export		=	sha512_ssse3_export,
-	.import		=	sha512_ssse3_import,
+	.finup		=	sha512_ssse3_finup,
 	.descsize	=	sizeof(struct sha512_state),
-	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name =	"sha512-ssse3",
@@ -243,13 +113,11 @@ static struct shash_alg algs[] = { {
 	}
 },  {
 	.digestsize	=	SHA384_DIGEST_SIZE,
-	.init		=	sha384_ssse3_init,
+	.init		=	sha384_base_init,
 	.update		=	sha512_ssse3_update,
-	.final		=	sha384_ssse3_final,
-	.export		=	sha512_ssse3_export,
-	.import		=	sha512_ssse3_import,
+	.final		=	sha512_ssse3_final,
+	.finup		=	sha512_ssse3_finup,
 	.descsize	=	sizeof(struct sha512_state),
-	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name =	"sha384-ssse3",
-- 
1.8.3.2
