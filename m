Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.12.242.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300672;
	b=kRbM0rHPUDHq6/KUqrtHVdYYG7pv8vcwkAVmTquiA/5TI4qS5KwWT0lbv7g7Y5I7zsKB
	 bFDKGSfUYj7V4mPQl6hk6ASM8dR21fhUiG9TpieHns+JzyxWEUnf/sw3NiRuEpMb1dUwD
	 O0n60gouFcokpmYahfwqRpcnk8fpQy02YJHSiuu8Qhd49qMiuSesNG+mYELA7JZ7bOZIt
	 t3oOyWqTcr5H0mhBw6NCHSQsU+9NrKd36dLApIb1D4tJk/iuK6EJlN2FjQ+8JjIcBmIrR
	 QF6XLT+adyhbNd3x0SBwjo5qnk6lX3hTKhmA3yWCk+3jPOxbvKvtWbjEExkWZCYgfmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300672;
	h=DMARC-Filter:Received:DKIM-Signature:X-ME-Helo:X-ME-Auth:X-ME-Date:
	 X-ME-IP:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=9ZavZJ0tM0u2Q8xdkZbjoOrQwlHby02WagG8hWWt2mI=;
	b=O2Z8uyFdRBH+oObjSdslT1Gzh5ddsL5+lkVx4ghEwp2h6v716UKJxlEieegdpUfeWQyA
	 ZBnYbf5wwvkGyzXsH9/0qiJFEHUzLp60YSUypp1L2NauVCXAT7oh8grknVYqNu3WSjWrZ
	 4LGHM0izYzL00ejA2/JFIrcLZ57b4eQ+2IP9BKfZYSUDvz9gJeR4CElHhJVtgqTkLmOR/
	 TKNTsy96yj6NNqNg4749Qo+QUZPBjMs3qHUqzxnFmnyL6FOIgo21rdtSqhdQltiUqPkpB
	 TKw7MARThNKdSiZDC8XgCRwR64w7iWtiVjMobpAbGlVw3xxmQGpkP5gwI8hlCaqtF+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wanadoo.fr;
	spf=pass smtp.mailfrom=wanadoo.fr;
	dkim=pass header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=A160Bh6O;
	arc=none smtp.remote-ip=80.12.242.73
Received: from smtp.smtpout.orange.fr (smtp-73.smtpout.orange.fr [80.12.242.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108DC606A31A;
	Thu, 29 Oct 2026 19:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 108DC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=A160Bh6O
Received: from [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
 ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id MVQAxrOxkL6ZKMVQAxzCqb; Thu, 29 Oct 2026 20:04:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1793300663;
	bh=9ZavZJ0tM0u2Q8xdkZbjoOrQwlHby02WagG8hWWt2mI=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=A160Bh6O5IquSjuq+6L5If12MEcwxBcgaNRH+zPk/3SCaVQpCKQFx4pdltWUwx3am
	 FZC2/dorznW+TbEDrWy5BU4Ay4yD4EI1z9HD5wY1qw8zX10m+fYOgln0hkszDYEV9I
	 wMVWbXVHLTct1j05ElcRm/q2zLu4BO3Kqu4AG8U/Eo9lfaEryVcVR5PHF9607NG9Zw
	 fyO+7ns0Zz4Hcs8L3Uy5wOFxqQslxQtcV/uwswYYQurBILYxEarLisgPzEtIjSRGOh
	 rHd5L3nHqDIMrtYrs51RqiF4BWkZuSMtxmS3dof70G7s3xDCuvEZuZHhw4rQc+OBhn
	 NejPkiRhoh+iA==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 29 Oct 2026 20:04:23 +0100
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
Message-ID: <0f44dca1-fd95-4b41-93b5-e5b71a4c07cb@wanadoo.fr>
Date: Thu, 29 Oct 2026 20:04:18 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: cctrng - fix usage counter in error path
To: Martin Kaiser <martin@kaiser.cx>, Hadar Gat <hadar.gat@arm.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261029081644.1897897-1-martin@kaiser.cx>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <20261029081644.1897897-1-martin@kaiser.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Le 29/10/2026 à 09:15, Martin Kaiser a écrit :
> If probe fails after the runtime pm usage counter was incremented,
> we have to decrement it before we exit.
>
> Remove the cc_trng_pm_fini call in the error path. It calls
> pm_runtime_disable before runtime pm is enabled.
>
> Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
> based on sashiko review
> https://lore.kernel.org/linux-crypto/67844d9d-d4d4-4026-9549-73589afcc1ff@wanadoo.fr/T/#m1a770f5f9eeed95b48cad7545580aed4fa74e6fa
>
> compile-tested only
>
>   drivers/char/hw_random/cctrng.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
> index 03401ee59a8e..d9492d25ecbb 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -533,9 +533,9 @@ static int cctrng_probe(struct platform_device *pdev)
>   	/* registration of the hwrng device */
>   	rc = devm_hwrng_register(dev, &drvdata->rng);
>   	if (rc) {
> -		dev_err(dev, "Could not register hwrng device.\n");
> -		cc_trng_pm_fini(drvdata);
> -		return rc;
> +		pm_runtime_put_noidle(dev);
> +		return dev_err_probe(dev, rc,
> +				     "Could not register hwrng device: %d\n", rc);

No need to duplicate rc in a dev_err_probe() call.

CJ

>   	}
>   
>   	/* trigger HW to start generate data */
