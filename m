From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 25/39] usb: musb: ux500: add device tree probing support
Date: Wed, 15 May 2013 10:51:48 +0100
Message-ID: <1368611522-9984-26-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org, srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org,
 devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>,
 Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 balbi-l0cyMroinI0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/devicetree-discuss>,
 <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/devicetree-discuss/>
List-Post: <mailto:devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Help: <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/devicetree-discuss>,
 <mailto:devicetree-discuss-request-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org?subject=subscribe>
Errors-To: devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Sender: "devicetree-discuss"
 <devicetree-discuss-bounces+gldd-devicetree-discuss=m.gmane.org-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

This patch will allow ux500-musb to be probed and configured solely from
configuration found in Device Tree.

Cc: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Cc: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devicetree-discuss-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Acked-by: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Fabio Baltieri <fabio.baltieri-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../devicetree/bindings/usb/ux500-usb.txt          |   50 +++++++++++++++++++
 drivers/usb/musb/ux500.c                           |   51 ++++++++++++++++++++
 2 files changed, 101 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ux500-usb.txt

diff --git a/Documentation/devicetree/bindings/usb/ux500-usb.txt b/Documentation/devicetree/bindings/usb/ux500-usb.txt
new file mode 100644
index 0000000..330d6ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ux500-usb.txt
@@ -0,0 +1,50 @@
+Ux500 MUSB
+
+Required properties:
+ - compatible : Should be "stericsson,db8500-musb"
+ - reg        : Offset and length of registers
+ - interrupts : Interrupt; mode, number and trigger
+ - dr_mode    : Dual-role; either host mode "host", peripheral mode "peripheral"
+                or both "otg"
+
+Optional properties:
+ - dmas       : A list of dma channels;
+                dma-controller, event-line, fixed-channel, flags
+ - dma-names  : An ordered list of channel names affiliated to the above
+
+Example:
+
+usb_per5@a03e0000 {
+	compatible = "stericsson,db8500-musb", "mentor,musb";
+	reg = <0xa03e0000 0x10000>;
+	interrupts = <0 23 0x4>;
+	interrupt-names = "mc";
+
+	dr_mode = "otg";
+
+	dmas = <&dma 38 0 0x2>, /* Logical - DevToMem */
+	       <&dma 38 0 0x0>, /* Logical - MemToDev */
+	       <&dma 37 0 0x2>, /* Logical - DevToMem */
+	       <&dma 37 0 0x0>, /* Logical - MemToDev */
+	       <&dma 36 0 0x2>, /* Logical - DevToMem */
+	       <&dma 36 0 0x0>, /* Logical - MemToDev */
+	       <&dma 19 0 0x2>, /* Logical - DevToMem */
+	       <&dma 19 0 0x0>, /* Logical - MemToDev */
+	       <&dma 18 0 0x2>, /* Logical - DevToMem */
+	       <&dma 18 0 0x0>, /* Logical - MemToDev */
+	       <&dma 17 0 0x2>, /* Logical - DevToMem */
+	       <&dma 17 0 0x0>, /* Logical - MemToDev */
+	       <&dma 16 0 0x2>, /* Logical - DevToMem */
+	       <&dma 16 0 0x0>, /* Logical - MemToDev */
+	       <&dma 39 0 0x2>, /* Logical - DevToMem */
+	       <&dma 39 0 0x0>; /* Logical - MemToDev */
+
+	dma-names = "iep_1_9",  "oep_1_9",
+		    "iep_2_10", "oep_2_10",
+		    "iep_3_11", "oep_3_11",
+		    "iep_4_12", "oep_4_12",
+		    "iep_5_13", "oep_5_13",
+		    "iep_6_14", "oep_6_14",
+		    "iep_7_15", "oep_7_15",
+		    "iep_8",    "oep_8";
+};
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 3cf10bc..f0beee7 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/usb/musb-ux500.h>
 
@@ -194,14 +195,57 @@ static const struct musb_platform_ops ux500_ops = {
 	.set_vbus	= ux500_musb_set_vbus,
 };
 
+static struct musb_hdrc_platform_data *
+ux500_of_probe(struct platform_device *pdev, struct device_node *np)
+{
+	struct musb_hdrc_platform_data *pdata;
+	const char *mode;
+	int strlen;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	mode = of_get_property(np, "dr_mode", &strlen);
+	if (!mode) {
+		dev_err(&pdev->dev, "No 'dr_mode' property found\n");
+		return NULL;
+	}
+
+	if (strlen > 0) {
+		if (!strcmp(mode, "host"))
+			pdata->mode = MUSB_HOST;
+		if (!strcmp(mode, "otg"))
+			pdata->mode = MUSB_OTG;
+		if (!strcmp(mode, "peripheral"))
+			pdata->mode = MUSB_PERIPHERAL;
+	}
+
+	return pdata;
+}
+
 static int ux500_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
+	struct device_node		*np = pdev->dev.of_node;
 	struct platform_device		*musb;
 	struct ux500_glue		*glue;
 	struct clk			*clk;
 	int				ret = -ENOMEM;
 
+	if (!pdata) {
+		if (np) {
+			pdata = ux500_of_probe(pdev, np);
+			if (!pdata)
+				goto err0;
+
+			pdev->dev.platform_data = pdata;
+		} else {
+			dev_err(&pdev->dev, "no pdata or device tree found\n");
+			goto err0;
+		}
+	}
+
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
@@ -230,6 +274,7 @@ static int ux500_probe(struct platform_device *pdev)
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &pdev->dev.coherent_dma_mask;
 	musb->dev.coherent_dma_mask	= pdev->dev.coherent_dma_mask;
+	musb->dev.of_node		= pdev->dev.of_node;
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
@@ -328,12 +373,18 @@ static const struct dev_pm_ops ux500_pm_ops = {
 #define DEV_PM_OPS	NULL
 #endif
 
+static const struct of_device_id ux500_match[] = {
+        { .compatible = "stericsson,db8500-musb", },
+        {}
+};
+
 static struct platform_driver ux500_driver = {
 	.probe		= ux500_probe,
 	.remove		= ux500_remove,
 	.driver		= {
 		.name	= "musb-ux500",
 		.pm	= DEV_PM_OPS,
+		.of_match_table = ux500_match,
 	},
 };
 
-- 
1.7.10.4
