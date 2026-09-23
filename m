Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15667473C86;
	Wed, 23 Sep 2026 08:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153507; cv=none; b=UY8HRShtlNQeMOrUzWGQIcIVi4poA85P7mctg22QoxgkWDc3O+nc0NOmbhX/Hj6BrKm/PJLMGIvTdzo6ZbVwMUHsgmhrhKA8Kiv8Y++zYav6hliDW5F4Lyx0GBy4jY1J8uaZaaenMg3Ll/Sm5Y4hSuXYaX+0AB7y8HFdx/efNNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153507; c=relaxed/simple;
	bh=IjrAOGLFJ3kDUr1SO+rRxFDNeiDjrtz8Nglkhm/hlYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPgZ1QzASoXwbfKt/TzRlogzqwyZ22j2HNC/ApEFuy8VOlBqmVHjdgBV2oZ2gTtYLBKDwrZB1XCeeMhTmyfFr+LCeLrAaXGbZO6LHjFarFIUq0ANBlP9w3lCnJ7c2kHAoAMPkCy9V/n9kEcz33JzLF1cBmX5BFAG9z4FfHTYV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IQXI6V+9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IQXI6V+9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=y64sLOl1wcR0EFaDPT84zdtExiCsWPjSAzpuBJJV7+Q=; 
	b=IQXI6V+9204LcR8vM2su3bnEKNWnOyikSSMIrpjJEckAoumeebZa16wSDTl6QlOLT6AlUtvWcbh
	QuoBxLRlfN/sfwVsDrx4pmR50bsaQCgF9mHLiwQhaQMvsmjSMrP8t4yeEP7nHrNK7H+4sj1FpWjNv
	7cgkqxjGbz77OzVn5dza1Hb7qQhw890KEbT6zGHNi+W+EK2d/o14ISCsCd+G1HvGSHq/QHu0hpPBo
	V28WehQxhoIgPXav1P6tGouPlpNbFb0rxuZ12vKkULCsG4gUgOXt+JMAylv+jqyk8ow7PzvW/qUAE
	Q0Psys9iVgcP1scfgI4Q6frQCIoa5YU1Bs6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IhZ-0000000GyEQ-2Kzt;
	Wed, 23 Sep 2026 16:51:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:51:41 +1000
Date: Wed, 23 Sep 2026 18:51:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com
Subject: Re: [PATCH 0/7] crypto: hisilicon/hpre - misc fixes and cleanups
Message-ID: <arOTHcB78JaQK_8P@gondor.apana.org.au>
References: <20260918122726.3014899-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918122726.3014899-1-qianweili@huawei.com>

On Fri, Sep 18, 2026 at 08:27:19PM +0800, Weili Qian wrote:
> Patches 1-5 fix bugs (OOB read, dead code, wrong errno, DMA mapping
> and GFP flags) in the ECDH/RSA/DH paths; patches 6-7 are cleanups.
> 
> Weili Qian (7):
>   crypto: hisilicon/hpre - fix pointer dereference before length check
>   crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in
>     ECDH
>   crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output
>     buffer
>   crypto: hisilicon/hpre - fix ECDH destination DMA mapping
>   crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
>   crypto: hisilicon/hpre - extract clusters num into inline function
>   crypto: hisilicon/hpre - remove unused macros and struct fields
> 
>  drivers/crypto/hisilicon/hpre/hpre.h        |  1 -
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 28 ++++++++---------
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 47 +++++++++--------------------
>  3 files changed, 28 insertions(+), 48 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
