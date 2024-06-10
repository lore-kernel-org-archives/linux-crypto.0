Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CD3158A07;
	Mon, 10 Jun 2024 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037781; cv=none; b=N4X8ycnXv94C1/cWiVeqAwYk1hFbXqfCC+O1aqR9BOQGINEECIoHJu0jrSC81Uog5mcsIJePk+yJmTyFHhaRgRcvEOlwMq7wwdIeULlrTSijhNoutdqOOeXa5Ve+qkMpRzUy+dvWwsOIpSO8xhFylZC4oabs8f1pp8uY6fS+x3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037781; c=relaxed/simple;
	bh=9hodINBTmc3Fj62igWgGsiX5FyUrqiDJA19e2g9Falo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVqfWf9iQFq5R4EuUErI76NzTmmwaEKGuzUPf5CL9WunO7riRdHzshF0umZDPBsyjbFolI26xOwa5fKN2R8CRCPv3FryX8j8NFuWKoDqnR+l6mEEfXIq6gFK7lBoKyph8xFoVwQNTeMw+eKTkVtRMsZJy7ny7Ab88aK5PkuBXOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9TiFmnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9TiFmnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363B7C4AF1D;
	Mon, 10 Jun 2024 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718037780;
	bh=9hodINBTmc3Fj62igWgGsiX5FyUrqiDJA19e2g9Falo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9TiFmnhaLVsCE0YSsw3qNorpz1+kERHXTivzjy6KwZrmRYkRo1bdmITCW+rxwke8
	 tSus1yA+1UtkuIsCHS9OmqcLhO8JLmnkZo5IiXo8xsoKvYKgjWTX3O+Ud7k3F8VV9m
	 1HyH0IHkSSrAOTHFSzKGxF2YxC2nQQBEvAvOCxaforW22EZYcJBIUObUBBA8RVRj2E
	 3jOMa6cA9bn/Zk0tDn48Ps+sus++qyabKVC7X5cjddz2lHBIOM9eqqf7km43hJvZQn
	 RVNw9FSyMV7XoWZO13kTFUXMZAaUyjJBkYJm5Co9x+XpVJY3TYPuth4nqEleLUBSYl
	 pU1VlDDQ54VRg==
Date: Mon, 10 Jun 2024 09:42:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240610164258.GA3269@sol.localdomain>
References: <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
 <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
 <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmF-JHxCfMRuR05G@gondor.apana.org.au>

Hi Herbert,

On Thu, Jun 06, 2024 at 05:15:16PM +0800, Herbert Xu wrote:
> On Thu, Jun 06, 2024 at 10:33:15AM +0200, Ard Biesheuvel wrote:
> >
> > Are you suggesting that, e.g., the arm64 sha2 shash implementation
> > that is modified by this series should instead expose both an shash as
> > before, and an ahash built around the same asm code that exposes the
> > multibuffer capability?
> 
> Yes the multi-request handling should be implemented as ahash
> only.
> 

That is not a reasonable way to do it.  It would be much more complex, more
error-prone, and slower than my proposal.  Also your proposal wouldn't actually
bring you much closer to being able to optimize your authenc use case.

First, each algorithm implementation that wants to support your scheme would
need to implement the ahash API alongside shash.  This would be a lot of
duplicated code, and it would need to support all quirks of the ahash API
including scatterlists.

Second, allowing an ahash_request to actually be a list of requests creates an
ambiguity where it will often be unclear when code is supposed to operate on an
ahash_request individually vs. on the whole list.  This is error-prone, as it
invites bugs where a crypto operation is done on only one request of the list.
This is a bad design, especially for a cryptographic API.  We would have
crypto_ahash_*() do some checks to prevent multi-requests from reaching
algorithms that don't support the particular kind of request being made.  But
there will be a lot of cases to consider.

Third, it would be hard to actually implement multibuffer hashing given an
arbitrary list of requests.  For multibuffer hashing to work, the lengths of all
the buffers must be synced up, including the internal buffers in the hash states
as well as every buffer that is produced while walking the scatterlists.  We can
place constraints on what is supported, but those constraints will need to be
clearly specified, and each algorithm will actually need to check for them and
do something sane (error or fallback) when they are not met.  Note that it would
be possible for the messages to get out of sync in the middle of walking the
scatterlists, which would be difficult to handle.  All this would add a lot of
complexity and overhead compared to my proposal, which naturally expresses the
same-length constraints in the API.

Fourth, having the API be ahash-only would also force fsverity to switch back to
the ahash API, which would add complexity and overhead.  The shash API is easier
to use even when working with pages, as the diffstat of commit 8fcd94add6c5
clearly shows.  The ahash API also has more overhead, including in doing the
needed memory allocation, setting up a scatterlist, initializing required but
irrelevant or redundant fields in the ahash_request, and shash_ahash_finup()
running the fully generalized scatterlist walker on the scatterlist just to
finally end up with a pointer which the caller could have provided directly.
All this overhead adds up, even when hashing 4K blocks.  Back when CPU-based
crypto was slow this didn't really matter, but now it's fast and these small
overheads are significant when trying to keep up with storage device speeds
(which are also fast now).  E.g., even disregarding the memory allocation,
hashing a 4K block is about 5% faster with shash than with ahash on x86_64.

Of course, I'd need to support ahash in fsverity anyway if someone were to
actually need support for non-inline hardware offload in fsverity (and if I
decide to accept that despite many hardware drivers being buggy).  But really
the best way to do this would be to support ahash alongside shash, like what I'm
proposing in dm-verity -- perhaps with ahash support limited to the data blocks
only, as that's the most performance critical part.  The ahash code path would
use the async callback to actually properly support offload, which would mean
the code would be substantially different anyway due to the fundamentally
different computational model, especially vs. multibuffer hashing.  A "single"
API, that works for both hardware offload and for the vast majority of users
that simply need very low overhead software crypto, would be nice in theory.
But I'm afraid it's been shown repeatedly that just doesn't work...  The
existence of lib/crypto/, shash, lskcipher, and scomp all reflect this.

I understand that you think the ahash based API would make it easier to add
multibuffer support to "authenc(hmac(sha256),cbc(aes))" for IPsec, which seems
to be a very important use case for you (though it isn't relevant to nearly as
many systems as dm-verity and fsverity are).  Regardless, the reality is that it
would be much more difficult to take advantage of multibuffer crypto in the
IPsec authenc use case than in dm-verity and fsverity.  authenc uses multiple
underlying algorithms, AES-CBC and HMAC-SHA256, that would both have to use
multibuffer crypto in order to see a significant benefit, seeing as even if the
SHA-256 support could be wired up through HMAC-SHA256, encryption would be
bottlenecked on AES-CBC, especially on Intel CPUs.  It also looks like the IPsec
code would need a lot of updates to support multibuffer crypto.

At the same time, an easier way to optimize "authenc(hmac(sha256),cbc(aes))"
would be to add an implementation of it to arch/x86/crypto/ that interleaves the
AES-CBC and SHA-256 and also avoids the overhead associated with the template
based approach (such as all the extra indirect calls).  Of course, that would
require writing assembly, but so would multibuffer crypto.  It seems unlikely
that someone would step in to do all the work to implement a multibuffer
optimization for this algorithm and its use in IPsec, when no one has ever
bothered to optimize the single-buffer case in the first place, which has been
possible all along and would require no API or IPsec changes...

In any case, any potential multi-request support in ahash, skcipher, or aead
should be separate considerations from the simple function in shash that I'm
proposing.  It makes sense to have the shash support regardless.

Ultimately, I need to have dm-verity and fsverity be properly optimized in the
downstreams that are most relevant to me.  If you're not going to allow the
upstream crypto API to provide the needed functionality in a reasonable way,
then I'll need to shift my focus to getting this patchset into downstream
kernels such as Android and Chrome OS instead.

- Eric
