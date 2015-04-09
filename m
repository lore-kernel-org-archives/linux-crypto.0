From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 01/16] crypto: sha1: implement base layer for SHA-1
Date: Thu,  9 Apr 2015 12:55:33 +0200
Message-ID: <1428576948-23863-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34673 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbDIK4I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 06:56:08 -0400
Received: by wgso17 with SMTP id o17so4054195wgs.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2015 03:56:06 -0700 (PDT)
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To reduce the number of copies of boilerplate code throughout
the tree, this patch implements generic glue for the SHA-1
algorithm. This allows a specific arch or hardware implementation
to only implement the special handling that it needs.

The users need to supply an implementation of

  void (sha1_block_fn)(struct sha1_state *sst, u8 const *src, int blocks)

and pass it to the SHA-1 base functions. For easy casting between the
prototype above and existing block functions that take a 'u32 state[]'
as their first argument, the 'state' member of struct sha1_state is
moved to the base of the struct.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/sha.h       |   2 +-
 include/crypto/sha1_base.h | 106 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100644 include/crypto/sha1_base.h

diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 190f8a0e0242..a9aad8e63f43 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -65,8 +65,8 @@
 #define SHA512_H7	0x5be0cd19137e2179ULL
 
 struct sha1_state {
-	u64 count;
 	u32 state[SHA1_DIGEST_SIZE / 4];
+	u64 count;
 	u8 buffer[SHA1_BLOCK_SIZE];
 };
 
diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
new file mode 100644
index 000000000000..41ccc5f325a0
--- /dev/null
+++ b/include/crypto/sha1_base.h
@@ -0,0 +1,106 @@
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
+typedef void (sha1_block_fn)(struct sha1_state *sst, u8 const *src, int blocks);
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
+static inline int sha1_base_do_update(struct shash_desc *desc,
+				      const u8 *data,
+				      unsigned int len,
+				      sha1_block_fn *block_fn)
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
+
+			block_fn(sctx, sctx->buffer, 1);
+		}
+
+		blocks = len / SHA1_BLOCK_SIZE;
+		len %= SHA1_BLOCK_SIZE;
+
+		if (blocks) {
+			block_fn(sctx, data, blocks);
+			data += blocks * SHA1_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buffer + partial, data, len);
+
+	return 0;
+}
+
+static inline int sha1_base_do_finalize(struct shash_desc *desc,
+					sha1_block_fn *block_fn)
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
+		block_fn(sctx, sctx->buffer, 1);
+	}
+
+	memset(sctx->buffer + partial, 0x0, bit_offset - partial);
+	*bits = cpu_to_be64(sctx->count << 3);
+	block_fn(sctx, sctx->buffer, 1);
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
