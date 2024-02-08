Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A732A6A8B1
	for <linux-crypto@vger.kernel.org>; Thu,  8 Feb 2024 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707381523; cv=none; b=epgXcwK/fjxEDH9TyBiJ+6YhasfRpfvixXbOvHKUCNWvuqtNY89XMVNBpjNZ7kDmHwPot3hWsKj2UUFDQt6xcI1jAx8dA/v4sSLS1N9ahniaD/pGL0v7X6WrzHSFex9YYA1qT5jAiV9T0ncNb+X9J6LO+4fmW+tuTVoGhw16zyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707381523; c=relaxed/simple;
	bh=uPvI//sdUZWcQl5m+2rptWfruZeWhl6Oy+X40K4xYy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XWCPQ6B9POvgSI6tZgPHSCePWoh8EFcLR9nz/cKo+mSW5SQTQLZ35hJaLT93PALtGjTKNsMtv5uQSnfcNMjrYRRWx4YwaytZZo1qCG0ELsf0YPpVnprKLDs8gvB78hGB2qWAQJkuWl5/hhqSqkeg4XupSNe8qzR++Fowdgtjbew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ieLxi5U4; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ieLxi5U4"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-41008ab427fso14187505e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Feb 2024 00:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707381519; x=1707986319; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qr9JmnlTZM+mC+5PTeNA50C8sKbTF6tVkGIW20MXSlY=;
        b=ieLxi5U4+66KpEzB6jQrE+LMRxelWmKP+gePgK0TEAzyEc5vE6mPHxd9a/cluzhS/q
         ePpkVFOy15hgOlwx7sDOEomwJ7d87XXVHn3g6UhiH8DWBSoSzziTEjEFMDM4v4t+H/3F
         9z2UcGT8ZR7viFawGDILsqSPy4pPMHhZSSdDWpwWTHNfdqoN06Y7dNCktz+14pfG0VhG
         skm2jEMV9C+OhEJALXyFORqzbYsPr+Uw/SqjUmnZdD0JRXahlXFyzn/wXLhGXhLLQ7CZ
         UMS255mBSQe2IMx/POURk7LMvprQmm4fowOD74nbM3Rjy4QRXlAolMkoGoZKTCutZvT9
         FiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707381519; x=1707986319;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qr9JmnlTZM+mC+5PTeNA50C8sKbTF6tVkGIW20MXSlY=;
        b=meNQqJvIKt3nixqLIP+4m18CC9U0nFIPO/DHn3OTlQfaI1uMmdh742Tb0bSc+JGG5M
         QGH+JAs7EeERpU4WyIC3ToLabw+7HVyyiysE1L0HFEMW7zhfM+BQgKYOlIWaaBnD5WmC
         HGD6GiDtfMBbSTNwk3f5DuK4GMbRUlDrlz/kTivib8KY2SMP032Ydh2jMNU+ANn+l6tL
         FJo+KykakgpwTYsQ2Ax9JYmFbTYFw0p9Wfh/dhmqEitbK3zxwhBRzeUPCdaWsd7tc1sG
         SDzdvm4OES04SFpVka9MN27xPcEGbuwVAS31j/jF6jMK6EDrb21duiR0K2GtMPHqrf3I
         ZXlg==
X-Gm-Message-State: AOJu0Yx8bEGaXf2013z5sHrmt32eDOA6/aWY1Kd+410Umc024q1VHqXn
	kG1bbOEKo3ipxnCS2FLtcT4fPdLA64HlZocRD8jFYMhqLFyi0CNCG4e1FNrjWP8=
X-Google-Smtp-Source: AGHT+IF+cukrfLPNGBJ/O00IGvwc5IG6n2Ej0mJ+11haqqjzNzNtwFvtIxcbPpAzgiPq0nol3J4Viw==
X-Received: by 2002:a5d:5f44:0:b0:33b:2d46:74e with SMTP id cm4-20020a5d5f44000000b0033b2d46074emr6072969wrb.55.1707381518882;
        Thu, 08 Feb 2024 00:38:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJ/9Cq4SGjXVrt7HCYGR2R9f2GPIGSEKGJFeIoJvTxKnk7n5TGQsrE5U0d2RXOb4tahO3b5NSca1oAmzKpXDOO16/BMgJ4GuOEcgHqeJsMLmDtgv2ijvAITYUYlOcx4eVmuPG9BzzIC1iGjjTX6o9I/a6wm/EYikyRNSOd17293ELLGN+i4r4KJpc+rcUfcUIS9zJZlCf+vwuU6Pa6g8Cq7HJiILMaOtVflP+Zdj8XE86jMNiGwdjTsEnMGtSAXZTgAaDX+ZBr176JYOZ2nmNwg8rqoX/lGkxJSh1VgkZPkAyrcBhEubigCueaXi9c7wWtZkTQJWOUwoqLLsE30l4I2GskTqeyKoGfg8kkoGxs3p04knUCMXq6td5raHyjL3Zgpj32ya4bJvgQOluMhDuIuU+Ir6RKs2wgJHRwMvCjQPjnucXUYJUGx7wh6EerSEToKyi9biMivItUpDpL8qaPWAAw9jJig67pksYqrJdJzitZE9hQMWfGfuPMaUnfXvprmRFF9Tax8TotxqzHTdHLXfv7ltmO3mEnwmhcVy3RU3XuyOEhzL/v4dBmMWisjpsQkO3bWN0q+bWSc20bOtOXvty1mltLgSyc
Received: from [192.168.1.20] ([178.197.222.62])
        by smtp.gmail.com with ESMTPSA id bg20-20020a05600c3c9400b0040ffe1ca25bsm928058wmb.21.2024.02.08.00.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 00:38:38 -0800 (PST)
Message-ID: <b2e4ac25-5b07-46c7-a96f-8390a95584ea@linaro.org>
Date: Thu, 8 Feb 2024 09:38:36 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/20] dt-bindings: crypto: meson: support new SoC's
Content-Language: en-US
To: Alexey Romanov <avromanov@salutedevices.com>, neil.armstrong@linaro.org,
 clabbe@baylibre.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 khilman@baylibre.com, jbrunet@baylibre.com,
 martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com
References: <20240205155521.1795552-1-avromanov@salutedevices.com>
 <20240205155521.1795552-17-avromanov@salutedevices.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20240205155521.1795552-17-avromanov@salutedevices.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/02/2024 16:55, Alexey Romanov wrote:
> Now crypto module available at G12A/G12B/S4/A1/SM1/AXG.
> 
> 1. Add new compatibles:
>   - amlogic,g12a-crypto
>   - amlogic,s4-crypto (uses g12a-crypto as fallback)
>   - amlogic,a1-crypto (uses g12a-crypto as fallback)
>   - amlogic,axg-crypto
> 
> 2. All SoC's, exclude GXL, doesn't take a clock input for
> Crypto IP. Make it required only for amlogic,gxl-crypto.
> 
> 3. All SoC's, exclude GXL, uses only one interrupt flow
> for Crypto IP.
> 
> 4. Add power-domains in schema.
> 
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   | 44 +++++++++++++++----
>  1 file changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> index 948e11ebe4ee..62f772036b06 100644
> --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> @@ -11,20 +11,30 @@ maintainers:
>  
>  properties:
>    compatible:
> -    items:
> -      - const: amlogic,gxl-crypto
> +    oneOf:
> +      - items:
> +          - enum:
> +              - amlogic,a1-crypto
> +              - amlogic,s4-crypto
> +          - const: amlogic,g12a-crypto
> +      - items:
> +          - const: amlogic,gxl-crypto
> +      - items:
> +          - const: amlogic,axg-crypto
> +      - items:
> +          - const: amlogic,g12a-crypto

You just ignored my comment, so repeat: that's just enum with three entries.

>  
>    reg:
>      maxItems: 1
>  
> -  interrupts:
> -    items:
> -      - description: Interrupt for flow 0
> -      - description: Interrupt for flow 1
> +  interrupts: true

No, you need widest constraints here.

>  
>    clocks:
>      maxItems: 1
>  
> +  power-domains:
> +    maxItems: 1
> +
>    clock-names:
>      const: blkmv
>  
> @@ -32,8 +42,26 @@ required:
>    - compatible
>    - reg
>    - interrupts
> -  - clocks
> -  - clock-names
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: amlogic,gxl-crypto
> +    then:
> +      required:
> +        - clocks
> +        - clock-names
> +      properties:
> +        interrupts:
> +          maxItems: 2
> +          minItems: 2

Instead describe items like it was in original code.

> +    else:
> +      properties:
> +        interrupts:
> +          maxItems: 1
> +          minItems: 1

and what interrupt is expected here?

>  
>  additionalProperties: false
>  

Best regards,
Krzysztof

