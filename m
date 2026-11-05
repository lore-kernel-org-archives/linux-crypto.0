Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895094;
	b=ud2lOuf4Yi55lUDbottOKU7mYQJ2wObZV57QEJuTRcbajIh+5PAkxpB3RaNRyHAst01w
	 IvobGp6w7n/FRVcVYf5CsAp3g0MiSKa0nuxpOygrJeN9HLgIeMV8Qq0WWsAgekgNHpr+B
	 TeXKp8oMC+ZoFbzEK0Gn4vfg3Xys2QUmEFmA7n34OKdqAqHL5rrGslbKYw6UeECUnmvnw
	 zMYZEW2B97i9Bq+q8Kjj2fVY3CjGEBKJ2ferMGQg2d7ZgoLItOtJyGbdb19fofKybigGU
	 Hz18o58lboPuiqDm9ORcJBEQj5zh3RbaJsRjGPxuVPCVfJck9urjXcBOh3EmirRseUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895094;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ueGGPsMOAtJg+IZhamnuZ9QzV1Rb6CdLyKTnicrr4lQ=;
	b=I0csQkscDKY1Sf+mp6T3yN6R30KUU8xybeORFba6qWOdAOVxVmPFjhor22EIp736n1QQ
	 bGoPqbQ1HJCkLvJFtvPRvRAvXXevh+5MtfPH6IDfUjHLhGgQWt1Xt35VAHilk0DuppZge
	 AJRp403SirCVkpvCaX9WnjcFOSwpuYmE4Ls0ZCNPb2hIINlRH3jjk4UIz51rLkX10j96+
	 QGDCYNYNa8mNCkeOuSJTFsyg4l/keSKEq/AfpmdtdSZqhVDWxgm7id1YwtsqP/gcKsCg8
	 7NKRvkR3i/Zfb82HYJboa4c2ckOj64LMKT8uGy/9upsIVCyQa1Jmjg0UINaLZ7cRROw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkckW4nw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254FF606A31B;
	Thu,  5 Nov 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkckW4nw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFCC1F000C1;
	Thu,  5 Nov 2026 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793895094;
	bh=ueGGPsMOAtJg+IZhamnuZ9QzV1Rb6CdLyKTnicrr4lQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BkckW4nwTPl1OQ4+HdfHK5WnMp9yptpaGwwPKkNnzM3rhJURSrur49XMOwpL2CK4O
	 /bVYgDKX1MbqZM7H9Z38dO0LSLLoB4oZBIvKhmA/9oJBiXy34Nn92dlFvRLggpg8l8
	 x+cj5e/FdmK9LJlKPteiFPlS1Y9PrtH3mpc0cQJuG9D/QFRoi+GAK29RZgBSyoeUO9
	 F9WuUSV5mGNadlEr1DZTiCZGZuapWuSG9NPLEUiBSC6+T1b5BfJcuhHWyVPTv+3s8N
	 uKS3b9LYjJVhepu1RG5B6/Rjyv/6iDW81ohgv1YhX5BXk1PufKVo7mq48OwCftgMlL
	 HUk6DWKfX1I6A==
Message-ID: <sashiko-outbox-199445@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Demeter Barna" <me@fromdisposition.org>, "Abel Vesa" <abelvesa@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261105-b4-sm8350-ice-v1-2-f55e6ea8e1ca@fromdisposition.org>
References: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
 <20261105-b4-sm8350-ice-v1-2-f55e6ea8e1ca@fromdisposition.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:11:32 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] dt-bindings: crypto: qcom,inline-crypto-engine: inverted if-not =
condition for SM8350
- [Low] arm64: dts: qcom: sm8350: ICE reg size 0x11000 instead of 0x18000
--

commit da3fc875e05c7271bcc6b15fe532d10c5104a0b1
Author: Demeter Barna <me@fromdisposition.org>

arm64: dts: qcom: sm8350: Add the inline crypto engine

This commit adds the UFS inline crypto engine (ICE) device node at 0x1d88000
to the SM8350 device tree and links it to the UFS host controller via the
qcom,ice property.

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

[Severity: Medium]
In the accompanying binding commit 4bdcd3be438d ("dt-bindings: crypto:
qcom,inline-crypto-engine: Add SM8350"), the commit message states:

  Document the compatible and require the power domain and clock names
  for it, as for SM8450.

However, in Documentation/devicetree/bindings/crypto/qcom,inline-crypto-eng=
ine.yaml,
qcom,sm8350-inline-crypto-engine was added to the negated compatible enum
under allOf:

  # Do not extend the list.
  # Legacy SoCs are allowed for single clock.
  # New SoCs must provide both clocks and power domains.
  allOf:
    - if:
        not:
          properties:
            compatible:
              contains:
                enum:
                  ...
                  - qcom,sc7280-inline-crypto-engine
                  - qcom,sm8350-inline-crypto-engine
                  - qcom,sm8450-inline-crypto-engine
                  ...
      then:
        required:
          - power-domains
          - clock-names
        properties:
          clocks:
            minItems: 2
          clock-names:
            minItems: 2

Because that condition uses if: not: (introduced in commit 3360fa760425 to
exempt legacy SoCs), doesn't adding qcom,sm8350-inline-crypto-engine to that
enum exempt SM8350 from requiring power-domains, clock-names, and two clocks
during dtbs_check validation instead of requiring them?

> +			reg =3D <0 0x01d88000 0 0x11000>;

[Severity: Low]
Should the reg size in ice: crypto@1d88000 be 0x18000 instead of 0x11000?

When qcom_ice_probe() in drivers/soc/qcom/ice.c maps this resource via
devm_platform_ioremap_resource(), 0x11000 covers the 0x8000 ICE region plus
only 0x9000 bytes of the HWKM region from the downstream vendor device tree,
leaving the upper 0x7000 bytes of the 0x10000 HWKM block unmapped.

Other upstream Qualcomm SoCs with ICE v3.2.0+ and HWKM at 0x01d88000, such =
as
SC7280 in arch/arm64/boot/dts/qcom/kodiak.dtsi and SM8450 in
arch/arm64/boot/dts/qcom/sm8450.dtsi (as well as SM8550, SM8650, SM8750,
SA8775P, and QCS8300), use:

  reg =3D <0 0x01d88000 0 0x18000>;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-b4-sm8350-=
ice-v1-0-f55e6ea8e1ca@fromdisposition.org?part=3D2
