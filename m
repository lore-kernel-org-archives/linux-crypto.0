Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73552500C5;
	Thu,  3 Apr 2025 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743698639; cv=none; b=KOY/NOxXf2UnCZrU372G8buhq8IOwHGF/y71b5IpOQePB5ipz1xFTCZgYaI23Ned7IE31+RmNDX3MytHziMi4dMWLCU1g+6xSju2+VHlB1b6ydseHuEnupU0FHS/NJA6D0/hmOM8QzSpT92ag9YOhh6yRlNuR3/sPhvMkk7he18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743698639; c=relaxed/simple;
	bh=d/TSkeYj3F9bgZrKVP1yeLOHbpVrzfuqdbuPh7Jy6gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cyh5KsJ0c03asKkS/ZUBc10axwWkE+3aPcHdUV8AGRxdfKqmefz5v5KYx8Pg3nGFLZV5iD+VITqJZvoCzKHhtdR4f8xWv8npXf7XpQff08VWfsQGsncR6ai6UvhR22FxgKCiVU8SpdFqRMT4BDsxDlCeIHzu3DrTpEXhX41dDZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NthLJHCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NthLJHCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08BCC4CEE3;
	Thu,  3 Apr 2025 16:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743698639;
	bh=d/TSkeYj3F9bgZrKVP1yeLOHbpVrzfuqdbuPh7Jy6gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NthLJHCjkKm6tGo/2CJqLnV7pEAKxp+StQycPx/WxvtKJQVXL5DgE8DAl6sgMJrDe
	 WBWYIvFiQfzLW6/erZa0iQaXS+mwqXfYHKBy9LUA78zDS6OcxIbbHGk6laPzcd0X8H
	 a5wK1LruuZvug4/g2iufZK291IM7yUw4GayMzLqvhGXFGAvS05SJF9FHU08HHArMe6
	 oaeb+t3GjxUBnFucend62Gw4E3vJDrA9NLMqoqbGeWJqYRiU6++Y+S31ezCpQvnWGF
	 tpIi0phI0xooe6jbOdDxX+V3fBBgUlMU3Lmax0b9lbZXZcyPVOdKZ5V2ZjHNG8LVkt
	 dmGgTVOkHAkYw==
Date: Thu, 3 Apr 2025 09:43:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
Message-ID: <20250403164357.GC1241@sol.localdomain>
References: <20250403094527.349526-1-ubizjak@gmail.com>
 <20250403094527.349526-3-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403094527.349526-3-ubizjak@gmail.com>

On Thu, Apr 03, 2025 at 11:44:41AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.25,
> which supports AVX-512 instruction mnemonics.
> 
> Remove check for assembler support of AVX-512 instructions
> and all relevant macros for conditional compilation.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
