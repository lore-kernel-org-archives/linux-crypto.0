From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/3] crypto: salsa20-generic - cleanup and convert to skcipher API
Date: Sun, 31 Dec 2017 17:46:40 -0600
Message-ID: <20171231234642.22621-2-ebiggers3@gmail.com>
References: <20171231234642.22621-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:46951 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdLaXwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Dec 2017 18:52:04 -0500
Received: by mail-it0-f68.google.com with SMTP id c16so11499180itc.5
        for <linux-crypto@vger.kernel.org>; Sun, 31 Dec 2017 15:52:03 -0800 (PST)
In-Reply-To: <20171231234642.22621-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Convert salsa20-generic from the deprecated "blkcipher" API to the
"skcipher" API, in the process fixing it up to be thread-safe (as the
crypto API expects) by maintaining each request's state separately from
the transform context.

Also remove the unnecessary cra_alignmask and tighten validation of the
key size by accepting only 16 or 32 bytes, not anything in between.

These changes bring the code close to the way chacha20-generic does
things, so hopefully it will be easier to maintain in the future.

However, the way Salsa20 interprets the IV is still slightly different;
that was not changed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/salsa20_generic.c | 240 ++++++++++++++++++++---------------------------
 1 file changed, 104 insertions(+), 136 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index d7da0eea5622..59f64e041a7f 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -19,49 +19,27 @@
  *
  */
 
-#include <linux/init.h>
+#include <asm/unaligned.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/crypto.h>
-#include <linux/types.h>
-#include <linux/bitops.h>
-#include <crypto/algapi.h>
-#include <asm/byteorder.h>
 
-#define SALSA20_IV_SIZE        8U
-#define SALSA20_MIN_KEY_SIZE  16U
-#define SALSA20_MAX_KEY_SIZE  32U
+#define SALSA20_IV_SIZE        8
+#define SALSA20_MIN_KEY_SIZE  16
+#define SALSA20_MAX_KEY_SIZE  32
+#define SALSA20_BLOCK_SIZE    64
 
-/*
- * Start of code taken from D. J. Bernstein's reference implementation.
- * With some modifications and optimizations made to suit our needs.
- */
-
-/*
-salsa20-ref.c version 20051118
-D. J. Bernstein
-Public domain.
-*/
-
-#define U32TO8_LITTLE(p, v) \
-	{ (p)[0] = (v >>  0) & 0xff; (p)[1] = (v >>  8) & 0xff; \
-	  (p)[2] = (v >> 16) & 0xff; (p)[3] = (v >> 24) & 0xff; }
-#define U8TO32_LITTLE(p)   \
-	(((u32)((p)[0])      ) | ((u32)((p)[1]) <<  8) | \
-	 ((u32)((p)[2]) << 16) | ((u32)((p)[3]) << 24)   )
-
-struct salsa20_ctx
-{
-	u32 input[16];
+struct salsa20_ctx {
+	u32 initial_state[16];
 };
 
-static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
+static void salsa20_block(u32 *state, u32 *stream)
 {
 	u32 x[16];
 	int i;
 
-	memcpy(x, input, sizeof(x));
-	for (i = 20; i > 0; i -= 2) {
+	memcpy(x, state, sizeof(x));
+
+	for (i = 0; i < 20; i += 2) {
 		x[ 4] ^= rol32((x[ 0] + x[12]),  7);
 		x[ 8] ^= rol32((x[ 4] + x[ 0]),  9);
 		x[12] ^= rol32((x[ 8] + x[ 4]), 13);
@@ -95,145 +73,135 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
 		x[14] ^= rol32((x[13] + x[12]), 13);
 		x[15] ^= rol32((x[14] + x[13]), 18);
 	}
-	for (i = 0; i < 16; ++i)
-		x[i] += input[i];
-	for (i = 0; i < 16; ++i)
-		U32TO8_LITTLE(output + 4 * i,x[i]);
-}
 
-static const char sigma[16] = "expand 32-byte k";
-static const char tau[16] = "expand 16-byte k";
+	for (i = 0; i < 16; i++)
+		stream[i] = (__force u32)cpu_to_le32(x[i] + state[i]);
+
+	if (++state[8] == 0)
+		state[9]++;
+}
 
-static void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k, u32 kbytes)
+static void salsa20_docrypt(u32 *state, u8 *dst, const u8 *src,
+			    unsigned int bytes)
 {
-	const char *constants;
+	u32 stream[SALSA20_BLOCK_SIZE / sizeof(u32)];
 
-	ctx->input[1] = U8TO32_LITTLE(k + 0);
-	ctx->input[2] = U8TO32_LITTLE(k + 4);
-	ctx->input[3] = U8TO32_LITTLE(k + 8);
-	ctx->input[4] = U8TO32_LITTLE(k + 12);
-	if (kbytes == 32) { /* recommended */
-		k += 16;
-		constants = sigma;
-	} else { /* kbytes == 16 */
-		constants = tau;
+	if (dst != src)
+		memcpy(dst, src, bytes);
+
+	while (bytes >= SALSA20_BLOCK_SIZE) {
+		salsa20_block(state, stream);
+		crypto_xor(dst, (const u8 *)stream, SALSA20_BLOCK_SIZE);
+		bytes -= SALSA20_BLOCK_SIZE;
+		dst += SALSA20_BLOCK_SIZE;
+	}
+	if (bytes) {
+		salsa20_block(state, stream);
+		crypto_xor(dst, (const u8 *)stream, bytes);
 	}
-	ctx->input[11] = U8TO32_LITTLE(k + 0);
-	ctx->input[12] = U8TO32_LITTLE(k + 4);
-	ctx->input[13] = U8TO32_LITTLE(k + 8);
-	ctx->input[14] = U8TO32_LITTLE(k + 12);
-	ctx->input[0] = U8TO32_LITTLE(constants + 0);
-	ctx->input[5] = U8TO32_LITTLE(constants + 4);
-	ctx->input[10] = U8TO32_LITTLE(constants + 8);
-	ctx->input[15] = U8TO32_LITTLE(constants + 12);
 }
 
-static void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv)
+static void salsa20_init(u32 *state, const struct salsa20_ctx *ctx,
+			 const u8 *iv)
 {
-	ctx->input[6] = U8TO32_LITTLE(iv + 0);
-	ctx->input[7] = U8TO32_LITTLE(iv + 4);
-	ctx->input[8] = 0;
-	ctx->input[9] = 0;
+	memcpy(state, ctx->initial_state, sizeof(ctx->initial_state));
+	state[6] = get_unaligned_le32(iv + 0);
+	state[7] = get_unaligned_le32(iv + 4);
 }
 
-static void salsa20_encrypt_bytes(struct salsa20_ctx *ctx, u8 *dst,
-				  const u8 *src, unsigned int bytes)
+static int salsa20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  unsigned int keysize)
 {
-	u8 buf[64];
-
-	if (dst != src)
-		memcpy(dst, src, bytes);
-
-	while (bytes) {
-		salsa20_wordtobyte(buf, ctx->input);
-
-		ctx->input[8]++;
-		if (!ctx->input[8])
-			ctx->input[9]++;
+	static const char sigma[16] = "expand 32-byte k";
+	static const char tau[16] = "expand 16-byte k";
+	struct salsa20_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const char *constants;
 
-		if (bytes <= 64) {
-			crypto_xor(dst, buf, bytes);
-			return;
-		}
+	if (keysize != SALSA20_MIN_KEY_SIZE &&
+	    keysize != SALSA20_MAX_KEY_SIZE)
+		return -EINVAL;
 
-		crypto_xor(dst, buf, 64);
-		bytes -= 64;
-		dst += 64;
+	ctx->initial_state[1] = get_unaligned_le32(key + 0);
+	ctx->initial_state[2] = get_unaligned_le32(key + 4);
+	ctx->initial_state[3] = get_unaligned_le32(key + 8);
+	ctx->initial_state[4] = get_unaligned_le32(key + 12);
+	if (keysize == 32) { /* recommended */
+		key += 16;
+		constants = sigma;
+	} else { /* keysize == 16 */
+		constants = tau;
 	}
-}
-
-/*
- * End of code taken from D. J. Bernstein's reference implementation.
- */
+	ctx->initial_state[11] = get_unaligned_le32(key + 0);
+	ctx->initial_state[12] = get_unaligned_le32(key + 4);
+	ctx->initial_state[13] = get_unaligned_le32(key + 8);
+	ctx->initial_state[14] = get_unaligned_le32(key + 12);
+	ctx->initial_state[0]  = get_unaligned_le32(constants + 0);
+	ctx->initial_state[5]  = get_unaligned_le32(constants + 4);
+	ctx->initial_state[10] = get_unaligned_le32(constants + 8);
+	ctx->initial_state[15] = get_unaligned_le32(constants + 12);
+
+	/* space for the nonce; it will be overridden for each request */
+	ctx->initial_state[6] = 0;
+	ctx->initial_state[7] = 0;
+
+	/* initial block number */
+	ctx->initial_state[8] = 0;
+	ctx->initial_state[9] = 0;
 
-static int setkey(struct crypto_tfm *tfm, const u8 *key,
-		  unsigned int keysize)
-{
-	struct salsa20_ctx *ctx = crypto_tfm_ctx(tfm);
-	salsa20_keysetup(ctx, key, keysize);
 	return 0;
 }
 
-static int encrypt(struct blkcipher_desc *desc,
-		   struct scatterlist *dst, struct scatterlist *src,
-		   unsigned int nbytes)
+static int salsa20_crypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
-	struct crypto_blkcipher *tfm = desc->tfm;
-	struct salsa20_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct salsa20_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	u32 state[16];
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, 64);
+	err = skcipher_walk_virt(&walk, req, true);
 
-	salsa20_ivsetup(ctx, walk.iv);
+	salsa20_init(state, ctx, walk.iv);
 
-	while (walk.nbytes >= 64) {
-		salsa20_encrypt_bytes(ctx, walk.dst.virt.addr,
-				      walk.src.virt.addr,
-				      walk.nbytes - (walk.nbytes % 64));
-		err = blkcipher_walk_done(desc, &walk, walk.nbytes % 64);
-	}
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
 
-	if (walk.nbytes) {
-		salsa20_encrypt_bytes(ctx, walk.dst.virt.addr,
-				      walk.src.virt.addr, walk.nbytes);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		salsa20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
+				nbytes);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
 }
 
-static struct crypto_alg alg = {
-	.cra_name           =   "salsa20",
-	.cra_driver_name    =   "salsa20-generic",
-	.cra_priority       =   100,
-	.cra_flags          =   CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_type           =   &crypto_blkcipher_type,
-	.cra_blocksize      =   1,
-	.cra_ctxsize        =   sizeof(struct salsa20_ctx),
-	.cra_alignmask      =	3,
-	.cra_module         =   THIS_MODULE,
-	.cra_u              =   {
-		.blkcipher = {
-			.setkey         =   setkey,
-			.encrypt        =   encrypt,
-			.decrypt        =   encrypt,
-			.min_keysize    =   SALSA20_MIN_KEY_SIZE,
-			.max_keysize    =   SALSA20_MAX_KEY_SIZE,
-			.ivsize         =   SALSA20_IV_SIZE,
-		}
-	}
+static struct skcipher_alg alg = {
+	.base.cra_name		= "salsa20",
+	.base.cra_driver_name	= "salsa20-generic",
+	.base.cra_priority	= 100,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct salsa20_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= SALSA20_MIN_KEY_SIZE,
+	.max_keysize		= SALSA20_MAX_KEY_SIZE,
+	.ivsize			= SALSA20_IV_SIZE,
+	.chunksize		= SALSA20_BLOCK_SIZE,
+	.setkey			= salsa20_setkey,
+	.encrypt		= salsa20_crypt,
+	.decrypt		= salsa20_crypt,
 };
 
 static int __init salsa20_generic_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_skcipher(&alg);
 }
 
 static void __exit salsa20_generic_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_skcipher(&alg);
 }
 
 module_init(salsa20_generic_mod_init);
-- 
2.15.1
