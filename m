From: <yanjiang.jin@windriver.com>
Subject: [PATCH 1/4] crypto: caam: fix some compile warnings
Date: Sat, 28 Feb 2015 14:00:31 +0800
Message-ID: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <horia.geanta@freescale.com>, <kim.phillips@freescale.com>,
	<ruchika.gupta@freescale.com>, <cristian.stoica@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <jinyanjiang@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:36844 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbB1GAu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 01:00:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yanjiang Jin <yanjiang.jin@windriver.com>

This commit is to avoid the below warnings:

drivers/crypto/caam/sg_sw_sec4.h:88:12: warning:
'dma_map_sg_chained' defined but not used [-Wunused-function]
 static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
            ^
drivers/crypto/caam/sg_sw_sec4.h:104:12: warning:
'dma_unmap_sg_chained' defined but not used [-Wunused-function]
 static int dma_unmap_sg_chained(struct device *dev,
            ^

Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
---
 drivers/crypto/caam/sg_sw_sec4.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 3b91821..a6276eb 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -85,7 +85,7 @@ static inline int sg_count(struct scatterlist *sg_list, int nbytes,
 	return sg_nents;
 }
 
-static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
+static inline int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
 			      unsigned int nents, enum dma_data_direction dir,
 			      bool chained)
 {
@@ -101,9 +101,9 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
 	return nents;
 }
 
-static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
-				unsigned int nents, enum dma_data_direction dir,
-				bool chained)
+static inline int dma_unmap_sg_chained(struct device *dev,
+				struct scatterlist *sg, unsigned int nents,
+				enum dma_data_direction dir, bool chained)
 {
 	if (unlikely(chained)) {
 		int i;
-- 
1.9.1
