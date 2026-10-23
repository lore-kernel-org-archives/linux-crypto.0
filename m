Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783772;
	b=AFEqBeQRCjNpzuW2zXhu7oeNXfIxVkiPWCvKm5zRBJqjvQ1HwLREl2jmjpN/yhw4oGwE
	 UU8KbUyleEsmsqJFwiCzSkKa73YZNTlYR+Qzbt0SkEnT5wPMCgDUnPk4emP/OqNrjZuTZ
	 KadjR48o1sO+0YGCmTv62EEepLIXhAonXPklLRq3iIuY6cVwdMZcmnOKfisNWpW+oXCzb
	 BJG4ax+iE33m/N5mVky/ssUDDTi2ksijTo6IhP9IcXn6b5CUWbqvRpiBrRXlhspORww+7
	 QwiLYbBxKtRpb7fNj2XYZ4Lh/Nq3rZR+H/xfHvIK2klOAgW8RGJFhsqGCZ1ykuO90dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783772;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=chg+/HSh0EnOLS0pHhhLjumvSXLC3hV3PXgterkyd/k=;
	b=GfrGCWUWwBJDyNjV3K3R8U0i48QZaF4xnkZAtUczWf2AVcBm3VwjL/K2ucI0zquQL1oc
	 hp1nFYuvTTLBemUqcwHK1PKHi+oLLw/iynSwrb+m18XR/Z5KtGrs86dROwWvJeOfXBFIf
	 iiSY+HwlzfAxEVUr9Cp584Jf0CwJTdxbWFVQIC/SXCRBbfQX8NTbVabsFfU3JfDDmyeJw
	 HzgiF/c5iYoUWFfPL4sO9oEe1t3B+pVcLRd1vhjnT03kqJ33XiDGYVJFcCJLeEtSoXwer
	 Txag3oLf7wgJLEkhBxQgZnjiaE2VAEkhE3khjKa33VHKp3zYKTiGNIrLrIP8SF+PbKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EbPba3Rx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E033C606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 19:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EbPba3Rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6301F01825;
	Fri, 23 Oct 2026 19:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783771;
	bh=chg+/HSh0EnOLS0pHhhLjumvSXLC3hV3PXgterkyd/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EbPba3RxrzIMneWEXIPg+Irr4wOtxKW0tsC2SqFsozmIKtRzy9VSaAVWYf7LBKBku
	 AqtRRAItEzZOT1hyQUA5yYXxpgVTsX3kpYHe+CDod/yWJrsj/G4uo7O8+bYaWdQa43
	 7crwjFO672KNqyo9cwjLTF4uWEv6dR43NyvFbt/Eu353XDu2WAeD+oQALcwK7gKj92
	 /1SHN+zCXuEh0/qeeQzdIHEBHCoGQN2+dRqzltld7H/GzSScFJW/bMx7N7Avxdrs1n
	 pBzjgwjTxa8b0RqYyI2Z2li+MBE1EdXaCtBJELShtekBp5evQnkiX/2StoFEtkldvo
	 YZoqFxXfqOAjQ==
Message-ID: <sashiko-outbox-183117@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] hwrng: cctrng - Fix an error handling path in
 cctrng_probe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>, "Hadar Gat" <hadar.gat@arm.com>, "Olivia
 Mackall" <olivia@selenic.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Martin
 Kaiser" <martin@kaiser.cx>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <b66b3df3d178a04b35690d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr>
References: <b66b3df3d178a04b35690d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 19:29:31 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hwrng: cctrng: unbalanced pm_runtime_disable() in cctrng_probe()=
 error path
--

commit a9816f5e80718b9a879081c61af5922aa650d7de
Author: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

hwrng: cctrng - Fix an error handling path in cctrng_probe

This commit routes cc_trng_pm_get() and devm_hwrng_register() failures in
cctrng_probe() to a common post_pm_err label that calls cc_trng_pm_fini().

> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cct=
rng.c
> index 03401ee59a8e8..608b3321c05aa 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -524,8 +524,10 @@ static int cctrng_probe(struct platform_device *pdev)
> =20
>  	/* increment device's usage counter */
>  	rc =3D cc_trng_pm_get(dev);
> -	if (rc)
> -		return dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
> +	if (rc) {
> +		dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
> +		goto post_pm_err;
> +	}
> =20
>  	/* set pending_hw to verify that HW won't be triggered from read */
>  	atomic_set(&drvdata->pending_hw, 1);
> @@ -534,8 +536,7 @@ static int cctrng_probe(struct platform_device *pdev)
>  	rc =3D devm_hwrng_register(dev, &drvdata->rng);
>  	if (rc) {
>  		dev_err(dev, "Could not register hwrng device.\n");
> -		cc_trng_pm_fini(drvdata);
> -		return rc;
> +		goto post_pm_err;
>  	}
> =20
>  	/* trigger HW to start generate data */
> @@ -548,6 +549,11 @@ static int cctrng_probe(struct platform_device *pdev)
>  	dev_info(dev, "ARM cctrng device initialized\n");
> =20
>  	return 0;
> +
> +post_pm_err:
> +	cc_trng_pm_fini(drvdata);
> +
> +	return rc;

[Severity: Medium]
Does calling cc_trng_pm_fini() in the post_pm_err error path cause an
unbalanced pm_runtime_disable() and leak a dev->power.disable_depth
reference when cc_trng_pm_get() or devm_hwrng_register() fails?

In drivers/char/hw_random/cctrng.c, cc_trng_pm_init() only configures
autosuspend and sets the runtime status to active without enabling runtime
PM:

static int cc_trng_pm_init(struct cctrng_drvdata *drvdata)
{
	struct device *dev =3D &(drvdata->pdev->dev);

	/* must be before the enabling to avoid redundant suspending */
	pm_runtime_set_autosuspend_delay(dev, CC_TRNG_SUSPEND_TIMEOUT);
	pm_runtime_use_autosuspend(dev);
	/* set us as active - note we won't do PM ops until cc_trng_pm_go()! */
	return pm_runtime_set_active(dev);
}

Runtime PM is only enabled later in cctrng_probe() via
cc_trng_pm_go() -> pm_runtime_enable(), after both cc_trng_pm_get() and
devm_hwrng_register() have succeeded:

static void cc_trng_pm_go(struct cctrng_drvdata *drvdata)
{
	struct device *dev =3D &(drvdata->pdev->dev);

	/* enable the PM module*/
	pm_runtime_enable(dev);
}

static void cc_trng_pm_fini(struct cctrng_drvdata *drvdata)
{
	struct device *dev =3D &(drvdata->pdev->dev);

	pm_runtime_disable(dev);
}

Because cc_trng_pm_fini() calls pm_runtime_disable(), it pairs with
cc_trng_pm_go() rather than cc_trng_pm_init(). Jumping to post_pm_err before
cc_trng_pm_go() has run calls pm_runtime_disable() when runtime PM was never
enabled, incrementing dev->power.disable_depth from 1 to 2.

When cctrng_probe() returns an error, device_unbind_cleanup() calls
pm_runtime_reinit() in drivers/base/power/runtime.c, which already resets
runtime_status to RPM_SUSPENDED and clears use_autosuspend when runtime PM
is disabled, but does not reset dev->power.disable_depth. If the device is
subsequently re-probed, cc_trng_pm_go() only decrements disable_depth from 2
to 1, leaving runtime PM permanently disabled for the device.

In addition, if devm_hwrng_register() fails after cc_trng_pm_get() succeeds,
wouldn't cctrng_probe() need to undo the usage count increment from
cc_trng_pm_get() rather than calling cc_trng_pm_fini()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/b66b3df3d178a04b356=
90d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr?part=3D1
