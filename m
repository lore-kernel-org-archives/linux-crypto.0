From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 3/6] crypto: img-hash - Reconfigure DMA Burst length
Date: Mon, 11 Jul 2016 10:33:33 +0100
Message-ID: <1468229616-3888-4-git-send-email-will.thomas@imgtec.com>
References: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Will Thomas <will.thomas@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:9717 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcGKJeX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:23 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id 8664F1201AD65
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:09 +0100 (IST)
In-Reply-To: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
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
index 7fa6aa4..fbed47a 100644
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
