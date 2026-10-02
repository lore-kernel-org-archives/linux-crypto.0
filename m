Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF4540A93E;
	Fri,  2 Oct 2026 08:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790928441; cv=none; b=OMrCXRXAu4lSZm7G6pFxu2WOc9xDIvlK2gfMY4wditzl3S5rQOWA/GchiMrXfFHNdWC6vQPPJ/ugwUnt2QYJSkgHOlx0l/LgLd/zUhgQJMGj6U1LDGGlbIEzSKA9KONVWd0bhkyXQGdXfUe/0CqPtbPQQlsQ7UvTayw9r/FHXzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790928441; c=relaxed/simple;
	bh=lNa0D2iOfUDGX949UR+N9KWR91XXwWx5blcUcYp8e6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfTHH1rWbpNBPBVrJ41/lp5dIhnjIiYSRbEfOYyNweS992ePgfZgBcFvEu4FoznNp9zNStYeEdwABND1PFKyM2GelPCnX+WMvNnh5gAeowkyTx1gfllzY2AJYqPg0Sm3/x/NSwM4XB5Vl4H9fqTk5Bd6xZcIA+LPLuR4gtnuXxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=l8Iij5oL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="l8Iij5oL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0EwZdcP6rnC7m3HSDydB2GXYz0Nd4Q/SCrQmAr5EHGs=; 
	b=l8Iij5oLoG0mHMIAw89nD4i9BYkJuAvgb/mSXUBLfieii92IhC1GkRz2CHddYzL806TJYuifBkO
	iX6819IQCksHPOXTfRhbQklqyU//wjX8TXvL9AdeiqIHwqgPI6ltbho0guBDb8ixzLbf2RAo234yD
	Fvc9cBulR/sweNI7qUaVS8BOjjKrI0500dMHEJhQqjg6/I8Y753gda2fjVU5w+2gduG9eoD68Mkqg
	q5K7Ao3kxaW7JcscICQq4AXlGRqHtmUH8spwbVbDsmk1WgzFZrfFT+Hw1FrXoUjxV+ifa22GL1IiD
	NshPXaQn3WlbwpT6RubGJZIHtsKp2o5TpVug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYIS-00000002mFt-3L8Q;
	Fri, 02 Oct 2026 16:07:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:07:12 +1000
Date: Fri, 2 Oct 2026 18:07:12 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: haren@us.ibm.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Vishal Chourasia <vishalc@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] crypto: nx - validate 'ignore' before subtracting in
 decompress
Message-ID: <ar9mMJaWd7kbZDiL@gondor.apana.org.au>
References: <20260925175839.3704942-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925175839.3704942-1-qwe.aldo@gmail.com>

On Fri, Sep 25, 2026 at 02:58:39PM -0300, Aldo Ariel Panzardo wrote:
> The decompress() function subtracts the header-supplied `ignore` value
> (a u16 from the compressed stream) from `dlen` (the number of bytes
> produced by the decompressor) without checking that ignore <= dlen.
> 
> If a caller decompresses a crafted buffer where `hdr->ignore` exceeds
> the actual decompressed length, the subtraction wraps around to a
> near-UINT_MAX value.  The subsequent memcpy() then copies gigabytes of
> data past the destination buffer, causing an out-of-bounds kernel write.
> 
> Add a bounds check before the subtraction and return -EINVAL if the
> value is inconsistent.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
>  drivers/crypto/nx/nx-842.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks for the fix!

I think a bigger problem is that this hardware is accepting input
that cannot be processed by the software fallback since it has no
handling of NX842_CRYPTO_MAGIC.

The whole point of having the software implementation is to be able
to decompress the output of the hardware.

I'm not sure who is maintaining this currently.  Vishal, do we
still need the 842 algorithm? Could we fix the software fallback
so that it can handle the same input as the hardware driver?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
