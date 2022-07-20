Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902F3C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jul 2022 13:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiGTNhJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jul 2022 09:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiGTNhI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jul 2022 09:37:08 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Jul 2022 06:37:04 PDT
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2ADA4B496
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 06:37:04 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id E9lWoEl0qnm5hE9lXoFeAH; Wed, 20 Jul 2022 15:29:32 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 20 Jul 2022 15:29:32 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christoph Hellwig <hch@infradead.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: ccree - Remove a useless dma_supported() call
Date:   Wed, 20 Jul 2022 15:28:44 +0200
Message-Id: <f47cdaa7067af0ae2eeeca52cee2176cdc449a22.1658323697.git.christophe.jaillet@wanadoo.fr>
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

Moreover, setting a larger DMA mask will never fail when setting a smaller
one will succeed, so the whole "while" loop can be removed as well. (see
[1])

While at it, fix the name of the function reported in a dev_err().

[1]: https://lore.kernel.org/all/YteQ6Vx2C03UtCkG@infradead.org/

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/ccree/cc_driver.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 7d1bee86d581..cadead18b59e 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -372,17 +372,10 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		dev->dma_mask = &dev->coherent_dma_mask;
 
 	dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
-	while (dma_mask > 0x7fffffffUL) {
-		if (dma_supported(dev, dma_mask)) {
-			rc = dma_set_coherent_mask(dev, dma_mask);
-			if (!rc)
-				break;
-		}
-		dma_mask >>= 1;
-	}
-
+	rc = dma_set_coherent_mask(dev, dma_mask);
 	if (rc) {
-		dev_err(dev, "Failed in dma_set_mask, mask=%llx\n", dma_mask);
+		dev_err(dev, "Failed in dma_set_coherent_mask, mask=%llx\n",
+			dma_mask);
 		return rc;
 	}
 
-- 
2.34.1

