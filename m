Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D8F3BAD94;
	Thu, 11 Jun 2026 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167637; cv=none; b=LZFvL3TBr/kTKVSiHdfU+vakUq/L3Bj7jKK/Xlu5DlhWzMGGQbPPfJ1yaidKJ37RVtXCjD3X0tcBwygs4Ywod14DGEWOaKZP0tYZnmdvBoJqnrV1mQ6LqWtOLgPFPzEKQy03fqQoeYai1UchqDylChpEDmOCfz4Cjf5Jcz3Blms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167637; c=relaxed/simple;
	bh=p3VFzluSG4KUtmK2o4PmhRNpzIz4XrdG4befu3O85zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohBUZV8XCtAwBq6XJtuJ7NlZzz+iPMeVccriOzMoofytfhsOttnwQZOrqCSj5e9LOB3+2BKwMy6BhbGgvh99VqaLU2t4roCroRLEeazmhbL1PFKPYkkynkTKmBeoJV4OCGHs0iQWWPBBX1ISoZS0XKHQ858fTquvbNqMAfyh5Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ewanb71h; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ewanb71h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sKVfby74oDjxfTtZORtOiAzRAVYhFnZVQ82kmcDTCDI=; 
	b=ewanb71h8n4GjOKPrbT8Hfaju1SItPx3fUZ+cOX6wMpTbQUd0M+yOc2MoRc0VBxWaAlLtvm/5J+
	cc4utsZeVhST+K5QRVFeu49BsCEXcdd71p/KN7ZlfMLwqk+jtl8W6kz9m6sH2C9ppLmIx7UK7eP1A
	h6Qfn0UpLniYL6JwdObQXR9vgYY7JCb2EnMlKYyIVtaa4YMoTgGVxeB1Ys/1ZvqoAEeFvHpfotQLe
	zjMpJAECDaN7thuCC7iMxG6NL6Ih3H3kQCjox8qU7HtmuPJ/JndNq6GNEcZlxg6K5/FCYxHhVyYjF
	WctMgSxbAEL6o+Br79udaVAxg/lmYp9Wjmhg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXb4B-00000004XR0-41FU;
	Thu, 11 Jun 2026 16:47:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:47:11 +0800
Date: Thu, 11 Jun 2026 16:47:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org, Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: Re: [PATCH] crypto: qat - validate RSA CRT component lengths
Message-ID: <aip2D_O8EprwIL4u@gondor.apana.org.au>
References: <20260528155854.40858-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528155854.40858-1-giovanni.cabiddu@intel.com>

On Thu, May 28, 2026 at 04:57:44PM +0100, Giovanni Cabiddu wrote:
> The generic RSA key parser (rsa_helper.c) bounds each CRT component (p,
> q, dp, dq, qinv) by the modulus size n_sz, but qat_rsa_setkey_crt()
> allocates half-size DMA buffers (key_sz / 2) and right-aligns each
> component with:
> 
>     memcpy(dst + half_key_sz - len, src, len)
> 
> When a CRT component is larger than half_key_sz the subtraction
> underflows and memcpy writes past the DMA buffer, causing memory
> corruption.
> 
> Add a len > half_key_sz check next to the existing !len check for each
> of the five CRT components so the driver falls back to the non-CRT path
> instead of writing out of bounds.
> 
> Fixes: 879f77e9071f ("crypto: qat - Add RSA CRT mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> Tested-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
