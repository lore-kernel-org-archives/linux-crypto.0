Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B01BA2D;
	Thu, 13 Feb 2025 06:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739428387; cv=none; b=hfWXhCnOpKhpnf8yxdsHK7o7ZfS7ZZ0nC2REU2N46DxXSGQ8XRiDzEmoQm5UVm09hMvqXvMgLG+bL4ODNYJGhga3aBjiF4FbUgyy+R8iKLPsqWy7gqJ6KO7jzZ2qOXl868wY5xLIBme5qr/4II6+RPSpt00BPo407beDxFMVFz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739428387; c=relaxed/simple;
	bh=EYlzHzMqG7RCe6q7JFcYu+FiAfG2RPpXS8EZEEWgLsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSEi15aSsSaEFJlhYeAyzY61crE3W4aYaclAdm82lotK1fwlmVV+YWEegp+OgKqhAX5tgC7eVn1Nf2scq07fO6VrtdxLWl8g8HYmPnGkQRQjyZkA92UN57kWMWJLtqKQieOOb5blaWvCqr71yQ5bUFAMa2aUhy+z9lkaNTkxjiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkS4A/KV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkS4A/KV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F2DC4CED1;
	Thu, 13 Feb 2025 06:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739428386;
	bh=EYlzHzMqG7RCe6q7JFcYu+FiAfG2RPpXS8EZEEWgLsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkS4A/KV+3NNKiQjsxvFOCzRdT8eWvlDjxM2q4kcb2BJO337OWJX9LiciToHB4H5D
	 betsxIK36VXW3NHNoB4lRt0NJXBcNvvIRD4TdwxZiVuUg3QYAeOYlV1HlcU0EOe6Iq
	 PZLtnwxTCnRM2qsfunBg9CIOm9UrYC0WezluyZS+0WZx/wi4xyYmqrxjQWRSRydQv3
	 JAKdnQbYR1WC1r7H2ZTQHeKSXHaJKzo/J/55xlp6TGxwvoKepy/NpWl6mEE7OkYIg4
	 oMQ9JVu3HAPS0/XGVqxfYxi4AA4Ae/S7xImljyKO0EBVNzSAITvpy/EH7dB6z6x2NI
	 wBiVk20+/3H9Q==
Date: Wed, 12 Feb 2025 22:33:04 -0800
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
Message-ID: <20250213063304.GA11664@sol.localdomain>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z61yZjslWKmDGE_t@gondor.apana.org.au>

On Thu, Feb 13, 2025 at 12:17:42PM +0800, Herbert Xu wrote:
> On Wed, Feb 12, 2025 at 07:47:11AM -0800, Eric Biggers wrote:
> > [ This patchset keeps getting rejected by Herbert, who prefers a
> >   complex, buggy, and slow alternative that shoehorns CPU-based hashing
> >   into the asynchronous hash API which is designed for off-CPU offload:
> >   https://lore.kernel.org/linux-crypto/cover.1730021644.git.herbert@gondor.apana.org.au/
> >   This patchset is a much better way to do it though, and I've already
> >   been maintaining it downstream as it would not be reasonable to go the
> >   asynchronous hash route instead.  Let me know if there are any
> >   objections to me taking this patchset through the fsverity tree, or at
> >   least patches 1-5 as the dm-verity patches could go in separately. ]
> 
> Yes I object.  While I very much like this idea of parallel hashing
> that you're introducing, shoehorning it into shash is restricting
> this to storage-based users.
> 
> Networking is equally able to benefit from paralell hashing, and
> parallel crypto (in particular, AEAD) in general.  In fact, both
> TLS and IPsec can benefit directly from bulk submission instead
> of the current scheme where a single packet is processed at a time.

I've already covered this extensively, but here we go again.  First there are
more users of shash than ahash in the kernel, since shash is much easier to use
and also a bit faster.  There is nothing storage specific about it.  You've
claimed that shash is deprecated, but that reflects a misunderstanding of what
users actually want and need.  Users want simple, fast, easy-to-use APIs.  Not
APIs that are optimized for an obsolete form of hardware offload and have
CPU-based crypto support bolted on as an afterthought.

Second, these days TLS and IPsec usually use AES-GCM, which is inherently
parallelizable so does not benefit from multibuffer crypto.  This is a major
difference between the AEADs and message digest algorithms in common use.  And
it happens that I recently did a lot of work to optimize AES-GCM on x86_64; see
my commits in v6.11 that made AES-GCM 2-3x as fast on VAES-capable CPUs.

So anyone who cares about TLS or IPsec performance should of course be using
AES-GCM, as it's the fastest by far, and it has no need for multibuffer.  But
even for the rare case where someone is still using a legacy algorithm like
"authenc(hmac(sha256),cbc(aes))" for some reason, as I've explained before there
are much lower hanging fruit to optimizing it.  For example x86_64 still has no
implementation of the authenc template, let alone one that interleaves the
encryption with the MAC.  Both could be done today with the current crypto API.
Meanwhile multibuffer crypto would be very hard to apply to that use case (much
harder than the cases where I've applied it) and would not be very effective,
for reasons such as the complexity of that combination of algorithms vs. just
SHA-256.  Again, see
https://lore.kernel.org/linux-crypto/20240605191410.GB1222@sol.localdomain/,
https://lore.kernel.org/linux-crypto/20240606052801.GA324380@sol.localdomain/,
https://lore.kernel.org/linux-crypto/20240610164258.GA3269@sol.localdomain/,
https://lore.kernel.org/linux-crypto/20240611203209.GB128642@sol.localdomain/,
https://lore.kernel.org/linux-crypto/20240611201858.GA128642@sol.localdomain/
where I've already explained this in detail.

You've drawn an analogy to TSO and claimed that submitting multiple requests to
the crypto API at once would significantly improve performance even without
support from the underlying algorithm.  But that is incorrect.  TSO saves a
significant amount of time due to how the networking stack works.  In contrast,
the equivalent in the crypto API would do very little.  It would at best save
one indirect call per message, at the cost of adding the overhead of multi
request support.  Even assuming it was beneficial at all, it would be a very
minor optimization, and not worth it over other optimization opportunities that
would not require making complex and error-prone extensions to the crypto API.

I remain quite puzzled by your position here, as it makes no sense.  TBH, I
think your opinions would be more informed if you had more experience with
actually implementing and optimizing the various crypto algorithms.

> But thanks for the reminder and I will be posting my patches soon.

I am not really interested in using your patches, sorry.  They just seem like
really poor engineering and a continuation of many of the worst practices of the
kernel crypto API that we *know* are not working.  Especially for cryptography
code, we need to do better.  (And I've even already done it!)

- Eric
