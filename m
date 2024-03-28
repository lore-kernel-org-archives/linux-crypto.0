Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94854C62E
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 10:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711623360; cv=none; b=H5nkV9JgRQ/etdbYNZ/pYR+6JxqaxCktn6qE8eQzovyNN+XxefgmCd2RWCmPBCvm/XksZiRGAkEl6wIhHv2x3q1DPTJUyu9XXVvRj49KkH9OzvwtQUQxFp5azHD49RPMQ8akbxDN6EKqnS/bnyw1Mb4JWwWqvlBcLPdPsoJK+Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711623360; c=relaxed/simple;
	bh=FJpI8A6NrgCPAGBZO8P/lsMrsDeicY0KL9y2p22JHWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CgE+Weu2Eg9exALduNIs0uGjZHE6kLD5ZS8THlFr6hSD9m/VdKMyeBV7bzCXilfqk0GKyDiCd6N1QsR7Yv/IykHdjR0cWxKkpGkOCMs2KjEf6h+xa77MtuNS01+u56NStHgmfvXRC+QKvV8sqPvJkolnymOww8UMRCEYfpOOJ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rpnQH-00C8SU-KJ; Thu, 28 Mar 2024 18:55:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 Mar 2024 18:56:10 +0800
Date: Thu, 28 Mar 2024 18:56:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>
Subject: Re: [PATCH] crypto: ecc - update ecc_gen_privkey for FIPS 186-5
Message-ID: <ZgVMymPK3Q/6tiU7@gondor.apana.org.au>
References: <20240320051558.62868-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320051558.62868-1-git@jvdsn.com>

On Wed, Mar 20, 2024 at 12:13:38AM -0500, Joachim Vandersmissen wrote:
> FIPS 186-5 [1] was released approximately 1 year ago. The most
> interesting change for ecc_gen_privkey is the removal of curves with
> order < 224 bits. This is minimum is now checked in step 1. It is
> unlikely that there is still any benefit in generating private keys for
> curves with n < 224, as those curves provide less than 112 bits of
> security strength and are therefore unsafe for any modern usage.
> 
> This patch also updates the documentation for __ecc_is_key_valid and
> ecc_gen_privkey to clarify which FIPS 186-5 method is being used to
> generate private keys. Previous documentation mentioned that "extra
> random bits" was used. However, this did not match the code. Instead,
> the code currently uses (and always has used) the "rejection sampling"
> ("testing candidates" in FIPS 186-4) method.
> 
> [1]: https://doi.org/10.6028/NIST.FIPS.186-5
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/ecc.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
