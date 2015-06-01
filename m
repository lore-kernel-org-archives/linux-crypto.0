From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 1/9] crypto: Add a generic ChaCha20 stream cipher implementation
Date: Mon,  1 Jun 2015 13:43:56 +0200
Message-ID: <1433159044-30753-2-git-send-email-martin@strongswan.org>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:40491 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbFAMZA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 08:25:00 -0400
In-Reply-To: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ChaCha20 is a high speed 256-bit key size stream cipher algorithm designed by
Daniel J. Bernstein. It is further specified in RFC7539 for use in IETF
protocols as a building block for the ChaCha20-Poly1305 AEAD.

This is a portable C implementation without any architecture specific
optimizations. It uses a 16-byte IV, which includes the 12-byte ChaCha20 nonce
prepended by the initial block counter. Some algorithms require an explicit
counter value, for example the mentioned AEAD construction.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 crypto/Kconfig            |  13 +++
 crypto/Makefile           |   1 +
 crypto/chacha20_generic.c | 216 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+)
 create mode 100644 crypto/chacha20_generic.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0ff4cd4..5407e8f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1156,6 +1156,19 @@ config CRYPTO_SALSA20_X86_64
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
+config CRYPTO_CHACHA20
+	tristate "ChaCha20 cipher algorithm"
+	select CRYPTO_BLKCIPHER
+	help
+	  ChaCha20 cipher algorithm, RFC7539.
+
+	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
+	  Bernstein and further specified in RFC7539 for use in IETF protocols.
+	  This is the portable C implementation of ChaCha20.
+
+	  See also:
+	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
+
 config CRYPTO_SEED
 	tristate "SEED cipher algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index 5db5b95..be87ec1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
+obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
new file mode 100644
index 0000000..fa42e70
--- /dev/null
+++ b/crypto/chacha20_generic.c
@@ -0,0 +1,216 @@
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <crypto/algapi.h>
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#define CHACHA20_NONCE_SIZE 16
+#define CHACHA20_KEY_SIZE   32
+#define CHACHA20_BLOCK_SIZE 64
+
+struct chacha20_ctx {
+	u32 key[8];
+};
+
+static inline u32 rotl32(u32 v, u8 n)
+{
+	return (v << n) | (v >> (sizeof(v) * 8 - n));
+}
+
+static inline u32 le32_to_cpuvp(const void *p)
+{
+	return le32_to_cpup(p);
+}
+
+static void chacha20_block(u32 *state, void *stream)
+{
+	u32 x[16], *out = stream;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(x); i++)
+		x[i] = state[i];
+
+	for (i = 0; i < 20; i += 2) {
+		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
+		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
+		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
+		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
+
+		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
+		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
+		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
+		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
+
+		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
+		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
+		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
+		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
+
+		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
+		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
+		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
+		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
+
+		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
+		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
+		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
+		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
+
+		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
+		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
+		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
+		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
+
+		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
+		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
+		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
+		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
+
+		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
+		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
+		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
+		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(x); i++)
+		out[i] = cpu_to_le32(x[i] + state[i]);
+
+	state[12]++;
+}
+
+static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
+			     unsigned int bytes)
+{
+	u8 stream[CHACHA20_BLOCK_SIZE];
+
+	if (dst != src)
+		memcpy(dst, src, bytes);
+
+	while (bytes >= CHACHA20_BLOCK_SIZE) {
+		chacha20_block(state, stream);
+		crypto_xor(dst, stream, CHACHA20_BLOCK_SIZE);
+		bytes -= CHACHA20_BLOCK_SIZE;
+		dst += CHACHA20_BLOCK_SIZE;
+	}
+	if (bytes) {
+		chacha20_block(state, stream);
+		crypto_xor(dst, stream, bytes);
+	}
+}
+
+static void chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
+{
+	static const char constant[16] = "expand 32-byte k";
+
+	state[0]  = le32_to_cpuvp(constant +  0);
+	state[1]  = le32_to_cpuvp(constant +  4);
+	state[2]  = le32_to_cpuvp(constant +  8);
+	state[3]  = le32_to_cpuvp(constant + 12);
+	state[4]  = ctx->key[0];
+	state[5]  = ctx->key[1];
+	state[6]  = ctx->key[2];
+	state[7]  = ctx->key[3];
+	state[8]  = ctx->key[4];
+	state[9]  = ctx->key[5];
+	state[10] = ctx->key[6];
+	state[11] = ctx->key[7];
+	state[12] = le32_to_cpuvp(iv +  0);
+	state[13] = le32_to_cpuvp(iv +  4);
+	state[14] = le32_to_cpuvp(iv +  8);
+	state[15] = le32_to_cpuvp(iv + 12);
+}
+
+static int chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
+			   unsigned int keysize)
+{
+	struct chacha20_ctx *ctx = crypto_tfm_ctx(tfm);
+	int i;
+
+	if (keysize != CHACHA20_KEY_SIZE)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
+		ctx->key[i] = le32_to_cpuvp(key + i * sizeof(u32));
+
+	return 0;
+}
+
+static int chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	u32 state[16];
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
+
+	chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
+
+	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
+		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
+				 rounddown(walk.nbytes, CHACHA20_BLOCK_SIZE));
+		err = blkcipher_walk_done(desc, &walk,
+					  walk.nbytes % CHACHA20_BLOCK_SIZE);
+	}
+
+	if (walk.nbytes) {
+		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
+				 walk.nbytes);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static struct crypto_alg alg = {
+	.cra_name		= "chacha20",
+	.cra_driver_name	= "chacha20-generic",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_ctxsize		= sizeof(struct chacha20_ctx),
+	.cra_alignmask		= sizeof(u32) - 1,
+	.cra_module		= THIS_MODULE,
+	.cra_u			= {
+		.blkcipher = {
+			.min_keysize	= CHACHA20_KEY_SIZE,
+			.max_keysize	= CHACHA20_KEY_SIZE,
+			.ivsize		= CHACHA20_NONCE_SIZE,
+			.geniv		= "seqiv",
+			.setkey		= chacha20_setkey,
+			.encrypt	= chacha20_crypt,
+			.decrypt	= chacha20_crypt,
+		},
+	},
+};
+
+static int __init chacha20_generic_mod_init(void)
+{
+	return crypto_register_alg(&alg);
+}
+
+static void __exit chacha20_generic_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(chacha20_generic_mod_init);
+module_exit(chacha20_generic_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_DESCRIPTION("chacha20 cipher algorithm");
+MODULE_ALIAS_CRYPTO("chacha20");
+MODULE_ALIAS_CRYPTO("chacha20-generic");
-- 
1.9.1
