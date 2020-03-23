Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C86C3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 14:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF7F2072E
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 14:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCWO4u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 10:56:50 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48127 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgCWO4t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 10:56:49 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost.discworld.emantor.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <r.czerwinski@pengutronix.de>)
        id 1jGOV7-0006Sg-Pz; Mon, 23 Mar 2020 15:56:25 +0100
Message-ID: <412a4da61063b8c8a72729f03c06480c5f1374fb.camel@pengutronix.de>
Subject: Re: [PATCH v5 2/3] hw_random: cctrng: introduce Arm CryptoCell
 driver
From:   Rouven Czerwinski <r.czerwinski@pengutronix.de>
To:     Hadar Gat <hadar.gat@arm.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Date:   Mon, 23 Mar 2020 15:56:19 +0100
In-Reply-To: <1584891085-8963-3-git-send-email-hadar.gat@arm.com>
References: <1584891085-8963-1-git-send-email-hadar.gat@arm.com>
         <1584891085-8963-3-git-send-email-hadar.gat@arm.com>
Organization: Pengutronix e.K.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: r.czerwinski@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Hadar,

On Sun, 2020-03-22 at 17:31 +0200, Hadar Gat wrote:
> Introduce low level Arm CryptoCell TRNG HW support.
> 
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  drivers/char/hw_random/Kconfig  |  12 +
>  drivers/char/hw_random/Makefile |   1 +
>  drivers/char/hw_random/cctrng.c | 735
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/char/hw_random/cctrng.h |  69 ++++
>  4 files changed, 817 insertions(+)
>  create mode 100644 drivers/char/hw_random/cctrng.c
>  create mode 100644 drivers/char/hw_random/cctrng.h
> 
> [...]
> +static int cctrng_probe(struct platform_device *pdev)
> +{
> +	struct resource *req_mem_cc_regs = NULL;
> +	struct cctrng_drvdata *drvdata;
> +	struct device *dev = &pdev->dev;
> +	int rc = 0;
> +	u32 val;
> +	int irq;
> +
> +	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +
> +	drvdata->rng.name = devm_kstrdup(dev, dev_name(dev),
> GFP_KERNEL);
> +	if (!drvdata->rng.name)
> +		return -ENOMEM;
> +
> +	drvdata->rng.read = cctrng_read;
> +	drvdata->rng.priv = (unsigned long)drvdata;

You are not initializing drvdata->rng.quality to a default value, which
results in the TRNG not being used by the kernel by default. If its a
perfect TRNG this should be set to 1024, i.e. 1024 bits of entropy per
1024 bits of input.

Regards,
Rouven Czerwinski

