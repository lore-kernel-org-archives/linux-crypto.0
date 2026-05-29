Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7C2C15A5;
	Fri, 29 May 2026 06:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034792; cv=none; b=DH2jUUHkC0iGSGrYIT2fmUhEx0l8Ymjxa/z1LwIPabWGVFGV9MtZg1uIzgy0hbNeKcu5Ez0Io0pT0TNF3Yu5gJgtNiPSP3OCJdRvIca8cQqdvSKT8wdT6FogIxZxl4saNXB1CUNBnRTjbmUaxmJLf2V+pfOUx5cPUXvdeOeBAGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034792; c=relaxed/simple;
	bh=Rz1PQmiUbfbGjiF6j0jVCpRI/u6bYn1X7b1Iemcfn5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tb9RIosCz7WK3qh22djuAwXAxQqPIaputGD15DB7haBGGGM3gpetYWmvRi4rPeCU2TpmQT9VutsNZzb2orR86b4FszvvYRaDRxVTnRmpDhNxnii1WSWGWf2KRQqJQhJ6hyU5UMBz9F9/+ROdAuIKB2/vhnApmC5cVPd9kqrCPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=r3gaSo0q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="r3gaSo0q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=blrD1b7iv5E583OimT5b10drAf9IDtHxLR7DVziUmkA=; 
	b=r3gaSo0qSflVRGAoU6Rm1GZQtudrRG4+5p/XHr1XVY5GMOI08UUJAWtOncXdLxdjc9z3LgJsieJ
	MBPT9jxa9+wC02Nt1WZMOeOQOzNkxkoObDt6XQ3r88rOVMS0FEf3d2y7Rapovb9yUdjUc4gHamctR
	f4NTUaVkhVRufJcH51AH+jl7N+orqmOwbsuXUPWRYI9alY9iDxHvdzq6RDjAeGjsEyb+QZA7kVoFJ
	ls1NEcMcKSk/LY+r5NKIlYV5sOzAUbrGYIKxwGqm9+LLMGPe6cuIlHpyQ8UVHcSrvB6Cogj4CiYXA
	RjZBmubZGDgtFYuYyZceEOl/1KewOARAm9UQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqMK-000dEm-2R;
	Fri, 29 May 2026 14:06:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:06:16 +0800
Date: Fri, 29 May 2026 14:06:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx - use strscpy_pad in ucode_load_store
Message-ID: <ahks2F_yS2CoxuO7@gondor.apana.org.au>
References: <20260520100031.246078-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520100031.246078-2-thorsten.blum@linux.dev>

On Wed, May 20, 2026 at 12:00:30PM +0200, Thorsten Blum wrote:
> Instead of zero-initializing the temporary buffer and then copying into
> it with strscpy(), use strscpy_pad() to copy the string and zero-pad any
> trailing bytes. Drop the explicit size argument to further simplify the
> code since strscpy_pad() can determine it automatically when the
> destination buffer has a fixed length.
> 
> Also use strscpy_pad() to check for string truncation instead of the
> hard-coded OTX_CPT_UCODE_NAME_LENGTH.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
