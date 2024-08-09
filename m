Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED84168490
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2024 23:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723245222; cv=none; b=fR+Y0x80imSBcw3HFmjKT6R6BrQeJQCkV21Sez1nMMfvVnNXUZABW2R6QnyfmnAHXEjB8iiUJ0fg929atjSLwL8OH4Y17UVuS0txqFRjliSOl37F3yBsJrrIL2VxFJXlc40TJNcg2SdxR1hMtsuGqK76Bva8bc2ELCmxWtNK4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723245222; c=relaxed/simple;
	bh=cJ56P3LSkNQ0mGQTKzOiM0tEiuw3Pjk+qMELGgbtChY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zdd4Alr85wKv6oebDARUy80+sdPRtHLgZkP+WBpQQnGp7eYDI0YNLDXEwFT5/CTDjF1qB7hr210tAEhoOC2zbs5h4/9i4jBi1DNrKaWQfLmOU0VFDsBBlN7TbN8vgV3rqC+t301OCT4AxUFHx40sw3aAOqxhvf3FBIUGfcT4sCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuBgSDIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuBgSDIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842CDC32782;
	Fri,  9 Aug 2024 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723245221;
	bh=cJ56P3LSkNQ0mGQTKzOiM0tEiuw3Pjk+qMELGgbtChY=;
	h=From:To:Cc:Subject:Date:From;
	b=NuBgSDIg3HQVJxW7g+cyI6/KLtKJ8G5/3e9cL2qGP531fNSmOl1RWl/nfaHC8oBQ+
	 JkqaT7s43WRYNmZegwiIHsCqp4QxH2XIrEsiGg9wiXVduYG25Kc34EpWnz3+MO0vyb
	 bRPD80FAIerJopEDQdDZbQRm17nXAJQxGysB/xeD0Y0obLxRBoObpejvnaU+TL9O4f
	 xQZGWVm3bRsi2XukEDgXB0BbuD/SEvLBj3cKRxOrEKh9S5jp453jjtrsEcM+kWeUpy
	 UYOINT3gc+qE+7cOFFhJch3qL8ZaDMNXiazR6j/zMJ7vEU/yjPdn8lNUugYbHfhHqp
	 QUBSh8vqVFEHA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] crypto: arm/aes-neonbs - go back to using aes-arm directly
Date: Fri,  9 Aug 2024 16:11:49 -0700
Message-ID: <20240809231149.222482-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In aes-neonbs, instead of going through the crypto API for the parts
that the bit-sliced AES code doesn't handle, namely AES-CBC encryption
and single-block AES, just call the ARM scalar AES cipher directly.

This basically goes back to the original approach that was used before
commit b56f5cbc7e08 ("crypto: arm/aes-neonbs - resolve fallback cipher
at runtime").  Calling the ARM scalar AES cipher directly is faster,
simpler, and avoids any chance of bugs specific to the use of fallback
ciphers such as module loading deadlocks which have happened twice.  The
deadlocks turned out to be fixable in other ways, but there's no need to
rely on anything so fragile in the first place.

The rationale for the above-mentioned commit was to allow people to
choose to use a time-invariant AES implementation for the fallback
cipher.  There are a couple problems with that rationale, though:

- In practice the ARM scalar AES cipher (aes-arm) was used anyway, since
  it has a higher priority than aes-fixed-time.  Users *could* go out of
  their way to disable or blacklist aes-arm, or to lower its priority
  using NETLINK_CRYPTO, but very few users customize the crypto API to
  this extent.  Systems with the ARMv8 Crypto Extensions used aes-ce,
  but the bit-sliced algorithms are irrelevant on such systems anyway.

- Since commit 913a3aa07d16 ("crypto: arm/aes - add some hardening
  against cache-timing attacks"), the ARM scalar AES cipher is partially
  hardened against cache-timing attacks.  It actually works like
  aes-fixed-time, in that it disables interrupts and prefetches its
  lookup table.  It does use a larger table than aes-fixed-time, but
  even so, it is not clear that aes-fixed-time is meaningfully more
  time-invariant than aes-arm.  And of course, the real solution for
  time-invariant AES is to use a CPU that supports AES instructions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/Kconfig           |  14 +++-
 arch/arm/crypto/aes-cipher-glue.c |   5 +-
 arch/arm/crypto/aes-cipher.h      |  13 +++
 arch/arm/crypto/aes-neonbs-glue.c | 131 ++++++++++--------------------
 4 files changed, 67 insertions(+), 96 deletions(-)
 create mode 100644 arch/arm/crypto/aes-cipher.h

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 847b7a003356..5ff49a5e9afc 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -164,14 +164,13 @@ config CRYPTO_AES_ARM
 	  such attacks very difficult.
 
 config CRYPTO_AES_ARM_BS
 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS (bit-sliced NEON)"
 	depends on KERNEL_MODE_NEON
+	select CRYPTO_AES_ARM
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
-	select CRYPTO_AES
-	select CRYPTO_CBC
 	select CRYPTO_SIMD
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	  with block cipher modes:
 	   - ECB (Electronic Codebook) mode (NIST SP800-38A)
@@ -181,12 +180,19 @@ config CRYPTO_AES_ARM_BS
 	     and IEEE 1619)
 
 	  Bit sliced AES gives around 45% speedup on Cortex-A15 for CTR mode
 	  and for XTS mode encryption, CBC and XTS mode decryption speedup is
 	  around 25%. (CBC encryption speed is not affected by this driver.)
-	  This implementation does not rely on any lookup tables so it is
-	  believed to be invulnerable to cache timing attacks.
+
+	  The bit sliced AES code does not use lookup tables, so it is believed
+	  to be invulnerable to cache timing attacks. However, since the bit
+	  sliced AES code cannot process single blocks efficiently, in certain
+	  cases table-based code with some countermeasures against cache timing
+	  attacks will still be used as a fallback method; specifically CBC
+	  encryption (not CBC decryption), the encryption of XTS tweaks, XTS
+	  ciphertext stealing when the message isn't a multiple of 16 bytes, and
+	  CTR when invoked in a context in which NEON instructions are unusable.
 
 config CRYPTO_AES_ARM_CE
 	tristate "Ciphers: AES, modes: ECB/CBC/CTS/CTR/XTS (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
diff --git a/arch/arm/crypto/aes-cipher-glue.c b/arch/arm/crypto/aes-cipher-glue.c
index 6dfaef2d8f91..29efb7833960 100644
--- a/arch/arm/crypto/aes-cipher-glue.c
+++ b/arch/arm/crypto/aes-cipher-glue.c
@@ -7,13 +7,14 @@
  */
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/module.h>
+#include "aes-cipher.h"
 
-asmlinkage void __aes_arm_encrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
-asmlinkage void __aes_arm_decrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
+EXPORT_SYMBOL_GPL(__aes_arm_encrypt);
+EXPORT_SYMBOL_GPL(__aes_arm_decrypt);
 
 static void aes_arm_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int rounds = 6 + ctx->key_length / 4;
diff --git a/arch/arm/crypto/aes-cipher.h b/arch/arm/crypto/aes-cipher.h
new file mode 100644
index 000000000000..d5db2b87eb69
--- /dev/null
+++ b/arch/arm/crypto/aes-cipher.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef ARM_CRYPTO_AES_CIPHER_H
+#define ARM_CRYPTO_AES_CIPHER_H
+
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+asmlinkage void __aes_arm_encrypt(const u32 rk[], int rounds,
+				  const u8 *in, u8 *out);
+asmlinkage void __aes_arm_decrypt(const u32 rk[], int rounds,
+				  const u8 *in, u8 *out);
+
+#endif /* ARM_CRYPTO_AES_CIPHER_H */
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 201eb35dde37..fd04f855b2f5 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -7,28 +7,26 @@
 
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
-#include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <linux/module.h>
+#include "aes-cipher.h"
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_DESCRIPTION("Bit sliced AES using NEON instructions");
 MODULE_LICENSE("GPL v2");
 
 MODULE_ALIAS_CRYPTO("ecb(aes)");
-MODULE_ALIAS_CRYPTO("cbc(aes)-all");
+MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
 
-MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-
 asmlinkage void aesbs_convert_key(u8 out[], u32 const rk[], int rounds);
 
 asmlinkage void aesbs_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks);
 asmlinkage void aesbs_ecb_decrypt(u8 out[], u8 const in[], u8 const rk[],
@@ -50,17 +48,17 @@ struct aesbs_ctx {
 	u8	rk[13 * (8 * AES_BLOCK_SIZE) + 32] __aligned(AES_BLOCK_SIZE);
 };
 
 struct aesbs_cbc_ctx {
 	struct aesbs_ctx	key;
-	struct crypto_skcipher	*enc_tfm;
+	struct crypto_aes_ctx	fallback;
 };
 
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
-	struct crypto_cipher	*cts_tfm;
-	struct crypto_cipher	*tweak_tfm;
+	struct crypto_aes_ctx	fallback;
+	struct crypto_aes_ctx	tweak_key;
 };
 
 struct aesbs_ctr_ctx {
 	struct aesbs_ctx	key;		/* must be first member */
 	struct crypto_aes_ctx	fallback;
@@ -127,41 +125,53 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
 	int err;
 
-	err = aes_expandkey(&rk, in_key, key_len);
+	err = aes_expandkey(&ctx->fallback, in_key, key_len);
 	if (err)
 		return err;
 
 	ctx->key.rounds = 6 + key_len / 4;
 
 	kernel_neon_begin();
-	aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
+	aesbs_convert_key(ctx->key.rk, ctx->fallback.key_enc, ctx->key.rounds);
 	kernel_neon_end();
-	memzero_explicit(&rk, sizeof(rk));
 
-	return crypto_skcipher_setkey(ctx->enc_tfm, in_key, key_len);
+	return 0;
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct skcipher_request *subreq = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
 
-	skcipher_request_set_tfm(subreq, ctx->enc_tfm);
-	skcipher_request_set_callback(subreq,
-				      skcipher_request_flags(req),
-				      NULL, NULL);
-	skcipher_request_set_crypt(subreq, req->src, req->dst,
-				   req->cryptlen, req->iv);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	return crypto_skcipher_encrypt(subreq);
+	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 *prev = walk.iv;
+
+		do {
+			crypto_xor_cpy(dst, src, prev, AES_BLOCK_SIZE);
+			__aes_arm_encrypt(ctx->fallback.key_enc,
+					  ctx->key.rounds, dst, dst);
+			prev = dst;
+			src += AES_BLOCK_SIZE;
+			dst += AES_BLOCK_SIZE;
+			nbytes -= AES_BLOCK_SIZE;
+		} while (nbytes >= AES_BLOCK_SIZE);
+		memcpy(walk.iv, prev, AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+	return err;
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -188,34 +198,10 @@ static int cbc_decrypt(struct skcipher_request *req)
 	}
 
 	return err;
 }
 
-static int cbc_init(struct crypto_skcipher *tfm)
-{
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-	unsigned int reqsize;
-
-	ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->enc_tfm))
-		return PTR_ERR(ctx->enc_tfm);
-
-	reqsize = sizeof(struct skcipher_request);
-	reqsize += crypto_skcipher_reqsize(ctx->enc_tfm);
-	crypto_skcipher_set_reqsize(tfm, reqsize);
-
-	return 0;
-}
-
-static void cbc_exit(struct crypto_skcipher *tfm)
-{
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_skcipher(ctx->enc_tfm);
-}
-
 static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
 				 unsigned int key_len)
 {
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
@@ -269,20 +255,12 @@ static int ctr_encrypt(struct skcipher_request *req)
 }
 
 static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
 {
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
-	unsigned long flags;
-
-	/*
-	 * Temporarily disable interrupts to avoid races where
-	 * cachelines are evicted when the CPU is interrupted
-	 * to do something else.
-	 */
-	local_irq_save(flags);
-	aes_encrypt(&ctx->fallback, dst, src);
-	local_irq_restore(flags);
+
+	__aes_arm_encrypt(ctx->fallback.key_enc, ctx->key.rounds, src, dst);
 }
 
 static int ctr_encrypt_sync(struct skcipher_request *req)
 {
 	if (!crypto_simd_usable())
@@ -300,49 +278,27 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	err = xts_verify_key(tfm, in_key, key_len);
 	if (err)
 		return err;
 
 	key_len /= 2;
-	err = crypto_cipher_setkey(ctx->cts_tfm, in_key, key_len);
+	err = aes_expandkey(&ctx->fallback, in_key, key_len);
 	if (err)
 		return err;
-	err = crypto_cipher_setkey(ctx->tweak_tfm, in_key + key_len, key_len);
+	err = aes_expandkey(&ctx->tweak_key, in_key + key_len, key_len);
 	if (err)
 		return err;
 
 	return aesbs_setkey(tfm, in_key, key_len);
 }
 
-static int xts_init(struct crypto_skcipher *tfm)
-{
-	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->cts_tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(ctx->cts_tfm))
-		return PTR_ERR(ctx->cts_tfm);
-
-	ctx->tweak_tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(ctx->tweak_tfm))
-		crypto_free_cipher(ctx->cts_tfm);
-
-	return PTR_ERR_OR_ZERO(ctx->tweak_tfm);
-}
-
-static void xts_exit(struct crypto_skcipher *tfm)
-{
-	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	crypto_free_cipher(ctx->tweak_tfm);
-	crypto_free_cipher(ctx->cts_tfm);
-}
-
 static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 		       void (*fn)(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[], int))
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const int rounds = ctx->key.rounds;
 	int tail = req->cryptlen % AES_BLOCK_SIZE;
 	struct skcipher_request subreq;
 	u8 buf[2 * AES_BLOCK_SIZE];
 	struct skcipher_walk walk;
 	int err;
@@ -362,11 +318,11 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 
 	err = skcipher_walk_virt(&walk, req, true);
 	if (err)
 		return err;
 
-	crypto_cipher_encrypt_one(ctx->tweak_tfm, walk.iv, walk.iv);
+	__aes_arm_encrypt(ctx->tweak_key.key_enc, rounds, walk.iv, walk.iv);
 
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 		int reorder_last_tweak = !encrypt && tail > 0;
 
@@ -376,11 +332,11 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 			reorder_last_tweak = 0;
 		}
 
 		kernel_neon_begin();
 		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->key.rk,
-		   ctx->key.rounds, blocks, walk.iv, reorder_last_tweak);
+		   rounds, blocks, walk.iv, reorder_last_tweak);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
 
@@ -394,13 +350,13 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 	scatterwalk_map_and_copy(buf, req->src, req->cryptlen, tail, 0);
 
 	crypto_xor(buf, req->iv, AES_BLOCK_SIZE);
 
 	if (encrypt)
-		crypto_cipher_encrypt_one(ctx->cts_tfm, buf, buf);
+		__aes_arm_encrypt(ctx->fallback.key_enc, rounds, buf, buf);
 	else
-		crypto_cipher_decrypt_one(ctx->cts_tfm, buf, buf);
+		__aes_arm_decrypt(ctx->fallback.key_dec, rounds, buf, buf);
 
 	crypto_xor(buf, req->iv, AES_BLOCK_SIZE);
 
 	scatterwalk_map_and_copy(buf, req->dst, req->cryptlen - AES_BLOCK_SIZE,
 				 AES_BLOCK_SIZE + tail, 1);
@@ -437,22 +393,19 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_driver_name	= "__cbc-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL |
-				  CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
 	.setkey			= aesbs_cbc_setkey,
 	.encrypt		= cbc_encrypt,
 	.decrypt		= cbc_decrypt,
-	.init			= cbc_init,
-	.exit			= cbc_exit,
 }, {
 	.base.cra_name		= "__ctr(aes)",
 	.base.cra_driver_name	= "__ctr-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= 1,
@@ -498,12 +451,10 @@ static struct skcipher_alg aes_algs[] = { {
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
 	.setkey			= aesbs_xts_setkey,
 	.encrypt		= xts_encrypt,
 	.decrypt		= xts_decrypt,
-	.init			= xts_init,
-	.exit			= xts_exit,
 } };
 
 static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
 
 static void aes_exit(void)

base-commit: afdab700f65e14070d8ab92175544b1c62b8bf03
-- 
2.46.0

