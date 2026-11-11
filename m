Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794407831;
	b=yKE7v5oErgOFjv/wAnjYks/D7q8EuV+AGrDof3BbTsVLVruaypp3feBWGtnj6ZQ9gqkr
	 9pGCxV+0BAhx9039q6BpNis1V21spPiXbP0JZMpfQiLxYS+Yy+XS77oSjWAmXAmsQNJW6
	 YHxm/vF9zG+6YhU1vvELfQpwr8oLmhqXkTRfV8OO5Dg7gJMp6TQzdCnomIvn5oxn7Js2e
	 AC7QrCb8sWHHWOvLCqs4FZ97XFm0h3EUu2pdTv5tYnzmng2bCmL3D06z7DGkfoKYivZzG
	 yn7WFqtYTawnwrLR/hQhGIEg528h6xYUJhNy1NaZhe6EfSk0MU4Nha5cQsQRNUsEY6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407831;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CSxxSIPi6RvxMgWgiHMOLM06SK6zDJV7usqwPI3cSzw=;
	b=5hARL3vc2w4AVgXQqXwlMvEp48HXr82QwAdwfaeHtKbnsfQIFPTzqFi4i5JTLhS0fLpC
	 RiyNYd7P9WNaNcu7pDj2JrSKJK93tPYyN1FuI3LnFE6/5jLkORTAzdw0Q+iDfqv40PY3U
	 FsSeMbc2nJKQbtp4yLBlQ78mD01/SerznLVmbntJV7hmGu1jX343ucAqtqLYalmtlgy3P
	 KAPz6HF+6mQBiZL/nVAJjvprBdncMMVjytWvnCUAYHAI7NgwIt+rO7QcbOk/Cm+hih1F+
	 VRikpXLmytGnvaP+Y3vy+t4jj32APZ+ltnnkLlzrZh7VhzdkhBJinGW/qwCWAx/G6kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CdaqOJnB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DAC606A327
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CdaqOJnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DAE1F00A09;
	Wed, 11 Nov 2026 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794407831;
	bh=CSxxSIPi6RvxMgWgiHMOLM06SK6zDJV7usqwPI3cSzw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CdaqOJnByrVodiO2OU8NpecTd4Lui7HzQ4x/afOHYF0Ymrgw4rSf7VqAQnkNR7btV
	 MM1lVofDM8Hk7VjAoQlOdHWbVBoPYeN6ohtWyH7YYlB8h+F7TNoSJi4Gi68tZrONO5
	 f5czFthDEsAUGuuRG8YeE8OggBT2es5wcOM1NH1SOtKuiJyWRrtr9RrcJg3VyyS0AD
	 G/fX9Era53hSB9xxOs0ydMP+bF7VJ86bYnYgx2EM3VTcJMtahnXgz3psP7u6pXbxUW
	 +VbITB3SxS2QTu242T2TrYQYFGk7WHWA4XUqEcRkRGbpuM0o2m8fSPx6i72SXGtupF
	 Y4TeFIYTil3iw==
Message-ID: <sashiko-outbox-209172@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/6] soc: qcom: ice: Add TZ agnostic re-direction
 functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Eric Biggers" <ebiggers@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Abel
 Vesa" <abelvesa@kernel.org>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>, "Sumit
 Garg" <sumit.garg@oss.qualcomm.com>, "Selvam Sathappan Periakaruppan" <selvam.periakaruppan@oss.qualcomm.com>
Cc: "Basant Kumar" <basantk@qti.qualcomm.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-1-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-1-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:37:09 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] soc: qcom: ice: broken CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dm guard
  in ice.h
- [High] soc: qcom: ice: broken TZ availability check in
  qcom_ice_tz_is_available()
- [Medium] soc: qcom: ice: qcom_ice_tz_has_wrapped_key_support() returns
  -ENODEV as bool
- [Low] soc: qcom: ice: non-atomic check-then-store in
  qcom_ice_tz_ops_register()
--

commit aaede1b942c524f288e35421c3d46bb0baa718ed
Author: Harshal Dev <harshal.dev@oss.qualcomm.com>

soc: qcom: ice: Add TZ agnostic re-direction functions

This commit adds TrustZone-agnostic redirection functions and a backend
operations registration interface so the Qualcomm ICE driver can route calls
to either QTEE SCM or an OP-TEE backend.

> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index e256595b9826f..452896b1858f1 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -118,6 +118,130 @@ struct qcom_ice {
>  static DEFINE_XARRAY(ice_handles);
>  static DEFINE_MUTEX(ice_mutex);
> =20
> +static struct qcom_ice_tz_ops *ice_tz_ops;
> +
> +static bool qcom_ice_tz_ops_registered(void)
> +{
> +	/*
> +	 * The barrier is intended to synchronize the data stores for the
> +	 * ice_tz_ops data structure when client drivers (UFS/SDHC) are in
> +	 * parallel checking for ICE service availability.
> +	 */
> +	return !!smp_load_acquire(&ice_tz_ops);
> +}
> +
> +static bool qcom_ice_tz_is_available(void)
> +{
> +	return qcom_scm_is_available();
> +}

[Severity: High]
As reported by Eric Biggers on v1 [1], does qcom_ice_tz_is_available() cause
qcom_ice_create() to return -EPROBE_DEFER indefinitely on QTEE-only
platforms?

Later in this series, commit "tee: optee: Register TEE devices on the
platform bus" updates qcom_ice_tz_is_available() to return
(qcom_scm_is_available() & qcom_ice_tee_is_available()), and commit
"soc: qcom: ice: Migrate to the TZ agnostic ICE APIs" makes
qcom_ice_create() return -EPROBE_DEFER when qcom_ice_tz_is_available() is
false before checking qcom_ice_tz_ops_registered().  Because
qcom_ice_tee_is_available() only becomes true after an OP-TEE platform
device probes, it stays false on QTEE-only platforms (or when CONFIG_OPTEE
is disabled).  Since ufs_qcom_ice_init() and sdhci_msm_ice_init() only fall
back to running without inline encryption on -EOPNOTSUPP and propagate
-EPROBE_DEFER, UFS and eMMC/SDHC controllers never finish probing on those
platforms.

[ ... ]

> +static bool qcom_ice_tz_has_wrapped_key_support(void)
> +{
> +	struct qcom_ice_tz_ops *ops;
> +
> +	ops =3D ice_tz_ops;
> +	if (!ops)
> +		return -ENODEV;
> +
> +	return ops->ice_has_wrapped_key_support(ops->dev);
> +}

[Severity: Medium]
Does returning -ENODEV from a bool function evaluate to true when
ice_tz_ops is NULL?  Besides triggering a -Wint-in-bool-context compiler
warning, this reports that wrapped keys are supported when no TZ backend is
registered.

[ ... ]

> +int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *ops)
> +{
> +	if (!qcom_ice_tz_ops_registered())
> +		/* Paired with smp_load_acquire() in qcom_ice_tz_ops_registered() */
> +		smp_store_release(&ice_tz_ops, ops);
> +	else
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_tz_ops_register);
> +
> +void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *ops)
> +{
> +	if (READ_ONCE(ice_tz_ops) =3D=3D ops)
> +		/* Paired with smp_load_acquire() in qcom_ice_tz_ops_registered() */
> +		smp_store_release(&ice_tz_ops, NULL);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_tz_ops_unregister);

[Severity: Low]
Can two backends probing in parallel on the platform and TEE buses both pass
!qcom_ice_tz_ops_registered() and overwrite ice_tz_ops instead of returning
-EBUSY?  Using cmpxchg() or a mutex across register and unregister would ma=
ke
the check and update atomic.

> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 4bee553f0a59d..89e62e151b85b 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h

[ ... ]

> @@ -31,4 +72,19 @@ int qcom_ice_import_key(struct qcom_ice *ice,
>  			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
>  struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
> =20
> +#ifdef CONFIG_QCOM_INLINE_CRYPTO_ENGINE
> +int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *ops);
> +void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *ops);
> +#else
> +static inline int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *__unu=
sed)
> +{
> +	return 0;
> +}
> +
> +static inline
> +void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *__unused)
> +{
> +}
> +#endif /* CONFIG_QCOM_INLINE_CRYPTO_ENGINE */
> +
>  #endif /* __QCOM_ICE_H__ */

[Severity: High]
Does #ifdef CONFIG_QCOM_INLINE_CRYPTO_ENGINE break the build when
CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dm?

QCOM_INLINE_CRYPTO_ENGINE is a tristate symbol (and defaults to =3Dm in arm=
64
defconfig), so when built as a module only
CONFIG_QCOM_INLINE_CRYPTO_ENGINE_MODULE is defined.  The header then exposes
the static inline stubs, which conflict with the non-static definitions in
drivers/soc/qcom/ice.c and cause TZ backends to call no-op stubs.  Also, if
CONFIG_QCOM_SCM=3Dy while CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dm, built-in
qcom_scm cannot link against symbols exported by qcom_ice.ko.

[1] https://lore.kernel.org/r/20261024185602.GF2553@quark

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ice-migrat=
e-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com?part=3D1
