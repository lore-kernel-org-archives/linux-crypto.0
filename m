Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EFAC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 20:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiGSU16 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 16:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiGSU16 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 16:27:58 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBD04F691
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 13:27:56 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id DtotonZfqnnjODtotop12z; Tue, 19 Jul 2022 22:27:54 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 19 Jul 2022 22:27:54 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ccree - Remove a useless dma_supported() call
Date:   Tue, 19 Jul 2022 22:27:50 +0200
Message-Id: <ef6f884ef144390f152c34d2f549b1f50303b7b1.1658262447.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no point in calling dma_supported() before calling
dma_set_coherent_mask(). This function already calls dma_supported() and
returns an error (-EIO) if it fails.

So remove the superfluous dma_supported() call.

While at it, fix the name of the function reported in a dev_err().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I guess that the whole while loop could be removed, but I don't remind the
thread with the corresponding explanation, so leave it as-is :(
---
 drivers/crypto/ccree/cc_driver.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 7d1bee86d581..99f8bda718fe 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -373,16 +373,16 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
 	while (dma_mask > 0x7fffffffUL) {
-		if (dma_supported(dev, dma_mask)) {
-			rc = dma_set_coherent_mask(dev, dma_mask);
-			if (!rc)
-				break;
-		}
+		rc = dma_set_coherent_mask(dev, dma_mask);
+		if (!rc)
+			break;
+
 		dma_mask >>= 1;
 	}
 
 	if (rc) {
-		dev_err(dev, "Failed in dma_set_mask, mask=%llx\n", dma_mask);
+		dev_err(dev, "Failed in dma_set_coherent_mask, mask=%llx\n",
+			dma_mask);
 		return rc;
 	}
 
-- 
2.34.1

