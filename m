From: Max Vozeler <max@hinterhof.net>
Subject: [PATCH 3/4] crypto: md5 - Add export support
Date: Mon, 28 Dec 2009 19:59:14 +0100
Message-ID: <1262026755-23056-4-git-send-email-max@hinterhof.net>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Cc: linux-crypto@nl.linux.org, Max Vozeler <max@hinterhof.net>,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:44468 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZL1Tcz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 14:32:55 -0500
In-Reply-To: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds export support to md5.  The exported type is
defined by struct md5_state.

This is modeled after the equivalent change to sha1_generic,
except only export is added for now.

Signed-off-by: Max Vozeler <max@hinterhof.net>
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>
---
 crypto/md5.c         |   31 +++++++++++++++----------------
 include/crypto/md5.h |   17 +++++++++++++++++
 2 files changed, 32 insertions(+), 16 deletions(-)
 create mode 100644 include/crypto/md5.h

diff --git a/crypto/md5.c b/crypto/md5.c
index 83eb529..8ae5114 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -16,17 +16,13 @@
  *
  */
 #include <crypto/internal/hash.h>
+#include <crypto/md5.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
-#define MD5_DIGEST_SIZE		16
-#define MD5_HMAC_BLOCK_SIZE	64
-#define MD5_BLOCK_WORDS		16
-#define MD5_HASH_WORDS		4
-
 #define F1(x, y, z)	(z ^ (x & (y ^ z)))
 #define F2(x, y, z)	F1(z, x, y)
 #define F3(x, y, z)	(x ^ y ^ z)
@@ -35,12 +31,6 @@
 #define MD5STEP(f, w, x, y, z, in, s) \
 	(w += f(x, y, z) + in, w = (w<<s | w>>(32-s)) + x)
 
-struct md5_ctx {
-	u32 hash[MD5_HASH_WORDS];
-	u32 block[MD5_BLOCK_WORDS];
-	u64 byte_count;
-};
-
 static void md5_transform(u32 *hash, u32 const *in)
 {
 	u32 a, b, c, d;
@@ -141,7 +131,7 @@ static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
 	}
 }
 
-static inline void md5_transform_helper(struct md5_ctx *ctx)
+static inline void md5_transform_helper(struct md5_state *ctx)
 {
 	le32_to_cpu_array(ctx->block, sizeof(ctx->block) / sizeof(u32));
 	md5_transform(ctx->hash, ctx->block);
@@ -149,7 +139,7 @@ static inline void md5_transform_helper(struct md5_ctx *ctx)
 
 static int md5_init(struct shash_desc *desc)
 {
-	struct md5_ctx *mctx = shash_desc_ctx(desc);
+	struct md5_state *mctx = shash_desc_ctx(desc);
 
 	mctx->hash[0] = 0x67452301;
 	mctx->hash[1] = 0xefcdab89;
@@ -162,7 +152,7 @@ static int md5_init(struct shash_desc *desc)
 
 static int md5_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
-	struct md5_ctx *mctx = shash_desc_ctx(desc);
+	struct md5_state *mctx = shash_desc_ctx(desc);
 	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
 
 	mctx->byte_count += len;
@@ -194,7 +184,7 @@ static int md5_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 
 static int md5_final(struct shash_desc *desc, u8 *out)
 {
-	struct md5_ctx *mctx = shash_desc_ctx(desc);
+	struct md5_state *mctx = shash_desc_ctx(desc);
 	const unsigned int offset = mctx->byte_count & 0x3f;
 	char *p = (char *)mctx->block + offset;
 	int padding = 56 - (offset + 1);
@@ -220,12 +210,21 @@ static int md5_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
+static int md5_export(struct shash_desc *desc, void *out)
+{
+	struct md5_state *ctx = shash_desc_ctx(desc);
+
+	memcpy(out, ctx, sizeof(*ctx));
+	return 0;
+}
+
 static struct shash_alg alg = {
 	.digestsize	=	MD5_DIGEST_SIZE,
 	.init		=	md5_init,
 	.update		=	md5_update,
 	.final		=	md5_final,
-	.descsize	=	sizeof(struct md5_ctx),
+	.export		=	md5_export,
+	.descsize	=	sizeof(struct md5_state),
 	.base		=	{
 		.cra_name	=	"md5",
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
diff --git a/include/crypto/md5.h b/include/crypto/md5.h
new file mode 100644
index 0000000..65f299b
--- /dev/null
+++ b/include/crypto/md5.h
@@ -0,0 +1,17 @@
+#ifndef _CRYPTO_MD5_H
+#define _CRYPTO_MD5_H
+
+#include <linux/types.h>
+
+#define MD5_DIGEST_SIZE		16
+#define MD5_HMAC_BLOCK_SIZE	64
+#define MD5_BLOCK_WORDS		16
+#define MD5_HASH_WORDS		4
+
+struct md5_state {
+	u32 hash[MD5_HASH_WORDS];
+	u32 block[MD5_BLOCK_WORDS];
+	u64 byte_count;
+};
+
+#endif
-- 
1.6.5.4

