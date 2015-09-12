From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 2/4] hwrng: mxc-rnga - Remove uneeded initialization
Date: Sat, 12 Sep 2015 20:19:51 -0300
Message-ID: <1442099993-29449-2-git-send-email-festevam@gmail.com>
References: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:33877 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbbILXU0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Sep 2015 19:20:26 -0400
Received: by ykdg206 with SMTP id g206so123233301ykd.1
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2015 16:20:25 -0700 (PDT)
In-Reply-To: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to pre-initialize variable 'err' as this
initial value will be overwritten later on.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 8803126..c7380b8 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -141,7 +141,7 @@ static void mxc_rnga_cleanup(struct hwrng *rng)
 
 static int __init mxc_rnga_probe(struct platform_device *pdev)
 {
-	int err = -ENODEV;
+	int err;
 	struct resource *res;
 	struct mxc_rng *mxc_rng;
 
-- 
1.9.1
