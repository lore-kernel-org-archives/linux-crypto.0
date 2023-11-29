Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407FA5DF34
	for <linux-crypto@vger.kernel.org>; Wed, 29 Nov 2023 21:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qquxI+wI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1745C433C8;
	Wed, 29 Nov 2023 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701291862;
	bh=/o5a4nfDEoRYUg8eNQ+jUw6KM0gP1yZnCE4P1jOIGn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qquxI+wIjSokMpA5LkqaZ0pDFu5NR2GuhZQfQboj2U61zHZuAOKGVd3QOSl+UWqxM
	 C3zStFxNL4jRSDAKFklMQFkW8HlxIAbnCCkzgjMBlQB3o8+e6PKhzJKvUjx49ZGhEw
	 ETds7I6Zj7a6dhT+/jqq4wq3flmAs1okOqDl/nKKqo2rvxRH8XccWMRjD8DZ6NegBx
	 VEHHQwT+Lfdv8sQOTySZW7cTpvwhVmWM0pZ1EEftu4l55gepU11E0RBn0oS+15ClTd
	 IzjacRjl6ejMT7dulEjrEFkao8o41e1DMEQwb13vb3CX0tKioleFAXBjF3dTTkofsS
	 8uAsW6JOb9oYg==
Date: Wed, 29 Nov 2023 13:04:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/4] crypto: Fix chaining support for stream ciphers
 (arc4 only for now)
Message-ID: <20231129210421.GD1174@sol.localdomain>
References: <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
 <20231117054231.GC972@sol.localdomain>
 <ZVctSuGp2SgRUjAM@gondor.apana.org.au>
 <ZWB6jQv4jjBTrRGB@gondor.apana.org.au>
 <20231127222803.GC1463@sol.localdomain>
 <ZWbZEnSPIP5aHydB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbZEnSPIP5aHydB@gondor.apana.org.au>

On Wed, Nov 29, 2023 at 02:24:18PM +0800, Herbert Xu wrote:
> On Mon, Nov 27, 2023 at 02:28:03PM -0800, Eric Biggers wrote:
> >
> > As far as I can tell, currently "chaining" is only implemented by CBC and CTR.
> > So this really seems like an issue in AF_ALG, not the skcipher API per se.
> > AF_ALG should not support splitting up encryption/decryption operations on
> > algorithms that don't support it.
> 
> Yes I can see your view.  But it really is only a very small number
> of algorithms (basically arc4 and chacha) that are currently broken
> in this way.  CTS is similarly broken but for a different reason.

I don't think that's accurate.  CBC and CTR are the only skciphers for which
this behavior is actually tested.  Everything else, not just stream ciphers but
all other skciphers, can be assumed to be broken.  Even when I added the tests
for "output IV" for CBC and CTR back in 2019 (because I perhaps
over-simplisticly just considered those to be missing tests), many
implementations failed and had to be fixed.  So I think it's fair to say that
this is not really something that has ever actually been important or even
supported, despite what the intent of the algif_skcipher code may have been.  We
could choose to onboard new algorithms to that convention one by one, but we'd
need to add the tests and fix everything failing them, which will be a lot.

- Eric
