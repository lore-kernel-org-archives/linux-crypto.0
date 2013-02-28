From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH v2 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
Date: Thu, 28 Feb 2013 12:07:48 +0100
Message-ID: <87vc9chf23.fsf@lebrac.rtp-net.org>
References: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
	<1361961711-4603-3-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-crypto@vger.kernel.org, swarren@nvidia.com,
	herbert@gondor.apana.org.au, arnd@arndb.de,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	kernel@pengutronix.de, shawn.guo@linaro.org, davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org, gcembed@gmail.com
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lebrac.rtp-net.org ([88.191.135.105]:44668 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3B1LKA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Feb 2013 06:10:00 -0500
In-Reply-To: <1361961711-4603-3-git-send-email-javier.martin@vista-silicon.com>
	(Javier Martin's message of "Wed, 27 Feb 2013 11:41:50 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=

Javier Martin <javier.martin@vista-silicon.com> writes:

Hi,

> SAHARA2 HW module is included in the i.MX27 SoC from
> Freescale. It is capable of performing cipher algorithms
> such as AES, 3DES..., hashing and RNG too.

The rmmod oops is gone with this version, thanks.

>
> This driver provides support for AES-CBC and AES-ECB
> by now.
>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/crypto/Kconfig  |   10 +
>  drivers/crypto/Makefile |    1 +
>  drivers/crypto/sahara.c | 1070 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1081 insertions(+)
>  create mode 100644 drivers/crypto/sahara.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 87ec4d0..7d73f5a 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -276,6 +276,16 @@ config CRYPTO_DEV_PICOXCELL
>  
>  	  Saying m here will build a module named pipcoxcell_crypto.
>  
> +config CRYPTO_DEV_SAHARA
> +	tristate "Support for SAHARA crypto accelerator"
> +	depends on MACH_MX27 && EXPERIMENTAL && OF

maybe switch to ARCH_MXC instead of MAC_MX27 ?

[...]

> +static struct platform_driver sahara_driver = {
> +	.probe		= sahara_probe,
> +	.remove		= __devexit_p(sahara_remove),

Please remove the __devexit_p too.


For information, you'll find below what I've changed to test the driver on my
imx51. It's not perfect but it's enough for testing things.


Arnaud

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=imx51-sahara.patch

Index: sascha-new/Documentation/devicetree/bindings/clock/imx5-clock.txt
===================================================================
--- sascha-new.orig/Documentation/devicetree/bindings/clock/imx5-clock.txt	2013-02-27 22:30:39.000000000 +0100
+++ sascha-new/Documentation/devicetree/bindings/clock/imx5-clock.txt	2013-02-27 22:36:07.007547186 +0100
@@ -173,6 +173,7 @@ clocks and IDs.
 	can1_ipg_gate		158
 	srtc_gate		159
 	pata_gate		160
+	sahara_gate		161
 
 Examples (for mx53):
 
Index: sascha-new/arch/arm/boot/dts/imx51-genesi-efika-sb.dts
===================================================================
--- sascha-new.orig/arch/arm/boot/dts/imx51-genesi-efika-sb.dts	2013-02-27 22:30:39.000000000 +0100
+++ sascha-new/arch/arm/boot/dts/imx51-genesi-efika-sb.dts	2013-02-27 22:36:07.043547182 +0100
@@ -399,3 +399,6 @@
 	status = "okay";
 };
 
+&sahara {
+	status = "okay";
+};
Index: sascha-new/arch/arm/boot/dts/imx51.dtsi
===================================================================
--- sascha-new.orig/arch/arm/boot/dts/imx51.dtsi	2013-02-27 22:30:39.000000000 +0100
+++ sascha-new/arch/arm/boot/dts/imx51.dtsi	2013-02-27 22:36:07.071547182 +0100
@@ -678,6 +678,15 @@
 				clock-names = "per", "ahb";
 				status = "disabled";
 			};
+
+			sahara: sahara@83ff8000 {
+				compatible = "fsl,imx51-sahara";
+				reg = <0x83ff8000 0x4000>;
+				interrupts = <19>;
+				clocks = <&clks 161>, <&clks 0>;
+				clock-names = "ipg", "ahb";
+				status = "disabled";
+			};
 		};
 	};
 };
Index: sascha-new/arch/arm/mach-imx/clk-imx51-imx53.c
===================================================================
--- sascha-new.orig/arch/arm/mach-imx/clk-imx51-imx53.c	2013-02-27 22:30:39.000000000 +0100
+++ sascha-new/arch/arm/mach-imx/clk-imx51-imx53.c	2013-02-27 22:36:07.015547183 +0100
@@ -83,6 +83,7 @@ enum imx5_clks {
 	ssi2_root_gate, ssi3_root_gate, ssi_ext1_gate, ssi_ext2_gate,
 	epit1_ipg_gate, epit1_hf_gate, epit2_ipg_gate, epit2_hf_gate,
 	can_sel, can1_serial_gate, can1_ipg_gate, srtc_gate, pata_gate,
+	sahara_gate,
 	clk_max
 };
 
@@ -346,6 +347,7 @@ int __init mx51_clocks_init(unsigned lon
 	clk[mipi_esc_gate] = imx_clk_gate2("mipi_esc_gate", "ipg", MXC_CCM_CCGR4, 10);
 	clk[mipi_hsp_gate] = imx_clk_gate2("mipi_hsp_gate", "ipg", MXC_CCM_CCGR4, 12);
 	clk[pata_gate] = imx_clk_gate2("pata_gate", "ipg", MXC_CCM_CCGR4, 0);
+	clk[sahara_gate] = imx_clk_gate2("sahara_gate", "ipg", MXC_CCM_CCGR4, 14);
 
 	for (i = 0; i < ARRAY_SIZE(clk); i++)
 		if (IS_ERR(clk[i]))
Index: sascha-new/drivers/crypto/Kconfig
===================================================================
--- sascha-new.orig/drivers/crypto/Kconfig	2013-02-27 22:30:59.000000000 +0100
+++ sascha-new/drivers/crypto/Kconfig	2013-02-27 22:36:07.079547182 +0100
@@ -278,7 +278,7 @@ config CRYPTO_DEV_PICOXCELL
 
 config CRYPTO_DEV_SAHARA
 	tristate "Support for SAHARA crypto accelerator"
-	depends on MACH_MX27 && EXPERIMENTAL && OF
+	depends on ARCH_MXC && EXPERIMENTAL && OF
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_ECB
Index: sascha-new/drivers/crypto/sahara.c
===================================================================
--- sascha-new.orig/drivers/crypto/sahara.c	2013-02-27 22:30:59.000000000 +0100
+++ sascha-new/drivers/crypto/sahara.c	2013-02-27 22:45:40.359521961 +0100
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #define SAHARA_NAME "sahara"
@@ -859,14 +860,30 @@ static struct platform_device_id sahara_
 };
 MODULE_DEVICE_TABLE(platform, sahara_platform_ids);
 
+struct sahara_data {
+	int version;
+};
+
+static struct sahara_data sahara_data_v3 = {
+	.version = 3,
+};
+
+static struct sahara_data sahara_data_v4 = {
+	.version = 4,
+};
+
 static struct of_device_id sahara_dt_ids[] = {
-	{ .compatible = "fsl,imx27-sahara" },
+	{ .compatible = "fsl,imx51-sahara", .data = &sahara_data_v4, },
+	{ .compatible = "fsl,imx27-sahara", .data = &sahara_data_v3, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(platform, sahara_dt_ids);
 
 static int sahara_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id =
+		of_match_device(sahara_dt_ids, &pdev->dev);
+	const struct sahara_data *data;
 	struct sahara_dev *dev;
 	struct resource *res;
 	u32 version;
@@ -982,10 +999,13 @@ static int sahara_probe(struct platform_
 	clk_prepare_enable(dev->clk_ipg);
 	clk_prepare_enable(dev->clk_ahb);
 
+	data = of_id->data;
+
 	version = sahara_read(dev, SAHARA_REG_VERSION);
-	if (version != SAHARA_VERSION_3) {
-		dev_err(&pdev->dev, "SAHARA version %d not supported\n",
-			version);
+	/* sahara 4 version nr is not encoded in the same way as 2/3 */
+	if ((version != data->version) && (((version >> 8) & 0xff) != data->version)) {
+		dev_err(&pdev->dev, "SAHARA version %d not supported (wanted %d)\n",
+			version, data->version);
 		err = -ENODEV;
 		goto err_algs;
 	}
@@ -1002,7 +1022,7 @@ static int sahara_probe(struct platform_
 	if (err)
 		goto err_algs;
 
-	dev_info(&pdev->dev, "SAHARA version %d initialized\n", version);
+	dev_info(&pdev->dev, "SAHARA version %d initialized\n", data->version);
 
 	return 0;
 
@@ -1054,7 +1074,7 @@ static int sahara_remove(struct platform
 
 static struct platform_driver sahara_driver = {
 	.probe		= sahara_probe,
-	.remove		= __devexit_p(sahara_remove),
+	.remove		= sahara_remove,
 	.driver		= {
 		.name	= SAHARA_NAME,
 		.owner	= THIS_MODULE,

--=-=-=--
