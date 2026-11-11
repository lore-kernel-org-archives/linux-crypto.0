Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409681;
	b=iYDGa5DmQYSS5HGmei3tb13h/fhPoqXHiEcq/AmynK4D7sVJSFEuHE1ML1n4tQJrVFZA
	 4WO6QEw90FUjgmBiZuLeOZ6RisyF+eQsHvZWRWn4UmYRkYhKaS4g632tFETZ7ssC1zQxk
	 yiSccE9Bajcm9OBadgNxLOCp0Q++KQrpMCbA7+oTZC7/ExlnF9XgXe/I2X5hWl+2jwyGx
	 Zc0H7RSM7K3z2RMdVE67+1P+k4SZELPHBeML1rZnv1p7XXZzDS1OlXQiOYxVphNOL5oBq
	 05GnVV6KKEqLgoeWJBTP7Szoqlorhi1Ruk5lQEy2AUZAJDEZc4MJcDoaT4n5E6lyVeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409681;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ih2B8blwTc3USqx6VcHYBPSXPYFyGlrDkk2IWGJJ8RY=;
	b=kLPGXxdeeXTAaYn+sNyC5xtIIOVxETGBElwpGE0Ya96zYzMW/wMPnGkoUL66Ae37GIrh
	 +SlPi32vyfvbY6WFhyytBhNHb4cE48fDxBtTNuSulq6VFUZj/F4Ey+Grx40hEiB8jNB5F
	 ssd4/F7wz6kk6M0ec3ISe98HAfwsOiJc4rDJLXn/BznMGyVlUAj7NOYdciZOcFj0UMko3
	 jJBK9pJuw18DnS4+vWoMmQ9U2jpINr33Y80ZvIVtOAI0d3Kf+qbIU0YJWJdAPC+KFAumt
	 KPKVTFOSVqvB5lD+J9S19QQ/x92+Q5oA47fFPdg+W7cRN2rCyDJWEk+YHNSKZVLTM8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oiW8jtYi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36625606A33A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oiW8jtYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB62C1F00A05;
	Wed, 11 Nov 2026 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794409680;
	bh=ih2B8blwTc3USqx6VcHYBPSXPYFyGlrDkk2IWGJJ8RY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oiW8jtYibBCfW8SldCv6W6KmObhplE+P0sQneiQ9e7RAgGX28wz0bZ7ANq0U969IU
	 77VnXsdHJqWbl7dbU7YP6Z5he54LKEorjEytS9a6eZ3xhx7JfeqilESIAr7zaO5ggO
	 eaHlX5Wq5bsRxhstXPZDpvWqZaOOWtSBG5hy/p2uny4/VGRXUh24LmEgAZQvJkt4TK
	 GGH6o08mohq8/7mEu9SqDv92h53odJaI44YEPjUcVtL9X9eBTy0Dk51NZ6o7PklT75
	 9P94b3cyEhnz1ici2XRbJuUqb0Xqar4aL98mm8zs1VzWaxHVbSh+bVtweYwJtPpwr8
	 qyQcVqXz6XIow==
Message-ID: <sashiko-outbox-209215@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/6] firmware: qcom: Add a TEE bus based ICE back-end
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Eric Biggers" <ebiggers@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Abel
 Vesa" <abelvesa@kernel.org>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>, "Sumit
 Garg" <sumit.garg@oss.qualcomm.com>, "Selvam Sathappan Periakaruppan" <selvam.periakaruppan@oss.qualcomm.com>
Cc: "Basant Kumar" <basantk@qti.qualcomm.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-3-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-3-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 15:07:58 +0000
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
- [High] firmware: qcom: missing qcom_ice_tee.h breaks build in
  qcom_ice_tee.c
- [High] firmware: qcom: broken stub guard and Kconfig deps for
  qcom_ice_tee_probe()
--

commit dca5daf641df3494a0c5504854d7604efeca0f27
Author: Harshal Dev <harshal.dev@oss.qualcomm.com>

firmware: qcom: Add a TEE bus based ICE back-end

This commit adds an OP-TEE client driver that registers TrustZone operations
for the Qualcomm Inline Crypto Engine (ICE) driver.

> diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfig
> index 3ad22f8fc3e5f..189ada7fdcd67 100644
> --- a/drivers/firmware/qcom/Kconfig
> +++ b/drivers/firmware/qcom/Kconfig
> @@ -25,6 +25,15 @@ config QCOM_PAS_TEE
>  	  Enable the generic Peripheral Authentication Service (PAS) provided
>  	  by the firmware TEE implementation as the backend.
> =20
> +config QCOM_ICE_TEE
> +	tristate
> +	depends on TEE
> +	depends on !CPU_BIG_ENDIAN
> +	default m if ARCH_QCOM
> +	help
> +	  Enable the generic Inline Crypto Engine (ICE) firmware service TEE
> +	  implementation as a backend.
> +
>  config QCOM_SCM
>  	tristate "Qualcomm PAS SCM interface driver" if ARCH_QCOM || COMPILE_TE=
ST
>  	select QCOM_PAS
> diff --git a/drivers/firmware/qcom/Makefile b/drivers/firmware/qcom/Makef=
ile
> index 88ce74d74c3e2..5ef64f17e6e59 100644
> --- a/drivers/firmware/qcom/Makefile
> +++ b/drivers/firmware/qcom/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_QCOM_QSEECOM)	+=3D qcom_qseecom.o
>  obj-$(CONFIG_QCOM_QSEECOM_UEFISECAPP) +=3D qcom_qseecom_uefisecapp.o
>  obj-$(CONFIG_QCOM_PAS)		+=3D qcom_pas.o
>  obj-$(CONFIG_QCOM_PAS_TEE)	+=3D qcom_pas_tee.o
> +obj-$(CONFIG_QCOM_ICE_TEE)     +=3D qcom_ice_tee.o
> diff --git a/drivers/firmware/qcom/qcom_ice_tee.c b/drivers/firmware/qcom=
/qcom_ice_tee.c
> new file mode 100644
> index 0000000000000..694aa05847f0e
> --- /dev/null
> +++ b/drivers/firmware/qcom/qcom_ice_tee.c
> @@ -0,0 +1,402 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/tee_drv.h>
> +#include <linux/uuid.h>
> +#include <linux/firmware/qcom/qcom_ice_tee.h>

[Severity: High]
Does including <linux/firmware/qcom/qcom_ice_tee.h> here break compilation =
at
this commit?

include/linux/firmware/qcom/qcom_ice_tee.h is not created until a later pat=
ch
in the series, commit "tee: optee: Register TEE devices on the platform bus=
",
and nothing in qcom_ice_tee.c uses it.  Moving this #include to that commit
would keep this patch compilable and bisectable.

[ ... ]

> +	qcom_ice_tee_ops.dev =3D dev;
> +	ret =3D qcom_ice_tz_ops_register(&qcom_ice_tee_ops);
> +	if (ret)
> +		goto err_ops;
> +
> +	return 0;
> +err_ops:
> +	tee_client_close_session(data->ctx, data->session_id);
> +err_sess:
> +	tee_client_close_context(data->ctx);
> +	return ret;
> +}
> +
> +static void qcom_ice_tee_remove(struct tee_client_device *ice_dev)
> +{
> +	struct device *dev =3D &ice_dev->dev;
> +	struct qcom_ice_tee_private *data =3D dev_get_drvdata(dev);
> +
> +	qcom_ice_tz_ops_unregister(&qcom_ice_tee_ops);

[Severity: High]
When the ICE driver is built as a module, do qcom_ice_tz_ops_register() and
qcom_ice_tz_ops_unregister() here resolve to the no-op stubs in
include/soc/qcom/ice.h?

In commit "soc: qcom: ice: Add TZ agnostic re-direction functions", the
declarations in include/soc/qcom/ice.h are guarded with #ifdef rather than
IS_ENABLED():

include/soc/qcom/ice.h:
    #ifdef CONFIG_QCOM_INLINE_CRYPTO_ENGINE
    int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *ops);
    void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *ops);
    #else
    static inline int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *__un=
used)
    {
    	return 0;
    }

Because qcom_inline_crypto_engine is a tristate symbol (defaulting to m in
arm64 defconfig), modular builds define CONFIG_QCOM_INLINE_CRYPTO_ENGINE_MO=
DULE
instead of CONFIG_QCOM_INLINE_CRYPTO_ENGINE, so qcom_ice_tee_probe() silent=
ly
calls the stub and never registers qcom_ice_tee_ops with the ICE driver.

Also, in drivers/firmware/qcom/Kconfig, the new qcom_ice_tee entry has no
dependency on qcom_inline_crypto_engine (allowing qcom_ice_tee to be built-=
in
while qcom_inline_crypto_engine is a module, or built when it is disabled) =
and
defines help text on a promptless tristate symbol.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ice-migrat=
e-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com?part=3D3
