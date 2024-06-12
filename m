Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63921180A65;
	Wed, 12 Jun 2024 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206711; cv=none; b=XKe2nHo+qQ9tP2S4gLwUBkezVnvnUWuoIh42W5sDi6O3O6E9SDpQx+5GPOCcbHQzF9AgSzI7wImg/IQyqEzf3PJ4BHtdGOW86r28Vgn1FA5ZckdYE/C/NrYbELzT+dLsPmT4KhYyJtOWVwNTHL0+jLCd9hbjTSDiB2cEP2xa4WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206711; c=relaxed/simple;
	bh=g55WUS79UqWb2vcT2SLnwjgCqvRpBv4jwQTnch6tqy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSOQis1SKiivC1ufqcvuuWtv/C7UTHQk4CyspFqJV+kvZY0xubxWJ7Jvfa0wXif82U4o4ZS5WibtTZ9lWaMs2LqXVre40eIBSRo9djSRWcYCvDzlULkUljo+zZWH0liGCgCZfjp27Cas+7C3l5Lgbi6O7rghrq+p0SA/rIGmp5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AT6C4Fg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AT6C4Fg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13C8C116B1;
	Wed, 12 Jun 2024 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718206711;
	bh=g55WUS79UqWb2vcT2SLnwjgCqvRpBv4jwQTnch6tqy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AT6C4Fg7PnFDHKkPaxNGpuWF4djK2aMRuhJAoJFr/3nq5R3PbOHQZgCPRPaBU/UwK
	 pXXuri4ppxubt4AtO57Xd8VY4fR7Af+9k6mumd31OFnGEW4e+olv1buTFfCm0QJ+pC
	 kQnjLpI8sSQqeE7pdFeDOqhUaMpQBPV4JteDQug3RyZaYdWJie6YnMF54KxuPOYPNY
	 KJhQwiWbmZcCx+cICN6dXIqR5CN0//8SrE6lxxeW0bqY9oP0sYFg8UqsA9ORONvuxH
	 x0H4rRnvZngxQ/MqD1ENi0nLGldcjf7Po+TjTHsWA0vUjUaaN+XSNgNGE0JmiTebO3
	 ODeQC/TnUFehg==
Date: Wed, 12 Jun 2024 08:38:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v5 15/15] dm-verity: improve performance by using
 multibuffer hashing
Message-ID: <20240612153829.GC1170@sol.localdomain>
References: <20240611034822.36603-1-ebiggers@kernel.org>
 <20240611034822.36603-16-ebiggers@kernel.org>
 <Zmlq5Y5MgEAVF42C@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmlq5Y5MgEAVF42C@gondor.apana.org.au>

On Wed, Jun 12, 2024 at 05:31:17PM +0800, Herbert Xu wrote:
> On Mon, Jun 10, 2024 at 08:48:22PM -0700, Eric Biggers wrote:
> >
> > +		if (++io->num_pending == v->mb_max_msgs) {
> > +			r = verity_verify_pending_blocks(v, io, bio);
> > +			if (unlikely(r))
> > +				goto error;
> >  		}
> 
> What is the overhead if you just let it accumulate as large a
> request as possible? We should let the underlying algorithm decide
> how to divide this up in the most optimal fashion.
> 

The queue adds 144*num_messages bytes to each bio.  It's desirable to keep this
memory overhead down.  So it makes sense to limit the queue length to the
multibuffer hashing interleaving factor.  Yes we could build something where you
could get a marginal performance benefit from amounts higher than that by saving
indirect calls, but I think it wouldn't be worth bloating the per-IO memory.

Another thing to keep in mind is that with how the dm-verity code is currently
structured, for each data block it gets the wanted hash from the Merkle tree
(which it prefetched earlier) before hashing the data block.  So I also worry
that if we wait too long before starting to hash the data blocks, dm-verity will
spend more time unnecessarily blocked on waiting for Merkle tree I/O.

- Eric
