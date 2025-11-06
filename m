Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9262DF141;
	Thu,  6 Nov 2025 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762413316; cv=none; b=AXNwpx8wmkmo60XyOGSPeVIKulQbEyNIAhZHAVvb8mWJKzNiDbDwoq8xj1JEPWzxtS6fvtzlNCIuLbHw2DoJWMSfG0QYwHdoxmtY9oK/BWBdS+hW1ex7ZGb92qqv0sulHDDSHboPdr3KFXuPerZLbMjuug5CntCh14tWv7Mgl5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762413316; c=relaxed/simple;
	bh=3fNemxrGiivFhJlesJwcFGpb43lACZhh1/eVkjpFPGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duxu87MyPRunTRvYIb+srTbVrjPssvi5DP9pF9vsgVQRYzaEVBQgTWVhU0h3q3mGbiq/mCeWPHK1aMMzaBjC64VaR6PUVdURdc5ZzTyJZnmYn5WB8qY7LMVXe0+wmS4VV+cn4fvXorZiRIL3JkrvZYtw6vPP/8AXu/qO4CehY4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=G0gx0CoV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="G0gx0CoV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DtlUKepwY+74pLSNJNka3fYy+/86iIE0K3o5wL8EfII=; 
	b=G0gx0CoVsAShTwmJyAqltaBCJ+m7JlFS+Oghr6UVJDAHisrGccKyYNktrsaqB3DAPv+4DXYTYSL
	JrQyuk9BRloqH02UKCHKGn7BUXNiDIgjp7KhPQ0lDsdjpFX+DM5nCf9sckQREsX8XSi2eYS/2dWei
	XBSdP0rbMvLR+pS7ZFJKTSvMsfbklcOKuvDTT8jsJCkhU0UfnPGn8qsPdhD8RJz2POA+SnmVW6Y2V
	bVWxGig52wttmW//6cyu3XakfmoaxQF6V46c36GkXryVZI1q1XLeHrwO5JzO4C3gO9NrxRBaQ/G/3
	L62Ik1mxEZZYPOT0hteMfbFW6we3c2md1+/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGuD5-000rkX-0t;
	Thu, 06 Nov 2025 15:15:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:15:07 +0800
Date: Thu, 6 Nov 2025 15:15:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 03/21] crypto/arm64: sm4-ce-gcm - Avoid pointless
 yield of the NEON unit
Message-ID: <aQxK-6dKZI5Y44VJ@gondor.apana.org.au>
References: <20251031103858.529530-23-ardb+git@google.com>
 <20251031103858.529530-26-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031103858.529530-26-ardb+git@google.com>

On Fri, Oct 31, 2025 at 11:39:02AM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it when calling APIs that may sleep.
> 
> Also, move the calls to kernel_neon_end() to the same scope as
> kernel_neon_begin(). This is needed for a subsequent change where a
> stack buffer is allocated transparently and passed to
> kernel_neon_begin().
> 
> While at it, simplify the logic.
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/sm4-ce-gcm-glue.c | 25 +++++---------------
>  1 file changed, 6 insertions(+), 19 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
