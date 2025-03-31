Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF21B155725;
	Mon, 31 Mar 2025 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743440193; cv=none; b=traVi86yAwuUk3s9Q2iahZoq5ZGAcpIETY5deA4FFOhRHWotCVPfsfQqTonRxOJr8NmTiGbBriPGDfu1WG0Z5UcT4o9sCrSNvbsDsxXgpsD9ILNUW5dSIa59AnxbbfpaaGaLRI9H80i+b+e/2/6ypOB/vJUGdpNOhbtvaw7iOk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743440193; c=relaxed/simple;
	bh=5pFinEz7ke1siiunzxiqlXX2duHMmNQpekzCsvcdZf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Isg59lfv+HqQ93vRRzuxzMiAAfIiMvJaJjmqswSS94pTEy4+kKweqDggcBYzh7WCRFDYkjzYzPG80gAtzRW5hHeQKLBfSQNETWVckvJK5+IhRDd2otItQsywaCVP95Mt5LcCCO0qTWneorwffwXM67FAHilAYzMsL6H9l5z58/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlqON7MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlqON7MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362ACC4CEE3;
	Mon, 31 Mar 2025 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743440192;
	bh=5pFinEz7ke1siiunzxiqlXX2duHMmNQpekzCsvcdZf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nlqON7MAMS8h43V+Wdv2AVwCQAV5bVHeHNBiaxUtbElCsnji7qxsCNlk7N8b8MTbv
	 +NOnz4IUxFnOc4A7EMIYgPXSNNGhrTOQI//YOLh0x+v8On9kzBK1bQrHVLmBCJz0cj
	 MT0WwQLuRUVGWa4cTLVQTFFSZCUZKMBHAh/PS6bScIiZyf3edwKj54E6TP4/bT7Lsw
	 +LPdhw809nbBUGMekvgF0MfaemAlmF4IIwFyrlxfB/h12wLshSbXae6Z8aTtIPeH4w
	 +MwGgiUVn6zItlKnU7ujYGkPEinkR4zH8gD5d9sOeEPMeXkJtbkhJGxlDyAVWbu59B
	 u+UpcURuxHHfA==
Date: Mon, 31 Mar 2025 16:56:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <20250331165630.GA3893920@google.com>
References: <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-itc_Qd5LLn19pH@gondor.apana.org.au>

On Sun, Mar 30, 2025 at 10:33:23AM +0800, Herbert Xu wrote:
> On Wed, Mar 26, 2025 at 11:52:05AM +0800, Herbert Xu wrote:
> >
> > they don't need it.  Take ext4 as an example:
> > 
> > 	ext4 calls verity
> > 	schedule_work(verity_work);
> > 	return asynchronously!
> > 
> > verity_work:
> > 	do the crypto work
> > 	__read_end_io(bio);
> 
> I went ahead and removed the work queue for fsverity and fscrypt
> (except for the reading of the Merkle tree which is still done in
> a work queue because I'm too lazy to make that async), and it
> actually turned out to be slower than using a work queue.
> 
> I was testing with an encrypted 8GB file over ext4 mounted over a
> loopback device in tmpfs.  The encryption is with xts-vaes.  It turns
> out that not using a work queue actually made reading the entire file
> go from 2.4s to 2.5s.
> 
> I then tried passing the whole bio (256KB per crypto request in my
> test as opposed to the data unit size of 4KB per crypto request)
> through using chaining to skcipher, with xts-vaes doing the requests
> one-by-one.  Against my expectations, this didn't speed things up at
> all (but at least it didn't slow things down either).  All the
> benefits of aggregating the data were offset by the extra setup cost
> of creating the chained requests.

Yes, your chaining API has poor performance and is difficult to test, as I've
been saying all along.

> So chaining is clearly not the way to go because it involves cutting
> up into data units at the start of the process, rather than the end.

Certainly agreed that chaining is not the way to go, but I think you're
overlooking that Linus's suggestion to use the libraries directly would also
solve this, while also not being restricted to bios and folios (note that not
all filesystems are block-based, for example...).  That would avoid the
per-request overhead from the generic crypto infrastructure, which is the real
source of the problem.

> Finally I hacked up a patch (this goes on top of the skcipher branch
> in cryptodev) to pass the whole bio through the Crypto API all the
> way to xts-vaes which then unbundled it.  This turned out to be a
> winner, taking the read time for 8GB from 2.4s down to 2.1s.
> 
> In view of this result, I'm going to throw away chaining, and instead
> work on an interface that can take a whole bio (or folio), then cut
> it up into the specified data unit size before processing.
> 
> The bottom-end of the interface should be able to feed two (or whatever
> number you fancy) data units to the actual algorithm.
> 
> This should work just as well for compression, since their batching
> input is simply a order-N folio.  The compression output is a bit
> harder because the data unit size is not constant, but I think I
> have a way of making it work by adding a bit to the scatterlist data
> structure to indicate the end of each data unit.
> 
> PS For fsverity a 256KB bio size equates to 64 units of hash input.
> My strategy is to allocate the whole thing if we can (2KB or 4KB
> depending on your digest size), and if that fails, fall back to
> a stack buffer of 512 bytes (or whatever number that keeps the
> compiler quiet regarding stack usage).  Even if we're on the stack,
> it should still give more than enough to data to satiate your
> multibuffer hash code.

Extending the generic crypto infrastructure to support bios and folios is an
interesting idea.

But TBH I think it's worse than Linus's suggestion of just extending lib/crypto/
to support the needed functionality and using that directly.  Your proposal is
again solving a problem created by the generic crypto infrastructure being too
complex, by making the generic crypto infrastructure even more complex.

With the bio and folio support in the generic crypto infrastructure, there would
be lots of work to do with adding support in all the underlying algorithms, and
adding tests for all the new APIs.

For hashing, users would need to allocate an array to hold the digest for every
block in the bio or folio.  That would add an additional memory allocation to
every I/O.  You said you'd like to fall back to a smaller buffer if the memory
allocation fails.  But that's silly; if we have to support that anyway, we might
as well do it that way only.  In which case the bio interface is pointless.

Also note that the kernel also *already* has an abstraction layer that allows
doing en/decryption on bios.  It's called blk-crypto, and it makes it possible
to do the en/decryption using either inline encryption hardware (i.e., the newer
style of crypto accelerator that is actually commonly used and doesn't use the
Crypto API at all) or the Crypto API.  I have plans to remove the fs-layer bio
en/decryption code from fscrypt and always use blk-crypto instead.

Adding bio support to the Crypto API feels duplicative of blk-crypto, and we'd
end up with too many abstraction layers.  I think my preferred approach is that
blk-crypto-fallback would directly call the library functions.  The legacy
Crypto API really has no useful role to play anymore.

FWIW, there are also people thinking about developing inline hashing hardware,
in which case something similar would apply to blk-integrity.

- Eric
