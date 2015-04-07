From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 12/16] crypto/arm64: move SHA-1 ARMv8 implementation to base layer
Date: Tue,  7 Apr 2015 10:52:00 +0200
Message-ID: <1428396724-19962-13-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38898 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbDGIwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:53 -0400
Received: by wiun10 with SMTP id n10so9764749wiu.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:52 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha1-ce-core.S |  11 ++--
 arch/arm64/crypto/sha1-ce-glue.c | 133 +++++++--------------------------------
 2 files changed, 31 insertions(+), 113 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 09d57d98609c..a2c3ad51286b 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -131,15 +131,18 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 
 	/*
 	 * Final block: add padding and total bit count.
-	 * Skip if we have no total byte count in x4. In that case, the input
-	 * size was not a round multiple of the block size, and the padding is
-	 * handled by the C code.
+	 * Skip if the input size was not a round multiple of the block size,
+	 * the padding is handled by the C code in that case.
 	 */
 	cbz		x4, 3f
+	ldr		x5, [x2, #-8]		// sha1_state::count
+	tst		x5, #0x3f		// round multiple of block size?
+	b.ne		3f
+	str		wzr, [x4]
 	movi		v9.2d, #0
 	mov		x8, #0x80000000
 	movi		v10.2d, #0
-	ror		x7, x4, #29		// ror(lsl(x4, 3), 32)
+	ror		x7, x5, #29		// ror(lsl(x4, 3), 32)
 	fmov		d8, x8
 	mov		x4, #0
 	mov		v11.d[0], xzr
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 6fe83f37a750..141d5f3d7389 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -12,6 +12,7 @@
 #include <asm/unaligned.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
+#include <crypto/sha1_base.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
@@ -21,132 +22,46 @@ MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 asmlinkage void sha1_ce_transform(int blocks, u8 const *src, u32 *state,
-				  u8 *head, long bytes);
+				  const u8 *head, void *p);
 
-static int sha1_init(struct shash_desc *desc)
+static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-	return 0;
-}
-
-static int sha1_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA1_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buffer + partial, data, p);
-			data += p;
-			len -= p;
-		}
-
-		blocks = len / SHA1_BLOCK_SIZE;
-		len %= SHA1_BLOCK_SIZE;
-
-		kernel_neon_begin_partial(16);
-		sha1_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buffer : NULL, 0);
-		kernel_neon_end();
-
-		data += blocks * SHA1_BLOCK_SIZE;
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buffer + partial, data, len);
-	return 0;
-}
-
-static int sha1_final(struct shash_desc *desc, u8 *out)
-{
-	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
-
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	__be64 bits = cpu_to_be64(sctx->count << 3);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	u32 padlen = SHA1_BLOCK_SIZE
-		     - ((sctx->count + sizeof(bits)) % SHA1_BLOCK_SIZE);
-
-	sha1_update(desc, padding, padlen);
-	sha1_update(desc, (const u8 *)&bits, sizeof(bits));
-
-	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
+	kernel_neon_begin_partial(16);
+	sha1_base_do_update(desc, data, len, sha1_ce_transform, NULL);
+	kernel_neon_end();
 
-	*sctx = (struct sha1_state){};
 	return 0;
 }
 
-static int sha1_finup(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out)
+static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
+			 unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int blocks;
-	int i;
-
-	if (sctx->count || !len || (len % SHA1_BLOCK_SIZE)) {
-		sha1_update(desc, data, len);
-		return sha1_final(desc, out);
-	}
-
-	/*
-	 * Use a fast path if the input is a multiple of 64 bytes. In
-	 * this case, there is no need to copy data around, and we can
-	 * perform the entire digest calculation in a single invocation
-	 * of sha1_ce_transform()
-	 */
-	blocks = len / SHA1_BLOCK_SIZE;
+	u32 finalize = 1;
 
 	kernel_neon_begin_partial(16);
-	sha1_ce_transform(blocks, data, sctx->state, NULL, len);
+	if (len)
+		sha1_base_do_update(desc, data, len, sha1_ce_transform,
+				    &finalize);
+	if (finalize)
+		sha1_base_do_finalize(desc, sha1_ce_transform, NULL);
 	kernel_neon_end();
 
-	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha1_state){};
-	return 0;
+	return sha1_base_finish(desc, out);
 }
 
-static int sha1_export(struct shash_desc *desc, void *out)
+static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	struct sha1_state *dst = out;
-
-	*dst = *sctx;
-	return 0;
-}
-
-static int sha1_import(struct shash_desc *desc, const void *in)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	struct sha1_state const *src = in;
-
-	*sctx = *src;
-	return 0;
+	return sha1_ce_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg alg = {
-	.init			= sha1_init,
-	.update			= sha1_update,
-	.final			= sha1_final,
-	.finup			= sha1_finup,
-	.export			= sha1_export,
-	.import			= sha1_import,
+	.init			= sha1_base_init,
+	.update			= sha1_ce_update,
+	.final			= sha1_ce_final,
+	.finup			= sha1_ce_finup,
+	.export			= sha1_base_export,
+	.import			= sha1_base_import,
 	.descsize		= sizeof(struct sha1_state),
 	.digestsize		= SHA1_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha1_state),
-- 
1.8.3.2
