From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 07/20] crypto: caam - remove jr register/deregister
Date: Fri, 22 Jun 2012 19:48:44 -0500
Message-ID: <1340412537-2325-2-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:34587
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756736Ab2FWAuz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:50:55 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yuan Kang <Yuan.Kang@freescale.com>

remove caam_jr_register and caam_jr_deregister
to allow sharing of job rings.

Signed-off-by: Yuan Kang <Yuan.Kang@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 30 ++----------------------------
 drivers/crypto/caam/intern.h  |  2 --
 2 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d0f8df1..a4e266f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2228,7 +2228,7 @@ static int caam_cra_init(struct crypto_tfm *tfm)
 	 * distribute tfms across job rings to ensure in-order
 	 * crypto request processing per tfm
 	 */
-	ctx->jrdev = priv->algapi_jr[(tgt_jr / 2) % priv->num_jrs_for_algapi];
+	ctx->jrdev = priv->jrdev[(tgt_jr / 2) % priv->total_jobrs];
 
 	/* copy descriptor header template value */
 	ctx->class1_alg_type = OP_TYPE_CLASS1_ALG | caam_alg->class1_alg_type;
@@ -2265,7 +2265,6 @@ static void __exit caam_algapi_exit(void)
 	struct device *ctrldev;
 	struct caam_drv_private *priv;
 	struct caam_crypto_alg *t_alg, *n;
-	int i, err;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
 	if (!dev_node) {
@@ -2290,13 +2289,6 @@ static void __exit caam_algapi_exit(void)
 		list_del(&t_alg->entry);
 		kfree(t_alg);
 	}
-
-	for (i = 0; i < priv->total_jobrs; i++) {
-		err = caam_jr_deregister(priv->algapi_jr[i]);
-		if (err < 0)
-			break;
-	}
-	kfree(priv->algapi_jr);
 }
 
 static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
@@ -2349,7 +2341,7 @@ static int __init caam_algapi_init(void)
 {
 	struct device_node *dev_node;
 	struct platform_device *pdev;
-	struct device *ctrldev, **jrdev;
+	struct device *ctrldev;
 	struct caam_drv_private *priv;
 	int i = 0, err = 0;
 
@@ -2370,24 +2362,6 @@ static int __init caam_algapi_init(void)
 
 	INIT_LIST_HEAD(&priv->alg_list);
 
-	jrdev = kmalloc(sizeof(*jrdev) * priv->total_jobrs, GFP_KERNEL);
-	if (!jrdev)
-		return -ENOMEM;
-
-	for (i = 0; i < priv->total_jobrs; i++) {
-		err = caam_jr_register(ctrldev, &jrdev[i]);
-		if (err < 0)
-			break;
-	}
-	if (err < 0 && i == 0) {
-		dev_err(ctrldev, "algapi error in job ring registration: %d\n",
-			err);
-		kfree(jrdev);
-		return err;
-	}
-
-	priv->num_jrs_for_algapi = i;
-	priv->algapi_jr = jrdev;
 	atomic_set(&priv->tfm_count, -1);
 
 	/* register crypto algorithms the device supports */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index a34be01..462be99 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -86,8 +86,6 @@ struct caam_drv_private {
 
 	/* which jr allocated to scatterlist crypto */
 	atomic_t tfm_count ____cacheline_aligned;
-	int num_jrs_for_algapi;
-	struct device **algapi_jr;
 	/* list of registered crypto algorithms (mk generic context handle?) */
 	struct list_head alg_list;
 
-- 
1.7.11.1
