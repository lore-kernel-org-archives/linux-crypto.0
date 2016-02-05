From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/2] crypto: atmel-sha: fix atmel_sha_remove()
Date: Fri, 5 Feb 2016 13:45:12 +0100
Message-ID: <0ded195da1a7c7e84f959eff0cdd65ddc39c8d51.1454675769.git.cyrille.pitchen@atmel.com>
References: <cover.1454675769.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45864 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbcBEMpG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Feb 2016 07:45:06 -0500
In-Reply-To: <cover.1454675769.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since atmel_sha_probe() uses devm_xxx functions to allocate resources,
atmel_sha_remove() should no longer explicitly release them.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Fixes: b0e8b3417a62 ("crypto: atmel - use devm_xxx() managed function")
---
 drivers/crypto/atmel-sha.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 63b09e01075c..b827c99b17c1 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1611,13 +1611,6 @@ static int atmel_sha_remove(struct platform_device *pdev)
 	if (sha_dd->caps.has_dma)
 		atmel_sha_dma_cleanup(sha_dd);
 
-	iounmap(sha_dd->io_base);
-
-	clk_put(sha_dd->iclk);
-
-	if (sha_dd->irq >= 0)
-		free_irq(sha_dd->irq, sha_dd);
-
 	return 0;
 }
 
-- 
1.8.2.2
