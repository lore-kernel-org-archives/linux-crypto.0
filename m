Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11E37CD21;
	Tue, 18 Aug 2026 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787041738; cv=none; b=jG/OglO7huY9oaZJl74p8iJ6VgQbSlbz6GD3eCur1OYGoqj0Ed0XlOY39hrBw5VDRFxJ5X783lNcyhgw6doXI6huR7uMybLwrG6mgDVPdwCapGBWBYEz5uXcpk0UjwjQH5ziCK6S0PxSWzCoLxr1qGWPtWppGfW4IGnPoYdCvB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787041738; c=relaxed/simple;
	bh=0GLSPgfLPnGkhDHv6uGO2bihMSRdIB9j6ooENMQbZHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2ugRn8BEF4n28VR7wc/oRrUOJ8QLdxoFslzLoIPMdoedwP0NwS1mdtmDz5K7EJ1bmejNZLqs8mLz1BxvB79ttTFkBbdOP9/7WjDGJn4S3nfl2TGQo16KRWjjm22NB1eBWHIORlyLnPYGzVxmxvVhWaJzr1isBsbxlwySdRTz44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6uZsUrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6uZsUrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A8C1F00A3A;
	Tue, 18 Aug 2026 08:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787041737;
	bh=EvHSMteT/z+D5EU6UdnH2mhprHjlF/y16XFkvC86WFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q6uZsUrCrf8IbeQZ9eCWEXA8Wyv0njLBnbPv42pc0SjcZ2keCvMEbthUwUvr81BFu
	 Wmxr8ohGCkIuJY5HwtcYxzjeiGo9vXwjqHfo8/Akp45kp0MdfHdet7QRc1pe5I8hpr
	 J63gdbISM+tdqC6cBg2vHDfEAYOzF5yB4w75/lnJwyxH7m6lh9r1GFLJ9IcVUnNUnB
	 ETd7gy3bSGEhYzZNFw49ZFoxooa1SxvcRwXixfORSgIfmKW+bypFo8EvCLrah9AKEN
	 E9epXYK8KsRxLnBxiLl6Ya7QJxGOoLNQkGo6a8xxmv3UizYajQnZryw4lqbEZQ0ld8
	 KH3LKxgy2yMCA==
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1wwFBm-00000000nOA-2Twz;
	Tue, 18 Aug 2026 10:28:54 +0200
Date: Tue, 18 Aug 2026 10:28:54 +0200
From: Johan Hovold <johan@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: atmel: fix usage_count leak when
 autosuspend_delay is negative
Message-ID: <aoQXxhJGFdCjrljz@hovoldconsulting.com>
References: <20260808063458.2609136-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808063458.2609136-1-lgs201920130244@gmail.com>

On Sat, Aug 08, 2026 at 02:34:58PM +0800, Guangshuo Li wrote:
> atmel_trng_probe() calls pm_runtime_use_autosuspend(), but neither the
> probe failure path nor atmel_trng_remove() calls the matching
> pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> 
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.

As I've explained elsewhere, this is just misleading. There is no usage
count leak here as the count is balanced whenever the user re-enables
autosuspend through sysfs (by writing a non-negative timeout).

Drivers should clean up after themselves and disable autosuspend, but
this is more of a clean up than a fix and should not be backported.

You've sent upwards of 60 of these in the matter of a just a few days,
some which have even been picked up. Please send follow-ups (replies or
v2s) as soon as possible to prevent further of these from getting
merged.

> Add the missing pm_runtime_dont_use_autosuspend() calls to both the
> probe failure and remove paths before disabling runtime PM.
> 
> This issue was found by manual code inspection.
> 
> Fixes: c4f51eab6ce0 ("hwrng: atmel - add runtime pm support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Johan
