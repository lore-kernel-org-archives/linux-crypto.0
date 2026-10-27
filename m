Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.53.16.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793089382;
	b=OWn/K84OIMcNZfF9C5u2GoV+JPj8mAeUx7qlzV5rCR5+zkRJUuXqYs/9pMJSg8mn4VCh
	 LtsOhLArh07ltpJUcTJabxsRCXf0DEVoRIsNs5Z82ILejLfypPwt5BqBj3D5kSVZLc+5B
	 vgrAsimd7938yN/h6qrWMZWeleV6zySfoausaBAeKzKpji+ekPtd2WhTgqqEqhbWDCVWI
	 KB/nJTM63ZdKyooXAsz97yDbUlNMaS/g1qXBD3VzbsdOFzwfmF5OmJm41VZquo2q8dIqP
	 ZHmqEwmCrJ9mAMhejZb1C0/qC0v/INxZBykG/2yvKpWOuNaLaJAVkMJSQivWqAwygDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089382;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:Sender;
	bh=ENnuQzOvNJw9JvPQj87EiIPGBim2zyQAvJJJTp8AvDs=;
	b=FzepL8omi7VLvqe8CCGcDE+AdKvAo8N4XXxtvf2OF+BqxOxBjCvQJRTyia5k/lKa2bWK
	 BeL0swXwZUxim/YTGHjdx8ZsubsmTgDQvWbGqdUGaTInHRoL5H5BkDxUug1D+otN5/ILD
	 qaxGR2F3KtdZdqGNsvFE7+KM76lf0aTOEa3SrTEMFWZu5eIft7AaHm9BEKlqxPXQG3xIn
	 kN32DEH+oLvmi+7+TgQI1jlz9lW1Ho0fijcQ7uDDSnqtsvUlZI3Db51nc7z5X6CEujnzn
	 rvU/B1hxzNtKcTGRQohR0ambkkHCw0/lY8RrGATQzVrrnQ+6WGDD2VlfZJH8rlsLkWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kaiser.cx;
	spf=pass smtp.mailfrom=kaiser.cx;
	arc=none smtp.remote-ip=152.53.16.207
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D57606A31F;
	Tue, 27 Oct 2026 08:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7D57606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.98.2)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1xLcSE-00000001QM3-3LXb;
	Tue, 27 Oct 2026 09:22:46 +0100
Date: Tue, 27 Oct 2026 09:22:46 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: cctrng - Fix an error handling path in
 cctrng_probe
Message-ID: <auBfVkwtsMUdgyG9@akranes.kaiser.cx>
References: <b66b3df3d178a04b35690d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b66b3df3d178a04b35690d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

The sashiko review makes sense to me. We should probably call
pm_runtime_put_noidle after post_pm_err.

Best regards,
Martin

Thus wrote Christophe JAILLET (christophe.jaillet@wanadoo.fr):

> If an error occurs after a successful cc_trng_pm_init() call, it must be
> undone by a corresponding cc_trng_pm_fini() call.

> The commit in Fixes has erroneously updated the error handling path if
> cc_trng_pm_get() fails.

> Fixes: 8bcd96893848 ("hwrng: cctrng - let devres enable the clock")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only.

> This patch also undo the clean-up done by commit a7ea3d63e897 ("hwrng:
> cctrng - simplify cctrng_probe()"). Keeping an error path makes sense with
> 2 users. But if preferred, the missing cc_trng_pm_fini() could also be
> added after the test for errors in cc_trng_pm_get().
> ---
>  drivers/char/hw_random/cctrng.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
> index 03401ee59a8e..608b3321c05a 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -524,8 +524,10 @@ static int cctrng_probe(struct platform_device *pdev)

>  	/* increment device's usage counter */
>  	rc = cc_trng_pm_get(dev);
> -	if (rc)
> -		return dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
> +	if (rc) {
> +		dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
> +		goto post_pm_err;
> +	}

>  	/* set pending_hw to verify that HW won't be triggered from read */
>  	atomic_set(&drvdata->pending_hw, 1);
> @@ -534,8 +536,7 @@ static int cctrng_probe(struct platform_device *pdev)
>  	rc = devm_hwrng_register(dev, &drvdata->rng);
>  	if (rc) {
>  		dev_err(dev, "Could not register hwrng device.\n");
> -		cc_trng_pm_fini(drvdata);
> -		return rc;
> +		goto post_pm_err;
>  	}

>  	/* trigger HW to start generate data */
> @@ -548,6 +549,11 @@ static int cctrng_probe(struct platform_device *pdev)
>  	dev_info(dev, "ARM cctrng device initialized\n");

>  	return 0;
> +
> +post_pm_err:
> +	cc_trng_pm_fini(drvdata);
> +
> +	return rc;
>  }

>  static void cctrng_remove(struct platform_device *pdev)
> -- 
> 2.56.0

