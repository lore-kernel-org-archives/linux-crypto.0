Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5A7C3A59B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 22:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D230F23439
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 22:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfH3Wrm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:47:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbfH3Wrm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 18:47:42 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UMksKf096951
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 18:47:40 -0400
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [192.155.248.74])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uqbx99h25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 18:47:40 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <linux-crypto@vger.kernel.org> from <miltonm@us.ibm.com>;
        Fri, 30 Aug 2019 22:47:40 -0000
Received: from us1a3-smtp03.a3.dal06.isc4sb.com (10.106.154.98)
        by smtp.notes.na.collabserv.com (10.106.227.92) with smtp.notes.na.collabserv.com ESMTP;
        Fri, 30 Aug 2019 22:47:22 -0000
Received: from us1a3-mail228.a3.dal06.isc4sb.com ([10.146.103.71])
          by us1a3-smtp03.a3.dal06.isc4sb.com
          with ESMTP id 2019083022472156-935807 ;
          Fri, 30 Aug 2019 22:47:21 +0000 
In-Reply-To: <20190828162617.237398-3-tmaimon77@gmail.com>
From:   "Milton Miller II" <miltonm@us.ibm.com>
To:     Tomer Maimon <tmaimon77@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au, devicetree@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Date:   Fri, 30 Aug 2019 22:47:21 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20190828162617.237398-3-tmaimon77@gmail.com>,<20190828162617.237398-1-tmaimon77@gmail.com>
X-Mailer: IBM iNotes ($HaikuForm 1054) | IBM Domino Build
 SCN1812108_20180501T0841_FP57 August 05, 2019 at 12:42
X-LLNOutbound: False
X-Disclaimed: 11283
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 19083022-3165-0000-0000-000000D79B79
X-IBM-SpamModules-Scores: BY=0; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.40962; ST=0; TS=0; UL=0; ISC=; MB=0.177132
X-IBM-SpamModules-Versions: BY=3.00011687; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01254435; UDB=6.00662622; IPR=6.01036056;
 MB=3.00028401; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-30 22:47:37
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2019-08-30 17:30:21 - 6.00010349
x-cbparentid: 19083022-3166-0000-0000-00001BF1D68D
Message-Id: <OF311056DF.80F736D6-ON00258466.007A807F-00258466.007D2F93@notes.na.collabserv.com>
Subject: Re:  [PATCH v1 2/2] hwrng: npcm: add NPCM RNG driver
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On August 28th around 11:28AM in some timezone, Tomer Maimon wrote

>Add Nuvoton NPCM BMC Random Number Generator(RNG) driver.
>
>Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
>---
> drivers/char/hw_random/Kconfig    |  13 ++
> drivers/char/hw_random/Makefile   |   1 +
> drivers/char/hw_random/npcm-rng.c | 207
>++++++++++++++++++++++++++++++
> 3 files changed, 221 insertions(+)
> create mode 100644 drivers/char/hw_random/npcm-rng.c
>
>diff --git a/drivers/char/hw_random/Kconfig
>b/drivers/char/hw_random/Kconfig
>index 59f25286befe..87a1c30e7958 100644
>--- a/drivers/char/hw_random/Kconfig
>+++ b/drivers/char/hw_random/Kconfig
>@@ -440,6 +440,19 @@ config HW_RANDOM_OPTEE
> 
> 	  If unsure, say Y.
> 
>+config HW_RANDOM_NPCM
>+	tristate "NPCM Random Number Generator support"
>+	depends on ARCH_NPCM || COMPILE_TEST
>+	default HW_RANDOM
>+	help
>+ 	  This driver provides support for the Random Number
>+	  Generator hardware available in Nuvoton NPCM SoCs.
>+
>+	  To compile this driver as a module, choose M here: the
>+	  module will be called npcm-rng.
>+
>+ 	  If unsure, say Y.
>+
> endif # HW_RANDOM
> 
> config UML_RANDOM
>diff --git a/drivers/char/hw_random/Makefile
>b/drivers/char/hw_random/Makefile
>index 7c9ef4a7667f..17b6d4e6d591 100644
>--- a/drivers/char/hw_random/Makefile
>+++ b/drivers/char/hw_random/Makefile
>@@ -39,3 +39,4 @@ obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
> obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
> obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
> obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
>+obj-$(CONFIG_HW_RANDOM_NPCM) += npcm-rng.o
>diff --git a/drivers/char/hw_random/npcm-rng.c
>b/drivers/char/hw_random/npcm-rng.c
>new file mode 100644
>index 000000000000..5b4b1b6cb362
>--- /dev/null
>+++ b/drivers/char/hw_random/npcm-rng.c
>@@ -0,0 +1,207 @@
>+// SPDX-License-Identifier: GPL-2.0
>+// Copyright (c) 2019 Nuvoton Technology corporation.
>+
>+#include <linux/kernel.h>
>+#include <linux/module.h>
>+#include <linux/io.h>
>+#include <linux/iopoll.h>
>+#include <linux/init.h>
>+#include <linux/random.h>
>+#include <linux/err.h>
>+#include <linux/platform_device.h>
>+#include <linux/hw_random.h>
>+#include <linux/delay.h>
>+#include <linux/of_irq.h>
>+#include <linux/pm_runtime.h>
>+
>+#define NPCM_RNGCS_REG		0x00	/* Control and status register */
>+#define NPCM_RNGD_REG		0x04	/* Data register */
>+#define NPCM_RNGMODE_REG	0x08	/* Mode register */
>+
>+#define NPCM_RNG_CLK_SET_25MHZ	GENMASK(4, 3) /* 20-25 MHz */
>+#define NPCM_RNG_DATA_VALID	BIT(1)
>+#define NPCM_RNG_ENABLE		BIT(0)
>+#define NPCM_RNG_M1ROSEL	BIT(1)
>+
>+#define NPCM_RNG_TIMEOUT_POLL	20
>+
>+#define to_npcm_rng(p)	container_of(p, struct npcm_rng, rng)
>+
>+struct npcm_rng {
>+	void __iomem *base;
>+	struct hwrng rng;
>+};
>+
>+static int npcm_rng_init(struct hwrng *rng)
>+{
>+	struct npcm_rng *priv = to_npcm_rng(rng);
>+	u32 val;
>+
>+	val = readl(priv->base + NPCM_RNGCS_REG);
>+	val |= NPCM_RNG_ENABLE;
>+	writel(val, priv->base + NPCM_RNGCS_REG);
>+
>+	return 0;
>+}
>+
>+static void npcm_rng_cleanup(struct hwrng *rng)
>+{
>+	struct npcm_rng *priv = to_npcm_rng(rng);
>+	u32 val;
>+
>+	val = readl(priv->base + NPCM_RNGCS_REG);
>+	val &= ~NPCM_RNG_ENABLE;
>+	writel(val, priv->base + NPCM_RNGCS_REG);
>+}
>+
>+static bool npcm_rng_wait_ready(struct hwrng *rng, bool wait)
>+{
>+	struct npcm_rng *priv = to_npcm_rng(rng);
>+	int timeout_cnt = 0;
>+	int ready;
>+
>+	ready = readl(priv->base + NPCM_RNGCS_REG) & NPCM_RNG_DATA_VALID;

You should honor the wait paramter here.

>+	while ((ready == 0) && (timeout_cnt < NPCM_RNG_TIMEOUT_POLL)) {
>+		usleep_range(500, 1000);
>+		ready = readl(priv->base + NPCM_RNGCS_REG) &
>+			NPCM_RNG_DATA_VALID;
>+		timeout_cnt++;
>+	}
>+
>+	return !!ready;
>+}
>+
>+static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max,
>bool wait)
>+{
>+	struct npcm_rng *priv = to_npcm_rng(rng);
>+	int retval = 0;
>+
>+	pm_runtime_get_sync((struct device *)priv->rng.priv);
>+
>+	while (max >= sizeof(u32)) {
>+		if (!npcm_rng_wait_ready(rng, wait))
>+			break;
>+
>+		*(u32 *)buf = readl(priv->base + NPCM_RNGD_REG);
>+		retval += sizeof(u32);
>+		buf += sizeof(u32);
>+		max -= sizeof(u32);
>+	}
>+
>+	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
>+	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
>+
>+	return retval || !wait ? retval : -EIO;

So you are doing pm get/put around each rng data sample.

Have you characterized the time to enable to the time to get a sample
and compared to the pm runtime sync parameters?

Do you get any data if you set non-blocking wait above?


>+}
>+
>+static int npcm_rng_probe(struct platform_device *pdev)
>+{
>+	struct npcm_rng *priv;
>+	struct resource *res;
>+	u32 quality;
>+	int ret;
>+
>+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>+	if (!priv)
>+		return -ENOMEM;
>+
>+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>+	priv->base = devm_ioremap_resource(&pdev->dev, res);
>+	if (IS_ERR(priv->base))
>+		return PTR_ERR(priv->base);
>+
>+	priv->rng.name = pdev->name;
>+#ifndef CONFIG_PM
>+	priv->rng.init = npcm_rng_init;
>+	priv->rng.cleanup = npcm_rng_cleanup;

so npcm_rng_init and npcm_rng_cleanup are unused if !CONFIG_PM.  No warnings?

>+#endif
>+	priv->rng.read = npcm_rng_read;
>+	priv->rng.priv = (unsigned long)&pdev->dev;
>+	if (of_property_read_u32(pdev->dev.of_node, "quality", &quality))
>+		priv->rng.quality = 1000;
>+	else
>+		priv->rng.quality = quality;
>+
>+	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
>+#ifndef CONFIG_PM
>+	writel(NPCM_RNG_CLK_SET_25MHZ, priv->base + NPCM_RNGCS_REG);
>+#else
>+	writel(NPCM_RNG_CLK_SET_25MHZ | NPCM_RNG_ENABLE,
>+	       priv->base + NPCM_RNGCS_REG);
>+#endif

I am assuming these are safe to always set and the clock will
bein range?

Did you test without CONFIG_PM ? Looks like the ifndev should be
ifdef otherwise the enable will never be set.

Can you use a local variable for this value that is chosen by
the config instead of ifdef'ing the code?



>+
>+	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
>+	if (ret) {
>+		dev_err(&pdev->dev, "Failed to register rng device: %d\n",
>+			ret);
>+		return ret;
>+	}
>+
>+	dev_set_drvdata(&pdev->dev, priv);
>+	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
>+	pm_runtime_use_autosuspend(&pdev->dev);
>+	pm_runtime_enable(&pdev->dev);
>+
>+	dev_info(&pdev->dev, "Random Number Generator Probed\n");
>+
>+	return 0;
>+}
>+
>+static int npcm_rng_remove(struct platform_device *pdev)
>+{
>+	struct npcm_rng *priv = platform_get_drvdata(pdev);
>+
>+	hwrng_unregister(&priv->rng);
>+	pm_runtime_disable(&pdev->dev);
>+	pm_runtime_set_suspended(&pdev->dev);
>+
>+	return 0;
>+}
>+
>+#ifdef CONFIG_PM
>+static int npcm_rng_runtime_suspend(struct device *dev)
>+{
>+	struct npcm_rng *priv = dev_get_drvdata(dev);
>+
>+	npcm_rng_cleanup(&priv->rng);
>+
>+	return 0;
>+}
>+
>+static int npcm_rng_runtime_resume(struct device *dev)
>+{
>+	struct npcm_rng *priv = dev_get_drvdata(dev);
>+
>+	return npcm_rng_init(&priv->rng);
>+}
>+#endif
>+
>+static const struct dev_pm_ops npcm_rng_pm_ops = {
>+	SET_RUNTIME_PM_OPS(npcm_rng_runtime_suspend,
>+			   npcm_rng_runtime_resume, NULL)
>+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
>+				pm_runtime_force_resume)
>+};
>+
>+static const struct of_device_id rng_dt_id[] = {
>+	{ .compatible = "nuvoton,npcm750-rng",  },
>+	{},
>+};
>+MODULE_DEVICE_TABLE(of, rng_dt_id);
>+
>+static struct platform_driver npcm_rng_driver = {
>+	.driver = {
>+		.name		= "npcm-rng",
>+		.pm		= &npcm_rng_pm_ops,
>+		.owner		= THIS_MODULE,
>+		.of_match_table = of_match_ptr(rng_dt_id),
>+	},
>+	.probe		= npcm_rng_probe,
>+	.remove		= npcm_rng_remove,
>+};
>+
>+module_platform_driver(npcm_rng_driver);
>+
>+MODULE_DESCRIPTION("Nuvoton NPCM Random Number Generator Driver");
>+MODULE_AUTHOR("Tomer Maimon <tomer.maimon@nuvoton.com>");
>+MODULE_LICENSE("GPL v2");
>-- 
>2.18.0
>
>

