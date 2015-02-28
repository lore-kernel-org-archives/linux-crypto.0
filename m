From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: fix typo in dev_err error message
Date: Sat, 28 Feb 2015 20:40:10 +0000
Message-ID: <1425156010-8653-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbB1Ulu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 15:41:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Fix typo, "intialization" -> "initialization"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/atmel-aes.c  | 2 +-
 drivers/crypto/atmel-sha.c  | 2 +-
 drivers/crypto/atmel-tdes.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6597aac..2e875aa 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1374,7 +1374,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	/* Initializing the clock */
 	aes_dd->iclk = clk_get(&pdev->dev, "aes_clk");
 	if (IS_ERR(aes_dd->iclk)) {
-		dev_err(dev, "clock intialization failed.\n");
+		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(aes_dd->iclk);
 		goto clk_err;
 	}
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 34db04a..325d6b6 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1385,7 +1385,7 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	/* Initializing the clock */
 	sha_dd->iclk = clk_get(&pdev->dev, "sha_clk");
 	if (IS_ERR(sha_dd->iclk)) {
-		dev_err(dev, "clock intialization failed.\n");
+		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(sha_dd->iclk);
 		goto clk_err;
 	}
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 258772d..8495b8959 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1408,7 +1408,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	/* Initializing the clock */
 	tdes_dd->iclk = clk_get(&pdev->dev, "tdes_clk");
 	if (IS_ERR(tdes_dd->iclk)) {
-		dev_err(dev, "clock intialization failed.\n");
+		dev_err(dev, "clock initialization failed.\n");
 		err = PTR_ERR(tdes_dd->iclk);
 		goto clk_err;
 	}
-- 
2.1.4
