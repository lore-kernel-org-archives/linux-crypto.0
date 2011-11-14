From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH] crypto: mv_cesa - fix hashing of chunks > 1920 bytes
Date: Mon, 14 Nov 2011 16:41:43 +0100
Message-ID: <1321285303-28925-1-git-send-email-phil.sutter@viprinet.com>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:44132 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1KNP4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Nov 2011 10:56:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This was broken by commit 7759995c75ae0cbd4c861582908449f6b6208e7a (yes,
myself). The basic problem here is since the digest state is only saved
after the last chunk, the state array is only valid when handling the
first chunk of the next buffer. Broken since linux-3.0.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 5c6f56f..dcd8bab 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -343,11 +343,13 @@ static void mv_process_hash_current(int first_block)
 		else
 			op.config |= CFG_MID_FRAG;
 
-		writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
-		writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
-		writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
-		writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
-		writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
+		if (first_block) {
+			writel(req_ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
+			writel(req_ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
+			writel(req_ctx->state[2], cpg->reg + DIGEST_INITIAL_VAL_C);
+			writel(req_ctx->state[3], cpg->reg + DIGEST_INITIAL_VAL_D);
+			writel(req_ctx->state[4], cpg->reg + DIGEST_INITIAL_VAL_E);
+		}
 	}
 
 	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config));
-- 
1.7.6.1
