From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] crypto: bfin_crc: Simplify use of devm_ioremap_resource
Date: Mon, 4 Jul 2016 18:30:21 +0530
Message-ID: <20160704130021.GA16839@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: julia.lawall@lip6.fr
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:32911 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbcGDNA0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 09:00:26 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to
devm_ioremap_resource.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/crypto/bfin_crc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 95b7396..10db7df 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -588,11 +588,6 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	crypto_init_queue(&crc->queue, CRC_CCRYPTO_QUEUE_LENGTH);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
-		return -ENOENT;
-	}
-
 	crc->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR((void *)crc->regs)) {
 		dev_err(&pdev->dev, "Cannot map CRC IO\n");
-- 
1.9.1
