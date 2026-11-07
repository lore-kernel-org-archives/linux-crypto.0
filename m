Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794046878;
	b=XvW/WtgAOeaDrIhU7Go/04fQntvbsOcky5qPp7LPZJ0Kw7k/mF57ij6JZhibCIO+g8Mv
	 jpiHLXK+HAUAHhzC25+aJiIccNOHETB2sHCRalmF5qI36d7Ka1yK6u3VYTBLapp+6RELL
	 pQENX+PjPH933Vhde7ncpwnHitIRB/MboeNZp/sQQ7gNZ0TUjDCWqEqWQNSSw6peNNomr
	 30Q6GYdCzWrYFxb0Z203CEy53Yzv3LnZJpX1dEG3qM8f2Zu3F5Z3eTP1YIcGlIR2yBR1o
	 Sg4dcOgnabmwgMExWMxWX7XKjDOZ9Dw+WBgXRY4BTsMvWs1z3war6JNJNmefREJ+XPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794046878;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1Hte/mrif48x+MfoOWMojIHIFcNzBDtLRjD6dpkNF4M=;
	b=UqsYh6V4csvBPjVhZ791y/aNfO5gPI3dteRo9qSNPsoV7x7w5KIl6xeo2888stwAgdI1
	 xHaUvQhT0oZXXt0TEzRGaG2CLw/yIbTLUAw8WEUTdOR0zOjwn0OZSKGpCZc67Fl79UVhc
	 qSipFSkgktn6xjN1iZT/O0WJxMdFANpb44x+gymBtBUJ8paumDCz9cySGck3TSSwgDUsO
	 z4zokgXiMMa5P82qb5jXe+CvAWR4Uxttl7+UU4LclSPaRhcIiJZnZy01ofvj0JRcrztsd
	 re3nVHjRxYJedJ8dMOGYxLRDRBBqmKS2MvbT4ecFzJFcx97hbB+df1Pca7SmMlqxLlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaAFwMzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFD1606D815
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 10:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaAFwMzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77241F008A1;
	Sat,  7 Nov 2026 10:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794046878;
	bh=1Hte/mrif48x+MfoOWMojIHIFcNzBDtLRjD6dpkNF4M=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=aaAFwMzSPChEBA+HIupiW/aWb5Uq3ApFw+PGpZvIry4RyW6PqfgY4Yk4ZtmiTbq24
	 yQwTagVsQrcgGlwJfyBarWXN+GmYRtXS39eUH+bu8NDD/itTLAPX4rPxEV/+LF5Rye
	 opNlvNJWIAiex9LS+yKU2X99P4t3W1WL/FWEpVQ1HWOCOPwYK1fDKgT+LqhZoeJvOj
	 jS6T9uP1dmPef37S23kCAtpJ970zOJc9UYt+znbz/n+RpTnP94QUv4U4klhWfL6skj
	 Pp1JP9UUIXrMU7/6kxCkoQh4AlFVm03JO57VB749Z7Q3ZMXB4getzPxaSGrsmQ6XnJ
	 uMHUkpzVbA9Gg==
Message-ID: <sashiko-outbox-202815@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] hwrng: cctrng - cancel deferred works on unbind to
 avoid use-after-free
Reply-To: sashiko-reviews@lists.linux.dev
To: hyunjungg <hj351016@gmail.com>, "Olivia Mackall" <olivia@selenic.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
In-Reply-To: <20261107100238.3542588-1-hj351016@gmail.com>
References: <20261107100238.3542588-1-hj351016@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 10:21:17 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] hwrng: cctrng - runtime resume before enabling runtime PM in
  cctrng_probe() [1]
--

commit 8e1ce791cb06b2432af8b8abe4b88073b7383901
Author: Hyunjung Ko <hj351016@gmail.com>

hwrng: cctrng - cancel deferred works on unbind to avoid use-after-free

This commit replaces INIT_WORK() with devm_work_autocancel() for
compwork and startwork in cctrng_probe() so that pending work items are
canceled on driver unbind before drvdata is freed.

> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cct=
rng.c
> index 03401ee59a8e8..138cc7072b023 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c

[ ... ]

> @@ -497,8 +498,14 @@ static int cctrng_probe(struct platform_device *pdev)
>  		return dev_err_probe(dev, PTR_ERR(drvdata->clk),
>  				     "Failed to get or enable the clock\n");
> =20
> -	INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
> -	INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
> +	rc =3D devm_work_autocancel(dev, &drvdata->compwork,
> +				  cc_trng_compwork_handler);
> +	if (rc)
> +		return rc;
> +	rc =3D devm_work_autocancel(dev, &drvdata->startwork,
> +				  cc_trng_startwork_handler);
> +	if (rc)
> +		return rc;
>  	spin_lock_init(&drvdata->read_lock);
> =20
>  	/* register the driver isr function */

[Severity: High]
This problem wasn't introduced by this patch, but later in cctrng_probe(),
does cc_trng_pm_get() fail with -EACCES when CONFIG_PM is enabled [1]?

drivers/char/hw_random/cctrng.c:cctrng_probe() {
	...
	/* init PM */
	rc =3D cc_trng_pm_init(drvdata);
	if (rc)
		return dev_err_probe(dev, rc, "cc_trng_pm_init failed\n");

	/* increment device's usage counter */
	rc =3D cc_trng_pm_get(dev);
	if (rc)
		return dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
	...
	/* All set, we can allow auto-suspend */
	cc_trng_pm_go(drvdata);
	...
}

cc_trng_pm_init() calls pm_runtime_set_active(), while pm_runtime_enable()
is deferred until cc_trng_pm_go() at the end of probe.  When
cc_trng_pm_get() calls pm_runtime_resume_and_get(), runtime PM is still
disabled and dev->power.last_status is RPM_INVALID, so rpm_resume()
returns -EACCES and cctrng_probe() aborts.

[1] https://sashiko.dev/#/bug/linux-6da7f352-ac7d-4b81-8569-a1008cfc3400

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107100238.3542=
588-1-hj351016@gmail.com?part=3D1
