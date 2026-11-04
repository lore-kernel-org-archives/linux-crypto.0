Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779869;
	b=Kg0lnuS1IMacSi/T35p+XisQ7JvC5OVtOqDOUXOAmdMvsJ0E1BJhN9lBnEk/TCwcFhsC
	 /5E5im0eCdrSkaEYOr+EQyajFRXnKcazAWOP0JuhfB5ADnoQbR6UNMZ1miOeEBvbAkWf4
	 +yPBTwsEbdzFnyUTt4VLXn0bTmhjV44zvCUysusEAeItiruzBtwxtTyAPr6fXU+wM52Jf
	 bEGTiM5dg0WxU4qOhmHVOwDp+FH+UWwmyeUZYyQg1YNuRWbodkwaVKx/nB+EK/fsRRQmq
	 22Nv7H28DQ/lcNykHXDMK7/WUOk1k0pEqrsUvef4irXZ4eMsChYLS0CdipkAwoabYRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779869;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4KY+Fuiq+GYQrb6V/VfCQHGb8q0rg+tzhRKKwIWQwGw=;
	b=aU3TDWeHcoCzmEkXCllx9Yq2A+vQDqIxNScAQgC15k33jP/JBDX5yOo8YsKA550pw5dm
	 tLBp2toq+pOfgEb9SGRQt53TdpMwvEDly/b9bORoyFV6u4DatoOGjqNHuynzpoUxd4IoN
	 1tL7C0kd+PseHbJEiVJX+HGhx6nJEUo3G1SsI8o1yV2qGVPe1i1wmGST14kwZDlfo1MnS
	 m3Uw6cbo7VTRw7dXZXq9adg4JPyEgeQLeGZagqUq/4hDxE5i8SZKWce/nxnZWZGKEyyXm
	 04g+J5LuW2LiqNu4X/A1nTJqAxnOjRZMsdC1K/MY7gO+7BJ6IqvCFrscrUxm8sr0qOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMS9HsRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1A6606A329;
	Wed,  4 Nov 2026 08:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMS9HsRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAC61F000C1;
	Wed,  4 Nov 2026 08:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779868;
	bh=4KY+Fuiq+GYQrb6V/VfCQHGb8q0rg+tzhRKKwIWQwGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eMS9HsRBy7rj+CCF/fKwXB6sfgwftmuo/rgpmp7bene/SfCsS4+CgB4PStBt07G/v
	 zLBLgfz8rzIRtv5EdSTh9ydr9xiRNJCpKMNKMXrauKNef/hbHPbo3XAa4aZ1NVFXzK
	 Iofg2X7CxRZqQwK+3of/eC/MbfP4hc2foMOu0w6pxo6aVDsJ9V3vcTj1RvkiI2+tD0
	 5AMsKa/Hmt7IsLX1XB9ypxc98vsccE4/wg3GTWON6SgDS+jEBpMJ6ZPjBbvHzEZU/n
	 EZdKBudg+axXUnoq9/7Xq9w7zS6KI8y+BJ1+qoIPhJN2xnsH4SjNMZNP0UwAbl1LIN
	 3ZCcqo89Va8Ow==
Message-ID: <sashiko-outbox-196860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Gigena" <mail@andrewgigena.dev>, "Abel Vesa" <abelvesa@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261104-sm8150-ice-rfc-v1-2-5737b6c2ecc0@andrewgigena.dev>
References: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v1-2-5737b6c2ecc0@andrewgigena.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 08:11:02 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] arm64: dts: qcom: sm8150: ufs_mem_hc violates qcom,ufs.yaml schema
--

commit 44282b2e2d420ebb8b4be7b6dd11cd5ecade575e
Author: Andrew Gigena <mail@andrewgigena.dev>

arm64: dts: qcom: sm8150: Use standalone ICE node for UFS

This commit converts the SM8150 UFS controller node to use a standalone
Inline Crypto Engine (ICE) node referenced via the qcom,ice property,
moving the ICE register region and clock out of ufs_mem_hc.

> diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/q=
com/sm8150.dtsi
> index 293fcbacff346..b3d6f3d923950 100644
> --- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> @@ -2071,9 +2071,7 @@ pcie1_phy: phy@1c0e000 {
>  		ufs_mem_hc: ufshc@1d84000 {
>  			compatible =3D "qcom,sm8150-ufshc", "qcom,ufshc",
>  				     "jedec,ufs-2.0";
> -			reg =3D <0 0x01d84000 0 0x2500>,
> -			      <0 0x01d90000 0 0x8000>;
> -			reg-names =3D "std", "ice";
> +			reg =3D <0 0x01d84000 0 0x2500>;
>  			interrupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
>  			phys =3D <&ufs_mem_phy>;
>  			phy-names =3D "ufsphy";
> @@ -2092,8 +2090,7 @@ ufs_mem_hc: ufshc@1d84000 {
>  				"ref_clk",
>  				"tx_lane0_sync_clk",
>  				"rx_lane0_sync_clk",
> -				"rx_lane1_sync_clk",
> -				"ice_core_clk";
> +				"rx_lane1_sync_clk";
>  			clocks =3D
>  				<&gcc GCC_UFS_PHY_AXI_CLK>,
>  				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> @@ -2102,8 +2099,7 @@ ufs_mem_hc: ufshc@1d84000 {
>  				<&rpmhcc RPMH_CXO_CLK>,
>  				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>  				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
> -				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
> -				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
> +				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
>  			freq-table-hz =3D
>  				<37500000 300000000>,
>  				<0 0>,
> @@ -2112,8 +2108,8 @@ ufs_mem_hc: ufshc@1d84000 {
>  				<0 0>,
>  				<0 0>,
>  				<0 0>,
> -				<0 0>,
> -				<0 300000000>;
> +				<0 0>;
> +			qcom,ice =3D <&ice>;

[Severity: Low]
Does converting ufs_mem_hc here without updating the devicetree binding
cause dtbs_check failures on SM8150 and SA8155P boards?

In Documentation/devicetree/bindings/ufs/qcom,ufs.yaml, the allOf entry
matching qcom,sm8150-ufshc still requires 9 clocks (including
ice_core_clk), 2 reg entries, and reg-names:

  - if:
      properties:
        compatible:
          contains:
            enum:
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
            ...
            - const: ice_core_clk
        reg:
          minItems: 2
        reg-names:
          minItems: 2
      required:
        - reg-names

Meanwhile, the rule for qcom,ice in the same binding requires maxItems: 1
for reg and maxItems: 8 for clocks, which conflicts with the
qcom,sm8150-ufshc constraints above.

Should qcom,sm8150-ufshc be updated in the UFS binding schema (for example,
moved to Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
alongside qcom,sm8250-ufshc and qcom,sm8450-ufshc) before or along with
this change?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-sm8150-ice=
-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev?part=3D2
