Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794676895;
	b=K1XGNYBQufKtajmVBgcwBs+NdE8o5W3Jkuch4epkYAaXDReF5mobL1+1e/cC2luQCEvs
	 lPOztx8VEyO3OVBB815QjM+xyPEVlYKm2xphYKVGzId1bKfZ5wxxIjcXYHEJvs6z66jg3
	 PQTd0MflSV+5N90wIqdjpsiqUkJzs+g6mBHC25HMlAnr4IoP7/haxIB+D1fO5OxTVLkKX
	 ggcSdz7QEUbH1pgDW+tVArYncuTm6e41OauDu++seBIbStSx39mE8HWI/kQ0XXNNB4IBy
	 ARH+8A4kEPgXwHBeselz24mjIOYINUkwjJOmOOODa2AmtdcSGbbkwtjZ3FBRFYLC6bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794676895;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3j7ZPFqVNyG19WtPZ72u5lUEQUI9wCFsXYx0aSltSQU=;
	b=pXtbUANpem7sac2b3qvGBYFOKI1+YPq6X+ZeyiB61jRqBb39oUzNeItFqFNGo9EWhkHb
	 3SW10daaf8uKgiL9Sbr8uEfatoJNld8VyjQxT4v/zslGMItp2JpmaeiYSJplxwv6VH2JU
	 ywTW3dJB3dhdo0xAhHWU89FWczqknduP8HrdHcoV2FSy1x+XqbDbgL7ntTWcDEMVb5Unh
	 nZrvPkLsp/elurUMmzfTCIyj0V/O0JiWZhp1qqFwrorfRaCJaH2aIp8GdOHt4R3d4W4GZ
	 pGUy5dLz+7ElW/T1StqVh1m1W5ZJ22FOdSRbiH0tXIMwmsDP2fb8QPu9umATvmDAwYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MPi6O0nq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDA6606A323
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MPi6O0nq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE581F000C4;
	Sat, 14 Nov 2026 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794676895;
	bh=3j7ZPFqVNyG19WtPZ72u5lUEQUI9wCFsXYx0aSltSQU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MPi6O0nqo/O4DBmFizO6rd2WHSsMKz/A9zgm+uruWs7bGcXsT3mjpwIZirHNgiVfo
	 5gSEomwqGD/AiW4wKa/r8yj9/cHwtCzyw8uV4+IWT8jp8YRKYg+OOuTbE4U4InP84B
	 6d6Tg5xRI/NGuenILG3vhtT3N4lMBv62WYfIxKAPy8T5aJgZTsABwwS7aCQp/yPqSG
	 UZl7blIDS+Rc0yetY7KbkeahYEcOQaIsj12J82+LLoUBundAmICUTY6HMmodIblT2E
	 a96fhSZMa91mi21EatEXk0D+pIBulNsBGHm2ynFoKfj1TcLkrV26tnt9FJhe5e6TtJ
	 cbKebqxYIYCBA==
Message-ID: <sashiko-outbox-214832@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] hwrng: cctrng - use device-managed api for runtime
 pm
Reply-To: sashiko-reviews@lists.linux.dev
To: "Martin Kaiser" <martin@kaiser.cx>, "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261114170335.1680546-3-martin@kaiser.cx>
References: <20261114170335.1680546-1-martin@kaiser.cx>
 <20261114170335.1680546-3-martin@kaiser.cx>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 17:21:34 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] hwrng: cctrng: unchecked devm_pm_runtime_enable() and late
  devres registration
- [Medium] hwrng: cctrng: double clk_disable_unprepare() on unbind via
  devm_pm_runtime_enable()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] hwrng: cctrng: use-after-free due to uncancelled works in
  cctrng_remove() [1]
--

commit b87f66a9bcd0c0b30376ba4eb9926de4dd58fc40
Author: Martin Kaiser <martin@kaiser.cx>

hwrng: cctrng - use device-managed api for runtime pm

This commit replaces manual pm_runtime_enable() and pm_runtime_disable()
calls with devm_pm_runtime_enable() and removes cctrng_remove().

> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cct=
rng.c
> index ef3ca6d8cc850..ac77c6afea5b7 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
[ ... ]
> @@ -534,25 +518,13 @@ static int cctrng_probe(struct platform_device *pde=
v)
>  	cc_trng_hw_trigger(drvdata);
> =20
>  	/* All set, we can allow auto-suspend */
> -	cc_trng_pm_go(drvdata);
> +	devm_pm_runtime_enable(dev);

[Severity: Medium]
Should cctrng_probe() check the return value of devm_pm_runtime_enable(dev)
and call it in cc_trng_pm_init() before devm_hwrng_register()?

If devm_pm_runtime_enable() fails to allocate its devres entry,
devm_add_action_or_reset() immediately runs pm_runtime_disable_action(),
leaving runtime PM disabled, autosuspend cleared, and the usage count from
pm_runtime_resume_and_get() leaked while cctrng_probe() returns 0.

Calling devm_pm_runtime_enable() after devm_hwrng_register() and
cc_trng_hw_trigger() also means devres teardown on unbind disables runtime
PM before unregistering the hwrng device, and allows cc_trng_compwork_handl=
er()
to call pm_runtime_put_autosuspend() while runtime PM is still disabled.

[Severity: Medium]
Can switching to devm_pm_runtime_enable(dev) cause clk_disable_unprepare()
to be called twice on drvdata->clk when unbinding the driver?

cctrng_probe() enables drvdata->clk via devm_clk_get_optional_enabled().
Unlike the previous cctrng_remove() which only called pm_runtime_disable(),
devm_pm_runtime_enable()'s cleanup action calls
pm_runtime_dont_use_autosuspend() before pm_runtime_disable().  When the
device is unbound while idle, clearing autosuspend with runtime PM still
enabled synchronously invokes cctrng_suspend(), which calls
clk_disable_unprepare(drvdata->clk) before the devres release for
devm_clk_get_optional_enabled() disables and unprepares drvdata->clk a
second time.

>  	dev_info(dev, "ARM cctrng device initialized\n");
> =20
>  	return 0;
>  }
> =20
> -static void cctrng_remove(struct platform_device *pdev)
> -{
> -	struct cctrng_drvdata *drvdata =3D platform_get_drvdata(pdev);
> -	struct device *dev =3D &pdev->dev;
> -
> -	dev_dbg(dev, "Releasing cctrng resources...\n");
> -
> -	cc_trng_pm_fini(drvdata);
> -
> -	dev_info(dev, "ARM cctrng device terminated\n");
> -}

[Severity: Critical]
This problem wasn't introduced by this patch, but can unbinding the driver
without cancelling drvdata->compwork and drvdata->startwork cause a
use-after-free on drvdata [1]?

CPU0                                    CPU1 (kworker)
device_release_driver()
  devres_release_all()
    devm_hwrng_release()
    devm_irq_release()
    devm_ioremap_release()
    ...                                 cc_trng_compwork_handler()
    /* drvdata freed */                   cc_iowrite(drvdata, ...)
                                            <-- use-after-free

cc_isr() schedules drvdata->compwork and cctrng_read() schedules
drvdata->startwork, and compwork can also reschedule startwork.  Nothing
cancels either work item during teardown before devres unmaps drvdata->cc_b=
ase
and frees drvdata.

[1] https://sashiko.dev/#/bug/linux-c156c6f0-25a8-4aa0-8a30-20ef6163ee06

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114170335.1680=
546-2-martin@kaiser.cx?part=3D2
