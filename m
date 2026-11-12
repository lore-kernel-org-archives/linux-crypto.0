Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489365;
	b=AspLCbw48wFuJM4r6Fkign0jPhFVuG/0WGNARwXrwbBTQUUz+U89+u0Sw6PuD1c7IAC9
	 UA72BjyfWPovmLdSPN3iZRK2HLOoIZi0V2pUrfG/4Fiw3hyzPDWnaEiqo/y//+g2l2DF9
	 8fq00MQQYfAFR8/ZfdLHIFicFt26ZHd0+7suFBNTRirroLjtd8N9mik5+wKTelFiety6a
	 +vIdAapYRTjVsWaSXtfhHpRxGPELlMEfHr1kdMLtqFJbRHVqjPg6BHZD0mqlu+4n33uw0
	 QmOqygrn8OyJwnE8M1zHpUQsVtvlT5xG0i0aBVwHwJqxIy+DwReqVsjsp125upOXlyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489365;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yiP26pboFA81WdMuIKeQFHL8HikYYDh31zAm8N9+vWg=;
	b=pPK4t7w2Is9alomvgVLhMtdP0i9QLwqwM3aADJmBwd87a5QfMzdVrSwNMEVUZqfAqMRO
	 NILd3oqea6pI+VW0NB8ROQdsqyKRy4Em9KBSV2+qIWWvDT1Wke80WezC5pynFLMpl3RQK
	 4hPT4Eo/8rfnepU4WhRq9FgV3e+IVSye2BnsrNnLyMIlrywSpVjx5beNtte6aiOpcTbHu
	 IvuVdtHTGzocmqhWyX37yDTO4avd1EwblLXzXJ69F12nobXgISRRWuCj6dogokZP/Yu3N
	 8QlviCXN4WbrcK+1RzSFAnfuDKgB3XdVfONHn0JfWGiA+QJehtHqHeYBp/JX9eNHJjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tot+4AeN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4541F606A327;
	Thu, 12 Nov 2026 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tot+4AeN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B4A1F00A05;
	Thu, 12 Nov 2026 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794489364;
	bh=yiP26pboFA81WdMuIKeQFHL8HikYYDh31zAm8N9+vWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tot+4AeNfi+SZfvkAE+NatKaqkTaTRFO1l5g+S93MCupEgRX1zP9XnIUMa/fgQpQX
	 6G+/VzE7fv0leMfs7V4O7tPgqXhcBbc/ZAQwcW4EwfcAvfcb4prb7h3OXtz7aMcKAc
	 gfzE8MHy4P6s7eMnEwJqTOJsQLinOyMC2lCguWrlnLYKYDE8NcrlBUUYPsggjdymqf
	 3F/DqBdwEkAKRG/GgXMOiBQ0vuoMyDZRwu/p/hIZfnUaX6Vre1bi85nIt81nwz4uAf
	 R0Cx+ASc/bgRzfsg+ytShAt4Zb9hhkDwRdW6cYYsIUTJDIJ0QoBw2a0Hed4bg1f687
	 bwMY0pXDk3bQQ==
Message-ID: <sashiko-outbox-211156@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Bartosz Golaszewski" <brgl@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>
Cc: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, "Konrad
 Dybcio" <konrad.dybcio@oss.qualcomm.com>, "Wenjia Zhang" <wenjia.zhang@oss.qualcomm.com>
In-Reply-To: <20261112-shikra_qce_fix-v2-2-2ce112cc2ccf@oss.qualcomm.com>
References: <20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com>
 <20261112-shikra_qce_fix-v2-2-2ce112cc2ccf@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:16:03 +0000
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
- [Medium] arm64: dts: qcom: shikra: unexplained removal of QCE memory
  interconnect
--

commit accab4d6610b99099fcb37c8fbe0de4933119ef7
Author: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

arm64: dts: qcom: shikra: Correct QCE node configuration

This commit updates the fallback compatible string and replaces the memory
interconnect properties with the core clock in the Shikra QCE device tree
node.

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

[Severity: Medium]
Was the removal of interconnects and interconnect-names intentional here?

qce_crypto_probe() acquires both the core clock (qce->core) and the "memory"
interconnect path (qce->mem_path), and qce_runtime_resume() votes for
QCE_DEFAULT_MEM_BANDWIDTH on qce->mem_path alongside enabling qce->core.
Without the interconnect properties, the QCE driver no longer scales the
MASTER_CRYPTO_CORE0 to SLAVE_EBI_CH0 path during crypto transfers, and the
commit message does not mention removing it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-shikra_qce=
_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com?part=3D2
