Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D727817E
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746035581; cv=none; b=R/gE808loWqVe2oacsXXPt6Jbo21v+FeGoFR3RAWFth0j8sczghssS0NHz2YqcK1l5sorUOtm9C0fPIqsBfiobw+6qCfc05Fsmj8aEzNbnetcfpcN4QIrJb2SPYVhuSvTS53diJrAq+H15yy/4gE+mww4sfmhUvSu0e+K1cFuoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746035581; c=relaxed/simple;
	bh=7Yk7NNe1mj3ICuKRHyTW5SFMLd9Z5x2pzRH/xmO84tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=le2lyVd+6lPpYLjBabPkrL1IgjMJVkSY4dZpnmKyPkRH+XcWGP9FKdLkJID5HwwwlTp4uiEiTUPWjpHD6K6i5BBFE7qRshOZKR+grAE4/iP05PDsVxfl5L9lSfvVuOdw+mGF0c6oiRDyHikLbDQnIkR1GU8LkIEJKcvRf8Coe9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atZ5rE1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atZ5rE1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6736C4CEEA;
	Wed, 30 Apr 2025 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746035580;
	bh=7Yk7NNe1mj3ICuKRHyTW5SFMLd9Z5x2pzRH/xmO84tY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=atZ5rE1+d74FjZWEHfN7HwtUyKgYLT0oC6EfEtlmCWF1rDVNH8xJWr/9b1I9BTmU/
	 6K2mdlIv5JMaBINqTI9bRtH6HuJoxiQIyNhZ0YPtdvZVNSY6T3zuL0U+mStdcAo/6B
	 l40O8Gdv7U3BhFJY1QRBXOwsb0LrRStSbcZ6CBEuQjan8fcTMJ8EBpeRgwgzEfAEmi
	 zdD2s+9FQApEQrY7TXGN9RiLNYpgpvHtl17v4ynQIH2DL1Z8/SgjGKpS/q96rzrewG
	 ydJUNDbap0lwRmq7H4vd+4WWaoTLbbTvSPoN4dVMw3uff03L8iLUQTRsGmsYwaWVBB
	 0FbhY8akgLC1g==
Date: Wed, 30 Apr 2025 10:52:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <20250430175258.GC1958@sol.localdomain>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
 <aBHcftWYX1Pe9Ogh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBHcftWYX1Pe9Ogh@gondor.apana.org.au>

On Wed, Apr 30, 2025 at 04:17:02PM +0800, Herbert Xu wrote:
> v2 moves lib/crypto to subsys_initcall en masse and removes the
> blake2s patch.
> 
> ---8<---
> This reverts commit c4741b23059794bd99beef0f700103b0d983b3fd.
> 
> Crypto API self-tests no longer run at registration time and now
> occur either at late_initcall or upon the first use.
> 
> Therefore the premise of the above commit no longer exists.  Revert
> it and subsequent additions of subsys_initcall and arch_initcall.
> 
> Note that lib/crypto calls will stay at subsys_initcall (or rather
> downgraded from arch_initcall) because they may need to occur
> before Crypto API registration.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

The commit message shouldn't pretend that this is a 'git revert', since clearly
a lot of these changes were made by hand.

Otherwise this generally looks fine, but I also don't know where this applies
to, so I can't properly review it.

- Eric
