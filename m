Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0518CBE4E
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2024 05:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706248728; cv=none; b=Jb0Nv/rXzS+7RJRJ5q8nUk8Ds8P++PsczCDMyIF4uYdWrWZiG+vd2lvGkgn/LIDARl0V+t0l4N3yE2na7FN2iKcMPdgsT9zzTJeHeDk8n11G71vtHLRBJpLyWn/WI9NWhOZRW1Doji1j7NXb+ty0zF2u3dvpzU3+Rvg9OyHH/b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706248728; c=relaxed/simple;
	bh=9L+GGz90Pc91pu0axVQOTlb+2Gj2Rd8uRYAPgahsf/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Obk+AZK8aOJEOqGssQhoNjAaDyWs/zhX1NDD9+qqatjD4eQSKm3S7Ro+4faz5RXmM9WvH5WXNwmSqyM9qSgzGIJfJoNX0zGNDmzgaQMj5Rsem1nfJaBWg1hZoL6FrwcGcovFtfPT6nVi+cn6nZB3GNVTkTX6trlL7fZAs4/4g3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rTFEd-006Ct5-R0; Fri, 26 Jan 2024 13:58:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jan 2024 13:58:52 +0800
Date: Fri, 26 Jan 2024 13:58:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: rsa - restrict plaintext/ciphertext values more
 in FIPS mode
Message-ID: <ZbNKHGDiGOyIB5+S@gondor.apana.org.au>
References: <20240121194901.344206-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121194901.344206-1-git@jvdsn.com>

On Sun, Jan 21, 2024 at 01:49:00PM -0600, Joachim Vandersmissen wrote:
>
>  static int _rsa_enc(const struct rsa_mpi_key *key, MPI c, MPI m)
>  {
> +	/* For FIPS, SP 800-56Br2, Section 7.1.1 requires 1 < m < n - 1 */
> +	if (fips_enabled && rsa_check_payload_fips(m, key->n))
> +		return -EINVAL;
> +
>  	/* (1) Validate 0 <= m < n */
>  	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
>  		return -EINVAL;

I think this check makes sense in general, so why not simply
replace the second check above with the new check?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
