Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3B1E871;
	Mon, 26 Aug 2024 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724680235; cv=none; b=HOx6+vDKw4LQVzTjySfqqppJUx2824h2i83da+uDXIR2eMxosK8JPra9q4C1OZg/MPI/JofJ2LzdYJb7ICM2mUsYX+X7tkZrj5x9oPpvd3rvD8Vzhuc/nr4NTLJwTR+IkfaEf23m4FomDVh+PK0WnDf5U6+Zd+0xJV5/43xYAcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724680235; c=relaxed/simple;
	bh=048956Hz69VplOQW8TIX6foE8BvnSSaO5WdBcuYMZ9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpiOFLhP3N2Sibcz6qWX8NpwhYTSPIuxRGSxslXeX5pRNaUdRnYxFKdbSFYFMTsoGRNM8aGrLOQKx+BgudRetKqIEzjv5HYvTdMiO/JSDbR39EHJdrbi41bGSXUsj0/iJhBmqrcajisVptX0dcm68oEIchNXCUDj52WPBl+e2+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yq7SRW9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yq7SRW9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EB2C52FC7;
	Mon, 26 Aug 2024 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724680233;
	bh=048956Hz69VplOQW8TIX6foE8BvnSSaO5WdBcuYMZ9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yq7SRW9EcBKoGIL2P95KHrhwnlkRvqgFlUzzr7DM5u2r8244vaOSdNZoG61bFoRPC
	 hrCZSE8Z1s8q0BUMss7PMJBTmO6jig0fesc7seDjQJcFnbXkH7/hRgAcdfajxNonON
	 HQhStcPhBtU8xNQtw5FMsidSRS8rcPSVBcTDtZwi1+0KdW6JM3CWHWT5G84uLqm1uo
	 nSqr0V6p6R8Wkaxrr2WH3z4+YezLnmB07/i/n1CZTTWoVW2JdVuM1AsnePmYPMueBf
	 WlVVrIB4mkWIa8MSDfgkFI2+6dQUG6OUuJzn61wXo715pzHqIHtYWzI0Uwl9gX18BI
	 hBj3/0WedhfUg==
Date: Mon, 26 Aug 2024 08:50:31 -0500
From: Rob Herring <robh@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	khilman@baylibre.com, jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com, vadim.fedorenko@linux.dev,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com
Subject: Re: [PATCH v9 19/23] arch: arm64: dts: meson: gxl: correct crypto
 node definition
Message-ID: <20240826135031.GA55751-robh@kernel.org>
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
 <20240820145623.3500864-20-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820145623.3500864-20-avromanov@salutedevices.com>

On Tue, Aug 20, 2024 at 05:56:19PM +0300, Alexey Romanov wrote:
> GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
> Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
> engine is hard weired to clk81 (CLKID_CLK81). And remove clock-names
> field: according to the new dt-binding, it is no longer required.

Subject should be "arm64: dts: amlogic: ...". IIRC, Amlogic stuff has 
moved away from using "meson".

> 
> Also, GXL crypto IP isn't to seconnd interrput line. So we must
> remove it from dt-bindings.
> 
> Fixes: c4a0457eb858 ("ARM64: dts: amlogic: adds crypto hardware node")
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
> index 17bcfa4702e1..c29d5b81ce67 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
> @@ -68,10 +68,8 @@ acodec: audio-controller@c8832000 {
>  		crypto: crypto@c883e000 {
>  			compatible = "amlogic,gxl-crypto";
>  			reg = <0x0 0xc883e000 0x0 0x36>;
> -			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
> -				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
> -			clocks = <&clkc CLKID_BLKMV>;
> -			clock-names = "blkmv";
> +			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> +			clocks = <&clkc CLKID_CLK81>;
>  			status = "okay";
>  		};
>  	};
> -- 
> 2.34.1
> 
