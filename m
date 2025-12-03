Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584962FFFAB
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764785561; cv=none; b=Kbu/6NLrMx15UaQCxvcAIxELTGfgUvMr3zrtsJXgaymti2a7z+n2bXbxJEVwoMi1erSHhpmcN0dMpyx0O2/SSSOioL5Z7ibihlWt94WsIFypYTooIQDy8xn9vHsmfme9xEumJd7YJZzzqbP0DEuz3ImvFtq0Msh501VyHaHTkoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764785561; c=relaxed/simple;
	bh=6Bnvz1iwVVqQ21HFx0qsOtfZ8PwNEZPj/7YoGffSQEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSkWFxIk+BrLPnU/QBelRyxqHQHSKnlMT4DvVRMSB5zUdUlwjW9S0hCZnYZiiewR1oKZ4Z6dDd5XomWgKo2Ri9Tz1u++7IG4QIA6gxavT7yD/EhKTjJh5x1Nw09oQfTdTADLG5x50WKAQ1WR4l+tWGBV5JpnfG3lflNFxwrk7HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2FZ5HO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2FZ5HO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4666C4CEF5;
	Wed,  3 Dec 2025 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764785560;
	bh=6Bnvz1iwVVqQ21HFx0qsOtfZ8PwNEZPj/7YoGffSQEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2FZ5HO1BCtmYPx4+UwOqKgxGIFhPb1E3IYNYlDP9HC10Y1b/es5N+PzXRS5DOkQm
	 //qP3RVlShLOhXSewLxUVlKKDxCnwk13MhDiuaiiGb+NG2oFMDAeG/5uo3qiiJoosM
	 6/f0JX5c/IWcNt5vnn35Ih92AJbWSEXm8RGPfCvEgu/PeYkfZOqRGuppxFIz9StPYr
	 AAU2lw23qJ4RmMSscBb7YriZxLxlTTkIvtsk1TIFJMZVQAlMuwLtcSkADqXunoEio3
	 d/cdI01puSqIAFpWmQAJtJOcX4fN9ojcV+vL03AxqzsjMZYfoGe9uEyhNv97QDX+Da
	 WN2qo8CNWlAeg==
Date: Wed, 3 Dec 2025 10:10:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto/arm64: Reduce stack bloat from scoped ksimd
Message-ID: <20251203181046.GB1417@sol>
References: <20251203163803.157541-4-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203163803.157541-4-ardb@kernel.org>

On Wed, Dec 03, 2025 at 05:38:04PM +0100, Ard Biesheuvel wrote:
> Arnd reports that the new scoped ksimd changes result in excessive stack
> bloat in the XTS routines in some cases. Fix this for AES-XTS and
> SM4-XTS.
> 
> Note that the offending patches went in via the libcrypto tree, so these
> changes should either go via the same route, or wait for -rc1
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (2):
>   crypto/arm64: aes/xts - Using single ksimd scope to reduce stack bloat
>   crypto/arm64: sm4/xts: Merge ksimd scopes to reduce stack bloat
> 

Thanks, looks good to me.  I'll plan to take these and send another pull
request probably sometime next week.

- Eric
