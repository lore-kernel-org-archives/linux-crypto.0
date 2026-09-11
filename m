Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A9826982C;
	Fri, 11 Sep 2026 06:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789107426; cv=none; b=c5ie2HOZtPf8Hxd8On6VgGyUCsaUiJW8GVDr6+dtFFyfSGMtjKXUNjGJdMOlm3PVROhffnUgFTDvalJ2jCmkzdPsq7mJonpefoqC9cu6bwHHJKOIKRw6R/srMDvi6FlFGSqZ1IMbDxD00UwZfWOyr2mURERA4Cpl99OLuTPzSU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789107426; c=relaxed/simple;
	bh=ts7gkvtDKZ+x1wHsvYBS9NbAWzo6fLziQrOLz9oQK+8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/MSis3UVB94eHUmD0DQ1NEZVHWQnLVKIJGy/D4uoPYhJ9X+Jugtn5KOCFZaytWeelF/o7l2HEZ/Uf84XBh+CTb7MIrUXkPRAyXtdn09WjgnqQqf7cQopHSLdjdFn3nQFdmPMP3HMMsN3bgDoFp8F2g4NWwFLbMr2CAWd+CbriE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=f4Ij8LH4; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="f4Ij8LH4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=lGj6tD8S75FkNAQospxrl1Av+QZr5tEfZgtcYlCahP8=; t=1789107425; x=1790317025; 
	b=f4Ij8LH4564DAF0BK/5ZUJNaxkpXqZfXxmOaovRqpm0Xal7JHY/4rkDrdM7u/ThrhzjK7lhVYhd
	57kajzcpYwLr4Rc72u7fMaAV/8V8VGvl+mOFSvB+RdlcHOcxzLgB6HMsRmDWWXon8opIJCiFA3Ksa
	SK0EovC7dTV1i0lXvuMNhakqI1O0vfntlyIC2b94gaMGjmLe4qogbqzxsk0V6fxTd8Gh4lQpFf/9M
	93bCrUNg0AI9CmrB8Iaa+UsBLO7h5FCYZXWQIg9NBjUN1mEMGS9IPWaNRXB401KqzE6SRoX3zozSS
	MovAF/0WzOmC55qFR1vcHP8AjweY8uUPQRFw==;
Date: Fri, 11 Sep 2026 08:15:47 +0200
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
Subject: Re: [PATCH 1/2] ARM: dts: ti: omap: dra7: Remove clocks from crypto
 nodes
Message-ID: <20260911081547.400ac521@kemnade.info>
In-Reply-To: <20260911-ti-dra7-omap-sham-fix-v1-1-c430f01b4e13@gmail.com>
References: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
	<20260911-ti-dra7-omap-sham-fix-v1-1-c430f01b4e13@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Sep 2026 03:41:57 +0530
Bhargav Joshi <j.bhargav.u@gmail.com> wrote:

> The omap-sham and omap-aes crypto drivers do not use "clocks" and
> "clock-names" properties. Clock management is handled by the ti-sysc
> interconnect parent wrapper. The dt-bindings for ti,omap-sham and
> ti,omap-aes don't define these clock properties. Having them in the
> child nodes causes dtbs_check warnings.
> 
> Remove the "clocks" and "clock-names" properties from the sham and aes
> nodes.
> 
> Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>

Reviewed-by: Andreas Kemnade <andreas@kemnade.info>

> ---
>  arch/arm/boot/dts/ti/omap/dra7.dtsi | 8 --------
>  1 file changed, 8 deletions(-)
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

