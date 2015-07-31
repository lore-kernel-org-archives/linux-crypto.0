From: Aaron Sierra <asierra@xes-inc.com>
Subject: [PATCH] crypto: talitos: Prevent panic in probe error path
Date: Fri, 31 Jul 2015 15:52:18 -0500 (CDT)
Message-ID: <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:38653 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945947AbbGaUx0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 16:53:26 -0400
In-Reply-To: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RNG unregistration and per-channel FIFO cleanup can cause a kernel
panic, depending on how early in talitos_probe() an error occurs.
This patch prevents these panics from happening.

For completeness, this patch also sets device drvdata to NULL after
the private structure is freed in talitos_remove().

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/crypto/talitos.c | 33 +++++++++++++++++++++++----------
 drivers/crypto/talitos.h |  2 +-
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 83aca95..684fe89 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -766,21 +766,33 @@ static int talitos_rng_init(struct hwrng *rng)
 static int talitos_register_rng(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	int err = 0;
 
-	priv->rng.name		= dev_driver_string(dev),
-	priv->rng.init		= talitos_rng_init,
-	priv->rng.data_present	= talitos_rng_data_present,
-	priv->rng.data_read	= talitos_rng_data_read,
-	priv->rng.priv		= (unsigned long)dev;
+	priv->rng = kzalloc(sizeof(struct hwrng), GFP_KERNEL);
+	if (!priv->rng)
+		return -ENOMEM;
+
+	priv->rng->name		= dev_driver_string(dev),
+	priv->rng->init		= talitos_rng_init,
+	priv->rng->data_present	= talitos_rng_data_present,
+	priv->rng->data_read	= talitos_rng_data_read,
+	priv->rng->priv		= (unsigned long)dev;
+
+	err = hwrng_register(priv->rng);
+	if (err) {
+		kfree(priv->rng);
+		priv->rng = NULL;
+	}
 
-	return hwrng_register(&priv->rng);
+	return err;
 }
 
 static void talitos_unregister_rng(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 
-	hwrng_unregister(&priv->rng);
+	if (priv->rng)
+		hwrng_unregister(priv->rng);
 }
 
 /*
@@ -2727,7 +2739,7 @@ static int talitos_remove(struct platform_device *ofdev)
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
-	for (i = 0; i < priv->num_channels; i++)
+	for (i = 0; priv->chan && i < priv->num_channels; i++)
 		kfree(priv->chan[i].fifo);
 
 	kfree(priv->chan);
@@ -2746,6 +2758,8 @@ static int talitos_remove(struct platform_device *ofdev)
 
 	kfree(priv);
 
+	dev_set_drvdata(dev, NULL);
+
 	return 0;
 }
 
@@ -2905,8 +2919,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	priv->reg = of_iomap(np, 0);
 	if (!priv->reg) {
 		dev_err(dev, "failed to of_iomap\n");
-		err = -ENOMEM;
-		goto err_out;
+		return -ENOMEM;
 	}
 
 	/* get SEC version capabilities from device tree */
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index bf88fe7..e86f67c 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -148,7 +148,7 @@ struct talitos_private {
 	struct list_head alg_list;
 
 	/* hwrng device */
-	struct hwrng rng;
+	struct hwrng *rng;
 };
 
 extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-- 
1.9.1
