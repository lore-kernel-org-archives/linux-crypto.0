Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD243C433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8025764EB4
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhBTTK0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 14:10:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBTTK0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 14:10:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDXdC-007Z1R-6F; Sat, 20 Feb 2021 20:09:30 +0100
Date:   Sat, 20 Feb 2021 20:09:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au,
        nsaenzjulienne@suse.de, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        rikard.falkeborn@gmail.com, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
Message-ID: <YDFeao/bOxvoXI9D@lunn.ch>
References: <20210220174741.23665-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210220174741.23665-1-noltari@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 20, 2021 at 06:47:40PM +0100, Álvaro Fernández Rojas wrote:
> This allows devices without a high precission timer to reduce boot from >100s
> to <30s.
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index 1a7c43b43c6b..4b48cb7176b0 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -163,6 +163,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>  	priv->rng.init = bcm2835_rng_init;
>  	priv->rng.read = bcm2835_rng_read;
>  	priv->rng.cleanup = bcm2835_rng_cleanup;
> +	priv->rng.quality = 1000;

Hi Alvero

 * @quality:		Estimation of true entropy in RNG's bitstream
 *			(in bits of entropy per 1024 bits of input;
 *			valid values: 1 to 1024, or 0 for unknown).

How did you determine this device produces 1000 bits of true entropy
per 1024?

    Andrew
