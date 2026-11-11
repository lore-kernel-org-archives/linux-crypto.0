Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408906;
	b=cRLSvlol8MvcOE1MuIBsL1xQfIrcQABq3c3AfIKSsbi+8YG8uQM8HxXT0UMsNDx1sa/i
	 EZN2tnf+14MrLnl8FGD7iWcvCni6wKL/eUEBNvWkbSgKuTZpwmgHxSCAugG/9xnA05bsD
	 hhKCj3/eg/zNYToDaOxk82ELEHOCS0STkRzvIKy+4U5wXbn8KgU/ew1XzYDtFg0hPYIvd
	 Ek/ZDL2TZPj48feUstoskSj0hXFSw68wyvk5jL/DyhoCVDDlNbWbJg9LkxwPngEAKcrow
	 hkWNMGzczfC0gTOlsVqWGyprLWu2eEBPoH+9f8atusqE/a73ecJmCz+irT4D60V2q/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408906;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LTKIZ2aQVmEJlChOYMANH8jRETy8IQU0+96JUTFYwH8=;
	b=SisnpeUQSAIEVlxvdzUvtvSgFHIl7HYzze6qdxiJephh7ZAkcfhxfynhZ60WXQ2n4nAe
	 nKUfJJLA+++giu5iaOO4YJBDCWWSyIWx+7FGsngC8SlJtGIKJYYKsLXxZB7XYWm0b/LV3
	 6aD+NdCyIXoth1TbX0g00qXNjlljXXGnB6iQQgcmidU3JoTExWdDw5SCsluOHbhPx2Fue
	 vCeeKacAfEdgr9Ii8jtyg3NxunDNaf94bi3bD2P0naoUrRvVQv1d2u/e4ENC56UAVN0Qk
	 6lbUrIh68fX7qIDizzP3fuRAiPyrQYsEdEEzfcWVmTTAEQ7xKvzDIoKAUTq2z5cH8Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCivYfj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F989606A321
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCivYfj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3E91F00A05;
	Wed, 11 Nov 2026 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408906;
	bh=LTKIZ2aQVmEJlChOYMANH8jRETy8IQU0+96JUTFYwH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GCivYfj+KoAXwW52LbAnpJFoIlqU8K6mjERuhEZPYTdhzf49i11r2A3feNhPHc11R
	 v0CEoIDFzTMxaEX/RddtbIVd89OlORigLnqySDC9rcSKnL1Tll3BmAsQvic7Yor0a+
	 89t2dhVJTx+g5D8HhGZSKc4oI0tOjr7Vmmy84Npxv/yWkdWMWisKPtsufQ0qxRhorw
	 0f8QDU3Ronv42YSTgUCZOgLcCNzG6waKrmLA3tkB+Kt2mmvXDJKQLLVapf5ZMeM6AA
	 VBA0u8BMGIc91tm6ZWMIBKzUV9KD+7ylXcpG9kh63IPXaSe4xTbS4aJJNn1+dhX8/Y
	 9Lt/sxw52UPVQ==
Message-ID: <sashiko-outbox-209201@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/6] firmware: qcom_scm: Transition to ICE TZ
 agnostic operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Eric Biggers" <ebiggers@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Abel
 Vesa" <abelvesa@kernel.org>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>, "Sumit
 Garg" <sumit.garg@oss.qualcomm.com>, "Selvam Sathappan Periakaruppan" <selvam.periakaruppan@oss.qualcomm.com>
Cc: "Basant Kumar" <basantk@qti.qualcomm.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-2-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-2-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:55:05 +0000
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
- [High] firmware: qcom_scm: broken qcom_ice_tz_ops_register() linkage
  when ICE=3Dm
- [Medium] firmware: qcom_scm: missing static on
  __qcom_scm_ice_available()
- [Low] firmware: qcom_scm: kernel-doc mismatch on static
  __qcom_scm_ice_*()
--

commit 8abba45f5b733420aae4f360c4bcadfad9c878ba
Author: Harshal Dev <harshal.dev@oss.qualcomm.com>

firmware: qcom_scm: Transition to ICE TZ agnostic operations

This commit transitions the ICE-related SCM calls to static helpers
registered as a qcom_ice_tz_ops backend while keeping the existing
exported wrappers in place.

> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qco=
m_scm.c
> index 43e250faea75a..6b66bcedc84fd 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
[ ... ]
> @@ -1397,6 +1399,14 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_clie=
nt id, u32 offset, u32 size)
>  }
>  EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
> =20
> +bool __qcom_scm_ice_available(struct device *dev)
> +{
> +	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
> +					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
> +		__qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
> +					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
> +}

[Severity: Medium]
Should __qcom_scm_ice_available() be marked static?

It is only used within drivers/firmware/qcom/qcom_scm.c and has no prior
prototype declaration, which triggers a -Wmissing-prototypes warning and
breaks CONFIG_WERROR=3Dy builds at this commit until commit "firmware: qcom:
scm: Drop exported ICE wrapper functions" removes the helper later in the
series.

> @@ -1424,7 +1431,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
>   *
>   * Return: 0 on success; -errno on failure.
>   */
> -int qcom_scm_ice_invalidate_key(u32 index)
> +static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
>  {
>  	struct qcom_scm_desc desc =3D {
>  		.svc =3D QCOM_SCM_SVC_ES,
> @@ -1434,7 +1441,12 @@ int qcom_scm_ice_invalidate_key(u32 index)
>  		.owner =3D ARM_SMCCC_OWNER_SIP,
>  	};
> =20
> -	return qcom_scm_call(__scm->dev, &desc, NULL);
> +	return qcom_scm_call(dev, &desc, NULL);
> +}
> +
> +int qcom_scm_ice_invalidate_key(u32 index)
> +{
> +	return __qcom_scm_ice_invalidate_key(__scm->dev, index);
>  }
>  EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);

[Severity: Low]
Does leaving the kernel-doc comments above __qcom_scm_ice_invalidate_key()
and the five other __qcom_scm_*() helpers cause scripts/kernel-doc warnings?

Each comment still documents the exported qcom_scm_*() symbol name and
omits the new @dev parameter on __qcom_scm_ice_invalidate_key(),
__qcom_scm_ice_set_key(), __qcom_scm_derive_sw_secret(),
__qcom_scm_generate_ice_key(), __qcom_scm_prepare_ice_key(), and
__qcom_scm_import_ice_key().  Later in the series, commit "firmware: qcom:
scm: Drop exported ICE wrapper functions" renames these static helpers
back to qcom_scm_*(), but @dev remains undocumented in all six kernel-doc
blocks.

[ ... ]

> @@ -2820,6 +2888,18 @@ static int qcom_scm_probe(struct platform_device *=
pdev)
>  					     "Failed to request qcom-scm irq\n");
>  	}
> =20
> +	/*
> +	 * If the ICE SCM interface is available, the operations MUST be
> +	 * registered before the SCM API is published below, otherwise
> +	 * ICE driver could attempt to call the ICE SCM pointers before
> +	 * they are registered and assume that they aren't available.
> +	 */
> +	if (__qcom_scm_ice_available(scm->dev)) {
> +		qcom_ice_scm_ops.dev =3D scm->dev;
> +		ret =3D qcom_ice_tz_ops_register(&qcom_ice_scm_ops);
> +		WARN(ret < 0, "failed to register ice SCM ops: %d\n", ret);
> +	}
> +
>  	/*
>  	 * Paired with smp_load_acquire() in qcom_scm_is_available().
>  	 *
> @@ -2876,6 +2956,7 @@ static void qcom_scm_shutdown(struct platform_devic=
e *pdev)
>  	/* Clean shutdown, disable download mode to allow normal restart */
>  	qcom_scm_set_download_mode(__scm, QCOM_DLOAD_NODUMP);
>  	qcom_pas_ops_unregister();
> +	qcom_ice_tz_ops_unregister(&qcom_ice_scm_ops);
>  }

[Severity: High]
Does qcom_scm_probe() silently call the no-op stub for
qcom_ice_tz_ops_register() when CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dm?

In include/soc/qcom/ice.h, the declarations are guarded with #ifdef rather
than IS_ENABLED():

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

Because QCOM_INLINE_CRYPTO_ENGINE is a tristate symbol (and defaults to =3Dm
in arm64 defconfig via CONFIG_SCSI_UFS_QCOM=3Dm while CONFIG_QCOM_SCM=3Dy),
qcom_scm_probe() and qcom_scm_shutdown() compile against the static inline
stubs, so qcom_ice_scm_ops is never registered and inline encryption fails
once the ICE driver checks qcom_ice_tz_ops_registered().

Even with IS_ENABLED(CONFIG_QCOM_INLINE_CRYPTO_ENGINE), CONFIG_QCOM_SCM=3Dy
with CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dm fails to link vmlinux against
qcom_ice_tz_ops_register() and qcom_ice_tz_ops_unregister() in qcom_ice.ko,
and building both as modules creates a circular dependency between
qcom-scm.ko and qcom_ice.ko while qcom_ice still calls qcom_scm_is_availabl=
e().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ice-migrat=
e-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com?part=3D2
