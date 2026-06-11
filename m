Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790A2EB0F;
	Thu, 11 Jun 2026 08:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167742; cv=none; b=lv8VpEA9uUWFKpN9lLU3OMvgUQj9FXRdFI0a+waUBs0YafFRVYLbyMabudnsKidhpuQqDwCmVd0PNgmp0BoJDJEnGH1yGvLswjrNc4DH/Wrqg9M3p/+rHH5PGnkkymLzhmGZVb87igqXdCniSQjrw/qzxRD1fhtjbs7lZ8pYwLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167742; c=relaxed/simple;
	bh=KmUBOod+bdcfw7TO+IHiPF2Yu0qcxFioX+evYn9InQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG6yVQ7vZKBDSDGhLsN53NiALUx1Chq0s2Fv3q/twZbo87NPoeY+WJWHICZZrqGfVUA+MjGUjC5Wgc3cpKQlP3vYonkHQ+jfmFrlChql435V0BTMdKFsgTQIMAOo9rn8wzK8+M8494aBRuiB2j2IfBA/yU0SNmKUIT87StIp4OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IImM62aC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IImM62aC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QQm2jwLs/EAdPqnVD3OnZ1YF7ka09zxXxXw4pnxA2UY=; 
	b=IImM62aCTzUVqQk/pgtpU0qUmBH0Qf/4Yu+k0YnL1i05CP3zk4JnNbHRFGJ3TbBXSanbO9ZHKSw
	hxXq2eQ2Csr6hWJFiZ2wLWyJVfzgogoWhYd9M84x61UdWtMjNXNLoLmp4oAWbZZzpte06UX64YR17
	AShxQml5FxpODWypyVbzmtl07j89hap19HSV+ejE5VDkru2GgCdIHbgZOQ4GGVFtZPR8DgJ0UpqVX
	VxA6GmAhXyopt9D4crzDYfhiMz4/CJmM1YqCEUZPGZCTjwyy9m1s+fNt/j/flhVxSerIsxjq+cejN
	oiHuJeTEHBOhkgx9X5/grR4LVffFVPX5ytQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXb5i-00000004XUM-0Rj0;
	Thu, 11 Jun 2026 16:48:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:48:46 +0800
Date: Thu, 11 Jun 2026 16:48:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	Weili Qian <qianweili@huawei.com>, Wei Xu <xuwei5@hisilicon.com>,
	Longfang Liu <liulongfang@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] HiSilicon TRNG fix and simplification
Message-ID: <aip2blIEFe3N1MbO@gondor.apana.org.au>
References: <20260530202624.20768-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530202624.20768-1-ebiggers@kernel.org>

On Sat, May 30, 2026 at 01:26:22PM -0700, Eric Biggers wrote:
> This series fixes and greatly simplifies the HiSilicon TRNG driver by
> removing the gratuitous crypto_rng interface, leaving just hwrng which
> is the one that actually matters.
> 
> Note that this mirrors similar changes in other drivers such as qcom-rng
> (https://lore.kernel.org/r/20260530020332.143058-1-ebiggers@kernel.org)
> 
> Eric Biggers (2):
>   crypto: hisi-trng - Remove crypto_rng interface
>   hwrng: hisi-trng - Move hisi-trng into drivers/char/hw_random/
> 
>  MAINTAINERS                            |   2 +-
>  arch/arm64/configs/defconfig           |   2 +-
>  drivers/char/hw_random/Kconfig         |  10 +
>  drivers/char/hw_random/Makefile        |   1 +
>  drivers/char/hw_random/hisi-trng-v2.c  |  98 +++++++
>  drivers/crypto/hisilicon/Kconfig       |   8 -
>  drivers/crypto/hisilicon/Makefile      |   1 -
>  drivers/crypto/hisilicon/trng/Makefile |   2 -
>  drivers/crypto/hisilicon/trng/trng.c   | 390 -------------------------
>  9 files changed, 111 insertions(+), 403 deletions(-)
>  create mode 100644 drivers/char/hw_random/hisi-trng-v2.c
>  delete mode 100644 drivers/crypto/hisilicon/trng/Makefile
>  delete mode 100644 drivers/crypto/hisilicon/trng/trng.c
> 
> 
> base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
> prerequisite-patch-id: 07e982b663ac3f8312ca524f6b91b5b38661df5e
> prerequisite-patch-id: 72064361a8f36e015ab0b7e1fa4d364b40d90506
> prerequisite-patch-id: 8978b8e0db7f47935e5f6f0aff14a97f55d3073c
> prerequisite-patch-id: 6aa0e3e93a008279d71e535a3d0cf48643f55e19
> -- 
> 2.54.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
