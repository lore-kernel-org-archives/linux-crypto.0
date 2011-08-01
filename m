From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH 2/3] crypto: picoxcell - add connection ID to the clock name
Date: Mon,  1 Aug 2011 17:25:18 +0100
Message-ID: <1312215919-24419-2-git-send-email-jamie@jamieiles.com>
References: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60119 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1HAQZ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Aug 2011 12:25:28 -0400
Received: by wyg8 with SMTP id 8so1713415wyg.19
        for <linux-crypto@vger.kernel.org>; Mon, 01 Aug 2011 09:25:27 -0700 (PDT)
In-Reply-To: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For using the device tree probing we use a connection ID for the
clk_get() operation.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/picoxcell_crypto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 4ffb903..d119e0e 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1724,7 +1724,7 @@ static int __devinit spacc_probe(struct platform_device *pdev)
 
 	spin_lock_init(&engine->hw_lock);
 
-	engine->clk = clk_get(&pdev->dev, NULL);
+	engine->clk = clk_get(&pdev->dev, "ref");
 	if (IS_ERR(engine->clk)) {
 		dev_info(&pdev->dev, "clk unavailable\n");
 		device_remove_file(&pdev->dev, &dev_attr_stat_irq_thresh);
-- 
1.7.4.1
