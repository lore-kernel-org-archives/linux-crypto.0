Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794494083;
	b=GcMFCDJjCm8JLRUnJNXzcqOfntF3YzuO0wRnBiHC0AcxGyH8rDiEGnPyhCfKNUjnemUd
	 1ENuGEukpRmbRe/E/AYz1m+oNzotsVQxHGzKnBXTs4TuW1rw/BukCdHg1UAUBu6/W7BAH
	 qxH8iKIT0y/LhtxZJ9w3SE08uFRtrvduSpjwVgx4PptxjU+eF9YxMuhJOtwuFsTZPqcZS
	 o9FkGWMKE244PtR6u3SCmwNrNrCJS1ofGawSb0ROhrX5D39yKEIW6DYcPKhr6YYrxs+l/
	 LrgBpmIFYDbNvKs4xjtTDN/McaVwdQ2QKBp6f6Hf3CrL7ociB/9f+1YYP1WBPiQZOtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794494083;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oKGOE90JjtF1ivf+YIrpKLut8WiEBtXXB8vgIF1ajQg=;
	b=DJggbUVUldFvGZPWa2hqyFWrscNOL/7sQo5FROcQNr2qzxhch8hSVGSQLL5vHVOqJnUJ
	 VlYyIhF/ax+njYu2GZJQoYD2DiPavvti/ZaAn2F/pT4ZCWoD2kJgFblFREQbShHyZ5hep
	 EdBohVWnCd0N+Uwdtxu4ds8wtd3y/rhborVpsVENjNoG+7tnWUHNLzEKbQZZ4b79I5Eqj
	 JpoJkvTuso+U17XiliizMglTr9EuEab9kYkZ6yy+cZ1r9d6Xr3a8ahsq+uetvWL10Ab1N
	 wCrM4lOh4YiYOtnUB9Jx20A53LxPr+LOQkErNeB3slEEGfXAzCHzOFCqf6QHHc8eZ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMwUUDv0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64B1606A881
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMwUUDv0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77AA1F00A05;
	Thu, 12 Nov 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794494082;
	bh=oKGOE90JjtF1ivf+YIrpKLut8WiEBtXXB8vgIF1ajQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LMwUUDv0xQNn6f3uc5y+JrEwPQLm4+zQnHOEyGNJAPWJy0LaYuMwWdKFD+aG3DZ5i
	 D+HHCUI4oTFGmq+30g3w6jB0G3Cy+EFaz0GcEb2XsJNoi102wYl4teXMTrd7I4vkrY
	 r9Zazfws7W0VADbVCQEQM6jOjCtM4/ruUg4UHOFxWYnWvwVM8YLMIziZ9/6c4og22V
	 K0qchBcG5jHQz5KGqLmSMn0/hKMsonTs5KS0GzVChN21yYYtfdnvy4HbeEnGoSbUvu
	 gB7f6QTreyvGEf0ilEtwRwHIIY3weRSlLwihesgrYowQTZnGHAJrXssRqgBCap4qIf
	 Gao7SetoPvr8A==
Message-ID: <sashiko-outbox-211343@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 1/4] crypto: qce - convert to auxiliary bus
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, "Thara
 Gopinath" <thara.gopinath@gmail.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Stanimir Varbanov" <svarbanov@mm-sol.com>, "Eneas
 U de Queiroz" <cotequeiroz@gmail.com>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Eric
 Biggers" <ebiggers@kernel.org>, "Demi Marie Obenour" <demiobenour@gmail.com>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Russell
 King" <linux@armlinux.org.uk>, "Abel Vesa" <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, brgl@kernel.org, "Pankaj Patil" <pankaj.patil@oss.qualcomm.com>
In-Reply-To: <20261112-qce-fix-self-tests-v11-1-b86a65ee7107@oss.qualcomm.com>
References: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
 <20261112-qce-fix-self-tests-v11-1-b86a65ee7107@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:34:41 +0000
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
- [Low] crypto: qce: ignored .driver.name initializer in
  qce_crypto_driver
- [Low] crypto: qce - stale ICC comment in qce_crypto_probe()
--

commit 29e94f7689b20cef79914c127c10bb58d32472f1
Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

crypto: qce - convert to auxiliary bus

This commit converts the Qualcomm crypto engine driver from a platform
driver to an auxiliary bus driver, removes interconnect bandwidth scaling,
updates runtime PM handling, and uses the parent device for DMA mappings.

> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index ddb4df3d227f8..346e9ea0fe0f0 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c

[ ... ]

> @@ -228,10 +243,6 @@ static int qce_crypto_probe(struct platform_device *=
pdev)
>  	if (IS_ERR(qce->bus))
>  		return PTR_ERR(qce->bus);
> =20
> -	qce->mem_path =3D devm_of_icc_get(dev, "memory");
> -	if (IS_ERR(qce->mem_path))
> -		return PTR_ERR(qce->mem_path);
> -
>  	/*
>  	 * Enable runtime PM after clocks and ICC path are acquired so that
>  	 * the resume callback can enable clocks and apply the ICC bandwidth

[Severity: Low]
This isn't a bug, but this comment in qce_crypto_probe() still mentions
acquiring the ICC path and applying the ICC bandwidth vote, which this
commit removes from the driver.

[ ... ]

> @@ -336,25 +330,22 @@ static const struct dev_pm_ops qce_crypto_pm_ops =
=3D {
>  	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
>  };
> =20
> -static const struct of_device_id qce_crypto_of_match[] =3D {
> -	{ .compatible =3D "qcom,crypto-v5.1", },
> -	{ .compatible =3D "qcom,crypto-v5.4", },
> -	{ .compatible =3D "qcom,qce", },
> +static const struct auxiliary_device_id qce_crypto_ids[] =3D {
> +	{ .name =3D "qce.crypto", },
>  	{}
>  };
> -MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> +MODULE_DEVICE_TABLE(auxiliary, qce_crypto_ids);
> =20
> -static struct platform_driver qce_crypto_driver =3D {
> +static struct auxiliary_driver qce_crypto_driver =3D {
>  	.probe =3D qce_crypto_probe,
> +	.id_table =3D qce_crypto_ids,
>  	.driver =3D {
> -		.name =3D KBUILD_MODNAME,
> -		.of_match_table =3D qce_crypto_of_match,
> +		.name =3D "qce-crypto",
>  		.pm =3D pm_ptr(&qce_crypto_pm_ops),
>  	},
>  };

[Severity: Low]
Should qce_crypto_driver set .name instead of .driver.name, or drop
.driver.name?  __auxiliary_driver_register() unconditionally overwrites
auxdrv->driver.name based on auxdrv->name and the module name:

drivers/base/auxiliary.c:__auxiliary_driver_register() {
	...
	if (auxdrv->name)
		auxdrv->driver.name =3D kasprintf(GFP_KERNEL, "%s.%s", modname,
						auxdrv->name);
	else
		auxdrv->driver.name =3D kasprintf(GFP_KERNEL, "%s", modname);
	...
}

Because qce_crypto_driver.name is NULL, the "qce-crypto" initializer is
ignored and overwritten with KBUILD_MODNAME ("qcrypto").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-qce-fix-se=
lf-tests-v11-0-b86a65ee7107@oss.qualcomm.com?part=3D1
