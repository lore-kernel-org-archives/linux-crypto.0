Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3AF2F2B;
	Wed,  5 Jun 2024 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717613896; cv=none; b=F0yYLCs+QmkGRblyOXvJKaorhQ9PQeqI1U+mv5G8bPoxikR/6+QPNgCWfnpMN2dmmwjGiZrjHQ66Jy3s41yw5oeS58hkki+7QnePtkmfjOL15PVFdt2xNkoNfXOB+GAmaCg+xyV4QRULVWFbVPagcdH1gw1lPvlOMX01tELZb0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717613896; c=relaxed/simple;
	bh=vi1o/e9gmwqnbe2LC/NP+cXWDaYTONv/9BSHBsc5bk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEDpKzAWiyV4mFM+iQPQ4wSNFVfsxI8MQUv2M4AOz9xxGZkIitqAqgRI/JIcpIDbsspWlAsgj8xh9anGBtgVMkEyLC2v1xup5VxQPzar5ketuUAo1vY+K8blae9vSBZPYzLuFVHtI4GqMNrB7r69eX4lR/nhnfnxcfmFhqn4BLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4BXj4xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4BXj4xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860D9C2BD11;
	Wed,  5 Jun 2024 18:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717613895;
	bh=vi1o/e9gmwqnbe2LC/NP+cXWDaYTONv/9BSHBsc5bk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M4BXj4xli/ZFwmGLAOvLGljdEnj/zSat1UrSG+Vbc+5Op13rKSxvEJaTy42KV8AO5
	 xj1iZmqMO5Pp1XZ5k0tvoRVBmHUmuJiDTJV7TU+ZuwEEikh/MvScIoXx5Xi55vNSTg
	 V3eAnKLeaUuAmtsEX0Y2TdlSBbYWp0UDH0d0Kjm7YGnQK8U19BJKMJlVBt2ahFLmja
	 rjeKseIaa4nBnYUZbLFUaMc7u0lV4SeFsi7tzq2CsanAEQD3oFZYWkwZxaEzIGLMvW
	 Ac+ggcG/4Q2+jmh84OMMFnb+7tWUHO4U0uyxU8PRIfhnB6SqwF2BhJ1rSaYXnAvrTN
	 PYy60e4x7Wctw==
Date: Wed, 5 Jun 2024 11:58:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240605185813.GA1222@sol.localdomain>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmAthcxC8V3V3sm3@gondor.apana.org.au>

On Wed, Jun 05, 2024 at 05:19:01PM +0800, Herbert Xu wrote:
> On Tue, Jun 04, 2024 at 11:42:20AM -0700, Eric Biggers wrote:
> >
> > This doesn't make any sense, though.  First, the requests need to be enqueued
> > for the task, but crypto_ahash_finup() would only have the ability to enqueue it
> > in a queue associated with the tfm, which is shared by many tasks.  So it can't
> 
> OK I screwed up that one.  But that's not hard to fix.  We could
> simply add request chaining:
> 
> 	ahash_request_chain(req1, req2);
> 	ahash_request_chain(req2, req3);
> 	...
> 	ahash_request_chain(reqn1, reqn);
> 
> 	err = crypto_ahash_finup(req1);

So after completely changing several times your proposal is getting a bit closer
to mine, but it still uses a very clumsy API based around ahash that would be
much harder to use and implement correctly.  It also says nothing about what the
API would look like on the shash side, which would be needed anyway because
ahash is almost always just a pointless wrapper for shash.  Is there a different
API that you are asking for on the shash side?  If so, what?

> > actually work unless the tfm maintained a separate queue for each task, which
> > would be really complex.  Second, it adds a memory allocation per block which is
> > very undesirable.  You claim that it's needed anyway, but actually it's not;
> > with my API there is only one initial hash state regardless of how high the
> > interleaving factor is.  In fact, if multiple initial states were allowed,
> 
> Sure you don't need it for two interleaved requests.  But as you
> scale up to 16 and beyond, surely at some point you're going to
> want to move the hash states off the stack.

To reiterate, with my proposal there is only one state in memory.  It's a simple
API that can't be misused by providing inconsistent properties in the requests.
Yes, separate states would be needed if we were to support arbitrary updates,
but why add all that complexity before it's actually needed?

Also, "16 and beyond" is highly unlikely to be useful for kernel use cases.

> > multibuffer hashing would become much more complex because the underlying
> > algorithm would need to validate that these different states are synced up.  My
> > proposal is much simpler and avoids all this unnecessary overhead.
> 
> We could simply state that these chained requests must be on block
> boundaries, similar to how we handle block ciphers.  This is not a
> big deal.

... which would make it useless for most dm-verity users, as dm-verity uses a
32-byte salt with SHA-256 (which has a 64-byte block size) by default.

> 
> > Really the only reason to even consider ahash at all would be try to support
> > software hashing and off-CPU hardware accelerators using the "same" code.
> > However, your proposal would not achieve that either, as it would not use the
> > async callback.  Note, as far as I know no one actually cares about off-CPU
> > hardware accelerator support in fsverity anyway...
> 
> The other thing is that verity doesn't benefit from shash at all.
> It appears to be doing kmap's on every single request.

The diff from switching fsverity from ahash to shash clearly demonstrates
otherwise.  Yes, fsverity has to map the pages to pass into shash, but that's a
very minor thing compared to all the complexity of ahash that was saved.  And
fsverity already had to map most of the pages anyway to access them.

- Eric
