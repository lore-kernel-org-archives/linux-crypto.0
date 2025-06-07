Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D301F151C
	for <linux-crypto@vger.kernel.org>; Sat,  7 Jun 2025 11:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749296513; cv=none; b=oIuD9IwItw8rA5+9yOG6Q+sI32xi5iCImuI5LbUuj73H9r2nWLbghLYN0ppsTtpQSif/1WhsJoMnqWIQx63d6LA+yY5AeHQSp4OBNc3vmka5KdMGQHXRnax7vP0jMdi6QmCdyUjzGeaFJd2Z8+v4kXSjq4hNcomfaelViF8Nvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749296513; c=relaxed/simple;
	bh=5LVMnYxo/8IkyC+9pL/eX2AR8AsZM1vjU+V7pUnT84I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0G9sr+5OHvXjd+jMlWywap5FMQw0Aze/rovLeP4CiMZG8GJb6aDrMHM1vUDFANSQHIR+GWGQu+vcvAftxCTaB5rnmIPO+gHkJTfeYTfBCb/4sQbDWqldjBNSkZLANoaEwNq8Ho9QZgDnM+sEGbIVUHXX5b/WuCrLLtSNGVuThk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=SCgI0v8Q; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="SCgI0v8Q"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so4668385a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jun 2025 04:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1749296509; x=1749901309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tpUIHwpdzY2CZpI6afE7z92XFQ6X7B6sr22AD7rh7/o=;
        b=SCgI0v8Q5XuTvRsxskQVPhs6EsKVtk2G556VHuAkTQ0hqs3wzRGHJwxIFQzNgafWBu
         ATyKcNCvA8XmJpZgKJPhU7YvVy/+P2oohn50IF0P+UArHRs4i6xT8SU6KjmwcQX3ioan
         ddaqrhi1cd0p050HiTyvscQ3yxyrf4giJj7+/vJQXUfwPgV24DO98gAMq7hJNd+lC3Fc
         2+pe6QlKgJDXGUCNeedISW7wEvTrfEydOOomWsdfdARWCN1r0561gQPz8gEz28rTQJX1
         bAdh9UyFU5+y4DagpZON8syk2gs7ro6yv0sgfpn11Pq9qnEE4MQj7GkAeFg6JKpOzs0e
         WcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749296509; x=1749901309;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tpUIHwpdzY2CZpI6afE7z92XFQ6X7B6sr22AD7rh7/o=;
        b=abuPMcH7xFERUTSsUbMT9zbjFUkKnv2b0N1yznijCoW9e5SuKQwgnNxIRBLFRFElE0
         d4uGaaVocV2F/Wq23+cy5hSUvB0vZysWXD2+/K8r8fbujQ2Fc5fZSsXsysljcbqChZ3K
         lIRP/bl9esmWjKox2ZgeeHOyf+AudhKenQojeha+zDKlcGE3EbAuKeCR8SLl3twDm2A5
         OJ/w1veSYs8E2nLLafTnLRGWOxl0Vc8qhcix5edXt4BpGGNT4eLJHxOM4kGcegdk+hJx
         Pxlui6GWYpYsNW3xiec9rqO4quucnJn5LgxXM5COVGsUVrLRtlDXAelA+XeTOgIQruxX
         AoqQ==
X-Gm-Message-State: AOJu0YzO+7ZVOL/xLg6/KyLlW0asU+FrmYKk86UABRX5Ia3kjRH0W1rc
	klTIos6QeJiUT+3wOUfUGtqJYYJYKhc/B47atEIYwI3djkliBd/14UkRrcG8E6gpDq4=
X-Gm-Gg: ASbGncs6kjecGod46qWUItzDzKzPdKkpiV9/t1k/Z/X/mhmEiGEdNA9CFeO6+kP9Gfa
	In+ryD8fF7c+OCuL8yJfRnMPrRacbdn4kKbSxBoK/VcBPgOe5/TNugYGr188aPD2Oxh4QnYIlyY
	d4XSVN82aIg6UF1b71PJMJ32EdUqCQiyh3en0wwWHk9VTkSsywpn25A+7HSW3xqpk+fHcAuFHg0
	Fd64cT92vUyb3odCDyK7I7UbkPJ6LWfj0sheN5Gfn4byBSmX/YlLYdnY5U3Urw3zzPL9bDVjziN
	IQFaDkf1WP05RWW/DOxkA8yVXT9JQfCeY6UpYRWPBNH9AU2pl+92OBVg2A26
X-Google-Smtp-Source: AGHT+IF+6xpy8Lxdm6lC66+KC/dopAh/IjXL4qdeSW+s29AFBKWuEN5NwskU3wTPxVH1rP+CS4zbfw==
X-Received: by 2002:a05:6402:13cf:b0:601:6c34:5ed2 with SMTP id 4fb4d7f45d1cf-60773ecbf9amr5548576a12.4.1749296509159;
        Sat, 07 Jun 2025 04:41:49 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.126])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6077836ff44sm2281966a12.8.2025.06.07.04.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 04:41:48 -0700 (PDT)
Message-ID: <c150550c-bba6-48d5-90c9-d52db1f039d5@tuxon.dev>
Date: Sat, 7 Jun 2025 14:41:47 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] ARM: dts: microchip: sama7d65: Add crypto support
To: Ryan.Wanner@microchip.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, olivia@selenic.com
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <5d045fc3be18fcd6644f14b9568f1f8d7c8d75a1.1747077616.git.Ryan.Wanner@microchip.com>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <5d045fc3be18fcd6644f14b9568f1f8d7c8d75a1.1747077616.git.Ryan.Wanner@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12.05.2025 22:27, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add and enable SHA, AES, TDES, and TRNG for SAMA7D65 SoC.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

> ---
>  arch/arm/boot/dts/microchip/sama7d65.dtsi | 39 +++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
> index d08d773b1cc5..90cbea576d91 100644
> --- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
> +++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
> @@ -186,6 +186,45 @@ sdmmc1: mmc@e1208000 {
>  			status = "disabled";
>  		};
>  
> +		aes: crypto@e1600000 {
> +			compatible = "microchip,sama7d65-aes", "atmel,at91sam9g46-aes";
> +			reg = <0xe1600000 0x100>;
> +			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 26>;
> +			clock-names = "aes_clk";
> +			dmas = <&dma0 AT91_XDMAC_DT_PERID(1)>,
> +			       <&dma0 AT91_XDMAC_DT_PERID(2)>;
> +			dma-names = "tx", "rx";
> +		};
> +
> +		sha: crypto@e1604000 {
> +			compatible = "microchip,sama7d65-sha", "atmel,at91sam9g46-sha";
> +			reg = <0xe1604000 0x100>;
> +			interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 78>;
> +			clock-names = "sha_clk";
> +			dmas = <&dma0 AT91_XDMAC_DT_PERID(48)>;
> +			dma-names = "tx";
> +		};
> +
> +		tdes: crypto@e1608000 {
> +			compatible = "microchip,sama7d65-tdes", "atmel,at91sam9g46-tdes";
> +			reg = <0xe1608000 0x100>;
> +			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 91>;
> +			clock-names = "tdes_clk";
> +			dmas = <&dma0 AT91_XDMAC_DT_PERID(54)>,
> +			       <&dma0 AT91_XDMAC_DT_PERID(53)>;
> +			dma-names = "tx", "rx";
> +		};
> +
> +		trng: rng@e160c000 {
> +			compatible = "microchip,sama7d65-trng", "microchip,sam9x60-trng";
> +			reg = <0xe160c000 0x100>;
> +			interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 92>;
> +		};
> +
>  		dma0: dma-controller@e1610000 {
>  			compatible = "microchip,sama7d65-dma", "microchip,sama7g5-dma";
>  			reg = <0xe1610000 0x1000>;

