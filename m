Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5D1C352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 20:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E444F2467D
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 20:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBLUpS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 15:45:18 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43665 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgBLUpS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 15:45:18 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1j1ysh-00039j-DC; Wed, 12 Feb 2020 21:45:11 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1j1ysd-0004v8-6T; Wed, 12 Feb 2020 21:45:07 +0100
Date:   Wed, 12 Feb 2020 21:45:07 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] hwrng: imx-rngc: improve dependencies
Message-ID: <20200212204507.u4slynuvztxjxbef@pengutronix.de>
References: <20200205140002.26273-1-u.kleine-koenig@pengutronix.de>
 <VI1PR0402MB3485267DA0BBAD58556611D1981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR0402MB3485267DA0BBAD58556611D1981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 12, 2020 at 07:51:46PM +0000, Horia Geanta wrote:
> On 2/5/2020 4:00 PM, Uwe Kleine-König wrote:
> > The imx-rngc driver binds to devices that are compatible to
> > "fsl,imx25-rngb". Grepping through the device tree sources suggests this
> > only exists on i.MX25. So restrict dependencies to configs that have
> The driver could also be used by some i.MX6 SoCs (SL, SLL),
> that have a compatible rngb.
> 
> Actually i.MX6SL has a rngb node in the DT, but unfortunately it lacks
> a compatible string.

Also the i.MX6ULL might have a compatible device?

> I am planning to address this short term.
> 
> > this SoC enabled, but allow compile testing. For the latter additional
> > dependencies for clk and readl/writel are necessary.
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/char/hw_random/Kconfig | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > index 8486c29d8324..17fe954fccde 100644
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -244,7 +244,8 @@ config HW_RANDOM_MXC_RNGA
> >  
> >  config HW_RANDOM_IMX_RNGC
> >  	tristate "Freescale i.MX RNGC Random Number Generator"
> > -	depends on ARCH_MXC
> > +	depends on HAS_IOMEM && HAVE_CLK
> > +	depends on SOC_IMX25 || COMPILE_TEST
> I guess SOC_IMX6SL and SOC_IMX6SLL will have to be added.
> Does this sound good?

I'd say currently the patch is right and once the device trees for the
imx6 variants were expanded to include these, the list here can be
expanded.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |
