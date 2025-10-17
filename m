Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBA1749C;
	Fri, 17 Oct 2025 01:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760663107; cv=none; b=sxEiVbCfNANQGYuXN+EiLMTRliBl5RuXq7VJs2KgQPuEBhftSzr5vV0n7OGkKNrP2MgrfzAbSKVPih07IDI6oNfQpNq/lBZW6IHJxoCDdpKiIQgYSdRe1J9TT7g+Zw0pmYpkuqnYs6Tl9+4OfjoYS6wW3cq/mgzogInxkdcfNaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760663107; c=relaxed/simple;
	bh=PQHjYRJwHjVN5siHsiamVg66MeCJnbXPENtO7QJyiSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1QnaHTrANi1dXvgZ1cSwtB3NrNb8ThRRFlGi8e9ESNd/FB1sxd8mAG/C4djc99eLbNTL7yokVrB3smyxCT2GXvyaBPVagPgHWZoJNeVGYUvcFdrQ+ANKCIFWl+PRy/QOnC9wo5QVi4nnYHYjpQ0Uo+y6oawhElfoBCS4d3qe30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=k2trUUsj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="k2trUUsj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+otO8+xQP5h/AbkUw+yS5HniWJg0TnvYn6GLh2V4iXs=; 
	b=k2trUUsjFYPeZZ1Xmz4s0eIEA7Wkz09DXOODOvy29JYHw0wua64eqVXrymqancOj1qDSGwNsLCz
	nWiRLxby0RcF9kcWZMK/zi3UNslIJBbeCc/neDsgHNCzjcqFIygIIPaEKDtTfBt5E/ucZlsiQkdbU
	FELqK/scO5UYL1CsYNhgMDc5iFhnHeuRSGxGugse+I2TWNk16O2+qmawToB63R63DM4g0I+Ka6NC+
	/YRKNtHlau4tb02hYx1A3m32lwKML0J3g5VQxxkVs+wWzznokomG6j4El2SWpnTejFj2ITPpX66z7
	GkFbiYBErjIFeCG1l/W2B1Ueb8BLHzQUOggA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9YtR-00DI3b-2k;
	Fri, 17 Oct 2025 09:04:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 09:04:29 +0800
Date: Fri, 17 Oct 2025 09:04:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v12 19/23] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Message-ID: <aPGWHWlsStefuvKL@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-20-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-20-kanchana.p.sridhar@intel.com>

On Thu, Sep 25, 2025 at 08:34:58PM -0700, Kanchana P Sridhar wrote:
>
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 0f1334168f1b..e94046529e46 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -108,6 +108,8 @@ struct acomp_req {
>   *
>   * @compress:		Function performs a compress operation
>   * @decompress:		Function performs a de-compress operation
> + * @batch_size:		Maximum batch-size for batching compress/decompress
> + *			operations.
>   * @reqsize:		Context size for (de)compression requests
>   * @fb:			Synchronous fallback tfm
>   * @base:		Common crypto API algorithm data structure
> @@ -115,6 +117,7 @@ struct acomp_req {
>  struct crypto_acomp {
>  	int (*compress)(struct acomp_req *req);
>  	int (*decompress)(struct acomp_req *req);
> +	unsigned int batch_size;

There is no need to store the batch_size in the tfm.  Just return
the value from acomp_alg directly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
