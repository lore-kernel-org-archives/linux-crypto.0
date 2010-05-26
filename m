From: David Miller <davem@davemloft.net>
Subject: [PATCH 4/7] n2_crypto: Kill n2_base_ctx and helpers.
Date: Tue, 25 May 2010 17:43:39 -0700 (PDT)
Message-ID: <20100525.174339.246534749.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37726
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297Ab0EZAn3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Unused, and we'll do this via the request context.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 23163fd..3a4eed4 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -239,18 +239,7 @@ static inline bool n2_should_run_async(struct spu_queue *qp, int this_len)
 }
 #endif
 
-struct n2_base_ctx {
-	struct list_head		list;
-};
-
-static void n2_base_ctx_init(struct n2_base_ctx *ctx)
-{
-	INIT_LIST_HEAD(&ctx->list);
-}
-
 struct n2_hash_ctx {
-	struct n2_base_ctx		base;
-
 	struct crypto_ahash		*fallback_tfm;
 };
 
@@ -390,7 +379,6 @@ static int n2_hash_async_digest(struct ahash_request *req,
 				unsigned int result_size, void *hash_loc)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct cwq_initial_entry *ent;
 	struct crypto_hash_walk walk;
 	struct spu_queue *qp;
@@ -403,6 +391,7 @@ static int n2_hash_async_digest(struct ahash_request *req,
 	 */
 	if (unlikely(req->nbytes > (1 << 16))) {
 		struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
+		struct n2_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 		ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
 		rctx->fallback_req.base.flags =
@@ -414,8 +403,6 @@ static int n2_hash_async_digest(struct ahash_request *req,
 		return crypto_ahash_digest(&rctx->fallback_req);
 	}
 
-	n2_base_ctx_init(&ctx->base);
-
 	nbytes = crypto_hash_walk_first(req, &walk);
 
 	cpu = get_cpu();
-- 
1.7.0.4
