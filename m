Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C5017C8B;
	Fri, 28 Jun 2024 01:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719539371; cv=none; b=IJ9BRMtYIQXhsmaEkE/QzF0RxQvQn34zxVlI31k79p51h9sPmVJSV+oqP6PwVaOsOJP5KUH1eqoD4Xs/vHRnz1etIceQgZistHAtqe5ePCJXBfEEWE3rJvqq53717oBNPK7ccGOM92xNaRZDhZyW/LnnVDl3yUOReQiRsRe9Zzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719539371; c=relaxed/simple;
	bh=fEbd+4OKzSprxO89Iz9GK5IvVFiVFpZLPmagN4F3mH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4kTpYmjNMO7etb7gvgOuxOO3nNGethBBEgKgoUCb+++kKjDi8Rb+5bvFvl4RMZowEVzIKfdgJvGWJHdPjJs25E+GL8wq8xt6LgylgemInXsxLYh/tBPQwOfzTyweJcSrKSg7DVVfK9LoP/gXWjDKHk9GTh6ifdSS7FoT6Dh1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sN0jb-004GEC-1N;
	Fri, 28 Jun 2024 11:49:08 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 11:49:07 +1000
Date: Fri, 28 Jun 2024 11:49:07 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: davem@davemloft.net, tom.zanussi@linux.intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	russ.anderson@hpe.com
Subject: Re: [PATCH] crypto: Add aliases to deflate
Message-ID: <Zn4Wk8rJpuOCtyas@gondor.apana.org.au>
References: <20240617203316.132697-1-kyle.meyer@hpe.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617203316.132697-1-kyle.meyer@hpe.com>

On Mon, Jun 17, 2024 at 03:33:17PM -0500, Kyle Meyer wrote:
> iaa_crypto depends on the deflate compression algorithm that's provided
> by deflate.
> 
> If the algorithm is not available because CRYPTO_DEFLATE=m and deflate
> is not inserted, iaa_crypto will request "crypto-deflate-generic".
> Deflate will not be inserted because "crypto-deflate-generic" is not a
> valid alias.
> 
> Add deflate-generic and crypto-deflate-generic aliases to deflate.
> 
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>  crypto/deflate.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
