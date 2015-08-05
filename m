From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 07/14] crypto: caam - Use local sg pointers to walk the scatterlist
Date: Wed, 5 Aug 2015 11:28:41 -0700
Message-ID: <1438799328-10757-8-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:51232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753199AbbHES26 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:58 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid moving the head of the scatterlist entry by using temporary
pointers to walk the scatterlist.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/sg_sw_sec4.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 711bb39..18cd6d1 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -105,9 +105,15 @@ static inline void dma_unmap_sg_chained(
 {
 	if (unlikely(chained)) {
 		int i;
+		struct scatterlist *tsg = sg;
+
+		/*
+		 * Use a local copy of the sg pointer to avoid moving the
+		 * head of the list pointed to by sg as we walk the list.
+		 */
 		for (i = 0; i < nents; i++) {
-			dma_unmap_sg(dev, sg, 1, dir);
-			sg = sg_next(sg);
+			dma_unmap_sg(dev, tsg, 1, dir);
+			tsg = sg_next(tsg);
 		}
 	} else if (nents) {
 		dma_unmap_sg(dev, sg, nents, dir);
@@ -118,19 +124,23 @@ static inline int dma_map_sg_chained(
 	struct device *dev, struct scatterlist *sg, unsigned int nents,
 	enum dma_data_direction dir, bool chained)
 {
-	struct scatterlist *first = sg;
-
 	if (unlikely(chained)) {
 		int i;
+		struct scatterlist *tsg = sg;
+
+		/*
+		 * Use a local copy of the sg pointer to avoid moving the
+		 * head of the list pointed to by sg as we walk the list.
+		 */
 		for (i = 0; i < nents; i++) {
-			if (!dma_map_sg(dev, sg, 1, dir)) {
-				dma_unmap_sg_chained(dev, first, i, dir,
+			if (!dma_map_sg(dev, tsg, 1, dir)) {
+				dma_unmap_sg_chained(dev, sg, i, dir,
 						     chained);
 				nents = 0;
 				break;
 			}
 
-			sg = sg_next(sg);
+			tsg = sg_next(tsg);
 		}
 	} else
 		nents = dma_map_sg(dev, sg, nents, dir);
-- 
2.1.4
