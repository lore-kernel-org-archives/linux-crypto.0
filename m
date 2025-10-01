Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3197446BF;
	Wed,  1 Oct 2025 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759332419; cv=none; b=fz+4RxENlRnB5Mv46oLp4305+mIh6EEKfUQ4aR2156SEdGXskgaIHkhV9h1OcQPIZX+U6tAI90ZpmTvMSrjUZiBfITEyyvQBeoZz0iXeAn8WTtwE6DvVGbMmo3xndz62NPAFI2FLJhRv+ydJY8kDDGRq9zQFnM1ogmyrFjUxggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759332419; c=relaxed/simple;
	bh=2bwSex0Nq8iycwg64ztyMYueUjIJ5xGZgXpbYqTRpfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0Sh3Cqpt7B96Kx3T3ebJ5bvFTdun1dOKmPJrHCN3AHUJP1EGiW8Xguz+WevRnRVkOX4XmmooKRGfI3Q762I2tWQ7dO9wHvE7rHEbXQ8okkmmt34Ff5ZYGmpkhmwWjdT5/w81mJfy46JHrQfyYzjq/qh8ZIpAAeW12O0+gzLcas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHDCY4DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHDCY4DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820F7C4CEF1;
	Wed,  1 Oct 2025 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759332418;
	bh=2bwSex0Nq8iycwg64ztyMYueUjIJ5xGZgXpbYqTRpfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QHDCY4DIzrVfOHUv/s19MXZZ6czxqe4iCo351/8Mn6XB2nrLq1R9j0+vDIedeEuTy
	 /bpsDOVDRhaJDgeVlb7Ge0MIiB8vo5OijCq+Q/vI10Qw1ghOwG1i6HOnecZlzRUvQQ
	 coNcwbOkLO7LJRXwXFZnXHP9TBft1kC95iyHxTxpjOAjfZnTIhZagMEeLy3JRWnmrR
	 wNuIp1vgjeyFBu2l6MnFEmBDqmiMJItYP+3NZ2cx6qASYvy0zTIFUATMsD/CXVMH6t
	 9KVVrRrE7okgGXD/y1X8XLyyLepS8lnGv8YvG3OjxF+vb80i3gNWwoj5B8R4qmtjcI
	 8PevwjEJMc0uA==
Date: Wed, 1 Oct 2025 08:25:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] crypto/sha3: Add SHAKE128/256 support
Message-ID: <20251001152528.GA1592@sol>
References: <20250926211415.GC2163@sol>
 <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-8-dhowells@redhat.com>
 <2284488.1759323746@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2284488.1759323746@warthog.procyon.org.uk>

On Wed, Oct 01, 2025 at 02:02:26PM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > I recommend holding off on this part until you have a try at using the
> > SHAKE library API directly.  The dispatch to different algorithms could
> > be done in the calling code.  This patch would also limit the ML-DSA
> > code to fixed-size SHAKE outputs; is that really going to be enough?
> 
> Actually, ML-DSA also allows SHA2 hashes for the prehash, so if I use
> crypto_shash for that, then I maintain the flexibility through that.
> 
> > When there's only a small number of supported algorithms, just doing the
> > dispatch in the calling code tends to be simpler than using
> > crypto_shash.  For example, see the recent conversion of fs/verity/ to
> > use the SHA-2 library API instead of crypto_shash.
> 
> That's reinventing the wheel.

Not really.  As I said, in fs/verity/ it was simpler to use the library
APIs, even with multiple algorithms.  I got similar results in net/sctp/
too.  The library APIs are also faster, due to eliminating overhead such
as algorithm lookup by name and indirect calls.

With the library it's also much easier to implement things that don't
fit into the existing paradigm well, such as XOFs.  Case in this point:
this patch adds "shake128" and "shake256" to crypto_shash, but only
offers fixed-size digests.  Which kind of defeats the point of SHAKE.

> Why have crypto_shash at all if we're going to
> encourage people to ignore that and use a union and an enum/ops table.

Mainly because some subsystems accept an arbitrary string in "Crypto API
algorithm syntax" from userspace, and they have to continue supporting
that for backwards compatibility.

Anyway, I'm not saying that you *can't* use crypto_shash.  Just the way
you described it, where using crypto_shash is *required* as soon as
there are two possible algorithms, is not correct.  It's an option.

- Eric
