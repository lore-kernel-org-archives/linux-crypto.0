Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19B154673;
	Fri, 31 May 2024 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717151053; cv=none; b=a76tEUwKeKA41Uf1LmtdYSYtDwm05jQwnwppZNB1nbef9OlD46Bzibfld+A4hZYsQH/W5RBno4zqS6R9Ks2nkW4EpPJTmTJs/LkrWRvjTcKwLS2D2BML0a7uPPzq7olqGvsr5sQCr/LNjQUvKxvP43NuYdukURV9bPPhsZ1cewE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717151053; c=relaxed/simple;
	bh=TnxfUSFytuBgiNFeRF6e16Fh5bmiFPHnISSe1fs+ZH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHPvMRC6l3JIQg9I4KjcNcR6B7Bj0qWeqe9hzWvCPj3IFE/I2psrL6un1wahJYmXy416YxEZp9O3wTCu0spQpZ64gdk/TtVdpQKUBuqdJG4K4b25LTg9/PEBLu7toPiyZaQVrIQJ/CZIZdSWXmac8q5VOTA2aa0ArxPsl5Wcyw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCzQZ-004Ao7-25;
	Fri, 31 May 2024 18:24:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 18:24:05 +0800
Date: Fri, 31 May 2024 18:24:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: Add missing MODULE_DESCRIPTION() macros
Message-ID: <ZlmlRf6bMK3tIVHO@gondor.apana.org.au>
References: <20240523-md-crypto-v1-1-eb68e4aa5592@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523-md-crypto-v1-1-eb68e4aa5592@quicinc.com>

On Thu, May 23, 2024 at 12:47:39PM -0700, Jeff Johnson wrote:
> Fix the 'make W=1' warnings:
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/cast_common.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/af_alg.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/algif_hash.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/algif_skcipher.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/ecc.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/curve25519-generic.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/xor.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/crypto_simd.o
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  crypto/af_alg.c             | 1 +
>  crypto/algif_hash.c         | 1 +
>  crypto/algif_skcipher.c     | 1 +
>  crypto/cast_common.c        | 1 +
>  crypto/curve25519-generic.c | 1 +
>  crypto/ecc.c                | 1 +
>  crypto/simd.c               | 1 +
>  crypto/xor.c                | 1 +
>  8 files changed, 8 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
