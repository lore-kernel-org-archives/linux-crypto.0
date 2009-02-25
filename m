From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 2/6] crypto: compress - Add pcomp interface
Date: Wed, 25 Feb 2009 14:43:10 +0100
Message-ID: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63866 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753325AbZBYNnT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 08:43:19 -0500
In-Reply-To: <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current "comp" crypto interface supports one-shot (de)compression only,
i.e. the whole data buffer to be (de)compressed must be passed at once, and
the whole (de)compressed data buffer will be received at once.
In several use-cases (e.g. compressed file systems that store files in big
compressed blocks), this workflow is not suitable.
Furthermore, the "comp" type doesn't provide for the configuration of
(de)compression parameters, and always allocates workspace memory for both
compression and decompression, which may waste memory.

To solve this, add a "pcomp" partial (de)compression interface that provides
the following operations:
  - crypto_compress_{init,update,final}() for compression,
  - crypto_decompress_{init,update,final}() for decompression,
  - crypto_{,de}compress_setup(), to configure (de)compression parameters
    (incl. allocating workspace memory).

The (de)compression methods take a struct comp_request, which was mimicked
after the z_stream object in zlib, and contains buffer pointer and length
pairs for input and output.

The setup methods take an opaque parameter pointer and length pair. Parameters
are supposed to be encoded using netlink attributes, whose meanings depend on
the actual (name of the) (de)compression algorithm.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/Kconfig                     |    4 +
 crypto/Makefile                    |    2 +
 crypto/pcompress.c                 |   97 ++++++++++++++++++++++++++++
 include/crypto/compress.h          |  125 ++++++++++++++++++++++++++++++++++++
 include/crypto/internal/compress.h |   28 ++++++++
 include/linux/crypto.h             |    1 +
 6 files changed, 257 insertions(+), 0 deletions(-)
 create mode 100644 crypto/pcompress.c
 create mode 100644 include/crypto/compress.h
 create mode 100644 include/crypto/internal/compress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a83ce04..c00c985 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -75,6 +75,10 @@ config CRYPTO_RNG2
 	tristate
 	select CRYPTO_ALGAPI2
 
+config CRYPTO_PCOMP
+	tristate
+	select CRYPTO_ALGAPI2
+
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
diff --git a/crypto/Makefile b/crypto/Makefile
index 46b08bf..8de194f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -25,6 +25,8 @@ crypto_hash-objs += ahash.o
 crypto_hash-objs += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
+obj-$(CONFIG_CRYPTO_PCOMP) += pcompress.o
+
 cryptomgr-objs := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
diff --git a/crypto/pcompress.c b/crypto/pcompress.c
new file mode 100644
index 0000000..ca9a4af
--- /dev/null
+++ b/crypto/pcompress.c
@@ -0,0 +1,97 @@
+/*
+ * Cryptographic API.
+ *
+ * Partial (de)compression operations.
+ *
+ * Copyright 2008 Sony Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ * If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/crypto.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+
+#include <crypto/compress.h>
+
+#include "internal.h"
+
+
+static int crypto_pcomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	return 0;
+}
+
+static unsigned int crypto_pcomp_extsize(struct crypto_alg *alg,
+					 const struct crypto_type *frontend)
+{
+	return alg->cra_ctxsize;
+}
+
+static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm,
+				 const struct crypto_type *frontend)
+{
+	return 0;
+}
+
+static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_printf(m, "type         : pcomp\n");
+}
+
+static const struct crypto_type crypto_pcomp_type = {
+	.extsize	= crypto_pcomp_extsize,
+	.init		= crypto_pcomp_init,
+	.init_tfm	= crypto_pcomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show		= crypto_pcomp_show,
+#endif
+	.maskclear	= ~CRYPTO_ALG_TYPE_MASK,
+	.maskset	= CRYPTO_ALG_TYPE_MASK,
+	.type		= CRYPTO_ALG_TYPE_PCOMPRESS,
+	.tfmsize	= offsetof(struct crypto_pcomp, base),
+};
+
+struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_pcomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_pcomp);
+
+int crypto_register_pcomp(struct pcomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_pcomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_PCOMPRESS;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_pcomp);
+
+int crypto_unregister_pcomp(struct pcomp_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_pcomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Partial (de)compression type");
+MODULE_AUTHOR("Sony Corporation");
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
new file mode 100644
index 0000000..b7d2287
--- /dev/null
+++ b/include/crypto/compress.h
@@ -0,0 +1,125 @@
+/*
+ * Compress: Compression algorithms under the cryptographic API.
+ *
+ * Copyright 2008 Sony Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ * If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _CRYPTO_COMPRESS_H
+#define _CRYPTO_COMPRESS_H
+
+#include <linux/crypto.h>
+
+
+struct comp_request {
+	const void *next_in;		/* next input byte */
+	void *next_out;			/* next output byte */
+	unsigned int avail_in;		/* bytes available at next_in */
+	unsigned int avail_out;		/* bytes available at next_out */
+};
+
+struct crypto_pcomp {
+	struct crypto_tfm base;
+};
+
+struct pcomp_alg {
+	int (*compress_setup)(struct crypto_pcomp *tfm, void *params,
+			      unsigned int len);
+	int (*compress_init)(struct crypto_pcomp *tfm);
+	int (*compress_update)(struct crypto_pcomp *tfm,
+			       struct comp_request *req);
+	int (*compress_final)(struct crypto_pcomp *tfm,
+			      struct comp_request *req);
+	int (*decompress_setup)(struct crypto_pcomp *tfm, void *params,
+				unsigned int len);
+	int (*decompress_init)(struct crypto_pcomp *tfm);
+	int (*decompress_update)(struct crypto_pcomp *tfm,
+				 struct comp_request *req);
+	int (*decompress_final)(struct crypto_pcomp *tfm,
+				struct comp_request *req);
+
+	struct crypto_alg base;
+};
+
+extern struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name, u32 type,
+					       u32 mask);
+
+static inline struct crypto_tfm *crypto_pcomp_tfm(struct crypto_pcomp *tfm)
+{
+	return &tfm->base;
+}
+
+static inline void crypto_free_pcomp(struct crypto_pcomp *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_pcomp_tfm(tfm));
+}
+
+static inline struct pcomp_alg *__crypto_pcomp_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct pcomp_alg, base);
+}
+
+static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
+{
+	return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg);
+}
+
+static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
+					void *params, unsigned int len)
+{
+	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
+}
+
+static inline int crypto_compress_init(struct crypto_pcomp *tfm)
+{
+	return crypto_pcomp_alg(tfm)->compress_init(tfm);
+}
+
+static inline int crypto_compress_update(struct crypto_pcomp *tfm,
+					 struct comp_request *req)
+{
+	return crypto_pcomp_alg(tfm)->compress_update(tfm, req);
+}
+
+static inline int crypto_compress_final(struct crypto_pcomp *tfm,
+					struct comp_request *req)
+{
+	return crypto_pcomp_alg(tfm)->compress_final(tfm, req);
+}
+
+static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
+					  void *params, unsigned int len)
+{
+	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
+}
+
+static inline int crypto_decompress_init(struct crypto_pcomp *tfm)
+{
+	return crypto_pcomp_alg(tfm)->decompress_init(tfm);
+}
+
+static inline int crypto_decompress_update(struct crypto_pcomp *tfm,
+					   struct comp_request *req)
+{
+	return crypto_pcomp_alg(tfm)->decompress_update(tfm, req);
+}
+
+static inline int crypto_decompress_final(struct crypto_pcomp *tfm,
+					  struct comp_request *req)
+{
+	return crypto_pcomp_alg(tfm)->decompress_final(tfm, req);
+}
+
+#endif	/* _CRYPTO_COMPRESS_H */
diff --git a/include/crypto/internal/compress.h b/include/crypto/internal/compress.h
new file mode 100644
index 0000000..178a888
--- /dev/null
+++ b/include/crypto/internal/compress.h
@@ -0,0 +1,28 @@
+/*
+ * Compress: Compression algorithms under the cryptographic API.
+ *
+ * Copyright 2008 Sony Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ * If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _CRYPTO_INTERNAL_COMPRESS_H
+#define _CRYPTO_INTERNAL_COMPRESS_H
+
+#include <crypto/compress.h>
+
+extern int crypto_register_pcomp(struct pcomp_alg *alg);
+extern int crypto_unregister_pcomp(struct pcomp_alg *alg);
+
+#endif	/* _CRYPTO_INTERNAL_COMPRESS_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 29729b8..ec29fa2 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -40,6 +40,7 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
-- 
1.6.0.4

