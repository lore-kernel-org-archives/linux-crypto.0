From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: mv_cesa: remove NO_IRQ reference
Date: Sat,  3 Sep 2016 01:26:40 +0200
Message-ID: <20160902232648.2119621-1-arnd@arndb.de>
Cc: Romain Perier <romain.perier@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51801 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbcIBX0q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 19:26:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Drivers should not use NO_IRQ, as we are trying to get rid of that.
In this case, the call to irq_of_parse_and_map() is both wrong
(as it returns '0' on failure, not NO_IRQ) and unnecessary
(as platform_get_irq() does the same thing)

This removes the call to irq_of_parse_and_map() and checks for
the error code correctly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/mv_cesa.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

It would be good if someone could test this on a machine that boots
from DT to ensure the conversion was correct.

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index e6b658faef63..104e9ce9400a 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1091,11 +1091,8 @@ static int mv_probe(struct platform_device *pdev)
 
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
 
-	if (pdev->dev.of_node)
-		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	else
-		irq = platform_get_irq(pdev, 0);
-	if (irq < 0 || irq == NO_IRQ) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		ret = irq;
 		goto err;
 	}
-- 
2.9.0
