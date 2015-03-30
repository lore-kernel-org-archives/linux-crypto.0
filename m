From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 03/14] crypto: sha1: implement base layer for SHA-1
Date: Mon, 30 Mar 2015 11:36:14 +0200
Message-ID: <1427708184-2353-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34314 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbC3Jgu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:36:50 -0400
Received: by wgbdm7 with SMTP id dm7so60717567wgb.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:36:48 -0700 (PDT)
In-Reply-To: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-1
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig       |   3 ++
 crypto/Makefile      |   1 +
 crypto/sha1_base.c   | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/sha.h |  17 +++++++
 4 files changed, 146 insertions(+)
 create mode 100644 crypto/sha1_base.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1664bd68b97d..155cc15c2719 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -516,6 +516,9 @@ config CRYPTO_RMD320
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
 	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
+config CRYPTO_SHA1_BASE
+	tristate
+
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index bb9bafeb3ac7..42446cab15f3 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CRYPTO_RMD128) += rmd128.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_RMD256) += rmd256.o
 obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
+obj-$(CONFIG_CRYPTO_SHA1_BASE) += sha1_base.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256_BASE) += sha256_base.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
diff --git a/crypto/sha1_base.c b/crypto/sha1_base.c
new file mode 100644
index 000000000000..30fb0f9b47cf
--- /dev/null
+++ b/crypto/sha1_base.c
@@ -0,0 +1,125 @@
+/*
+ * sha1_base.c - core logic for SHA-1 implementations
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
+int crypto_sha1_base_init(struct shash_desc *desc)
+{
+	static const u32 sha1_init_state[] = {
+		SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4,
+	};
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx->state, sha1_init_state, sizeof(sctx->state));
+	sctx->count = 0;
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha1_base_init);
+
+int crypto_sha1_base_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct sha1_state *dst = out;
+
+	*dst = *sctx;
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha1_base_export);
+
+int crypto_sha1_base_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct sha1_state const *src = in;
+
+	*sctx = *src;
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha1_base_import);
+
+int crypto_sha1_base_do_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int len, sha1_block_fn *block_fn,
+				 void *p)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
+
+	sctx->count += len;
+
+	if (unlikely((partial + len) >= SHA1_BLOCK_SIZE)) {
+		int blocks;
+
+		if (partial) {
+			int p = SHA1_BLOCK_SIZE - partial;
+
+			memcpy(sctx->buffer + partial, data, p);
+			data += p;
+			len -= p;
+		}
+
+		blocks = len / SHA1_BLOCK_SIZE;
+		len %= SHA1_BLOCK_SIZE;
+
+		block_fn(blocks, data, sctx->state,
+			 partial ? sctx->buffer : NULL, p);
+		data += blocks * SHA1_BLOCK_SIZE;
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buffer + partial, data, len);
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha1_base_do_update);
+
+int crypto_sha1_base_do_finalize(struct shash_desc *desc,
+				 sha1_block_fn *block_fn, void *p)
+{
+	const int bit_offset = SHA1_BLOCK_SIZE - sizeof(__be64);
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
+	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
+
+	sctx->buffer[partial++] = 0x80;
+	if (partial > bit_offset) {
+		memset(sctx->buffer + partial, 0x0, SHA1_BLOCK_SIZE - partial);
+		partial = 0;
+
+		block_fn(1, sctx->buffer, sctx->state, NULL, p);
+	}
+
+	memset(sctx->buffer + partial, 0x0, bit_offset - partial);
+	*bits = cpu_to_be64(sctx->count << 3);
+	block_fn(1, sctx->buffer, sctx->state, NULL, p);
+
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha1_base_do_finalize);
+
+int crypto_sha1_base_finish(struct shash_desc *desc, u8 *out)
+{
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	__be32 *digest = (__be32 *)out;
+	int i;
+
+	for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be32))
+		put_unaligned_be32(sctx->state[i], digest++);
+
+	*sctx = (struct sha1_state){};
+	return 0;
+}
+EXPORT_SYMBOL(crypto_sha1_base_finish);
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 0ed6630d7c40..63cba0bbf3bc 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -82,6 +82,8 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
+typedef void (sha1_block_fn)(int blocks, u8 const *src, u32 *state,
+			     const u8 *head, void *p);
 typedef void (sha256_block_fn)(int blocks, u8 const *src, u32 *state,
 			       const u8 *head, void *p);
 typedef void (sha512_block_fn)(int blocks, u8 const *src, u64 *state,
@@ -129,4 +131,19 @@ extern int crypto_sha256_base_do_finalize(struct shash_desc *desc,
 
 extern int crypto_sha256_base_finish(struct shash_desc *desc, u8 *out);
 
+extern int crypto_sha1_base_init(struct shash_desc *desc);
+extern int crypto_sha1_base_init(struct shash_desc *desc);
+
+extern int crypto_sha1_base_export(struct shash_desc *desc, void *out);
+extern int crypto_sha1_base_import(struct shash_desc *desc, const void *in);
+
+extern int crypto_sha1_base_do_update(struct shash_desc *desc, const u8 *data,
+			         unsigned int len, sha1_block_fn *block_fn,
+			         void *p);
+
+extern int crypto_sha1_base_do_finalize(struct shash_desc *desc,
+				   sha1_block_fn *block_fn, void *p);
+
+extern int crypto_sha1_base_finish(struct shash_desc *desc, u8 *out);
+
 #endif
-- 
1.8.3.2
