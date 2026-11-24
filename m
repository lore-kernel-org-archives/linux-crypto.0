Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558158;
	b=UqHWkZN4S39cpF+aN87A8kTjnFDJy4t+oyDvjBZPilrBJt4rqydCA3m9XVrTUxAOCdeF
	 JLodgo6L7ETEQ5/kRJAdo5cNyruzvv/oTpyBtXv50zxA4GhxmiyCfuEU2ea1D1sePvvk2
	 hgtPyxxtyvKjFKnw42LUYD4zjtIuPhmababboQYVkpBv7O5Nbj0MsV2GHQQqaqivqJQtS
	 1aOMseGkPEcsJAyyQ9CfKOl20XySNJXIuaghXhwqBj2uBpD4LtrgeCQS4IwsM1kJOpiBZ
	 RI3LaXaVjyfiLlfgbL1KciqBNBkIA64SEScUpG6i5ptQGxwOFZhXPDvlSeMS1ejt95A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558158;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lUuj/Y6wOVZtmwHgP4+/UEb7LXrLLClkrKGeWeDx+eI=;
	b=UJIskd5Aemp4dHxT2nC29Jl6h5nlMbNQiDn3XlDxhkrRVoiqdfbGlPnGZTE3mujZHYWv
	 UW6wCwD8okQI9V0+By1VLTolnNq1Cn/5CSCSc9e4usYAe8lUwPYeUJvY8YaK0RVz/1Wtd
	 0mhFs5beyUgEKErCcNQxCsTp7O3F7k7EXCLJUwxO//IYY3YCJiystfhvIDrRyuvmsVfQu
	 rugg0Tfb/rWJtADKasAEfzsqgafFOx6OEhX1jayKnyEDWEKl/4ngCtj3bHOHcxfc/aJrr
	 aqR3mrBr5KF9voiVZOjDUV5E05KbgVCD0XRaNN61YEjBUdqEku4uy1TTuIsYsbacWew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EobdNwq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 411B6606A31E;
	Tue, 24 Nov 2026 22:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EobdNwq0
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F1D81F000C0;
	Tue, 24 Nov 2026 22:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795558157;
	bh=lUuj/Y6wOVZtmwHgP4+/UEb7LXrLLClkrKGeWeDx+eI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EobdNwq0XFrXRfmZajs7bbG74i4Re6S8ODnQDetAu5BfFTs7Px15bLs2ypdGHCytT
	 BL7oY60Q/rBtrpeWOlgH1CJUtEovaXYYRHkFq9wb9mFTKQ4wZIU9HwshFXJeLxeJue
	 zULkzPY1A7XYb8xACMxHs57BjXXMEzY0qyDnFJW6Zwq50A9odHxHAavwHvWp4wFFOJ
	 cbUTKxbmzaYDbyEMROVvlPj1xecJA1KUFCAJTV4wvv9TTGlc6MLiFMYkv8VJFGfZiV
	 U3zw/ELW4Wn3qClz6DKfZDgzECTW1zRkq+yLpARdbf7JmKwZimNRAZuiz1c2TkiFv2
	 yYJsJs8wiYiHA==
Date: Wed, 25 Nov 2026 00:09:14 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 6/9] KEYS: Factor out KEYCTL_PKEY
Message-ID: <awYLCuCIG8--aa2Z@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-7-jarkko@kernel.org>
 <20261124215035.GE2227373@google.com>
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
In-Reply-To: <20261124215035.GE2227373@google.com>

On Tue, Nov 24, 2026 at 09:50:35PM +0000, Eric Biggers wrote:
> On Tue, Nov 24, 2026 at 09:40:40PM +0200, Jarkko Sakkinen wrote:
> > diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> > index c73979b2e98e..1c78a9a663c5 100644
> > --- a/crypto/asymmetric_keys/Kconfig
> > +++ b/crypto/asymmetric_keys/Kconfig
> > @@ -2,6 +2,7 @@
> >  menuconfig ASYMMETRIC_KEY_TYPE
> >  	bool "Asymmetric (public-key cryptographic) key type"
> >  	depends on KEYS
> > +	select KEYCTL_PKEY
> >  	help
> >  	  This option provides support for a key type that holds the data for
> >  	  the asymmetric keys used for public key cryptographic operations such
> 
> Could we use this opportunity to give CONFIG_KEYCTL_PKEY an
> off-by-default prompt like CONFIG_KEY_DH_OPERATIONS, please?  There are
> a lot of systems that need ASYMMETRIC_KEY_TYPE for verifying signatures
> but don't the KEYCTL_PKEY keyctls.  The fact that the KEYCTL_PKEY
> keyctls get pulled in too has always been a huge problem, given the
> additional attack surface they expose as well as other issues like the
> kernel's RSA code not being resistant to timing attacks.

We can do that.

> 
> - Eric

Br, Jarkko
