From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v2 2/3] hw_random: timeriomem_rng: Shorten verbose type and variable names
Date: Wed,  5 Apr 2017 16:20:59 -0700
Message-ID: <20170405232100.2023-3-raltherr@google.com>
References: <20170405232100.2023-1-raltherr@google.com>
Cc: openbmc@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: alex@digriz.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36806 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752304AbdDEXVI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 19:21:08 -0400
Received: by mail-pg0-f43.google.com with SMTP id g2so17988981pge.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2017 16:21:08 -0700 (PDT)
In-Reply-To: <20170405232100.2023-1-raltherr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No functional changes.

Signed-off-by: Rick Altherr <raltherr@google.com>
---

Changes in v2:
- Split type and variable renames into separate patch

 drivers/char/hw_random/timeriomem-rng.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 17574452fd35..024bdff7999f 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -31,7 +31,7 @@
 #include <linux/timeriomem-rng.h>
 #include <linux/timer.h>
 
-struct timeriomem_rng_private_data {
+struct timeriomem_rng_private {
 	void __iomem		*io_base;
 	unsigned int		expires;
 	unsigned int		period;
@@ -40,15 +40,14 @@ struct timeriomem_rng_private_data {
 	struct timer_list	timer;
 	struct completion	completion;
 
-	struct hwrng		timeriomem_rng_ops;
+	struct hwrng		rng_ops;
 };
 
 static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 				size_t max, bool wait)
 {
-	struct timeriomem_rng_private_data *priv =
-		container_of(hwrng, struct timeriomem_rng_private_data,
-				timeriomem_rng_ops);
+	struct timeriomem_rng_private *priv =
+		container_of(hwrng, struct timeriomem_rng_private, rng_ops);
 	unsigned long cur;
 	s32 delay;
 
@@ -89,8 +88,8 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 
 static void timeriomem_rng_trigger(unsigned long data)
 {
-	struct timeriomem_rng_private_data *priv
-			= (struct timeriomem_rng_private_data *)data;
+	struct timeriomem_rng_private *priv
+			= (struct timeriomem_rng_private *)data;
 
 	priv->present = 1;
 	complete(&priv->completion);
@@ -99,7 +98,7 @@ static void timeriomem_rng_trigger(unsigned long data)
 static int timeriomem_rng_probe(struct platform_device *pdev)
 {
 	struct timeriomem_rng_data *pdata = pdev->dev.platform_data;
-	struct timeriomem_rng_private_data *priv;
+	struct timeriomem_rng_private *priv;
 	struct resource *res;
 	int err = 0;
 	int period;
@@ -121,7 +120,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 
 	/* Allocate memory for the device structure (and zero it) */
 	priv = devm_kzalloc(&pdev->dev,
-			sizeof(struct timeriomem_rng_private_data), GFP_KERNEL);
+			sizeof(struct timeriomem_rng_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -155,8 +154,8 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 
 	setup_timer(&priv->timer, timeriomem_rng_trigger, (unsigned long)priv);
 
-	priv->timeriomem_rng_ops.name		= dev_name(&pdev->dev);
-	priv->timeriomem_rng_ops.read		= timeriomem_rng_read;
+	priv->rng_ops.name = dev_name(&pdev->dev);
+	priv->rng_ops.read = timeriomem_rng_read;
 
 	priv->io_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->io_base)) {
@@ -164,7 +163,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		goto out_timer;
 	}
 
-	err = hwrng_register(&priv->timeriomem_rng_ops);
+	err = hwrng_register(&priv->rng_ops);
 	if (err) {
 		dev_err(&pdev->dev, "problem registering\n");
 		goto out_timer;
@@ -182,9 +181,9 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 
 static int timeriomem_rng_remove(struct platform_device *pdev)
 {
-	struct timeriomem_rng_private_data *priv = platform_get_drvdata(pdev);
+	struct timeriomem_rng_private *priv = platform_get_drvdata(pdev);
 
-	hwrng_unregister(&priv->timeriomem_rng_ops);
+	hwrng_unregister(&priv->rng_ops);
 
 	del_timer_sync(&priv->timer);
 
-- 
2.12.2.715.g7642488e1d-goog
