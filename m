Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E18D53C;
	Thu,  3 Apr 2025 02:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743646498; cv=none; b=SHM6VNyv+wXoKudB3Ox3qDFPcm009LxZJbPiWvUfZ4V60H3M1k8rMdruZO2cwhni38AqKiSBSXp+NCb5hvrW5v1+DZCr3gqs2qVo01rnJs6CQBmgR4GDmFNcAdspaXElBbuyTcyve4FCCeQSTqnhNo0ShKyw+SpXd/FSrMx9nJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743646498; c=relaxed/simple;
	bh=ohUdiALX3TVu9ruR9N6SrCug5+ZDXXSpI9Wx76zbLzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAw/cF2JL0mZwrtNX9KkVj7+xyYFJYyFqHfLRMHXkiQWWsVDwbj3Pw5Z7vssvaeQtO1+hGLierb1pBfOmlHRhwG9HZVK4Kyr2OD0BdSXWmjyXFaavoU3yXXncPOxQWr828jshB7+CWu2X3nT4OV3nT7vma2lapt9/OXKYH4wtSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wi8YY+RK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wi8YY+RK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A11DC4CEDD;
	Thu,  3 Apr 2025 02:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743646495;
	bh=ohUdiALX3TVu9ruR9N6SrCug5+ZDXXSpI9Wx76zbLzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wi8YY+RK/IRCaQWpmm2LJuCf1JCitHvJRs8Cci3FFBCMxjm3vXJtv0l0CIjAqnV07
	 CPX8z+Aa8BVbG7R28/9OaNDSAQGGALdAXOmqJ/GwgSZGN8N4BdeoQwXdoYAk9i40V/
	 ae8wRjlF2RavV2qPUt1NAVPyjhJQ/lfyMpzvgWkEVBau7+a8vNFDMw5fv5qlkdqkuZ
	 4vEE8Xb39zPql6jgXdvpnoovtkmiFjqPXGgurkMKeyfzfBaMe2ncNF+GfEtOdd+M1v
	 dAIDqkFokX9M/iCeWp31ltkx5OL7MAYHB9fMlLJJ3C0SDM33E6zi3zPyqARzJDc6wW
	 KvWx4PHLXgmGg==
Date: Thu, 3 Apr 2025 02:14:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <20250403021453.GA2872965@google.com>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>

On Thu, Apr 03, 2025 at 09:25:37AM +0800, Herbert Xu wrote:
> On Wed, Apr 02, 2025 at 10:19:30AM -0700, Eric Biggers wrote:
> >
> > This seems premature.  crypto_shash is documented to be usable in any context.
> > See the "Context:" comments in include/crypto/hash.h.  Similarly, developers
> > expect lib/ functions to be available in any context unless otherwise
> > documented.
> 
> Doing slow computations in a hard IRQ is a bad idea.  The whole
> point of a hard IRQ handler is to set a flag and defer everything
> to a different context.
> 
> Please show me one good reason why we should allow crypto in
> a hard IRQ.
>  
> > IMO, doing it for lib/ too would be going too far though.  The lib/ functions
> > should be easy to use and not have random requirements on the calling context.
> > And since they're just functions, it's easy for them to fall back to the generic
> > functions when needed.  Also note that for very short inputs it can actually be
> > faster to use no-SIMD code, as that avoids the overhead of a kernel-mode SIMD
> > section.  So the fallback sometimes exists anyway for that.
> 
> We already disallow SIMD in hard IRQs anyway (may_use_simd is
> always false in that context).  The only thing you could use
> is the generic implementation.
> 
> So making this change in lib/crypto does not take any functionality
> away.  You could still invoke the generic lib/crypto code directly.
> 
> It does mean that we take away a completely useless check for
> people who are actually doing crypto because crypto work should
> never be done in a hard IRQ.

It's not the 90s anymore.  Crypto is fast now, and used ubiquitously.

And "crypto" doesn't necessarily mean a large operation.  It can be hashing just
a few bytes of data, for example.

Also as you know, the crypto API includes some non-cryptographic algorithms too.

BTW, x86 does allow SIMD in hardirq context in some cases.

Certainly agreed that crypto in hardirqs is something to be avoided in general,
though.

So maybe your proposal is okay, if it's done properly.

The thing I actually have more of a problem with is that you tend to start
making random API changes without any of the necessary prerequisites like
updating documentation, or adding debug assertions to catch violations of new
requirements.  You've already started removing the fallbacks from shash (commit
3846c01d42526bc31), but neither of those things have been done.  So we're
currently in a weird state where the shash API is explicitly documented to work
in all contexts, but you've broken that.

- Eric
