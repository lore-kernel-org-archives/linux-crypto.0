From: <yanjiang.jin@windriver.com>
Subject: [PATCH 3/4] crypto: caamhash: add two missed dma_mapping_error
Date: Sat, 28 Feb 2015 14:00:33 +0800
Message-ID: <1425103234-31129-3-git-send-email-yanjiang.jin@windriver.com>
References: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <horia.geanta@freescale.com>, <kim.phillips@freescale.com>,
	<ruchika.gupta@freescale.com>, <cristian.stoica@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <jinyanjiang@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:36846 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbB1GAx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 01:00:53 -0500
In-Reply-To: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yanjiang Jin <yanjiang.jin@windriver.com>

Add two missed dma_mapping_error() after dma_map_single().

Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
---
 drivers/crypto/caam/caamhash.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f347ab7..f6ad322 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -160,6 +160,10 @@ static inline dma_addr_t map_seq_out_ptr_result(u32 *desc, struct device *jrdev,
 	dma_addr_t dst_dma;
 
 	dst_dma = dma_map_single(jrdev, result, digestsize, DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dst_dma)) {
+		dev_err(jrdev, "unable to map dst dma\n");
+		return -ENOMEM;
+	}
 	append_seq_out_ptr(desc, dst_dma, digestsize, 0);
 
 	return dst_dma;
@@ -173,6 +177,10 @@ static inline dma_addr_t buf_map_to_sec4_sg(struct device *jrdev,
 	dma_addr_t buf_dma;
 
 	buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, buf_dma)) {
+		dev_err(jrdev, "unable to map buf dma\n");
+		return 0;
+	}
 	dma_to_sec4_sg_one(sec4_sg, buf_dma, buflen, 0);
 
 	return buf_dma;
-- 
1.9.1
