From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 02/16] crypto: sha256: implement base layer for SHA-256
Date: Thu,  9 Apr 2015 12:55:34 +0200
Message-ID: <1428576948-23863-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36728 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbDIK4K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:10 -0400
Received: by wizk4 with SMTP id k4so87501117wiz.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:09 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-256
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

The users need to supply an implementation of

  void (sha256_block_fn)(struct sha256_state *sst, u8 const *src, int blocks)

and pass it to the SHA-256 base functions. For easy casting between the
prototype above and existing block functions that take a 'u32 state[]'
as their first argument, the 'state' member of struct sha256_state is
moved to the base of the struct.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/sha.h         |   2 +-
 include/crypto/sha256_base.h | 128 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+), 1 deletion(-)
 create mode 100644 include/crypto/sha256_base.h

diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index a9aad8e63f43..a75bc80cc776 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -71,8 +71,8 @@ struct sha1_state {
 };
 
 struct sha256_state {
-	u64 count;
 	u32 state[SHA256_DIGEST_SIZE / 4];
+	u64 count;
 	u8 buf[SHA256_BLOCK_SIZE];
 };
 
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
new file mode 100644
index 000000000000..d1f2195bb7de
--- /dev/null
+++ b/include/crypto/sha256_base.h
@@ -0,0 +1,128 @@
+/*
+ * sha256_base.h - core logic for SHA-256 implementations
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
+typedef void (sha256_block_fn)(struct sha256_state *sst, u8 const *src,
+			       int blocks);
+
+static inline int sha224_base_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA224_H0;
+	sctx->state[1] = SHA224_H1;
+	sctx->state[2] = SHA224_H2;
+	sctx->state[3] = SHA224_H3;
+	sctx->state[4] = SHA224_H4;
+	sctx->state[5] = SHA224_H5;
+	sctx->state[6] = SHA224_H6;
+	sctx->state[7] = SHA224_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static inline int sha256_base_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static inline int sha256_base_do_update(struct shash_desc *desc,
+					const u8 *data,
+					unsigned int len,
+					sha256_block_fn *block_fn)
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
+
+			block_fn(sctx, sctx->buf, 1);
+		}
+
+		blocks = len / SHA256_BLOCK_SIZE;
+		len %= SHA256_BLOCK_SIZE;
+
+		if (blocks) {
+			block_fn(sctx, data, blocks);
+			data += blocks * SHA256_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buf + partial, data, len);
+
+	return 0;
+}
+
+static inline int sha256_base_do_finalize(struct shash_desc *desc,
+					  sha256_block_fn *block_fn)
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
+		block_fn(sctx, sctx->buf, 1);
+	}
+
+	memset(sctx->buf + partial, 0x0, bit_offset - partial);
+	*bits = cpu_to_be64(sctx->count << 3);
+	block_fn(sctx, sctx->buf, 1);
+
+	return 0;
+}
+
+static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
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
-- 
1.8.3.2
