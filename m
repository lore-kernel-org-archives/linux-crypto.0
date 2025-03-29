Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2307414D70E;
	Sat, 29 Mar 2025 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743271594; cv=none; b=Dhnph7yczORFyvy1PV9wKypq+FzClEJ9bHfSsXDs/UsxXQt7G1h7Qq7EH6JjkRB6cbQYdVpZpYk5dGWRGqAXsxwoKuxeaZl+qYx6e1EMArlAeqio612DZmqsVa52XZ67aVL8oWltTgCHpyAap9it/uY/uLE88z7fEFTfv/8ewWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743271594; c=relaxed/simple;
	bh=uVQvWprRtPEkAQPUHJ1Hfq5TQOedk5eyybTAvGR+WoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mj6WMbJ9JdsR6sJFmJlyOeebqhajorqV7T4TlQWjjdv7+tDpJtQ5GJoavUtvvxCAUUMBHrjfKh39D4uEBGhKSm+nqQCyEkARS6s9lf4wXvN5UoUgqs579KJ5sdyMijhyGaxZH2j5rYkT0+mLiH1g2K2rG5fcS5QLRXJEyi1Edvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTEtvZfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTEtvZfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D3CC4CEE2;
	Sat, 29 Mar 2025 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743271593;
	bh=uVQvWprRtPEkAQPUHJ1Hfq5TQOedk5eyybTAvGR+WoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rTEtvZfr03cTRKMG8KHVmJFL1ZeMe92FaYKQC0F9piqqwn9wBrbrQd3lIKOdKSrU+
	 bXYVxt8HobBH5XxZy/+oydVLRmb7oAJ3FzR2KmiJH7GzxPbYUe4gYrTx6tGOxnFTe4
	 e6kkq5cLhmii484c+/in5DZmGrZrU1eKazph8A9mm2th4fNKmjrEiTJ7moznfxxWZy
	 pbik8ziChCbE55r9E0cr8SiMQrkJU3PJGbLzD+eBrTMUJ50d06a3mjZFahtz4Z5lRs
	 VuQvHzj3E/2+r4HepVsxVAG0xSNAsIoFRyjLMV+Zmde0syV6JU+u/iK2bTf/wG41bp
	 cZb3XG1Ckbg7g==
Date: Sat, 29 Mar 2025 11:06:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <20250329180631.GA4018@sol.localdomain>
References: <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>

On Sat, Mar 29, 2025 at 10:40:23AM -0700, Linus Torvalds wrote:
> On Tue, 25 Mar 2025 at 08:25, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Each hash request can also contain an entire scatterlist.  It's overkill for
> > what is actually needed for multibuffer hashing, which is a simple API that
> > hashes two buffers specified by virtual address.  Herbert's API creates lots of
> > unnecessary edge cases, most of which lack any testing.
> 
> Isn't that the whole *point* of the generic crypto layer?
> 
> Honestly, I think anybody who cares about modern CPU-based crypto
> should do what wireguard did: stop using the generic crypto layer,
> because it's fundamentally designed for odd async hardware in strange
> *legacy* models, and the whole basic design is around the indirection
> that allows different crypto engines.
> 
> Because that's the *point* of that code. I mean, a large part of the
> *design* of it is centered around having external crypto engines. And
> the thing you worry about is pretty much the opposite of that.
> 
> So if what you want is just fast modern crypto on the CPU, the generic
> interfaces are just odd and complicated.
> 
> Yes, they get less complicated if you limit yourself to the
> synchronous interfaces - which is, as you point out - why most people
> do exactly that.
> 
> Put another way: I don't disagree with you, but at the same time my
> reaction is that the generic crypto layer does what it has always
> done.
> 
> I get the feeling that you are arguing for avoiding the overheads and
> abstractions, and I'm not disagreeing. But overheads and abstractions
> is what that crypto layer is *for*.
> 
> I mean, you can do
> 
>         tfm = crypto_alloc_shash("crc32c", 0, 0);
> 
> and jump through the crazy hoops with the indirection of going through
> that tfm ("transformation object") that allocates a lot of extra info
> and works with other things. And it's designed to work with various
> non-CPU addresses etc.
> 
> Or you can just do
> 
>         crc = crc32c(crc, virt, cur_len);
> 
> and you're done - at the cost of only working with regular virtually
> mapped addresses. Your choice.
> 
> So I think you want to do the wireguard thing, and use the fixed and
> simple cases.
> 
> Yes, those interfaces only exist for a subset of things, but I think
> that subset of things is (a) the relevant subset and (b) the ones
> you'd do the whole parallel execution for anyway (afaik you did
> sha256).

The crypto_shash API is synchronous and operates on virtual addresses.  So it
just provides a simple way to support multiple hash algorithms, and none of the
legacy asynchronous hardware offload stuff.  It's crypto_ahash that has that.

Multibuffer hashing (interleaving multiple hashes) is CPU-based, and it requires
that all the lengths be synced up for it to work, which makes it very difficult
to support scatterlists.  So considering just crypto_shash and crypto_ahash, it
really belongs in crypto_shash (whereas Herbert wants it to go in crypto_ahash).

You're correct that it could go in a SHA-256 library function instead of either
crypto_shash or crypto_ahash.  I think it would be slightly more convenient to
have it in crypto_shash, since the users that want this (dm-verity and
fs-verity) do support multiple hash algorithms and appreciate having the
*simple* abstraction layer of crypto_shash.

But I'd be okay with having a separate code path for SHA-256 too, and maybe this
is the best way out of this...  No need to use the "Crypto API" at all if it's
not going to provide what is needed.

- Eric
