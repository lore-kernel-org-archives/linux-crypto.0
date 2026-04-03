Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B56F1FC7C5
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 00:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775175911; cv=none; b=mInmIEl9+kJeJeJav6KfhVm6gw8DWmLuj8xUMDG+A8bIJLaoNHMoqdTFLWGFyR/wHbdc4I82MVarVjPBtJyWwl8g71oHPn8bVIauWW+8bXNGzxPBlakLIvypvCUjkwz9VKVP69HPhnju4sUTo99ZwD90i0bG3RvVAHNT+Sz2Hho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775175911; c=relaxed/simple;
	bh=3529xiERrkywvKDzSPpWMVIHa089ppIneL/dH9HCT4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0K/7JpP8crzMdJTkNuq5Ewl7bAEQPgtTCsbW2x/EonJ8KNiSXtnOzD6NlZwYCMbhjPlbwYb1k/SJMzBDQOZNd0psUa7VCxZnpAq9STx3G7ZdMNrVqCGsfmsuTu84znr6hTyS0oUZRmz3R6IGGwZ48PjCSAOUfdjkXq83y3zZmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZH8S941D; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZH8S941D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A5y1B4w3iYMnD3UXmYC0FaOgVuQlnJHsLd3jFdnKQtE=; 
	b=ZH8S941DHJ90D0gfGoYR718DMJfwOpj35wucf6IT6vw5zsqpmsr1eZ8bP42inRI92nqxSQKGmfo
	e6pB3c9t1eFc1uez7PMAt/sUdG6lDOv2/2l1mcMtMD2WDPntghmNySMoHL2SaWkEuMUwfFxfA13xL
	Orjy9z3geZ2IL4+f+bWjR4IGimyf6vpaxhvRp2ESQFGjw97QyzjEfPwYqZDhlx5gvIDFO86ynfyAf
	th+G5HJPe522noXPob0dnM30GEXLZ95xk7NqXRZTcvP/htHrq5J72mGqKJMg4Snc5FYNMTYVUKXCL
	9Xs8ePNNuKGdVVMyoZlfu0aFXBCNi/1xxFWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8Rvz-003QPL-1b;
	Fri, 03 Apr 2026 08:25:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 08:25:06 +0800
Date: Fri, 3 Apr 2026 08:25:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: Re: [PATCH v2] crypto: deflate - fix decompression window size
Message-ID: <ac8I4mpkdn8uy8TE@gondor.apana.org.au>
References: <20260326100433.57324-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326100433.57324-1-giovanni.cabiddu@intel.com>

On Thu, Mar 26, 2026 at 09:59:22AM +0000, Giovanni Cabiddu wrote:
> deflate_decompress() initializes the inflate stream with windowBits set
> to -DEFLATE_DEF_WINBITS (11 bits, 2KB window). Valid raw DEFLATE streams
> allow window sizes up to MAX_WBITS (15 bits, 32KB).
> 
> Data compressed with a history window larger than 2 KB, for example
> produced by hardware compressors such as QAT or IAA, might not be
> decompressed by deflate-generic since the inflate stream is initialized
> with a 2 KB window. This might be seen, for example, when
> deflate-generic is used as fallback.
> 
> Use -MAX_WBITS when calling zlib_inflateInit2() to accept all valid raw
> DEFLATE streams. The inflate workspace allocated in deflate_alloc_stream()
> is already sized using zlib_inflate_workspacesize(), which accounts for
> the maximum window size, so no allocation change is needed.
> 
> Fixes: f6ded09de8bd ("crypto: acomp - add support for deflate via scomp")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> ---
> Changes since v1:
> - Updated commit message to clearly state why this is needed for the
>   deflate algorithm (i.e. allow data produced by HW compressors with
>   larger history windows to be decompressed by deflate-generic, which
>   is used as fallback).
> - Updated fixes tag to point to the commit that introduced deflate
>   support in scomp.
> 
>  crypto/deflate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What happened to the parameters patch-set? Wouldn't this be something
that should be treated as a parameter?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
