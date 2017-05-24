From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 11/13] crypto: omap-sham: buffer handling fixes for hashing later
Date: Wed, 24 May 2017 10:35:32 +0300
Message-ID: <1495611334-15039-12-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:51597 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966684AbdEXHgZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:36:25 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, the hash later code only handles the cases when we have
either new data coming in with the request or old data in the buffer,
but not the combination when we have both. Fix this by changing the
ordering of the code a bit and handling both cases properly
simultaneously if needed. Also, fix an issue with omap_sham_update
that surfaces with this fix, so that the code checks the bufcnt
instead of total data amount against buffer length to avoid any
buffer overflows.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index d0b16e5..c65b49b 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -873,14 +873,21 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
 	}
 
 	if (hash_later) {
-		if (req->nbytes) {
-			scatterwalk_map_and_copy(rctx->buffer, req->src,
-						 req->nbytes - hash_later,
-						 hash_later, 0);
-		} else {
+		int offset = 0;
+
+		if (hash_later > req->nbytes) {
 			memcpy(rctx->buffer, rctx->buffer + xmit_len,
-			       hash_later);
+			       hash_later - req->nbytes);
+			offset = hash_later - req->nbytes;
 		}
+
+		if (req->nbytes) {
+			scatterwalk_map_and_copy(rctx->buffer + offset,
+						 req->src,
+						 offset + req->nbytes -
+						 hash_later, hash_later, 0);
+		}
+
 		rctx->bufcnt = hash_later;
 	} else {
 		rctx->bufcnt = 0;
@@ -1189,11 +1196,10 @@ static int omap_sham_update(struct ahash_request *req)
 	if (!req->nbytes)
 		return 0;
 
-	if (ctx->total + req->nbytes < ctx->buflen) {
+	if (ctx->bufcnt + req->nbytes <= ctx->buflen) {
 		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, req->src,
 					 0, req->nbytes, 0);
 		ctx->bufcnt += req->nbytes;
-		ctx->total += req->nbytes;
 		return 0;
 	}
 
-- 
1.9.1
