Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DA51EB2A;
	Wed, 12 Jun 2024 19:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219650; cv=none; b=BeMGua1qVK4fiWncar2edUy6bp6oc8jsqkKNggO28t1ILNZ1YfpYHOKE8ZIvEUk+00tORT0kJHztAYtu0NFAXyAqKgnKw9VIH9OqRnLZ+bhWrZWTaRefbDjQNCdwCXDWUI2w5cheKLf4cnvGY8WGKMu0eX6bU0e4QvVBzbXwGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219650; c=relaxed/simple;
	bh=IkuOVIKmhBNyEVZ4pzMiaylc6sEfQehwLzgJTI2arLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdGZoZcMdSu8dstF8AXaCT8ne6kn+y82/BZpjCXk+VRLvkQaGMIgzNKIFhWc8sOWrnh+R/GZ9/CnS6PFvxbhFMdClSbH1duD9TQe/3Uf5vydATmDzG1DlgaX7jbLGo7HhoQzQhtgGQYBKxdEiSf13Tp4nDyHWC0gdO7InmzkQqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtZNNTr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtZNNTr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F755C116B1;
	Wed, 12 Jun 2024 19:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718219649;
	bh=IkuOVIKmhBNyEVZ4pzMiaylc6sEfQehwLzgJTI2arLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dtZNNTr+zNrJyarcL+xMd9BfhFyLD6clDZTqSk7LwK4EDDaj9vtguy/f09nb6GyyY
	 DxN+1JJZWbOSRznIZQcXdrOIexDW0G/ICuzxiQlP46gldk5PHB2inCvIHWy9iiOjZh
	 KeCK86mVoIamVNpiIihT8MMeOXKdTi4og6onRXD9rgmmTlNxMEpPbjTs+Tdq2VqMI7
	 QMgAITS7kkwvnjotYrJs2gqTTFDgQrdWYTlSAQzCoAcUo4xZb7waFp9/OmmDzOXQ/Q
	 Frj3a2Pr3o5RCx+01mDNb4X+ldK66OdQ1NK3168ACiqHmoDQmkqpDwAe0FRDYWL8R9
	 Tzrmv2j2I+HhA==
Date: Wed, 12 Jun 2024 12:14:06 -0700
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
Message-ID: <20240612191406.GA1298@quark.localdomain>
References: <20240611034822.36603-1-ebiggers@kernel.org>
 <20240611034822.36603-16-ebiggers@kernel.org>
 <Zmlq5Y5MgEAVF42C@gondor.apana.org.au>
 <20240612153829.GC1170@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612153829.GC1170@sol.localdomain>

On Wed, Jun 12, 2024 at 08:38:29AM -0700, Eric Biggers wrote:
> On Wed, Jun 12, 2024 at 05:31:17PM +0800, Herbert Xu wrote:
> > On Mon, Jun 10, 2024 at 08:48:22PM -0700, Eric Biggers wrote:
> > >
> > > +		if (++io->num_pending == v->mb_max_msgs) {
> > > +			r = verity_verify_pending_blocks(v, io, bio);
> > > +			if (unlikely(r))
> > > +				goto error;
> > >  		}
> > 
> > What is the overhead if you just let it accumulate as large a
> > request as possible? We should let the underlying algorithm decide
> > how to divide this up in the most optimal fashion.
> > 
> 
> The queue adds 144*num_messages bytes to each bio.  It's desirable to keep this
> memory overhead down.  So it makes sense to limit the queue length to the
> multibuffer hashing interleaving factor.  Yes we could build something where you
> could get a marginal performance benefit from amounts higher than that by saving
> indirect calls, but I think it wouldn't be worth bloating the per-IO memory.
> 
> Another thing to keep in mind is that with how the dm-verity code is currently
> structured, for each data block it gets the wanted hash from the Merkle tree
> (which it prefetched earlier) before hashing the data block.  So I also worry
> that if we wait too long before starting to hash the data blocks, dm-verity will
> spend more time unnecessarily blocked on waiting for Merkle tree I/O.

To clarify, 144*num_messages bytes is for the current version that doesn't have
a redundant shash_desc (or ahash_request which is even bigger) for each block.
If you force those to be included, then that would of course go up.

Also, we can't really swap the order of "hashing a data block" and "getting the
wanted hash of the block" in order to avoid the second issue I mentioned,
because that would require removing the optimization where dm-verity zero-fills
blocks whose hashes are the hash of the zero block instead of verifying them.

So it seems like the downsides of queueing up too many blocks outweigh the
potential benefits.

- Eric
