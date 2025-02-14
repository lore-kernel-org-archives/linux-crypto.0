Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E248635A;
	Fri, 14 Feb 2025 02:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739501099; cv=none; b=AUHZ2c/W66T9EsS1VhqvBmU+sdAURpMeD8U4rWteYYNwN0a5eVzvIZXteKc8Yx8YvgbXFe9i0xk9wuymyv2KBBGy78xOndIfiZFETUFinUQWK8Tsw7Hu6/kOXoNg/4qReylSMokAws2VbGGbMRtTXhAazVqgMlwnm20VaTutnAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739501099; c=relaxed/simple;
	bh=WGPoqVRqUNUupOPvcUF75S6imIM0F94i8SNoD5PoDN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLOicXx/kXG+VH6kdbetg/gv9f6iMsXC+9TRky2w9v1dHd1NfOg6xVtlJPE/NNwSD7tBEhgqNavW7BWoghdLRsJfMFwxX3FT0Vz6mTGd6tgU5vqJWaLYvR7eGFeZBfo69F1iZhnrG37DBBNOiT+999v+jZJrfC4t6FNKiUGk3BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=crG3z6Nx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="crG3z6Nx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=65T4rBQvy6mFilnie1q3glh+nsrM26bK761iT5MKkEQ=; b=crG3z6NxOhqIo4edos2ddK19x9
	hWQSi3nAdhK010ZkcRwyeT/b7++m63S5YNZcODozEpBJOgP/hasAC3UwlWnFjWlOcuxZl6tHYs4l6
	6CdnKwqrBKWVhX/71+itsWvFCZPIi5xG1gs60s6n4iM2+RSM+EG2zasTj5Py8FPoAqUifwAFUeSF7
	jz3SIn2+ft0+9dsPngX+XYAY40kD7KeiEKr2GMLKn4zN7UML+XlDViVY9nEWPOxDqUIKfr4y2IiG8
	uHyVA8/XvOed0PTCNxcEp+sHeenwZAK2TFyGrWhXuNWJe+/SMmo5c/8xDxp+RWJ+TWkWRU6yqFsJt
	i0IQW4xQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tilUE-000DGZ-2e;
	Fri, 14 Feb 2025 10:44:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Feb 2025 10:44:47 +0800
Date: Fri, 14 Feb 2025 10:44:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-crypto@vger.kernel.org,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer
 hashing
Message-ID: <Z66uH_aeKc7ubONg@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213063304.GA11664@sol.localdomain>

On Wed, Feb 12, 2025 at 10:33:04PM -0800, Eric Biggers wrote:
> 
> I've already covered this extensively, but here we go again.  First there are
> more users of shash than ahash in the kernel, since shash is much easier to use
> and also a bit faster.  There is nothing storage specific about it.  You've
> claimed that shash is deprecated, but that reflects a misunderstanding of what
> users actually want and need.  Users want simple, fast, easy-to-use APIs.  Not
> APIs that are optimized for an obsolete form of hardware offload and have
> CPU-based crypto support bolted on as an afterthought.

The ahash interface was not designed for hardware offload, it's
exactly the same as the skcipher interface which caters for all
users.  The shash interface was a mistake, one which I've only
come to realise after adding the corresponding lskcipher interface.


> Second, these days TLS and IPsec usually use AES-GCM, which is inherently
> parallelizable so does not benefit from multibuffer crypto.  This is a major
> difference between the AEADs and message digest algorithms in common use.  And
> it happens that I recently did a lot of work to optimize AES-GCM on x86_64; see
> my commits in v6.11 that made AES-GCM 2-3x as fast on VAES-capable CPUs.

Bravo to your efforts on improving GCM.  But that does not mean that
GCM is not amenable to parallel processing.  While CTR itself is
obviously already parallel, the GHASH algorithm can indeed benefit
from parallel processing like any other hashing algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
