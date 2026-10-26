Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793040436;
	b=b/e7JLg/PRt6hQHOSacNPG7ztDHhpmDOJyiT1b8gxt+cg4SQiZ9e2O3c/FQRRXQTB+kw
	 /o0rVqBBd6FKVLjPn6K45yhcQTC2uDtgCIhJ/atdIqfdW2DCx/DaNBk3AhJOyFJq5mCWg
	 T8IWI1uoNnogb7A5MomcGi2FvTP6eunF6DoNOeS2EgyRbl3VjegYbOtgWnefHLtbJUhpP
	 LL9vxKSDavrP8Th0JYmmpOkKF2fmjcVDAU4GogETp3R1lRts4034mcigbsoBshlzzU8w+
	 RWT1N6coruiVVB9++52klAXLVgG52PMJWgDEtq4pRd/at8SGGUBCDcGI1b9aCwPoShg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793040436;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=U//eGvYDF2+/yYUB5pO51EtZ64gK1iprB2hzIuimqus=;
	b=LFbOKw8fAi37fuR1c8KUWVZ/EDuAGwp5VL2nz/qheUBirGy8yugkDVY2LjyVFnFLxiab
	 af3N/PCPSS3/WXhUMOGj4FpalhfZB1jWBLoWxHlsfwZiTHeb9WeB9RNGo+7gB/OMRf+Iv
	 yQ6F9CpiQz0qK5EHtlboORqkfWXTGBh5vWOylmo4fY1ybLXDF5uu98foEXPW+vv+OtFv+
	 4uhCwgy0ek24QGP2rtteRQurdEyeUI3F9KTtmpVw+gW8MmPIqg0PdME69r4xyateFG0gD
	 5YIjb2XJFv9jJ95BuZjAXCQVGuvj1InK2Eiu/41Nx4esRidRA6zOI/QzcUcYN4xMR/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7BZuj4H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4466C606A31A;
	Mon, 26 Oct 2026 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7BZuj4H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB301F01825;
	Mon, 26 Oct 2026 18:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793040436;
	bh=U//eGvYDF2+/yYUB5pO51EtZ64gK1iprB2hzIuimqus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j7BZuj4HerJfS21FoyC8+8SuiNC4IVV6qP3vjQELuaNqFNONlo3huyIk2dFtHEHZo
	 qYhnU+gCJ7PLVabMK6xmy/5nZ9Ef0Cii1VWo1jh/eMvEzsseVz+fIfS1R7XAGNFJaL
	 4G/sTBvTW6Vd2qd5plxVPe1WwdtsVgFiFPz61phz8n5DBGC7zuvECXjYgGFpWeMQym
	 jfxAdWGR3dckQvvYd5DMogiaae70ChnaTcsjnAzJf/GT571UAcEhF+DssmjkJ4aJu6
	 DiR7IAMvtbf0JLuH1MHaiX4iATFbtZJFSbW5Y3KRv/DcFAZCfvEft4KcfnA8GSE2x3
	 Pg36Cbh7s1qyg==
Date: Mon, 26 Oct 2026 11:47:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] raid6: simplify CPU feature checks
Message-ID: <20261026184714.GB1876@quark>
References: <20261025191207.86590-1-ebiggers@kernel.org>
 <20261025191207.86590-4-ebiggers@kernel.org>
 <20261026145704.5601466f@pumpkin>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026145704.5601466f@pumpkin>

On Mon, Oct 26, 2026 at 02:57:04PM +0000, David Laight wrote:
> On Sun, 25 Oct 2026 12:12:07 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Remove unnecessary checks for features that are prerequisites for other
> > features, such as AVX which is a prerequisite for AVX2.
> > 
> > (Note: in most cases arch/x86/kernel/cpu/cpuid-deps.c warns about
> > missing prerequisites rather than enforcing them.  This is intentional,
> > and it does not mean the prerequisites should be checked elsewhere.)
> > 
> > Then, move the raid6_recov_algo_add() lines into the appropriate places
> > just above so that the same CPU features aren't checked multiple times.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  lib/raid/raid6/x86/pq_arch.h | 51 ++++++++----------------------------
> >  1 file changed, 11 insertions(+), 40 deletions(-)
> > 
> > diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
> > index 4a863b253b909..418e4d4a2930f 100644
> > --- a/lib/raid/raid6/x86/pq_arch.h
> > +++ b/lib/raid/raid6/x86/pq_arch.h
> > @@ -16,63 +16,34 @@ extern const struct raid6_recov_calls raid6_recov_ssse3;
> >  extern const struct raid6_recov_calls raid6_recov_avx2;
> >  extern const struct raid6_recov_calls raid6_recov_avx512;
> >  
> > ...
> >  static __always_inline void __init arch_raid6_init(void)
> >  {
> > -	if (raid6_has_avx2()) {
> > +	if (boot_cpu_has(X86_FEATURE_AVX2)) {
> >  		raid6_algo_add(&raid6_avx2x1);
> >  		raid6_algo_add(&raid6_avx2x2);
> >  		if (IS_ENABLED(CONFIG_X86_64))
> >  			raid6_algo_add(&raid6_avx2x4);
> > -		if (raid6_has_avx512()) {
> > +		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&
> > +		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
> > +		    boot_cpu_has(X86_FEATURE_AVX512DQ)) {
> >  			raid6_algo_add(&raid6_avx512x1);
> >  			raid6_algo_add(&raid6_avx512x2);
> >  			if (IS_ENABLED(CONFIG_X86_64))
> >  				raid6_algo_add(&raid6_avx512x4);
> > +			raid6_recov_algo_add(&raid6_recov_avx512);
> > +		} else {
> > +			raid6_recov_algo_add(&raid6_recov_avx2);
> 
> Is that right (you haven't changed it)?
> You get both the avx2 and axv512 normal algorithms, but only one
> of the recov ones.
> 
> I presume these are added in addition to the generic C code and
> some startup test decides which is fastest and so used?

Yes, it's unchanged from before.

The raid6 library implements runtime benchmark-based selection for
struct raid6_algo, but not for struct raid6_recov_algo where only one
can be registered.  As always, you're welcome to check the code rather
than speculate; see lib/raid/raid6/algos.c.

Yes, it's inconsistent.  However, changing that is outside the scope of
this series.  (FWIW, none of the crypto or CRC code uses runtime
benchmark-based selection.  I think it's not worth it.)

- Eric
