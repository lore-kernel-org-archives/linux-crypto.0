Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6853C17
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 08:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707985227; cv=none; b=U0xTgKMaUhxx3D+5jsabqLqAoEjfCejGK4JG2Bb3wSQS2CPRd2qVGPOxKqXEsn9v+DxC6Taz+fiQ8bev4E/VEhXu7mbzvtaVAR6BHDRyPyIW5FPTC07X6gyHgMUsVy6JS21pkOM6Z72YON5C5y8I/u9wVEIow4BGCFyt6REI+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707985227; c=relaxed/simple;
	bh=iVP37YgWcPR6LAjyZ3mIOitug93tJt6aisTvv+BRtYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuDXq9tL7hHQL6Z8tz9FeTW93Sfn5CdzxNYp6pvPGlDejKePX+YdrWq0voLnhTthGR8OoPNLJoAckHX4WDkiBiJdCHy6w0Ki/gAMFUjA1zTq3VgRE9J1KMGBm+iYSZrFanlZlJNZ1a3rYoD6gja4qaG8enTJWCJKVM1zsJzhI+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raWyi-00DrR2-0A; Thu, 15 Feb 2024 16:20:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 16:20:34 +0800
Date: Thu, 15 Feb 2024 16:20:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/15] crypto: Add twopass lskcipher for adiantum
Message-ID: <Zc3JUsRbtzNqMR0p@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <20240214233517.GD1638@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214233517.GD1638@sol.localdomain>

On Wed, Feb 14, 2024 at 03:35:17PM -0800, Eric Biggers wrote:
> 
> Thanks.  Can you include an explanation of the high-level context and goals for
> this work?  It's still not clear to me.  I'm guessing that the main goal is to
> get rid of the vaddr => scatterlist => vaddr round trip for software
> encryption/decryption, which hopefully will improve performance and make the API
> easier to use?  And to do that, all software algorithms need to be converted to

The main goal is to remove the legacy cipher type, and replacing
it with lskcipher.  The vaddr interface is simply a bonus.  In fact
this particular series is basically my response to your questions
about adiantum from that thread:

https://lore.kernel.org/linux-crypto/20230914082828.895403-1-herbert@gondor.apana.org.au/

But yes I will update the cover letter.

> "lskcipher"?  Will skcipher API users actually be able to convert to lskcipher,
> or will they be blocked by people expecting to be able to use hardware crypto
> accelerators?  Would you accept lskcipher being used alongside skcipher?

That's a question for each user to decide.

> Previously you had said you don't want shash being used alongside ahash.

In general, if the amount of data being processed is large, then
I would expect the use of hardware accelerators to be a possibility
and therefore choose the SG-based interface.

I wouldn't consider 4K to be large though.  So it's really when you
feed hundreds of kilobytes of data through the algorithm when I would
recommend against using shash.


> By the way, note that hctr2 requires two passes too, as it's an SPRP like
> Adiantum.  Also note that SPRPs in general may require more than two passes,
> though Adiantum and HCTR2 were designed to only need two (technically they have
> three passes, but two are combinable).  It's fine to support only two passes if
> that's what's needed now; I just thought I'd mention that there's no guarantee
> that two passes will be enough forever.

Right, there is no reason why we couldn't extend this to more than
two passes when the need arises.  The CCM algorithm could also be
implemented in this manner with three passes (although the first
pass is a bit of a waste since it simply tallies up the length of
the input).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
