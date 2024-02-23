Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E606711C84
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 06:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708668091; cv=none; b=mKwKYJjCVd5FLEUPSXGjoZBJtz2kWHICFSLWsj9wbkIXWqXGJTTVKLuJeUcc0j1ieq2h/TgBDryMO50ncWpqjDWEOedbD319/j36g3Q8ksyDphrxF2q7aO8TKNrmlh1mvhn4xeJNovWsfFtFjzqtpBYgyWxjXpJKCwXwhibMseE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708668091; c=relaxed/simple;
	bh=pouxlyhZJsjXiTLw4WeEiNGsIX6y/4tHbvmvS8+mlc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8L1nmd66okPxRTKXXMd/XYBklUye/g87PTKTN3/ZlH7aHjF2xvM4UoSkETaDUYw0RdUlW7hKAF/iunFK9LtoAuYeNCCebpsOD/EIvIhf2ZZJd9rPNjcROf85loee2FfSQgIT3e4UL1g2TB9/j3giCQAh/1782CSd7FJp/k4Iak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsUOq30i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsUOq30i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB96C433C7;
	Fri, 23 Feb 2024 06:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708668090;
	bh=pouxlyhZJsjXiTLw4WeEiNGsIX6y/4tHbvmvS8+mlc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UsUOq30iXP2V5/WDmw2+HGlcc1FUVA62md2Ava2oTkDf3UjDdpNDi5TFUFJTEpyTX
	 RhkwO4Xkbu+CFrAqkSYgTZpYZI7ODvHs3fd81fJJQ1SgXs0ggBcYdbT2MAaL3CXOmd
	 Lanm/5zyGQ6MwSX9QEjqVUTdR/tJKdcrrw0/JGIZR+KN4Vy2Ni1AxoDYFpOyXugX03
	 yx4chrWkVtkktzeG8ymAiDBpBFn2O3ML90hciXL1QbTqFSvwAcROyJCT3tDj/JmSzR
	 YYEQtJrbzzU/E2eEQIP0TvmU6eK0KrMppRsXq1oYm+6yyKFjt8WYpClF3W01jebnYx
	 kcHoGtRHhU95g==
Date: Thu, 22 Feb 2024 22:01:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 01/15] crypto: skcipher - Add tailsize attribute
Message-ID: <20240223060128.GG25631@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <39cd9244cd3e4aba23653464c95f94da5b2dc3ec.1707815065.git.herbert@gondor.apana.org.au>
 <20240214234413.GF1638@sol.localdomain>
 <Zc2xxZAKrGGkU4id@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc2xxZAKrGGkU4id@gondor.apana.org.au>

On Thu, Feb 15, 2024 at 02:40:05PM +0800, Herbert Xu wrote:
> On Wed, Feb 14, 2024 at 03:44:13PM -0800, Eric Biggers wrote:
> >
> > > diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
> > > index 0b6dd8aa21f2..2a602911f4fc 100644
> > > --- a/crypto/lskcipher.c
> > > +++ b/crypto/lskcipher.c
> > > @@ -300,6 +300,7 @@ static void __maybe_unused crypto_lskcipher_show(
> > >  	seq_printf(m, "ivsize       : %u\n", skcipher->co.ivsize);
> > >  	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
> > >  	seq_printf(m, "statesize    : %u\n", skcipher->co.statesize);
> > > +	seq_printf(m, "tailsize     : %u\n", skcipher->co.tailsize);
> > 
> > Do we really want to add new attributes like this to /proc/crypto?
> >
> > I worry about userspace starting to depend on these algorithm attributes in a
> > weird way.
> > 
> > What is the use case for exposing them to userspace?
> 
> Well this particular parameter is needed for user-space apps to know
> whether their next read will block or not.
> 

Can you give a specific example of how this would be useful?

- Eric
