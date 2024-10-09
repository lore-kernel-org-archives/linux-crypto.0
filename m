Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65C92119;
	Wed,  9 Oct 2024 21:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509042; cv=none; b=e4rkCq29IC2A3qjOSOZNf2LdURt1YdaGwIqyXy+KRPDD8+WDrk5KFNbIbVtNQrYJUDy5bC1m21eB1+i+WxD+TaFroneVGZ84uoBFLGPfqhzFPQKiyaO66kBz2RBqY8wJ+TrsotRMy+NyalLdAwl5H1MlavKdqCvBwcrpPwdM884=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509042; c=relaxed/simple;
	bh=BjEvB7skkEeR6d+4kVsgommqWcL5Ch3q5u9TPLPNrVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRyXa7crIblvma0dSg/ogtL5RNKPILMTd2CXBlz4KICqR+pHa5YEzPA8qZco5Ikuug9nRTz8IENNGi1VrR4S/aHAEcCt6mYY75XC9rYWAm/MrvtMMRHZfAaKQnN1OV9i4ALse9yd4CDdyRcq5+6+tVNpQMX+5cCUsy3YWsKNmuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqrAB98l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqrAB98l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1E5C4CEC3;
	Wed,  9 Oct 2024 21:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728509041;
	bh=BjEvB7skkEeR6d+4kVsgommqWcL5Ch3q5u9TPLPNrVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pqrAB98leIdj82zuYYUEUn+3JmIzM8kOG1niL8LYQxL1P8up1LKWsv25+F2mTPaMt
	 F1lqhqogyrlVqBDReczONoUt/GCXcetIUCLRqe1Bsx2WR860+jfxcPkgqiynGV7LUq
	 8uM7NUK0eaHIvbR4M+uDmmdsGU1aM0yo9o087NYG/B/+BBwSWDkDyOXYoQR+AnktEa
	 /8ITYjZTYcMh0/mCLuuZriL8zfXHa7cjwUMNh5ykhfk7/kf5mK94QiNyAipzuQpnzr
	 jsLiVy++8UETOmfboawJBPJPGdJ6sQB1HajdxptNbCqH9aa2OEiuIgRYPsrX78Ie4E
	 JScIBdRUDWdtA==
Date: Wed, 9 Oct 2024 16:24:00 -0500
From: Rob Herring <robh@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto
 engine
Message-ID: <20241009212400.GA735586-robh@kernel.org>
References: <20241009171223.12695-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009171223.12695-1-ansuelsmth@gmail.com>

On Wed, Oct 09, 2024 at 07:12:20PM +0200, Christian Marangi wrote:
> Add bindings for the Mediatek EIP-93 crypto engine. The same IP is also
> present on Airoha SoC.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../bindings/crypto/mediatek,mtk-eip93.yaml   | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> new file mode 100644
> index 000000000000..b0173b4da42d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/mediatek,mtk-eip93.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Mediatek EIP93 crypto engine
> +
> +maintainers:
> +  - Christian Marangi <ansuelsmth@gmail.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek, mtk-eip93

space?

Why mediatek and mtk? Is eip93 an SoC? 

> +      - airoha,mtk-eip93
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    crypto@1e004000 {
> +      compatible = "airoha,mtk-eip93";
> +      reg = <0x1fb70000 0x1000>;
> +
> +      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +    };
> -- 
> 2.45.2
> 
