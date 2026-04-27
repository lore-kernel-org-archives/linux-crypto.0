Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DEB40DFA9;
	Mon, 27 Apr 2026 20:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777320079; cv=none; b=W5+qEO2xfGQzdvV/fpBxboPGWTYqdVYA5OulcYfM46JnT5XZPJ6ZJOg7fHcBsn9u2YHzbt0ck06TUdDCiK0AZM07I3HmnIT9xdylEBAtJUQVSAgoySHjwt97OZd3+kwoBkGI7BV0wpLCPx05hcOr9Ogii5H53PkD4XJmBoJah2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777320079; c=relaxed/simple;
	bh=RIb0Aa6EpzNRg1J0aTaLhEFrZVgJgo6t/s8NvM+Us+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLfYsPci64iOx+DQn/drhfkQFa0tKITzSIvxluiB180SB9b+ZyduSJPRUr/Sayi9/hI4gntWOGkY98znQ/dxP1pGMLzzwoitSwxNJBKuaOOySHxlb+4UdqVLWUitRV+MmM7v3kCGmKWb2qH67yWoHgc0QlTu49Ho60zEoq1zlo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=te0mMZsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="te0mMZsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B04AC19425;
	Mon, 27 Apr 2026 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777320078;
	bh=RIb0Aa6EpzNRg1J0aTaLhEFrZVgJgo6t/s8NvM+Us+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=te0mMZsfpyPjHwxfI2i1rV6e7UtQEbxyhCXcge+V5V30jFEwSSKvYj9wfC4FBlqQZ
	 nh/L7WvLUuQuxR+p0Pq0IE5I1AdLM0D/z9UCr+CozJ7osX7cT3pgK08sp7h0TTIUEB
	 001EAx86lplAyaWSwrYsF2Q6bOFm6PjyqqsD00oiLXfpq6xwoaPXyGj38btFYlsiJ/
	 FY8XN1XjPT6YUkAyjeDBEyTTyatGKVb02kypS0IjNQ4qNIVN0R/QO8Eg1cQ3myr0lX
	 06zznjZaWYVF4nPX0k3TmqCYX/ufTJrxneEB/wHDAvyMB4nSdSZWM/a8zilOAXDE15
	 jvZgFCFS1Ffvw==
Date: Mon, 27 Apr 2026 20:01:16 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
Message-ID: <20260427200116.GA3454259@google.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>

On Mon, Apr 27, 2026 at 08:09:05PM +0100, Dmitry Safonov wrote:
> > To get a sense for how much more efficient this makes the TCP-AO code,
> > here's a microbenchmark for tcp_ao_hash_skb() with skb->len == 128:
> >
> >         Algorithm       Avg cycles (before)     Avg cycles (after)
> >         ---------       -------------------     ------------------
> >         HMAC-SHA1       3319                    1256
> >         HMAC-SHA256     3311                    1344
> >         AES-128-CMAC    2720                    1107
> 
> 
> I do like these numbers quite much! Yet, as I mentioned in version 1,
> removing a fallback for other algorithms' support does not sound good
> to me. There are two reasons:
> - Ronald P. Bonica (the original RFC5925 author), together with Tony
> Li do have an active RFC draft to support the additional algorithms
> [1], potentially in addition to TCP Extended Options [2]
> - There is at least one open-source BGP implementation (BIRD) that
> allows using the algorithms that you are removing [3]. Without a
> deprecation period and communication with at least known open source
> users, it implies intentionally breaking them, which I can't agree
> with.
> 
> I don't feel like Naking as we don't have any customers using anything
> other than the 3 algorithms above (and BGP implementation is
> [unfortunately] closed-source, so that would not feel appropriate even
> if we had such customers), yet I do feel like it's worth and
> appropriate to express my thoughts/concerns.
> 
> [1] https://www.ietf.org/archive/id/draft-bonica-tcpm-tcp-ao-algs-00.html
> [2] https://www.ietf.org/archive/id/draft-bonica-tcpm-extended-options-00.html
> [3] https://github.com/CZ-NIC/bird/blob/master/sysdep/linux/sysio.h#L246

I think the usual "it's not really broken if no one notices" is likely
to apply here.  Indeed, there have been many cases where algorithms have
been removed from the crypto API before, despite this theoretically
impacting UAPI.  Just some of the removals from crypto_ahash over the
years that come to mind are the Tiger hash algorithms, multiple variants
of RIPEMD, multiple CRC variants, GHASH, Poly1305, NH, and POLYVAL.

The reality is that the crypto API's algorithm specification language
provides way more "flexibility" than anyone knows what to do with or
ever should have existed at all, let alone been exposed directly to
userspace.

We don't have a lot of choice but to clean up these old mistakes to keep
Linux maintainable going forwards, reduce the chance for user error, and
optimize for the things that actually matter.

And again, as I said, if there is another algorithm that someone
actually needs, we can add it back as a bug fix (or as a new feature,
considering that some never worked in the first place).

- Eric
