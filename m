From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Sun, 10 Mar 2013 16:34:01 +0800
Message-ID: <20130310083401.GB10448@gondor.apana.org.au>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
 <1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
 <20130304075306.GA1906@pengutronix.de>
 <CACKLOr2kuWXMreEFA4wqyYVRNnPwmEoHPM2+V+tN5P_1bQ+iJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, kernel@pengutronix.de, gcembed@gmail.com,
	shawn.guo@linaro.org, arnd@arndb.de, swarren@nvidia.com
To: javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59197 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305Ab3CJIeX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Mar 2013 04:34:23 -0400
Content-Disposition: inline
In-Reply-To: <CACKLOr2kuWXMreEFA4wqyYVRNnPwmEoHPM2+V+tN5P_1bQ+iJQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 05, 2013 at 08:48:19AM +0100, javier Martin wrote:
> Hi Sascha,
> 
> On 4 March 2013 08:53, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Fri, Mar 01, 2013 at 12:37:52PM +0100, Javier Martin wrote:
> >>
> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> >> ---
> >>  arch/arm/mach-imx/clk-imx27.c |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> >> index 4c1d1e4..0b9664a 100644
> >> --- a/arch/arm/mach-imx/clk-imx27.c
> >> +++ b/arch/arm/mach-imx/clk-imx27.c
> >> @@ -253,6 +253,8 @@ int __init mx27_clocks_init(unsigned long fref)
> >>       clk_register_clkdev(clk[nfc_baud_gate], NULL, "imx27-nand.0");
> >>       clk_register_clkdev(clk[vpu_baud_gate], "per", "coda-imx27.0");
> >>       clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "coda-imx27.0");
> >> +     clk_register_clkdev(clk[sahara_ahb_gate], "ahb", "sahara-imx27.0");
> >> +     clk_register_clkdev(clk[sahara_ipg_gate], "ipg", "sahara-imx27.0");
> >
> > One of the first patches I want to push upstream for the next merge
> > window is this one:
> >
> > https://patchwork.kernel.org/patch/1817741/
> >
> > So the change above becomes unnecessary
> 
> Very good. Then this patch can be safely dropped.

So should I take this patch or not?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
