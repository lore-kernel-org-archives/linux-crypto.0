Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D364DD2E4
	for <linux-crypto@vger.kernel.org>; Fri, 17 Nov 2023 05:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtxSaE7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFBC433C7;
	Fri, 17 Nov 2023 05:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700199753;
	bh=S9dNt7ZOYbC1iee2trtrwbsJ/Ko5JOnzMwlVQNF0HPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YtxSaE7PC/mnKDKuyd2+8N5AX+etT8u0KnvfcihDuNG7+tIJN8Q5gPwz4UNWKtjwq
	 O50x6QewNZ+Ru1YsCBFrVEaeNcjKHyD+ZOmjCMLKJmpFx8Nk06fBBGvTWMAudaVXdD
	 IzSKmsCRRh5mzx2jMAQowxeQGzhkSw/dKZR9GK6g9MYOys3vY5qGdMgwtCJqDKve6/
	 OuIF3RdxBwkt2bUJ4m43ChGj8Jof+YYWQh4Lp+RqopKvNi9iT5AmoekAPlcB61zi+w
	 w2+kPPfHNL2EKI5K7DWCXaSICfRheMz+pjnwb7VP7w32eEKk4eBd9cPXJt4iwc2WI4
	 SVB5tQygfR7JA==
Date: Thu, 16 Nov 2023 21:42:31 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <20231117054231.GC972@sol.localdomain>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVb38sHNJYJ9x0po@gondor.apana.org.au>

On Fri, Nov 17, 2023 at 01:19:46PM +0800, Herbert Xu wrote:
> On Thu, Sep 21, 2023 at 08:10:30PM -0700, Eric Biggers wrote:
> >
> > Well, IV is *initialization vector*: a value that the algorithm uses as input.
> > It shouldn't be overloaded to represent some internal intermediate state.  We
> > already made this mistake with the iv vs. iv_out thing, which only ever got
> > implemented by CBC and CTR, and people repeatedly get confused by.  So we know
> > it technically works for those two algorithms, but not anything else.
> > 
> > With ChaCha, for example, it makes more sense to use 16-word state matrix as the
> > intermediate state instead of the 4-word "IV".  (See chacha_crypt().)
> > Especially for XChaCha, so that the HChaCha step doesn't need to be repeated.
> 
> Fair enough, but what's the point of keeping the internal state
> across two lskcipher calls? The whole point of lskcipher is that the
> input is linear and can be processed in one go.
> 
> With shash we must keep the internal state because the API operates
> on the update/final model so we need multiple suboperations to finish
> each hashing operation.
> 
> With ciphers we haven't traditionally done it that way.  Are you
> thinking of extending lskcipher so that it is more like hashing, with
> an explicit finalisation step?

crypto_lskcipher_crypt_sg() assumes that a single en/decryption operation can be
broken up into multiple ones.  I think you're arguing that since there's no
"init" or "final", these sub-en/decryptions aren't analogous to "update" but
rather are full en/decryptions that happen to combine to create the larger one.
So sure, looking at it that way, the input/output IV does make sense, though it
does mean that we end up with the confusing "output IV" terminology as well as
having to repeat any setup code, e.g. HChaCha, that some algorithms have.

- Eric
