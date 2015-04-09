From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 03/16] crypto: sha512: implement base layer for SHA-512
Date: Thu,  9 Apr 2015 12:55:35 +0200
Message-ID: <1428576948-23863-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35539 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258AbbDIK4M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:12 -0400
Received: by widdi4 with SMTP id di4so87412693wid.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:11 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-512
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

The users need to supply an implementation of

  void (sha512_block_fn)(struct sha512_state *sst, u8 const *src, int blocks)

and pass it to the SHA-512 base functions. For easy casting between the
prototype above and existing block functions that take a 'u64 state[]'
as their first argument, the 'state' member of struct sha512_state is
moved to the base of the struct.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/sha.h         |   2 +-
 include/crypto/sha512_base.h | 131 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 include/crypto/sha512_base.h

diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index a75bc80cc776..05e82cbc4d8f 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -77,8 +77,8 @@ struct sha256_state {
 };
 
 struct sha512_state {
-	u64 count[2];
 	u64 state[SHA512_DIGEST_SIZE / 8];
+	u64 count[2];
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
new file mode 100644
index 000000000000..6c5341e005ea
--- /dev/null
+++ b/include/crypto/sha512_base.h
@@ -0,0 +1,131 @@
+/*
+ * sha512_base.h - core logic for SHA-512 implementations
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
+typedef void (sha512_block_fn)(struct sha512_state *sst, u8 const *src,
+			       int blocks);
+
+static inline int sha384_base_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA384_H0;
+	sctx->state[1] = SHA384_H1;
+	sctx->state[2] = SHA384_H2;
+	sctx->state[3] = SHA384_H3;
+	sctx->state[4] = SHA384_H4;
+	sctx->state[5] = SHA384_H5;
+	sctx->state[6] = SHA384_H6;
+	sctx->state[7] = SHA384_H7;
+	sctx->count[0] = sctx->count[1] = 0;
+
+	return 0;
+}
+
+static inline int sha512_base_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA512_H0;
+	sctx->state[1] = SHA512_H1;
+	sctx->state[2] = SHA512_H2;
+	sctx->state[3] = SHA512_H3;
+	sctx->state[4] = SHA512_H4;
+	sctx->state[5] = SHA512_H5;
+	sctx->state[6] = SHA512_H6;
+	sctx->state[7] = SHA512_H7;
+	sctx->count[0] = sctx->count[1] = 0;
+
+	return 0;
+}
+
+static inline int sha512_base_do_update(struct shash_desc *desc,
+					const u8 *data,
+					unsigned int len,
+					sha512_block_fn *block_fn)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
+
+	sctx->count[0] += len;
+	if (sctx->count[0] < len)
+		sctx->count[1]++;
+
+	if (unlikely((partial + len) >= SHA512_BLOCK_SIZE)) {
+		int blocks;
+
+		if (partial) {
+			int p = SHA512_BLOCK_SIZE - partial;
+
+			memcpy(sctx->buf + partial, data, p);
+			data += p;
+			len -= p;
+
+			block_fn(sctx, sctx->buf, 1);
+		}
+
+		blocks = len / SHA512_BLOCK_SIZE;
+		len %= SHA512_BLOCK_SIZE;
+
+		if (blocks) {
+			block_fn(sctx, data, blocks);
+			data += blocks * SHA512_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buf + partial, data, len);
+
+	return 0;
+}
+
+static inline int sha512_base_do_finalize(struct shash_desc *desc,
+					  sha512_block_fn *block_fn)
+{
+	const int bit_offset = SHA512_BLOCK_SIZE - sizeof(__be64[2]);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	__be64 *bits = (__be64 *)(sctx->buf + bit_offset);
+	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
+
+	sctx->buf[partial++] = 0x80;
+	if (partial > bit_offset) {
+		memset(sctx->buf + partial, 0x0, SHA512_BLOCK_SIZE - partial);
+		partial = 0;
+
+		block_fn(sctx, sctx->buf, 1);
+	}
+
+	memset(sctx->buf + partial, 0x0, bit_offset - partial);
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
+	bits[1] = cpu_to_be64(sctx->count[0] << 3);
+	block_fn(sctx, sctx->buf, 1);
+
+	return 0;
+}
+
+static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
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
-- 
1.8.3.2
