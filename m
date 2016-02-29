From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Mon, 29 Feb 2016 18:16:50 -0300
Message-ID: <CAOMZO5BN-1U6vX0HAHWX30t+23NnqEpOw6AttSgvqaZnq=cN6Q@mail.gmail.com>
References: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
	<1456761156-27664-3-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-crypto@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33233 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbcB2VQv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Feb 2016 16:16:51 -0500
In-Reply-To: <1456761156-27664-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 29, 2016 at 12:52 PM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:

> +       ret = clk_prepare_enable(rngc->clk);
> +       if (ret)
> +               return ret;
> +
> +       rngc->irq = platform_get_irq(pdev, 0);
> +       if (!rngc->irq) {
> +               dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
> +               clk_disable_unprepare(rngc->clk);
> +
> +               return ret;

You are returning the wrong error code here:

Better do like this:

       rngc->irq = platform_get_irq(pdev, 0);
       if (rngc->irq < 0) {
               dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
               clk_disable_unprepare(rngc->clk);
               return rngc->irq;
       }
