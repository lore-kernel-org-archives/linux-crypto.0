Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6771F8BF8
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 06:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707979199; cv=none; b=PGKXggk8cTewFMaEUzTryYB78qeGpOlTcVRbnpHhri3QRI5Q7TPmfGl/2Tq8uCdOn5AoopfFD9l/DSrFj6nZFyOIFLiqln5GkDrMyLsnwt2+rZi5N7V9j4MycFu7BR5m1CpyPiq32HI90nRE0d/g8+7QzzRj5v2KkDfnTY7Fw3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707979199; c=relaxed/simple;
	bh=zSWOxHiTEuLfZnTsQbzEGR7Gy3pKR5e/aSozLUS06VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aevhDSy27eo5jyILj1LNAKkYmt+E+7VcRF8HLXY+IiXvaunfvFuFO76MnDASLtvq717oXu3ptXeB1FN0i3o7e8L6hOA4jHlFsX+YZTjXs8u/CFoP4kd6dl2XtlZFJvS3eXFxWQjGgFbFc0B9hk9dFmfbE+yxNejPaUh5hxj19wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raVPT-00Dppb-H0; Thu, 15 Feb 2024 14:39:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 14:40:05 +0800
Date: Thu, 15 Feb 2024 14:40:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 01/15] crypto: skcipher - Add tailsize attribute
Message-ID: <Zc2xxZAKrGGkU4id@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <39cd9244cd3e4aba23653464c95f94da5b2dc3ec.1707815065.git.herbert@gondor.apana.org.au>
 <20240214234413.GF1638@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214234413.GF1638@sol.localdomain>

On Wed, Feb 14, 2024 at 03:44:13PM -0800, Eric Biggers wrote:
>
> > diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
> > index 0b6dd8aa21f2..2a602911f4fc 100644
> > --- a/crypto/lskcipher.c
> > +++ b/crypto/lskcipher.c
> > @@ -300,6 +300,7 @@ static void __maybe_unused crypto_lskcipher_show(
> >  	seq_printf(m, "ivsize       : %u\n", skcipher->co.ivsize);
> >  	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
> >  	seq_printf(m, "statesize    : %u\n", skcipher->co.statesize);
> > +	seq_printf(m, "tailsize     : %u\n", skcipher->co.tailsize);
> 
> Do we really want to add new attributes like this to /proc/crypto?
>
> I worry about userspace starting to depend on these algorithm attributes in a
> weird way.
> 
> What is the use case for exposing them to userspace?

Well this particular parameter is needed for user-space apps to know
whether their next read will block or not.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
