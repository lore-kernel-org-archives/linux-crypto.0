From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] hwrng: amd - Fix return value check in mod_init()
Date: Fri, 16 Sep 2016 01:49:41 +0000
Message-ID: <1473990581-18602-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33828 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754527AbcIPBtr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 21:49:47 -0400
Received: by mail-pf0-f196.google.com with SMTP id 21so1485833pfy.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2016 18:49:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

In case of error, the function devm_kzalloc() or devm_ioport_map()
return NULL pointer not ERR_PTR(). The IS_ERR() test in the return
value check should be replaced with NULL test.

Fixes: 31b2a73c9c5f ("hwrng: amd - Migrate to managed API")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/amd-rng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 4dbc5aa..4a99ac7 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -149,8 +149,8 @@ static int __init mod_init(void)
 		return -EIO;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (IS_ERR(priv))
-		return PTR_ERR(priv);
+	if (!priv)
+		return -ENOMEM;
 
 	if (!devm_request_region(&pdev->dev, pmbase + PMBASE_OFFSET,
 				PMBASE_SIZE, DRV_NAME)) {
@@ -161,9 +161,9 @@ static int __init mod_init(void)
 
 	priv->iobase = devm_ioport_map(&pdev->dev, pmbase + PMBASE_OFFSET,
 			PMBASE_SIZE);
-	if (IS_ERR(priv->iobase)) {
+	if (!priv->iobase) {
 		pr_err(DRV_NAME "Cannot map ioport\n");
-		return PTR_ERR(priv->iobase);
+		return -ENOMEM;
 	}
 
 	amd_rng.priv = (unsigned long)priv;
