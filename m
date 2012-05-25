From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 4/4] mv_cesa: fix for hash finalisation with data
Date: Fri, 25 May 2012 15:54:49 +0200
Message-ID: <1337954089-12702-4-git-send-email-phil.sutter@viprinet.com>
References: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:45591 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2EYOCS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 10:02:18 -0400
In-Reply-To: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since mv_hash_final_fallback() uses ctx->state, read out the digest
state register before calling it.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index d4763fb..3cc9237 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -421,6 +421,15 @@ out:
 	return rc;
 }
 
+static void mv_save_digest_state(struct mv_req_hash_ctx *ctx)
+{
+	ctx->state[0] = readl(cpg->reg + DIGEST_INITIAL_VAL_A);
+	ctx->state[1] = readl(cpg->reg + DIGEST_INITIAL_VAL_B);
+	ctx->state[2] = readl(cpg->reg + DIGEST_INITIAL_VAL_C);
+	ctx->state[3] = readl(cpg->reg + DIGEST_INITIAL_VAL_D);
+	ctx->state[4] = readl(cpg->reg + DIGEST_INITIAL_VAL_E);
+}
+
 static void mv_hash_algo_completion(void)
 {
 	struct ahash_request *req = ahash_request_cast(cpg->cur_req);
@@ -435,14 +444,12 @@ static void mv_hash_algo_completion(void)
 			memcpy(req->result, cpg->sram + SRAM_DIGEST_BUF,
 			       crypto_ahash_digestsize(crypto_ahash_reqtfm
 						       (req)));
-		} else
+		} else {
+			mv_save_digest_state(ctx);
 			mv_hash_final_fallback(req);
+		}
 	} else {
-		ctx->state[0] = readl(cpg->reg + DIGEST_INITIAL_VAL_A);
-		ctx->state[1] = readl(cpg->reg + DIGEST_INITIAL_VAL_B);
-		ctx->state[2] = readl(cpg->reg + DIGEST_INITIAL_VAL_C);
-		ctx->state[3] = readl(cpg->reg + DIGEST_INITIAL_VAL_D);
-		ctx->state[4] = readl(cpg->reg + DIGEST_INITIAL_VAL_E);
+		mv_save_digest_state(ctx);
 	}
 }
 
-- 
1.7.3.4
