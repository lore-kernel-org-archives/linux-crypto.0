From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: brcm: add NULL check on of_match_device() return
 value
Date: Fri, 7 Jul 2017 01:33:33 -0500
Message-ID: <20170707063333.GA18377@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@mebeddedor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.145.82]:22904 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750844AbdGGGdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 02:33:46 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 29231139A59
        for <linux-crypto@vger.kernel.org>; Fri,  7 Jul 2017 01:33:34 -0500 (CDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Check return value from call to of_match_device()
in order to prevent a NULL pointer dereference.

In case of NULL print error message and return -ENODEV

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/bcm/cipher.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 9cfd36c..f1a826f 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4813,6 +4813,11 @@ static int spu_dt_read(struct platform_device *pdev)
 	int err;
 
 	match = of_match_device(of_match_ptr(bcm_spu_dt_ids), dev);
+	if (!match) {
+		dev_err(&pdev->dev, "Failed to match device\n");
+		return -ENODEV;
+	}
+
 	matched_spu_type = match->data;
 
 	if (iproc_priv.spu.num_spu > 1) {
-- 
2.5.0
