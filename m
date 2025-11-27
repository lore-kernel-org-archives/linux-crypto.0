Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A65C2144C7;
	Thu, 27 Nov 2025 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764249772; cv=none; b=LNMNa/1iz0cLHfDrdVF8ok+OYfWpXRD4HT2N9PcimK2L8R15oBWWpLT5JGxaRmLgVtTJS73wnxhtChcpn8SDt1YDQmnBIGZFokbV8zsqGHVzcL1PkTEJytqvTGPmK9XHGuOeb+ySw6y3o3CWoi4d6JPAJU2lP3+OqXz55/v+MN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764249772; c=relaxed/simple;
	bh=j4m5kttRAm5kvGpDGtBPI0PXQs8rTAdOSDIXXBd0eGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOV65wKwpCHv7p5cXinTLTaYEW20MlDzNSxZfTIBuUCu//f/TtlHbXJVat77Z/PiGrLnRk1/c+cl/FrXrDbJfAhck0E8BnWeeXVbXob8SBvFbmiNr4iEoICaW28oMePpQH32/SeM63wVzeFvw7gZRHg1ArB8nCJKeeTrTgHYMFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.96)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1vObxC-0007Pt-0N;
	Thu, 27 Nov 2025 14:22:34 +0100
Date: Thu, 27 Nov 2025 14:22:34 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Michel Hautbois via B4 Relay <devnull+jeanmichel.hautbois.yoseli.org@kernel.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v4 1/2] hwrng: imx-rngc: Use optional clock
Message-ID: <aShQmqUfT5OQFf0N@akranes.kaiser.cx>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
 <20251126-b4-m5441x-add-rng-support-v4-1-5309548c9555@yoseli.org>
 <aSdjT9BLzGF3_5PB@akranes.kaiser.cx>
 <CAMuHMdUGmw+Pa43oqcGzt0x7ED2FGw0=U7XddvdaUZ3GFmsxsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUGmw+Pa43oqcGzt0x7ED2FGw0=U7XddvdaUZ3GFmsxsQ@mail.gmail.com>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Hi Geert,

Thus wrote Geert Uytterhoeven (geert@linux-m68k.org):

> Hi Martin,

> On Wed, 26 Nov 2025 at 21:30, Martin Kaiser <martin@kaiser.cx> wrote:
> > Thus wrote Jean-Michel Hautbois via B4 Relay (devnull+jeanmichel.hautbois.yoseli.org@kernel.org):

> > > From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

> > > Change devm_clk_get() to devm_clk_get_optional() to support platforms
> > > where the RNG clock is always enabled and not exposed via the clock
> > > framework (such as ColdFire MCF54418).

> > > Reviewed-by: Frank Li <Frank.Li@nxp.com>
> > > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> > > ---
> > >  drivers/char/hw_random/imx-rngc.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)

> > > diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> > > index 241664a9b5d9..d6a847e48339 100644
> > > --- a/drivers/char/hw_random/imx-rngc.c
> > > +++ b/drivers/char/hw_random/imx-rngc.c
> > > @@ -259,7 +259,7 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
> > >       if (IS_ERR(rngc->base))
> > >               return PTR_ERR(rngc->base);

> > > -     rngc->clk = devm_clk_get(&pdev->dev, NULL);
> > > +     rngc->clk = devm_clk_get_optional(&pdev->dev, NULL);
> > >       if (IS_ERR(rngc->clk))
> > >               return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk), "Cannot get rng_clk\n");

> > The clock is not optional on a standard imx25 system. If it's missing in the
> > device tree, the rngb will not work and we should not load the driver.

> As the clocks property is marked required in
> Documentation/devicetree/bindings/rng/imx-rng.yaml, "make dtbs_check"
> should flag a missing clock.

> > Should we call devm_clk_get or devm_clk_get_optional, depending on the
> > detected device?

> That can quickly lead to complex code.  Nowadays it is fine to rely on
> "make dtbs_check" for some part of the validation.

ok, understood. With this clarification, I'm happy with the patch.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>

Thanks,
Martin
