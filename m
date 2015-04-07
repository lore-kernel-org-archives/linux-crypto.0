From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Tue,  7 Apr 2015 10:51:49 +0200
Message-ID: <1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35979 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbDGIwZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:25 -0400
Received: by wgsk9 with SMTP id k9so26069471wgs.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:24 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-1
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/sha1_base.h | 123 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 include/crypto/sha1_base.h

diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
new file mode 100644
index 000000000000..919db0920203
--- /dev/null
+++ b/include/crypto/sha1_base.h
@@ -0,0 +1,123 @@
+/*
+ * sha1_base.h - core logic for SHA-1 implementations
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
+typedef void (sha1_block_fn)(int blocks, u8 const *src, u32 *state,
+			     const u8 *head, void *p);
+
+static inline int sha1_base_init(struct shash_desc *desc)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA1_H0;
+	sctx->state[1] = SHA1_H1;
+	sctx->state[2] = SHA1_H2;
+	sctx->state[3] = SHA1_H3;
+	sctx->state[4] = SHA1_H4;
+ 	sctx->count = 0;
+
+	return 0;
+}
+
+static inline int sha1_base_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct sha1_state *dst = out;
+
+	*dst = *sctx;
+
+	return 0;
+}
+
+static inline int sha1_base_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct sha1_state const *src = in;
+
+	*sctx = *src;
+
+	return 0;
+}
+
+static inline int sha1_base_do_update(struct shash_desc *desc, const u8 *data,
+				      unsigned int len, sha1_block_fn *block_fn,
+				      void *p)
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
+
+static inline int sha1_base_do_finalize(struct shash_desc *desc,
+					sha1_block_fn *block_fn, void *p)
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
+
+static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	__be32 *digest = (__be32 *)out;
+	int i;
+
+	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
+		put_unaligned_be32(sctx->state[i], digest++);
+
+	*sctx = (struct sha1_state){};
+	return 0;
+}
-- 
1.8.3.2
