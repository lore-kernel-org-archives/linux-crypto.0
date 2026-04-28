Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4A73E4C74
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370764; cv=none; b=hzWZcwEHhJxAZgByrHdIruKsTLMNoNc9aE5c8GY4mDANCzSWtrgo0N5AD5p9ZDl1RYAfiG8XBxOENapgzhdKgvWMXZKedOIXStjh9sFGyc+bw/Bn+hym5I3GCBjWlXIa/uNLuEPffp1fILE9Sg7Rld6pSQMVzgQyegohQ94wv4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370764; c=relaxed/simple;
	bh=si0GeyNOTWvpzr2O7XDw6IYfZNCHM16G3PuXERXzzAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NI/vQ4QXf+rHok4sqydF4pkjeU3F0QFBEirbtFNmdB6/5t35Ax59jPJPuk70VbdFuWTUKpS8+LpRR/k6mxVK4O9Dr9smAOFL47szJ29OPnBHiAEi+vrjPagCEJIiwdv077rlyruoGfQH4vh+HFWv9wpLyx+dftcX/zTyEHwbfqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C2tvSgRo; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C2tvSgRo"
Date: Tue, 28 Apr 2026 12:05:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777370751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F6NiVM+FcqKtdb/sqcUTVrGuVbWGle0JubOydHUeo5o=;
	b=C2tvSgRoc9Rwd5HDBOTSOX3/BUYtGIOIUbowRvaIbS1C/rncw+UmBZ1O5rRCo9xQk8rzxf
	z0bjNVDH+ioOZ42m0u/uPjHi9NKFCba9keqic7OenW9a1q/9+rsROB+Q3JLDTz3+2E+dQu
	iR9keTnJI7vDrTQSUISieZim/PAXgD8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Linus Walleij <linusw@kernel.org>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - drop hwrng quality reduction for
 ATSHA204A
Message-ID: <afCGefyZV_ujj41K@linux.dev>
References: <20260427124030.315590-3-thorsten.blum@linux.dev>
 <2d42b1fc-b5d5-4dcb-8dc8-62580502f586@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d42b1fc-b5d5-4dcb-8dc8-62580502f586@app.fastmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 28, 2026 at 07:58:39AM +0200, Ard Biesheuvel wrote:
> Hi Thorsten,
> 
> On Mon, 27 Apr 2026, at 14:40, Thorsten Blum wrote:
> > Commit 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to
> > lowest possible") reduced the hwrng quality to 1 based on a review by
> > Bill Cox [1]. However, despite its title, the review only tested the
> > ATSHA204, not the ATSHA204A.
> >
> > In the same thread, Atmel engineer Landon Cox wrote "this behavior has
> > been eliminated entirely"[2] in the ATSHA204A and "this problem does not
> > affect the ATECC108 or the ATECC108A (or the ATSHA204A)"[3].
> >
> > According to the official ATSHA204A datasheet [4], the device contains a
> > high-quality hardware RNG that combines its output with an internal seed
> > value stored in EEPROM or SRAM to generate random numbers. The device
> > also implements all security functions using SHA-256, and the driver
> > uses the chip's Random command in seed-update mode.
> >
> > Keep 'quality = 1' for ATSHA204, but drop the explicit hwrng quality
> > reduction for ATSHA204A and fall back to the hwrng core default.
> >
> 
> Interesting! Thanks for digging this up.
> 
> > [1] 
> > https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
> > [2] 
> > https://www.metzdowd.com/pipermail/cryptography/2014-December/023852.html
> > [3] 
> > https://www.metzdowd.com/pipermail/cryptography/2014-December/023886.html
> > [4] 
> > https://ww1.microchip.com/downloads/en/DeviceDoc/ATSHA204A-Data-Sheet-40002025A.pdf
> >
> > Fixes: 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to 
> > lowest possible")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  drivers/crypto/atmel-sha204a.c | 40 ++++++++++++++++++----------------
> >  1 file changed, 21 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> > index dbb39ed0cea1..df69fb190e52 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -19,6 +19,25 @@
> >  #include <linux/workqueue.h>
> >  #include "atmel-i2c.h"
> > 
> > +enum atmel_sha204a_variant {
> > +	ATSHA204 = 1,
> > +	ATSHA204A,
> > +};
> > +
> 
> I agree that setting quality to '1' is only appropriate for the ATSHA204
> but this looks a bit clunky to me.

Moving the declarations to the top was also a leftover from a previous
approach and not necessary anymore. I'll send a v2.

Thanks,
Thorsten
