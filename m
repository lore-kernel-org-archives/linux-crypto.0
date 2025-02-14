Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD931519AB;
	Fri, 14 Feb 2025 04:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739507393; cv=none; b=g+ZJiBTpzmN/0148aR2srm6PAX7I/BuMLKRVvJiEHD/dBDlfDiPJgRBDHK4rEHce9Wwp9kGNjOiMbPDETLMAbw+luwAd/FWBzIzqXolExF3USmAmSbcP+RpCC5xoUHhNxVIebljj2+5ed9mZ+p7oe2Zn3yB/bp4B25iHR+LWLpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739507393; c=relaxed/simple;
	bh=kJfkFaSW6aJQb8uFoWo8v4ScxVtaWTGd54TPudR6gnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vp7rMczNqn+27sBWsE8beZLn+1LF7+VXGdVeojLL06g3Mue2gm/Lo2EE93rHbTnB51pPO06th+2sq1kD4BG8enV964Cr4B9QBcrYU7iQiZaPVzRwQ+A8EMR9G+F+cs5nbZwdXrO0Hgbq67uL7c7MtRNl0u9MS/6fmiyIOHpP/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdP10B/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdP10B/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC6EC4CEDD;
	Fri, 14 Feb 2025 04:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739507393;
	bh=kJfkFaSW6aJQb8uFoWo8v4ScxVtaWTGd54TPudR6gnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BdP10B/d07a8NOBmx+NMyNq7E4ryvlAzNRtxyr9IhOOrkL3F76sOwT0kQsy75C15J
	 NdH8ijzNrzam/YU/kpqouZ2Gpdz6bE0ex62pPOyTv4Q40hIuslm3iDr89O6+KMocJp
	 /XCJwCOz7jf1mdTwPujOnuz2dpvZaXAaKr7bHmeFIQ5uO3Zzw31UEGy9AKmeNFXZxT
	 mQV5OPxyxp1QZxbBx1DLhUuYCGjTp7ahg0RfGQ5/mUco3sFrqZI5vbzuasB5k5Olj5
	 vgtCg+agVsu/TeRxXSUzqhllmhb1w+7l4FaVFdkqtD5p2GTgzVT5T8TLnCGwvHDFPH
	 EOZ/pqHoqYmjQ==
Date: Thu, 13 Feb 2025 20:29:51 -0800
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
Message-ID: <20250214042951.GB2771@sol.localdomain>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <Z66uH_aeKc7ubONg@gondor.apana.org.au>
 <20250214033518.GA2771@sol.localdomain>
 <Z669mxPsSpej6K6K@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z669mxPsSpej6K6K@gondor.apana.org.au>

On Fri, Feb 14, 2025 at 11:50:51AM +0800, Herbert Xu wrote:
> On Thu, Feb 13, 2025 at 07:35:18PM -0800, Eric Biggers wrote:
> >
> > It absolutely is designed for an obsolete form of hardware offload.  Have you
> > ever tried actually using it?  Here's how to hash a buffer of data with shash:
> > 
> > 	return crypto_shash_tfm_digest(tfm, data, size, out)
> > 
> > ... and here's how to do it with the SHA-256 library, for what it's worth:
> > 
> > 	sha256(data, size, out)
> > 
> > and here's how to do it with ahash:
> 
> Try the new virt ahash interface, and we could easily put the
> request object on the stack for sync algorithms:
> 
> 	SYNC_AHASH_REQUEST_ON_STACK(req, alg);
> 
> 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
> 	ahash_request_set_virt(req, data, out, size);
> 
> 	return crypto_ahash_digest(req);

That doesn't actually exist, and your code snippet is also buggy (undefined
behavior) because it never sets the tfm pointer in the ahash_request.  So this
just shows that you still can't use your own proposed APIs correctly because
they're still too complex.  Yes the virt address support would be an improvement
on current ahash, but it would still be bolted onto an interface that wasn't
designed for it.  There would still be the weirdness of having to initialize so
many unnecessary fields in the request, and having "synchronous asynchronous
hashes" which is always a fun one to try to explain to people.  The shash and
lib/crypto/ interfaces are much better as they do not have these problems.

> > What?  GHASH is a polynomial hash function, so it is easily parallelizable.  If
> > you precompute N powers of the hash key then you can process N blocks in
> > parallel.  Check how the AES-GCM assembly code works; that's exactly what it
> > does.  This is fundamentally different from message digests like SHA-* where the
> > blocks have to be processed serially.
> 
> Fair enough.
> 
> But there are plenty of other users who want batching, such as the
> zcomp with iaa, and I don't want everybody to invent their own API
> for the same thing.

Well, the IAA and zswap people want a batch_compress method that takes an array
of pages
(https://lore.kernel.org/linux-crypto/20250206072102.29045-3-kanchana.p.sridhar@intel.com/).
They do not seem to want the weird request chaining thing that you are trying to
make them use.  batch_compress is actually quite similar to what I'm proposing,
just for compression instead of hashing.   So there is no conflict with my
proposal, and in fact they complement each other as they arrived at a similar
conclusion.  Hash and compression are different algorithm types, so they can
never use exactly the same API anyway, just similar ones.  And FWIW, zswap is
synchronous, so yet again all the weird async stuff just gets in the way.

- Eric
