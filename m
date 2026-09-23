Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277B7346E64;
	Wed, 23 Sep 2026 08:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152355; cv=none; b=OrvOXE0zLJ8Yw3vOTl/jwGLIethP/CJb6NbbBPhQ+wpuU+NwO+ln1WnfEy8GV21qNGH8xP2e+RjOUt5b+/F1+ZxzJd4i9OobIfV8FUnDI26DMInOGq4cdOm6jxizC5WEu+HJ78qmW6HwE/mB/Bea6u2Kron4ZuRRGxDeiSxExXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152355; c=relaxed/simple;
	bh=3p/rqBCsBPprrZNeSjqBfIwUGC801QEegj7JgtWieXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIg3w1NygzAfdQ1E7VGcHwNSdWOLHXSgyfw5t9baA2OPxRt4pDbmjRR2YcTeEaVs3Yf/LAptE0aGxD7l/nii+6597N14mJ+E1d1MqEZ/QIrUvYXGyMEi4npyuXUZ4qf/CsAdsBsrnS9rkRwisRcslZIj3omXOBBFojBxCTf7F94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RuRz/5CX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RuRz/5CX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AbgpJ6CKUtUVTx6r4Q/hXLIcgGWueg/e2MoP3w3eSac=; 
	b=RuRz/5CXuGe8iCaC4esj2NRJ8JB7+ViG0qrh7vrEGr9K9UWBdMzLfMmdbSqXRyMtyqKqNXGOFag
	q/o8+MRTeaw63FVUCTKLj1DaFCv2Oh3ytudTdbN+xCv7Vh9yIUnuDBvm2vwAsbwxDppY2DRMnsJQI
	AZCsmSTX19/tRndIauxfkUJy9t76eqRNXFegj+oY0HhmbUbfaXtO8rm2ZBMo91zIlUe+o+cvg80Ge
	87BXWGyJuLQ5FPw6RGy2TAKh+7AL/L2DxRACvahW+Yc4tryoXfAHU5z9KaI/vyCS/a8biZJ2XniFr
	QL1W3DwtZ+T4Nm+7MjA1vzRl+/Xax+cnG7Kg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IOv-0000000Gxop-3682;
	Wed, 23 Sep 2026 16:32:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:32:25 +1000
Date: Wed, 23 Sep 2026 18:32:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Lici <ralf@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with
 accurate DMA directions
Message-ID: <arOOmSnC1NxvG1nw@gondor.apana.org.au>
References: <arNj5SOwXf_TV6eK@gondor.apana.org.au>
 <20260923072646.86229-1-ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923072646.86229-1-ralf@mandelbit.com>

On Wed, Sep 23, 2026 at 09:26:46AM +0200, Ralf Lici wrote:
>
> No, the regions do not need to occupy separate sg entries, the patch
> selects the direction conservatively for the whole entry.
> 
> For a completely linear in-place request, the entry overlaps the output
> range and is therefore mapped DMA_BIDIRECTIONAL. For an out-of-place
> request, the source is mapped DMA_TO_DEVICE. For example, a single
> destination entry covering:
> 
>     [ AAD | ciphertext | tag ]
> 
> has a logical output range covering only:
> 
>           [ ciphertext | tag ]
> 
> Since the entry also contains the preserved AAD prefix, it is classified
> as mixed and mapped DMA_BIDIRECTIONAL. The same applies if an entry
> extends beyond the end of the output range.

Wait, I think this suggests that the caller is giving us bogus
input.

If the input is out-of-place, it shouldn't contain overlapping
data.

Which caller is this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
