Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D15C1D86C7
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313258; cv=none; b=t7NyKZHEYh05EBvqgwOAyLe7a2r9k0rUCv/VyIOOZoPElnLwsAZ0GT4l+kG52mCA5UnEquxMqyp9Ef73CnootNKiNgPZaE6Y/157aXf8n5gIfKbXhYXj24GMuonoGKVsCbWbqT3Q24sHes5Z/hIpBSKldYz3m1hjRrQ9ZZHxRak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313258; c=relaxed/simple;
	bh=9TXYHj3iHR0mGjqblY9Xuz4oEKrqruFYvSo91qTiy0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G52dkYEnMdZDAZmXosC+LD85kkGK1D9+WWJVrltQb3G2yloFEx0F1+PqdlXNIiGPrk1xrmGCD6xuWwhpzdc5BIwulLAC7nlCF4YVO0yXd9UjITKC5TFSlwf14hpPlmOHCpOYr6BeZvnZEpBVakvAp5K/p57KxKf7WRDvJV9+zio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bj+tKOa+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bj+tKOa+"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42caeb4d671so7345235e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2024 08:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728313254; x=1728918054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HKuV/t0P8tcRegmVsaYPLz1LSsvm4XltyjhxkF/yT/M=;
        b=bj+tKOa+bjO9bx3D8wI4BncY6rvN1ramS+nUnGAPt4GnmI9AuRGViy7CPdTRlw+2Sv
         dqaztzNZ5Th7es6kv+9bMC38il1C+DiFq0yHt/5aSskaX10jjeITUld2tNyRyR8B61RD
         1Gn4fd9+0lLaV5Tl1Vt4TtvzCS3wUg1BSB2y0dDV6KkEVcMOmbrESsn4zB4ueZLbB6kW
         VVsipI/mRr1DT6Ezk795b0Ys/mDfrIMrAsoqbGS8x+UA9yQUVQjv92FE1Jmb0JLBQwoM
         2hACPLJlO2iqg8kmsh+qaH9cLp5NlZqSqO+nlfn9ErUdvJvrlLWJKEsc/jZ1+v2HNU7O
         Kygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728313254; x=1728918054;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HKuV/t0P8tcRegmVsaYPLz1LSsvm4XltyjhxkF/yT/M=;
        b=i54dthGI490TcqhOrXRshMvrggSBHQDyFMakgYP0jN+CnBB3/RGYoLILkxJniMkay3
         4v2cuQ43cHteUGhh9vl1dxWYCSPhvDHl+ow3VKBbjzgjBha9eUnkMA3/8NiNOuQchS2x
         9bZb6Sb4M1h9SQfwPCKawPZXNZJfNPedbxFqEyTOJsS3ODcp2fyDF07qrSYs9GJfdg+A
         Iz0N6RMOBL3W4HIEcVdmUhC3NwvT1vV1O9FLT7CuYAb98Q+JP4g3h2qT+p7LYtz8zs4E
         +3xDPq8eCOPrt1FEAL5EIDx1XehePfGFNv3kdlKcknLkdYoc2I8+OsorpHaKMfsICNd9
         Y2Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVnWruDQSQI3pp5dCxiUPsZPt76LvHfYwJeC0Ws5v/fFowF5vUeQSulZxskux3H1thKoe7QpYKnQNBLRyY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc+0Xf2teirJYiLcO/SIl6BqArehp8LtHV8bJaPR+np/x3E+/6
	Ffy93iw5Itt71bgf7tYNeEIVr7nLS8XDIB/ZH140rJxZQqGX7smEbGO3tDP24eM=
X-Google-Smtp-Source: AGHT+IGV/tzcF/bCj/krNhXcoeJNqtqJ70DwgAZPLKKnpdYx8DCziyBnCuiS6oXv6NME57+4Seqh+A==
X-Received: by 2002:a05:600c:1390:b0:42c:bb35:b6d0 with SMTP id 5b1f17b1804b1-42f85aa361cmr39788775e9.1.1728313253641;
        Mon, 07 Oct 2024 08:00:53 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.211.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b1d5fesm94960885e9.24.2024.10.07.08.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 08:00:53 -0700 (PDT)
Message-ID: <ec3cda71-57d0-4ec1-b9d8-62381667f7d6@linaro.org>
Date: Mon, 7 Oct 2024 17:00:51 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Gatien Chevallier <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>, Marek Vasut <marex@denx.de>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Lionel Debieve <lionel.debieve@foss.st.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Yang Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-2-gatien.chevallier@foss.st.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20241007132721.168428-2-gatien.chevallier@foss.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/10/2024 15:27, Gatien Chevallier wrote:
> Add RNG STM32MP25x platforms compatible. Update the clock
> properties management to support all versions.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>

You CC-ed an address, which suggests you do not work on mainline kernel
or you do not use get_maintainers.pl/b4/patman. Regardless of the
reason, process needs improvement: please CC correct address.

> ---
>  .../devicetree/bindings/rng/st,stm32-rng.yaml | 41 +++++++++++++++++--
>  1 file changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> index 340d01d481d1..c92ce92b6ac9 100644
> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> @@ -18,12 +18,19 @@ properties:
>      enum:
>        - st,stm32-rng
>        - st,stm32mp13-rng
> +      - st,stm32mp25-rng
>  
>    reg:
>      maxItems: 1
>  
>    clocks:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:

Missing minItems

> +    items:
> +      - const: rng_clk
> +      - const: rng_hclk

Drop _clk and come with some reasonable names, e.g. "core" and "bus"?

>  
>    resets:
>      maxItems: 1
> @@ -57,15 +64,43 @@ allOf:
>        properties:
>          st,rng-lock-conf: false
>  
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - st,stm32mp25-rng
> +    then:
> +      properties:
> +        clocks:
> +          description: >
> +            RNG bus clock must be named "rng_hclk". The RNG kernel clock
> +            must be named "rng_clk".

Drop description, useless.

Missing minItems

> +          maxItems: 2
> +      required:
> +        - clock-names
> +    else:
> +      properties:
> +        clocks:
> +          maxItems: 1

Missing constrain for clock-names.

> +
>  additionalProperties: false
>  
>  examples:
>    - |
> -    #include <dt-bindings/clock/stm32mp1-clks.h>

Why?

>      rng@54003000 {
>        compatible = "st,stm32-rng";
>        reg = <0x54003000 0x400>;
> -      clocks = <&rcc RNG1_K>;
> +      clocks = <&rcc 124>;

Why?


>      };
>  
> +  - |
> +    rng: rng@42020000 {
> +      compatible = "st,stm32mp25-rng";
> +      reg = <0x42020000 0x400>;
> +      clocks = <&clk_rcbsec>, <&rcc 110>;
> +      clock-names = "rng_clk", "rng_hclk";
> +      resets = <&rcc 97>;
> +      access-controllers = <&rifsc 92>;


Difference in one property should not need new example, usually.

Best regards,
Krzysztof

