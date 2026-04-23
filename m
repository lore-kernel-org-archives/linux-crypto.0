Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D23DF01F;
	Thu, 23 Apr 2026 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934828; cv=none; b=SIlQM0zLBag1AF3z4Xq579wRb/sOw61onQmZdcJyt01Yb1bqYZbLIq/N/MNxzDwFVKcNFQWuomf+C0+SU9rBmktyEyZtQS6Pb0zz8YHCrJbiWRzhjX5F7rEUnBthNU4QJ1WL7zGVxB9hZh/2RYFtu65gwgmpMzCZTQQSMwwqgQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934828; c=relaxed/simple;
	bh=9GLRlXD8R89QRKSo0VDxPUaNV3rb58H9I9inklx+S1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORLHGubqtBM1HQgd3qq/kkn5hbmb8ED/4JMKGQ8KFpua7KUg2gEkBEy7Qc9j7iWBwBJ3JWw4N/U/z8JgvH0yCsIqHby8alaVKNBA769cQa9k/jfMIc8Rd3pgnImZyPBZNY9kxWyAnl6j8k8PBnWTuapZmFdSiCTXW4vOWFCo45M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bFq9fzlt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bFq9fzlt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xBJpx/WgTzQTJVK4tn9rHHDlfR/K86CEVs4Z2TnHt0s=; 
	b=bFq9fzltYEiVavjVtc+vdeaill1Bwv8zaChgD1DzEz7SvrhW6nwzteZ78GArSM8UAcVXm1FefAd
	+DsbNkFiFzUmSQ9oAOQiU97ApNIvOLgL9UdtWvRLULmGWOqGHC3SNlPaBzppyTQHNsJx5eYedYmt+
	rh4xVHeC4EuIGh2QXqAoFI4q/PGbsxVHpel9+cNa7IZO72Hu5VtShPHqAS4hWwi8Gx5ITNH90pl9Z
	2dbJc/KBYIy176MUx+iApuQmOJ555QAP1gCAYU4svWazc8Mvfo3BecfI2CrMX4hc8nO+8PuDXAGbK
	29CIUIkGUrhMMe6lOppy75v1i2uO4qQ6OSnA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFput-008Bgo-2U;
	Thu, 23 Apr 2026 17:00:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2026 17:00:11 +0800
Date: Thu, 23 Apr 2026 17:00:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Eric Biggers <ebiggers@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - avoid hash and rng references
Message-ID: <aenfmxOvtHaAODqH@gondor.apana.org.au>
References: <20260423065600.2081989-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423065600.2081989-1-arnd@kernel.org>

On Thu, Apr 23, 2026 at 08:55:42AM +0200, Arnd Bergmann wrote:
>
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> index 58a76e2ba64e..813c4bc6312a 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> @@ -247,12 +247,14 @@ static int sun4i_ss_debugfs_show(struct seq_file *seq, void *v)
>  				   ss_algs[i].stat_req, ss_algs[i].stat_opti, ss_algs[i].stat_fb,
>  				   ss_algs[i].stat_bytes);
>  			break;
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
>  		case CRYPTO_ALG_TYPE_RNG:
>  			seq_printf(seq, "%s %s reqs=%lu tsize=%lu\n",
>  				   ss_algs[i].alg.rng.base.cra_driver_name,
>  				   ss_algs[i].alg.rng.base.cra_name,
>  				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
>  			break;

Does this work?

			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG))
				seq_printf(seq, "%s %s reqs=%lu tsize=%lu\n",
					   ss_algs[i].alg.rng.base.cra_driver_name,
					   ss_algs[i].alg.rng.base.cra_name,
					   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
			break;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
