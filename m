From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 08/10] mv_cesa: move digest state initialisation to a better place
Date: Thu,  5 May 2011 15:29:04 +0200
Message-ID: <1304602146-5918-8-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:41250 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EENju (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:50 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On one hand, the digest state registers need to be set only when
actually using the crypto engine. On the other hand, there is a check
for ctx->first_hash in mv_process_hash_current() already, so use that.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index c1925c2..a2d9e39 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -342,6 +342,12 @@ static void mv_process_hash_current(int first_block)
 			op.config |= CFG_LAST_FRAG;
 		else
 			op.config |= CFG_MID_FRAG;
+
+		writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
+		writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
+		writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
+		writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
+		writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
 	}
 
 	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config));
@@ -525,14 +531,6 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 		p->crypt_len = ctx->extra_bytes;
 	}
 
-	if (unlikely(!ctx->first_hash)) {
-		writel(ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
-		writel(ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
-		writel(ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
-		writel(ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
-		writel(ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
-	}
-
 	ctx->extra_bytes = hw_bytes % SHA1_BLOCK_SIZE;
 	if (ctx->extra_bytes != 0
 	    && (!ctx->last_chunk || ctx->count > MAX_HW_HASH_SIZE))
-- 
1.7.4.1
