From: "yashpal.dutta@freescale.com" <yashpal.dutta@freescale.com>
Subject: RE: [PATCH] crypto: caam - Check for CAAM block presence before
 registering with crypto layer
Date: Fri, 21 Mar 2014 07:07:33 +0000
Message-ID: <89ccb37664c84d079117807ba54accea@BY2PR03MB458.namprd03.prod.outlook.com>
References: <1395384261-30377-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:40506
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752498AbaCUHHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Mar 2014 03:07:36 -0400
In-Reply-To: <1395384261-30377-1-git-send-email-ruchika.gupta@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Reviewed by: Yashpal Dutta <yashpal.dutta@freescale.com>

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Ruchika Gupta
Sent: Friday, March 21, 2014 12:14 PM
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au
Subject: [PATCH] crypto: caam - Check for CAAM block presence before registering with crypto layer

The layer which registers with the crypto API should check for the presence of
the CAAM device it is going to use.  If the platform's device tree doesn't have
the required CAAM node, the layer should return an error and not register the
algorithms with crypto API layer.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 27 +++++++++++++++++++++++++++
 drivers/crypto/caam/caamhash.c | 26 ++++++++++++++++++++++++++
 drivers/crypto/caam/caamrng.c  | 26 ++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b71f2fd..4335e38 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2164,8 +2164,35 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 
 static int __init caam_algapi_init(void)
 {
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	void *priv;
 	int i = 0, err = 0;
 
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
+
 	INIT_LIST_HEAD(&alg_list);
 
 	/* register crypto algorithms the device supports */
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0378328..5592fec 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1797,8 +1797,34 @@ caam_hash_alloc(struct caam_hash_template *template,
 
 static int __init caam_algapi_hash_init(void)
 {
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	void *priv;
 	int i = 0, err = 0;
 
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
 	INIT_LIST_HEAD(&hash_list);
 
 	/* register crypto algorithms the device supports */
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 403d8d5..7c9803b 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -281,6 +281,32 @@ static void __exit caam_rng_exit(void)
 static int __init caam_rng_init(void)
 {
 	struct device *dev;
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	void *priv;
+
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
 
 	dev = caam_jr_alloc();
 	if (IS_ERR(dev)) {
-- 
1.8.1.4


