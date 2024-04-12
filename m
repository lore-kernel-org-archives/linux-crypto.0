Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0597E482DA
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 07:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712907189; cv=none; b=jJu/5u5BeefaKV/qlFnYON7SdGLLpXMcrMrWeC34QDnq360dkwmyDK3LoDx67Uz2XjFliQ7i5bzqJkrX8MTzcpfMjbQ7aU0t4+SvfPmODOpxmcHHsGsnH4OS68u9eEZrHu7axhrGq3MP6WJOgrYdELs1f1YSbPPCUh+f2k2DjZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712907189; c=relaxed/simple;
	bh=PzK3dZJ3p5mKtLm+dEa42dgv8+xc6IiOcXC3LcjhbkI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=A0fop4FCzdtk215dy0N2QneKiS67xG4ilMhRKlAVm/qNhWwiJYVqzUNhg9uHGoyH0wHTd+Mxv8ImCQYs/cBIxHE57VM+bkcRL5BfX7GhjKqAD80y8EC00Ce0fsG383tehQeNbHs2TCsxZGSZPWJTRpXMJwO7bNiAu9xjIjEnNHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rvBPD-000lrE-QU; Fri, 12 Apr 2024 15:33:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Apr 2024 15:33:21 +0800
Date: Fri, 12 Apr 2024 15:33:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	tim.c.chen@linux.intel.com
Subject: Re: [PATCH 0/3] crypto: x86 - add missing vzeroupper instructions
Message-ID: <ZhjjwYiy0dz+pQzC@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406002610.37202-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> This series adds missing vzeroupper instructions before returning from
> code that uses ymm registers.
> 
> Eric Biggers (3):
>  crypto: x86/nh-avx2 - add missing vzeroupper
>  crypto: x86/sha256-avx2 - add missing vzeroupper
>  crypto: x86/sha512-avx2 - add missing vzeroupper
> 
> arch/x86/crypto/nh-avx2-x86_64.S  | 1 +
> arch/x86/crypto/sha256-avx2-asm.S | 1 +
> arch/x86/crypto/sha512-avx2-asm.S | 1 +
> 3 files changed, 3 insertions(+)
> 
> 
> base-commit: 4ad27a8be9dbefd4820da0f60da879d512b2f659

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
