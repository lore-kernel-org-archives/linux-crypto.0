Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795204343;
	b=WvwIUnlvWU5vs6nPuTXLhiNOXHyma73p9XViqa9Eite9cYKGiJ6VheLlH+izYihG8w+k
	 c8r8j2IaUA+PatLJnmMNAr9wU6Wil2K/SbhTeX8TfKSIt/IChqZzqlgUmSZys/2G9wfdZ
	 ZfMFxwZ026D7ry1/lUXt3RCnkYNdlxdr5/O6mG9gVkONjRbwSIU/Ox8zmRjLvva9MPpDE
	 jh4bNOv8C1fvtQatb2DfRgXM9QcyxiUaDgZ2Cr2jF2I1moZEN7V+ANuFc3mQxfDM3g67V
	 h3tnOd238XCf+Nxnb99ZYHU0ceLvKegkcljyPyT/JQDo/VyJhwGyvRKfScVVEk3YOxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204343;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XxJsNtpTOv3BQRcOTmsjMpsRIvtl0qjRD5mX3/ihrPI=;
	b=PuHF0dAWUn3sIIQ5jLyq66aHuSlHloDCtf5e6w38vai6s3BE9EqFbkLSUMK34o8prFfj
	 dsIlPZy5Xm8VfQtHZnYXmSFsv44n4zJChzNMiAWV7iQDtwhR5zxH+KJCjWnRcyyhvYcUh
	 kMo8e2e7eHD88HOhHwnOrBAeN0ePRsxmlJUCOUhYm3oLVDGbhbUgM/ofp+ZE1Tr8GpzUp
	 YpNX96jQViopyQxH/QxMPqNYIXrUALD1V/E6XfXpxZ7ZevUtl3wLrd7fw2qcrwLY7Wm0a
	 yW+b8CODu/PIbL4EWcAZVjorVmFS0n2x2hJcTubJqq7/pxOoVwPIzodnbKXRTAxDD+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CnX03Nb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41089606A6DA
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CnX03Nb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4051F000C0;
	Fri, 20 Nov 2026 19:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795204342;
	bh=XxJsNtpTOv3BQRcOTmsjMpsRIvtl0qjRD5mX3/ihrPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CnX03Nb+d0KPahNY/iXf/f/RuzDLY+lbkskRf+jVtdoTl6loFru7jmM9HwyEQfci0
	 Lg0+CyiGQCGICkSSQNgO1iJi5B0xv3kGL1Xgl0RmItgfc3YmKo7Z4B87+7/z3cmYOF
	 EpVlagLVRD7SYOes3xw9JUskNRebg9pv2odw4Dd9lRJS8AHbxYFCnk1brLhgo7YvjX
	 wBPDJc7DKkQjw+dFBOubjJPzC3Gqt/PYpUXJsaAQTMHRm3UxmM8LKWfx+y/riMrZ1d
	 XcIijH0jq48WaM4PC/V5moSMQtYWk9klnhzWX09BstFZtJ2YXHSSKMSVxVGxiW8Md6
	 dt5RH8UKNTAyQ==
Message-ID: <sashiko-outbox-225968@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 2/4] soc: qcom: add core driver for the Qualcomm
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
In-Reply-To: <20261120-qce-fix-self-tests-v12-2-b5a2a44bc5ae@oss.qualcomm.com>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
 <20261120-qce-fix-self-tests-v12-2-b5a2a44bc5ae@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 19:52:21 +0000
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
- [Medium] soc: qcom: missing Kconfig dependency and default for
  QCOM_CRYPTO_CORE
--

commit 102209faf0f22bae7835821ad72826313dbef2e2
Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

soc: qcom: add core driver for the Qualcomm Crypto Engine

This commit adds the core platform driver for the Qualcomm Crypto Engine
to bind to the QCE devicetree node, manage interconnect scaling via
runtime PM, and register the crypto auxiliary device.

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

[Severity: Medium]
Should QCOM_CRYPTO_CORE have a default (or be depended on or selected by
CRYPTO_DEV_QCE) so that existing configs with CONFIG_CRYPTO_DEV_QCE
enabled keep working after commit "crypto: qce - convert to auxiliary
bus"?

Without a default or a dependency from CRYPTO_DEV_QCE, updating an
existing config leaves CONFIG_QCOM_CRYPTO_CORE disabled, so nothing
binds to the QCE devicetree node or creates the qce.crypto auxiliary
device that the crypto driver now binds to.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-qce-fix-se=
lf-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com?part=3D2
