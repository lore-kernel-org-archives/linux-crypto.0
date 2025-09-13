Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE26C1F30BB;
	Sat, 13 Sep 2025 04:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737723; cv=none; b=ug7QBKwzUmVvlWLL2V7UiQ8CyDDpLR69sI1hrqmLgf5v29XXfwdmNIH9dv9bZZCu8tkCMfyRsB5meKEvmsOMkS4ADPndaAxgsGmf7uDRgkkYMkr+BKYA8ngjWK9PRRCcen1aAfLl7jXf+kYsZdbP2PMGoOA2LHYhl6hno9q7I6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737723; c=relaxed/simple;
	bh=ouduViSvFX0J+/hQNDK6rf2w6AnpvLYUEQBa7kgLlL8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=pJGjGL0qPVVk86aoutmbDk8yS+Oud+H2nt9ZCOMINM93dAFjZNQCN5K0Y9r0oefVJMn7L+HywYPnFAtYeFvDfWSwJY8RrfIK8HVhj9BFcjy0+61v1huZvnOfnEsSfdeVLGRcFcQLGP+ZlC2ojnv7gIkmrmWK/Jt/7J4cSeXHNxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O6YyMDY3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O6YyMDY3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3KHyc/2tdmm6xZ4HKTg2vYxKrJunhanQJyOaHPDQdX8=; b=O6YyMDY3H+n5BdXS17h7AQ18Xk
	BN2rDhX86/wh+0UPVLiQbYnMvyRzwxOVUTZwM3q+ElSYLz+HNYeP98a6vnLsr91GNo1ro5btRr+jy
	uS1m5splrKyH9cuk+k2DojD0JCg520BZ7h3yAaMoDT6tAWjOB7oh5DC6GVaupWSTN3HWFPlSytrw0
	pA1Dn4TAz7VhutOBBqL1xAUaayCTu9TfpIWXUogelcOnyJTC8jrVkRTrL15yVFQz7/nSg0/6dF+By
	hw7yYkTnoKv1kyLD8gAe/7O4Oa+rLq9PKZw0goD8sgR0nLAfY/V784kj1Um78EBjd1ztC58DQa5At
	vk4fHDqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHcv-0053uS-11;
	Sat, 13 Sep 2025 12:28:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:28:37 +0800
Date: Sat, 13 Sep 2025 12:28:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, Jason@zx2c4.com, ayush.sawal@chelsio.com,
	ebiggers@kernel.org, giovanni.cabiddu@intel.com
Subject: Re: [PATCH v2] crypto: chelsio - Use library to prepare HMAC keys
Message-ID: <aMTy9foi5kHRzYei@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905030428.21790-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> To prepare HMAC keys, just use the library functions instead of
> crypto_shash.  This is much simpler, avoids depending on the fragile
> export_core and import_core methods, and is faster too.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is the same diff as v1, but with an updated commit message and now
> targeting cryptodev/master instead of libcrypto-fixes.  Since I'm going
> with
> https://lore.kernel.org/r/20250901165013.48649-1-ebiggers@kernel.org/ to
> fix the reported regression instead, this patch is now "just" a library
> conversion and not a fix per se.  If needed I'd be glad to take this
> through libcrypto-next instead, but usually these conversions have been
> going through subsystem trees (which is Herbert's in this case).
> 
> drivers/crypto/chelsio/Kconfig       |   6 +-
> drivers/crypto/chelsio/chcr_algo.c   | 259 +++++++--------------------
> drivers/crypto/chelsio/chcr_crypto.h |   1 -
> 3 files changed, 63 insertions(+), 203 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
