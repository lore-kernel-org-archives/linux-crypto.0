Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C67745F4;
	Mon, 10 Jun 2024 22:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718058509; cv=none; b=YTaQZAAFbW2TORkCdQz4PyF17WfsKW5ajLdweswMAwEKdSB/MqSKLX4pgELnRYd1Vti92OEFEvHKlezmmAbY/OrcsU8c28oBd5Omym3mttKC7ePKwoR8Nt+nZI7J4NTFm902PRRk2wh26SB/rquEb0e2Os0LAuXjz2iehukD3/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718058509; c=relaxed/simple;
	bh=jGyCsYSq/UxDN4mBtbNa7oTMO5CREgU3nQw/d+1YT7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBqDfxoipYYx/jI/u5YpbIoG/uCaGY11yVqJJXcN7UMS7zqU2AinICK9cFlYYg2mcpNEqzmvKoRUaANqGCKgOveBS65UCQFIt9VY1aRfau5OyhX61MLO/Czp/6LUKF6ZWtQbcwIJRWpRRxmSP3BOVRGJBuREJzpdj0Xe/aFpYJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f46QHQYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f46QHQYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E78C2BBFC;
	Mon, 10 Jun 2024 22:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718058508;
	bh=jGyCsYSq/UxDN4mBtbNa7oTMO5CREgU3nQw/d+1YT7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f46QHQYaT8efpXnW7g3klN5PIH6ovp9Gh+9wrYe1BexiGVnwrIOFdjS3q10YVryGa
	 INfl/LYTVO8mKs1o2AalrkDD0a51pEGI5cQKwT+RfK+mAL1YLG9ajFTFXvqBTmuuAn
	 aAxielqwOTuHkAd9jFowHSpVFTTklmAA1ZR0gXo0iEo7OYAZtF1vIFaRB2Qc0TpcPe
	 IFR09v8sZ7brPKgybBxuFi6Qy1QttxCtUUa95kU1Thw3dw7gz0t1hhBFxJOt/JT3g3
	 18xYi4QMbladdyrqTi7lKzHiW3cfltIEc6DnT+zC4FZp/8CHdDghQMRr4/aKh4+zNo
	 GWYyS1wiK4pIQ==
Date: Mon, 10 Jun 2024 16:28:27 -0600
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
Subject: Re: [PATCH v8 17/23] dt-bindings: crypto: meson: correct clk and
 remove second interrupt line
Message-ID: <20240610222827.GA3166929-robh@kernel.org>
References: <20240607141242.2616580-1-avromanov@salutedevices.com>
 <20240607141242.2616580-18-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607141242.2616580-18-avromanov@salutedevices.com>

On Fri, Jun 07, 2024 at 05:12:36PM +0300, Alexey Romanov wrote:
> GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
> Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
> engine is hard weired to a clk81 (CLKID_CLK81).

typo.

> 
> Also, GXL crypto IP isn't to seconnd interrput line. So we must

2 more typos. Spell checkers exist. Use them instead of me please.

I think you forgot the word 'connected' too.

> remove it from dt-bindings.


So did this binding not work at all? Are there any users? You need a bit 
more justification for an ABI breaking change.

> 
> Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings
> documentation for amlogic-crypto")

This line should not be wrapped.
> 

Drop the blank line.

> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml          | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> index 948e11ebe4ee..aff6f3234dc9 100644
> --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> @@ -20,13 +20,15 @@ properties:
>    interrupts:
>      items:
>        - description: Interrupt for flow 0
> -      - description: Interrupt for flow 1
>  
>    clocks:
>      maxItems: 1
>  
>    clock-names:
> -    const: blkmv
> +    const: clk81

Clocks are supposed be named local to the block like what function or 
part of the block they clock. This sounds like something global. 

With only 1 clock, I'd just drop the name altogether.

> +
> +  power-domains:
> +    maxItems: 1
>  
>  required:
>    - compatible
> @@ -46,7 +48,7 @@ examples:
>      crypto: crypto-engine@c883e000 {
>          compatible = "amlogic,gxl-crypto";
>          reg = <0xc883e000 0x36>;
> -        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
> -        clocks = <&clkc CLKID_BLKMV>;
> -        clock-names = "blkmv";
> +        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> +        clocks = <&clkc CLKID_CLK81>;
> +        clock-names = "clk81";
>      };
> -- 
> 2.34.1
> 
