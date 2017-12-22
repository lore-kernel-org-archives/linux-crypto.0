From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH v1 1/4] crypto: crypto4xx - shuffle iomap in front of request_irq
Date: Fri, 22 Dec 2017 21:18:35 +0100
Message-ID: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33730 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756086AbdLVUSl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 15:18:41 -0500
Received: by mail-wr0-f193.google.com with SMTP id v21so18113795wrc.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2017 12:18:41 -0800 (PST)
Received: from debian64.daheim (p5B0D71BC.dip0.t-ipconnect.de. [91.13.113.188])
        by smtp.gmail.com with ESMTPSA id u33sm30239689wrf.42.2017.12.22.12.18.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Dec 2017 12:18:39 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.90_RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1eSTmA-0005jw-G0
        for linux-crypto@vger.kernel.org; Fri, 22 Dec 2017 21:18:38 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It is possible to avoid the ce_base null pointer check in the
drivers' interrupt handler routine "crypto4xx_ce_interrupt_handler()"
by simply doing the iomap in front of the IRQ registration.

This way, the ce_base will always be valid in the handler and
a branch in an critical path can be avoided.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index c44954e274bc..50d5e64fbdbf 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1075,9 +1075,6 @@ static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
 	struct device *dev = (struct device *)data;
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 
-	if (!core_dev->dev->ce_base)
-		return 0;
-
 	writel(PPC4XX_INTERRUPT_CLR,
 	       core_dev->dev->ce_base + CRYPTO4XX_INT_CLR);
 	tasklet_schedule(&core_dev->tasklet);
@@ -1325,13 +1322,6 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
 		     (unsigned long) dev);
 
-	/* Register for Crypto isr, Crypto Engine IRQ */
-	core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	rc = request_irq(core_dev->irq, crypto4xx_ce_interrupt_handler, 0,
-			 core_dev->dev->name, dev);
-	if (rc)
-		goto err_request_irq;
-
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
 		dev_err(dev, "failed to of_iomap\n");
@@ -1339,6 +1329,13 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		goto err_iomap;
 	}
 
+	/* Register for Crypto isr, Crypto Engine IRQ */
+	core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	rc = request_irq(core_dev->irq, crypto4xx_ce_interrupt_handler, 0,
+			 core_dev->dev->name, dev);
+	if (rc)
+		goto err_request_irq;
+
 	/* need to setup pdr, rdr, gdr and sdr before this */
 	crypto4xx_hw_init(core_dev->dev);
 
@@ -1352,11 +1349,11 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	return 0;
 
 err_start_dev:
-	iounmap(core_dev->dev->ce_base);
-err_iomap:
 	free_irq(core_dev->irq, dev);
 err_request_irq:
 	irq_dispose_mapping(core_dev->irq);
+	iounmap(core_dev->dev->ce_base);
+err_iomap:
 	tasklet_kill(&core_dev->tasklet);
 err_build_sdr:
 	crypto4xx_destroy_sdr(core_dev->dev);
-- 
2.15.1
