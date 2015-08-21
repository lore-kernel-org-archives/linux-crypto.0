From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 3/4] crypto: caam: ctrl: Use the preferred method for devm_kzalloc()
Date: Fri, 21 Aug 2015 11:49:29 -0300
Message-ID: <1440168570-13635-3-git-send-email-festevam@gmail.com>
References: <1440168570-13635-1-git-send-email-festevam@gmail.com>
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:35647 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbHUOuD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 10:50:03 -0400
Received: by ykbi184 with SMTP id i184so72362628ykb.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 07:50:02 -0700 (PDT)
In-Reply-To: <1440168570-13635-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

>From Documentation/CodingStyle:

"The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);"

, so do as suggested.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1153417..aab8b2a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -424,8 +424,7 @@ static int caam_probe(struct platform_device *pdev)
 	int pg_size;
 	int BLOCK_OFFSET = 0;
 
-	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(struct caam_drv_private),
-				GFP_KERNEL);
+	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
 	if (!ctrlpriv)
 		return -ENOMEM;
 
-- 
1.9.1
