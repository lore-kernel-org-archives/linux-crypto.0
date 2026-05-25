Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9589F1EA7CE;
	Mon, 25 May 2026 03:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779679210; cv=none; b=rGSuGF9nI+fx8Iv2hHBPUiRRm1pCOj0kOg/rmI9++4yk8vSvz6KzwtfYIhXmbT2ODBtTbv0U15btmDvWmh2ix1UMG3ANrgjirlSVCQpxKbPEe4o8oGGYDHjOtJiAaeyWARslnjwRsAb5bmk538odlC19obetEnPR3pR2hzAFmZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779679210; c=relaxed/simple;
	bh=dujhx+kNkJj4kNiU/zgoiaK+THB6K/rFBIERBnI7OyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODil4idOV0fve3NyPpy6aTdGsDFpYxGe/mzjZnqBt3yYQCK+YkRrQ3BjiSG4N7ESy0sZBRstwgP9g3XxOMkXjvR031XOSxSOkvCnk+frLpcCfgMTRNtKpeoUo6sIZn+bJ0ZtUM+JT92+opLWrfewOt5j18pFrn1nX430YlOioe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTEABuQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTEABuQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1627B1F000E9;
	Mon, 25 May 2026 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779679208;
	bh=vsyaQijSF17oIUNASElUtqLbJFypQHGCf/EnkeK63AM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DTEABuQH/yQueBer9Vkmn/T1iSsMD8UI+in6nAOPm3PHV/3X+16QGNbPTybv5HxuZ
	 dS/3SauIYktoOoG7mO8/viXSJ8/dGW0l6P4S4+Ch9QRd26kYIOVnm+B4rjMsaqOblc
	 25qBnjKyEbh879DofpF6AE20PqZ+fxupDr/Un36ByLY/U0KSlESb8BSTdiKYmHN9j6
	 H89eBG7DHano0NsDWQWuvYpmv+xM/hxHU/MxG7z6fA47psoBwUOwpKnhFfc4m2j5Nj
	 YU2qfv9S5aDR3OVxPykdILWnVOqnZfixC1Z95JgU0YuzrOnkXeRu0wR397iFNNuO22
	 asOgTUNGzlk+Q==
Date: Sun, 24 May 2026 22:20:06 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	Yinggang Gu <guyinggang@loongson.cn>, Lee Jones <lee@kernel.org>,
	kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
Message-ID: <20260525032006.GA243157@quark>
References: <20260522022525.12976-1-ebiggers@kernel.org>
 <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
 <20260522025722.GD5937@quark>
 <d71adfa1-8895-e741-b72f-c5e99d5fb9e6@loongson.cn>
 <20260522040310.GF5937@quark>
 <bc3acf15-808d-4141-7f1f-4a7a7f856c6c@loongson.cn>
 <20260522174835.GA1894319@google.com>
 <4501444d-9c17-8d4b-8bfd-bd1d69d77a76@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4501444d-9c17-8d4b-8bfd-bd1d69d77a76@loongson.cn>

On Mon, May 25, 2026 at 10:45:14AM +0800, Qunqin Zhao wrote:
> > > To be honest, I previously assumed that the `hw_random` was designed
> > > strictly and exclusively for the TRNG mode.
> > > 
> > > Is it architecturally acceptable or common practice for a PRNG mode to
> > > utilize `hw_random` as well?
> > > 
> > > Thanks,
> > So the Loongson RNG is a PRNG?  Where does it get its entropy from, and
> > what is its security strength?
> 
> Loongson's hardware supports both TRNG and PRNG simultaneously.
> 
> We can locate a reseed function within loongson-rng.c, which clearly
> indicates that it is a PRNG driver.

That reseed function gets called with entropy from the Linux RNG.  So,
it seems it's really just a PRNG seeded from the Linux RNG.  What value
does that provide over just using the Linux RNG directly?

> So the core issue here is whether a PRNG driver can utilize the crypto
> interface.

If you're asking about crypto_rng, it can.  But the crypto_rng interface
is also kind of useless.  If you're asking about hwrng, it does look
like it's designed for TRNGs.  Would it be possible for this driver to
use the TRNG mode?

> If it cannot, does that imply the drivers listed below serve no practical
> purpose? (7.1-rc1)
> 
> loongson@loongson:~/upstream/linux/drivers/crypto$ grep crypto_register_rng

Most of the drivers in drivers/crypto/ are added by the hardware
manufacturer without any regard for whether they're useful or not.

- Eric
