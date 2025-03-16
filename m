Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C73D531
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 06:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742107827; cv=none; b=rBUC3t17W0LIEZmgvbEBLwvasp2y2D/9hqhiQ2rnxTMyJPYaxwBaZ/13Tfi39cEXWImCKkHeSXc6UPiEWtPGsmbj35NghDd/xB961qbGxFgMcaJ0RWCJ130nEpulEjqEvdYgpW1lT8pH6qyb7G1hJB5HJryBZC+3I+S1LzGW6OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742107827; c=relaxed/simple;
	bh=NzsNhL24DEtouPykIUFwHPEi2FFCv845RlrJsMStcpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkUGCqhFn40GaDagVxG6gQ59+IvdDZtDDz9jfGrCg/KXpi0TEw9KTJ+Spl1UDaKPiD0PdqEeGEyMZVrmF7mSGhGROBQdC/JqGBWL5yJ0PI2fnwNSQCOopPDieAOuMYEBC+qBTFGpJTS8DlPIyQ2NV0zvFVle8nNHelTkm4aFzGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2TGzFJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2TGzFJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B731C4CEDD;
	Sun, 16 Mar 2025 06:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742107826;
	bh=NzsNhL24DEtouPykIUFwHPEi2FFCv845RlrJsMStcpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p2TGzFJk9oFL/LNLy8GNBdS3lMkQ4s+XJ6lRa6xRREVNfkEulUJMUa0SEFzDr+h1b
	 +b31LHhIi0gQ+vQ0cPufpzSK/n5NpJ980SbIk/5M/a3ykFdxy3WO+zD5kt4Ik3AAc0
	 zRC+xMzDY48AmxkotB38x1ORqOHs6G3t45l9cjIV3wcuAII9oOyU2LXhBHJwLy/0hn
	 dBQ4H84wrrgYuq4VTSVB1YfWMqEcf1hLIm0qL6askVlLCBgceKsYsYt4kLRl6Y57Qb
	 EyiHje3VrKN1p62dVE9VdTI+UhtfhlbX7LnrNemqPRFq2i/hH6iW+x5N/Owadag3jF
	 7lGQDJmQRb1SQ==
Date: Sat, 15 Mar 2025 23:50:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <20250316065025.GF117195@sol.localdomain>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
 <20250316044937.GE117195@sol.localdomain>
 <Z9ZlFXGbDNNheKhZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9ZlFXGbDNNheKhZ@gondor.apana.org.au>

On Sun, Mar 16, 2025 at 01:43:49PM +0800, Herbert Xu wrote:
> On Sat, Mar 15, 2025 at 09:49:37PM -0700, Eric Biggers wrote:
> >
> > As I've said before, this would be much better handled by a function that
> > explicitly takes multiple buffers, rather than changing the whole API to make
> > every request ambiguously actually be a whole list of requests (whose behavior
> > also differs from submitting them individually in undocumented ways).
> 
> This is exactly how we handle GSO in the network stack.  It's
> always an sk_buff regardless of whether it's a batch or a single
> one.

We don't have to make the same mistakes again.

> In fact I will be using that to handle GSO over IPsec so the
> array-based interface that you proposed simply does not fit.

IPsec doesn't use compression, so I guess your comment above is about hashing.
But you are *still* ignoring all the reasons why it isn't useful for IPsec.

Nacked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
