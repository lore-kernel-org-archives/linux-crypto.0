From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: sahara - checking the wrong variable
Date: Tue, 20 Aug 2013 11:51:41 +0300
Message-ID: <20130820085141.GA7469@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45773 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3HTIwE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Aug 2013 04:52:04 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is a typo here.  "dev->hw_link[]" is an array, not a pointer, so
the check is nonsense.  We should be checking recently allocated
"dev->hw_link[0]" instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index b076d81..d7bb8ba 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -955,7 +955,7 @@ static int sahara_probe(struct platform_device *pdev)
 	dev->hw_link[0] = dma_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
 			&dev->hw_phys_link[0], GFP_KERNEL);
-	if (!dev->hw_link) {
+	if (!dev->hw_link[0]) {
 		dev_err(&pdev->dev, "Could not allocate hw links\n");
 		err = -ENOMEM;
 		goto err_link;
