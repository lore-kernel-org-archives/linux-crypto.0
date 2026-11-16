Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821166;
	b=QUUXP2MF3yDAMAa5PsgtrXDTpQrn4lw9fKK3i0NNeTquqRR5AUSzj4x8NG3W7ltI7y7L
	 3jdp2SPyFvo6v1w45AaYSSKP2RH158d7Z2l0/zqXoQjVnoR/9ygcYvVVE/vwE/Yhis7Xe
	 ibD8BhG1ylGNOrNfQKIlEsLak2iduPyBG+GzgdWc8Z7o60pWOgFw6FyyMATzbx3usd+lw
	 qERrMkPGII1WAa+M7sxESnD21Au74B91gNEB5mgDEKH3JuBUx8/iNpuWttpfFAdarXwFh
	 6BCc/AZVyZngURfw2U6U+n/qk8PZDX0T+9ui9pqUBLlwxVlLYKgMXum5NsKO2huOVUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pPBIOOwg0rkAE9qGLzT498Wru3LA3lOrjfmo2q4HlZk=;
	b=hDBc4YfSgiHWwTH8eFTZQN6vsZIrmNYCBfo/r30D3GJHjCZH4mNYOa7IEADct5NrvFlj
	 bt5LqjTTVCX19ujJrmCKU5seUYabf4Ig0joEU+SyQmrryDkIckB57E5IYdYM8hnT8cvVP
	 q+hQi/vmhlsTkbS6tVzpx0XO4zHDOHJKZJlebKslw7vFZM7BKGBg7nvPRGU73+2b21Joi
	 G23oeQVzpvzYRE1q4awINcChrShevQyw8qQPmhx/DFy/7wNGmc5drz19uDM25PZw2xxvO
	 GhE5GFSdMQD7yBaTrciM0Fne+bUkeHEw8OaCs5r50srfPL23br/DnZNbmocENksyPfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HX8Ur6t1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D953E606A31C;
	Mon, 16 Nov 2026 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HX8Ur6t1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF131F000C9;
	Mon, 16 Nov 2026 09:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794821166;
	bh=pPBIOOwg0rkAE9qGLzT498Wru3LA3lOrjfmo2q4HlZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HX8Ur6t1U2fhyfO1DIWB/bSt+1AdAoWDIUoSUbU6F3FRyW5iOOYpkUAzcbdRmTog3
	 bx0Bsy+yTeHiB/xVRG5hLYtrD4lRSwJJhV1+xYctqoQYcziK+vPpMJevooa1QJkpoQ
	 ZZtFzdby2OVPWzVOeHE/UebFKl3KAAvAmuj+Rgaj2W4qSgk7M1NrtDkSghXLPxZII3
	 99tRigAdu5nRmex7hBsr4Fe9/y4BI10EqrZd8yvFqdqWX26q5U+6RZ/LEAfN1m9Cqe
	 hj+TC50Yu+Q3KNEoE5Y0po4MixCJ7Cwu7+UQswGj7LufLWwU+X6vTusGcA5VIdOQHT
	 toQSycTXYx0GQ==
Message-ID: <sashiko-outbox-216611@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Bartosz Golaszewski" <brgl@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>
Cc: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, "Konrad
 Dybcio" <konrad.dybcio@oss.qualcomm.com>, "Wenjia Zhang" <wenjia.zhang@oss.qualcomm.com>
In-Reply-To: <20261116-shikra_qce_fix-v3-2-9ae31470ef48@oss.qualcomm.com>
References: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
 <20261116-shikra_qce_fix-v3-2-9ae31470ef48@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 09:26:03 +0000
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
- [Medium] arm64: dts: qcom: shikra: removal of QCE memory interconnect
  path
--

commit dd0d4eb9c6460c2234e0ce40f58aef857431e597
Author: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

arm64: dts: qcom: shikra: Correct QCE node configuration

This commit updates the Shikra QCE node fallback compatible string to
"qcom,ipq4019-qce", adds the "core" clock, and removes the "memory"
interconnect properties.

> diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/q=
com/shikra.dtsi
> index 0a95ad5a5582c..d5f0ef863173e 100644
> --- a/arch/arm64/boot/dts/qcom/shikra.dtsi
> +++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
> @@ -1208,7 +1208,7 @@ cryptobam: dma-controller@1b04000 {
>  		};
> =20
>  		crypto: crypto@1b3a000 {
> -			compatible =3D "qcom,shikra-qce", "qcom,sm8150-qce", "qcom,qce";
> +			compatible =3D "qcom,shikra-qce", "qcom,ipq4019-qce", "qcom,qce";
>  			reg =3D <0x0 0x01b3a000 0x0 0x6000>;
>  			dmas =3D <&cryptobam 4>, <&cryptobam 5>;
>  			dma-names =3D "rx", "tx";
> @@ -1219,9 +1219,8 @@ crypto: crypto@1b3a000 {
>  				 <&apps_smmu 0x96 0x0011>,
>  				 <&apps_smmu 0x98 0x0001>,
>  				 <&apps_smmu 0x9f 0x0>;
> -			interconnects =3D <&system_noc MASTER_CRYPTO_CORE0 0
> -					 &mc_virt SLAVE_EBI_CH0 0>;
> -			interconnect-names =3D "memory";
> +			clocks =3D <&rpmcc RPM_SMD_CE1_CLK>;
> +			clock-names =3D "core";
>  		};
> =20
>  		qfprom: efuse@1b44000 {

[Severity: Medium]
Does removing the "memory" interconnect from the crypto node leave QCE
without an interconnect bandwidth vote during crypto DMA transfers?

In drivers/firmware/qcom/qcom_scm.c, qcom_scm_bw_enable() votes on the
SCM node's interconnect path only for the duration of PAS SMC calls and
qcom_scm_bw_disable() drops that vote back to 0 as soon as each call
returns, just as it does for RPM_SMD_CE1_CLK.  Without the "memory"
interconnect property on the crypto node, devm_of_icc_get(dev, "memory")
in qce_crypto_probe() returns NULL, so qce_runtime_resume() never votes
for QCE_DEFAULT_MEM_BANDWIDTH while QCE is active.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-shikra_qce=
_fix-v3-0-9ae31470ef48@oss.qualcomm.com?part=3D2
