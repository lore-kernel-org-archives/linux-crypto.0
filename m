Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DE0172764
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 11:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718968682; cv=none; b=tXQGRzvYI/2wLR8utGAcEdw0ID5C6IeMtdANSW47nfwktpqF1OcqNkoyA+i3WdnqpLoP9moeGL+zMk8V9d6iZ2LogFRe5AuonmG2KhjMpcZTQAxZ0LnPGHcBZTemvM0PExaWkqtCke7GD0Dqmg/yBQMQr2a3BORHngjAJKDCrEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718968682; c=relaxed/simple;
	bh=M2E5FPK+P7aVGl7WNzGahMuf0WYQOrar8V2Ih0zJOsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X61C/uTpJspBRGPs7UlpvyMLNRmx3JSd/u5FFH88Y/bZH9+Wn7s5s5UWLbA5yArKIj+nNp5T9loCgOaw8iaUcKJlMDx8LYqqhIbOB4loWdXQeAtgSyHGm1HujBHQlbfPz1GirlBeDsF7sielX7xhS1YkWon9xrHcBOuuA1+Q9dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKcH0-002daa-03;
	Fri, 21 Jun 2024 21:17:43 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 21:17:42 +1000
Date: Fri, 21 Jun 2024 21:17:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, dengler@linux.ibm.com, Jason@zx2c4.com
Subject: Re: [PATCH] hwrng: core - Fix wrong quality calculation at hw rng
 registration
Message-ID: <ZnVhVqHAU6TDOIKR@gondor.apana.org.au>
References: <20240621095459.43622-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621095459.43622-1-freude@linux.ibm.com>

On Fri, Jun 21, 2024 at 11:54:59AM +0200, Harald Freudenberger wrote:
>
> @@ -545,8 +546,14 @@ int hwrng_register(struct hwrng *rng)
>  	complete(&rng->cleanup_done);
>  	init_completion(&rng->dying);
>  
> +	/* Quality field not set in struct hwrng means 1024 */
> +	rng_quality = rng->quality ? rng->quality : 1024;
> +	cur_quality = current_rng ?
> +		(current_rng->quality ? current_rng->quality : 1024) :
> +		0;

The number 1024 is meant to be user configurable.  We sould move
the rng->quality initialisation from hwrng_init to hwrng_register.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
