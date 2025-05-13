Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486AC1F237A;
	Tue, 13 May 2025 08:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123330; cv=none; b=Fs/Dc+kQpA9CoVvacYfEDsIj/oE+ui6v5R3Z9GgcCKvDj4exGI6dC3JmgKXjNmTAooG5KX8JXojZUYwEX0Fubakw/i1yp6JK77dfUA9T4qvsVdLB3g0Cbh90DOTlxn/infv4hrObLaBnaq8v/j0wQwod23BCvU7ioklJG1j7wpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123330; c=relaxed/simple;
	bh=8AlpCzHz8TYu2I39d9JcmlixFVJtz7YHX6TswcmhI7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSeM4+3dqA/I2jH+Wky3jmxCinONLx9l6VeJCs1lSp069U7uBFl9XS2x8T3sxi4aHdBiZAdNa5ziCWl/gdbzZwVYFCQth49sA+8mVw2B+t7KOUxzqJSHQLBrqc2JhnBBuZ/nFKo0Mvy7cSlGPhCvtDwuZeME9jdbtHxZjsWu/UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QE38+k6H; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QE38+k6H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=udPvSCRSnS0pLMv4b2XH86HcPTSJhkrdLImmvkdv1Ag=; b=QE38+k6H+mGxa3TKMTxlicJh9M
	0vMBdCSj6ehOIwHSwWiwZcVQCSMkZVlkQ2yloLbJq3AFvXIffUrm7I6drOxQ5sej9lbUGStQLyLXL
	xZL361GdJNngh+v+4igmgCNtZkuetRUkNEcv0GNUcFBB4inkfHg+fUaT97+M4anLYfXQOA/wUi88s
	Som+95F4ndpWdL2WvX1le7NGCH5/S2nnQFOUHRcbwqO2cidhwD4XeXU/tGCucS7Le/m9Pm2pUJdgp
	7tFYigMgn/VXX0bUiQKo5fx/eUD36Ioj9DBqGKoJCzu6vijpHR88NJnYuOoDQRhObCBm5B+KTbvVy
	aFdAsLpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEka7-005hLH-11;
	Tue, 13 May 2025 16:01:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 16:01:43 +0800
Date: Tue, 13 May 2025 16:01:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v9 02/19] crypto: acomp - Reinstate non-chained
 crypto_acomp_[de]compress().
Message-ID: <aCL8Z-XHk4StnvPQ@gondor.apana.org.au>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
 <20250508194134.28392-3-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508194134.28392-3-kanchana.p.sridhar@intel.com>

On Thu, May 08, 2025 at 12:41:17PM -0700, Kanchana P Sridhar wrote:
>
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 82fb3c04e68f..d08e0fe8cd9e 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -310,21 +310,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
>  
>  int crypto_acomp_compress(struct acomp_req *req)
>  {
> -	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> -
> -	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
> -		crypto_acomp_reqtfm(req)->compress(req);
> -	return acomp_do_req_chain(req, true);
> +	return crypto_acomp_reqtfm(req)->compress(req);

That's not right.  Request chaining has already been removed.
What remains is linear address support which you've just removed
with this patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
