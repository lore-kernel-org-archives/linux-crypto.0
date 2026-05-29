Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F7832B114;
	Fri, 29 May 2026 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780071140; cv=none; b=qETXZMCGaTL0NCewwiaOWEs0E5AgH6LqPMJpJDHUV1h2PMqQ/eDSDnNtC8EIIM/gXAMtVqx45da4Iyh6EZSgYMgzagZXzG+l6wAYuXSEAkmfGYF8lfoVOGdg5RNX+N2Wtv+MQyyOWETizhfWqXJJ2n6TmzufHyiqfLW9iUdR0BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780071140; c=relaxed/simple;
	bh=OHeeyqoChQDad6pbZhVax+uFHgxh/wDUMIP2gJcupuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkHmACX5yslLiSAtDWpVPKoVkVNClrXNXf0DG0Eu9H35fPEoHq36TzMA6NMDlaa5S5J2u+TAzgfyk1y6pDRdMsJpg2m9FI0YgfmxoDmaS0nMaBhPhLt/X9mYlsNZXA4SAyfflDN3FwxJU8DAZQ+wz8a6NqR4AGAxRCU5EwEXj+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIff+iUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIff+iUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC091F00893;
	Fri, 29 May 2026 16:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780071139;
	bh=O64NbSrhCjdHeoemZg/mhRJwhCejkHY0XbaaTicTFT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GIff+iUMDMNmzEm5o/UKkYDLuIwCl/3cYOEXHy4I2sP+yno/IwfE6+EcXvyUHyU4T
	 sgU9NZFO1Rwsr4eakJk+FJbFUwTBS8N/RIEVUAaGHORsvHRr1cquaKLq1zo7rBbRAY
	 mUE5SWOxvTr25/NfBN94R8nJbmKNWDCSlzzXR06L4WW/goIH6Evkv4UU8Q1Mn1WaWY
	 BL0cbfs7bZPXUlKsauL8lmOy6bJWpZft55FQNa/FxnZdAfTtaLDfLpRWUO/a3qj5w9
	 kjAFR81T1yWN32RBQoHtaLFjhzzyo6Qh7/dtzytSgaA8dsklArgHObXc2DgGzPS6vT
	 wFHCQGtqeUjSw==
Date: Fri, 29 May 2026 09:10:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Tianchu Chen <tianchu.chen@linux.dev>
Cc: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, wens@kernel.org, jernej.skrabec@gmail.com,
	samuel@sholland.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun4i-ss - clamp PRNG seed length to prevent
 heap overflow
Message-ID: <20260529161057.GA2706@sol>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
 <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>

On Fri, May 29, 2026 at 08:08:01AM +0000, Tianchu Chen wrote:
> From: Tianchu Chen <flynnnchen@tencent.com>
> 
> sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
> using the user-provided length with no bounds check. The crypto core
> does not enforce slen <= seedsize before calling into the driver, so a
> userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
> sysctl_optmem_max bytes, overflowing the fixed-size buffer and
> corrupting adjacent heap memory.
> 
> Clamp the copy length to the buffer size, matching the approach used by
> loongson-rng for oversized seeds.
> 
> Discovered by Atuin - Automated Vulnerability Discovery Engine.
> 
> Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> ---
> v2: Silently clamp oversized seeds with min_t instead of returning
>     -EINVAL (Herbert Xu).

sun4i-ss-prng.c is useless, is still broken, and should just be deleted.

- Eric
