Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA00C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 05:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiEHFac (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 01:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiEHFac (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 01:30:32 -0400
X-Greylist: delayed 181 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 07 May 2022 22:26:39 PDT
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC1BBDEA9
        for <linux-crypto@vger.kernel.org>; Sat,  7 May 2022 22:26:39 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.87])
        by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee6627753d5cff-fa988;
        Sun, 08 May 2022 13:23:36 +0800 (CST)
X-RM-TRANSID: 2ee6627753d5cff-fa988
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from 192.168.125.128 (unknown[112.22.3.130])
        by rmsmtp-syy-appsvrnew04-12029 (RichMail) with SMTP id 2efd627753d0c4e-a6fa5;
        Sun, 08 May 2022 13:23:35 +0800 (CST)
X-RM-TRANSID: 2efd627753d0c4e-a6fa5
From:   jianchunfu <jianchunfu@cmss.chinamobile.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Subject: [PATCH] crypto: talitos - Uniform coding style with defined variable
Date:   Sun,  8 May 2022 13:22:50 +0800
Message-Id: <20220508052250.23000-1-jianchunfu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the defined variable "desc" to uniform coding style.

Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
---
 drivers/crypto/talitos.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 25c9f825b..c9ad6c213 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1709,7 +1709,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	struct talitos_desc *desc2 = (struct talitos_desc *)
 				     (edesc->buf + edesc->dma_len);
 
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
 	if (desc->next_desc &&
 	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
 		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
@@ -1721,8 +1721,8 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&edesc->desc.ptr[1], is_sec1))
-		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
+	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
+		unmap_single_talitos_ptr(dev, &desc->ptr[1],
 					 DMA_TO_DEVICE);
 	else if (desc->next_desc)
 		unmap_single_talitos_ptr(dev, &desc2->ptr[1],
@@ -1736,8 +1736,8 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
 
-	if (edesc->desc.next_desc)
-		dma_unmap_single(dev, be32_to_cpu(edesc->desc.next_desc),
+	if (desc->next_desc)
+		dma_unmap_single(dev, be32_to_cpu(desc->next_desc),
 				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 }
 
-- 
2.18.4



