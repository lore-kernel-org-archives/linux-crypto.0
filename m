Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B54917E00B;
	Mon, 25 Nov 2024 09:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732527351; cv=none; b=H0qQ9Xi+9k/f3AHDB6o725bhaR2zy4Wpt7eJdpSKsQJUwn/+SJ2ZxurD87YEf0iTiLWrJsX/2lx53OnntqQqztbqbRRqLBX1nhuKw9E1JxO2VC1WDtY2pmzMUAIDJTGhMr8L8NpOtbcBaeRZLbf/xwc94ZSlAwYh5/PTBaWGXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732527351; c=relaxed/simple;
	bh=47pj93BkvbbtlxDpOOOfDW6m/GciuSYLivd4omBASGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alsUL4/eGWsuGBAqYiui7Nilma7OHs97BuWH8nekLTT3mgdStFKn6oiWM664TTN98pD8tO5r4KHD9bhLiXnVwjKBtqkESrPU6SG5jY7NAA/ZOeJ2eGs+xQQwYYwy1/3IqXZ7h6QCl9/INfjelef96QdRkcP+ttYBWjuvmrBFEas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CAuWej14; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CAuWej14"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HXQYfqFbYHuEpAtKnrN5Ri66cSthdBXyLJzdbLH+Tyg=; b=CAuWej143vcmdFoP8d0LRNICnr
	AaeRfPRREgp6c31jomIXPxipY8NQEhbpj4pW5AeVB44tu5o0ncz7zioS/dUqQnueJgK9NM8OvKemg
	BW0w3+JkAv36WqcqYCjvR0neQvL89o8ejpmiTHegfdhaizZ0a08XcOUYa0FSXH3G6e8P2HtYfWkHf
	2ujgEhm2Y55lJzmMX3sgRDpRgLB7Ra2cBDCGApWRxO3zNZtpoZvSQKlRztmL92QEqkOyF2aoHctR0
	4eDkTVE91+u4GOLgKWgp9hm9zPIbjdFYmSEQ9CQhMTY7liFcCohuPTZurw62Pkr+aVGaMuMjXF4eO
	fID/9WNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tFVV6-001VRG-1K;
	Mon, 25 Nov 2024 17:35:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Nov 2024 17:35:24 +0800
Date: Mon, 25 Nov 2024 17:35:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosryahmed@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@intel.com,
	21cnbao@gmail.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Message-ID: <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123070127.332773-2-kanchana.p.sridhar@intel.com>

On Fri, Nov 22, 2024 at 11:01:18PM -0800, Kanchana P Sridhar wrote:
> This commit adds batch_compress() and batch_decompress() interfaces to:
> 
>   struct acomp_alg
>   struct crypto_acomp
> 
> This allows the iaa_crypto Intel IAA driver to register implementations for
> the batch_compress() and batch_decompress() API, that can subsequently be
> invoked from the kernel zswap/zram swap modules to compress/decompress
> up to CRYPTO_BATCH_SIZE (i.e. 8) pages in parallel in the IAA hardware
> accelerator to improve swapout/swapin performance.
> 
> A new helper function acomp_has_async_batching() can be invoked to query
> if a crypto_acomp has registered these batch_compress and batch_decompress
> interfaces.
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  crypto/acompress.c                  |  2 +
>  include/crypto/acompress.h          | 91 +++++++++++++++++++++++++++++
>  include/crypto/internal/acompress.h | 16 +++++
>  3 files changed, 109 insertions(+)

This should be rebased on top of my request chaining patch:

https://lore.kernel.org/linux-crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herbert@gondor.apana.org.au/

Request chaining provides a perfect fit for batching.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
