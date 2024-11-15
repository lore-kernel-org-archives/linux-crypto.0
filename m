Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE921B85C2;
	Fri, 15 Nov 2024 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731670402; cv=none; b=oGh054tyvBSsb+I8sdnTZdztE71C4lt+8ArItogao3reeL52bCpOy4tA+3x0nOv9L/hJxVM36r8Yas0gVsQSbKy9kxzzxAZ1pPI0Qf7beJIDwoUfJATupTahQQbXQrtadCD9bJwai/algMew9vpDhHGmcMWEiEMz1OkBiTP3No0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731670402; c=relaxed/simple;
	bh=v9i28nJCezREsYArIUCbJka9KYdGM/FFt3R8pcRKFkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhanvGZNTuULMTAlUj7zNEBHTOiqOYQz4mvmUFHFrNftf+aGruXTq8iRNVefIREOXvNsyl3OyNsqtHcsmMFJxkByxrgkSSU00hXTjpALl6erYiQ7yFdsWAyOKtfipFQQLvmFcbFhAYmpZ1kIBr8Duv9E+Djidfsvzx04Ahtix5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MR4KkWGO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MR4KkWGO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2VqsRLp8fru+hs5a9XxkUuNEDw9hbg6t75bmYJqUWkQ=; b=MR4KkWGOZxDE/DEYPmGfsEqBL/
	8Smn1EmJlmeyYlkBDwaAOENA9l/W8G9bO6ZKD2m5WL3PlOiPFKATroizzwctEPIke+NNgEBjuK15k
	qwDxK5bbQP9cBHbr9EDtuu8SZai3fl+gRShqO2aTnwZ8X4tuIrkS2V2DJMP3ZnuDwBCuieyejTaHM
	NUYOFg2Q07sQYVyvKINlQg45ptlGKh76Hawpqj9sw2CHirDvsopPHccpIE8Y9jbAqmyJ793pGMaa1
	XylVE/KYSxyyohxd3OFvlk+F0FzSlId2hMQotPWPtOgN5YplOgoqLBMfrHYANxGFOeX0QpFakxFzZ
	F2e5ZWJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBuZH-00H1fs-24;
	Fri, 15 Nov 2024 19:32:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:32:51 +0800
Date: Fri, 15 Nov 2024 19:32:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosryahmed@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@intel.com,
	21cnbao@gmail.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com, zanussi@kernel.org,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v2 01/13] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Message-ID: <ZzcxY8P8NdfwvxB_@gondor.apana.org.au>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
 <20241103032111.333282-2-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241103032111.333282-2-kanchana.p.sridhar@intel.com>

On Sat, Nov 02, 2024 at 08:20:59PM -0700, Kanchana P Sridhar wrote:
> This commit adds batch_compress() and batch_decompress() interfaces to:
> 
>   struct acomp_alg
>   struct crypto_acomp
> 
> This allows the iaa_crypto Intel IAA driver to register implementation for
> batch_compress() and batch_decompress() API, that can subsequently be
> invoked from the kernel zswap/zram swap modules to compress/decompress
> up to CRYPTO_BATCH_SIZE (i.e. 8) pages in parallel in the IAA hardware
> accelerator to improve swapout/swapin performance.
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  crypto/acompress.c                  |  2 +
>  include/crypto/acompress.h          | 82 +++++++++++++++++++++++++++++
>  include/crypto/internal/acompress.h | 16 ++++++
>  3 files changed, 100 insertions(+)

Please take a look at the request chaining patch that I created
for crypto_ahash.  It should be applicable to acomp as well.

https://lore.kernel.org/all/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
