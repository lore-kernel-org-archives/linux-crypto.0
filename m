From: rsnel@cube.dyndns.org
Subject: [PATCHv2 5/6] LRW, Liskov Rivest Wagner, a tweakable narrow block cipher mode
Date: Sat, 02 Sep 2006 03:00:26 +0200
Message-ID: <115715883237-git-send-email-rsnel@cube.dyndns.org>
References: <20060901103707.GA17110@gondor.apana.org.au>
Reply-To: rsnel@cube.dyndns.org
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3085 "EHLO
	smtp-vbr13.xs4all.nl") by vger.kernel.org with ESMTP
	id S1750793AbWIBBAq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Sep 2006 21:00:46 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <20060901103707.GA17110@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rik Snel <rsnel@cube.dyndns.org>

Main module, this implements the Liskov Rivest Wagner block cipher mode
in the new blockcipher API. The implementation is based on ecb.c.

The LRW-32-AES specification I used can be found at:
http://grouper.ieee.org/groups/1619/email/pdf00017.pdf

It implements the optimization specified as optional in the
specification, and in addition it uses optimized multiplication
routines from gf128mul.c.

Since gf128mul.[ch] is not tested on bigendian, this cipher mode
may currently fail badly on bigendian machines.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---

Note: I rerolled the loop because it turned out that I had unrolled it
wrong. (I noticed it after I added the long testvector; a cypherblock
was split in two by a page boundary and the reconstructed block was
discarded because of an error in the unrolling).

 crypto/Kconfig  |   13 ++
 crypto/Makefile |    1 
 crypto/lrw.c    |  291 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 305 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6b23c20..dfdfe08 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -156,6 +156,19 @@ config CRYPTO_CBC
 	  CBC: Cipher Block Chaining mode
 	  This block cipher algorithm is required for IPSec.
 
+config CRYPTO_LRW
+	tristate "LRW support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_GF128MUL
+	default n
+	help
+	  LRW: Liskov Rivest Wagner, a tweakable, non malleable, non movable
+	  narrow block cipher mode. Use it with cipher specification string
+	  aes-lrw-benbi, the key must be 256, 320 or 384. The first 128, 192
+	  or 256 bits in the key are used for AES and the rest is used to tie
+	  each cipher block to its logical position.
+
 config CRYPTO_DES
 	tristate "DES and Triple DES EDE cipher algorithms"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index bf0406b..e2e57be 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
+obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_DES) += des.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
diff --git a/crypto/lrw.c b/crypto/lrw.c
new file mode 100644
index 0000000..a037379
--- /dev/null
+++ b/crypto/lrw.c
@@ -0,0 +1,291 @@
+/* LRW: as defined by Cyril Guyot in
+ *	http://grouper.ieee.org/groups/1619/email/pdf00017.pdf
+ *
+ * Copyright (c) 2006 Rik Snel <rsnel@cube.dyndns.org>
+ *
+ * Based om ecb.c
+ * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+/* This implementation is checked against the test vectors in the above
+ * document and by a test vector provided by Ken Buchanan at
+ * http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html
+ *
+ * The test vectors are included in the testing module tcrypt.[ch] */
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+
+#include "b128ops.h"
+#include "gf128mul.h"
+
+struct priv {
+	struct crypto_cipher *child;
+	/* optimizes multiplying a random (non incrementing, as at the
+	 * start of a new sector) value with key2, we could also have
+	 * used 4k optimization tables or no optimization at all. In the
+	 * latter case we would have to store key2 here */
+	struct gf128mul_64k table;
+	/* stores:
+	 *  key2*{ 0,0,...0,0,0,0,1 }, key2*{ 0,0,...0,0,0,1,1 },
+	 *  key2*{ 0,0,...0,0,1,1,1 }, key2*{ 0,0,...0,1,1,1,1 }
+	 *  key2*{ 0,0,...1,1,1,1,1 }, etc
+	 * needed for optimized multiplication of incrementing values
+	 * with key2 */
+	u64 mulinc[128][GF128MUL_BYTES >> 3];
+};
+
+static inline void setbit128(void *b, int bit)
+{
+	int index = 15 - bit/8;
+	((u8 *)b)[index] |= 1<<(bit%8);
+}
+
+static int setkey(struct crypto_tfm *parent, const u8 *key,
+			     unsigned int keylen)
+{
+	struct priv *ctx = crypto_tfm_ctx(parent);
+	struct crypto_cipher *child = ctx->child;
+	int err, i;
+	u64 tmp[2] = { 0, }, scratch[2];
+	int bsize = crypto_cipher_blocksize(child);
+
+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
+				       CRYPTO_TFM_REQ_MASK);
+	if ((err = crypto_cipher_setkey(child, key, keylen - bsize)))
+		return err;
+	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
+				     CRYPTO_TFM_RES_MASK);
+
+
+	/* initialize multiplication table for Key2 */
+	gf128mul_init_64k_bbe(&ctx->table, (u64 *)(key + keylen - bsize));
+
+	/* initialize optimization table */
+	for (i = 0; i < 128; i++) {
+		setbit128(tmp, i);
+		b128ops_mov(ctx->mulinc[i], tmp);
+		gf128mul_64k_bbe(ctx->mulinc[i], &ctx->table, scratch);
+	}
+
+	return 0;
+}
+
+struct sinfo {
+	u64 b1[2], b2[2];
+	struct crypto_tfm *tfm;
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+};
+
+static inline void inc(u64 *iv)
+{
+	if (!(iv[1] = cpu_to_be64(be64_to_cpu(iv[1]) + 1)))
+		iv[0] = cpu_to_be64(be64_to_cpu(iv[0]) + 1);
+}
+
+static inline void round(struct sinfo *s, u8 *dst, const u8 *src)
+{
+	b128ops_xor(s->b2, src);		/* PP <- T xor P */
+	s->fn(s->tfm, dst, (u8 *)s->b2);	/* CC <- E(Key2,PP) */
+	b128ops_xor(dst, s->b1);		/* C <- T xor CC */
+}
+
+/* this returns the number of consequative 1 bits
+ * starting from the right in i */
+static inline int get_index8(u8 i)
+{
+	int j = 1;
+
+	if (i&1) {
+		while ((i >>= 1)&1) j++;
+		return j;
+	}
+
+	return 0;
+}
+
+/* this returns the number of consequative 1 bits starting
+ * from the right, get_index128(00 00 00 00 00 00 ... 00 00 10 FB) = 2 */
+static inline int get_index128(u8 *block)
+{
+	int inc, ret = 0, len = 16;
+	while ((inc = get_index8(block[--len])) == 8) ret += 8;
+	return ret + inc;
+}
+
+static int crypt(struct blkcipher_desc *d,
+			    struct scatterlist *dst,
+			    struct scatterlist *src,
+			    unsigned int nbytes, struct priv *ctx,
+			    void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
+{
+	struct blkcipher_walk w;
+	int err, old_t_known = 0;
+	unsigned int avail;
+	const int bs = crypto_cipher_blocksize(ctx->child);
+	struct sinfo s = {
+		.tfm = crypto_cipher_tfm(ctx->child),
+		.fn = fn
+	};
+
+	blkcipher_walk_init(&w, dst, src, nbytes);
+
+	err = blkcipher_walk_virt(d, &w);
+
+	while ((avail = w.nbytes)) {
+		u8 *wsrc = w.src.virt.addr;
+		u8 *wdst = w.dst.virt.addr;
+		do {
+			if (old_t_known) {
+				/* old T is available in s.b1; new one
+			 	 * must be made available in b1 and b2 */
+
+				/* T <- I*Key2, using the optimization
+				 * discussed in the specification */
+				b128ops_xor(s.b1, ctx->mulinc[
+						get_index128(w.iv)]);
+				inc((u64*)w.iv);
+				b128ops_mov(s.b2, s.b1);
+			} else {
+				/* calculate first value of T */
+				b128ops_mov(s.b1, w.iv);
+				/* T <- I*Key2 */
+				gf128mul_64k_bbe(s.b1, &ctx->table, s.b2);
+				old_t_known = 1;
+			}
+
+			round(&s, wdst, wsrc);
+
+			wsrc += bs;
+			wdst += bs;
+		} while ((avail -= bs) >= bs);
+
+		err = blkcipher_walk_done(d, &w, avail);
+	}
+
+	return err;
+}
+
+static int encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes)
+{
+	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
+	return crypt(desc, dst, src, nbytes, ctx,
+			crypto_cipher_alg(ctx->child)->cia_encrypt);
+}
+
+static int decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes)
+{
+	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
+	return crypt(desc, dst, src, nbytes, ctx,
+			crypto_cipher_alg(ctx->child)->cia_decrypt);
+}
+
+static int init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct priv *ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+
+	tfm = crypto_spawn_tfm(spawn);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	if (crypto_tfm_alg_blocksize(tfm) != 16) {
+		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
+		return -EINVAL;
+	}
+
+	ctx->child = crypto_cipher_cast(tfm);
+	return 0;
+}
+
+static void exit_tfm(struct crypto_tfm *tfm)
+{
+	struct priv *ctx = crypto_tfm_ctx(tfm);
+	crypto_free_cipher(ctx->child);
+}
+
+static struct crypto_instance *alloc(void *param, unsigned int len)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+
+	alg = crypto_get_attr_alg(param, len, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	if (IS_ERR(alg))
+		return ERR_PTR(PTR_ERR(alg));
+
+	inst = crypto_alloc_instance("lrw", alg);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+
+	if (alg->cra_alignmask < 7) inst->alg.cra_alignmask = 7;
+	else inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_blkcipher_type;
+
+	if (!(alg->cra_blocksize % 4))
+		inst->alg.cra_alignmask |= 3;
+	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
+	inst->alg.cra_blkcipher.min_keysize =
+		alg->cra_cipher.cia_min_keysize + alg->cra_blocksize;
+	inst->alg.cra_blkcipher.max_keysize =
+		alg->cra_cipher.cia_max_keysize + alg->cra_blocksize;
+
+	inst->alg.cra_ctxsize = sizeof(struct priv);
+
+	inst->alg.cra_init = init_tfm;
+	inst->alg.cra_exit = exit_tfm;
+
+	inst->alg.cra_blkcipher.setkey = setkey;
+	inst->alg.cra_blkcipher.encrypt = encrypt;
+	inst->alg.cra_blkcipher.decrypt = decrypt;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static void free(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct crypto_template crypto_tmpl = {
+	.name = "lrw",
+	.alloc = alloc,
+	.free = free,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_module_init(void)
+{
+	return crypto_register_template(&crypto_tmpl);
+}
+
+static void __exit crypto_module_exit(void)
+{
+	crypto_unregister_template(&crypto_tmpl);
+}
+
+module_init(crypto_module_init);
+module_exit(crypto_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LRW block cipher mode");
-- 
1.4.1.1


-- 
VGER BF report: U 0.5
