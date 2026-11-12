Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794493289;
	b=upBJKo6TzUrXC9AwtWGYP+PUB+7m2rnrUxP/cdrpKMyzSQmq+OVbOfWTAawj9eSAeJmP
	 K7INFLPxvAoOoLeIxMXHw3OuOh1iMnGMkStE+XQf7uevH/QaDE3DNKnLaabeXMNN3LwZk
	 5W9oRVI17l4Apt3bnsu8BFkoMynlsJCepK8K5aHCLFI6AimEnDt4uAHTJUP4y1ez+Icym
	 q5iUcVo/Mp3tsP/RHOkJbkTMxSbDw5zCt2ddLMySjGQwoxT5/ubSGIE0JFQjNfGyNnW5N
	 DEvPjwg3p5IAT+tJ7nwxg0XX+QUOux3Iq4AG3xBZI30Qr/3AhvOuGI2lOKhNgBvYZsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794493289;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JeiXReGFIigsnxp+EjXluL4rh7Bp6LV85L/Z5vjT+B0=;
	b=ePyb6AEScNrcHddMno7oyWuRkJxEgIiBmBkTwOybAUOxRXgjzMrmfJr1kCr5DFV/WUqy
	 EH7KAmNQ4gVfMB4CdIfZypg9Zh6sCPV5GzlseCfjdBdkY4K+uboicFuyeUFJjmdQaesAM
	 zovSjH7n9xW48Arr/GFTPrRBtdIr7QyJuF/CHay2vxgjMYR5HhP6Y6XsZvMtat5lo73Zh
	 jTkwZk6cGWzirJ/DAWKaTLfA//e1wLuCH7WjoPKKkUeNP7VHFQb6C3zdyJE+/ix27y11y
	 DfVXrRSx+SSS+Sf64in0Oc/o8fScQPmdgzb3rhp5DohB2mFDhx25MJ/94IZ7ka9n/kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H7Rdwark;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BCD606B804
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H7Rdwark
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FF71F00A05;
	Thu, 12 Nov 2026 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493289;
	bh=JeiXReGFIigsnxp+EjXluL4rh7Bp6LV85L/Z5vjT+B0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H7RdwarktzvSvHJjJ9Zwd8VzHWkbryFy9aegvLAoGdxAo48r4ZcuB5UnKfqbgn7hN
	 0Prfi8Lq11x6LO9rwfi7+gvI6nd0VDF3iV2+sKCVIGBPnzt02hpFLEXbWvTDYRCB+k
	 DPt2H3kfidCDoJu6PgmND3luG3XAWKOCSdlLD9XjoP/hqiH8nGWAgXnhWO8T7EiUCC
	 3WiHuEtemQHCpqT5aNB06rDtiYeYR40CEKwWiNOUhtBA2t5+ujeIj+kspjyiFKROWC
	 vaMQGqAGCJRyfGn1Nm0eR+weHkV0bGNvaWDykPi3X3jB6Shc2tDWKyK/A7Md5JiZbK
	 mwhsMlgO4RCIQ==
Message-ID: <sashiko-outbox-211301@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 2/4] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, "Thara
 Gopinath" <thara.gopinath@gmail.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Stanimir Varbanov" <svarbanov@mm-sol.com>, "Eneas
 U de Queiroz" <cotequeiroz@gmail.com>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Eric
 Biggers" <ebiggers@kernel.org>, "Demi Marie Obenour" <demiobenour@gmail.com>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Russell
 King" <linux@armlinux.org.uk>, "Abel Vesa" <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, brgl@kernel.org, "Pankaj Patil" <pankaj.patil@oss.qualcomm.com>, "Abel
 Vesa" <abel.vesa@oss.qualcomm.com>
In-Reply-To: <20261112-qce-fix-self-tests-v11-2-b86a65ee7107@oss.qualcomm.com>
References: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
 <20261112-qce-fix-self-tests-v11-2-b86a65ee7107@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:21:28 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] soc: qcom: qce-core: wrong error check in qce_core_probe()
--

commit 3e3675a3a324f53defb90d980deda844f4366b5a
Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

soc: qcom: add core driver for the Qualcomm Crypto Engine

This commit adds the core platform driver for the Qualcomm Crypto Engine to
manage runtime PM interconnect scaling and register child auxiliary devices.

> diff --git a/drivers/soc/qcom/qce-core.c b/drivers/soc/qcom/qce-core.c
> new file mode 100644
> index 0000000000000..d51a791bb1a36
> --- /dev/null
> +++ b/drivers/soc/qcom/qce-core.c
> @@ -0,0 +1,92 @@

[ ... ]

> +static int qce_core_probe(struct platform_device *pdev)
> +{
> +	struct auxiliary_device *auxdev;
> +	struct device *dev =3D &pdev->dev;
> +	struct icc_path *mem_path;
> +	const char *const *subdev;
> +	int ret;
> +
> +	mem_path =3D devm_of_icc_get(&pdev->dev, "memory");
> +	if (IS_ERR(mem_path))
> +		return PTR_ERR(mem_path);
> +
> +	dev_set_drvdata(dev, mem_path);
> +
> +	ret =3D devm_pm_runtime_enable(dev);
> +	if (ret)
> +		return ret;
> +
> +	PM_RUNTIME_ACQUIRE(dev, pm);
> +	ret =3D PM_RUNTIME_ACQUIRE_ERR(&pm);
> +	if (ret)
> +		return ret;
> +
> +	for (subdev =3D qce_core_aux_devs; *subdev; subdev++) {
> +		auxdev =3D __devm_auxiliary_device_create(dev, "qce", *subdev, NULL, 0=
);
> +		if (IS_ERR(auxdev))
> +			return PTR_ERR(auxdev);
> +	}

[Severity: Medium]
Should this check for !auxdev instead of IS_ERR(auxdev)?
__devm_auxiliary_device_create() returns NULL on failure, so a failed
allocation or registration will be ignored and qce_core_probe() will return
0 without creating the child device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-qce-fix-se=
lf-tests-v11-0-b86a65ee7107@oss.qualcomm.com?part=3D2
