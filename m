From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto/s5p-sss: Use common error handling code in
 s5p_aes_probe()
Date: Sun, 22 Oct 2017 15:05:05 +0200
Message-ID: <791df15e-3a35-d270-0acf-1661bd89adad@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50279 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751019AbdJVNF0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2017 09:05:26 -0400
Content-Language: en-GB
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 22 Oct 2017 15:00:27 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/s5p-sss.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7ac657f46d15..ea59e184c199 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -863,16 +863,13 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	pdata->irq_fc = platform_get_irq(pdev, 0);
 	if (pdata->irq_fc < 0) {
 		err = pdata->irq_fc;
-		dev_warn(dev, "feed control interrupt is not available.\n");
-		goto err_irq;
+		goto report_failure;
 	}
 	err = devm_request_threaded_irq(dev, pdata->irq_fc, NULL,
 					s5p_aes_interrupt, IRQF_ONESHOT,
 					pdev->name, pdev);
-	if (err < 0) {
-		dev_warn(dev, "feed control interrupt is not available.\n");
-		goto err_irq;
-	}
+	if (err < 0)
+		goto report_failure;
 
 	pdata->busy = false;
 	pdata->dev = dev;
@@ -906,6 +903,10 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	s5p_dev = NULL;
 
 	return err;
+
+report_failure:
+	dev_warn(dev, "feed control interrupt is not available.\n");
+	goto err_irq;
 }
 
 static int s5p_aes_remove(struct platform_device *pdev)
-- 
2.14.2
