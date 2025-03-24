Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBB2189520;
	Mon, 24 Mar 2025 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837543; cv=none; b=tK/J8/Eo7HVvGHkYKNejbZjYgMfVB8Y4ae7H8FhRbMJwSOv9lwd2GiMkFa58W3s4NA5gjgv7Pd4bi9zlptP8el7tSh1KggdiK8E/Q0iswVK4DiqVQTFzZe4s/Sw4salET/i6OmclfRHucpOVSQ/DqrsKo6+u8tBPFmMtCg2MgWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837543; c=relaxed/simple;
	bh=PXftx9fDpmtVIJSUgl+PWTJ178iKomE19+1VW4GE6W8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMleQQqMX1zdkgH1kjHZnJ7AX7aLauYGuFf0vHlCrk6Li+yeuGzZ4jnbiCO+9U359zAgumWjI2VF3teQJNxVKfwZ9AovxwEdsVfySlbGKFyNja4X1uUJ6wXcZJ/29Xr8WT4TcX6t/LyzghpMqs82UNT2RfVfaiFvnY6Um9jA3Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mopi9wAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mopi9wAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4AFC4CEDD;
	Mon, 24 Mar 2025 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742837542;
	bh=PXftx9fDpmtVIJSUgl+PWTJ178iKomE19+1VW4GE6W8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mopi9wAtA6+xseOc27yGzUl008bnLj6qnm8YoGbc40zwR50xGIi6sNcFLqYW5Vaan
	 vOttuSeThLJKkUm/QLuk0jM5ziDDjBNFQHd/AmHK03JUvmf2U46C8cQkk3yskL0Biv
	 ftht1RWKyATfPrzLj2YF0n0PD9LRJIV433nZg20Rd/Ynai01VTzMD+UsNn7WW2TDZK
	 LsmGrg3XcMLOFS8vBwkIaxcvoQfrNzEYOnvfGxg6ctWNkaQ/5hJIgtVMtmDXgZeKBV
	 zHNUqBHPK4gSUBx3g/nxuKsnBgECaCvMOKLK+vzp4/HE/pIDFoICupdFKuJA7WLvlW
	 hxD7fYQ835nSA==
Date: Mon, 24 Mar 2025 17:32:19 +0000
From: Simon Horman <horms@kernel.org>
To: Markus Theil <theil.markus@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, akpm@linux-foundation.org, Jason@zx2c4.com
Subject: Re: [PATCH 2/2] prandom/random32: switch to Xoshiro256++
Message-ID: <20250324173219.GJ892515@horms.kernel.org>
References: <20250214081840.47229-1-theil.markus@gmail.com>
 <20250214081840.47229-3-theil.markus@gmail.com>
 <20250217111806.GJ1615191@kernel.org>
 <8db53465-381f-428a-8fea-7386b4a97557@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8db53465-381f-428a-8fea-7386b4a97557@gmail.com>

On Sat, Mar 22, 2025 at 07:24:57PM +0100, Markus Theil wrote:
> On 2/17/25 12:18, Simon Horman wrote:
> > On Fri, Feb 14, 2025 at 09:18:40AM +0100, Markus Theil wrote:
> > > The current Linux PRNG is based on LFSR113, which means:
> > > - needs some warmup rounds to yield better statistical properties
> > > - seeds/initial states must be of certain structure
> > > - does not pass L’Ecuyer's BigCrush in TestU01
> > > 
> > > While of course, there is no clear "best" PRNG, replace with
> > > Xoshiro256++, which seams to be a sensible replacement, from
> > > todays point of view:
> > > - only needs one bit set to 1 in the seed, needs no warmup, when
> > >    seeded with splitmix64.
> > > - Also has statistical evaluation, like LFSR113.
> > > - Passes BigCrush in TestU01.
> > > 
> > > The code got smaller, because some edge cases are ruled out now.
> > > I kept the test vectors and adapted them to this RNG.
> > > 
> > > Signed-off-by: Markus Theil <theil.markus@gmail.com>
> > ...
> > 
> > > diff --git a/lib/random32.c b/lib/random32.c
> > ...
> > 
> > > +/**
> > > + * prandom_seed_state - set seed for prandom_u32_state().
> > > + * @state: pointer to state structure to receive the seed.
> > > + * @seed: arbitrary 64-bit value to use as a seed.
> > > + *
> > > + * splitmix64 init as suggested for xoshiro256++
> > > + * See: https://prng.di.unimi.it/splitmix64.c
> > > + */
> > > +void prandom_seed_state(struct rnd_state *state, u64 seed)
> > >   {
> > > -	/* Calling RNG ten times to satisfy recurrence condition */
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > -	prandom_u32_state(state);
> > > +	int i;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(state->s); ++i) {
> > > +		seed += 0x9e3779b97f4a7c15;
> > > +		u64 z = seed;
> > > +		z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9;
> > > +		z = (z ^ (z >> 27)) * 0x94d049bb133111eb;
> > > +        state->s[i] = z ^ (z >> 31);
> > nit: The indentation seems off here.
> Shall I resend for this line?

The maintainer may think otherwise.
But in my opinion that would be a good idea.

> > > +	}
> > >   }
> > > +EXPORT_SYMBOL(prandom_seed_state);
> > ...





