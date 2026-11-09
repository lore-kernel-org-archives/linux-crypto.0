Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233393;
	b=PJK5PsQFrtByyEHYtG7Ts38J7rNjlsmEixYgJynWMUyf2dq2UTYuHdsGDt9sMkIg+XHJ
	 GJr+b4oBkT9SNfAex+omPLJ0ViqI/TpsW6DBLbICShbyB1dUyEiHLN/r3D/HwWmU8/ieq
	 yQQl7VaD+SkP4rsbc5p8AzukYct7ciVEKMbsSgdHRSdF8Ojz1LLs0DO9ubbNqkMNC53VO
	 OJEhthaZ5qGcxUC1H3VqAibApXDrxOB1nj/kRqwzB7ipQoJg4s+y9+1cx2TCYw244gyi7
	 dIUgkc+IQnvfsCMw7CaXYWLAho+DaBniKdcCXeGXKrqv+Lnd7SEWNmLGJjS5C8ysgcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233393;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ymLVNQH4aRnaJdm4Uc2RFK8LkpmRaWArAoVU8rsSZvY=;
	b=bzjRitfO+M7lX/q02afBXLZYHazQdCi3TXkPQE3sRul3FyqTOhXYpQwcmaUailqHqTjf
	 Vq2ZCQy1HFH+ERbXDwoQDVKV+oLc75oeF1A62BJ/Dyxrxiy5DTCNGiMuHO8OFzYgSSNiN
	 5bvshT/J/Cfqn/vX+v7svIse1S47DDjjwU2UOiESrjb7VD+AfNhfHuTi3QVU6H2ftDV6s
	 2qnEVTxtRR2tFur0WoKkbhUbHRIyimy2FCgTkO2syzQlLQ9L/EvmAg29WU3lTQZQkRJ4L
	 9S/S3JAlrm6dbiXpfuL/ixVPWh8fKRSJwl4WQFbSyxZiQfd8TLyvyBNH6oTCRixKTRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cftk5GHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9533D606A32A;
	Mon,  9 Nov 2026 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cftk5GHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F6B1F0089F;
	Mon,  9 Nov 2026 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794233393;
	bh=ymLVNQH4aRnaJdm4Uc2RFK8LkpmRaWArAoVU8rsSZvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cftk5GHhphe++buNVL3FitpLXPEtVwgvyU2yN5q9erVMAJ7ug87E33a3PVr2YLDs1
	 Wbim4JmZb9PuaRe9sWguYhplnHe7VYbea96aBwpUTGu8PuTGloDCKnAieBYCR0xIaN
	 UaKJU1iZXZKPhv2IFKZWs5oY9SYKcP17RWw/uku31A5PuH+c9ERU9TwZf4kntfcDV0
	 wbz52WoBwCNmcwTp7W9K1T/e/A7/HSiC56m+oYMWGfPwOhz1EfTQTkUId+CKzvTGl0
	 I9OUlrSy2HoQUtWVgOVujzr+ugcQ4U4q1FEZ2QA9WlJKXCrnq5vnqfirv/eF5hnxH5
	 2fnq/VxrGhTzg==
Message-ID: <sashiko-outbox-205061@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Demeter Barna" <me@fromdisposition.org>, "Abel Vesa" <abelvesa@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
References: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
 <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:09:52 +0000
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
- [Low] arm64: dts: qcom: sm8350: ICE reg size 0x11000 instead of
  0x18000
--

commit b6d71a017150b9b7aef8d2a54ca324fd569ec504
Author: Demeter Barna <me@fromdisposition.org>

arm64: dts: qcom: sm8350: Add the inline crypto engine

This commit adds the UFS inline crypto engine (ICE) device node to the
SM8350 device tree and links it from the UFS host controller node via
qcom,ice.

> diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/q=
com/sm8350.dtsi
> index 55b32050ce9c8..2b258c4b4fa71 100644
> --- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi

[ ... ]

> @@ -1807,6 +1809,17 @@ ufs_mem_phy: phy@1d87000 {
>  			status =3D "disabled";
>  		};
> =20
> +		ice: crypto@1d88000 {
> +			compatible =3D "qcom,sm8350-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg =3D <0 0x01d88000 0 0x11000>;

[Severity: Low]
Should the ICE register region size be 0x18000 (0x8000 for ICE + 0x10000
for HWKM) instead of 0x11000?

Other Qualcomm SoCs with ICE v3.2.0+ and HWKM at 0x01d88000 define this
aperture as 0x18000, including Kodiak in fa9c7403af64 ("arm64: dts: qcom:
kodiak: Fix ICE reg size") and SM8450 in 7fb3d0512dac ("arm64: dts: qcom:
sm8450: Fix ICE reg size").  While drivers/soc/qcom/ice.c currently
accesses up to offset 0xd010 (QCOM_ICE_REG_HWKM_BANK0_BBAC_4), mapping
only 0x11000 leaves the upper 0x7000 bytes of the HWKM register space
unmapped.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-b4-sm8350-=
ice-v2-0-fd5e84985e90@fromdisposition.org?part=3D2
