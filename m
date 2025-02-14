Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80A1DDC00;
	Fri, 14 Feb 2025 06:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739513522; cv=none; b=kLsS3mmD/HwI6Y969TjC/8WrW60E5cup/+vZJ9QqDvuzSY0RguCyGWnuuDSb44s4MBuOcKL61I1aKa7MniF11cbLjZhQPeP/kdn/FoDdyUmNFduVjGX4hVwOYQRPS6TcMJqN9UgS6tMqhsDxSuLvq9mHMwmf/LfgpbKPV0x1XIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739513522; c=relaxed/simple;
	bh=kjKHneaaDBuIXsWcKyGK0NM3OpIrEwVZV5f1ZO7dz88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5mSfLaPitiAQlr7IcgIErbby68xo/bhUkVIo7aizRIepgMxpwsrzESw2/DzueWrlnIIwCYKld1TjNfMX5oO9ZBzY73gqvUu1ziWqETY38lL10YJmN+TjJ/NyGScUNJ0vat8ytk7FHV+3UcWnkjEFsfRYiniVw3eYDovjH+GKpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNYIiPYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNYIiPYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A4BC4CED1;
	Fri, 14 Feb 2025 06:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739513521;
	bh=kjKHneaaDBuIXsWcKyGK0NM3OpIrEwVZV5f1ZO7dz88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jNYIiPYqj9k89L1AKdVGtNfga4LBPcic0J5cebK2pXX6HgY567bCvRpJVgbuS9m3L
	 WVF/bU4zCZhy8J9rWmbVca5XFTefAOvM1HsSZ9lI6L8eN4cBOQ6JlNTxhsvf4tI9wO
	 Pn3AezEVm4n1xUe/vQOPiVD55BvBVEf4l93S+4V1PD//j6Twur6PjqopS8ehqzdQYQ
	 4tQvvuiao6KylzQ6cKbYYrZ/U1K2mKihuddgDMcbEyfQCOB9j+JLI27W4jZOLqRmEf
	 iT3kd0zNFnUfuG3R99ecdcN7VDDqzkQ7Se2W1QVmsv3//FM+OIV8k36mNLqOC0aune
	 v2GD8WXX8XNIw==
Date: Thu, 13 Feb 2025 22:11:59 -0800
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
Message-ID: <20250214061159.GC2771@sol.localdomain>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <Z66uH_aeKc7ubONg@gondor.apana.org.au>
 <20250214033518.GA2771@sol.localdomain>
 <Z669mxPsSpej6K6K@gondor.apana.org.au>
 <20250214042951.GB2771@sol.localdomain>
 <Z67M6iSoMyvGwkAF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z67M6iSoMyvGwkAF@gondor.apana.org.au>

On Fri, Feb 14, 2025 at 12:56:10PM +0800, Herbert Xu wrote:
> On Thu, Feb 13, 2025 at 08:29:51PM -0800, Eric Biggers wrote:
> >
> > That doesn't actually exist, and your code snippet is also buggy (undefined
> > behavior) because it never sets the tfm pointer in the ahash_request.  So this
> 
> Well thanks for pointing out that deficiency.  It would be good
> to be able to set the tfm in the macro, something like:
> 
> #define SYNC_AHASH_REQUEST_ON_STACK(name, _tfm) \
> 	char __##name##_desc[sizeof(struct ahash_request) + \
> 			     MAX_SYNC_AHASH_REQSIZE \
> 			    ] CRYPTO_MINALIGN_ATTR; \
> 	struct ahash_request *name = (((struct ahash_request *)__##name##_desc)->base.tfm = crypto_sync_ahash_tfm((_tfm)), (void *)__##name##_desc)

I'm not sure what you intended with the second line, which looks like it won't
compile.  The first line also shows that ahash_request has a large alignment for
DMA, which is irrelevant for CPU based crypto.  And I'm not sure
__attribute__((aligned)) with that alignment on the stack even works reliably
all architectures; we've had issues with that in the past.  So again you're
still proposing APIs with weird quirks caused by bolting CPU-based crypto
support onto an API designed for an obsolete style of hardware offload.

> > just shows that you still can't use your own proposed APIs correctly because
> > they're still too complex.  Yes the virt address support would be an improvement
> > on current ahash, but it would still be bolted onto an interface that wasn't
> > designed for it.  There would still be the weirdness of having to initialize so
> > many unnecessary fields in the request, and having "synchronous asynchronous
> > hashes" which is always a fun one to try to explain to people.  The shash and
> > lib/crypto/ interfaces are much better as they do not have these problems.
> 
> I'm more than happy to rename ahash to hash.  The only reason
> it was called ahash is to distinguish it from shash, which will
> no longer be necessary.
> 
> > never use exactly the same API anyway, just similar ones.  And FWIW, zswap is
> > synchronous, so yet again all the weird async stuff just gets in the way.
> 
> I think you're again conflating two different concepts.  Yes
> zswap/iaa are sleepable, but they're not synchronous.  

Here's the compression in zswap:

    comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);

And here's the decompression:

    BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));

It waits synchronously for each request to complete.

It doesn't want an asynchronous API.

> iaa is also useable by IPsec, which is most certainly not sleepable.

The IAA driver doesn't actually support encryption, so that's a very bad start.
But even assuming it was added, the premise of IAA being helpful for IPsec seems
questionable.  AES-GCM is already accelerated via the VAES and VPCLMULQDQ
instructions, performing at 10-30 GB/s per thread on recent processors.  It's
hard to see how legacy-style offload can beat that in practice, when accounting
for all the driver overhead and the fact that memory often ends up as the
bottleneck these days.  But of course for optimal IPsec performance you actually
need adapter-level offload (inline crypto) which does not use the crypto API at
all, so again the legacy-style offload support in the crypto API is irrelevant.

But, this is tangential to this discussion, since we can still keep the legacy
style hardware offload APIs around for the few users that think they want them.
The point is that we shouldn't let them drag down everyone else.

- Eric
