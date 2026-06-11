Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDFF25A2DD;
	Thu, 11 Jun 2026 05:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154998; cv=none; b=k1xRfRPE0eJbVDVJKw8xHKUt5gepVASQzkW1Ss1abaHIvpQsn/0RhBz0v6OH+jrvvn1a7McW/FzSW/haX5Z25GhbmS20PeeME8WcDS+2GHQU4KF9GtajeLhIPNYs+kCGungdjhzH94UNbw6Nt3CYVCu0bg+xAH4TVds7UDUifiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154998; c=relaxed/simple;
	bh=C/r37UCkDzNvAKVVt+5U0UauHsRUaBH7egxUqYMZvXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVyWU7JBtFaI13D4VKDaQO/qFdV3Lmoa+T+vSD+E2RreISsu8vIulYPpLwSfciDyjh3BOH89TjJd0LJSzjkHVRUDgui4Di+TqhqTdO7lbbLtTlpmywcQrzxJYZ/N3n08VSy1W9/842YK08lfHdA2+3VIMC2HpyZEVpz87hsGUUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MQG2Lmi3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MQG2Lmi3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9dYHozM+8mTnEpAwrTAAoqx/bjeUpcqHYAObS20ULYI=; 
	b=MQG2Lmi3FYPbh3PQ0QJK/RyjKxgPzHp1ktHbScVijbT5R3s4qk3B3vYrDJlhNDiWY8Du36aQXFs
	GkkeFz0OQqOL86UJMgF6gY/CgCNOCmSXQp/UZf24cvZLz0KnyBgc9a0fLs55sIE+L61fVwGFQl1dr
	PHDRpoB0gqGYu6sk0HAJOM+zryFuWNeqVRPWN+H4R8e7vENvVfF6khrqLiE87RoMWH4cU0HQ6Jrjt
	8+9Q6wo5RgdnBM8g2qsOrdFypT2Fwt0W3XD5vxjNYGh3p6mfoxqkxEOCgEY7HKSpVbNmbJ2R5N6Gd
	OQiokW/cKDqmHg6O4FkdA9RQCVCj8TiYCLOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXXmE-00000004Txl-0cMy;
	Thu, 11 Jun 2026 13:16:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:16:26 +0800
Date: Thu, 11 Jun 2026 13:16:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregory.clement@bootlin.com, richard.genoud@bootlin.com,
	u-kumar1@ti.com, a-kumar2@ti.com
Subject: Re: [PATCH v2] hwrng: core - Do not read data during PM sleep
 transition
Message-ID: <aipEqj982ozWJXn4@gondor.apana.org.au>
References: <20260601-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v2-1-667ce5da32ee@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v2-1-667ce5da32ee@bootlin.com>

On Mon, Jun 01, 2026 at 03:19:13PM +0200, Thomas Richard (TI) wrote:
>
> @@ -538,8 +539,9 @@ static int hwrng_fillfn(void *unused)
>  		}
>  
>  		mutex_lock(&reading_mutex);
> -		rc = rng_get_data(rng, rng_fillbuf,
> -				  rng_buffer_size(), 1);
> +		if (!pm_sleep_transition_in_progress())
> +			rc = rng_get_data(rng, rng_fillbuf,
> +					  rng_buffer_size(), 1);

Sashiko asks how this can be safe given that there is no locking
at all.  That's exactly what I was going to ask :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
