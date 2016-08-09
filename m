From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 2/7] crypto: marvell: remove unused parameter in mv_cesa_ahash_dma_add_cache()
Date: Tue,  9 Aug 2016 11:03:15 +0200
Message-ID: <1470733400-23621-3-git-send-email-romain.perier@free-electrons.com>
References: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39663 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbcHIJDi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:03:38 -0400
In-Reply-To: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

The dma_iter parameter of mv_cesa_ahash_dma_add_cache() is never used,
so get rid of it.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 82e0f4e6..0d7f5f9 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -455,7 +455,6 @@ mv_cesa_dma_add_frag(struct mv_cesa_tdma_chain *chain,
 
 static int
 mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
-			    struct mv_cesa_ahash_dma_iter *dma_iter,
 			    struct mv_cesa_ahash_req *creq,
 			    gfp_t flags)
 {
@@ -586,7 +585,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	 * Add the cache (left-over data from a previous block) first.
 	 * This will never overflow the SRAM size.
 	 */
-	ret = mv_cesa_ahash_dma_add_cache(&basereq->chain, &iter, creq, flags);
+	ret = mv_cesa_ahash_dma_add_cache(&basereq->chain, creq, flags);
 	if (ret)
 		goto err_free_tdma;
 
-- 
2.8.1
