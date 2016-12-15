From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] crypto: bfin_crc: Fix format printing warning
Date: Thu, 15 Dec 2016 10:59:42 +0100
Message-ID: <20161215095943.10015-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35206 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcLOKBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2016 05:01:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

bfin_crc.c print some u32 as unsigned long ans so gcc complains
about it.
This patch remove the long print qualifier.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/bfin_crc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 10db7df..a118b9b 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -203,7 +203,7 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 			crc->sg_cpu[i].x_count = 1;
 			crc->sg_cpu[i].x_modify = CHKSUM_DIGEST_SIZE;
 			dev_dbg(crc->dev, "%d: crc_dma: start_addr:0x%lx, "
-				"cfg:0x%lx, x_count:0x%lx, x_modify:0x%lx\n",
+				"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
 				i, crc->sg_cpu[i].start_addr,
 				crc->sg_cpu[i].cfg, crc->sg_cpu[i].x_count,
 				crc->sg_cpu[i].x_modify);
@@ -233,7 +233,7 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 		crc->sg_cpu[i].x_count = dma_count;
 		crc->sg_cpu[i].x_modify = dma_mod;
 		dev_dbg(crc->dev, "%d: crc_dma: start_addr:0x%lx, "
-			"cfg:0x%lx, x_count:0x%lx, x_modify:0x%lx\n",
+			"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
 			i, crc->sg_cpu[i].start_addr,
 			crc->sg_cpu[i].cfg, crc->sg_cpu[i].x_count,
 			crc->sg_cpu[i].x_modify);
@@ -257,7 +257,7 @@ static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
 		crc->sg_cpu[i].x_count = 1;
 		crc->sg_cpu[i].x_modify = CHKSUM_DIGEST_SIZE;
 		dev_dbg(crc->dev, "%d: crc_dma: start_addr:0x%lx, "
-			"cfg:0x%lx, x_count:0x%lx, x_modify:0x%lx\n",
+			"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
 			i, crc->sg_cpu[i].start_addr,
 			crc->sg_cpu[i].cfg, crc->sg_cpu[i].x_count,
 			crc->sg_cpu[i].x_modify);
-- 
2.10.2
