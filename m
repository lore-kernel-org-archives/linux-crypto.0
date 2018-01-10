From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] hwrng: exynos - remove redundant dev_err call in exynos_trng_probe()
Date: Wed, 10 Jan 2018 13:30:59 +0000
Message-ID: <1515591059-73230-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: <l.stelmach@samsung.com>, <mpm@selenic.com>,
        <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <kgene@kernel.org>, <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:47712 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755537AbeAJNYn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 08:24:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/exynos-trng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 34d6f51..4c8a2be 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -129,10 +129,8 @@ static int exynos_trng_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	trng->mem = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(trng->mem)) {
-		dev_err(&pdev->dev, "Could not map IO resources.\n");
+	if (IS_ERR(trng->mem))
 		return PTR_ERR(trng->mem);
-	}
 
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
