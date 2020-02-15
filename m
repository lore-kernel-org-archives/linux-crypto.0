Return-Path: <SRS0=thAn=4D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26A9C2BA83
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Feb 2020 17:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E7E2081E
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Feb 2020 17:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgBORQ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Feb 2020 12:16:28 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:52716 "EHLO viti.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgBORQ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Feb 2020 12:16:28 -0500
Received: from dslb-088-068-092-168.088.068.pools.vodafone-ip.de ([88.68.92.168] helo=martin-debian-2)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <postmaster@kaiser.cx>)
        id 1j313J-0005jM-8R; Sat, 15 Feb 2020 18:16:25 +0100
Received: from martin by martin-debian-2 with local (Exim 4.92)
        (envelope-from <martin@martin-debian-2>)
        id 1j313I-0003zr-Mn; Sat, 15 Feb 2020 18:16:24 +0100
Date:   Sat, 15 Feb 2020 18:16:24 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc: improve dependencies
Message-ID: <20200215171616.GA15321@martin-debian-1.paytec.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thus wrote Uwe Kleine-König (u.kleine-koenigpengutronix!de):

> On Wed, Feb 12, 2020 at 07:51:46PM +0000, Horia Geanta wrote:
> > On 2/5/2020 4:00 PM, Uwe Kleine-König wrote:
> > > The imx-rngc driver binds to devices that are compatible to
> > > "fsl,imx25-rngb". Grepping through the device tree sources suggests this
> > > only exists on i.MX25. So restrict dependencies to configs that have
> > The driver could also be used by some i.MX6 SoCs (SL, SLL),
> > that have a compatible rngb.

> > Actually i.MX6SL has a rngb node in the DT, but unfortunately it lacks
> > a compatible string.

> Also the i.MX6ULL might have a compatible device?

AFAICS imx35 chips have an rngc which is compatible to this driver as
well. I don't have any hardware to test this, though.

> > I am planning to address this short term.

> > > this SoC enabled, but allow compile testing. For the latter additional
> > > dependencies for clk and readl/writel are necessary.
> > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > >  drivers/char/hw_random/Kconfig | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)

> > > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > > index 8486c29d8324..17fe954fccde 100644
> > > --- a/drivers/char/hw_random/Kconfig
> > > +++ b/drivers/char/hw_random/Kconfig
> > > @@ -244,7 +244,8 @@ config HW_RANDOM_MXC_RNGA

> > >  config HW_RANDOM_IMX_RNGC
> > >  	tristate "Freescale i.MX RNGC Random Number Generator"
> > > -	depends on ARCH_MXC
> > > +	depends on HAS_IOMEM && HAVE_CLK
> > > +	depends on SOC_IMX25 || COMPILE_TEST
> > I guess SOC_IMX6SL and SOC_IMX6SLL will have to be added.
> > Does this sound good?

> I'd say currently the patch is right and once the device trees for the
> imx6 variants were expanded to include these, the list here can be
> expanded.

Makes sense to me.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
