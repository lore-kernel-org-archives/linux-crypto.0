Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9D4C432C3
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D822864FDF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhCDAHU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242521AbhCCNxf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 08:53:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3771BC06121E
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 05:52:56 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lHRvJ-0005O2-TD; Wed, 03 Mar 2021 14:52:21 +0100
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lHRvF-0004VL-ED; Wed, 03 Mar 2021 14:52:17 +0100
Message-ID: <cb7e29012e15ff10916374f911c74430fc3f5b32.camel@pengutronix.de>
Subject: Re: [PATCH v4 2/2] hwrng: bcm2835: add reset support
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     =?ISO-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?ISO-8859-1?Q?N=EDcolas?= "F. R. A. Prado" 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 03 Mar 2021 14:52:17 +0100
In-Reply-To: <20210224082230.29015-3-noltari@gmail.com>
References: <20210223160131.29053-1-noltari@gmail.com>
         <20210224082230.29015-1-noltari@gmail.com>
         <20210224082230.29015-3-noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Álvaro,

On Wed, 2021-02-24 at 09:22 +0100, Álvaro Fernández Rojas wrote:
[...]
> @@ -115,6 +121,8 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
>  	/* disable rng hardware */
>  	rng_writel(priv, 0, RNG_CTRL);
>  
> +	reset_control_rearm(priv->reset);
> +
>  	if (!IS_ERR(priv->clk))
>  		clk_disable_unprepare(priv->clk);
>  }
> @@ -159,6 +167,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>  	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
>  		return -EPROBE_DEFER;
>  
> +	priv->reset = devm_reset_control_get_optional_exclusive(dev, NULL);
> +	if (IS_ERR(priv->reset))
> +		return PTR_ERR(priv->reset);
> +
>  	priv->rng.name = pdev->name;
>  	priv->rng.init = bcm2835_rng_init;
>  	priv->rng.read = bcm2835_rng_read;

That doesn't seem right. reset_control_rearm() doesn't do anything if
the reset control is exclusive. Either the reset control should be
requested as shared, or the _rearm should be removed.

regards
Philipp
