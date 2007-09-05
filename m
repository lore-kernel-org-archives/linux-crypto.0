From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] an XTS blockcipher mode implementation without partial
	blocks
Date: Wed, 5 Sep 2007 02:29:06 +0200
Message-ID: <20070905002906.GA6930@Chamillionaire.breakpoint.cc>
References: <11888559161619-git-send-email-rsnel@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, christoph.sievers@gmail.com,
	herbert@gondor.apana.org.au
To: Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38816 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505AbXIEA3L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Sep 2007 20:29:11 -0400
Content-Disposition: inline
In-Reply-To: <11888559161619-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Rik Snel | 2007-09-03 23:45:16 [+0200]:

>diff --git a/crypto/xts.c b/crypto/xts.c
>new file mode 100644
>index 0000000..7d9a353
>--- /dev/null
>+++ b/crypto/xts.c
>@@ -0,0 +1,277 @@
>+/* XTS: as defined in IEEE1619/D16
>+ *	http://grouper.ieee.org/groups/1619/email/pdf00086.pdf
>+ *	(sector sizes which are not a multiple of 16 bytes are,
>+ *	however currently unsupported)
>+ *
>+ * Copyright (c) 2007 Rik Snel <rsnel@cube.dyndns.org>
>+ *
>+ * Based om ecb.c
>+ * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
>+ *
>+ * This program is free software; you can redistribute it and/or modify it
>+ * under the terms of the GNU General Public License as published by the Free
>+ * Software Foundation; either version 2 of the License, or (at your option)
>+ * any later version.
>+ */
>+#include <crypto/algapi.h>
>+#include <linux/err.h>
>+#include <linux/init.h>
>+#include <linux/kernel.h>
>+#include <linux/module.h>
>+#include <linux/scatterlist.h>
>+#include <linux/slab.h>
>+
>+#include <crypto/b128ops.h>
>+#include <crypto/gf128mul.h>
>+
>+struct priv {
>+	struct crypto_cipher *child;
>+	struct crypto_cipher *tweak;
>+};
>+
>+static int setkey(struct crypto_tfm *parent, const u8 *key,
>+		  unsigned int keylen)
>+{
>+	struct priv *ctx = crypto_tfm_ctx(parent);
>+	struct crypto_cipher *child = ctx->tweak;
>+	u32 *flags = &parent->crt_flags;
>+	int err;
>+
>+	/* key consists of keys of equal size concatenated, therefore
>+	 * the length must be even */
>+	if (keylen % 2) {
>+		/* does anyone read this flag, it is not set if key setup
>+		 * fails below (or is it?) */
>+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
>+		return -EINVAL;
>+	}

A algo user might read this.

>+
>+	/* we need two cipher instances: one to compute the inital 'tweak'
>+	 * by encrypting the IV (usually the 'plain' iv) and the other
>+	 * one to encrypt and decrypt the data */
>+
>+	/* tweak cipher, uses Key2 i.e. the second half of *key */
>+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
>+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
>+				       CRYPTO_TFM_REQ_MASK);
>+	if ((err = crypto_cipher_setkey(child, key + keylen/2, keylen/2)))
>+		return err;

why not
	err = crypto_cipher_setkey(child, key + keylen/2, keylen/2);
	if (err)
		return err;

>+	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
>+				     CRYPTO_TFM_RES_MASK);
>+
>+	child = ctx->child;
>+
>+	/* data cipher, uses Key1 i.e. the first half of *key */
>+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
>+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
>+				       CRYPTO_TFM_REQ_MASK);
>+	if ((err = crypto_cipher_setkey(child, key, keylen/2)))
...

>+		return err;
>+	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
>+				     CRYPTO_TFM_RES_MASK);
>+
>+	return 0;
>+}
>+
>+struct sinfo {
>+	be128 t;
>+	struct crypto_tfm *tfm;
>+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
>+};
>+
>+static inline void xts_round(struct sinfo *s, void *dst, const void *src)
>+{
>+	be128_xor(dst, &s->t, src);		/* PP <- T xor P */
>+	s->fn(s->tfm, dst, dst);		/* CC <- E(Key1,PP) */
>+	be128_xor(dst, dst, &s->t);		/* C <- T xor CC */
>+}
>+
>+static int crypt(struct blkcipher_desc *d,
>+		 struct blkcipher_walk *w, struct priv *ctx,
>+		 void (*tw)(struct crypto_tfm *, u8 *, const u8 *),
>+		 void (*fn)(struct crypto_tfm *, u8 *, const u8 *))
>+{
>+	int err;
>+	unsigned int avail;
>+	const int bs = crypto_cipher_blocksize(ctx->child);
>+	struct sinfo s = {
>+		.tfm = crypto_cipher_tfm(ctx->child),
>+		.fn = fn
>+	};
>+	be128 *iv;
>+	u8 *wsrc;
>+	u8 *wdst;
>+
>+	err = blkcipher_walk_virt(d, w);
>+	if (!(avail = w->nbytes))
...
>+		return err;
>+
>+	wsrc = w->src.virt.addr;
>+	wdst = w->dst.virt.addr;
>+
>+	/* calculate first value of T */
>+	iv = (be128 *)w->iv;
>+	tw(crypto_cipher_tfm(ctx->tweak), (void*)&s.t, w->iv);
>+
>+	goto first;
>+
>+	for (;;) {
>+		do {
>+			gf128mul_x_ble(&s.t, &s.t);
>+
>+first:

why not

int first = 0;
...
do {
  if (!first) {
    gf128mul_x_ble(&s.t, &s.t);
    first = 1;
}

The compiler should generate similar code.

>+			xts_round(&s, wdst, wsrc);
>+
>+			wsrc += bs;
>+			wdst += bs;
>+		} while ((avail -= bs) >= bs);
>+
>+		err = blkcipher_walk_done(d, w, avail);
>+		if (!(avail = w->nbytes))

		avail = w->nbytes;
		if (!avail)

>+			break;
>+
>+		wsrc = w->src.virt.addr;
>+		wdst = w->dst.virt.addr;
>+	}
>+
>+	return err;
>+}
>+
>+static int encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>+		   struct scatterlist *src, unsigned int nbytes)
>+{
>+	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
>+	struct blkcipher_walk w;
>+
>+	blkcipher_walk_init(&w, dst, src, nbytes);
>+	return crypt(desc, &w, ctx, crypto_cipher_alg(ctx->tweak)->cia_encrypt,
>+		     crypto_cipher_alg(ctx->child)->cia_encrypt);
>+}
>+
>+static int decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>+		   struct scatterlist *src, unsigned int nbytes)
>+{
>+	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
>+	struct blkcipher_walk w;
>+
>+	blkcipher_walk_init(&w, dst, src, nbytes);
>+	return crypt(desc, &w, ctx, crypto_cipher_alg(ctx->tweak)->cia_encrypt,
>+		     crypto_cipher_alg(ctx->child)->cia_decrypt);
>+}
>+
>+static int init_tfm(struct crypto_tfm *tfm)
>+{
>+	struct crypto_cipher *cipher;
>+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
>+	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
>+	struct priv *ctx = crypto_tfm_ctx(tfm);
>+	u32 *flags = &tfm->crt_flags;
>+
>+	cipher = crypto_spawn_cipher(spawn);
>+	if (IS_ERR(cipher))
>+		return PTR_ERR(cipher);
>+
>+	if (crypto_cipher_blocksize(cipher) != 16) {
>+		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
>+		return -EINVAL;
>+	}
>+
>+	ctx->child = cipher;
>+
>+	cipher = crypto_spawn_cipher(spawn);
>+	if (IS_ERR(cipher))
>+		return PTR_ERR(cipher);

don't you want to free ctx->child on error?

>+
>+	/* this check isn't really needed */
>+	if (crypto_cipher_blocksize(cipher) != 16) {
>+		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
>+		return -EINVAL;
>+	}

and here both.
Right now you should get the same algo but I don't thing that a check
will hurt.

>+
>+	ctx->tweak = cipher;
>+
>+	return 0;
>+}
>+
>+static void exit_tfm(struct crypto_tfm *tfm)
>+{
>+	struct priv *ctx = crypto_tfm_ctx(tfm);
>+	crypto_free_cipher(ctx->child);
>+	crypto_free_cipher(ctx->tweak);
>+}
>+
>+static struct crypto_instance *alloc(struct rtattr **tb)
>+{
>+	struct crypto_instance *inst;
>+	struct crypto_alg *alg;
>+	int err;
>+
>+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
>+	if (err)
>+		return ERR_PTR(err);
>+
>+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
>+				  CRYPTO_ALG_TYPE_MASK);
>+	if (IS_ERR(alg))
>+		return ERR_PTR(PTR_ERR(alg));
>+
>+	inst = crypto_alloc_instance("xts", alg);
>+	if (IS_ERR(inst))
>+		goto out_put_alg;
>+
>+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
>+	inst->alg.cra_priority = alg->cra_priority;
>+	inst->alg.cra_blocksize = alg->cra_blocksize;
>+
>+	if (alg->cra_alignmask < 7) inst->alg.cra_alignmask = 7;
>+	else inst->alg.cra_alignmask = alg->cra_alignmask;
>+	inst->alg.cra_type = &crypto_blkcipher_type;
>+
>+	if (!(alg->cra_blocksize % 4))
>+		inst->alg.cra_alignmask |= 3;

please do

if (a)
 do_on_a();
else
 do_on_b();

besides that, what are you trying to do? The if() makes sure that the
alignmask is atleast 7 (0b111). And then, depending on the block size
you might set the lower two bits (3 is 0b11) which are allready set.


>+	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
>+	inst->alg.cra_blkcipher.min_keysize = 2*alg->cra_cipher.cia_min_keysize;
>+	inst->alg.cra_blkcipher.max_keysize = 2*alg->cra_cipher.cia_max_keysize;

a space between the operator might not be a bad idea.

>+
>+	inst->alg.cra_ctxsize = sizeof(struct priv);
>+
>+	inst->alg.cra_init = init_tfm;
>+	inst->alg.cra_exit = exit_tfm;
>+
>+	inst->alg.cra_blkcipher.setkey = setkey;
>+	inst->alg.cra_blkcipher.encrypt = encrypt;
>+	inst->alg.cra_blkcipher.decrypt = decrypt;
>+
>+out_put_alg:
>+	crypto_mod_put(alg);
>+	return inst;
>+}
>+
>+static void free(struct crypto_instance *inst)
>+{
>+	crypto_drop_spawn(crypto_instance_ctx(inst));
>+	kfree(inst);
>+}
>+
>+static struct crypto_template crypto_tmpl = {
>+	.name = "xts",
>+	.alloc = alloc,
>+	.free = free,
>+	.module = THIS_MODULE,
>+};
>+
>+static int __init crypto_module_init(void)
>+{
>+	return crypto_register_template(&crypto_tmpl);
>+}
>+
>+static void __exit crypto_module_exit(void)
>+{
>+	crypto_unregister_template(&crypto_tmpl);
>+}
>+
>+module_init(crypto_module_init);
>+module_exit(crypto_module_exit);
>+
>+MODULE_LICENSE("GPL");
>+MODULE_DESCRIPTION("XTS block cipher mode");

The other things are looking fine to me. You might want to consider
using ./scripts/checkpatch.pl on your patch the next time :)

Sebastian
