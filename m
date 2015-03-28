From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/6] crypto: sha512: implement base layer for SHA-512
Date: Sat, 28 Mar 2015 23:10:23 +0100
Message-ID: <1427580628-7128-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35097 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbC1WKn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Mar 2015 18:10:43 -0400
Received: by wgdm6 with SMTP id m6so133595659wgd.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2015 15:10:42 -0700 (PDT)
In-Reply-To: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-512
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig       |   3 ++
 crypto/Makefile      |   1 +
 crypto/sha512_base.c | 143 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/sha.h |  20 +++++++
 4 files changed, 167 insertions(+)
 create mode 100644 crypto/sha512_base.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 88639937a934..3400cf4e3cdb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -641,6 +641,9 @@ config CRYPTO_SHA256_SPARC64
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
 	  using sparc64 crypto instructions, when available.
 
+config CRYPTO_SHA512_BASE
+	tristate
+
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 97b7d3ac87e7..6174bf2592fe 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_CRYPTO_RMD256) += rmd256.o
 obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
+obj-$(CONFIG_CRYPTO_SHA512_BASE) += sha512_base.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
diff --git a/crypto/sha512_base.c b/crypto/sha512_base.c
new file mode 100644
index 000000000000..488e24cc6f0a
--- /dev/null
+++ b/crypto/sha512_base.c
@@ -0,0 +1,143 @@
+/*
+ * sha512_base.c - core logic for SHA-512 implementations
+ *
+ * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+#include <asm/unaligned.h>
+
+int sha384_base_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha512_state){
+		.state = {
+			SHA384_H0, SHA384_H1, SHA384_H2, SHA384_H3,
+			SHA384_H4, SHA384_H5, SHA384_H6, SHA384_H7,
+		}
+	};
+	return 0;
+}
+EXPORT_SYMBOL(sha384_base_init);
+
+int sha512_base_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha512_state){
+		.state = {
+			SHA512_H0, SHA512_H1, SHA512_H2, SHA512_H3,
+			SHA512_H4, SHA512_H5, SHA512_H6, SHA512_H7,
+		}
+	};
+	return 0;
+}
+EXPORT_SYMBOL(sha512_base_init);
+
+int sha512_base_export(struct shash_desc *desc, void *out)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state *dst = out;
+
+	*dst = *sctx;
+
+	return 0;
+}
+EXPORT_SYMBOL(sha512_base_export);
+
+int sha512_base_import(struct shash_desc *desc, const void *in)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	struct sha512_state const *src = in;
+
+	*sctx = *src;
+
+	return 0;
+}
+EXPORT_SYMBOL(sha512_base_import);
+
+int sha512_base_do_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len, sha512_block_fn *block_fn, void *p)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
+
+	sctx->count[0] += len;
+	if (sctx->count[0] < len)
+		sctx->count[1]++;
+
+	if ((partial + len) >= SHA512_BLOCK_SIZE) {
+		int blocks;
+
+		if (partial) {
+			int p = SHA512_BLOCK_SIZE - partial;
+
+			memcpy(sctx->buf + partial, data, p);
+			data += p;
+			len -= p;
+		}
+
+		blocks = len / SHA512_BLOCK_SIZE;
+		len %= SHA512_BLOCK_SIZE;
+
+		block_fn(blocks, data, sctx->state,
+			 partial ? sctx->buf : NULL, p);
+		data += blocks * SHA512_BLOCK_SIZE;
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buf + partial, data, len);
+
+	return 0;
+}
+EXPORT_SYMBOL(sha512_base_do_update);
+
+int sha512_base_do_finalize(struct shash_desc *desc, sha512_block_fn *block_fn,
+			    void *p)
+{
+	static const u8 padding[SHA512_BLOCK_SIZE] = { 0x80, };
+
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	unsigned int padlen;
+	__be64 bits[2];
+
+	padlen = SHA512_BLOCK_SIZE -
+		 (sctx->count[0] + sizeof(bits)) % SHA512_BLOCK_SIZE;
+
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 |
+			      sctx->count[0] >> 61);
+	bits[1] = cpu_to_be64(sctx->count[0] << 3);
+
+	sha512_base_do_update(desc, padding, padlen, block_fn, p);
+
+	memcpy(sctx->buf + SHA512_BLOCK_SIZE - sizeof(bits),
+	       bits, sizeof(bits));
+
+	block_fn(1, sctx->buf, sctx->state, NULL, p);
+	return 0;
+}
+EXPORT_SYMBOL(sha512_base_do_finalize);
+
+int sha512_base_finish(struct shash_desc *desc, u8 *out)
+{
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	__be64 *digest = (__be64 *)out;
+	int i;
+
+	for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be64))
+		put_unaligned_be64(sctx->state[i], digest++);
+
+	*sctx = (struct sha512_state){};
+	return 0;
+}
+EXPORT_SYMBOL(sha512_base_finish);
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 190f8a0e0242..d252a8fcc4de 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -82,6 +82,9 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
+typedef void (sha512_block_fn)(int blocks, u8 const *src, u64 *state,
+			       const u8 *head, void *p);
+
 struct shash_desc;
 
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
@@ -92,4 +95,21 @@ extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 
 extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
+
+
+extern int sha384_base_init(struct shash_desc *desc);
+extern int sha512_base_init(struct shash_desc *desc);
+
+extern int sha512_base_export(struct shash_desc *desc, void *out);
+extern int sha512_base_import(struct shash_desc *desc, const void *in);
+
+extern int sha512_base_do_update(struct shash_desc *desc, const u8 *data,
+			         unsigned int len, sha512_block_fn *block_fn,
+			         void *p);
+
+extern int sha512_base_do_finalize(struct shash_desc *desc,
+				   sha512_block_fn *block_fn, void *p);
+
+extern int sha512_base_finish(struct shash_desc *desc, u8 *out);
+
 #endif
-- 
1.8.3.2
