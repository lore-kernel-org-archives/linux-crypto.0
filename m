Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F153209;
	Sun, 16 Feb 2025 05:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739682657; cv=none; b=og3dZdTgOc7B1+NoK0hZ5hF0jjgngucqVsjkI6YCW7a5Dur377Wteh1E8YAUL/hr6fvBMr1sxwNNsVILRDJFbmA2jBZih8OHp2FztBLmJh5pLxLd0ZV025YAonaKa3VJcq5feFQjJPHVCTKI2V4wYPy9E3cEsvpzZAD03ZIshfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739682657; c=relaxed/simple;
	bh=mVpititt3FOPOuTOtPU/fN66eVnjLMbye7wPrIHxFWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MtIvF5+l1HqnoiyYUPCGpKbQHP/SX4bmpmDLAWjSg/W7qS4LYFOCCf1DWJLphkqlQLwkRcVut0V93NJctg5RLHhSq7W8GOLWiRY+6erd4E5pAg2apOemQPDHBm4TB3x89ZJ8njDzsOyTOQZDaMOj1EzjgcO9Vb6BohHlsYS6GLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b7E6XKQc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b7E6XKQc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f7RtmdJ5KUIMrq7cdsN0B5NpP3HuWU6euFmNqdKBSyI=; b=b7E6XKQcwZN+hBGza39tXleN3N
	Xt9v5FVAp/ZwfgnY4DUExKVNDa6dP/A1JX3Ii7w3YDwX7OIY4gkNS95QpotHbBWqAjIGlbX2Kweub
	kkU8NX7/RZU62dxoo6G6t9qVeaeEhtdBxPUEeNKlo7CpxeftnwffR4afRRnXX+biLyOxf6maoj9rr
	47vvzsils+IYKF1752cVzPg2Qzc0EqXrdTx7UAMRrqGE50qB2xO8UCLDZaQHKmXJeZEMryysBLYq2
	fcFUCcSNyYDpE7+fvsOylCG12Ze4i93hqlgPXe8A9UibQsKMY5F4aKscNJydBs4AZ/1cl8JzGEkdF
	d6YNfzlw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjWiR-000hE4-2l;
	Sun, 16 Feb 2025 13:10:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 13:10:36 +0800
Date: Sun, 16 Feb 2025 13:10:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v6 02/16] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z7FzTLPSrnixkvGQ@gondor.apana.org.au>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-3-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206072102.29045-3-kanchana.p.sridhar@intel.com>

On Wed, Feb 05, 2025 at 11:20:48PM -0800, Kanchana P Sridhar wrote:
> This commit adds get_batch_size(), batch_compress() and batch_decompress()
> interfaces to:
> 
>   struct acomp_alg
>   struct crypto_acomp
> 
> A crypto_acomp compression algorithm that supports batching of compressions
> and decompressions must provide implementations for these API.
> 
> A new helper function acomp_has_async_batching() can be invoked to query if
> a crypto_acomp has registered these batching interfaces.
> 
> A higher level module like zswap can call acomp_has_async_batching() to
> detect if the compressor supports batching, and if so, it can call
> the new crypto_acomp_batch_size() to detect the maximum batch-size
> supported by the compressor. Based on this, zswap can use the minimum of
> any zswap-specific upper limits for batch-size and the compressor's max
> batch-size, to allocate batching resources.
> 
> This allows the iaa_crypto Intel IAA driver to register implementations for
> the get_batch_size(), batch_compress() and batch_decompress() acomp_alg
> interfaces, that can subsequently be invoked from the kernel zswap/zram
> modules to compress/decompress pages in parallel in the IAA hardware
> accelerator to improve swapout/swapin performance through these newly added
> corresponding crypto_acomp API:
> 
>   crypto_acomp_batch_size()
>   crypto_acomp_batch_compress()
>   crypto_acomp_batch_decompress()
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  crypto/acompress.c                  |   3 +
>  include/crypto/acompress.h          | 111 ++++++++++++++++++++++++++++
>  include/crypto/internal/acompress.h |  19 +++++
>  3 files changed, 133 insertions(+)

Please get rid of these batch interfaces.  The whole point of
request chaining is to remove the distinction between batching
and normal requests.  IOW, if a request is chained then it is
automatically processed as a batch.  If it's a singleton then
normal processing will occur.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
