Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73011F153C
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747337732; cv=none; b=P5sFT6/ysGAYjDOVGhgqCQnTQggSe/sGuH2YRr7IoL4+VAX63rTKD46g8JEsug/IrjNaP+b2z5L3VREO3EaxP9d18wy+Q3DHI8sGd25aEGvU3qnqw/Vm3KsFVmS0Dcd0QFcyefto+BocnbKr7Y9xlkzE2D+IdaRddWqWxbkV8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747337732; c=relaxed/simple;
	bh=045HtLHYJMy+3dvhVh7oGbQPC9jFgUnx162iZuuwdbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urI49lo3FvE8JaADteicHw8kx+SWCLvhJJgPZ/EQZpNnN+3gP/Pl/g7HSqGmdSz/TGWxtXWtoFBljTcoZkmWcsAEj0Nqs5YATc5usF+4mC65TwyZ0o7kYKgjLl8CHGLwBTP2PF7EMNuEoy1Y/Hgs/V11YwQCDbHeXjMpLiPf9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbAM4k66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbAM4k66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C8EC4CEE7;
	Thu, 15 May 2025 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747337732;
	bh=045HtLHYJMy+3dvhVh7oGbQPC9jFgUnx162iZuuwdbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbAM4k66tWQsVnVWprrKEnDgC8ATIZk+ZLrvpx2n1bmp2OagRY6+2Kzlq1DEBqPeF
	 6VETc0Op+6KbxN0RMeDnkUDVqyzBMyxa/Avb/RJCtKf3nVxsirm9unMSggHZja1bPS
	 Ijx+8mGHq1tJIr1u7R/wvgZbdKUhZIUi7xEwfN07Ruv/I04APJZA9q+0vP1ZerAOBh
	 KXxauK5V6GMKBIiCMlX58Mi5kCcYP0rXHC4Dc7qCh9eU7e4B7H43CmyoCqW0QvTelg
	 3sNjJrDwVnNjmVK/JoBjiDyV1VaeZ36oMAjWetco+v+I+S3h//5YPnjn0OoQkJ9Qss
	 daWtYrRZwjvdw==
Date: Thu, 15 May 2025 12:35:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <20250515193529.GJ1411@quark>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>

On Thu, May 15, 2025 at 01:54:30PM +0800, Herbert Xu wrote:
> v4 switches the name of the hmac shash and ahash instances.  The
> ahash instance will bear the hmac name while shash gets the driver
> name of hmac-shash.

That seems backwards.  The shash one should be the regular one and ahash should
be special.

> A new test has been added to testmgr to ensure that all implementations
> of a given algorithm use the same export format.

Still lacks any explanation for why this even matters.

>  crypto/ahash.c                 | 572 ++++++++++++++++-----------------
>  crypto/algapi.c                |   8 +-
>  crypto/hmac.c                  | 392 +++++++++++++++++++---
>  crypto/shash.c                 |  46 ++-
>  crypto/testmgr.c               | 134 ++++++--
>  crypto/testmgr.h               |   2 +
>  include/crypto/algapi.h        |  12 +-
>  include/crypto/hash.h          |  73 ++---
>  include/crypto/internal/hash.h |  66 ++++
>  9 files changed, 883 insertions(+), 422 deletions(-)
> 
> -- 
> 2.39.5

As usual, missing a base-commit.  (Use the --base option to 'git format-patch')

- Eric
