Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CD72116F4;
	Mon, 13 Jul 2026 03:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914298; cv=none; b=JV3foBFEkBsp4a7v2q5K1HOe7qHds0yhDiitNw+DYc43oaFvoHDkLYM1W6yiCrr0NcNORct4ByHoBIr/b8996cKaF7fA5y+XRNg+nrqkB+MZKl/LALhQctwp37KyEGhkUXhv30xbcVncvqM44tjek90tSmWvqzo0zckY/d1iOKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914298; c=relaxed/simple;
	bh=r8sfdbqN1zs6K8NiXsx1BVuNZ9M2YhYO4Ctgpt76Edw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDRxFOO27bRHI8rD3i/i1Rg7ozufg8S5uhQoYtozHV3kIeBRqru8mCpRnn8QMOcAMIURQGDD4A4h6NngI/dxGBAiecfArtZgK5IpX0cb4XcheDnFzSoT+YduDwgGmKVjqcLdoW6rwZuQ1O51Vs1TFqkxU1X/mZpItzr4F6OqABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=l//rRRH1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="l//rRRH1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RREQle099gdxdz7gtCoh4ys0y9zML3oLj26BLgi/8GE=; 
	b=l//rRRH1MwZXJiVab728G6psnKp8my4yzdw2/SuqSldp8ojJWtpcuhpnDRxZ+sELPkfaaL35CSJ
	CGslQQUJygsEP47uRZ6iFY8p1jvBGnOKGsf54VoaD6/HhI6I6DPWZJh6LVhnTF26xcJYnbuniZjmE
	hVw3IkJdV2uQeIhRLq97EFB3FdviM+9lJIMk18nRNotBCOqlfcnCsvo6GcP8bbU6ZHBuIO+KwuHGG
	Z2KqxHgRdJq3PVwh8RWEY+0IRUs6/+8jnj29YX76zIHBBixOpWQXG1w1OfL4HfS+di15P1e0l80HI
	zmQxCbof8LCLLvRA9IfWCVEoSs8TIhRMyAWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7b9-0000000CyH7-3rWD;
	Mon, 13 Jul 2026 11:44:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:44:51 +1000
Date: Mon, 13 Jul 2026 13:44:51 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yuho Choi <dbgh9129@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Alexander Sverdlin <alex@sverdlin.org>, Nishanth Menon <nm@ti.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] hwrng: ks-sa: Fix runtime PM cleanup on registration
 failure
Message-ID: <alRfM-Ygtmk1UNa2@gondor.apana.org.au>
References: <20260702233921.100478-1-dbgh9129@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702233921.100478-1-dbgh9129@gmail.com>

On Thu, Jul 02, 2026 at 07:39:21PM -0400, Yuho Choi wrote:
> ks_sa_rng_probe() enables runtime PM and resumes the device before
> registering the hwrng. If devm_hwrng_register() fails, probe returns
> without dropping the runtime PM usage count or disabling runtime PM.
> 
> Unwind the runtime PM state on the registration failure path, matching
> the cleanup done by remove().
> 
> Fixes: e9009fb227fa ("hwrng: ks-sa - Use pm_runtime_resume_and_get() to replace open coding")
> Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
> ---
>  drivers/char/hw_random/ks-sa-rng.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
