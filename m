Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE517C7C8;
	Wed, 12 Jun 2024 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206030; cv=none; b=Db8HSM9XDeeTpuCknLNsddaI9LmgGPaykhUnKL1NHEF0AjmlEA6DWjh6j9a3pMgtXBAHLGASElvhiq9YKrW8lOFoE5j/TQxlgT3Gdf/bQP38bQoDN+85ffHz6y1Cw+RItNSzIjxgLRBpWdXDsChD3cTb1kW1i9j948/jHDc727U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206030; c=relaxed/simple;
	bh=KE9bUaqEpu2RJsSsU4Se8f2nefjiYvwAZR+iz4KwldM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0Cjz10Zba5Pt3Mq9FhqeX2QgYfN0hT6i3nCGwIGQ7zOiRRo/0BhJlzGHpLyBm5EUgBVmW0/2FoKcqE2QgjwD/ujTQ+OINZagHtg0P+n0evyN3EBtlGnkhgbrEEnv4m4xLngGi5ww7faZXm6pzxGKIeLGWIwTls5GDc8yzCfCqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXGyOHqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXGyOHqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77344C116B1;
	Wed, 12 Jun 2024 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718206029;
	bh=KE9bUaqEpu2RJsSsU4Se8f2nefjiYvwAZR+iz4KwldM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LXGyOHqVVzVWn2OFkyZKMYG2RlYiAjOuhlc0b0XUFZyjWra87fCl0AMPj4fd1sPQS
	 ygXpM+will0lrddn7C4PLYkJuxgnS1DBHlBYNrzWqubIjvrxgynZ/xBNeCASiSXz9/
	 I/cyn9zNcH5TqLOpnC+LEtPMQfczR/tueRmqAbGNgfKDXSWU8SiXQolH2TqfC/OX0G
	 RPYin3RE8sGHVFdR4RGlnUobks26qVAK1F8fFM8ve4CogOmzPdiPPBqehHxp/NSrl5
	 frDgTuMyt/9AlcH/TPkQaD6Ww6frSjmPRwATxoJeQNnqB/X4pYAB9+BXu5nJzraa5Y
	 mA2cxpQ7B93ag==
Date: Wed, 12 Jun 2024 08:27:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v5 04/15] crypto: x86/sha256-ni - add support for finup_mb
Message-ID: <20240612152707.GB1170@sol.localdomain>
References: <20240611034822.36603-1-ebiggers@kernel.org>
 <20240611034822.36603-5-ebiggers@kernel.org>
 <ZmltfGWFTj2Kq7hN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmltfGWFTj2Kq7hN@gondor.apana.org.au>

On Wed, Jun 12, 2024 at 05:42:20PM +0800, Herbert Xu wrote:
> On Mon, Jun 10, 2024 at 08:48:11PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add an implementation of finup_mb to sha256-ni, using an interleaving
> > factor of 2.  It interleaves a finup operation for two equal-length
> > messages that share a common prefix.  dm-verity and fs-verity will take
> 
> I think the limitation on equal length is artificial.  There is
> no reason why the code couldn't handle two messages with different
> lengths.  Simply execute in dual mode up until the shorter message
> runs out.  Then carry on as if you have a single message.

Sure, as I mentioned the algorithm could fall back to single-buffer hashing once
the messages get out of sync.  This would actually have to be implemented and
tested, of course, which gets especially tricky with your proposal to support
arbitrary scatterlists.  And there's no actual use case for adding that
complexity yet.

> In fact, there is no reason why the two hashes have to start from
> the same initial state either.  It has no bearing on the performance
> of the actual hashing as far as I can see.

The SHA-256 inner loop would indeed be the same, but the single state has
several advantages:

- The caller only needs to allocate and prepare a single state.  This saves
  per-IO memory and reduces overhead.
- The glue code doesn't need to check that the number of internally buffered
  bytes are synced up.
- The assembly code only needs to load from the one state.

All of this simplifies the code slightly and boosts performance slightly.

These advantages aren't *too* large, of course, and if a use case for supporting
update arose, then support for multiple states would be added.  But it doesn't
make sense to add this functionality prematurely before it actually has a user.

- Eric
