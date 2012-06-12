From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 12/13] mv_cesa: drop the now unused process callback
Date: Tue, 12 Jun 2012 19:17:26 +0200
Message-ID: <1339521447-17721-13-git-send-email-phil.sutter@viprinet.com>
References: <20120612113941.GA14757@gondor.apana.org.au>
 <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:58586 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab2FLRRk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 13:17:40 -0400
In-Reply-To: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

And while here, simplify dequeue_complete_req() a bit.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 86b73d1..7b2b693 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -70,7 +70,6 @@ struct req_progress {
 	struct scatterlist *src_sg;
 	struct scatterlist *dst_sg;
 	void (*complete) (void);
-	void (*process) (void);
 
 	/* src mostly */
 	int sg_src_left;
@@ -650,25 +649,17 @@ static void mv_hash_algo_completion(void)
 static void dequeue_complete_req(void)
 {
 	struct crypto_async_request *req = cpg->cur_req;
-	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
-	cpg->p.crypt_len = 0;
 
 	mv_dma_clear();
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
