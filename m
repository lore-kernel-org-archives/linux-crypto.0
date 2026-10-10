Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA33D75A0;
	Sat, 10 Oct 2026 08:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791622298; cv=none; b=H5XQy/b7vIA4sfRpF/Uhm014bGBecq5Vcb17prI1whpUm9GYUJGWDIstfl4doNAvuL/F5nzWpha7FGbeEubpY7q9xh+2zCYE9/8mnOqY0GWqeIZ7dCXMR9m4uZLk6eYWM33qqTD66rNXgHa77qaaYDaNY+I2gc2i178yvpYdI54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791622298; c=relaxed/simple;
	bh=RuOovqrOh1KCioDiSzvzTR23m07513lBeXANRFcJqLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eIulK/5gWVmMb9wzjG7j1U53S9AUhgLk7NDICt6kdRZOXCrK9s/67O6xgpQ+RxX3mWNDtfAIV5LZbXEpJj94YR7UWLu65pvaSPBr/rDDR87jnuSLEcJZP9xZ/hbGzXgEUuCbXoCU+IN8jQoaGrSU2nEKwCWJSdj1uO6sOYgDe18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=COXd/rYh; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="COXd/rYh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GRQCjk8o/a/C0+wV15inpx1btX0H9yvKy9U4k4uppuo=; 
	b=COXd/rYh6c/YIeSmGHxKuzPrhoV2lB4EI1g+3cavw5LEJgQ1BzD4kOybLc4/lzQu3/5477pYrgA
	AhrlmfN/9ALE2CrEvAlevl8YMcU46aRk/h0oWUADoPrAvJ1Pe8HOH/VZTdd19Q16Vx+aS5sKui5yy
	ygS/NQGpLe4vSCZ+hZqC+ZXFAA2dBE5nRSlRsib4i5OSLoLcmf5ihPKeGOhiLPIq2aC978V7eEht/
	Dw+ccFzuLz3Ph2daSx7iloaS5RzQOQikYKHB/o5bFMl0EkIK8n6Y5aQ84buPl32/CMb5MoCDDLGL9
	Y7imYxMT9vHgC2Oi/7Vzlhr2gKxjnYBbXOHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xFSnL-00000002TuW-2Zcm;
	Sat, 10 Oct 2026 16:51:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Oct 2026 19:51:07 +1100
Date: Sat, 10 Oct 2026 19:51:07 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg Ungerer <gerg@polyxeno.com>
Cc: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v4 2/2] m68k: coldfire: Add RNG support for MCF54418
Message-ID: <asn8e5puc3I01Lva@gondor.apana.org.au>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
 <20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org>
 <bd25e903-30fc-4905-986c-96d1b42e9f02@linux-m68k.org>
 <ddf0ab32-5b66-453e-b7aa-1722aeaf2aa0@yoseli.org>
 <9ba1ebd8-61cc-4e1a-b68d-906b20dd4999@polyxeno.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ba1ebd8-61cc-4e1a-b68d-906b20dd4999@polyxeno.com>

On Wed, Aug 19, 2026 at 07:36:36AM +1000, Greg Ungerer wrote:
> Hi JM,
> 
> On 19/8/26 01:09, Jean-Michel Hautbois wrote:
> > Hi Greg,
> > 
> > Sorry for the very long silence on this one, it fell off my radar...
> > 
> > Le 03/12/2025 à 13:15, Greg Ungerer a écrit :
> > > Hi Jean-Michel,
> > > 
> > > On 26/11/25 17:08, Jean-Michel Hautbois via B4 Relay wrote:
> > > > From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> > > > 
> > > > Add support for the hardware Random Number Generator (RNGB) found on
> > > > MCF54418 ColdFire processors with clock enabled at platform
> > > > initialization.
> > > > 
> > > > The RNGB block is compatible with the imx-rngc driver.
> > > > 
> > > > Reviewed-by: Frank Li <Frank.Li@nxp.com>
> > > > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> > > > ---
> > > >   arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
> > > >   arch/m68k/coldfire/m5441x.c       |  2 +-
> > > >   arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
> > > >   drivers/char/hw_random/Kconfig    |  3 ++-
> > > >   drivers/char/hw_random/imx-rngc.c |  7 +++++++
> > > >   5 files changed, 47 insertions(+), 2 deletions(-)
> > > 
> > > I am happy with the ColdFire arch parts, so from me:
> > > 
> > >      Acked-by: Greg Ungerer <gerg@linux-m68k.org>
> > > 
> > > I don't mind taking this commit via the m68knommu git tree if the hw_rng
> > > maintainers are ok with that. Otherwise if you break out the arch/m68k
> > > parts I can apply those on their own.
> > 
> > I think Herbert acked ?
> > Do you need another ack ?
> 
> I would like to see an acknowledgement that taking this patch via the
> m68knommu git tree (to Linus) is ok with the RNG maintainers.

I have no objections to this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
