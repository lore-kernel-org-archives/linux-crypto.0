Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779997;
	b=2ASBT4ujYW6/N/2Uyo3+bf2CtKdM3ZtqhdYdZlnWXJhR28cZgdL1/78c273CHU7WrGDD
	 6KtT9T5DAKS0tvS/D094pTgoYG5qveakxActCYYtpmGgvGXYBZjsf8ISO4WVAyYrXKK48
	 4WKArkqfkNHNTR+Lgh/yIvfBc4zdMFl4cWsJhSf3Ho30WbgFkhUgEEvDkp9PLvVry6KLq
	 S6vWNeHx4o7BVl8ziMcmBpboGNLX2pgYmy5DsZ3Tf5Jlsu80fwwCnGPHHMbzLCTrcInEQ
	 twkxmSLyFOk5Es1+Twhxm9ixcwklrJUUfItUECvudBZex3HlcuibM+ZapKorfitq+Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779997;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bdJaCuRrck5XURNeDJ9hK44eiu7EkOclUMzEmjR9gPg=;
	b=ak+DfyKFKiHUm1UxS1avMZ6rzcwFBukjUhqD1aTXMq8viZ+/4Wu3bteq08qiuE4OVBd+
	 NPV1aNI5yGrbYPOAK5DiBl5pnzdT0mIjnkVlAKge9vOo1n3TqsvtYq0HVtDF+9xtSWrqB
	 JJ9zYdNn6dB5mG1H0sxwkki7G9Cs/so/jU1W7jxe8bDghPKhQ66EvJ2UFdiKKEKx8jmu7
	 ZwAg6DwFboAeCf6QvkB9jYWKQ2Eus+c1vH3vJELXtHqtBw3VX1Zh47vXm968c2H2gU3A8
	 Lin9s9znhZHwG+0n7/XRUhWw2erv8zie7cXu6sLISmr24r2vcdb3dCajjIPi9o7umdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=esasq0kU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A44B606A32C;
	Wed,  4 Nov 2026 08:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=esasq0kU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345441F00A02;
	Wed,  4 Nov 2026 08:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779996;
	bh=bdJaCuRrck5XURNeDJ9hK44eiu7EkOclUMzEmjR9gPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=esasq0kUdJ8TBKGIsocSdW9hgp35/Sz3SfYoG18RFZUS+dbK328U20UdVz9VTOM2S
	 97hF+FUycDdnSIPmeFIkTvAJkjC8fLpwh4/zheDSzMb+MFkPCjqqVfs3wgWPsx4xts
	 VOHUSRJwXz0SoWS5DkFQw8GYxyHd5lGqiJ0BGmAhXmB78zv8R/DjJCe3xZCO+lVWDQ
	 Y07CT5XTaRz+q2P75uPqCaQXv30mjvzYBADlzOUhJpFw/VVtJRBAskJzE0VvY0TrjR
	 QxlynUCF7MYcY9y7jqvB7Ma+AESEAiW75ClD35ysQ9k51cNQphQxhAVxqxV93TO7LZ
	 SCwEf+ZdG5U4A==
Message-ID: <sashiko-outbox-196863@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: ice: Document sm8150 inline
 crypto engine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Gigena" <mail@andrewgigena.dev>, "Abel Vesa" <abelvesa@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261104-sm8150-ice-rfc-v1-1-5737b6c2ecc0@andrewgigena.dev>
References: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v1-1-5737b6c2ecc0@andrewgigena.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 08:13:15 +0000
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
- [Medium] dt-bindings: crypto: ice: sm8150 standalone ICE conflicts with q=
com,ufs.yaml
- [Low] dt-bindings: crypto: ice: qcom,sm8150-inline-crypto-engine out of s=
ort order
--

commit 8ecc5836840659392f33486ed20f5aa5057a1a4c
Author: Andrew Gigena <mail@andrewgigena.dev>

dt-bindings: crypto: ice: Document sm8150 inline crypto engine

This commit documents the qcom,sm8150-inline-crypto-engine compatible string
in Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml.

> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-=
engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-e=
ngine.yaml
> index 23bf98c2b9fa0..1918f18fe8b10 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.=
yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.=
yaml
> @@ -23,6 +23,7 @@ properties:
>            - qcom,sa8775p-inline-crypto-engine
>            - qcom,sc7180-inline-crypto-engine
>            - qcom,sc7280-inline-crypto-engine
> +          - qcom,sm8150-inline-crypto-engine

[Severity: Medium]
Does adding a standalone ICE compatible for SM8150 conflict with the existi=
ng
qcom,sm8150-ufshc binding in Documentation/devicetree/bindings/ufs/qcom,ufs=
.yaml?

On SM8150, the inline crypto engine is associated with the UFS controller
(GCC only provides GCC_UFS_PHY_ICE_CORE_CLK, with no SDCC ICE clock in
include/dt-bindings/clock/qcom,gcc-sm8150.h).

In Documentation/devicetree/bindings/ufs/qcom,ufs.yaml, qcom,sm8150-ufshc is
defined as using the legacy embedded ICE representation:

    if:
      properties:
        compatible:
          contains:
            enum:
              - qcom,msm8996-ufshc
              - qcom,sdm845-ufshc
              - qcom,sm6350-ufshc
              - qcom,sm8150-ufshc
    then:
      properties:
        clocks:
          minItems: 9
          maxItems: 9
        clock-names:
          items:
            - const: core_clk
            ...
            - const: ice_core_clk
        reg:
          minItems: 2
        reg-names:
          items:
            - const: std
            - const: ice

In the same qcom,ufs.yaml schema, the conditional rule for nodes using the
standalone ICE binding via qcom,ice requires at most 1 reg entry and 8
clocks, which is mutually exclusive with the qcom,sm8150-ufshc constraints:

    if:
      required:
        - qcom,ice
    then:
      properties:
        clocks:
          maxItems: 8
        clock-names:
          maxItems: 8
        reg:
          maxItems: 1
        reg-names:
          maxItems: 1

When ufshc@1d84000 in arch/arm64/boot/dts/qcom/sm8150.dtsi is converted to a
standalone qcom,sm8150-inline-crypto-engine node referenced via qcom,ice and
the embedded ice register range and ice_core_clk are removed from the UFS
node, won't this fail dtbs_check against qcom,ufs.yaml and break Device Tree
ABI compatibility with existing kernels expecting the embedded ICE registers
and clock on qcom,sm8150-ufshc?

>            - qcom,shikra-inline-crypto-engine

[Severity: Low]
This isn't a bug, but the compatible enum in properties:compatible in
Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml is
sorted alphabetically. Should qcom,sm8150-inline-crypto-engine be placed
after qcom,shikra-inline-crypto-engine and before
qcom,sm8450-inline-crypto-engine?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-sm8150-ice=
-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev?part=3D1
