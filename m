From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 3/7] crypto: img-hash - Reconfigure DMA Burst length
Date: Fri, 5 Aug 2016 14:00:16 +0100
Message-ID: <1470402020-10774-4-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Will Thomas <will.thomas@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:25560 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692AbcHENIN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:13 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Burst length of 16 drives the hash accelerator out of spec
and causes stability issues in some cases. Reduce this to
stop data being lost.

Signed-off-by: Will Thomas <will.thomas@imgtec.com>
Reviewed-by: James Hartley <james.hartley@imgtec.com>
---
 drivers/crypto/img-hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index de2b86e..f8abbe3 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -71,6 +71,7 @@
 #define DRIVER_FLAGS_MD5		BIT(21)
 
 #define IMG_HASH_QUEUE_LENGTH		20
+#define IMG_HASH_DMA_BURST		4
 #define IMG_HASH_DMA_THRESHOLD		64
 
 #ifdef __LITTLE_ENDIAN
@@ -342,7 +343,7 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 	dma_conf.direction = DMA_MEM_TO_DEV;
 	dma_conf.dst_addr = hdev->bus_addr;
 	dma_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	dma_conf.dst_maxburst = 16;
+	dma_conf.dst_maxburst = IMG_HASH_DMA_BURST;
 	dma_conf.device_fc = false;
 
 	err = dmaengine_slave_config(hdev->dma_lch,  &dma_conf);
-- 
2.1.4
