Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F0A217675;
	Mon, 17 Feb 2025 11:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739791091; cv=none; b=qTaggmuUDLQ2BxDtrffaUqNja4QrUWOc7b+BAYglxMNOghaObw3IvmU+ZrIU0JFr05fUIw3pBIBAEdUL00yMnFwQhTPPF1NAFg3plYR3HXkQZUywdXtwOdX9FxFoopirCLeKhaG6LtIp0JmJHqUHOuGLe2X9Rm1JulsnjRFmp4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739791091; c=relaxed/simple;
	bh=G7MUF03CFLa9tDuGxMo3/Ts+kGBg6ABgYmTn1CKu4N8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iff0agOss0mi8aJPd4CrwIxVuhldhKWCrei8g0ofxAQ1+hxCjMZzpmPhUWCXyaGCcnmfBRAvJ1c+2GNflUz8kJEgCWA8folaSeEJJCtf71g66YsF5/RSkXbctbrAcP7XtdKJLhMZSRMtPfqD4IEMba+0XmShG1bLPcHqWDZYsaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqBhkz7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqBhkz7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5A8C4CED1;
	Mon, 17 Feb 2025 11:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739791089;
	bh=G7MUF03CFLa9tDuGxMo3/Ts+kGBg6ABgYmTn1CKu4N8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RqBhkz7V5C7wsiWTDDcC/l7js8LwWoyOIWuO9YGTAEoGP1ABTxSuQnruELyMBOp0K
	 nu0olB4N8C/KZrDwsf1lHiy3jpqzlupnUSzejSEJAAK84HZiFfIJX7bvMQifSChCkS
	 GHwK5SYxvLZCHwq0z/Luqf0IbqVuZ3z5msCidkln1mNS13Xlkcp4ewJw23D477ReVa
	 PadL7aR7AdTP4ypD1oXAZwLs2ZbbGzgRP+W4o6+aqt5XL10xpN1HQVyfAbMnkEWObs
	 17LdsX62I7ylhtmKgEcksRwDIpeMcFLMCJT61KyYucuhO+mXzo4TYDVcwPPugvAUn/
	 NZWC/8/l0KOFA==
Date: Mon, 17 Feb 2025 11:18:06 +0000
From: Simon Horman <horms@kernel.org>
To: Markus Theil <theil.markus@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, akpm@linux-foundation.org, Jason@zx2c4.com
Subject: Re: [PATCH 2/2] prandom/random32: switch to Xoshiro256++
Message-ID: <20250217111806.GJ1615191@kernel.org>
References: <20250214081840.47229-1-theil.markus@gmail.com>
 <20250214081840.47229-3-theil.markus@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250214081840.47229-3-theil.markus@gmail.com>

On Fri, Feb 14, 2025 at 09:18:40AM +0100, Markus Theil wrote:
> The current Linux PRNG is based on LFSR113, which means:
> - needs some warmup rounds to yield better statistical properties
> - seeds/initial states must be of certain structure
> - does not pass L’Ecuyer's BigCrush in TestU01
> 
> While of course, there is no clear "best" PRNG, replace with
> Xoshiro256++, which seams to be a sensible replacement, from
> todays point of view:
> - only needs one bit set to 1 in the seed, needs no warmup, when
>   seeded with splitmix64.
> - Also has statistical evaluation, like LFSR113.
> - Passes BigCrush in TestU01.
> 
> The code got smaller, because some edge cases are ruled out now.
> I kept the test vectors and adapted them to this RNG.
> 
> Signed-off-by: Markus Theil <theil.markus@gmail.com>

...

> diff --git a/lib/random32.c b/lib/random32.c

...

> +/**
> + * prandom_seed_state - set seed for prandom_u32_state().
> + * @state: pointer to state structure to receive the seed.
> + * @seed: arbitrary 64-bit value to use as a seed.
> + *
> + * splitmix64 init as suggested for xoshiro256++
> + * See: https://prng.di.unimi.it/splitmix64.c
> + */
> +void prandom_seed_state(struct rnd_state *state, u64 seed)
>  {
> -	/* Calling RNG ten times to satisfy recurrence condition */
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(state->s); ++i) {
> +		seed += 0x9e3779b97f4a7c15;
> +		u64 z = seed;
> +		z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9;
> +		z = (z ^ (z >> 27)) * 0x94d049bb133111eb;
> +        state->s[i] = z ^ (z >> 31);

nit: The indentation seems off here.

> +	}
>  }
> +EXPORT_SYMBOL(prandom_seed_state);

...
