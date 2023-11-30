Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07DFD50
	for <linux-crypto@vger.kernel.org>; Wed, 29 Nov 2023 18:17:25 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8WcD-0057u7-7h; Thu, 30 Nov 2023 10:17:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 10:17:30 +0800
Date: Thu, 30 Nov 2023 10:17:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/4] crypto: Fix chaining support for stream ciphers
 (arc4 only for now)
Message-ID: <ZWfwuklBbOoNSCTs@gondor.apana.org.au>
References: <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
 <20231117054231.GC972@sol.localdomain>
 <ZVctSuGp2SgRUjAM@gondor.apana.org.au>
 <ZWB6jQv4jjBTrRGB@gondor.apana.org.au>
 <20231127222803.GC1463@sol.localdomain>
 <ZWbZEnSPIP5aHydB@gondor.apana.org.au>
 <20231129210421.GD1174@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129210421.GD1174@sol.localdomain>

On Wed, Nov 29, 2023 at 01:04:21PM -0800, Eric Biggers wrote:
>
> I don't think that's accurate.  CBC and CTR are the only skciphers for which
> this behavior is actually tested.  Everything else, not just stream ciphers but
> all other skciphers, can be assumed to be broken.  Even when I added the tests
> for "output IV" for CBC and CTR back in 2019 (because I perhaps
> over-simplisticly just considered those to be missing tests), many
> implementations failed and had to be fixed.  So I think it's fair to say that
> this is not really something that has ever actually been important or even
> supported, despite what the intent of the algif_skcipher code may have been.  We
> could choose to onboard new algorithms to that convention one by one, but we'd
> need to add the tests and fix everything failing them, which will be a lot.

OK I was perhaps a bit over the top, but it is certainly the case
that for IPsec encryption algorithms, all the underlying algorithms
are able to support chaining.  I concede that the majority of disk
encryption algorithms do not.

I'm not worried about the amount of work here since most of it could
be done at the same as the lskcipher conversion which is worthy in and
of itself.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
