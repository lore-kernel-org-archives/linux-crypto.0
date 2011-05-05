From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 05/10] mv_cesa: no need to save digest state after the last chunk
Date: Thu,  5 May 2011 15:29:01 +0200
Message-ID: <1304602146-5918-5-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:52350 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1EENjo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:44 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index c018cd0..fb3f1e3 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -407,12 +407,6 @@ static void mv_hash_algo_completion(void)
 		copy_src_to_buf(&cpg->p, ctx->buffer, ctx->extra_bytes);
 	sg_miter_stop(&cpg->p.src_sg_it);
 
-	ctx->state[0] = readl(cpg->reg + DIGEST_INITIAL_VAL_A);
-	ctx->state[1] = readl(cpg->reg + DIGEST_INITIAL_VAL_B);
-	ctx->state[2] = readl(cpg->reg + DIGEST_INITIAL_VAL_C);
-	ctx->state[3] = readl(cpg->reg + DIGEST_INITIAL_VAL_D);
-	ctx->state[4] = readl(cpg->reg + DIGEST_INITIAL_VAL_E);
-
 	if (likely(ctx->last_chunk)) {
 		if (likely(ctx->count <= MAX_HW_HASH_SIZE)) {
 			memcpy(req->result, cpg->sram + SRAM_DIGEST_BUF,
@@ -420,6 +414,12 @@ static void mv_hash_algo_completion(void)
 						       (req)));
 		} else
 			mv_hash_final_fallback(req);
+	} else {
+		ctx->state[0] = readl(cpg->reg + DIGEST_INITIAL_VAL_A);
+		ctx->state[1] = readl(cpg->reg + DIGEST_INITIAL_VAL_B);
+		ctx->state[2] = readl(cpg->reg + DIGEST_INITIAL_VAL_C);
+		ctx->state[3] = readl(cpg->reg + DIGEST_INITIAL_VAL_D);
+		ctx->state[4] = readl(cpg->reg + DIGEST_INITIAL_VAL_E);
 	}
 }
 
-- 
1.7.4.1
