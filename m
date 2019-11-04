Return-Path: <SRS0=nD+4=Y4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116B7CA9ED3
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 12:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E66D8222C1
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 12:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfKDM4q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:56:46 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:11184 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfKDM4p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Nov 2019 07:56:45 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: dbAug5vvENl8xXGmZB86dPAacdvNNvFH0BLXftjyU665RcYwrlBP5bco/BWV10dqj6MYt4LtaL
 vm53q9uncluOmePQbeXp32euhwjyMxFCy3JwyrcnqFQGMqhPNlt1waOn4/FfZt2v3UQxRqKHx2
 hBm6hX+0nKmTrnrNnyqfj9Vr5eoOGztCUn7HmgYZJBhrf23DQf3PDCFiAQbLRK7N16qDE3NyZe
 Y7yHTDNgiaqkhImm8tsRifaEeFQr5N1LWT9B51poDy8Dr528t9cxd6ydFy6lgEddLyfC3KOK6q
 jqA=
X-IronPort-AV: E=Sophos;i="5.68,267,1569308400"; 
   d="scan'208";a="54041455"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2019 05:56:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Nov 2019 05:56:24 -0700
Received: from rob-ult-m19940.corp.atmel.com (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 4 Nov 2019 05:56:21 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <arnd@arndb.de>,
        <Tudor.Ambarus@microchip.com>, <Claudiu.Beznea@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH v2 2/2] hwrng: atmel: add new platform support for sam9x60
Date:   Mon, 4 Nov 2019 13:54:57 +0200
Message-ID: <20191104115457.2681-2-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191104115457.2681-1-codrin.ciubotariu@microchip.com>
References: <20191104115457.2681-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add platform support for the new IP found on sam9x60 SoC. For this
version, if the peripheral clk is above 100MHz, the HALFR bit must be
set. This bit is available only if the IP can generate a random number
every 168 cycles (instead of 84).

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---

Changes in v2:
 - replaced '*pdata' with '*data';
 - added 'const' to trng_data configs;

 drivers/char/hw_random/atmel-rng.c | 39 ++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index b3138ec26f85..ecb71c4317a5 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -14,14 +14,22 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/hw_random.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #define TRNG_CR		0x00
+#define TRNG_MR		0x04
 #define TRNG_ISR	0x1c
 #define TRNG_ODATA	0x50
 
 #define TRNG_KEY	0x524e4700 /* RNG */
 
+#define TRNG_HALFR	BIT(0) /* generate RN every 168 cycles */
+
+struct atmel_trng_data {
+	bool has_half_rate;
+};
+
 struct atmel_trng {
 	struct clk *clk;
 	void __iomem *base;
@@ -62,6 +70,7 @@ static void atmel_trng_disable(struct atmel_trng *trng)
 static int atmel_trng_probe(struct platform_device *pdev)
 {
 	struct atmel_trng *trng;
+	const struct atmel_trng_data *data;
 	int ret;
 
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -75,6 +84,17 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	trng->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(trng->clk))
 		return PTR_ERR(trng->clk);
+	data = of_device_get_match_data(&pdev->dev);
+	if (!data)
+		return -ENODEV;
+
+	if (data->has_half_rate) {
+		unsigned long rate = clk_get_rate(trng->clk);
+
+		/* if peripheral clk is above 100MHz, set HALFR */
+		if (rate > 100000000)
+			writel(TRNG_HALFR, trng->base + TRNG_MR);
+	}
 
 	ret = clk_prepare_enable(trng->clk);
 	if (ret)
@@ -139,9 +159,24 @@ static const struct dev_pm_ops atmel_trng_pm_ops = {
 };
 #endif /* CONFIG_PM */
 
+static const struct atmel_trng_data at91sam9g45_config = {
+	.has_half_rate = false,
+};
+
+static const struct atmel_trng_data sam9x60_config = {
+	.has_half_rate = true,
+};
+
 static const struct of_device_id atmel_trng_dt_ids[] = {
-	{ .compatible = "atmel,at91sam9g45-trng" },
-	{ /* sentinel */ }
+	{
+		.compatible = "atmel,at91sam9g45-trng",
+		.data = &at91sam9g45_config,
+	}, {
+		.compatible = "microchip,sam9x60-trng",
+		.data = &sam9x60_config,
+	}, {
+		/* sentinel */
+	}
 };
 MODULE_DEVICE_TABLE(of, atmel_trng_dt_ids);
 
-- 
2.20.1

