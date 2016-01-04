From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 2/7] crypto/compress: introduce sychronuous compression API
Date: Mon,  4 Jan 2016 13:46:53 +0900
Message-ID: <1451882819-2810-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This introduces new compression APIs. Major change is that APIs are
stateless. Instead of previous implementation, tfm objects doesn't
embedded any context so we can de/compress concurrently with one tfm
object. Instead, thsi de/compression context is coupled with the request.
This architecture change will make APIs more flexible.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig            |   5 ++
 crypto/Makefile           |   1 +
 crypto/scompress.c        | 114 ++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/compress.h |  76 +++++++++++++++++++++++++++++++
 include/linux/crypto.h    |   1 +
 5 files changed, 197 insertions(+)
 create mode 100644 crypto/scompress.c
 create mode 100644 include/crypto/compress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c80d34f..7159520 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -84,6 +84,10 @@ config CRYPTO_RNG_DEFAULT
 	tristate
 	select CRYPTO_DRBG_MENU
 
+config CRYPTO_SCOMPRESS
+	tristate
+	select CRYPTO_ALGAPI2
+
 config CRYPTO_AKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
@@ -1499,6 +1503,7 @@ config CRYPTO_LZO
 	select CRYPTO_ALGAPI
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select SCOMPRESS
 	help
 	  This is the LZO algorithm.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index ffe18c9..16ef796 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -28,6 +28,7 @@ crypto_hash-y += ahash.o
 crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
+obj-$(CONFIG_CRYPTO_SCOMPRESS) += scompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
diff --git a/crypto/scompress.c b/crypto/scompress.c
new file mode 100644
index 0000000..7c9955b
--- /dev/null
+++ b/crypto/scompress.c
@@ -0,0 +1,114 @@
+/*
+ * Cryptographic API.
+ *
+ * Synchronous compression operations.
+ *
+ * Copyright 2015 LG Electronics Inc.
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
+#include <linux/cryptouser.h>
+
+#include <crypto/compress.h>
+#include <net/netlink.h>
+
+#include "internal.h"
+
+
+static int crypto_scomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	return 0;
+}
+
+static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+#ifdef CONFIG_NET
+static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp rcomp;
+
+	strncpy(rcomp.type, "scomp", sizeof(rcomp.type));
+	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		    sizeof(struct crypto_report_comp), &rcomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
+static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : scomp\n");
+}
+
+static const struct crypto_type crypto_scomp_type = {
+	.extsize	= crypto_alg_extsize,
+	.init		= crypto_scomp_init,
+	.init_tfm	= crypto_scomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show		= crypto_scomp_show,
+#endif
+	.report		= crypto_scomp_report,
+	.maskclear	= ~CRYPTO_ALG_TYPE_MASK,
+	.maskset	= CRYPTO_ALG_TYPE_MASK,
+	.type		= CRYPTO_ALG_TYPE_SCOMPRESS,
+	.tfmsize	= offsetof(struct crypto_scomp, base),
+};
+
+struct crypto_scomp *crypto_alloc_scomp(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_scomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_scomp);
+
+int crypto_register_scomp(struct scomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_scomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_scomp);
+
+int crypto_unregister_scomp(struct scomp_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Synchronous compression operations");
+MODULE_AUTHOR("LG Electronics Inc.");
+
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
new file mode 100644
index 0000000..4d89a68
--- /dev/null
+++ b/include/crypto/compress.h
@@ -0,0 +1,76 @@
+#ifndef _CRYPTO_COMPRESS_H
+#define _CRYPTO_COMPRESS_H
+#include <linux/crypto.h>
+
+struct crypto_scomp {
+	struct crypto_tfm base;
+};
+
+struct scomp_alg {
+	void *(*alloc_ctx)(struct crypto_scomp *tfm);
+	void (*free_ctx)(struct crypto_scomp *tfm, void *ctx);
+	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx);
+	int (*decompress)(struct crypto_scomp *tfm, const u8 *src,
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx);
+
+	struct crypto_alg base;
+};
+
+extern struct crypto_scomp *crypto_alloc_scomp(const char *alg_name, u32 type,
+					       u32 mask);
+
+static inline struct crypto_tfm *crypto_scomp_tfm(struct crypto_scomp *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct crypto_scomp *crypto_scomp_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_scomp *)tfm;
+}
+
+static inline void crypto_free_scomp(struct crypto_scomp *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_scomp_tfm(tfm));
+}
+
+static inline struct scomp_alg *__crypto_scomp_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct scomp_alg, base);
+}
+
+static inline struct scomp_alg *crypto_scomp_alg(struct crypto_scomp *tfm)
+{
+	return __crypto_scomp_alg(crypto_scomp_tfm(tfm)->__crt_alg);
+}
+
+static inline void *crypto_scomp_alloc_ctx(struct crypto_scomp *tfm)
+{
+	return crypto_scomp_alg(tfm)->alloc_ctx(tfm);
+}
+
+static inline void crypto_scomp_free_ctx(struct crypto_scomp *tfm,
+						void *ctx)
+{
+	return crypto_scomp_alg(tfm)->free_ctx(tfm, ctx);
+}
+
+static inline int crypto_scomp_compress(struct crypto_scomp *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return crypto_scomp_alg(tfm)->compress(tfm, src, slen, dst, dlen, ctx);
+}
+
+static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return crypto_scomp_alg(tfm)->decompress(tfm, src, slen,
+						dst, dlen, ctx);
+}
+
+extern int crypto_register_scomp(struct scomp_alg *alg);
+extern int crypto_unregister_scomp(struct scomp_alg *alg);
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ab2a745..726df9b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -54,6 +54,7 @@
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
+#define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000e
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
-- 
1.9.1
