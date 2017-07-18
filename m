From: Rob Herring <robh@kernel.org>
Subject: [PATCH] crypto: n2_core: Convert to using %pOF instead of full_name
Date: Tue, 18 Jul 2017 16:42:56 -0500
Message-ID: <20170718214339.7774-16-robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that we have a custom printf format specifier, convert users of
full_name to use %pOF instead. This is preparation to remove storing
of the full path string for each node.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/n2_core.c | 60 ++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 269451375b63..a9fd8b9e86cd 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1730,8 +1730,8 @@ static int spu_mdesc_walk_arcs(struct mdesc_handle *mdesc,
 			continue;
 		id = mdesc_get_property(mdesc, tgt, "id", NULL);
 		if (table[*id] != NULL) {
-			dev_err(&dev->dev, "%s: SPU cpu slot already set.\n",
-				dev->dev.of_node->full_name);
+			dev_err(&dev->dev, "%pOF: SPU cpu slot already set.\n",
+				dev->dev.of_node);
 			return -EINVAL;
 		}
 		cpumask_set_cpu(*id, &p->sharing);
@@ -1751,8 +1751,8 @@ static int handle_exec_unit(struct spu_mdesc_info *ip, struct list_head *list,

 	p = kzalloc(sizeof(struct spu_queue), GFP_KERNEL);
 	if (!p) {
-		dev_err(&dev->dev, "%s: Could not allocate SPU queue.\n",
-			dev->dev.of_node->full_name);
+		dev_err(&dev->dev, "%pOF: Could not allocate SPU queue.\n",
+			dev->dev.of_node);
 		return -ENOMEM;
 	}

@@ -1981,41 +1981,39 @@ static void n2_spu_driver_version(void)
 static int n2_crypto_probe(struct platform_device *dev)
 {
 	struct mdesc_handle *mdesc;
-	const char *full_name;
 	struct n2_crypto *np;
 	int err;

 	n2_spu_driver_version();

-	full_name = dev->dev.of_node->full_name;
-	pr_info("Found N2CP at %s\n", full_name);
+	pr_info("Found N2CP at %pOF\n", dev->dev.of_node);

 	np = alloc_n2cp();
 	if (!np) {
-		dev_err(&dev->dev, "%s: Unable to allocate n2cp.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to allocate n2cp.\n",
+			dev->dev.of_node);
 		return -ENOMEM;
 	}

 	err = grab_global_resources();
 	if (err) {
-		dev_err(&dev->dev, "%s: Unable to grab "
-			"global resources.\n", full_name);
+		dev_err(&dev->dev, "%pOF: Unable to grab global resources.\n",
+			dev->dev.of_node);
 		goto out_free_n2cp;
 	}

 	mdesc = mdesc_grab();

 	if (!mdesc) {
-		dev_err(&dev->dev, "%s: Unable to grab MDESC.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to grab MDESC.\n",
+			dev->dev.of_node);
 		err = -ENODEV;
 		goto out_free_global;
 	}
 	err = grab_mdesc_irq_props(mdesc, dev, &np->cwq_info, "n2cp");
 	if (err) {
-		dev_err(&dev->dev, "%s: Unable to grab IRQ props.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to grab IRQ props.\n",
+			dev->dev.of_node);
 		mdesc_release(mdesc);
 		goto out_free_global;
 	}
@@ -2026,15 +2024,15 @@ static int n2_crypto_probe(struct platform_device *dev)
 	mdesc_release(mdesc);

 	if (err) {
-		dev_err(&dev->dev, "%s: CWQ MDESC scan failed.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: CWQ MDESC scan failed.\n",
+			dev->dev.of_node);
 		goto out_free_global;
 	}

 	err = n2_register_algs();
 	if (err) {
-		dev_err(&dev->dev, "%s: Unable to register algorithms.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to register algorithms.\n",
+			dev->dev.of_node);
 		goto out_free_spu_list;
 	}

@@ -2092,42 +2090,40 @@ static void free_ncp(struct n2_mau *mp)
 static int n2_mau_probe(struct platform_device *dev)
 {
 	struct mdesc_handle *mdesc;
-	const char *full_name;
 	struct n2_mau *mp;
 	int err;

 	n2_spu_driver_version();

-	full_name = dev->dev.of_node->full_name;
-	pr_info("Found NCP at %s\n", full_name);
+	pr_info("Found NCP at %pOF\n", dev->dev.of_node);

 	mp = alloc_ncp();
 	if (!mp) {
-		dev_err(&dev->dev, "%s: Unable to allocate ncp.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to allocate ncp.\n",
+			dev->dev.of_node);
 		return -ENOMEM;
 	}

 	err = grab_global_resources();
 	if (err) {
-		dev_err(&dev->dev, "%s: Unable to grab "
-			"global resources.\n", full_name);
+		dev_err(&dev->dev, "%pOF: Unable to grab global resources.\n",
+			dev->dev.of_node);
 		goto out_free_ncp;
 	}

 	mdesc = mdesc_grab();

 	if (!mdesc) {
-		dev_err(&dev->dev, "%s: Unable to grab MDESC.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to grab MDESC.\n",
+			dev->dev.of_node);
 		err = -ENODEV;
 		goto out_free_global;
 	}

 	err = grab_mdesc_irq_props(mdesc, dev, &mp->mau_info, "ncp");
 	if (err) {
-		dev_err(&dev->dev, "%s: Unable to grab IRQ props.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: Unable to grab IRQ props.\n",
+			dev->dev.of_node);
 		mdesc_release(mdesc);
 		goto out_free_global;
 	}
@@ -2138,8 +2134,8 @@ static int n2_mau_probe(struct platform_device *dev)
 	mdesc_release(mdesc);

 	if (err) {
-		dev_err(&dev->dev, "%s: MAU MDESC scan failed.\n",
-			full_name);
+		dev_err(&dev->dev, "%pOF: MAU MDESC scan failed.\n",
+			dev->dev.of_node);
 		goto out_free_global;
 	}

--
2.11.0
