From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 09/10] mv_cesa: copy remaining bytes to SRAM only when needed
Date: Thu,  5 May 2011 15:29:05 +0200
Message-ID: <1304602146-5918-9-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:44915 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EENjo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:44 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index a2d9e39..d704ed0 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -525,12 +525,6 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	hw_bytes = req->nbytes + ctx->extra_bytes;
 	old_extra_bytes = ctx->extra_bytes;
 
-	if (unlikely(ctx->extra_bytes)) {
-		memcpy(cpg->sram + SRAM_DATA_IN_START, ctx->buffer,
-		       ctx->extra_bytes);
-		p->crypt_len = ctx->extra_bytes;
-	}
-
 	ctx->extra_bytes = hw_bytes % SHA1_BLOCK_SIZE;
 	if (ctx->extra_bytes != 0
 	    && (!ctx->last_chunk || ctx->count > MAX_HW_HASH_SIZE))
@@ -546,6 +540,12 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 		p->complete = mv_hash_algo_completion;
 		p->process = mv_process_hash_current;
 
+		if (unlikely(old_extra_bytes)) {
+			memcpy(cpg->sram + SRAM_DATA_IN_START, ctx->buffer,
+			       old_extra_bytes);
+			p->crypt_len = old_extra_bytes;
+		}
+
 		mv_process_hash_current(1);
 	} else {
 		copy_src_to_buf(p, ctx->buffer + old_extra_bytes,
-- 
1.7.4.1
