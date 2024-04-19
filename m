Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E9E7E77B
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 10:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524355; cv=none; b=b4hs/or2nTBXzeURFe7pDrSmq3rdg7VfEh1BzvyVSZsr/ZmIA7OBSXjBwdMTE1HKsDYh/eB8aE4bJkGO+nypKSmU0seKvQt6d4URs2Nj2+hF1pEU8/uQEf88243S7SEscwX3sD5CFFi57UZqhVs074/xvGdPPXCiRbJLHGlzTFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524355; c=relaxed/simple;
	bh=J32OATyMAthrQ9bLqk2hVd/jOH5fdg9poOvJHzZ91AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWBG3G39YfS/BjFPsfrWaR3Tf5TjmGs4MMp2d14imjcsK53DfOFjMEIjqKC6f5TNYEq+d+a2WP7SSE4srD0fCp4q0JqcU5kC6/pXVeHfK/M4zDZYg/Vve89HMXP5NaSuvacjoeuxd4uVaDwsUJHIg6yCiKPXbcxQvHse8EjEtb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rxlxU-003sR4-LT; Fri, 19 Apr 2024 18:59:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Apr 2024 18:59:26 +0800
Date: Fri, 19 Apr 2024 18:59:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - implement dh fallback for primes > 4K
Message-ID: <ZiJOjmRZnAlmHYf6@gondor.apana.org.au>
References: <20240411092526.127182-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411092526.127182-1-damian.muszynski@intel.com>

On Thu, Apr 11, 2024 at 11:24:58AM +0200, Damian Muszynski wrote:
> The Intel QAT driver provides support for the Diffie-Hellman (DH)
> algorithm, limited to prime numbers up to 4K. This driver is used
> by default on platforms with integrated QAT hardware for all DH requests.
> This has led to failures with algorithms requiring larger prime sizes,
> such as ffdhe6144.
> 
>   alg: ffdhe6144(dh): test failed on vector 1, err=-22
>   alg: self-tests for ffdhe6144(qat-dh) (ffdhe6144(dh)) failed (rc=-22)
> 
> Implement a fallback mechanism when an unsupported request is received.
> 
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../intel/qat/qat_common/qat_asym_algs.c      | 66 +++++++++++++++++--
>  1 file changed, 60 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
