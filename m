Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA7E18C324;
	Wed,  5 Jun 2024 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579153; cv=none; b=lUltweXE428TKL2Z735a9rjaMLPjMFi/EHY9ZCNR1O3Qrh+Cbp4AUARfbLIgKn/ujT7FDKISAFtpJgKarnVpqR6G/Dlae7gwJwg8S+s6E/TPa3754flNI+8V3A5vnDTg3g8CEvzOwBUNfiKjpdUKWfZnnYfV+Gufx5Cusm+w2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579153; c=relaxed/simple;
	bh=MrxZ/G9F0uWEM4pRHqrms1rajBedIxzdSelMDZ0BuZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXhI1c2YgeL50hvmeiBUCD6AqN1ZZHX/Nk+oTGrU/pdTugMJzLGEqxx+rDW/6+GCoMltfEy354iAe0HR6pbCTntRkgdadwtJurLSZoWxvu6VV67tY9dVL8vr5SAAfYRksJ5zuALjqb+kkf3FW9z0hYURbNgqlCN82B6ZtIeDOuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sEmnK-005t8z-2C;
	Wed, 05 Jun 2024 17:18:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Jun 2024 17:19:01 +0800
Date: Wed, 5 Jun 2024 17:19:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604184220.GC1566@sol.localdomain>

On Tue, Jun 04, 2024 at 11:42:20AM -0700, Eric Biggers wrote:
>
> This doesn't make any sense, though.  First, the requests need to be enqueued
> for the task, but crypto_ahash_finup() would only have the ability to enqueue it
> in a queue associated with the tfm, which is shared by many tasks.  So it can't

OK I screwed up that one.  But that's not hard to fix.  We could
simply add request chaining:

	ahash_request_chain(req1, req2);
	ahash_request_chain(req2, req3);
	...
	ahash_request_chain(reqn1, reqn);

	err = crypto_ahash_finup(req1);

> actually work unless the tfm maintained a separate queue for each task, which
> would be really complex.  Second, it adds a memory allocation per block which is
> very undesirable.  You claim that it's needed anyway, but actually it's not;
> with my API there is only one initial hash state regardless of how high the
> interleaving factor is.  In fact, if multiple initial states were allowed,

Sure you don't need it for two interleaved requests.  But as you
scale up to 16 and beyond, surely at some point you're going to
want to move the hash states off the stack.

> multibuffer hashing would become much more complex because the underlying
> algorithm would need to validate that these different states are synced up.  My
> proposal is much simpler and avoids all this unnecessary overhead.

We could simply state that these chained requests must be on block
boundaries, similar to how we handle block ciphers.  This is not a
big deal.

> Really the only reason to even consider ahash at all would be try to support
> software hashing and off-CPU hardware accelerators using the "same" code.
> However, your proposal would not achieve that either, as it would not use the
> async callback.  Note, as far as I know no one actually cares about off-CPU
> hardware accelerator support in fsverity anyway...

The other thing is that verity doesn't benefit from shash at all.
It appears to be doing kmap's on every single request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
