Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C140E8D7;
	Fri, 18 Sep 2026 12:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735387; cv=none; b=JNEmaYZZAj/93SGveL4SL3aAclkZoJ0UTipeCs3Fw319RPowfCHDDscvuAqd8f19ecbqPp5pMzz6yAsi3pHOdFgEGP51qo+2xXkfLMIOP7I0RBTMCyZKL/sE9L/sYROHUftoFA/JYH9tKm6LEc2JRaq0+efPEbxS8Q0hojiP1TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735387; c=relaxed/simple;
	bh=9Fd/IauTwv+I6tcxCZAWmJnRH9cM8SdbYJ9ZjQhDMG8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JxMvsXuRMoKWEbZ6gTDyFSZJwPGETJCRs/GvzIfdZvkfzszq+NAVtO9aJCoEzGxGAiNR80aP8kBH6mauUoV4zeCsnDOUQLgHny4m+hdddaguoqpPabDKZ0sO/ZvHf2n+Ug1aSWcIcTdMIk8+BISxLhVKc0W4/mYGUidbxIVSryA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=CIzVClh0; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="CIzVClh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=yEhZos8eYIYEnu9oeamuw66fgjpYm7R1b5iyPaCotIM=; t=1789735382; x=1790944982; 
	b=CIzVClh0L0XK+So/X9y3As2vmU+8Aqoi2T0PEDG58uSnF1wOtkl9qdHDNxVCJimV7xyIn90ACtr
	Qsb+PVKwa+1QphekFLP1Kd1lQ/YwbwxpbwsayiVN9Ri5U5/BWERi5JocIqIn+Gwg4OHmDw/kerByt
	eGOmo8yJyiRy1NyNrerO4MDKRgXQR73da46VSEwaMmxccV8nrSmrlCqaS4m4JBoxm4Yyz282YRfeC
	+YSch30d6IlaHX3yPlYPNLAqsKPRrzk2vpzCBooy6ThKLe9twCxaotvHaETrbrTjqY+oKzyAvipVR
	nH5s1AbDwb30foVjAA3iqKCGHE8Lh1EmXI2Q==;
Date: Fri, 18 Sep 2026 14:42:24 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Bhargav Joshi <j.bhargav.u@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Kevin Hilman
 <khilman@baylibre.com>, Roger Quadros <rogerq@kernel.org>, Tony Lindgren
 <tony@atomide.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ARM: dts: ti: omap: dra7: Remove clocks from
 crypto nodes
Message-ID: <20260918144224.4dfb8515@kemnade.info>
In-Reply-To: <20260916-ti-dra7-omap-sham-fix-v2-2-4eadb60081e5@gmail.com>
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
	<20260916-ti-dra7-omap-sham-fix-v2-2-4eadb60081e5@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Sep 2026 02:29:39 +0530
Bhargav Joshi <j.bhargav.u@gmail.com> wrote:

> The omap-sham, omap4-des and omap2-aes crypto drivers do not use
> "clocks" and "clock-names" properties. Clock management is handled by
> the ti-sysc interconnect parent wrapper. The dt-bindings for
> ti,omap-sham and ti,omap-aes don't define these clock properties. Having
> them in the child nodes causes dtbs_check warnings.
> 
> Remove the "clocks" and "clock-names" properties from the sham, des and
> aes nodes.
> 
> Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
> Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>

I was a bit too fast here, clocks here are different from what is
used in the ti-sysc block. So some more thought and argumenting is needed.

Regards,
Andreas

> ---
>  arch/arm/boot/dts/ti/omap/dra7-l4.dtsi | 2 --
>  arch/arm/boot/dts/ti/omap/dra7.dtsi    | 8 --------
>  2 files changed, 10 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi b/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
> index a595745afe59..bca035fd7e62 100644
> --- a/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
> +++ b/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
> @@ -2086,8 +2086,6 @@ des: des@0 {
>  				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
>  				dmas = <&sdma_xbar 117>, <&sdma_xbar 116>;
>  				dma-names = "tx", "rx";
> -				clocks = <&l3_iclk_div>;
> -				clock-names = "fck";
>  			};
>  		};
>  
> diff --git a/arch/arm/boot/dts/ti/omap/dra7.dtsi b/arch/arm/boot/dts/ti/omap/dra7.dtsi
> index 711ce4c31bb1..0784c6d9cbe4 100644
> --- a/arch/arm/boot/dts/ti/omap/dra7.dtsi
> +++ b/arch/arm/boot/dts/ti/omap/dra7.dtsi
> @@ -1012,8 +1012,6 @@ aes1: aes@0 {
>  				interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>  				dmas = <&edma_xbar 111 0>, <&edma_xbar 110 0>;
>  				dma-names = "tx", "rx";
> -				clocks = <&l3_iclk_div>;
> -				clock-names = "fck";
>  			};
>  		};
>  
> @@ -1043,8 +1041,6 @@ aes2: aes@0 {
>  				interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
>  				dmas = <&edma_xbar 114 0>, <&edma_xbar 113 0>;
>  				dma-names = "tx", "rx";
> -				clocks = <&l3_iclk_div>;
> -				clock-names = "fck";
>  			};
>  		};
>  
> @@ -1073,8 +1069,6 @@ sham1: sham@0 {
>  				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
>  				dmas = <&edma_xbar 119 0>;
>  				dma-names = "rx";
> -				clocks = <&l3_iclk_div>;
> -				clock-names = "fck";
>  			};
>  		};
>  
> @@ -1103,8 +1097,6 @@ sham2: sham@0 {
>  				interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>;
>  				dmas = <&edma_xbar 165 0>;
>  				dma-names = "rx";
> -				clocks = <&l3_iclk_div>;
> -				clock-names = "fck";
>  			};
>  		};
>  
> 

