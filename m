From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 05/11] crypto: caam - Add cache coherency support to Freescale CAAM scatterlist implementation
Date: Mon, 15 Jun 2015 16:52:53 -0700
Message-ID: <1434412379-11623-6-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0101.outbound.protection.outlook.com ([65.55.169.101]:22978
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730AbbFPA0e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:26:34 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add cache coherency support to the CAAM scatterlist implementation.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/sg_sw_sec4.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 6365585..6730b01 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -91,9 +91,14 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
 {
 	if (unlikely(chained)) {
 		int i;
+	struct scatterlist *tsg = sg;
+
+	/* We use a local copy of the sg pointer to avoid moving the
+	 * head of the list pointed to by sg as we wall the list.
+	 */
 		for (i = 0; i < nents; i++) {
-			dma_map_sg(dev, sg, 1, dir);
-			sg = sg_next(sg);
+			dma_map_sg(dev, tsg, 1, dir);
+			tsg = scatterwalk_sg_next(tsg);
 		}
 	} else {
 		dma_map_sg(dev, sg, nents, dir);
@@ -106,6 +111,9 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
 				unsigned int nents, enum dma_data_direction dir,
 				bool chained)
 {
+	if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
+		dma_sync_sg_for_cpu(dev, sg, nents, dir);
+
 	if (unlikely(chained)) {
 		int i;
 		for (i = 0; i < nents; i++) {
-- 
2.1.4
