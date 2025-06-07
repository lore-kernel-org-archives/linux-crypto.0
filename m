Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ACE207669
	for <linux-crypto@vger.kernel.org>; Sat,  7 Jun 2025 11:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749296661; cv=none; b=utRvMs5Zltbivs+U4mbL8Bd1l6XJ1Vky8OPx1fXDxoNwJXfmaxShpRu7EPVgTmaK1Kmu74QIKcd6wy+mHltCoGazXzyMBu7uPekJOBokUj6fCxMfTlS2l7VntDrNBgb8nQPaNRCMhIInzj8ceJPL4CtZQrokqV5TLTLngPg0n+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749296661; c=relaxed/simple;
	bh=gv0tMOWwWLz9TNHcfO9BCckdP/os8K0yPX8V/NxNjNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tIdjSK9+Jj7E2TNu//eA4pC9uEOH9wCvGnh1CR6zkWzdX0Y1vQORPb1yzQ2DejwaLnFQA89DbRDm529CCgzJqVH78ZSwpIK//G96D1Ou8tByNVnBN3+2PzmAnIlvtiEmhityBda/vBqzv5mqQUuJ9dMMUF1YEkEhXLq/X++gSfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=i4h6b5Sj; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="i4h6b5Sj"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-addda47ebeaso559226166b.1
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jun 2025 04:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1749296658; x=1749901458; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UymOFrjabx3ry9XfCk+Bu/z/xm63u4bINQR9bUcHuP0=;
        b=i4h6b5Sj1/YxVOjsQpWrQtiCtX/BGlwKU9/b/q6azV5AdMlEYDWzNLz1EkCW4FjZth
         gaWuXsQzF1smqwdbyx0HC+6oYmwYmtkk6geJFzhI/gqy5I2uiERo0uHu2bvtRDjaUbcA
         blUjLMdow0fM8qt+yIdPUoA023Bb6R7kYtRAdz1uAtUKO1jz7MX7e6NP2EM6BVbmqXjI
         Yihd8/WLrq2PbkKG79xt2GxYzAJEH0fZkQ4zTzi4zssEEL2dLomWETMGWernt69AOk0/
         l+NRhwR1HrTJ6hbJLlFHNWohCyhCDiQPdO5OuhpvaYmaD4Go7xaRU3PB1KBI6lEzVS4H
         xxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749296658; x=1749901458;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UymOFrjabx3ry9XfCk+Bu/z/xm63u4bINQR9bUcHuP0=;
        b=xFcRYBlKcJn4EUclycpanOwVQCxvOkw+dNLgx2ZqIKeS+uNH6qEMT3eXLIclsJnvOa
         B8t5KoB2I/NMCJ5zp3puZJBILYaaUR/6t1n1P8wII6IZg6esNhGxZSuhyJtDepofOTwm
         SdeoRTXjSPdHH7whav9/Ypb2qjh/nLGbTR35ialYkenWX/FJKv2h/dNWUEmoU7P6aKDh
         /zsUSj4voebNy/XF1Rf4Fl6sgZcwO99lW0gaoFb8Mi2AOsFyglYrjsz4ktHtxKiXH1lz
         XxFDfGgmR4UPm6N1v9prp/Ttoix397Ma+jyYGb1xeJsmKxj8IvwL2L+4oEhaOzkpfyuz
         GgUA==
X-Gm-Message-State: AOJu0YwNHXNdKi9ybypQwluo8WQjulHcUgqf5l854/QvTRKMElHuaVlu
	9qmFMY7ZCNXboSBYI/9sFAT4H09d4H+YwTaQpqivJev8jelR8KANGzo3ec1UnJEqT54=
X-Gm-Gg: ASbGncty920uGx+wQZnX6dWpl+9VGpU4lRkop80dXOt5f2YvMqgGoPhL/3ZwG52r4B9
	u82lvJ5ioNRXqqJNTCiiH8qCwNXK4fdmq5rmmMEBowpcI+I/2BcI9w+pMQ5bpvJp9h5BRVw9pn0
	PVeORO1Nmp64ko6gGoCoFJQ+Qv/iZEJaparm//m2INOwARHxkaFdyMcAnmGKk21Fzs2riHRB+ZB
	E8Jw9O2kEpa6lCVGwRKSincX2lolTfFAyqmBmAzIB2TrWoSCKa0ITxCHXqXPa21W5k7UMQdOPiN
	XSB8SfKI6f4CAIYyjweclllv3GnrCNKlvifg4mIuTC5aVMkMhxJxi+kEJN5p6nu6/HR3wwE=
X-Google-Smtp-Source: AGHT+IEA1Rq7VWwYJS4G4kmb+z0nn7gMvEpZQk2GAonFxGlvr7kubnoaKOkM5BseiEpQ88K45+xR8A==
X-Received: by 2002:a17:907:9713:b0:ad8:93a3:29ba with SMTP id a640c23a62f3a-ade1aa06c53mr606411166b.17.1749296657956;
        Sat, 07 Jun 2025 04:44:17 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.126])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1d5f9b37sm264185666b.0.2025.06.07.04.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 04:44:17 -0700 (PDT)
Message-ID: <9391cd59-b23a-4df0-9799-e9766adac460@tuxon.dev>
Date: Sat, 7 Jun 2025 14:44:16 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] ARM: dts: microchip: sama7d65: Enable CAN bus
To: Ryan.Wanner@microchip.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, olivia@selenic.com
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <0e34e0416c43f4de6d2cef5cea46087af4577a50.1747077616.git.Ryan.Wanner@microchip.com>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <0e34e0416c43f4de6d2cef5cea46087af4577a50.1747077616.git.Ryan.Wanner@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12.05.2025 22:27, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Enable CAN bus for SAMA7D65 curiosity board.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../dts/microchip/at91-sama7d65_curiosity.dts | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
> index 53a657cf4efb..34935179897e 100644
> --- a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
> +++ b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
> @@ -38,7 +38,24 @@ reg_5v: regulator-5v {
>  		regulator-max-microvolt = <5000000>;
>  		regulator-always-on;
>  	};
> +};
> +

Please drop the empty line in a different patch.

> +&can1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_can1_default>;
> +	status = "okay";
> +};
>  
> +&can2 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_can2_default>;
> +	status = "okay";
> +};
> +
> +&can3 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_can3_default>;
> +	status = "okay";
>  };
>  
>  &dma0 {
> @@ -278,6 +295,24 @@ &main_xtal {
>  };
>  
>  &pioa {
> +	pinctrl_can1_default: can1-default {
> +		pinmux = <PIN_PD10__CANTX1>,
> +			<PIN_PD11__CANRX1>;

The "<" on on this line would have to be aligned with the one on the
previous line. Same for the other places in this patch.

I can address all these minor bits while applying, if any.

Other than this:

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

> +		bias-disable;
> +	};
> +
> +	pinctrl_can2_default: can2-default {
> +		pinmux = <PIN_PD12__CANTX2>,
> +			<PIN_PD13__CANRX2>;
> +		bias-disable;
> +	};
> +
> +	pinctrl_can3_default: can3-default {
> +		pinmux = <PIN_PD14__CANTX3>,
> +			<PIN_PD15__CANRX3>;
> +		bias-disable;
> +	};
> +
>  	pinctrl_gmac0_default: gmac0-default {
>  		pinmux = <PIN_PA26__G0_TX0>,
>  			 <PIN_PA27__G0_TX1>,

