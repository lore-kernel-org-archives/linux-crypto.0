Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57A21D00A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 04:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773202562; cv=none; b=VipZxCP9+rQGaTMq6HbQeDvhwAmARd7MWsDoCIpKCamtcQ1aqDDCUZn/eYDLHbuGByRiFKzEtF+qWDFAdSlPOsEtcu763aX5D1O5biFWrgkTKK+CPHW0yDAo2DX8zollw0iiCzOwTtGOYrPR67x98Elc0biqNKZI0OnBRSnsnTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773202562; c=relaxed/simple;
	bh=Xl2MhmDCR5jDpun46TF4Dk23ElfPoPs5ff3UyeIwInQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMRWX6JTas96fNQCHo8aHDrM9r23spVbMjS5DK4ldfXYUa0XWS0AVUC678GxdfewUyLruh40/8RzwCvdYSz3tf8gezrt9fe79upTXtRGfoVHYpHMFpRGsedpHBY8g2TChB6GndpyRQlIHlBkVQKtZD6yH/IzICGwdMSwunUfcBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FLa6LP8K; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FLa6LP8K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=U8K3itJjndALQYsGy55CAFS1GZ92Bgvbl0syJjouOfA=; 
	b=FLa6LP8KAPfbgOlF7TTF3jNuuK4MONhP9tWsoewFvmS+6FUsEzdB/gbdpkqRg+BMKq7pQiDy04k
	RnDymeCMY1JI5dZ29h0YD/x94jwdj1XVQZNe2sRFwoo9wLKdVMvMzNeDVXmcCBCgzOXvaidmt4vas
	uJNVjt06RQdaSVyADaP62mOhUstrsw/fDKwms/JoBFHQXwWMUeqr57RRz+h+rVu45gGN+9OXIaFz/
	ZBfJehTn5A+U/NyQYKHyJJkkRP7a3DPBmAs4sbIBqMytQhlIEP+GjCST/DqYw7F4Ku0XYIy3J8VZl
	orwwEUBQp1S369EB+otmTXiFVkmR5Bxx2NvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w0AzB-00DNZO-2k;
	Wed, 11 Mar 2026 12:15:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Mar 2026 13:15:53 +0900
Date: Wed, 11 Mar 2026 13:15:53 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, Paul Bunyan <pbunyan@redhat.com>
Subject: Re: [PATCH] crypto: caam - Fix DMA corruption on long hmac keys
Message-ID: <abDseUutHQaKsWtQ@gondor.apana.org.au>
References: <aa6PaoYiz_BY1eZI@gondor.apana.org.au>
 <d1bd8cf9-db43-4e36-869f-ecb953dd82e6@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1bd8cf9-db43-4e36-869f-ecb953dd82e6@nxp.com>

On Tue, Mar 10, 2026 at 05:12:10PM +0200, Horia Geantă wrote:
>
> > diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> > index e0a23c55c10e..aded03c8601c 100644
> > --- a/drivers/crypto/caam/caamhash.c
> > +++ b/drivers/crypto/caam/caamhash.c
> > @@ -441,7 +441,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
> >   		if (aligned_len < keylen)
> >   			return -EOVERFLOW;
> > -		hashed_key = kmemdup(key, keylen, GFP_KERNEL);
> > +		hashed_key = kmemdup(key, aligned_len, GFP_KERNEL);
> 
> When aligned_len is bigger than keylen, kmemdup would go beyond the end of
> "key" buffer.
> 
> Looks like kzalloc + memcpy should be used instead of kmemdup.
> 
> Double checking the faulty commit, I've found the same pattern in
> ahash_setkey from drivers/crypto/caam/caamalg_qi2.c. Let me know if you'd
> send a fix for this or I should do it.

Good catch.  Please feel free to send a patch for both issues.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
