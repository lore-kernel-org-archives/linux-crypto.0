From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 4/7] crypto: marvell: make mv_cesa_ahash_cache_req() return bool
Date: Tue,  9 Aug 2016 11:03:17 +0200
Message-ID: <1470733400-23621-5-git-send-email-romain.perier@free-electrons.com>
References: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39681 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752174AbcHIJDi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:03:38 -0400
In-Reply-To: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

The mv_cesa_ahash_cache_req() function always returns 0, which makes
its return value pretty much useless. However, in addition to
returning a useless value, it also returns a boolean in a variable
passed by reference to indicate if the request was already cached.

So, this commit changes mv_cesa_ahash_cache_req() to return this
boolean. It consequently simplifies the only call site of
mv_cesa_ahash_cache_req(), where the "ret" variable is no longer
needed.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 7291664..cf8063d 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -403,15 +403,16 @@ static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int mv_cesa_ahash_cache_req(struct ahash_request *req, bool *cached)
+static bool mv_cesa_ahash_cache_req(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	bool cached = false;
 
 	if (creq->cache_ptr + req->nbytes < 64 && !creq->last_req) {
-		*cached = true;
+		cached = true;
 
 		if (!req->nbytes)
-			return 0;
+			return cached;
 
 		sg_pcopy_to_buffer(req->src, creq->src_nents,
 				   creq->cache + creq->cache_ptr,
@@ -420,7 +421,7 @@ static int mv_cesa_ahash_cache_req(struct ahash_request *req, bool *cached)
 		creq->cache_ptr += req->nbytes;
 	}
 
-	return 0;
+	return cached;
 }
 
 static struct mv_cesa_op_ctx *
@@ -665,7 +666,6 @@ err:
 static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	int ret;
 
 	creq->src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (creq->src_nents < 0) {
@@ -673,17 +673,15 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
 		return creq->src_nents;
 	}
 
-	ret = mv_cesa_ahash_cache_req(req, cached);
-	if (ret)
-		return ret;
+	*cached = mv_cesa_ahash_cache_req(req);
 
 	if (*cached)
 		return 0;
 
 	if (cesa_dev->caps->has_tdma)
-		ret = mv_cesa_ahash_dma_req_init(req);
-
-	return ret;
+		return mv_cesa_ahash_dma_req_init(req);
+	else
+		return 0;
 }
 
 static int mv_cesa_ahash_queue_req(struct ahash_request *req)
-- 
2.8.1
