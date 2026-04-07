Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A30A30C61B;
	Tue,  7 Apr 2026 19:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775590439; cv=none; b=oDIsKGZ7pr5JGCiXAF2lXJDfFz6gHJwQd4tBDg6ePbfhclh0eqOWwIkgXHiK1MTFYV8eemXA6BeOmidFxhi+CkS4Q9aiFtE3VM3A+tORIEOY6ppgU7CXksQT0n0fwM9EbnHRRXiyQLABBOET4AXHpZWDUf2kHeSNVzfSAuqYvHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775590439; c=relaxed/simple;
	bh=+VjAbOhrU4zSzvQ97yDAQ8yIuYHE6jTCE7CNjVM7FSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISSssZOKzAqbfvHXpw27tNwCQKH0PE8QSXg8H6igL7ie/GCWWj1uMHHLuQ+neXtsgllHsHC7WFAX/uauz9BVP9NrEaNE0ds70IJGifQUJK/RTB7k0UeSKtLEi4Qu5j1tQNN7ialMUQ3U2e8qzqAFEW9bqHPjS8sUCQVEH5U3ltc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gi8PAVZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gi8PAVZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EE6C116C6;
	Tue,  7 Apr 2026 19:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775590438;
	bh=+VjAbOhrU4zSzvQ97yDAQ8yIuYHE6jTCE7CNjVM7FSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gi8PAVZkL4brMY9NBpojQJyGAnXgJD4K9J9V2pL+i9irvsLGwsuxCNwkOwIgoyW78
	 PrQ6KXYHcA40gvAtXaDVZXglOl2mMvEA1QNcD8ndYWC2QAtyMCA/dGz7ZdVpWsbKtR
	 +ECgYLmeWnNveWs+HRXnfe10R+AH07bVPdXXtaJsL2gMKHnI9S/X4PIsNMS02MkcS9
	 K8fcqS4LXAcLQsJuGm0AleTAeHtxxB8vtrnZFb6Kbzr49lDx0571/eFxiiBi3/m1Gh
	 PECk0DcF9g5tP7EWIQ2fDVnLV8vdFxFDD4iTZ77/gchX+fUxIYVc6K6pw/fnZSvige
	 NRpgatw2yhR+w==
Date: Tue, 7 Apr 2026 14:33:56 -0500
From: Rob Herring <robh@kernel.org>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 16/16] ARM: dts: renesas: r9a06g032: Describe the EIP-150
 block
Message-ID: <20260407193356.GB3531350-robh@kernel.org>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-16-5e6ff7853994@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-16-5e6ff7853994@bootlin.com>

On Fri, Mar 27, 2026 at 09:09:38PM +0100, Miquel Raynal (Schneider Electric) wrote:
> The EIP-150 is composed of 3 blocks:
> * An interrupt controller named EIP-201 AIC
>     - fed by a clock coming from the EIP-150
>     - connected to the main GIC
> * A random number generator named EIP-76
>     - fed by a clock coming from the EIP-150
>     - signalling interrupts through the AIC
> * A public key accelerator engine named EIP-28
>     - Fed by a clock coming from the EIP-150
>     - Signalling interrupts through the AIC
> 
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
> ---
>  arch/arm/boot/dts/renesas/r9a06g032.dtsi | 42 ++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/renesas/r9a06g032.dtsi b/arch/arm/boot/dts/renesas/r9a06g032.dtsi
> index f4f760aff28b..6aaa93ed03d6 100644
> --- a/arch/arm/boot/dts/renesas/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/renesas/r9a06g032.dtsi
> @@ -8,6 +8,7 @@
>  
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> +#include <dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h>
>  
>  / {
>  	compatible = "renesas,r9a06g032";
> @@ -170,6 +171,47 @@ usb@2,0 {
>  			};
>  		};
>  
> +		eip150: bus@40040000 {
> +			compatible = "inside-secure,safexcel-eip150", "simple-pm-bus";
> +			clocks = <&sysctrl R9A06G032_HCLK_CRYPTO_EIP150>;
> +			#clock-cells = <0>;
> +			clock-map = <&sysctrl R9A06G032_HCLK_CRYPTO_EIP150>;

I don't get why you need clock-map here. Why can't you just put this 
clock in each child node?

Rob
