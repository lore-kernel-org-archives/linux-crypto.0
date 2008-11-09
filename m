From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/8] crypto/md4.c: use ARRAY_SIZE
Date: Sun, 9 Nov 2008 17:54:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811091753500.32509@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:37594 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbYKIQyU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Nov 2008 11:54:20 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 crypto/md4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/md4.c b/crypto/md4.c
index 3c19aa0..a143c4a 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -148,7 +148,7 @@ static void md4_transform(u32 *hash, u32 const *in)
 
 static inline void md4_transform_helper(struct md4_ctx *ctx)
 {
-	le32_to_cpu_array(ctx->block, sizeof(ctx->block) / sizeof(u32));
+	le32_to_cpu_array(ctx->block, ARRAY_SIZE(ctx->block));
 	md4_transform(ctx->hash, ctx->block);
 }
 
@@ -214,7 +214,7 @@ static void md4_final(struct crypto_tfm *tfm, u8 *out)
 	le32_to_cpu_array(mctx->block, (sizeof(mctx->block) -
 	                  sizeof(u64)) / sizeof(u32));
 	md4_transform(mctx->hash, mctx->block);
-	cpu_to_le32_array(mctx->hash, sizeof(mctx->hash) / sizeof(u32));
+	cpu_to_le32_array(mctx->hash, ARRAY_SIZE(mctx->hash));
 	memcpy(out, mctx->hash, sizeof(mctx->hash));
 	memset(mctx, 0, sizeof(*mctx));
 }
