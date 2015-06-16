From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 5/8] crypto: caam - Handle errors in dma_map_sg_chained
Date: Tue, 16 Jun 2015 13:54:22 +0800
Message-ID: <E1Z4jpG-0005dh-9I@gondolin.me.apana.org.au>
References: <20150616054551.GA21524@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52422 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbFPFyZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 01:54:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently dma_map_sg_chained does not handle errors from the
underlying dma_map_sg calls.  This patch adds rollback in case
of an error by simply calling dma_unmap_sg_chained for the ones
that we've already mapped.

All current callers ignore the return value so this should have
no impact on them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/sg_sw_sec4.h |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index efbc1db..b68b74c 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -100,34 +100,41 @@ static inline int sg_count(struct scatterlist *sg_list, int nbytes,
 	return sg_nents;
 }
 
-static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
-			      unsigned int nents, enum dma_data_direction dir,
-			      bool chained)
+static inline void dma_unmap_sg_chained(
+	struct device *dev, struct scatterlist *sg, unsigned int nents,
+	enum dma_data_direction dir, bool chained)
 {
 	if (unlikely(chained)) {
 		int i;
 		for (i = 0; i < nents; i++) {
-			dma_map_sg(dev, sg, 1, dir);
+			dma_unmap_sg(dev, sg, 1, dir);
 			sg = sg_next(sg);
 		}
-	} else {
-		dma_map_sg(dev, sg, nents, dir);
+	} else if (nents) {
+		dma_unmap_sg(dev, sg, nents, dir);
 	}
-	return nents;
 }
 
-static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
-				unsigned int nents, enum dma_data_direction dir,
-				bool chained)
+static inline int dma_map_sg_chained(
+	struct device *dev, struct scatterlist *sg, unsigned int nents,
+	enum dma_data_direction dir, bool chained)
 {
+	struct scatterlist *first = sg;
+
 	if (unlikely(chained)) {
 		int i;
 		for (i = 0; i < nents; i++) {
-			dma_unmap_sg(dev, sg, 1, dir);
+			if (!dma_map_sg(dev, sg, 1, dir)) {
+				dma_unmap_sg_chained(dev, first, i, dir,
+						     chained);
+				nents = 0;
+				break;
+			}
+
 			sg = sg_next(sg);
 		}
-	} else {
-		dma_unmap_sg(dev, sg, nents, dir);
-	}
+	} else
+		nents = dma_map_sg(dev, sg, nents, dir);
+
 	return nents;
 }
