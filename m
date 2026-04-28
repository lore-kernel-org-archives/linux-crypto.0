Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B23E42B720;
	Tue, 28 Apr 2026 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382694; cv=none; b=g4BiCn9q6h14gVBxTpBfFx1VaElQ1fx8KyeiPQChCXhBW1CcCovLyUOo8eiEsdyZXUYy5k/Pu+leRVitVwTsy8m8RZLyMVT4ZwrDvIyTCcI3rnSkdzi7c/v80Rs3OKNZqESu5r2hE3uRN5RvT4SOtNEe6px0Wb8CpGGNYM179HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382694; c=relaxed/simple;
	bh=Mbk7GJhzzHEOvI4/qFSYDMc92u86YKebUsjdgehgAuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c902Tt1ipplvLGHEpxbw1/WUbH0Jze0aw8sSFH4yJH4gnKo020nNqk/4B1RSpPlRDI/CLcTrstEnACDvezvyZBkiohKAAfTclF6SI5Ew+c1OhfFZyzMYrrqh3D2sxTlYEMemhEnW2JqGcUjJDjzMbdIz2/Qf6MTOjhwXjfIoXK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tlkFwXz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tlkFwXz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F96C2BCAF;
	Tue, 28 Apr 2026 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777382694;
	bh=Mbk7GJhzzHEOvI4/qFSYDMc92u86YKebUsjdgehgAuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tlkFwXz0zkNo/cS4uLIzu8CJsJA+Gy7EPJmTOv8jt5oOyjTHBpxdBg+ZaeE9UJW95
	 kedR9fTTgN57okQTaM4Gc8uQDIwuae5pRI41THfuXii83zd4ZVLFEn5m0mJVF/wx1u
	 OrSWGzqHcpIgtX6u2SeJ2bvUOnBTjgRi/5ejvOR707E6dfieaBBIwSAbX2fRwVkJKM
	 +eGjG0f1J/WooMr/yU+3UvUnNgeJn56Rj2h8JqMopfBiAYryhWKzBUWGhssSSbhaNI
	 CzxgFSlNyfeaVsdXgnTgkN7Gdap15ZEOZarc9TcUkvhh1C5X/5RakRkAxFJHm0P5vX
	 CO4oo/GbqRnmQ==
Date: Tue, 28 Apr 2026 15:24:48 +0200
From: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>, 
	Bill Cox <waywardgeek@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - drop hwrng quality reduction
 for ATSHA204A
Message-ID: <cbk4ho3bpprjxvcywv4sudbmb2fhfsgaguoywv5mhtoql4vhd6@f7oisxcrvii4>
References: <20260428101430.514838-3-thorsten.blum@linux.dev>
 <25ntssyy6t5uwxlwfpmrpzpcq6xv62l643hflf26hxi6lv5wqu@6vub6ysczjvd>
 <afCo9PbDpTYeqGd4@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afCo9PbDpTYeqGd4@linux.dev>

Hi Thorsten,

Bill also wrote about ATSHA204A [1]

  My best guess as to what's going on here is that the device has a
  ring-oscillator based entropy source, but that it generates only a few bits
  of entropy for each use.  It seems to be called before generating each
  32-byte "random" value, which is why the second set of 32-bit values have
  more possible values, and the 3rd has even more.  However, the number of
  unique values in the final column of 32*N byte values is always equal to
  the number of unique values of the entire string of bytes.

If this is true that the device generates <256 true random bits and then
mixes in non-volatile pseudorandom number generator to produce 256 bits,
then the quality should not be set to full 1024.

Marek

[1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html

On Tue, Apr 28, 2026 at 02:32:52PM +0200, Thorsten Blum wrote:
>
> Bill wrote in his review:
> 
>   "If I made no mistake (and I do make a lot), the "random" data from
>    the Atmel ATSHA204A is highly predictable when you disable the seed
>    update to EEPROM."
> 
> However, the atmel-sha204a driver doesn't operate the device in that
> mode. It uses the Random command with seed updates enabled, which is
> also what the datasheet recommends for highest security:
> 
>   "Microchip recommends that the EEPROM seed always be updated."
> 
> So the reported behavior doesn't reflect how the driver uses the device.
> 
> Thanks,
> Thorsten
