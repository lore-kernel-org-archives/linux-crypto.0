Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794412492;
	b=FE861MZ1mMqF+bbM4m6RaFlelHUWSHyUovDp2/wKXnb0Fih78e2NI+dGVHV2dLZeRfQx
	 nMHs9hL9wNFcDFxHadPGNNhI24sdZd6o7LMoEzE8jcta+0E06j0xFHJGlMeCq9tbcOkJn
	 yioDYQsIV4knMWVWKz6qM2DBbWqAqemIczxBJGizlSce/CGcSUwSoMAZAGUHkpfGUn/Aq
	 eHEzYfllHRnRqntUMZ6MAU06YblvbXa9xHSu+yjnk0VFAxw+2EjD0AV6qaQqz5+eCO+vv
	 7j5JD3Ou7YcU0i5gZVq15mpxtWaPpNPT8CjMldbmHhNYGEhv4MBQi5Dv3ZRziHbHvdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412492;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nSe4OW8xhUxzc1SihiNGaIeSrpjr0BWrfZIJ2KCa3CA=;
	b=eKIUrv1WZCvDm60gmPI3zt6dWEXjxpIKPz1RcCvhlyACTqcTNxYdWkSL4ohrWMADDMwQ
	 tGW09kg+NytOkgpt9Hxm1nuYI1KtfS9Uy5usNg5Ino4ZOb4c9R0FYlBV/RkEHNYQHeAWJ
	 1J2MEExPxjNp9KdbyNqBYjdbupWKvGph3yZnI6DvCIFbpFrsfPBI5YXzBr9aP8sTG6bme
	 A5J8UiyS4kVAO1WCtjw+eS1nySs/E4mq6A+N8MoyG8Ibvm2VJEoAkUYTslEHzsftPNL+O
	 RG/1J5YJQxtYb8zN+X3VnSxm866tJu3BbNp8YNe93q2l83mAvCqULiCwYCgcG6HTguw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oy/WLyph";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18342606A32E
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oy/WLyph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A22C1F00A09;
	Wed, 11 Nov 2026 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794412491;
	bh=nSe4OW8xhUxzc1SihiNGaIeSrpjr0BWrfZIJ2KCa3CA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oy/WLyph0h8j216TKYDpgqhQf7PO0I9w6+mmUFHnpckoJfGMOZps3GLQhs2FDMJfB
	 v5sSd0RyLYugEkZsbkC6gK5iLy2RhrAi2sIacxSpCFdA9jALt59HK5Nby4MB0ozy4L
	 XnZSZtEOf+a628v3O1mu5U9W3hcP7x8/vAz/uN2kxonElpogLx0dqn0x9DW+RfAlTt
	 qx+Km/8Xus9dKL7Mufz9A0a1D34KCLGK2+VPDOKRN1+8m9CI9pQuuWCAQrJMBk5zEk
	 4ouhgY/KMvT/Hrmf7GfaR0vo79AyXjKAMPRfBHLmBWwPN7K2AKYMA3vC8ek7kHvuvh
	 Sst41ugyWxKPg==
Message-ID: <sashiko-outbox-209233@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/6] firmware: qcom: scm: Drop exported ICE wrapper
 functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Eric Biggers" <ebiggers@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Abel
 Vesa" <abelvesa@kernel.org>, "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>, "Sumit
 Garg" <sumit.garg@oss.qualcomm.com>, "Selvam Sathappan Periakaruppan" <selvam.periakaruppan@oss.qualcomm.com>
Cc: "Basant Kumar" <basantk@qti.qualcomm.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-6-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-6-29d19f6c92ab@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 15:54:50 +0000
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
- [Low] firmware: qcom: scm: missing @dev in ICE helper kernel-doc
  comments
--

commit 7bfa90e5e53a6765c06df911105e2ee2369b3560
Author: Harshal Dev <harshal.dev@oss.qualcomm.com>

firmware: qcom: scm: Drop exported ICE wrapper functions

This commit removes the exported ICE wrapper functions from the SCM driver
and renames the internal static helpers now that the ICE driver uses the TZ
agnostic ICE APIs.

> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qco=
m_scm.c
> index 6b66bcedc84fd..277334f71178d 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
> @@ -1399,25 +1399,20 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_cli=
ent id, u32 offset, u32 size)
>  }
>  EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
> =20
> -bool __qcom_scm_ice_available(struct device *dev)
> -{
> -	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
> -					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
> -		__qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
> -					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
> -}
> -
>  /**
>   * qcom_scm_ice_available() - Is the ICE key programming interface avail=
able?
> + * @dev: The SCM device
>   *
>   * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key=
() and
>   *	   qcom_scm_ice_set_key() are available.
>   */
> -bool qcom_scm_ice_available(void)
> +static bool qcom_scm_ice_available(struct device *dev)
>  {
> -	return __qcom_scm_ice_available(__scm->dev);
> +	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
> +					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
> +		__qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
> +					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
>  }
> -EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
> =20
>  /**
>   * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
> @@ -1431,7 +1426,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
>   *
>   * Return: 0 on success; -errno on failure.
>   */
> -static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
> +static int qcom_scm_ice_invalidate_key(struct device *dev, u32 index)

[Severity: Low]
Should the kernel-doc comments for qcom_scm_ice_invalidate_key(),
qcom_scm_ice_set_key(), qcom_scm_derive_sw_secret(),
qcom_scm_generate_ice_key(), qcom_scm_prepare_ice_key(), and
qcom_scm_import_ice_key() also document @dev like qcom_scm_ice_available()
above?  Renaming these static helpers to match the preceding kernel-doc
blocks without documenting @dev causes W=3D1 kernel-doc warnings.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ice-migrat=
e-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com?part=3D6
