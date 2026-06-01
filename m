Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E75E2798F8;
	Mon,  1 Jun 2026 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780328864; cv=none; b=H/r703I3k44rEtki5uXnx30e8TxSKkYOLHmnJHpSz0ADzTazHtT07VoTKHteheTmoW7CPAIOdDPQYg8NtJ3tZauyrFeHwgCwTQaywep9gE28W6jlAUz/XYoenGbHxaLllIwSmCXhyVlpKsAZ52IIyPSjQhKBi3GVc5wqFmutoYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780328864; c=relaxed/simple;
	bh=ZGQoeQM9rVKcEOJK0M6QRwcPz1+olNWsoVjYBqCZQXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnGgaZvxWJ1POgJ+UwwhIQ6V6T/UzXOM7YaPjqFfLjsaChKqghHNkuHlLd06l5BWPkWAoAKyD9J5kXsqx2MJ0CGXfMlMj9ze1z0YZRjBZmBeNUx0QEOxg/ZOPdHobBTR71sKgSiM4jg/ZxN4GtsynNIFbhcxG8g1X1JqQps1fh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REhd2V2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REhd2V2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701171F00893;
	Mon,  1 Jun 2026 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328862;
	bh=UZaQZA/YkXwhmlYNR9C5TH/86ysytbwmJ3KoYCamO5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=REhd2V2yu6dndNqAWxs9F06Fld5Yu5uNtFEFSpX6COUw+oYOYdG8ik7nUDUY4IO2Y
	 RNp2O50il4BV9lVKLGtfPtcmdE4fBtlZ+Jk8BS0WzK3zdi3jILLlcTZLq8dxwBQ1rE
	 3hU0Szkaif/riuT80PGpsRvLOSd+fyZdWBkTph6oWds7FDm23FmJgYEXwZiMj3rVNf
	 WGay+zjVXH32/oXVoJ9vTEoavrNnto6ikOr9PGUjzSBqZb+sd7nJTkhITCJWOdWxVM
	 64o/jDDeuMo2rl1llgTpesKungho/t3Qgi8ASgTOPLoVuu9BXSRHKi3QFx79gGq9dZ
	 auKQasjFMiZmg==
Date: Mon, 1 Jun 2026 15:47:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Tianchu Chen <tianchu.chen@linux.dev>, herbert@gondor.apana.org.au,
	davem@davemloft.net, wens@kernel.org, jernej.skrabec@gmail.com,
	samuel@sholland.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun4i-ss - clamp PRNG seed length to prevent
 heap overflow
Message-ID: <20260601154740.GA17375@google.com>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
 <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>
 <20260529161057.GA2706@sol>
 <ahnIbpBLyn5z_siT@Red>
 <20260529173341.GA566433@google.com>
 <ah2d0RyZcVp614_k@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ah2d0RyZcVp614_k@Red>

On Mon, Jun 01, 2026 at 04:57:21PM +0200, Corentin Labbe wrote:
> Le Fri, May 29, 2026 at 05:33:41PM +0000, Eric Biggers a écrit :
> > On Fri, May 29, 2026 at 07:10:06PM +0200, Corentin Labbe wrote:
> > > Le Fri, May 29, 2026 at 09:10:57AM -0700, Eric Biggers a écrit :
> > > > On Fri, May 29, 2026 at 08:08:01AM +0000, Tianchu Chen wrote:
> > > > > From: Tianchu Chen <flynnnchen@tencent.com>
> > > > > 
> > > > > sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
> > > > > using the user-provided length with no bounds check. The crypto core
> > > > > does not enforce slen <= seedsize before calling into the driver, so a
> > > > > userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
> > > > > sysctl_optmem_max bytes, overflowing the fixed-size buffer and
> > > > > corrupting adjacent heap memory.
> > > > > 
> > > > > Clamp the copy length to the buffer size, matching the approach used by
> > > > > loongson-rng for oversized seeds.
> > > > > 
> > > > > Discovered by Atuin - Automated Vulnerability Discovery Engine.
> > > > > 
> > > > > Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> > > > > ---
> > > > > v2: Silently clamp oversized seeds with min_t instead of returning
> > > > >     -EINVAL (Herbert Xu).
> > > > 
> > > > sun4i-ss-prng.c is useless, is still broken, and should just be deleted.
> > > 
> > > Hello
> > > 
> > > useless ? clearly no, it helped a lot on devices where it is.
> > 
> > The only way this code is reachable is via "rng" algorithm type in
> > AF_ALG, which is almost never used.  Everyone just uses the regular
> > Linux RNG (/dev/random etc) instead, as they should.
> > 
> > In fact, anyone were to accidentally use this it would be a security
> > vulnerability, seeing as sun4i_ss_prng_generate() doesn't actually fill
> > in all the bytes that were requested.  It also doesn't wait for the FIFO
> > to be ready when reading data from it.
> > 
> > Is it possible that there's a misunderstanding here and you think this
> > provides entropy to the regular Linux RNG?  It doesn't.  hwrng does
> > that, crypto_rng does not.
> > 
> 
> I believe to have used rngd for that. ( or something like that)
> 
> Anyway, I understand why want to remove it.

rngd doesn't use AF_ALG.  So no, it couldn't have used this driver.

- Eric
