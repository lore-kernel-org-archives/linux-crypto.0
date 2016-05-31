From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 31 May 2016 13:52:32 +0200
Message-ID: <4593825.q48Y9K9RSZ@positron.chronox.de>
References: <17649236.piPdUxUzaM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35256 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbcEaLyG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 07:54:06 -0400
In-Reply-To: <17649236.piPdUxUzaM@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SP800-108 compliant Key Derivation Function is implemented as a
random number generator considering that it behaves like a deterministic
RNG.

All three KDF types specified in SP800-108 are implemented.

The code comments provide details about how to invoke the different KDF
types.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/kdf.c | 514 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 514 insertions(+)
 create mode 100644 crypto/kdf.c

diff --git a/crypto/kdf.c b/crypto/kdf.c
new file mode 100644
index 0000000..b39bddf
--- /dev/null
+++ b/crypto/kdf.c
@@ -0,0 +1,514 @@
+/*
+ * Copyright (C) 2015, Stephan Mueller <smueller@chronox.de>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * ALTERNATIVELY, this product may be distributed under the terms of
+ * the GNU General Public License, in which case the provisions of the GPL2
+ * are required INSTEAD OF the above restrictions.  (This clause is
+ * necessary due to a potential bad interaction between the GPL and
+ * the restrictions contained in a BSD-style copyright.)
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ */
+
+/*
+ * For performing a KDF operation, the following input is required
+ * from the caller:
+ *
+ *	* Keying material to be used to derive the new keys from
+ *	  (denoted as Ko in SP800-108)
+ *	* Label -- a free form binary string
+ *	* Context -- a free form binary string
+ *
+ * The KDF is implemented as a random number generator.
+ *
+ * The Ko keying material is to be provided with the initialization of the KDF
+ * "random number generator", i.e. with the crypto_rng_reset function.
+ *
+ * The Label and Context concatenated string is provided when obtaining random
+ * numbers, i.e. with the crypto_rng_generate function. The caller must format
+ * the free-form Label || Context input as deemed necessary for the given
+ * purpose. Note, SP800-108 mandates that the Label and Context are separated
+ * by a 0x00 byte, i.e. the caller shall provide the input as
+ * Label || 0x00 || Context when trying to be compliant to SP800-108. For
+ * the feedback KDF, an IV is required as documented below.
+ *
+ * Example without proper error handling:
+ *	char *keying_material = "\x00\x11\x22\x33\x44\x55\x66\x77";
+ *	char *label_context = "\xde\xad\xbe\xef\x00\xde\xad\xbe\xef";
+ *	kdf = crypto_alloc_rng(name, 0, 0);
+ *	crypto_rng_reset(kdf, keying_material, 8);
+ *	crypto_rng_generate(kdf, label_context, 9, outbuf, outbuflen);
+ *
+ * NOTE: Technically you can use one buffer for holding the label_context and
+ *	 the outbuf in the example above. Howerver, multiple rounds of the
+ *	 KDF are to be expected with the input must always be the same.
+ *	 The first round would replace the input in case of one buffer, and the
+ *	 KDF would calculate a cryptographically strong result which, however,
+ *	 is not portable to other KDF implementations! Thus, always use
+ *	 different buffers for the label_context and the outbuf. A safe
+ *	 in-place operation can only be done when only one round of the KDF
+ *	 is executed (i.e. the size of the requested buffer is equal to the
+ *	 digestsize of the used MAC).
+ */
+
+#include <linux/module.h>
+#include <crypto/rng.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+
+struct crypto_kdf_ctx {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+/* convert 32 bit integer into its string representation */
+static inline void crypto_kw_cpu_to_be32(u32 val, u8 *buf)
+{
+	__be32 *a = (__be32 *)buf;
+
+	*a = cpu_to_be32(val);
+}
+
+/*
+ * Implementation of the KDF in double pipeline iteration mode according with
+ * counter to SP800-108 section 5.3.
+ *
+ * The caller must provide Label || 0x00 || Context in src. This src pointer
+ * may also be NULL if the caller wishes not to provide anything.
+ */
+static int crypto_kdf_dpi_random(struct crypto_rng *rng,
+				 const u8 *src, unsigned int slen,
+				 u8 *dst, unsigned int dlen)
+{
+	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
+	struct shash_desc *desc = &ctx->shash;
+	unsigned int h = crypto_shash_digestsize(desc->tfm);
+	unsigned int alignmask = crypto_shash_alignmask(desc->tfm);
+	int err = 0;
+	u8 *dst_orig = dst;
+	u8 Aiblock[h + alignmask];
+	u8 *Ai = PTR_ALIGN((u8 *)Aiblock, alignmask + 1);
+	u32 i = 1;
+	u8 iteration[sizeof(u32)];
+
+	/* enforce the note from above */
+	if (dlen != h && src == dst)
+		return -EINVAL;
+
+	memset(Ai, 0, h);
+
+	while (dlen) {
+		/* Calculate A(i) */
+		if (dst == dst_orig && src && slen)
+			/* 5.3 step 4 and 5.a */
+			err = crypto_shash_digest(desc, src, slen, Ai);
+		else
+			/* 5.3 step 5.a */
+			err = crypto_shash_digest(desc, Ai, h, Ai);
+		if (err)
+			goto err;
+
+		/* Calculate K(i) -- step 5.b */
+		err = crypto_shash_init(desc);
+		if (err)
+			goto err;
+
+		err = crypto_shash_update(desc, Ai, h);
+		if (err)
+			goto err;
+
+		crypto_kw_cpu_to_be32(i, iteration);
+		err = crypto_shash_update(desc, iteration, sizeof(u32));
+		if (err)
+			goto err;
+		if (src && slen) {
+			err = crypto_shash_update(desc, src, slen);
+			if (err)
+				goto err;
+		}
+
+		if (dlen < h) {
+			u8 tmpbuffer[h];
+
+			err = crypto_shash_final(desc, tmpbuffer);
+			if (err)
+				goto err;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			goto ret;
+		} else {
+			err = crypto_shash_final(desc, dst);
+			if (err)
+				goto err;
+			dlen -= h;
+			dst += h;
+			i++;
+		}
+	}
+
+err:
+	memzero_explicit(dst_orig, dlen);
+ret:
+	memzero_explicit(Ai, h);
+	return err;
+}
+
+/*
+ * Implementation of the KDF in feedback mode with a non-NULL IV and with
+ * counter according to SP800-108 section 5.2. The IV is supplied with src
+ * and must be equal to the digestsize of the used cipher.
+ *
+ * In addition, the caller must provide Label || 0x00 || Context in src. This
+ * src pointer must not be NULL as the IV is required. The ultimate format of
+ * the src pointer is IV || Label || 0x00 || Context where the length of the
+ * IV is equal to the output size of the PRF.
+ */
+static int crypto_kdf_fb_random(struct crypto_rng *rng,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int dlen)
+{
+	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
+	struct shash_desc *desc = &ctx->shash;
+	unsigned int h = crypto_shash_digestsize(desc->tfm);
+	int err = 0;
+	u8 *dst_orig = dst;
+	const u8 *label;
+	unsigned int labellen = 0;
+	u32 i = 1;
+	u8 iteration[sizeof(u32)];
+
+	/* enforce the note from above */
+	if (dlen != h && src == dst)
+		return -EINVAL;
+
+	/* require the presence of an IV */
+	if (!src || slen < h)
+		return -EINVAL;
+
+	/* calculate the offset of the label / context data */
+	label = src + h;
+	labellen = slen - h;
+
+	while (dlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto err;
+
+		/*
+		 * Feedback mode applies to all rounds except first which uses
+		 * the IV.
+		 */
+		if (dst_orig == dst)
+			err = crypto_shash_update(desc, src, h);
+		else
+			err = crypto_shash_update(desc, dst - h, h);
+		if (err)
+			goto err;
+
+		crypto_kw_cpu_to_be32(i, iteration);
+		err = crypto_shash_update(desc, iteration, sizeof(u32));
+		if (err)
+			goto err;
+		if (labellen) {
+			err = crypto_shash_update(desc, label, labellen);
+			if (err)
+				goto err;
+		}
+
+		if (dlen < h) {
+			u8 tmpbuffer[h];
+
+			err = crypto_shash_final(desc, tmpbuffer);
+			if (err)
+				goto err;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			return 0;
+		} else {
+			err = crypto_shash_final(desc, dst);
+			if (err)
+				goto err;
+			dlen -= h;
+			dst += h;
+			i++;
+		}
+	}
+
+	return 0;
+
+err:
+	memzero_explicit(dst_orig, dlen);
+	return err;
+}
+
+/*
+ * Implementation of the KDF in counter mode according to SP800-108 section 5.1.
+ *
+ * The caller must provide Label || 0x00 || Context in src. This src pointer
+ * may also be NULL if the caller wishes not to provide anything.
+ */
+static int crypto_kdf_ctr_random(struct crypto_rng *rng,
+				 const u8 *src, unsigned int slen,
+				 u8 *dst, unsigned int dlen)
+{
+	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
+	struct shash_desc *desc = &ctx->shash;
+	unsigned int h = crypto_shash_digestsize(desc->tfm);
+	int err = 0;
+	u8 *dst_orig = dst;
+	u32 i = 1;
+	u8 iteration[sizeof(u32)];
+
+	/* enforce the note from above */
+	if (dlen != h && src == dst)
+		return -EINVAL;
+
+	while (dlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto err;
+
+		crypto_kw_cpu_to_be32(i, iteration);
+		err = crypto_shash_update(desc, iteration, sizeof(u32));
+		if (err)
+			goto err;
+
+		if (src && slen) {
+			err = crypto_shash_update(desc, src, slen);
+			if (err)
+				goto err;
+		}
+
+		if (dlen < h) {
+			u8 tmpbuffer[h];
+
+			err = crypto_shash_final(desc, tmpbuffer);
+			if (err)
+				goto err;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			return 0;
+		} else {
+			err = crypto_shash_final(desc, dst);
+			if (err)
+				goto err;
+
+			dlen -= h;
+			dst += h;
+			i++;
+		}
+	}
+
+	return 0;
+
+err:
+	memzero_explicit(dst_orig, dlen);
+	return err;
+}
+
+/*
+ * The seeding of the KDF allows to set a key which must be at least
+ * digestsize long.
+ */
+static int crypto_kdf_seed(struct crypto_rng *rng,
+			   const u8 *seed, unsigned int slen)
+{
+	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
+	unsigned int ds = crypto_shash_digestsize(ctx->shash.tfm);
+
+	/* Check according to SP800-108 section 7.2 */
+	if (ds > slen)
+		return -EINVAL;
+
+	/*
+	 * We require that we operate on a MAC -- if we do not operate on a
+	 * MAC, this function returns an error.
+	 */
+	return crypto_shash_setkey(ctx->shash.tfm, seed, slen);
+}
+
+static int crypto_kdf_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct crypto_shash_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_shash *hash;
+
+	hash = crypto_spawn_shash(spawn);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
+
+	ctx->shash.tfm = hash;
+
+	return 0;
+}
+
+static void crypto_kdf_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(ctx->shash.tfm);
+}
+
+static int crypto_kdf_alloc_common(struct crypto_template *tmpl,
+				   struct rtattr **tb,
+				   const u8 *name,
+				   int (*generate)(struct crypto_rng *tfm,
+						   const u8 *src,
+						   unsigned int slen,
+						   u8 *dst, unsigned int dlen))
+{
+	struct rng_instance *inst;
+	struct crypto_alg *alg;
+	struct shash_alg *salg;
+	int err;
+	unsigned int ds, ss;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_RNG);
+	if (err)
+		return err;
+
+	salg = shash_attr_alg(tb[1], 0, 0);
+	if (IS_ERR(salg))
+		return PTR_ERR(salg);
+
+	ds = salg->digestsize;
+	ss = salg->statesize;
+	alg = &salg->base;
+
+	inst = rng_alloc_instance(name, alg);
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	err = crypto_init_shash_spawn(rng_instance_ctx(inst), salg,
+				      rng_crypto_instance(inst));
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.base.cra_priority	= alg->cra_priority;
+	inst->alg.base.cra_blocksize	= alg->cra_blocksize;
+	inst->alg.base.cra_alignmask	= alg->cra_alignmask;
+
+	inst->alg.generate		= generate;
+	inst->alg.seed			= crypto_kdf_seed;
+	inst->alg.seedsize		= ds;
+
+	inst->alg.base.cra_init		= crypto_kdf_init_tfm;
+	inst->alg.base.cra_exit		= crypto_kdf_exit_tfm;
+	inst->alg.base.cra_ctxsize	= ALIGN(sizeof(struct crypto_kdf_ctx) +
+					  ss * 2, crypto_tfm_ctx_alignment());
+
+	err = rng_register_instance(tmpl, inst);
+
+	if (err) {
+out_free_inst:
+		rng_free_instance(rng_crypto_instance(inst));
+	}
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return err;
+}
+
+static int crypto_kdf_ctr_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
+{
+	return crypto_kdf_alloc_common(tmpl, tb, "kdf_ctr",
+				       crypto_kdf_ctr_random);
+}
+
+static struct crypto_template crypto_kdf_ctr_tmpl = {
+	.name = "kdf_ctr",
+	.create = crypto_kdf_ctr_create,
+	.free = rng_free_instance,
+	.module = THIS_MODULE,
+};
+
+static int crypto_kdf_fb_create(struct crypto_template *tmpl,
+				struct rtattr **tb) {
+	return crypto_kdf_alloc_common(tmpl, tb, "kdf_fb",
+				       crypto_kdf_fb_random);
+}
+
+static struct crypto_template crypto_kdf_fb_tmpl = {
+	.name = "kdf_fb",
+	.create = crypto_kdf_fb_create,
+	.free = rng_free_instance,
+	.module = THIS_MODULE,
+};
+
+static int crypto_kdf_dpi_create(struct crypto_template *tmpl,
+				 struct rtattr **tb) {
+	return crypto_kdf_alloc_common(tmpl, tb, "kdf_dpi",
+				       crypto_kdf_dpi_random);
+}
+
+static struct crypto_template crypto_kdf_dpi_tmpl = {
+	.name = "kdf_dpi",
+	.create = crypto_kdf_dpi_create,
+	.free = rng_free_instance,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_kdf_init(void)
+{
+	int err = crypto_register_template(&crypto_kdf_ctr_tmpl);
+
+	if (err)
+		return err;
+
+	err = crypto_register_template(&crypto_kdf_fb_tmpl);
+	if (err) {
+		crypto_unregister_template(&crypto_kdf_ctr_tmpl);
+		return err;
+	}
+
+	err = crypto_register_template(&crypto_kdf_dpi_tmpl);
+	if (err) {
+		crypto_unregister_template(&crypto_kdf_ctr_tmpl);
+		crypto_unregister_template(&crypto_kdf_fb_tmpl);
+	}
+	return err;
+}
+
+static void __exit crypto_kdf_exit(void)
+{
+	crypto_unregister_template(&crypto_kdf_ctr_tmpl);
+	crypto_unregister_template(&crypto_kdf_fb_tmpl);
+	crypto_unregister_template(&crypto_kdf_dpi_tmpl);
+}
+
+module_init(crypto_kdf_init);
+module_exit(crypto_kdf_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Key Derivation Function according to SP800-108");
+MODULE_ALIAS_CRYPTO("kdf_ctr");
+MODULE_ALIAS_CRYPTO("kdf_fb");
+MODULE_ALIAS_CRYPTO("kdf_dpi");
-- 
2.5.5
