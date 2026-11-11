Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794383042;
	b=1wFZqd8jaLysrL1OM+VLrQkWa5tPHki2e+Mi8gP1a3dyqAATwQVB8IBNcYpCWoZk3DMW
	 15ymTNJyqiPYySt0CGvL9UsCWlxTqdVvu9xSGoOZieeKbB2k+riPy4qc3n8L3KyCg2qds
	 Ywnhv8EC65JEdUCq03hTlxc9pgsULW0kp/fIS32ydUgQGR2VLkIJ98y2zd79Kq28iSBgq
	 NYwfmzTLigGNnDtfM9oI6lXX+2KJIHZQ6BHbvHzSghGLlzYi7c+IXUfmTmUpIyncSMJEE
	 9hjj+Jz780Wgsi8jqAsmm5hzXY5s60yaJdeTeGQKlmrwH1igfOTKfraQzZ8zed6mobQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794383042;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=45FhZV3cK1G+TR2s+hAlpex0xsCMjuBlN5+yKT3scms=;
	b=0JJojGkKIAA7W9l3qFTeCdLeeURj5icivEgUuho2JUwVzfXvh/KBi/RgXSk5naBnJI5B
	 boWZNO8tdJxi/oGL1H2tfNJ6ZH8IF4GIi36SjLllg8BTOOXOjHm3dSgRsH+mRhHRjQQ83
	 0UOQNF+dXFtNZwpzBzR0QaasKM57b+TI5qsiiM6WWdHeYwvsYZPOXy0p9h40TSKQl1xvs
	 JEQI2+EUAsqgPNrJVcIiH+YSgyMrVAaIQ8BgnwTDf9Kpi/hRftq9miNyvZ5nQO5IhbLWC
	 jlLABNqyFc+4lpox36yWqhA+rIYw7TAqpCBEFx93pAfWbvSr1O/2+FdDk1ezHiffEhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aipMd4e7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE75606A320
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 07:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aipMd4e7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8901F00A05;
	Wed, 11 Nov 2026 07:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794383041;
	bh=45FhZV3cK1G+TR2s+hAlpex0xsCMjuBlN5+yKT3scms=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aipMd4e76FJLjbE+/3gNlUNND1zjX/MEpsz+pbXzoVt3zn8pgKvUjoBetkAmdWPuU
	 qr60y810aU40irtG3a1fOF5N238wBW8G5TuVhlwnQCFd4iVi1WbxCJSDO8XlUjQdOf
	 0OmIQi5QJrVPf45BijOSKxtN4NQSw2grkYmgIc8AIIBvtWT5yfmkHl0wdfLvZKCjPf
	 iFq16HoFNJTHm/EvEYItkFTlEc6yLfdUvyAb7dLLGBin7V2skEDVrzvMTph3U4twlW
	 w4tH3kO6bggSbR3ndSmx8infIGL8I2OnwS+WSNHLYehM73RmRbiAoGMB2kqQCt1/b9
	 grkClUqMcXv/g==
Message-ID: <sashiko-outbox-208540@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] hwrng: mtk - use pm_runtime_resume_and_get() in
 mtk_rng_read()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gu Bin" <gubin@cmss.chinamobile.com>, sean.wang@mediatek.com, olivia@selenic.com, herbert@gondor.apana.org.au
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, linux-crypto@vger.kernel.org
In-Reply-To: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
References: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 07:44:00 +0000
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
- [High] hwrng: mtk - premature hwrng registration and unchecked runtime
  PM in mtk_rng_read() [1]
--

commit dfb825399ed095d750b85ef745a6c83b7ac41f98
Author: Gu Bin <gubin@cmss.chinamobile.com>

hwrng: mtk - use pm_runtime_resume_and_get() in mtk_rng_read()

This commit replaces pm_runtime_get_sync() with pm_runtime_resume_and_get()
in mtk_rng_read() and returns early if resuming the device fails.

> diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mt=
k-rng.c
> index 127b82d979e8e..1e8e458dab25c 100644
> --- a/drivers/char/hw_random/mtk-rng.c
> +++ b/drivers/char/hw_random/mtk-rng.c
> @@ -95,7 +95,9 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, s=
ize_t max, bool wait)
>  	struct mtk_rng *priv =3D to_mtk_rng(rng);
>  	int retval =3D 0;
> =20
> -	pm_runtime_get_sync(priv->dev);
> +	retval =3D pm_runtime_resume_and_get(priv->dev);
> +	if (retval < 0)
> +		return retval;
> =20
>  	while (max >=3D sizeof(u32)) {
>  		if (!mtk_rng_wait_ready(rng, wait))

[Severity: High]
This problem wasn't introduced by this patch, but can mtk_rng_read() be
called while runtime PM is disabled [1]?

In mtk_rng_probe(), devm_hwrng_register() is called before dev_set_drvdata()
and devm_pm_runtime_enable():

drivers/char/hw_random/mtk-rng.c:mtk_rng_probe() {
	...
	ret =3D devm_hwrng_register(&pdev->dev, &priv->rng);
	if (ret) {
		dev_err(&pdev->dev, "failed to register rng device: %d\n",
			ret);
		return ret;
	}

	if (!(priv->flags & MTK_RNG_SMC)) {
		dev_set_drvdata(&pdev->dev, priv);
		pm_runtime_set_autosuspend_delay(&pdev->dev,
						 RNG_AUTOSUSPEND_TIMEOUT);
		pm_runtime_use_autosuspend(&pdev->dev);
		ret =3D devm_pm_runtime_enable(&pdev->dev);
	...
}

Because devm_hwrng_register() immediately exposes the RNG and starts
hwrng_fillfn(), and because reverse-order devres teardown on unbind disables
runtime PM before unregistering the RNG, mtk_rng_read() can run while
runtime PM is disabled, causing pm_runtime_resume_and_get() to fail with
-EACCES (or previously causing unclocked MMIO reads when CONFIG_PM is
enabled).  Enabling runtime PM and setting drvdata before calling
devm_hwrng_register() would avoid this window during both probe and unbind.

[1] https://sashiko.dev/#/bug/linux-371c6254-7dda-4dcc-bf98-1919a85f9f5b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111073237.1647=
-1-gubin@cmss.chinamobile.com?part=3D1
