Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:18160 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392367AbfAPLLs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 06:11:48 -0500
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH v2 4/6] crypto: hkdf - HMAC-based Extract-and-Expand KDF
Date: Wed, 16 Jan 2019 12:08:49 +0100
Message-ID: <3767574.eZANq8FNrB@positron.chronox.de>
In-Reply-To: <2082192.jPI8ve1O8G@positron.chronox.de>
References: <20190103143227.9138-1-jlee@suse.com> <9733066.Vrs4h5eWcW@positron.chronox.de> <2082192.jPI8ve1O8G@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The HMAC-based Extract-and-Expand Key Derivation Function is conformant
to RFC5869.

The extraction phase can be invoked separately from the expansion phase.
This implies that the once a key is set and thus the extraction phase was
applied, the expansion phase can be invoked multiple times.

The HKDF implementation does not restrict the type of keyed message
digest it is instantiated with. RFC5869 specifies HMAC-SHA as the only
keyed message digest, though. From a cryptographic point of view, using
other keyed message digests would result in an equally strong KDF.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  |   6 ++
 crypto/Makefile |   1 +
 crypto/hkdf.c   | 272 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 279 insertions(+)
 create mode 100644 crypto/hkdf.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7c0336c9ba9c..c25b2033321a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -568,6 +568,12 @@ config CRYPTO_KDF_SP800108
 	  Support for KDF compliant to SP800-108. All three types of
 	  KDF specified in SP800-108 are implemented.
 
+config CRYPTO_HKDF
+	tristate "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)"
+	select CRYPTO_RNG
+	help
+	  Support for KDF conformant to RFC5869.
+
 config CRYPTO_XCBC
 	tristate "XCBC support"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index eead7ec9fd8e..80363b8cbf6c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -59,6 +59,7 @@ crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
 obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_KDF_SP800108) += kdf_sp800108.o
+obj-$(CONFIG_CRYPTO_HKDF) += hkdf.o
 obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
diff --git a/crypto/hkdf.c b/crypto/hkdf.c
new file mode 100644
index 000000000000..2f392c71c85b
--- /dev/null
+++ b/crypto/hkdf.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * HMAC-based Extract-and-Expand Key Derivation Function (conformant to RFC5869)
+ *
+ * Copyright (C) 2019, Stephan Mueller <smueller@chronox.de>
+ */
+
+/*
+ * The HKDF extract phase is applied with crypto_rng_reset().
+ * The HKDF expand phase is applied with crypto_rng_generate().
+ */
+
+#include <asm/unaligned.h>
+#include <linux/module.h>
+#include <crypto/rng.h>
+#include <crypto/internal/rng.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+
+struct crypto_hkdf_ctx {
+	struct crypto_shash *kmd;
+};
+
+#define CRYPTO_HKDF_MAX_DIGESTSIZE	64
+
+static inline void crypto_kdf_init_desc(struct shash_desc *desc,
+					struct crypto_shash *kmd)
+{
+	desc->tfm = kmd;
+	desc->flags = 0;
+}
+
+/*
+ * HKDF expand phase
+ */
+static int crypto_hkdf_generate(struct crypto_rng *rng,
+				const u8 *info, unsigned int infolen,
+				u8 *dst, unsigned int dlen)
+{
+	const struct crypto_hkdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
+	struct crypto_shash *kmd = ctx->kmd;
+	SHASH_DESC_ON_STACK(desc, kmd);
+	const unsigned int h = crypto_shash_digestsize(kmd);
+	int err = 0;
+	u8 *dst_orig = dst;
+	const u8 *prev = NULL;
+	u8 ctr = 0x01;
+
+	if (dlen > h * 255)
+		return -EINVAL;
+
+	crypto_kdf_init_desc(desc, kmd);
+
+	/* T(1) and following */
+	while (dlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto out;
+
+		if (prev) {
+			err = crypto_shash_update(desc, prev, h);
+			if (err)
+				goto out;
+		}
+
+		if (info) {
+			err = crypto_shash_update(desc, info, infolen);
+			if (err)
+				goto out;
+		}
+
+		if (dlen < h) {
+			u8 tmpbuffer[CRYPTO_HKDF_MAX_DIGESTSIZE];
+
+			err = crypto_shash_finup(desc, &ctr, 1, tmpbuffer);
+			if (err)
+				goto out;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			goto out;
+		}
+
+		err = crypto_shash_finup(desc, &ctr, 1, dst);
+		if (err)
+			goto out;
+
+		prev = dst;
+		dst += h;
+		dlen -= h;
+		ctr++;
+	}
+
+out:
+	if (err)
+		memzero_explicit(dst_orig, dlen);
+	shash_desc_zero(desc);
+	return err;
+}
+
+/*
+ * HKDF extract phase.
+ *
+ * The seed is defined to be a concatenation of the salt and the IKM.
+ * The data buffer is pre-pended by a word which provides an u32 value
+ * with the length of the salt. Thus, the buffer length - salt length is the
+ * IKM length.
+ */
+static int crypto_hkdf_seed(struct crypto_rng *rng,
+			    const u8 *seed, unsigned int slen)
+{
+	const struct crypto_hkdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
+	struct crypto_shash *kmd = ctx->kmd;
+	SHASH_DESC_ON_STACK(desc, kmd);
+	u32 saltlen;
+	unsigned int h = crypto_shash_digestsize(kmd);
+	int err;
+	const u8 null_salt[CRYPTO_HKDF_MAX_DIGESTSIZE] = { 0 };
+	u8 prk[CRYPTO_HKDF_MAX_DIGESTSIZE];
+
+	if (slen < sizeof(saltlen))
+		return -EINVAL;
+
+	saltlen = get_unaligned((u32 *)seed);
+
+	seed += sizeof(saltlen);
+	slen -= sizeof(saltlen);
+
+	if (slen < saltlen)
+		return -EINVAL;
+
+	crypto_kdf_init_desc(desc, kmd);
+
+	/* Set the salt as HMAC key */
+	if (saltlen)
+		err = crypto_shash_setkey(kmd, seed, saltlen);
+	else
+		err = crypto_shash_setkey(kmd, null_salt, h);
+	if (err)
+		return err;
+
+	/* Extract the PRK */
+	err = crypto_shash_digest(desc, seed + saltlen, slen - saltlen, prk);
+	if (err)
+		goto err;
+
+	/* Set the PRK for the expand phase */
+	err = crypto_shash_setkey(kmd, prk, h);
+
+err:
+	shash_desc_zero(desc);
+	memzero_explicit(prk, h);
+	return err;
+}
+
+static int crypto_hkdf_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct crypto_shash_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_hkdf_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_shash *kmd;
+
+	kmd = crypto_spawn_shash(spawn);
+	if (IS_ERR(kmd))
+		return PTR_ERR(kmd);
+
+	ctx->kmd = kmd;
+
+	return 0;
+}
+
+static void crypto_hkdf_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_hkdf_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(ctx->kmd);
+}
+
+static void crypto_kdf_free(struct rng_instance *inst)
+{
+	crypto_drop_spawn(rng_instance_ctx(inst));
+	kfree(inst);
+}
+
+static int crypto_hkdf_create(struct crypto_template *tmpl, struct rtattr **tb)
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
+	/* Require a keyed message digest */
+	if (!salg->setkey)
+		return -EOPNOTSUPP;
+
+	ds = salg->digestsize;
+	/* Hashes with no digest size are not allowed for KDFs. */
+	if (!ds || WARN_ON(ds > CRYPTO_HKDF_MAX_DIGESTSIZE))
+		return -EOPNOTSUPP;
+
+	ss = salg->statesize;
+	alg = &salg->base;
+
+	inst = rng_alloc_instance("hkdf", alg);
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	err = crypto_init_shash_spawn(rng_instance_ctx(inst), salg,
+				      rng_crypto_instance(inst));
+	if (err)
+		goto free_inst;
+
+	inst->alg.base.cra_priority	= alg->cra_priority;
+	inst->alg.base.cra_blocksize	= alg->cra_blocksize;
+	inst->alg.base.cra_alignmask	= alg->cra_alignmask;
+
+	inst->alg.generate		= crypto_hkdf_generate;
+	inst->alg.seed			= crypto_hkdf_seed;
+
+	inst->alg.base.cra_init		= crypto_hkdf_init_tfm;
+	inst->alg.base.cra_exit		= crypto_hkdf_exit_tfm;
+	inst->alg.base.cra_ctxsize	= sizeof(struct crypto_hkdf_ctx);
+
+	inst->free			= crypto_kdf_free;
+
+	err = rng_register_instance(tmpl, inst);
+
+	if (err) {
+		crypto_drop_spawn(rng_instance_ctx(inst));
+free_inst:
+		kfree(inst);
+	}
+
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return err;
+}
+
+static struct crypto_template crypto_hkdf_tmpl = {
+	.name = "hkdf",
+	.create = crypto_hkdf_create,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_hkdf_init(void)
+{
+	return crypto_register_template(&crypto_hkdf_tmpl);
+}
+
+static void __exit crypto_hkdf_exit(void)
+{
+	crypto_unregister_template(&crypto_hkdf_tmpl);
+}
+
+module_init(crypto_hkdf_init);
+module_exit(crypto_hkdf_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("HKDF HMAC-based Extract-and-Expand Key Derivation Function  (conformant to RFC5869)");
+MODULE_ALIAS_CRYPTO("hkdf");
-- 
2.20.1
