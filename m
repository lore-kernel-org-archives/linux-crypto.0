Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C631EB19B;
	Sat, 15 Aug 2026 00:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786755472; cv=none; b=FgybcMq7P7VzQwIfsS0//geY5LMm1lvIO3fhLPgJWM0mSmqsxohzK8X8OwOJmnsPtcMC2RqPRImMPD1TBYA1wW/+xBbffo40KylLvsQjIaReNkVihE+MEsCSSkDgJcax4xGiA65eQH1rwfvAIpGphQ0xtdEzmpd2nU5JjfCZDhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786755472; c=relaxed/simple;
	bh=+hGMK3e3guMzc+6WZ6sIX+ss9Wt5s0Cywu+7gpMI5m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnOPIGvN6Do0zVnPBplkE+C58xJPIJlbx0v0IQxZsq8dsPMT+ZUKK2gpNgsJ8pHoVr9eCusiFeqVHTqSVLj2gu+r/tcwGHYl2R6s3o99yzXfDBNOvxpyk7hPaQnZ5es1QVhtv/16ujnjcirLU1o2dg520X1BG5VSIS3vlsmIfaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MtNg5mg1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MtNg5mg1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s/WM1J0gqkTH/mi2cnpL5fDIwJ0fuXkcfSw8qYUjwN4=; 
	b=MtNg5mg1gBQIKXUcuirc5QruKWBV4WlL3jfk7SQYQjbUeCoxPNo963KkZ8whTTWVJWieLndT+oc
	p/jOx7tpjHI8ej2e1X0MxkpTYRxilSHNQ+wPJD30zQkztuR2Ktn/YCzwg/J3/AumYhusc4VF2TOcI
	LGSIGsDOzQG5W3KUM5JtXrMCZscETiLLxBAkimGY3I8JLFhj0HhXt6kUQ2qOAQw98Jg1eRmMqO4ra
	/d8iWCtGMbPHN8f5zOQlb0383TGtGqmCv6AlBbAili15iIace7EGNY9xyENRdSFxPf4RdIVWkB6cc
	WrFxynZFPKRDmN18WzDklnBEJhBQNJkyYf3g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv2iL-000000054fT-1r6A;
	Sat, 15 Aug 2026 08:57:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 10:57:33 +1000
Date: Sat, 15 Aug 2026 10:57:33 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: hadar.gat@arm.com, olivia@selenic.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cctrng: Fix use-after-free in cctrng_remove due
 to race condition
Message-ID: <an-5fU8RgEQM2j_d@gondor.apana.org.au>
References: <c77fad0623ba0f152490dc14d4029debd789915e.1785828765.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c77fad0623ba0f152490dc14d4029debd789915e.1785828765.git.xiaopei01@kylinos.cn>

On Tue, Aug 04, 2026 at 03:34:41PM +0800, Pei Xiao wrote:
>
> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
> index a6925211c3b5..dd41f2d1fee5 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -568,6 +568,12 @@ static void cctrng_remove(struct platform_device *pdev)
>  
>  	cc_trng_pm_fini(drvdata);
>  
> +	/* Mask RNG interrupts so cc_isr cannot schedule new work */
> +	cc_iowrite(drvdata, CC_RNG_IMR_REG_OFFSET, 0xFFFFFFFF);
> +
> +	cancel_work_sync(&drvdata->compwork);
> +	cancel_work_sync(&drvdata->startwork);

I don't think this closes the race window.  After all, the ISR could
have already been started before your iowrite call.

Is there any way to make devm make the cancel_work_sync calls after
the ISR has been deregistered?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
