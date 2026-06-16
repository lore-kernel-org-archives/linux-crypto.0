Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8021448E0;
	Tue, 16 Jun 2026 04:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781585514; cv=none; b=Lh+HhOQxpzidvt9Fl0UsodO0iTgCRR7w6Q8hwAqnVnYOrhEIx+dg+sCaPyuE/LhmLdueU7o2kPxlhnQSigr1tYSj5Ij57Fe6oCSx9+WhWW3TsX2ToTxArEKORL7L5f8+s5mKWebPo9evPHfEhHnWvrcxtSH5AmWpEUi2devk3jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781585514; c=relaxed/simple;
	bh=CDe3fP83zvxWYTUtNEfNFBErP1of+id1fhWVjf93Q9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CskXQo6yGG53zE1+pyoo+euZXc7j7XH6QKRvIUdk4yZEhSlIn3cIIEUzY3LhW5d/uhdJfobMPiMXBtJLMWgh07d+X8iea2369kAdV9MxoFORSsCjOLF8v9u4/UCERCSTXgaIt60fnTAkUJGBIAZ5k0qrBK4sAV49DZZNJCfaNHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMwo2yh0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMwo2yh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ECB1F000E9;
	Tue, 16 Jun 2026 04:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781585512;
	bh=EYZQNXEAHS+yGmR3jEboZ3cP60eSiYFi0WDQBnHMECI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dMwo2yh0fYx0tzSOvW6JigGmOTTMCGUydxb3M1bv5/meEuSFb5CXp2nFuBpmSEQ/A
	 xDbaTxvLf4qZ0ruZqJBkEInHP5xpU9kXVcHgIYBwEU3phGNIJKJsY27ZqtY6DJCK6w
	 SqL0CmEvEm+5E6Z/6UpEHDwHlSsF5tSTCwhmFm6xQdMu8abxnTPJB59SQdzGhM43FS
	 DmY7Siel5TIkBmUtIBk7mDkB0npIMGJnj7wceXPAeXUvRcB4CO5qPZFLvvkI52RUza
	 i0DpvAtBMqy37GQOQzOSlPTUZceKqbSwhZ4zIteZjGltrQiaOUd5SbxScgqwXET8zs
	 ddmRybaWSBSXQ==
Date: Mon, 15 Jun 2026 21:50:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Leonid Ravich <lravich@amazon.com>, Alasdair Kergon <agk@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Horia Geanta <horia.geanta@nxp.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit
 batching
Message-ID: <20260616045023.GA113934@sol>
References: <20260615111459.9452-1-lravich@amazon.com>
 <20260615225317.GB28589@quark>
 <ajDNT5jVGgRtiNH6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajDNT5jVGgRtiNH6@gondor.apana.org.au>

On Tue, Jun 16, 2026 at 12:13:03PM +0800, Herbert Xu wrote:
> On Mon, Jun 15, 2026 at 03:53:17PM -0700, Eric Biggers wrote:
> >
> > So in other words, this series slows down dm-crypt and crypto_skcipher
> > for everyone to optimize for an out-of-tree driver.  And there's also no
> > benchmark showing that your driver is even worth it over just using the
> > CPU.
> 
> There is no reason why the software fallback should be slower
> than the status quo.  Existing callers of the Crypto API will
> be issuing one indirect function call per data unit.  With the
> new scheme, the indirect calls per unit moves from from the caller
> into the Crypto API.

Have you checked the code?  This patchset adds overhead in multiple
places.  Dynamically allocating multiple scatterlists and then parsing
them, adding a new field to skcipher_request for everyone, new checks in
crypto_skcipher_en/decrypt for everyone, new checks to validate the data
unit size that the caller knew was valid in the first place, etc.

> In fact, we could move it down further and improve upon the
> status quo by splitting the data in each algorithm implemntation
> so that the calls per unit become direct function calls and only
> the overall call into the Crypto API remains indirect.

That's not what this patchset does.  But also, as we know, a better way
to eliminate "Crypto API" overhead is to call the algorithms directly.

- Eric
