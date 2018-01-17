From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] crypto: axis - remove unnecessary platform_get_resource() error check
Date: Wed, 17 Jan 2018 11:26:47 +0000
Message-ID: <1516188407-145156-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, <linux-arm-kernel@axis.com>,
        <linux-crypto@vger.kernel.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4216 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752556AbeAQLUa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 06:20:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

devm_ioremap_resource() already checks if the resource is NULL, so
remove the unnecessary platform_get_resource() error check.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 0f9754e..02e8739 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -3041,9 +3041,6 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	variant = (enum artpec6_crypto_variant)match->data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
