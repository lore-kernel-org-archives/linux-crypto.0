From: Aaron Sierra <asierra@xes-inc.com>
Subject: [PATCH v2] crypto: talitos: Prevent panic in probe error path
Date: Wed, 5 Aug 2015 16:52:08 -0500 (CDT)
Message-ID: <355366700.773095.1438811528320.JavaMail.zimbra@xes-inc.com>
References: <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:58736 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbbHEVxT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 17:53:19 -0400
In-Reply-To: <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The probe error path for this driver, for all intents and purposes,
is the talitos_remove() function due to the common "goto err_out".

Without this patch applied, talitos_remove() will panic under these
two conditions:

1. If the RNG device hasn't been registered via
   talitos_register_rng() prior to entry into talitos_remove(),
   then the attempt to unregister the RNG "device" will cause a panic.

2. If the priv->chan array has not been allocated prior to entry
   into talitos_remove(), then the per-channel FIFO cleanup will panic
   because of the dereference of that NULL "array".

Both of the above scenarios occur if talitos_probe_irq() fails.

This patch resolves issue #1 by introducing a boolean to mask the
hwrng_unregister() call in talitos_unregister_rng() if RNG device
registration was unsuccessful.

It resolves issue #2 by checking that priv->chan is not NULL in the
per-channel FIFO cleanup for loop.

For completeness, this patch also sets device drvdata to NULL after
the private structure is freed in talitos_remove().

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/crypto/talitos.c | 14 ++++++++++++--
 drivers/crypto/talitos.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 83aca95..74f1a62 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -766,6 +766,7 @@ static int talitos_rng_init(struct hwrng *rng)
 static int talitos_register_rng(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	int err;
 
 	priv->rng.name		= dev_driver_string(dev),
 	priv->rng.init		= talitos_rng_init,
@@ -773,14 +774,22 @@ static int talitos_register_rng(struct device *dev)
 	priv->rng.data_read	= talitos_rng_data_read,
 	priv->rng.priv		= (unsigned long)dev;
 
-	return hwrng_register(&priv->rng);
+	err = hwrng_register(&priv->rng);
+	if (!err)
+		priv->rng_registered = true;
+
+	return err;
 }
 
 static void talitos_unregister_rng(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 
+	if (!priv->rng_registered)
+		return;
+
 	hwrng_unregister(&priv->rng);
+	priv->rng_registered = false;
 }
 
 /*
@@ -2727,7 +2736,7 @@ static int talitos_remove(struct platform_device *ofdev)
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
-	for (i = 0; i < priv->num_channels; i++)
+	for (i = 0; priv->chan && i < priv->num_channels; i++)
 		kfree(priv->chan[i].fifo);
 
 	kfree(priv->chan);
@@ -2745,6 +2754,7 @@ static int talitos_remove(struct platform_device *ofdev)
 	iounmap(priv->reg);
 
 	kfree(priv);
+	dev_set_drvdata(dev, NULL);
 
 	return 0;
 }
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 163cfe7..0090f32 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -149,6 +149,7 @@ struct talitos_private {
 
 	/* hwrng device */
 	struct hwrng rng;
+	bool rng_registered;
 };
 
 extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-- 
1.9.1
