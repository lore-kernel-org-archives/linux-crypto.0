From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] crypto: s5p-sss - Fix completing crypto request in IRQ handler
Date: Sun,  5 Mar 2017 19:14:07 +0200
Message-ID: <20170305171407.839-1-krzk@kernel.org>
Cc: Nathan Royce <nroycea+kernel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752428AbdCEROS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2017 12:14:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In a regular interrupt handler driver was finishing the crypt/decrypt
request by calling complete on crypto request.  This is disallowed since
converting to skcipher in commit b286d8b1a690 ("crypto: skcipher - Add
skcipher walk interface") and causes a warning:
	WARNING: CPU: 0 PID: 0 at crypto/skcipher.c:430 skcipher_walk_first+0x13c/0x14c

The interrupt is marked shared but in fact there are no other users
sharing it.  Thus the simplest solution seems to be to just use a
threaded interrupt handler, after converting it to oneshot.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Tested on Odroid U3 and XU3.
Not sure which commit introduced it so I am also not sure if this should
be cc-stable.
---
 drivers/crypto/s5p-sss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index dce1af0ce85c..a668286d62cb 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -805,8 +805,9 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
-			       IRQF_SHARED, pdev->name, pdev);
+	err = devm_request_threaded_irq(dev, pdata->irq_fc, NULL,
+					s5p_aes_interrupt, IRQF_ONESHOT,
+					pdev->name, pdev);
 	if (err < 0) {
 		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
-- 
2.9.3
