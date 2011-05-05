From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 07/10] mv_cesa: fill inner/outer IV fields only in HMAC case
Date: Thu,  5 May 2011 15:29:03 +0200
Message-ID: <1304602146-5918-7-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:49576 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EENjy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:54 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index de09303..c1925c2 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -296,6 +296,7 @@ static void mv_crypto_algo_completion(void)
 static void mv_process_hash_current(int first_block)
 {
 	struct ahash_request *req = ahash_request_cast(cpg->cur_req);
+	const struct mv_tfm_hash_ctx *tfm_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
 	struct req_progress *p = &cpg->p;
 	struct sec_accel_config op = { 0 };
@@ -308,6 +309,8 @@ static void mv_process_hash_current(int first_block)
 		break;
 	case COP_HMAC_SHA1:
 		op.config = CFG_OP_MAC_ONLY | CFG_MACM_HMAC_SHA1;
+		memcpy(cpg->sram + SRAM_HMAC_IV_IN,
+				tfm_ctx->ivs, sizeof(tfm_ctx->ivs));
 		break;
 	}
 
@@ -510,7 +513,6 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 {
 	struct req_progress *p = &cpg->p;
 	struct mv_req_hash_ctx *ctx = ahash_request_ctx(req);
-	const struct mv_tfm_hash_ctx *tfm_ctx = crypto_tfm_ctx(req->base.tfm);
 	int num_sgs, hw_bytes, old_extra_bytes, rc;
 	cpg->cur_req = &req->base;
 	memset(p, 0, sizeof(struct req_progress));
@@ -523,8 +525,6 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 		p->crypt_len = ctx->extra_bytes;
 	}
 
-	memcpy(cpg->sram + SRAM_HMAC_IV_IN, tfm_ctx->ivs, sizeof(tfm_ctx->ivs));
-
 	if (unlikely(!ctx->first_hash)) {
 		writel(ctx->state[0], cpg->reg + DIGEST_INITIAL_VAL_A);
 		writel(ctx->state[1], cpg->reg + DIGEST_INITIAL_VAL_B);
-- 
1.7.4.1
