Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7993D3302;
	Fri, 18 Sep 2026 09:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725250; cv=none; b=bNjsiqeCS2xgQQ9lMbdLvG1llaxAnbPdPzK7TEBWNBbGTAR6vFAtLterQfLKzpvUa1SFG3o7c8yC73NI2zlfJhCtu4kbP92gExKYKQPIVCzKhuDXMcen+6JFFVLyQWuUOIyDLhsOfaj6FMb+MEMiEeorF3tYzAHIzJtEH9MyKGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725250; c=relaxed/simple;
	bh=JuG/FhwlmlfuJHZZxe/3Pd36Lh+X9iMxwWmQuhb068s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkAImFnpJFPKLB7Ln3s8PCZ6pylGJX8C75AH6zrv2gw3q8GUKeFi7AtlTgqm4KRpduQcMvWNMJWNkJ0ztRmZLxJVBUyVOirXqIiP0dcJsFMVsTQwAdykVlWqHnSzszC2D38FHkrx0V88NbDQanHfFxkl5JaIT65NT8/3BPVrVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=e0p6U52g; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="e0p6U52g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4cBmi5rDcDFE4LGowyANqWcanFUVM4w4mUVj3rI8W3A=; 
	b=e0p6U52gOhCU3lyAaPCzlSbYYI0QFrwvYvylH4nlyFQGDdzWr2k+Qvjti/fLzTRXzLdv5znegfj
	nXXEaHW9xEYXNaRVJWU9YIKVOYGpGuJJcWz8JEkS/z5xSEUFna9Vj0xK3XObWAl6IIgeX/4OxZHc9
	mNAIMXlTf1vUg+KcOjSP6NV/Ck4kxd2Nk2Zlpe2H/VNqKqFHp5Drxu0Wm85cwvSbWVqll0BG3JQph
	75JhRLpZhWLnEJGg4U5UWxAZQ71cggqwZFZmY3iLUD+XocRCbSS42U2BvTdEoXylujZsR5Pr0q6Ut
	i0URYBs3RzoV6faKoHnNG1opeceyVs31W6uA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VI4-0000000FM0t-0qcl;
	Fri, 18 Sep 2026 17:53:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:53:56 +1000
Date: Fri, 18 Sep 2026 19:53:56 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Harsha <harsha.harsha@amd.com>, "David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: zynqmp-sha - fix NULL pointer dereference in
 init_tfm
Message-ID: <aq0KNOqblAfdG-NF@gondor.apana.org.au>
References: <20260908075339.396499-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908075339.396499-2-blum@kernel.org>

On Tue, Sep 08, 2026 at 09:53:40AM +0200, Thorsten Blum wrote:
> zynqmp_sha_init_tfm() checks crypto_shash_statesize(tfm_ctx->fbk_tfm)
> before assigning the fallback transform to it, which dereferences a NULL
> pointer since the transform context is zero-initialized. Use the local
> fallback_tfm pointer for the size check instead.
> 
> Fixes: c1dd353d18e5 ("crypto: zynqmp-sha - Make descsize an algorithm attribute")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/xilinx/zynqmp-sha.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
