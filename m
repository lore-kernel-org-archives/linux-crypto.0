Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284EEC636C9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F67A6120E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhGTIRW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:22 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41181 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhGTIPR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771355; x=1658307355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hVd8xpyglrOfRYOTqJne5vynkGg7GlMgVqvOu0dtfXU=;
  b=agPqvCJMq38vDecx/GSJ0VUxQGOdhI/MP/4q3p/rmN9G/fbukC6Z0Vfj
   cnIs18G/T/m0KAVmwPjBMrAzTcUDRjmIp1N8zaBiFvmfesuRa5otBwZn1
   bDUfmQoes5ygv4s8aGlHotgyWEB2K5aKCQSSxU8gxYZsxgZTT9klz0uJT
   rEw6UyufHU0q+O5hQmQFpOSdGYvzHnqxqilD04H2p4xNTEzf3JYMtPztS
   8HstcDf4eG/8a7ZsEzYLSREqPZ2C0hsNZi2gv+8HtDSCkaIVdeU/nVOHi
   Ngz96Bzev6pQkeL/8VhP1zwwdxCsrZz8yERjuUV0jwezPUKB6K9TjBFQX
   A==;
IronPort-SDR: A8EdHpt6RD7sCTQKpOa5KAjWEF4yqPwQxlxvbusIpgzN3XypSoEZLy9Lz9zove/mM1bDshw3CF
 DtLUQWE9Cl3l7DAgyBbgN06QmW823RHWqIck+/qzQjuU1tdJbNdIU/0cZJmpzURjdOhqdhdhpS
 z33hPTuAzy4kUhivI1F+Zjr4nAFMgUaGpPPOQgrAH2fnfNZJhiNiJ7VHLvISoiPYqmIy+ZOyil
 ERTjgv0D22xa5mXM1QD0rvBISnvignJIlhqlt/evLqPSRph0cOxp/WgrLJXHZJ/eQuHnlnQTIg
 vLIZQ7LoXeoC3JFmi7HwBsNj
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="122687330"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:55:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:44 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:42 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 2/9] crypto: atmel-tdes: Handle error messages
Date:   Tue, 20 Jul 2021 11:55:28 +0300
Message-ID: <20210720085535.141486-3-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Downgrade all runtime error messages to dev_dbg so that we don't
pollute the console. All probe error messages are kept with dev_err.
Get rid of pr_err and use dev_dbg instead, so that we know from which
device the error comes.
dma_mapping_error() return code was overwritten, use the error code
that the function returns.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index dda70dbe0838..abbf1b7a75ab 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -312,7 +312,7 @@ static int atmel_tdes_crypt_pdc_stop(struct atmel_tdes_dev *dd)
 				dd->buf_out, dd->buflen, dd->dma_size, 1);
 		if (count != dd->dma_size) {
 			err = -EINVAL;
-			pr_err("not all data converted: %zu\n", count);
+			dev_dbg(dd->dev, "not all data converted: %zu\n", count);
 		}
 	}
 
@@ -329,24 +329,24 @@ static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)
 	dd->buflen &= ~(DES_BLOCK_SIZE - 1);
 
 	if (!dd->buf_in || !dd->buf_out) {
-		dev_err(dd->dev, "unable to alloc pages.\n");
+		dev_dbg(dd->dev, "unable to alloc pages.\n");
 		goto err_alloc;
 	}
 
 	/* MAP here */
 	dd->dma_addr_in = dma_map_single(dd->dev, dd->buf_in,
 					dd->buflen, DMA_TO_DEVICE);
-	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
-		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
-		err = -EINVAL;
+	err = dma_mapping_error(dd->dev, dd->dma_addr_in);
+	if (err) {
+		dev_dbg(dd->dev, "dma %zd bytes error\n", dd->buflen);
 		goto err_map_in;
 	}
 
 	dd->dma_addr_out = dma_map_single(dd->dev, dd->buf_out,
 					dd->buflen, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
-		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
-		err = -EINVAL;
+	err = dma_mapping_error(dd->dev, dd->dma_addr_out);
+	if (err) {
+		dev_dbg(dd->dev, "dma %zd bytes error\n", dd->buflen);
 		goto err_map_out;
 	}
 
@@ -359,8 +359,6 @@ static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)
 err_alloc:
 	free_page((unsigned long)dd->buf_out);
 	free_page((unsigned long)dd->buf_in);
-	if (err)
-		pr_err("error: %d\n", err);
 	return err;
 }
 
@@ -512,14 +510,14 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {
-			dev_err(dd->dev, "dma_map_sg() error\n");
+			dev_dbg(dd->dev, "dma_map_sg() error\n");
 			return -EINVAL;
 		}
 
 		err = dma_map_sg(dd->dev, dd->out_sg, 1,
 				DMA_FROM_DEVICE);
 		if (!err) {
-			dev_err(dd->dev, "dma_map_sg() error\n");
+			dev_dbg(dd->dev, "dma_map_sg() error\n");
 			dma_unmap_sg(dd->dev, dd->in_sg, 1,
 				DMA_TO_DEVICE);
 			return -EINVAL;
@@ -670,7 +668,7 @@ static int atmel_tdes_crypt_dma_stop(struct atmel_tdes_dev *dd)
 				dd->buf_out, dd->buflen, dd->dma_size, 1);
 			if (count != dd->dma_size) {
 				err = -EINVAL;
-				pr_err("not all data converted: %zu\n", count);
+				dev_dbg(dd->dev, "not all data converted: %zu\n", count);
 			}
 		}
 	}
@@ -682,11 +680,12 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct atmel_tdes_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(req);
+	struct device *dev = ctx->dd->dev;
 
 	switch (mode & TDES_FLAGS_OPMODE_MASK) {
 	case TDES_FLAGS_CFB8:
 		if (!IS_ALIGNED(req->cryptlen, CFB8_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB8 blocks\n");
+			dev_dbg(dev, "request size is not exact amount of CFB8 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = CFB8_BLOCK_SIZE;
@@ -694,7 +693,7 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	case TDES_FLAGS_CFB16:
 		if (!IS_ALIGNED(req->cryptlen, CFB16_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB16 blocks\n");
+			dev_dbg(dev, "request size is not exact amount of CFB16 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = CFB16_BLOCK_SIZE;
@@ -702,7 +701,7 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	case TDES_FLAGS_CFB32:
 		if (!IS_ALIGNED(req->cryptlen, CFB32_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of CFB32 blocks\n");
+			dev_dbg(dev, "request size is not exact amount of CFB32 blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = CFB32_BLOCK_SIZE;
@@ -710,7 +709,7 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	default:
 		if (!IS_ALIGNED(req->cryptlen, DES_BLOCK_SIZE)) {
-			pr_err("request size is not exact amount of DES blocks\n");
+			dev_dbg(dev, "request size is not exact amount of DES blocks\n");
 			return -EINVAL;
 		}
 		ctx->block_size = DES_BLOCK_SIZE;
-- 
2.25.1

