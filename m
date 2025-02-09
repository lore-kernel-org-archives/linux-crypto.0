Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC831487F6
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 09:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739092725; cv=none; b=t6oegaDMYQHvVB1mk+QO1NEU04z5QOGjLSwxRbPnwduN9ATZFPeoDupv/xC0SmCb0v6vAZaR2gA0/6nQpnraWq/3rGCPP52DACqmnqJv9sDIY65uj9sPUvRxIcGuV6FcMlPjK8kQk20BQNU4i71Xui4ofXpWPmyzHjeSlxBwWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739092725; c=relaxed/simple;
	bh=vjCPsWJBW4bnvJy3NHHAn0qFkUsqMrC7lQpMmcO7Qf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iV7CCHGlmG1FoMLJOWATRQDJ97xEQ6KqF5CLcX1GNpkMGLGfEVz2hHdxZhJ4o1kCO+uFeA3Rc96Se5xoCCo64S+vNxNYsTp/EFSGroTKX6oPtqKiM8JPgUrf7QzsAEz/YIiEIzdmWCnd6RCcw2lc/ucTA+2NPVSjqTFZDqDvhCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ruEX0hut; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ruEX0hut"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IJ8a6TRoEyvGfhA9iOR3JSTkGUZ58qh8U5Mi9pIl1uc=; b=ruEX0hutnxukaXzBICiv94m0M9
	w9WtFGQcW5dTBm5sdP8IMRwr0eDmYhsfoEya/Mj1vwcOFEyzw6CHWqGX54ngRq9Rxl+wD3qo9i09H
	xLgXUXPWyKxgYev67OTMGPpotX75M4DL/H6G0BFMg7Tvc9tMOA4oWVM+U54I3SaTvLcI4fO2dRnXh
	N+oIikWRfmR1zgdaXtLJ9M7ScPzsRS8wQ9oHRgsAhqiFNzwbyoCVwavfpKiWHemAEZ+PxA4gH/w+H
	1PYJofEoXKY4cmjzsilPsd06oP/ZgqsE41KGJgoSUy4+w0kRE/fZ+lQFuvCO9Yq7K2DEEYFDBlC7s
	6n78mhwA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th3Fc-00GID6-0B;
	Sun, 09 Feb 2025 17:18:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 17:18:36 +0800
Date: Sun, 9 Feb 2025 17:18:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Theil <theil.markus@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de
Subject: Re: [PATCH] crypto: jitter - add cmdline oversampling overrides
Message-ID: <Z6hy7LFoHPffWuWi@gondor.apana.org.au>
References: <20250127160236.7821-1-theil.markus@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127160236.7821-1-theil.markus@gmail.com>

On Mon, Jan 27, 2025 at 05:02:36PM +0100, Markus Theil wrote:
> As already mentioned in the comments, using a cryptographic
> hash function, like SHA3-256, decreases the expected entropy
> due to properties of random mappings (collisions and unused values).
> 
> When mapping 256 bit of entropy to 256 output bits, this results
> in roughly 6 bit entropy loss (depending on the estimate formula
> for mapping 256 bit to 256 bit via a random mapping):
> 
> NIST approximation (count all input bits as input): 255.0
> NIST approximation (count only entropy bits as input): 251.69 Bit
> BSI approximation (count only entropy bits as input): 250.11 Bit
> 
> Therefore add a cmdline override for the 64 bit oversampling safety margin,
> This results in an expected entropy of nearly 256 bit also after hashing,
> when desired.
> 
> Only enable this, when you are aware of the increased runtime per
> iteration.
> 
> This override is only possible, when not in FIPS mode (as FIPS mandates
> this to be true for a full entropy claim).
> 
> Signed-off-by: Markus Theil <theil.markus@gmail.com>
> ---
>  crypto/jitterentropy.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)

Why does this need to be a toggle?

Why can't you just make this conditional on fips_enabled?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
