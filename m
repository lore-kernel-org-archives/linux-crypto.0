From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 02/14] crypto: sha256: implement base layer for SHA-256
Date: Mon, 30 Mar 2015 11:36:12 +0200
Message-ID: <1427708184-2353-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37171 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbC3Jgo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:36:44 -0400
Received: by wiaa2 with SMTP id a2so120318505wia.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:36:43 -0700 (PDT)
In-Reply-To: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-256
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig       |   4 ++
 crypto/Makefile      |   1 +
 crypto/sha256_base.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/sha.h |  17 +++++++
 4 files changed, 162 insertions(+)
 create mode 100644 crypto/sha256_base.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3400cf4e3cdb..1664bd68b97d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -602,6 +602,10 @@ config CRYPTO_SHA1_MB
 	  lanes remain unfilled, a flush operation will be initiated to
 	  process the crypto jobs, adding a slight latency.
 
+
+config CRYPTO_SHA256_BASE
+	tristate
+
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 6174bf2592fe..bb9bafeb3ac7 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_RMD256) += rmd256.o
 obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
+obj-$(CONFIG_CRYPTO_SHA256_BASE) += sha256_base.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512_BASE) += sha512_base.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
diff --git a/crypto/sha256_base.c b/crypto/sha256_base.c
new file mode 100644
index 000000000000..5fd728066912
--- /dev/null
+++ b/crypto/sha256_base.c
@@ -0,0 +1,140 @@
+/*
+ * sha256_base.c - core logic for SHA-256 implementations
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
+int crypto_sha224_base_init(struct shash_desc *desc)
+{
+	static const u32 sha224_init_state[] = {
+		SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
+		SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
+	};
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx->state, sha224_init_state, sizeof(sctx->state));
+	sctx->count = 0;
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha224_base_init);
+
+int crypto_sha256_base_init(struct shash_desc *desc)
+{
+	static const u32 sha256_init_state[] = {
+		SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+		SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
+	};
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx->state, sha256_init_state, sizeof(sctx->state));
+	sctx->count = 0;
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha256_base_init);
+
+int crypto_sha256_base_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state *dst = out;
+
+	*dst = *sctx;
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha256_base_export);
+
+int crypto_sha256_base_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state const *src = in;
+
+	*sctx = *src;
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha256_base_import);
+
+int crypto_sha256_base_do_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int len, sha256_block_fn *block_fn,
+				 void *p)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
+
+	sctx->count += len;
+
+	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
+		int blocks;
+
+		if (partial) {
+			int p = SHA256_BLOCK_SIZE - partial;
+
+			memcpy(sctx->buf + partial, data, p);
+			data += p;
+			len -= p;
+		}
+
+		blocks = len / SHA256_BLOCK_SIZE;
+		len %= SHA256_BLOCK_SIZE;
+
+		block_fn(blocks, data, sctx->state,
+			 partial ? sctx->buf : NULL, p);
+		data += blocks * SHA256_BLOCK_SIZE;
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buf + partial, data, len);
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha256_base_do_update);
+
+int crypto_sha256_base_do_finalize(struct shash_desc *desc,
+				   sha256_block_fn *block_fn, void *p)
+{
+	const int bit_offset = SHA256_BLOCK_SIZE - sizeof(__be64);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	__be64 *bits = (__be64 *)(sctx->buf + bit_offset);
+	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
+
+	sctx->buf[partial++] = 0x80;
+	if (partial > bit_offset) {
+		memset(sctx->buf + partial, 0x0, SHA256_BLOCK_SIZE - partial);
+		partial = 0;
+
+		block_fn(1, sctx->buf, sctx->state, NULL, p);
+	}
+
+	memset(sctx->buf + partial, 0x0, bit_offset - partial);
+	*bits = cpu_to_be64(sctx->count << 3);
+	block_fn(1, sctx->buf, sctx->state, NULL, p);
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha256_base_do_finalize);
+
+int crypto_sha256_base_finish(struct shash_desc *desc, u8 *out)
+{
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	__be32 *digest = (__be32 *)out;
+	int i;
+
+	for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be32))
+		put_unaligned_be32(sctx->state[i], digest++);
+
+	*sctx = (struct sha256_state){};
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha256_base_finish);
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 85997a17d4e2..0ed6630d7c40 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -82,6 +82,8 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
+typedef void (sha256_block_fn)(int blocks, u8 const *src, u32 *state,
+			       const u8 *head, void *p);
 typedef void (sha512_block_fn)(int blocks, u8 const *src, u64 *state,
 			       const u8 *head, void *p);
 
@@ -112,4 +114,19 @@ extern int crypto_sha512_base_do_finalize(struct shash_desc *desc,
 
 extern int crypto_sha512_base_finish(struct shash_desc *desc, u8 *out);
 
+extern int crypto_sha224_base_init(struct shash_desc *desc);
+extern int crypto_sha256_base_init(struct shash_desc *desc);
+
+extern int crypto_sha256_base_export(struct shash_desc *desc, void *out);
+extern int crypto_sha256_base_import(struct shash_desc *desc, const void *in);
+
+extern int crypto_sha256_base_do_update(struct shash_desc *desc, const u8 *data,
+			         unsigned int len, sha256_block_fn *block_fn,
+			         void *p);
+
+extern int crypto_sha256_base_do_finalize(struct shash_desc *desc,
+				   sha256_block_fn *block_fn, void *p);
+
+extern int crypto_sha256_base_finish(struct shash_desc *desc, u8 *out);
+
 #endif
-- 
1.8.3.2
