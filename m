From: y@vger.kernel.org
Subject: [PATCH] of/crypto: n2_core.c: Fix build failures
Date: Thu,  3 Jun 2010 01:35:41 +0200
Message-ID: <5638.25094509429$1275521774@news.gmane.org>
Cc: devicetree-discuss@lists.ozlabs.org,
	Grant Likely <grant.likely@secretlab.ca>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Anatolij Gustschin <agust@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:34698 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab0FBXgJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Jun 2010 19:36:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anatolij Gustschin <agust@denx.de>

Fixes build errors caused by the:
- OF device_node pointer being moved into struct device
- removal of the match_table and name fields from
  struct of_platform_driver

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/crypto/n2_core.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8566be8..fcf7583 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1398,7 +1398,7 @@ static int find_devino_index(struct of_device *dev, struct spu_mdesc_info *ip,
 
 	intr = ip->ino_table[i].intr;
 
-	dev_intrs = of_get_property(dev->node, "interrupts", NULL);
+	dev_intrs = of_get_property(dev->dev.of_node, "interrupts", NULL);
 	if (!dev_intrs)
 		return -ENODEV;
 
@@ -1574,7 +1574,7 @@ static int spu_mdesc_walk_arcs(struct mdesc_handle *mdesc,
 		id = mdesc_get_property(mdesc, tgt, "id", NULL);
 		if (table[*id] != NULL) {
 			dev_err(&dev->dev, "%s: SPU cpu slot already set.\n",
-				dev->node->full_name);
+				dev->dev.of_node->full_name);
 			return -EINVAL;
 		}
 		cpu_set(*id, p->sharing);
@@ -1595,7 +1595,7 @@ static int handle_exec_unit(struct spu_mdesc_info *ip, struct list_head *list,
 	p = kzalloc(sizeof(struct spu_queue), GFP_KERNEL);
 	if (!p) {
 		dev_err(&dev->dev, "%s: Could not allocate SPU queue.\n",
-			dev->node->full_name);
+			dev->dev.of_node->full_name);
 		return -ENOMEM;
 	}
 
@@ -1684,7 +1684,7 @@ static int __devinit grab_mdesc_irq_props(struct mdesc_handle *mdesc,
 	const unsigned int *reg;
 	u64 node;
 
-	reg = of_get_property(dev->node, "reg", NULL);
+	reg = of_get_property(dev->dev.of_node, "reg", NULL);
 	if (!reg)
 		return -ENODEV;
 
@@ -1836,7 +1836,7 @@ static int __devinit n2_crypto_probe(struct of_device *dev,
 
 	n2_spu_driver_version();
 
-	full_name = dev->node->full_name;
+	full_name = dev->dev.of_node->full_name;
 	pr_info("Found N2CP at %s\n", full_name);
 
 	np = alloc_n2cp();
@@ -1948,7 +1948,7 @@ static int __devinit n2_mau_probe(struct of_device *dev,
 
 	n2_spu_driver_version();
 
-	full_name = dev->node->full_name;
+	full_name = dev->dev.of_node->full_name;
 	pr_info("Found NCP at %s\n", full_name);
 
 	mp = alloc_ncp();
@@ -2034,10 +2034,12 @@ static struct of_device_id n2_crypto_match[] = {
 MODULE_DEVICE_TABLE(of, n2_crypto_match);
 
 static struct of_platform_driver n2_crypto_driver = {
-	.name		=	"n2cp",
-	.match_table	=	n2_crypto_match,
 	.probe		=	n2_crypto_probe,
 	.remove		=	__devexit_p(n2_crypto_remove),
+	.driver = {
+		.name		= "n2cp",
+		.of_match_table	= n2_crypto_match,
+	},
 };
 
 static struct of_device_id n2_mau_match[] = {
@@ -2055,10 +2057,12 @@ static struct of_device_id n2_mau_match[] = {
 MODULE_DEVICE_TABLE(of, n2_mau_match);
 
 static struct of_platform_driver n2_mau_driver = {
-	.name		=	"ncp",
-	.match_table	=	n2_mau_match,
 	.probe		=	n2_mau_probe,
 	.remove		=	__devexit_p(n2_mau_remove),
+	.driver = {
+		.name		= "ncp",
+		.of_match_table	= n2_mau_match,
+	},
 };
 
 static int __init n2_init(void)
-- 
1.7.0.4
