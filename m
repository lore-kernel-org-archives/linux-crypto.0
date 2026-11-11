Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794412055;
	b=tn2hSFShjuB0fJIUIGX8b80IvPu92BemnYgy95MvN0bjONXdHUh0cXx3n70PJpa+eiHB
	 gd5CrxrOigWQoHKv18WgRnR0Cv6mG8wINZQQor3lEmKe+Nnz6t/xLVWMEAkZz9RjSPjoQ
	 tqm2FLFFGeWBMWZn1c/fG47R4ZxUp+iqzECFROly9sAnWK3B0qZHL683KeCu73VZdYjzR
	 mufdUPbONSTwfW4HsFRoCt4+vW9iKsraM+jzhxqISuJTUNs1GzSL2TSFH3YXrWy1YlThH
	 8QSFWEshOWC9PRoWP37A8qF9ZMEEwMHo70k79UhjD6MCYgkN4nREFgcvni4wzxnonyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412055;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xIZHJyQOhdBp8HxU5684aVF32yUv2tOaBYVhKjjuZgs=;
	b=vme49tb/Q/6lLUauXiaC/mQdAou16kNHOQCk3JlOxn28gO5Eq+VhCsDJ3+zeqHpapQq7
	 LDNPWN3FjWf5TuTl+q9Hp3+ZUFNL0uO00PlNwFY6Sg1oXpLzeNvPESFM5vJua8H/N1Fg4
	 2WaN7mpvz5M33qSb1Y7Tbaiznw/PUPApwiOiwlud1cwsE/dzIFfyLsX/hBbIEWuVmX1w1
	 qhnXFz4wZBpGBxt4MqJQpyrEnwDh82Eo0+TyZBNnFcZOWQ1h9sLCOa3ROIXaw3hgOLQBL
	 xs8Kzl7Z9ubtNoozL3bMp24gveEHmVljWAoRIVaE8+JAmn8LB/CjHzos3gTbEsZNouQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMmEb7Eh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBB606A326
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMmEb7Eh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E91F00A08;
	Wed, 11 Nov 2026 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794412055;
	bh=xIZHJyQOhdBp8HxU5684aVF32yUv2tOaBYVhKjjuZgs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GMmEb7EhuycQBA8Lrgnj0VsowFCWZKFXM3H1uwTpwD5EXXrO48kyQe5itKPPbVNsY
	 SaQHpx1qsKXDoAj7mwIYOyQiGBBRAHYwFp9re7fhjP5BVtnUIvyU9yHs2evl01SdH4
	 GAZ+wnO8qyTLZzBRKYBBW8x+DGYtHA01US8ws8+5js/W5FUMqJ7xzZFMN8nF86LBBg
	 JTPYr9Qplt90BFmmiDM2j91F0LV8YaFC40Fb6Kc4bDRL4dZ/dWfg1fsXSP+wZtyj/V
	 5WPfQFoCOmIsqBrIiNh+3WsdblyL0SCCPXjJbEjuKJQ6Jr+wefk/RA/vKpeUTo/nrg
	 FmteVk12uawRg==
Message-ID: <sashiko-outbox-209231@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/6] soc: qcom: ice: Migrate to the TZ agnostic ICE
 APIs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Eric Biggers" <ebiggers@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Abel
 Vesa" <abelvesa@kernel.org>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>, "Sumit
 Garg" <sumit.garg@oss.qualcomm.com>, "Selvam Sathappan Periakaruppan" <selvam.periakaruppan@oss.qualcomm.com>
Cc: "Basant Kumar" <basantk@qti.qualcomm.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-5-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-5-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 15:47:34 +0000
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
- [High] soc: qcom: ice: infinite probe deferral in qcom_ice_create()
  without OP-TEE
- [High] soc: qcom: ice: circular module dependency and build failure in
  qcom_ice_create()
- [Medium] soc: qcom: ice: -ENODEV converts to true in
  qcom_ice_tz_has_wrapped_key_support()
- [Medium] soc: qcom: ice: unsynchronized ice_tz_ops access races with
  backend teardown
--

commit 6c35fbb5f17a57538422d90392b9a647da09687a
Author: Harshal Dev <harshal.dev@oss.qualcomm.com>

soc: qcom: ice: Migrate to the TZ agnostic ICE APIs

This commit switches the Qualcomm Inline Crypto Engine driver from calling
qcom_scm_*() directly to using the qcom_ice_tz_*() wrapper functions.

> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 4844621b74970..9bab177f7ce55 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -307,7 +307,7 @@ static bool qcom_ice_check_supported(struct qcom_ice =
*ice)
>  	 * advertise support for raw keys or wrapped keys, HWKM cannot be used
>  	 * unconditionally.  A module parameter is used to opt into using it.
>  	 */
> -	if (ice->hwkm_version && qcom_scm_has_wrapped_key_support()) {
> +	if (ice->hwkm_version && qcom_ice_tz_has_wrapped_key_support()) {

[Severity: Medium]
Does qcom_ice_tz_has_wrapped_key_support() evaluate to true when ice_tz_ops
is NULL?

drivers/soc/qcom/ice.c:qcom_ice_tz_has_wrapped_key_support() {
	struct qcom_ice_tz_ops *ops;

	ops =3D ice_tz_ops;
	if (!ops)
		return -ENODEV;

	return ops->ice_has_wrapped_key_support(ops->dev);
}

Because the return type is bool, returning -ENODEV converts to true,
causing qcom_ice_check_supported() to falsely enable ice->use_hwkm when
ice_tz_ops is NULL.

[ ... ]

> @@ -553,9 +553,9 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsign=
ed int slot,
>  	for (i =3D 0; i < ARRAY_SIZE(key.words); i++)
>  		__cpu_to_be32s(&key.words[i]);
> =20
> -	err =3D qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
> -				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
> -				   blk_key->crypto_cfg.data_unit_size / 512);
> +	err =3D qcom_ice_tz_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
> +				  QCOM_ICE_CIPHER_AES_256_XTS,
> +				  blk_key->crypto_cfg.data_unit_size / 512);

[Severity: Medium]
Can qcom_ice_tz_set_key() and the other qcom_ice_tz_*() wrappers race with
qcom_ice_tz_ops_unregister() during backend teardown?

CPU0                              CPU1
qcom_ice_program_key()
  qcom_ice_tz_set_key()
    ops =3D ice_tz_ops;
    if (!ops)
                                  qcom_ice_tee_remove()
                                    qcom_ice_tz_ops_unregister(...)
                                      smp_store_release(&ice_tz_ops, NULL)
                                    tee_client_close_session(...)
                                    tee_client_close_context(...)
                                    /* devm frees qcom_ice_tee_private */
    ops->ice_set_key(ops->dev, ...)
      ...                         <-- use-after-free on ops->dev data

Each qcom_ice_tz_*() wrapper reads ice_tz_ops without holding a lock or
reference, and qcom_ice_tz_ops_unregister() clears ice_tz_ops without
waiting for in-flight calls to complete before qcom_ice_tee_remove() tears
down the TEE session and frees its devm-managed driver data.

[ ... ]

> @@ -696,11 +696,11 @@ static struct qcom_ice *qcom_ice_create(struct devi=
ce *dev,
>  {
>  	struct qcom_ice *engine;
> =20
> -	if (!qcom_scm_is_available())
> +	if (!qcom_ice_tz_is_available())
>  		return ERR_PTR(-EPROBE_DEFER);

[Severity: High]
Does checking qcom_ice_tz_is_available() here cause qcom_ice_create() to
return -EPROBE_DEFER forever on platforms that do not have both QTEE SCM
and OP-TEE available at the same time?

drivers/soc/qcom/ice.c:qcom_ice_tz_is_available() {
	...
	return (qcom_scm_is_available() & qcom_ice_tee_is_available());
}

qcom_ice_tee_is_available() only becomes true when an OP-TEE platform
device binds to qcom_ice_plat_probe().  On any QTEE/SCM platform without
OP-TEE (or on an OP-TEE platform without qcom_scm),
qcom_ice_tz_is_available() never becomes true even after ice_tz_ops is
registered, so UFS and SDHCI controllers calling devm_of_qcom_ice_get()
defer probe indefinitely and cannot mount the root filesystem.

Conversely, on OP-TEE platforms, qcom_ice_plat_probe() and
qcom_ice_tee_probe() bind on different buses; if qcom_ice_plat_probe() sets
__teedev before qcom_ice_tee_probe() registers qcom_ice_tee_ops,
qcom_ice_tz_is_available() returns true while qcom_ice_tz_ops_registered()
is still false, causing qcom_ice_create() to fail permanently with
-EOPNOTSUPP instead of deferring probe.

> =20
> -	if (!qcom_scm_ice_available()) {
> -		dev_warn(dev, "ICE SCM interface not found\n");
> +	if (!qcom_ice_tz_ops_registered()) {
> +		dev_warn(dev, "ICE firmware service interface not found\n");
>  		return ERR_PTR(-EOPNOTSUPP);
>  	}

[Severity: High]
Does calling qcom_ice_tz_is_available() and qcom_ice_tz_ops_registered() in
qcom_ice_create() introduce a circular module dependency and break modular
builds?

Making qcom_ice_tz_is_available() live causes qcom_ice to reference
qcom_ice_tee_is_available() from qcom_ice_tee and qcom_scm_is_available()
from qcom_scm, while both of those modules call qcom_ice_tz_ops_register()
and qcom_ice_tz_ops_unregister() exported by qcom_ice.  This also fails to
link when CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dy and CONFIG_QCOM_ICE_TEE is
modular or disabled.

In addition, include/soc/qcom/ice.h guards qcom_ice_tz_ops_register() and
qcom_ice_tz_ops_unregister() with #ifdef CONFIG_QCOM_INLINE_CRYPTO_ENGINE
instead of IS_ENABLED(CONFIG_QCOM_INLINE_CRYPTO_ENGINE):

include/soc/qcom/ice.h:
#ifdef CONFIG_QCOM_INLINE_CRYPTO_ENGINE
int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *ops);
void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *ops);
#else
static inline int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *__unused)
{
	return 0;
}

When CONFIG_QCOM_INLINE_CRYPTO_ENGINE=3Dm (such as in arm64 defconfig), the
static inline stubs in include/soc/qcom/ice.h conflict with the definitions
in drivers/soc/qcom/ice.c and turn registration in the backends into a
no-op, leaving qcom_ice_tz_ops_registered() permanently false.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ice-migrat=
e-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com?part=3D5
