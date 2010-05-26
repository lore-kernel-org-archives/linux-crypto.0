From: David Miller <davem@davemloft.net>
Subject: [PATCH 1/7] n2_crypto: Fix build after
 of_device/of_platform_driver changes.
Date: Tue, 25 May 2010 17:43:30 -0700 (PDT)
Message-ID: <20100525.174330.115936503.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37715
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab0EZAnU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8566be8..1a5b1e7 100644
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
@@ -2034,8 +2034,11 @@ static struct of_device_id n2_crypto_match[] = {
 MODULE_DEVICE_TABLE(of, n2_crypto_match);
 
 static struct of_platform_driver n2_crypto_driver = {
-	.name		=	"n2cp",
-	.match_table	=	n2_crypto_match,
+	.driver = {
+		.name		=	"n2cp",
+		.owner		=	THIS_MODULE,
+		.of_match_table	=	n2_crypto_match,
+	},
 	.probe		=	n2_crypto_probe,
 	.remove		=	__devexit_p(n2_crypto_remove),
 };
@@ -2055,8 +2058,11 @@ static struct of_device_id n2_mau_match[] = {
 MODULE_DEVICE_TABLE(of, n2_mau_match);
 
 static struct of_platform_driver n2_mau_driver = {
-	.name		=	"ncp",
-	.match_table	=	n2_mau_match,
+	.driver = {
+		.name		=	"ncp",
+		.owner		=	THIS_MODULE,
+		.of_match_table	=	n2_mau_match,
+	},
 	.probe		=	n2_mau_probe,
 	.remove		=	__devexit_p(n2_mau_remove),
 };
-- 
1.7.0.4
