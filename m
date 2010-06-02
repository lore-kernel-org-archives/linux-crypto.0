From: y@ozlabs.org
Subject: [PATCH] of/crypto: n2_core.c: Fix build failures
Date: Thu,  3 Jun 2010 01:35:41 +0200
Message-ID: <44197.6351234645$1275521782@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/devicetree-discuss>,
	<mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/devicetree-discuss>
List-Post: <mailto:devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Help: <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/devicetree-discuss>,
	<mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=subscribe>
Sender: devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Errors-To: devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Anatolij Gustschin <agust-ynQEQJNshbs@public.gmane.org>

Fixes build errors caused by the:
- OF device_node pointer being moved into struct device
- removal of the match_table and name fields from
  struct of_platform_driver

Signed-off-by: Anatolij Gustschin <agust-ynQEQJNshbs@public.gmane.org>
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
