Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11755C5AE59
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 20:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD5F21924
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 20:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfIJUxj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 16:53:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbfIJUxi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 16:53:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8AKqxCX048465
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 16:53:37 -0400
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [192.155.248.81])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uxgemw9k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 16:53:37 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <linux-crypto@vger.kernel.org> from <miltonm@us.ibm.com>;
        Tue, 10 Sep 2019 20:53:36 -0000
Received: from us1a3-smtp08.a3.dal06.isc4sb.com (10.146.103.57)
        by smtp.notes.na.collabserv.com (10.106.227.88) with smtp.notes.na.collabserv.com ESMTP;
        Tue, 10 Sep 2019 20:53:16 -0000
Received: from us1a3-mail228.a3.dal06.isc4sb.com ([10.146.103.71])
          by us1a3-smtp08.a3.dal06.isc4sb.com
          with ESMTP id 2019091020531513-935522 ;
          Tue, 10 Sep 2019 20:53:15 +0000 
In-Reply-To: <20190909123840.154745-3-tmaimon77@gmail.com>
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
Date:   Tue, 10 Sep 2019 20:53:13 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20190909123840.154745-3-tmaimon77@gmail.com>,<20190909123840.154745-1-tmaimon77@gmail.com>
X-Mailer: IBM iNotes ($HaikuForm 1054) | IBM Domino Build
 SCN1812108_20180501T0841_FP57 August 05, 2019 at 12:42
X-LLNOutbound: False
X-Disclaimed: 34479
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 19091020-3067-0000-0000-000000AA6B2C
X-IBM-SpamModules-Scores: BY=0; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.40962; ST=0; TS=0; UL=0; ISC=; MB=0.056169
X-IBM-SpamModules-Versions: BY=3.00011750; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01259539; UDB=6.00665766; IPR=6.01041294;
 MB=3.00028569; MTD=3.00000008; XFM=3.00000015; UTC=2019-09-10 20:53:31
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2019-09-10 16:44:15 - 6.00010391
x-cbparentid: 19091020-3068-0000-0000-000011BD12C5
Message-Id: <OFDC101E51.54765CB8-ON00258471.006F34B7-00258471.0072BCA7@notes.na.collabserv.com>
Subject: Re:  [PATCH v2 2/2] hwrng: npcm: add NPCM RNG driver
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-10_11:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On September 9, 2019 around 7:40AM in somet timezone, Tomer Maimon wrote:
>+#define NPCM_RNG_TIMEOUT_USEC	20000
>+#define NPCM_RNG_POLL_USEC	1000

...

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
>+static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max,
>bool wait)
>+{
>+	struct npcm_rng *priv = to_npcm_rng(rng);
>+	int retval = 0;
>+	int ready;
>+
>+	pm_runtime_get_sync((struct device *)priv->rng.priv);
>+
>+	while (max >= sizeof(u32)) {
>+		ready = readl(priv->base + NPCM_RNGCS_REG) &
>+			NPCM_RNG_DATA_VALID;
>+		if (!ready) {
>+			if (wait) {
>+				if (readl_poll_timeout(priv->base + NPCM_RNGCS_REG,
>+						       ready,
>+						       ready & NPCM_RNG_DATA_VALID,
>+						       NPCM_RNG_POLL_USEC,
>+						       NPCM_RNG_TIMEOUT_USEC))
>+					break;
>+			} else {
>+				break;

This break is too far from the condition and deeply nested to follow.

And looking further, readl_poll_timeout will read and check the condition before
calling usleep, so the the initial readl and check is redundant

Rearrange to make wait determine if you call readl_poll_timeout or 
readl / compare / break.

>+			}
>+		}
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
>+}
>+
>+static int npcm_rng_probe(struct platform_device *pdev)
>+{
>+	struct npcm_rng *priv;
>+	struct resource *res;
>+	bool pm_dis = false;
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
>+	pm_dis = true;
>+	priv->rng.init = npcm_rng_init;
>+	priv->rng.cleanup = npcm_rng_cleanup;
>+#endif

if you move this down you can use one if (ENABLED_CONFIG_PM) {}

>+	priv->rng.read = npcm_rng_read;
>+	priv->rng.priv = (unsigned long)&pdev->dev;
>+	if (of_property_read_u32(pdev->dev.of_node, "quality", &quality))
>+		priv->rng.quality = 1000;
>+	else
>+		priv->rng.quality = quality;
>+
>+	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
>+	if (pm_dis)
>+		writel(NPCM_RNG_CLK_SET_25MHZ, priv->base + NPCM_RNGCS_REG);
>+	else
>+		writel(NPCM_RNG_CLK_SET_25MHZ | NPCM_RNG_ENABLE,
>+		       priv->base + NPCM_RNGCS_REG);

wait ... if we know the whole value here, why read/modify/write the value
in the init and cleanup hook?   Save the io read and write the known value
 ... define the value to be written for clarity between enable/disable if
needed



>+
>+	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
>+	if (ret) {
>+		dev_err(&pdev->dev, "Failed to register rng device: %d\n",
>+			ret);

need to disable if CONFIG_PM ?

>+		return ret;
>+	}
>+
>+	dev_set_drvdata(&pdev->dev, priv);

This should probably be before the register.

>+	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);

So every 100ms power off, and if userspace does a read we
will poll every 1ms for upto 20ms.

If userspace says try once a second with -ENODELAY so no wait,
it never gets data.


Oh, and yes, rngd sets non-blocking, polls the descriptors,
and falls back to slow expensive software if no hardware
says it has data ready.

>+	pm_runtime_use_autosuspend(&pdev->dev);
>+	pm_runtime_enable(&pdev->dev);
>+
>+	return 0;
>+}
>+
>+static int npcm_rng_remove(struct platform_device *pdev)
>+{
>+	struct npcm_rng *priv = platform_get_drvdata(pdev);
>+
>+	hwrng_unregister(&priv->rng);

you did devm register, but call unregister directly?

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

module_platform_driver will set owner, remove it here.

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

milton

