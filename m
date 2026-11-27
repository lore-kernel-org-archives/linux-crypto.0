Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795802449;
	b=D6fw2mOBgqz8he2tA2kUar0Grs3oA7+jnO0Sn7NmhHx8TmRkCW2GUyzt2NzlpMhuPDx3
	 v3OYHe5bBUEXhNr9LdlwrnMiBnzhYlqOKPfu+HuanMeADuIqK5WQBiz9KPb5DuexhT4Sy
	 8w81w84UGkml3wjTxE1kknf7M/cuQsSVNX85n7L9qQPaEQ75mni2HrpyD+QwS7D8zHUyA
	 oqleQhypK+hjZvmKwa76Q/+NQKwMi/FDfVdcS3uNs4CVe7P0oG9JkfKyDspv76mjYtYIf
	 Gt406MBK/XF73Ct6RT3BzIzeTEb9QvacwvIG96xFzpkXyHTtuz9VcyvpZoapCQAECfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795802449;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bcuSQgOJKidQVg85uZjMuUy2qyOzQ6Qy017ExFf/r/g=;
	b=Dqa/jNMDdeLBy00GfUwo04vQpAzQWUKQps81e8sT7RscntDb6+4DP8FmA2G8mUtqoOaZ
	 j3SD8yCIFCeLysreBLRE89kORALoDe//OAi82r5q0NSTr64ASx/BnJDY/bbadkiwQT0Qw
	 BgQ+iri7LCMQXumGfG0Pzo1lDlFsuu1KY5NyUWeG2+J9ot5AUsAxAhAA3Et6dgj4Shfe/
	 5/sgH1pdizZrQ8/tQM0UyZwKyn5QFuJ9ylj2PimTJLD6/FMuh0jLe9X4so3pUbRNhe+KN
	 h0/b7dQw6P6Ynw76KAbPUbf5cWG1NJUPKp1jH2V5rdVdjP8d6WX8AMrw0NTFO9J7O+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KO6l8MuK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FC9606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KO6l8MuK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507941F000C1;
	Fri, 27 Nov 2026 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795802449;
	bh=bcuSQgOJKidQVg85uZjMuUy2qyOzQ6Qy017ExFf/r/g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KO6l8MuKf6COuoBOIHo5KqkHtQKcH02ZiBLanEdNBe6VSrRMFjavYhc1lNqkuc6dM
	 4uZuHimhKVGGbvPLnQGT9kxjotNhlQf57NepsYl1VU1uJH6U3tnVeSIbCIHC73spTY
	 zUKBgCnmU85xICwoFwL7GBfGRSy8x+9gWYzh68IUr0TXnIMx6h2zCO9g0tcH6Yc78U
	 PDqEcXe8sX9EhZWsvEpJJ0zwuj2n5N4WkySZ0Hm+vKxrmmlyBWifdcr8FCJ3SRRV2J
	 a5ak8G//znEh6DCN/a+FvcswzsCnPe1hJ24HVs9ReZlHWvaq+lERpfAssiXTyG0mRg
	 YawlJCdRLQaqQ==
Message-ID: <sashiko-outbox-238022@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13] crypto: qce - split the crypto driver into core and
 crypto parts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, "Thara
 Gopinath" <thara.gopinath@gmail.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Stanimir Varbanov" <svarbanov@mm-sol.com>, "Eneas
 U de Queiroz" <cotequeiroz@gmail.com>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Eric
 Biggers" <ebiggers@kernel.org>, "Demi Marie Obenour" <demiobenour@gmail.com>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Russell
 King" <linux@armlinux.org.uk>, "Abel Vesa" <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, brgl@kernel.org
In-Reply-To: <20261127-qce-fix-self-tests-v13-1-80b601792901@oss.qualcomm.com>
References: <20261127-qce-fix-self-tests-v13-1-80b601792901@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 18:00:47 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] soc: qcom: missing Kconfig dependency and default for
  QCOM_CRYPTO_CORE
- [Low] crypto: qce: undocumented runtime PM fix in qce_handle_queue()
- [Low] soc: qcom: qce-core: redundant platform MODULE_ALIAS in
  qce-core.c
--

commit 4da044e24ff7154ba3b99469082d955ba8f5a0b0
Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

crypto: qce - split the crypto driver into core and crypto parts

This commit splits the Qualcomm Crypto Engine driver into a core platform
driver in drivers/soc/qcom/ that manages the memory interconnect vote via
runtime PM and registers auxiliary child devices, and an auxiliary driver in
drivers/crypto/qce/ for the crypto offloader functionality.

> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index ddb4df3d227f8..7c72f9bd36b9d 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
[ ... ]
> @@ -92,12 +91,7 @@ static int qce_handle_queue(struct qce_device *qce,
>  			    struct crypto_async_request *req)
>  {
>  	struct crypto_async_request *async_req, *backlog;
> -	int ret, err;
> -
> -	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(qce->dev, pm);
> -	ret =3D PM_RUNTIME_ACQUIRE_ERR(&pm);
> -	if (ret)
> -		return ret;
> +	int ret =3D 0, err;
> =20
>  	scoped_guard(mutex, &qce->lock) {
>  		if (req)
> @@ -121,8 +115,21 @@ static int qce_handle_queue(struct qce_device *qce,
>  			crypto_request_complete(backlog, -EINPROGRESS);
>  	}
> =20
> +	/*
> +	 * Hold the device resumed across that whole window instead of just
> +	 * across this function, or autosuspend could gate the engine clocks
> +	 * while the DMA is still in flight.
> +	 */
> +	err =3D pm_runtime_resume_and_get(qce->dev);
> +	if (err) {
> +		qce->result =3D err;
> +		schedule_work(&qce->done_work);
> +		return ret;
> +	}
> +
>  	err =3D qce_handle_request(async_req);
>  	if (err) {
> +		pm_runtime_put_autosuspend(qce->dev);
>  		qce->result =3D err;
>  		schedule_work(&qce->done_work);
>  	}
> @@ -155,6 +162,7 @@ static int qce_async_request_enqueue(struct qce_devic=
e *qce,
> =20
>  static void qce_async_request_done(struct qce_device *qce, int ret)
>  {
> +	pm_runtime_put_autosuspend(qce->dev);
>  	qce->result =3D ret;
>  	schedule_work(&qce->done_work);
>  }

[Severity: Low]
This isn't a bug in the code, but the commit message does not mention this
functional fix in qce_handle_queue() and qce_async_request_done(), which
holds the runtime PM reference across the in-flight DMA transfer instead of
dropping it when qce_handle_queue() returns (and initializes ret to 0).
Could this be noted in the changelog?

> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 535c8619197b3..67d54d5211ff2 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -121,6 +121,17 @@ config QCOM_PMIC_GLINK
>  	  Say yes here to support USB-C and battery status on modern Qualcomm
>  	  platforms.
> =20
> +config QCOM_CRYPTO_CORE
> +	tristate "Qualcomm Crypto Engine core driver"
> +	depends on PM
> +	select AUXILIARY_BUS
> +	help
> +	  Core driver for the Qualcomm Crypto Engine. Say yes here to enable
> +	  the top-level driver that binds to the devicetree node representing
> +	  the QCE, registers the sub-devices implementing actual QCE
> +	  functionalities and sets up runtime PM allowing the interconnects to
> +	  scale down.
> +

[Severity: Medium]
Should QCOM_CRYPTO_CORE have a default (such as default m if ARCH_QCOM), and
should CRYPTO_DEV_QCE in drivers/crypto/Kconfig depend on or select
QCOM_CRYPTO_CORE?

Without a default, updating an existing configuration via olddefconfig leav=
es
QCOM_CRYPTO_CORE disabled, so nothing binds to the QCE devicetree node to
scale down the memory interconnect bandwidth.  And if CRYPTO_DEV_QCE is
enabled without QCOM_CRYPTO_CORE, the qce.crypto auxiliary device is never
created and qcrypto cannot probe.

Also, the help text for CRYPTO_DEV_QCE in drivers/crypto/Kconfig still stat=
es
that qcrypto scales down the interconnect bandwidth, which is now handled by
qce-core.

> diff --git a/drivers/soc/qcom/qce-core.c b/drivers/soc/qcom/qce-core.c
> new file mode 100644
> index 0000000000000..1f249a22e8366
> --- /dev/null
> +++ b/drivers/soc/qcom/qce-core.c
[ ... ]
> +static const struct of_device_id qce_core_of_match[] =3D {
> +	{ .compatible =3D "qcom,crypto-v5.1" },
> +	{ .compatible =3D "qcom,crypto-v5.4" },
> +	{ .compatible =3D "qcom,qce" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, qce_core_of_match);
> +
> +static struct platform_driver qce_core_driver =3D {
> +	.probe =3D qce_core_probe,
> +	.driver =3D {
> +		.name =3D KBUILD_MODNAME,
> +		.of_match_table =3D qce_core_of_match,
> +		.pm =3D pm_ptr(&qce_core_pm_ops),
> +	},
> +};
> +module_platform_driver(qce_core_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Qualcomm crypto engine core driver");
> +MODULE_ALIAS("platform:" KBUILD_MODNAME);
> +MODULE_AUTHOR("Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com=
>");

[Severity: Low]
As reported by Krzysztof Kozlowski on v12 [1], is MODULE_ALIAS() needed here
given that qce_core_driver binds via devicetree and already exports
qce_core_of_match with MODULE_DEVICE_TABLE()?

[1] https://lore.kernel.org/r/7818fa09-8f9c-4d42-b746-0ec74ee1aa08@kernel.o=
rg

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-qce-fix-se=
lf-tests-v13-1-80b601792901@oss.qualcomm.com?part=3D1
