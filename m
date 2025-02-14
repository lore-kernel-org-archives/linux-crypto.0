Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE1978F34;
	Fri, 14 Feb 2025 03:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739504121; cv=none; b=B1PO/MLHefGNyx58z0KLtWMEUl2gdS8+sNFAZ3tlTYnZrB43gmGuH14QcTiHNFAUaapEjuvH4obminY20ea2/Xu3F2Tk3TAmqTU1DZjjSWw786vedhoEKrpdslHdJnIpFzdkx7S8Sfkn5LBvkSMvtyrwWQfRQWy/saskrsmheK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739504121; c=relaxed/simple;
	bh=GHXJGGSXmO3XdJUVBTnqgXpdPTGoAWBnUJGaHHmw8is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGbvkMi+ecXBfpNTbMflui6HGppxOzs3joThOJdtMq88hWr/B1yXwyw1YANNSJtDkUJrXsDsTgU5z7mVOVcLxZP2FwUy1xzxNCWnDoB+HmlrqPlCviJtIk3zz+jkYEGZBbFpeoayFucVuawxOZh8HMqpqe32m9Ib5+5sQZytrCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGyDKVt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGyDKVt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED176C4CED1;
	Fri, 14 Feb 2025 03:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739504120;
	bh=GHXJGGSXmO3XdJUVBTnqgXpdPTGoAWBnUJGaHHmw8is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mGyDKVt7O7hWki5SZw8ElAlXetpN0kOsRzduxYor4iWe1QnJQ85VsefWpe44PiY4M
	 P47TB51v1WwrqxRGhQg2d/uBRc50Fouh0MY6djzFipYz6npZxpbc08LMijaZsGpL4P
	 rQNSWB2jMm0h6sRZrv/MdxqCgqJSThsyH/bCy5O0dGfk5rKLwnKvUPAAX0+vra9uzr
	 aj+xzi04tOoYx3OrRL4gWF/HI4AXcbV9BSGWRBqwuIhHk4tGlzLjOhI5RmM1/9dr8i
	 pq9I2YOjlYE6fzyDEK79ukA5F5qcLCaWcZ+P34aQhdLFqCj1bjJpzL/d2QpKskawNE
	 S/KnXdysA74bA==
Date: Thu, 13 Feb 2025 19:35:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
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
Message-ID: <20250214033518.GA2771@sol.localdomain>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <Z66uH_aeKc7ubONg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z66uH_aeKc7ubONg@gondor.apana.org.au>

On Fri, Feb 14, 2025 at 10:44:47AM +0800, Herbert Xu wrote:
> On Wed, Feb 12, 2025 at 10:33:04PM -0800, Eric Biggers wrote:
> > 
> > I've already covered this extensively, but here we go again.  First there are
> > more users of shash than ahash in the kernel, since shash is much easier to use
> > and also a bit faster.  There is nothing storage specific about it.  You've
> > claimed that shash is deprecated, but that reflects a misunderstanding of what
> > users actually want and need.  Users want simple, fast, easy-to-use APIs.  Not
> > APIs that are optimized for an obsolete form of hardware offload and have
> > CPU-based crypto support bolted on as an afterthought.
> 
> The ahash interface was not designed for hardware offload, it's
> exactly the same as the skcipher interface which caters for all
> users.  The shash interface was a mistake, one which I've only
> come to realise after adding the corresponding lskcipher interface.

It absolutely is designed for an obsolete form of hardware offload.  Have you
ever tried actually using it?  Here's how to hash a buffer of data with shash:

	return crypto_shash_tfm_digest(tfm, data, size, out)

... and here's how to do it with the SHA-256 library, for what it's worth:

	sha256(data, size, out)

and here's how to do it with ahash:

	struct ahash_request *req;
	struct scatterlist sg;
	DECLARE_CRYPTO_WAIT(wait);
	int err;

	req = ahash_request_alloc(alg, GFP_KERNEL);
	if (!req)
		return -ENOMEM;

	sg_init_one(&sg, data, size);
	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
					CRYPTO_TFM_REQ_MAY_BACKLOG,
				   crypto_req_done, &wait);
	ahash_request_set_crypt(req, &sg, out, size);

	err = crypto_wait_req(crypto_ahash_digest(req), &wait);

	ahash_request_free(req);
	return err;

Hmm, I wonder which API users would rather use?

The extra complexity is from supporting an obsolete form of hardware offload.

Yes, skcipher and aead have the same problem, but that doesn't mean it is right.

> > Second, these days TLS and IPsec usually use AES-GCM, which is inherently
> > parallelizable so does not benefit from multibuffer crypto.  This is a major
> > difference between the AEADs and message digest algorithms in common use.  And
> > it happens that I recently did a lot of work to optimize AES-GCM on x86_64; see
> > my commits in v6.11 that made AES-GCM 2-3x as fast on VAES-capable CPUs.
> 
> Bravo to your efforts on improving GCM.  But that does not mean that
> GCM is not amenable to parallel processing.  While CTR itself is
> obviously already parallel, the GHASH algorithm can indeed benefit
> from parallel processing like any other hashing algorithm.

What?  GHASH is a polynomial hash function, so it is easily parallelizable.  If
you precompute N powers of the hash key then you can process N blocks in
parallel.  Check how the AES-GCM assembly code works; that's exactly what it
does.  This is fundamentally different from message digests like SHA-* where the
blocks have to be processed serially.

- Eric
