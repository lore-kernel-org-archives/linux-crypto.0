Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FF71DF261;
	Fri, 19 Dec 2025 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766113611; cv=none; b=aWAJEbEjMMc/KdIOLhIvMwHpC1Oq4XtKJgtrZjfOAPRbsPr9bkkN314ISt/wpzcLdyPQ9WTbO+e+jaPaGutZ+ye8i2/VtPBkO8qCNPj/YHlt1yoZ/GBdQCGVBOdHPfPXT0HJad+VViboTGjPU4C2RYgzeuygC3/XDzSBzz6E3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766113611; c=relaxed/simple;
	bh=kXvclewLb2kyrLUtWPs3+55RpSFcLYCFujbRbKUvUys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrZB7+pA0B6pqcxjAZqeX1TCszTGkk3q9M1mou42/5zM9nq3UtY2RNxpmweqGxbWZAmam9q+t5ye60/9lNXjZAqMEhAxVQh7BoEXN5X0iAW7CyB9ogyAHKo/aviWTCiHpvEUN3wJrg41zZ6Kf3Fs6CTh5OZT56/M5UT22K+Qs64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MEMUl8U/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MEMUl8U/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3P6pVW1cvr1lv0KqnGFmS//0XyGcyck9Xrs1PB2Q/TA=; 
	b=MEMUl8U/swtJVtcOGKx4iwStVyw/pi2UtYEyxoFDVYL+qtZlCiKfmS2tekYQSLRrooklvO8HYsK
	k3+EDbbg0PgHpXev62BQfiFZhtETE8pYupjuZUeN9PmFWdeREzwQA65NzdRc1KXk0jo63Wa4jK/yn
	TrjWq3YzRDR4CtiusBERKfOIdSsgnvnCiZ6vjGlUkyK35azT86Z8nJ3Vt9EqsR+IVs9FK1VFSpy8T
	GWc2syb7ga2pxLJ/+WYcxGU9FKkEbwxllJcxdDMYsSQ6QQoVdK8FESSrXCEoNWp4zgHNH7sSQJdno
	eHXTFLDehIPtwqUBqjdiYPh1pVp4sOwtoBUQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWQpG-00BClz-3D;
	Fri, 19 Dec 2025 11:06:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 11:06:42 +0800
Date: Fri, 19 Dec 2025 11:06:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 2/2] crypto: hisilicon/trng - support tfms sharing the
 device
Message-ID: <aUTBQjke3PxSREAu@gondor.apana.org.au>
References: <20251120135812.1814923-1-huangchenghai2@huawei.com>
 <20251120135812.1814923-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120135812.1814923-3-huangchenghai2@huawei.com>

On Thu, Nov 20, 2025 at 09:58:12PM +0800, Chenghai Huang wrote:
>
> +static int hisi_trng_reseed(struct hisi_trng *trng)
> +{
> +	u8 seed[SW_DRBG_SEED_SIZE];
> +	int size;
>  
> -	return ret;
> +	/* Allow other threads to acquire the lock and execute their jobs. */
> +	mutex_unlock(&trng->lock);
> +	mutex_lock(&trng->lock);

If we have a bunch threads doing generate, then they will all hit
reseed and end up here for no reason at all.

If you want to stop one thread from hogging the lock, perhaps move
it inside the read loop in hisi_trng_generate?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
