Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE1D15098B;
	Fri,  3 May 2024 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714750093; cv=none; b=YG2B/gIXCF0Bzim5WD7mGq6k02NKebG11eo3wQCONHEYUjT8Ik6LOI75FFmBQBIiqBJltJYWa/ibByfbwdDbM1EdYpijqwkeBykOJvN2KAU/nxMAcXzpnLf4XzAV1zdO85Lpc4zPEeb+TiD6vSQfNt5VXfe9+WjjT7ev3bJJX+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714750093; c=relaxed/simple;
	bh=q0yiVpvWbaHYUHI4s8f9mDHN0TBYmnMwy6gyVKrWQHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHXliftIj3QLZka1+Bv1KJhdgaUwCTzsZu7GTwOtQYpYl1+W9q0pzGwhF54mibj3xDBiSFnt6W+7bj6ssFxXv3Y1I60pdJbn9OtZYOpX2l74tyhh3iU/pLkWMKAW1FqqMrIY5RI1hCwuxzPSfIyotS/bhu9DMyhejAJzj6ybWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUXfXXta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUXfXXta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E94C116B1;
	Fri,  3 May 2024 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714750092;
	bh=q0yiVpvWbaHYUHI4s8f9mDHN0TBYmnMwy6gyVKrWQHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SUXfXXta0N0s3L31U6+7fOVQ0HTg1BGsHqM1QX8Lp7zLhOoZpfwWQilSnF52YEO5q
	 Ff3TNu7tf/KuuLuZFkUDMjgnL7Fp6oagvqxksH/H9UM9BnBKkV2israkeoKH93ICua
	 cd8G1PsdzVMKONo73NAXIhuNPNOSdb0mZN8IJYXzoYlkhSbMS6vKmG7p1rr5syJC4r
	 kLdzv/lgPSCoxYwKI3ruya87MP4pCRhQ6zudYYpxqN6Aum7+yKokDc4OL3HxoLwxjv
	 24bADwTRfL+SYm/dCYYTxMbYoXwv2BZKYtujlcYiOvpY8sYSCbNyNAvyI++WghXNIt
	 pjpU1nYEPSvJA==
Date: Fri, 3 May 2024 08:28:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v2 1/8] crypto: shash - add support for finup2x
Message-ID: <20240503152810.GA1132@sol.localdomain>
References: <20240422203544.195390-2-ebiggers@kernel.org>
 <ZjS5-Im1wWGawfUy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjS5-Im1wWGawfUy@gondor.apana.org.au>

On Fri, May 03, 2024 at 06:18:32PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > For now the API only supports 2-way interleaving, as the usefulness and
> > practicality seems to drop off dramatically after 2.  The arm64 CPUs I
> > tested don't support more than 2 concurrent SHA-256 hashes.  On x86_64,
> > AMD's Zen 4 can do 4 concurrent SHA-256 hashes (at least based on a
> > microbenchmark of the sha256rnds2 instruction), and it's been reported
> > that the highest SHA-256 throughput on Intel processors comes from using
> > AVX512 to compute 16 hashes in parallel.  However, higher interleaving
> > factors would involve tradeoffs such as no longer being able to cache
> > the round constants in registers, further increasing the code size (both
> > source and binary), further increasing the amount of state that users
> > need to keep track of, and causing there to be more "leftover" hashes.
> 
> I think the lack of extensibility is the biggest problem with this
> API.  Now I confess I too have used the magic number 2 in the
> lskcipher patch-set, but there I think at least it was more
> justifiable based on the set of algorithms we currently support.
> 
> Here I think the evidence for limiting this to 2 is weak.  And the
> amount of work to extend this beyond 2 would mean ripping this API
> out again.
> 
> So let's get this right from the start.  Rather than shoehorning
> this into shash, how about we add this to ahash instead where an
> async return is a natural part of the API?
> 
> In fact, if we do it there we don't need to make any major changes
> to the API.  You could simply add an optional flag that to the
> request flags to indicate that more requests will be forthcoming
> immediately.
> 
> The algorithm could then either delay the current request if it
> is supported, or process it immediately as is the case now.
> 

The kernel already had ahash-based multibuffer hashing years ago.  It failed
spectacularly, as it was extremely complex, buggy, slow, and potentially
insecure as it mixed requests from different contexts.  Sure, it could have been
improved slightly by adding flush support, but most issues would have remained.

Synchronous hashing really is the right model here.  One of the main performance
issues we are having with dm-verity and fs-verity is the scheduling hops
associated with the workqueues on which the dm-verity and fs-verity work runs.
If there was another scheduling hop from the worker task to another task to do
the actual hashing, that would be even worse and would defeat the point of doing
multibuffer hashing.  And with the ahash based API this would be difficult to
avoid, as when an individual request gets submitted and put on a queue somewhere
it would lose the information about the original submitter, so when it finally
gets hashed it might be by another task (which the original task would then have
to wait for).  I guess the submitter could provide some sort of tag that makes
the request be put on a dedicated queue that would eventually get processed only
by the same task (which might also be needed for security reasons anyway, due to
all the CPU side channels), but that would add lots of complexity to add tag
support to the API and support an arbitrary number of queues.

And then there's the issue of request lengths.  With one at a time submission
via 'ahash_request', each request would have its own length.  Having to support
multibuffer hashing of different length requests would add a massive amount of
complexity and edge cases that are difficult to get correct, as was shown by the
old ahash based code.  This suggests that either the API needs to enforce that
all the lengths are the same, or it needs to provide a clean API (my patch)
where the caller just provides a single length that applies to all messages.

So the synchronous API really seems like the right approach, whereas shoehorning
it into the asynchronous hash API would result in something much more complex
and not actually useful for the intended use cases.

If you're concerned about the hardcoding to 2x specifically, how about the
following API instead:

    int crypto_shash_finup_mb(struct shash_desc *desc,
                              const u8 *datas[], unsigned int len,
                              u8 *outs[], int num_msgs)

This would allow extension to higher interleaving factors.

I do suspect that anything higher than 2x isn't going to be very practical for
in-kernel use cases, where code size, latency, and per-request memory usage tend
to be very important.  Regardless, this would make the API able to support
higher interleaving factors.

- Eric
