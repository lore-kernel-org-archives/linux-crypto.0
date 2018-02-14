From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto: bfin_crc: Delete an error message for a failed memory
 allocation in bfin_crypto_crc_probe()
Date: Wed, 14 Feb 2018 21:42:26 +0100
Message-ID: <1601995f-79fd-8365-5dd3-4438a3515c28@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:33135 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932096AbeBNUmh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 15:42:37 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 21:34:54 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/bfin_crc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index a118b9bed669..7a1d6ed6d0b7 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -575,10 +575,8 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	int ret;
 
 	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
-	if (!crc) {
-		dev_err(&pdev->dev, "fail to malloc bfin_crypto_crc\n");
+	if (!crc)
 		return -ENOMEM;
-	}
 
 	crc->dev = dev;
 
-- 
2.16.1
