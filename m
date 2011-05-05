From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 10/10] mv_cesa: make count_sgs() null-pointer proof
Date: Thu,  5 May 2011 15:29:06 +0200
Message-ID: <1304602146-5918-10-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:49230 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab1EENjp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:45 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This also makes the dummy scatterlist in mv_hash_final() needless, so
drop it.

XXX: should this routine be made pulicly available? There are probably
other users with their own implementations.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index d704ed0..3cf303e 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -133,7 +133,6 @@ struct mv_req_hash_ctx {
 	int extra_bytes;	/* unprocessed bytes in buffer */
 	enum hash_op op;
 	int count_add;
-	struct scatterlist dummysg;
 };
 
 static void compute_aes_dec_key(struct mv_ctx *ctx)
@@ -482,7 +481,7 @@ static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
 	int i = 0;
 	size_t cur_len;
 
-	while (1) {
+	while (sl) {
 		cur_len = sl[i].length;
 		++i;
 		if (total_bytes > cur_len)
@@ -711,10 +710,7 @@ static int mv_hash_update(struct ahash_request *req)
 static int mv_hash_final(struct ahash_request *req)
 {
 	struct mv_req_hash_ctx *ctx = ahash_request_ctx(req);
-	/* dummy buffer of 4 bytes */
-	sg_init_one(&ctx->dummysg, ctx->buffer, 4);
-	/* I think I'm allowed to do that... */
-	ahash_request_set_crypt(req, &ctx->dummysg, req->result, 0);
+
 	mv_update_hash_req_ctx(ctx, 1, 0);
 	return mv_handle_req(&req->base);
 }
-- 
1.7.4.1
