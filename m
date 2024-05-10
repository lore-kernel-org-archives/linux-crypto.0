Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFD538396
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 09:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715332905; cv=none; b=K8/eafdkYSORAB17CS2otrdSS7PJWELYISbO4zuHTFMkeNhni+6wIl/slOdcfj1eXQ5QMdNQJ1/4F0Espqg+vigE5KmFyDBChY8UqP3g7YwCeBs9XWS9mfldkSLDgJRVp2ybYIiRO3IqcN82HkjmiS9hA4pGKleFMRjE7gYz0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715332905; c=relaxed/simple;
	bh=7qhr2sgSsYaeBLgmFrK3nRtgrGqYw/ONr57KF+CFy3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nK8WjAnUtahLbdvY60LB2YwIgMQ9qStx8dDZ9x4i4WwzKMJl+aHzL5PtAlelojMCkYjDai/4KTBqAJ8FI0AR24vIeeK1UucBaBaMAwzRO4GGTjbvZIgFYBjCsJYPsG9Kx4iVb+6dSTB8CK7PJDVB0X52TU4ePYXnIpoYFrC3/bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5MRd-00DKCP-1T;
	Fri, 10 May 2024 17:21:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 17:21:38 +0800
Date: Fri, 10 May 2024 17:21:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/1] crypto: use 'time_left' instead of 'timeout' with
 wait_for_*() functions
Message-ID: <Zj3nIih406SWrnrv@gondor.apana.org.au>
References: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430121443.30652-1-wsa+renesas@sang-engineering.com>

On Tue, Apr 30, 2024 at 02:14:41PM +0200, Wolfram Sang wrote:
> There is a confusing pattern in the kernel to use a variable named 'timeout' to
> store the result of wait_for_*() functions causing patterns like:
> 
>         timeout = wait_for_completion_timeout(...)
>         if (!timeout) return -ETIMEDOUT;
> 
> with all kinds of permutations. Use 'time_left' as a variable to make the code
> obvious and self explaining.
> 
> This is part of a tree-wide series. The rest of the patches can be found here
> (some parts may still be WIP):
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/time_left
> 
> Because these patches are generated, I audit them before sending. This is why I
> will send series step by step. Build bot is happy with these patches, though.
> No functional changes intended.
> 
> Wolfram Sang (1):
>   crypto: api: use 'time_left' variable with
>     wait_for_completion_killable_timeout()
> 
>  crypto/api.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
