Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AA3B67E
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 06:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707979917; cv=none; b=D8B+jFkgcpjAzkHk71JVk/MkRO75Pl6QXyXNIkEqNCV9ObaAyxARBW0gnpXnjV5bC9Izrg/frR+Ug5R+l9EO4wOpkumZALZB9SItUWLZcQxRdeaJpBUkSCZTCbwF8h1Ot/vlm9CkfCcTjLqGgfylOrmxhcsMgaRxtxnPs1UdU4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707979917; c=relaxed/simple;
	bh=3f1DVHN1YHA21G8RTBQTZBmH/bafHM/CnmL4dBIjLEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9uZuSu7KXDnNNqZUZd04hhui3k8EIOhTNhh19b0b9g6WU9mlMe7vBxPyS4hzUro/IT6BG6kCR4NbA2O+2yE+9WS9embfhZ7jvpYzvWjIr2AmQJFmAoINu+yjXim8wdq++mZe4GGFBRy6dYmHE/ZGU3epKCma4YHa7cJQ7oclos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raVb4-00DpzX-4d; Thu, 15 Feb 2024 14:51:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 14:52:04 +0800
Date: Thu, 15 Feb 2024 14:52:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/15] crypto: chacha-generic - Convert from skcipher to
 lskcipher
Message-ID: <Zc20lNlotnAW9e9P@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <1585df67b3f356eba2c23ac9f36c7181432d191e.1707815065.git.herbert@gondor.apana.org.au>
 <20240214234151.GE1638@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214234151.GE1638@sol.localdomain>

On Wed, Feb 14, 2024 at 03:41:51PM -0800, Eric Biggers wrote:
> On Wed, Dec 06, 2023 at 01:49:32PM +0800, Herbert Xu wrote:
> > +static int chacha_stream_xor(const struct chacha_ctx *ctx, const u8 *src,
> > +			     u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
> 
> In cryptography, siv normally stands for Synthetic Initialization Vector.  I
> *think* that here you're having it stand for "state and IV", or something like
> that.  Is there a better name for it?  Maybe it should just be state?

Thanks, I'll change this to ivst.

> So the "siv" contains xchacha_iv || real_iv || state?  That's 112 bytes, which
> is more than the 80 that's allocated for it.

Correct, it's 112 bytes.  The caller is meant to allocate enough
space for the IV and state: 32(ivsize) + 80(statesize).

> Isn't the state the only thing that actually needs to be carried forward?

Some algorithms (statesize == 0) will carry all their state in
the IV, e.g., cbc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
