From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 3/3] crypto: atmel-aes/tdes/sha - remove useless irq init
Date: Mon, 23 Oct 2017 18:34:41 +0300
Message-ID: <20171023153441.28825-3-tudor.ambarus@microchip.com>
References: <20171023153441.28825-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53762 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932102AbdJWPet (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 11:34:49 -0400
In-Reply-To: <20171023153441.28825-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

irq would be set to -1 and then unused, if we failed to get IORESOURCE_MEM.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 2 --
 drivers/crypto/atmel-sha.c  | 2 --
 drivers/crypto/atmel-tdes.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index bc859ab..2048292 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2644,8 +2644,6 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&aes_dd->queue, ATMEL_AES_QUEUE_LENGTH);
 
-	aes_dd->irq = -1;
-
 	/* Get the base address */
 	aes_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!aes_res) {
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 42c1f74..8874aa5 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2777,8 +2777,6 @@ static int atmel_sha_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&sha_dd->queue, ATMEL_SHA_QUEUE_LENGTH);
 
-	sha_dd->irq = -1;
-
 	/* Get the base address */
 	sha_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!sha_res) {
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 48e8653..592124f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1363,8 +1363,6 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&tdes_dd->queue, ATMEL_TDES_QUEUE_LENGTH);
 
-	tdes_dd->irq = -1;
-
 	/* Get the base address */
 	tdes_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!tdes_res) {
-- 
2.9.4
