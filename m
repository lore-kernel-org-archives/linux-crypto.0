From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 4/4] hwrng: mxc-rnga - Use the preferred format for kzalloc
Date: Sat, 12 Sep 2015 20:19:53 -0300
Message-ID: <1442099993-29449-4-git-send-email-festevam@gmail.com>
References: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:32817 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbbILXU3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Sep 2015 19:20:29 -0400
Received: by ykei199 with SMTP id i199so123312507yke.0
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2015 16:20:28 -0700 (PDT)
In-Reply-To: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

According to Documentation/CodingStyle:

"The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);"

,so do as suggested.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index ed2e3ef..4673622 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -145,8 +145,7 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct mxc_rng *mxc_rng;
 
-	mxc_rng = devm_kzalloc(&pdev->dev, sizeof(struct mxc_rng),
-					GFP_KERNEL);
+	mxc_rng = devm_kzalloc(&pdev->dev, sizeof(*mxc_rng), GFP_KERNEL);
 	if (!mxc_rng)
 		return -ENOMEM;
 
-- 
1.9.1
