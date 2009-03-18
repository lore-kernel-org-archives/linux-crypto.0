From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v3 2/3] crypto: Add fpu template, a wrapper for blkcipher
	touching FPU
Date: Wed, 18 Mar 2009 11:21:57 +0800
Message-ID: <1237346517.24215.241.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3m6cujcn3BBx28vAaGC5"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37300 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbZCRDWA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2009 23:22:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-3m6cujcn3BBx28vAaGC5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Blkcipher touching FPU need to be enclosed by kernel_fpu_begin() and
kernel_fpu_end(). If they are invoked in cipher algorithm
implementation, they will be invoked for each block, so that
performance will be hurt, because they are "slow" operations. This
patch implements "fpu" template, which makes these operations to be
invoked for each request.

v2: Make FPU mode invisible to end user

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig  |    5 +
 crypto/Makefile |    1=20
 crypto/fpu.c    |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++
 3 files changed, 172 insertions(+)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -241,6 +241,11 @@ config CRYPTO_XTS
 	  key size 256, 384 or 512 bits. This implementation currently
 	  can't handle a sectorsize which is not a multiple of 16 bytes.
=20
+config CRYPTO_FPU
+	tristate
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
+
 comment "Hash modes"
=20
 config CRYPTO_HMAC
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_CRYPTO_PCBC) +=3D pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) +=3D cts.o
 obj-$(CONFIG_CRYPTO_LRW) +=3D lrw.o
 obj-$(CONFIG_CRYPTO_XTS) +=3D xts.o
+obj-$(CONFIG_CRYPTO_FPU) +=3D fpu.o
 obj-$(CONFIG_CRYPTO_CTR) +=3D ctr.o
 obj-$(CONFIG_CRYPTO_GCM) +=3D gcm.o
 obj-$(CONFIG_CRYPTO_CCM) +=3D ccm.o
--- /dev/null
+++ b/crypto/fpu.c
@@ -0,0 +1,166 @@
+/*
+ * FPU: Wrapper for blkcipher touching fpu
+ *
+ * Copyright (c) Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation; either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/i387.h>
+
+struct crypto_fpu_ctx {
+	struct crypto_blkcipher *child;
+};
+
+static int crypto_fpu_setkey(struct crypto_tfm *parent, const u8 *key,
+			     unsigned int keylen)
+{
+	struct crypto_fpu_ctx *ctx =3D crypto_tfm_ctx(parent);
+	struct crypto_blkcipher *child =3D ctx->child;
+	int err;
+
+	crypto_blkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_blkcipher_set_flags(child, crypto_tfm_get_flags(parent) &
+				   CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_blkcipher_setkey(child, key, keylen);
+	crypto_tfm_set_flags(parent, crypto_blkcipher_get_flags(child) &
+				     CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int crypto_fpu_encrypt(struct blkcipher_desc *desc_in,
+			      struct scatterlist *dst, struct scatterlist *src,
+			      unsigned int nbytes)
+{
+	int err;
+	struct crypto_fpu_ctx *ctx =3D crypto_blkcipher_ctx(desc_in->tfm);
+	struct crypto_blkcipher *child =3D ctx->child;
+	struct blkcipher_desc desc =3D {
+		.tfm =3D child,
+		.info =3D desc_in->info,
+		.flags =3D desc_in->flags,
+	};
+
+	kernel_fpu_begin();
+	err =3D crypto_blkcipher_crt(desc.tfm)->encrypt(&desc, dst, src, nbytes);
+	kernel_fpu_end();
+	return err;
+}
+
+static int crypto_fpu_decrypt(struct blkcipher_desc *desc_in,
+			      struct scatterlist *dst, struct scatterlist *src,
+			      unsigned int nbytes)
+{
+	int err;
+	struct crypto_fpu_ctx *ctx =3D crypto_blkcipher_ctx(desc_in->tfm);
+	struct crypto_blkcipher *child =3D ctx->child;
+	struct blkcipher_desc desc =3D {
+		.tfm =3D child,
+		.info =3D desc_in->info,
+		.flags =3D desc_in->flags,
+	};
+
+	kernel_fpu_begin();
+	err =3D crypto_blkcipher_crt(desc.tfm)->decrypt(&desc, dst, src, nbytes);
+	kernel_fpu_end();
+	return err;
+}
+
+static int crypto_fpu_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst =3D crypto_tfm_alg_instance(tfm);
+	struct crypto_spawn *spawn =3D crypto_instance_ctx(inst);
+	struct crypto_fpu_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	struct crypto_blkcipher *cipher;
+
+	cipher =3D crypto_spawn_blkcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child =3D cipher;
+	return 0;
+}
+
+static void crypto_fpu_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_fpu_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	crypto_free_blkcipher(ctx->child);
+}
+
+static struct crypto_instance *crypto_fpu_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	err =3D crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg =3D crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
+	inst =3D crypto_alloc_instance("fpu", alg);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags =3D alg->cra_flags;
+	inst->alg.cra_priority =3D alg->cra_priority;
+	inst->alg.cra_blocksize =3D alg->cra_blocksize;
+	inst->alg.cra_alignmask =3D alg->cra_alignmask;
+	inst->alg.cra_type =3D alg->cra_type;
+	inst->alg.cra_blkcipher.ivsize =3D alg->cra_blkcipher.ivsize;
+	inst->alg.cra_blkcipher.min_keysize =3D alg->cra_blkcipher.min_keysize;
+	inst->alg.cra_blkcipher.max_keysize =3D alg->cra_blkcipher.max_keysize;
+	inst->alg.cra_ctxsize =3D sizeof(struct crypto_fpu_ctx);
+	inst->alg.cra_init =3D crypto_fpu_init_tfm;
+	inst->alg.cra_exit =3D crypto_fpu_exit_tfm;
+	inst->alg.cra_blkcipher.setkey =3D crypto_fpu_setkey;
+	inst->alg.cra_blkcipher.encrypt =3D crypto_fpu_encrypt;
+	inst->alg.cra_blkcipher.decrypt =3D crypto_fpu_decrypt;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static void crypto_fpu_free(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+
+static struct crypto_template crypto_fpu_tmpl =3D {
+	.name =3D "fpu",
+	.alloc =3D crypto_fpu_alloc,
+	.free =3D crypto_fpu_free,
+	.module =3D THIS_MODULE,
+};
+
+static int __init crypto_fpu_module_init(void)
+{
+	return crypto_register_template(&crypto_fpu_tmpl);
+}
+
+static void __exit crypto_fpu_module_exit(void)
+{
+	crypto_unregister_template(&crypto_fpu_tmpl);
+}
+
+module_init(crypto_fpu_module_init);
+module_exit(crypto_fpu_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("FPU block cipher wrapper");


--=-3m6cujcn3BBx28vAaGC5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknAaNEACgkQKhFGF+eHlpjagwCcDnD8ib3YSjjttZb9addvsf2F
hEYAn0wj+64rS6WUpVFtKHOzOXB/7mna
=/esL
-----END PGP SIGNATURE-----

--=-3m6cujcn3BBx28vAaGC5--

