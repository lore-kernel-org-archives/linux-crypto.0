Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411019;
	b=WdqoVBLkPc0R+r8tB4Lua/MIPDZ5U8TnZE9iTk6m6f60OX31bDR/voVnKsyd+ttHq9Qz
	 0pxmOlb8qFK2ok12wh7dBexLe/SOMoh+0kkqy2UCYPwAd1hALUDbAcu1TSw1/xAI+XX+5
	 vbLFqFG6CDKbZx5YtnGbpIAzXbTT36geCHIl+80I/T1wl5B4UeUeBIOIuS+HNGIHwMWFY
	 xf116sh652VvMrwtshjFqmcFophJhjnTxJ1ZbI0wmZlcShpy/+bPhhdxTD6gSTEv/rSDZ
	 li6f8cKrNeJnKQ1wINMFJvhgo8urzGZHlDENo3q+WjS4cfSnl0Vt4XQDML8HdYJ1F4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VPS+rF73zyfS5/2LmPCI0S8FRw/sGRxV3qcg3vrPAH8=;
	b=yPSL8vTuhtljJfA6Y8Fzq++zEEVZotqmzZ/suIeAqN9TGukNMJEjtchiS0fYsQFk5hIa
	 2jhPicxqcmUQY7nJhvxBCoQ9mfZAo1BVszpsSCq6i6bvKttvmLT/gS+TRmoYMbJ4Z1qDr
	 ZZBo5nK6AediHkF5WXFWD86Gxouw+7HwepdgQSwwopLu/QvVeFPgSWoqNv4g5xD7VMMvn
	 2fGSvgIsKbmwSLZMEYPrmKyTFw7FWrkphWaTCI+Q79j6fB12Wcc9cnQknKaSSd/LyKC1b
	 LDZW1HcmR5eM3aWTkYQ0eubxwJcM6+OWcs9FrWx/dD+/GyqKoRhtxEL042QS2hQMi7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9jkSN4G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C64D606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9jkSN4G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8AE1F00A05;
	Wed, 11 Nov 2026 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794411019;
	bh=VPS+rF73zyfS5/2LmPCI0S8FRw/sGRxV3qcg3vrPAH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U9jkSN4GD8V0oF9v+gGD5aLQf+N4wzQGg7UJKE7yil+YoySJ3ZOvEoFfsYPkSJ2gB
	 7GZy3siyu0JqkBk1CtOrIi+kP8IcA6JHOlx2t5ILwiTbRltTH8wJk4SvyNldzbdGI3
	 B76DrDHVQWEOn+bG6+ZqeK3AOzyG79FsUaObsqwQO12UvaksTNBWcD83p2x1zlXvn7
	 lSazSWa4RTN+2EgzdfTExy6UWi7q8QSHZoORk3wIrYxVyTlRwZY3U0V1x/drwfECOC
	 N/FUp904lYWlCS9PRJHx8EHdGAAioj+7PJgJaOQsR5nRAGjo0IUNo44dQtwoDpp+bW
	 yQ6D5H37M7QNQ==
Message-ID: <sashiko-outbox-209224@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/6] tee: optee: Register TEE devices on the platform
 bus
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Eric Biggers" <ebiggers@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Abel
 Vesa" <abelvesa@kernel.org>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>, "Sumit
 Garg" <sumit.garg@oss.qualcomm.com>, "Selvam Sathappan Periakaruppan" <selvam.periakaruppan@oss.qualcomm.com>
Cc: "Basant Kumar" <basantk@qti.qualcomm.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 15:30:17 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [High] firmware: qcom: duplicate module_init() and module_exit() in
  qcom_ice_tee.c
- [High] tee: missing EXPORT_SYMBOL_GPL() for
  tee_platform_device_register()
- [High] soc: qcom: Kconfig dependency and module cycle selecting
  QCOM_ICE_TEE
- [High] tee: optee: platform device name collision with optee_driver
- [High] soc: qcom: ice: qcom_ice_tz_is_available() requires both SCM
  and OP-TEE
- [Medium] tee: unchecked devm_add_action_or_reset() in
  tee_platform_device_register()
- [Medium] firmware: qcom: missing remove callback in
  qcom_ice_plat_driver
--

commit c9fd96220ba8e5c6eeef8806d3112f1e39c17581
Author: Harshal Dev <harshal.dev@oss.qualcomm.com>

tee: optee: Register TEE devices on the platform bus

This commit adds tee_platform_device_register() to register OP-TEE devices =
on
the platform bus and updates the Qualcomm ICE driver and its TEE backend to
check whether OP-TEE has probed.

> diff --git a/drivers/firmware/qcom/qcom_ice_tee.c b/drivers/firmware/qcom=
/qcom_ice_tee.c
> index 694aa05847f0e..39f7094439d99 100644
> --- a/drivers/firmware/qcom/qcom_ice_tee.c
> +++ b/drivers/firmware/qcom/qcom_ice_tee.c

[ ... ]

> @@ -398,5 +414,30 @@ static struct tee_client_driver qcom_ice_tee_driver =
=3D {
> =20
>  module_tee_client_driver(qcom_ice_tee_driver);
> =20
> +static int qcom_ice_plat_probe(struct platform_device *pdev)
> +{
> +	/* Paired with smp_load_acquire() in qcom_ice_tee_is_available() */
> +	smp_store_release(&__teedev, &pdev->dev);
> +	return 0;
> +}
> +
> +static const struct platform_device_id qcom_ice_plat_id_table[] =3D {
> +	{
> +		.name =3D "optee",
> +	},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(platform, qcom_ice_plat_id_table);
> +
> +static struct platform_driver qcom_ice_plat_driver =3D {
> +	.probe =3D qcom_ice_plat_probe,
> +	.id_table =3D qcom_ice_plat_id_table,
> +	.driver =3D {
> +		.name =3D "qcom-ice-plat",
> +	},
> +};

[Severity: Medium]
Should qcom_ice_plat_driver also provide a .remove callback to clear
__teedev?  When the parent tee_device is unregistered or qcom-ice-plat is
unbound, plat_tee_free() unregisters and frees pdev, leaving __teedev as a
dangling pointer and causing qcom_ice_tee_is_available() to keep returning
true.

> +
> +module_platform_driver(qcom_ice_plat_driver);

[Severity: High]
Does adding module_platform_driver(qcom_ice_plat_driver) in the same file as
module_tee_client_driver(qcom_ice_tee_driver) break modular builds?  Both
macros expand to module_driver(), which defines __inittest(), init_module(),
__exittest(), and cleanup_module(), causing duplicate symbol definitions wh=
en
built as a module.

A single module_init() and module_exit() pair is needed to register
qcom_ice_tee_driver before qcom_ice_plat_driver, unwind on registration
failure, and unregister both in reverse order.

> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 535c8619197b3..8dc75c252f52b 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -296,6 +296,7 @@ endif
>  config QCOM_INLINE_CRYPTO_ENGINE
>  	tristate
>  	select QCOM_SCM
> +	select QCOM_ICE_TEE

[Severity: High]
Can QCOM_INLINE_CRYPTO_ENGINE unconditionally select QCOM_ICE_TEE here?

QCOM_ICE_TEE depends on TEE and !CPU_BIG_ENDIAN in
drivers/firmware/qcom/Kconfig, whereas QCOM_INLINE_CRYPTO_ENGINE is selected
by MMC_SDHCI_MSM and SCSI_UFS_QCOM without those dependencies.  Selecting
QCOM_ICE_TEE when TEE is disabled (or when QCOM_INLINE_CRYPTO_ENGINE is
built-in and TEE is modular) causes unmet direct dependency warnings and li=
nk
failures for tee_client_* symbols, and include/linux/firmware/qcom/qcom_ice=
_tee.h
has no fallback stub for qcom_ice_tee_is_available() (nor an include of
linux/types.h for bool).

In addition, qcom_ice.c now calls qcom_ice_tee_is_available() from
qcom_ice_tee.c while qcom_ice_tee.c calls qcom_ice_tz_ops_register() and
qcom_ice_tz_ops_unregister() from qcom_ice.c, creating a circular dependency
between the two modules.

> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 452896b1858f1..4844621b74970 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -18,6 +18,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/xarray.h>
> =20
> +#include <linux/firmware/qcom/qcom_ice_tee.h>
>  #include <linux/firmware/qcom/qcom_scm.h>
> =20
>  #include <soc/qcom/ice.h>
> @@ -132,7 +133,13 @@ static bool qcom_ice_tz_ops_registered(void)
> =20
>  static bool qcom_ice_tz_is_available(void)
>  {
> -	return qcom_scm_is_available();
> +	/*
> +	 * Both back-ends should be available before we check for
> +	 * qcom_ice_tz_ops_registered(), otherwise we could pre-maturely
> +	 * assume that TZ does not provide any ICE secure interface.
> +	 */
> +	return (qcom_scm_is_available() & qcom_ice_tee_is_available());
> +
>  }

[Severity: High]
Does requiring both qcom_scm_is_available() and qcom_ice_tee_is_available()
break all QTEE-based platforms where OP-TEE is not present?

__teedev is only set when OP-TEE probes and registers its platform device.
On platforms using QTEE via SCM (or when OP-TEE is not enabled),
qcom_ice_tee_is_available() remains false forever, so once qcom_ice_create()
checks qcom_ice_tz_is_available() in the next patch it will defer probe
indefinitely and prevent UFS/SDHC storage from coming online.

Also, this uses bitwise & on booleans instead of &&, and at this commit
qcom_ice_tz_is_available() is an unused static function, triggering a
-Wunused-function warning during bisection.

> diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
> index 51624443359bf..85ee761739826 100644
> --- a/drivers/tee/optee/smc_abi.c
> +++ b/drivers/tee/optee/smc_abi.c
> @@ -1920,6 +1920,14 @@ static int optee_probe(struct platform_device *pde=
v)
>  	if (rc)
>  		goto err_disable_shm_cache;
> =20
> +	/*
> +	 * Device should only be visible on the platform bus once the
> +	 * child devices have already been enumerated on the TEE bus.
> +	 */
> +	rc =3D tee_platform_device_register(optee->teedev, "optee");
> +	if (rc)
> +		goto err_disable_shm_cache;

[Severity: High]
Does registering a platform device named "optee" here (and in
optee_ffa_probe()) collide with optee_driver on the platform bus?

drivers/tee/optee/smc_abi.c defines optee_driver with:

drivers/tee/optee/smc_abi.c:
	static struct platform_driver optee_driver =3D {
		.probe  =3D optee_probe,
		.remove =3D optee_smc_remove,
		.shutdown =3D optee_shutdown,
		.driver =3D {
			.name =3D "optee",
			.of_match_table =3D optee_dt_match,
		},
	};

Because optee_driver has .driver.name =3D "optee" and no .id_table,
platform_match() falls back to strcmp(pdev->name, drv->name) =3D=3D 0 and m=
atches
this new child platform device against optee_driver, recursively calling
optee_probe() (which logs errors and fails with -ENXIO).  On non-DT systems
that already have a platform device named "optee" with PLATFORM_DEVID_NONE,
registering a second one also fails with -EEXIST, and only a single platform
driver can bind to the device at a time.

> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index 1aac50c7c1de7..0d3c266b29c7b 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c

[ ... ]

> @@ -1225,6 +1226,26 @@ int tee_device_register(struct tee_device *teedev)
>  }
>  EXPORT_SYMBOL_GPL(tee_device_register);
> =20
> +static void plat_tee_free(void *data)
> +{
> +	struct platform_device *plat_dev =3D data;
> +
> +	platform_device_unregister(plat_dev);
> +}
> +
> +int tee_platform_device_register(struct tee_device *teedev, const char *=
teename)
> +{
> +	struct platform_device *plat_dev;
> +
> +	plat_dev =3D platform_device_register_data(&teedev->dev, teename,
> +						 PLATFORM_DEVID_NONE, NULL, 0);
> +	if (IS_ERR(plat_dev))
> +		return PTR_ERR(plat_dev);
> +
> +	devm_add_action_or_reset(&teedev->dev, plat_tee_free, plat_dev);
> +	return 0;

[Severity: Medium]
Should tee_platform_device_register() return the result of
devm_add_action_or_reset()?  __devm_add_action_or_reset() is marked
__must_check and on allocation failure it runs plat_tee_free() to unregister
plat_dev, while this function still returns 0 to the caller.

> +}

[Severity: High]
Does tee_platform_device_register() need EXPORT_SYMBOL_GPL()?  It is defined
in tee.ko and called from optee_probe() and optee_ffa_probe() in optee.ko, =
so
building OP-TEE as a module fails at modpost with an undefined symbol.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ice-migrat=
e-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com?part=3D4
