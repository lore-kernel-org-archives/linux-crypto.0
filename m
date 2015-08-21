From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 4/4] crypto: caam: ctrl: Use devm_kcalloc()
Date: Fri, 21 Aug 2015 11:49:30 -0300
Message-ID: <1440168570-13635-4-git-send-email-festevam@gmail.com>
References: <1440168570-13635-1-git-send-email-festevam@gmail.com>
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33416 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbHUOuF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 10:50:05 -0400
Received: by ykll84 with SMTP id l84so72374926ykl.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 07:50:04 -0700 (PDT)
In-Reply-To: <1440168570-13635-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

>From Documentation/CodingStyle:

"The preferred form for allocating a zeroed array is the following:

	p = kcalloc(n, sizeof(...), ...); "

, so do as suggested.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index aab8b2a..c9c5892 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -581,9 +581,8 @@ static int caam_probe(struct platform_device *pdev)
 		    of_device_is_compatible(np, "fsl,sec4.0-job-ring"))
 			rspec++;
 
-	ctrlpriv->jrpdev = devm_kzalloc(&pdev->dev,
-					sizeof(struct platform_device *) * rspec,
-					GFP_KERNEL);
+	ctrlpriv->jrpdev = devm_kcalloc(&pdev->dev, rspec,
+					sizeof(*ctrlpriv->jrpdev), GFP_KERNEL);
 	if (ctrlpriv->jrpdev == NULL) {
 		ret = -ENOMEM;
 		goto iounmap_ctrl;
-- 
1.9.1
