Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65FE1F151C
	for <linux-crypto@vger.kernel.org>; Sat,  7 Jun 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749296566; cv=none; b=A74E4KrtOiLtV3VMu1AS4otPSEfCTMCF8fwru3/zCbLlCN3SwY9mcUkJT0VBeDXxGC7DSJXPIHUG2+eFQ5GkVIztUsnyFX8ro9XLVkOu1ma9MEwPcXr/P4FKcfjUT4jz61cPNbIcYJ5BiYQe5fS+oJZrQ3M2OdOc7ggJHoFJ/fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749296566; c=relaxed/simple;
	bh=d8I8eKRlDb5f4zH5sidDXcjiayJ19dluoQhODaDQiKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZPr4m7KeLh0nX3Q0/ceBj6O5/JLCXdaYwM3Ev4zIhvOmBzBEDB/05qb7rhNglOp/umTuBZXn9VueedCTt9+Ltba1lmt6crQht4/QYOdReUibLCJxayqqVhQIz3KqcL26AWZtMz+6Kc0tFfb8cLB/lI2XQH/+xjVrBn6qTC/tIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=jflOxC5E; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="jflOxC5E"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ad883afdf0cso554547966b.0
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jun 2025 04:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1749296563; x=1749901363; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vbBYREB7EZz7uh97XCG/R2ZuqTlW8SyAHh+pi6ZvUpg=;
        b=jflOxC5EEqE0tIXFv7Fq/IrhKckN6OcbD2s7eUcmUAQFOonuGThUjC9Xs6lw6R+Dz0
         3/hehShJ9r4wvR6zCKKn3N5LmWbVVsaNESCTL1xdBFzI8cQI4uk/qT/t8vgED5kjVUPi
         s/H+rGPrIbYCTNKJyNHHaT0uAYBxL7lPoUvvPRaDOxue8lAJGGTPX3MRZWjXgbdapJsb
         F8EaVclYGAD9/GPWC9IPLWks1HvpSSqmTDrU3/Zy6jUzByDZ69aGM50DfuFSHX6loH8N
         miwMBRkfyVhUtPPNzqaMN69AFYaVZyjPCh5yJy6Bhsevlw6ntzaiU0VIjDRvY7YCcNON
         DeAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749296563; x=1749901363;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vbBYREB7EZz7uh97XCG/R2ZuqTlW8SyAHh+pi6ZvUpg=;
        b=DM9X6tmiG9P4B8eUYzs/WzgG9GDqelrhZrMGREqEO/Of4mQfqI99cJW9d6udTtWhJl
         FuDb7I3soBNWSWO4xD+NfrXS6ZzKLpyIC+pz02klPIGGJvHAVy/NxM5fqs3dDqhTzFOm
         aXW4obz+teBiERX/tNRt5oUUEA2afxwBbn2Uj1QScufQHqdm9ZKe7eAvys6QsntwIoe1
         Vwm4xfXdtztz6ZeL8cOc7mOzHz2nRuDFdzNt0jyJNJjdN9N1ztpLhBtksUGxQVGh0D4H
         rivR3aSkPBYRzexZse8P8gK6FZBLFJS6NznErXkj10Y4aVWqf+R0B4fstx5YZPNg4pp4
         drsA==
X-Gm-Message-State: AOJu0Yw5+PTc34LyRLw5RbWlsRQ1TpWrqJN2PYYYXsuJSWbhxWDMVE0Q
	cnfnGOul4WpH7LcS8FzDIgMY3d7yaZpFOna2NKxIqxJdRV3trswRxsLrGBVlsjJRKghHU7qcco8
	IJcae
X-Gm-Gg: ASbGncuPW1TXvxOcLcNQF5kxUYdQx3jGq2chJBGXhXGqEgJGOVo4opRRdeCUuggLUry
	bzUX7Y35RbwJXJEDuudcHMBEM04XgdG5/0cFvm7x+wEjml+2nn25DfUkluUrDhC39mg1DUyttOq
	AU/D6WDQYltJdj+ZihymXddtKsDjaDQGzy7lRQTXo9WUKP7GebWfWQjFX9LUpHuLzPR+JTsgC3G
	vu4Q+31IRwclGYXgbEwyYweaiq8cGgNrS9HJYb8LksnRh1/RayilKI0iwcb1oSsfSvR0PbMd7L2
	Wdx2HAqZBe2VFosVXOBYcbxxR+4zjv7ZU/HOaZjXm52udtPs/Ecqtp2ao/jUXc5i8crUwvI=
X-Google-Smtp-Source: AGHT+IE/ghuMo8WxjRQEBBSzj3ZNMEtTZhSuX3aE1kpWDYjCFmKx98n9jZapdCOk71/aJ5kHwhIRQA==
X-Received: by 2002:a17:907:7282:b0:ad8:9c97:c2dc with SMTP id a640c23a62f3a-ade1a9fcf5fmr648393066b.15.1749296551642;
        Sat, 07 Jun 2025 04:42:31 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.126])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade35ce30casm151447866b.162.2025.06.07.04.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 04:42:31 -0700 (PDT)
Message-ID: <b355e01c-d9a7-47f0-bfe8-282d9152a814@tuxon.dev>
Date: Sat, 7 Jun 2025 14:42:30 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] ARM: dts: microchip: sama7d65: Add PWM support
To: Ryan.Wanner@microchip.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, olivia@selenic.com
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <fae166010f94a672e4f1906f5fd4394f4236da53.1747077616.git.Ryan.Wanner@microchip.com>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <fae166010f94a672e4f1906f5fd4394f4236da53.1747077616.git.Ryan.Wanner@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12.05.2025 22:27, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add support for PWMs to the SAMA7D65 SoC.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

> ---
>  arch/arm/boot/dts/microchip/sama7d65.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
> index 90cbea576d91..796909fa2368 100644
> --- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
> +++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
> @@ -293,6 +293,15 @@ pit64b1: timer@e1804000 {
>  			clock-names = "pclk", "gclk";
>  		};
>  
> +		pwm: pwm@e1818000 {
> +			compatible = "microchip,sama7d65-pwm", "atmel,sama5d2-pwm";
> +			reg = <0xe1818000 0x500>;
> +			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 72>;
> +			#pwm-cells = <3>;
> +			status = "disabled";
> +		};
> +
>  		flx0: flexcom@e1820000 {
>  			compatible = "microchip,sama7d65-flexcom", "atmel,sama5d2-flexcom";
>  			reg = <0xe1820000 0x200>;

