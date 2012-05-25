From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 12/13] mv_cesa: drop the now unused process callback
Date: Fri, 25 May 2012 18:08:38 +0200
Message-ID: <1337962119-5509-13-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47911 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab2EYQJA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:09:00 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

And while here, simplify dequeue_complete_req() a bit.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 9afed2d..9a2f413 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -69,7 +69,6 @@ struct req_progress {
 	struct scatterlist *src_sg;
 	struct scatterlist *dst_sg;
 	void (*complete) (void);
-	void (*process) (void);
 
 	/* src mostly */
 	int sg_src_left;
@@ -648,25 +647,17 @@ static void mv_hash_algo_completion(void)
 static void dequeue_complete_req(void)
 {
 	struct crypto_async_request *req = cpg->cur_req;
-	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
-	cpg->p.crypt_len = 0;
 
 	mv_tdma_clear();
 	cpg->u32_usage = 0;
 
 	BUG_ON(cpg->eng_st != ENGINE_W_DEQUEUE);
-	if (cpg->p.hw_processed_bytes < cpg->p.hw_nbytes) {
-		/* process next scatter list entry */
-		cpg->eng_st = ENGINE_BUSY;
-		setup_data_in();
-		cpg->p.process();
-	} else {
-		cpg->p.complete();
-		cpg->eng_st = ENGINE_IDLE;
-		local_bh_disable();
-		req->complete(req, 0);
-		local_bh_enable();
-	}
+
+	cpg->p.complete();
+	cpg->eng_st = ENGINE_IDLE;
+	local_bh_disable();
+	req->complete(req, 0);
+	local_bh_enable();
 }
 
 static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
-- 
1.7.3.4
