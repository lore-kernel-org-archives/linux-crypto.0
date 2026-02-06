Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD5C1ADC7E;
	Fri,  6 Feb 2026 10:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770372218; cv=none; b=JaYnhb2sBy75t2AR1vV+JxiIt3nbJ6LyzDTlwZNVCtlhTfeSMPqH4iapm4S75OlSA3SOI0OiI9QOMxLg6QjZLw9mCHSgfcqlw7FNGMaq304uyYfuLT41Zs1zfOkk91w8I0v5bTem6XZ1X+xxwLokxGoe9jUcbd2tuwknxysdTDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770372218; c=relaxed/simple;
	bh=Rl071ZNdP/q5zBwHxsDurk485e7SBxe/KtCKGzss0sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFa2DrWCjz3P/RoqVKpquVZzWnBNKcChYwKzAHXkVfStsVvQ5F/f6QvS2U/Zjdz3hrblu/ZhFOVE0R1JA3fASinVwC2r+qJRXc+kXE9wt3r5RQKekCYvBoQoRTjB5/J5J9xwv4L9kEVbGLfHm8/BL1jZDTsXfZOImmX5Q/j2Hpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=V8PR9CTc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="V8PR9CTc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cH28OCzUCXtIb8rf4iZ/cLsOgAzYvktJTCaR2EzPIi4=; 
	b=V8PR9CTcHMjJ8QWdpKrMNH33+V0npPyybclURKkiBN42b3rCcKFdDrllBgACxr+bbOzAGDyEYQW
	vSAK37PyPPPAKzDYubWQVMFapVSJS/51YDYuHN6uPXudV6cxwaxjoe5zofc+MTVFxJbmEngIJBYrL
	lc07Eeb8beEmD7ccT5WrYAMP0svQn5TKMU1Z6ZSy1NRb0KsC4vto56N1DkjObh8+WdpSzz0JhU72O
	NB3IdJlHKDdpllHsX8Dzc9PgHEBBAgWN1EunofMkHIGWSXH+mCR85ktrG4FYhZHV+pC5hWVlmaVcD
	sIpkahJa36o/b9B+BdFZNX0BDLP5DCYhE0jA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voIg8-004yZR-0a;
	Fri, 06 Feb 2026 18:03:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:03:08 +0800
Date: Fri, 6 Feb 2026 18:03:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"David S . Miller" <davem@davemloft.net>,
	linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH V2] crypto: aegis128: Add RISC-V vector SIMD
 implementation
Message-ID: <aYW8XJk44phI3JSG@gondor.apana.org.au>
References: <20260126092411.243237-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126092411.243237-1-zhangchunyan@iscas.ac.cn>

On Mon, Jan 26, 2026 at 05:24:11PM +0800, Chunyan Zhang wrote:
> Add a RISC-V vector-accelerated implementation of aegis128 by
> wiring it into the generic SIMD hooks.
> 
> This implementation supports vlen values of 512, 256, and 128.
> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
> V2:
> - Add config dependency of RISCV_ISA_V to fix the issue reported by kernel test robot;
> - Add return value in preload_round_data() and aegis128_round().
> 
> V1: https://lore.kernel.org/all/20260121101923.64657-1-zhangchunyan@iscas.ac.cn/
> ---
>  crypto/Kconfig              |   4 +-
>  crypto/Makefile             |   4 +
>  crypto/aegis-rvv.h          |  19 +
>  crypto/aegis128-rvv-inner.c | 762 ++++++++++++++++++++++++++++++++++++
>  crypto/aegis128-rvv.c       |  63 +++
>  5 files changed, 850 insertions(+), 2 deletions(-)
>  create mode 100644 crypto/aegis-rvv.h
>  create mode 100644 crypto/aegis128-rvv-inner.c
>  create mode 100644 crypto/aegis128-rvv.c

In light of the recent move of aes from crypto to lib/crypto,
perhaps the same should be done for aegis?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
