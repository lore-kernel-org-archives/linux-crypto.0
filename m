From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH][v2] crypto: caam - Check for CAAM block presence before registering with crypto layer
Date: Mon, 7 Jul 2014 10:39:44 +0530
Message-ID: <1404709784-19167-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
	<kim.phillips@freescale.com>, <dan.carpenter@oracle.com>,
	<horia.geanta@freescale.com>, <marex@denx.de>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:23971
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750714AbaGGFKP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2014 01:10:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The layer which registers with the crypto API should check for the presence of
the CAAM device it is going to use.  If the platform's device tree doesn't have
the required CAAM node, the layer should return an error and not register the
algorithms with crypto API layer.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 29 +++++++++++++++++++++++++++++
 drivers/crypto/caam/caamhash.c | 28 ++++++++++++++++++++++++++++
 drivers/crypto/caam/caamrng.c  | 28 ++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

Changes from v1
Removed the memory leak of dev_node in case of error

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 87d9de4..64c606d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2441,8 +2441,37 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 
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
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
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
index 2ab057b..7754df4 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1793,8 +1793,36 @@ caam_hash_alloc(struct caam_hash_template *template,
 
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
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
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
index 8c07d31..a4afa8a 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -278,6 +278,34 @@ static void __exit caam_rng_exit(void)
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
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
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
