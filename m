From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 3/4] hwrng: mxc-rnga - Remove unnecessary dev_info message
Date: Sat, 12 Sep 2015 20:19:52 -0300
Message-ID: <1442099993-29449-3-git-send-email-festevam@gmail.com>
References: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35429 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbbILXU1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Sep 2015 19:20:27 -0400
Received: by ykdu9 with SMTP id u9so124138790ykd.2
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2015 16:20:27 -0700 (PDT)
In-Reply-To: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to print a message simply saying that a kernel
driver has been registered, so remove it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index c7380b8..ed2e3ef 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -180,8 +180,6 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	dev_info(&pdev->dev, "MXC RNGA Registered.\n");
-
 	return 0;
 
 err_ioremap:
-- 
1.9.1
