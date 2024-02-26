Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F70D51C47
	for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708939454; cv=none; b=AlrL5qZ3ZHtJXPu6mVva9F1akQ/4OtUia6JUgWOgPtVZ4ruq4RuSpchoEP9Yb4Mx+AMGboBQNwATrL/sS55wA3Mm2noxfHQrZPF2FLR7SURT3oos4h6jttP19VB9I4T8r4cF0jszphseFvapiq+mSJJKIxydvFJ2u8rxJuw4Pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708939454; c=relaxed/simple;
	bh=JV2wrawyeXPo4aIOiBpPMHJ26a4I93PUV7/GweGKTec=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ebBUXDEMn7ZynjRo1gp+CdPQt8Inwjg8mGTfz01IBo52o7S08Dds+YXov0m0uxiQ2NP6FznJMggHllCFQUExZETs4EkD6v0+u5su+tqWsMFdox0VD4tN03hvO5iX0bcJzFcCeR81AKDuY5wPYIO2i6BotjDTChsHHUp+WL7hBZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uA7k9Oep; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uA7k9Oep"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-564e4df00f3so3569278a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 01:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708939451; x=1709544251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zJf2FW1KV5zcyVzT2YgYrCyTLzGHgmEw6n4q6HDUml8=;
        b=uA7k9OepuNxk5J2K7o6VO0sFrcJRYYt06UsubzP9UDU9TDpOKgLMOAAr1lng1ocaa9
         m7e8Z/bsxCYQWMGE98RdN9d0AgSpK/56MTG9tyPMay0Tl+hr4tLyljd49E+pXj12JdFB
         N/1u+jg6WdfwsLwkQ9/oBZnxAS9oQ+/U6pSGV7KLm6axq8ByfVlgLmFyGMwxuKoPBFKm
         yKO1nPUQMDt+Co3XV1sAjUeJIgYBBzwgxbopNBhoksxRqqDvxkufdJVrQeQo7jQ96FZu
         12l5TKHztfddkVENAN7NgwqklRs7Y6qWgwiQd/fBND0U8erZw2Xi51A2KQZUVgM7RZMN
         sekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708939451; x=1709544251;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJf2FW1KV5zcyVzT2YgYrCyTLzGHgmEw6n4q6HDUml8=;
        b=Hqw28/dfKdTXWGj0/7KCAgJcMqDHhc61JcM9ADveOb27vH0MplQ4s2IVHWo/TrX1aZ
         G4tpJHHBKpI37ykK4mqTBb5P1Uiyhj+4G/pzsyqA3BZaqNIDsl3qKpg+RO85HUyEbjiX
         3fBW8eAH0LH7Py64x13BqMffFC5dJpU3nGkEVf9gjbqyeK3/OASHhQdDOTJkIpTY3meU
         sQvQHH/6o6eL2JSdH5tPGqcaXMQiokoqfMTG1g22Ye06nYu+zFfwgKO8jFzr3FInbVut
         xYApLBco4wYe6r5rrbnn1dBrGFe5pmxz2LiHI6FppxmhS6QrrEKaUhDSPGX+vYlCkxKH
         4a0A==
X-Forwarded-Encrypted: i=1; AJvYcCX4P3/2IHwlolhZWCFXQOuaNcqV4OzyEx90Xfb/Yr7uGQ7kcvSSveImdLn2FwWbqNEyJzFG37Ekr5Kzn2tvOu06Zzqc+cPOsZ8ny54G
X-Gm-Message-State: AOJu0YyH1Lr2KSmPluBFIlUJ2Z8qE+o+ntk8imBBMW1V/HOKHWMpVBdV
	0GTcRhrgx2/eNVohSW402TFRryVJxWUaGgVNpBpaIlsE73tQ7vtdVsGqnh4PSLeL12DFd5wO4VK
	J
X-Google-Smtp-Source: AGHT+IFn6o+RexLO13XYps7GlH49YQXHwq9GVtbMl5z7QBcD2ywIAisyJKdBhxCc5k1QxJ6sd1XBEA==
X-Received: by 2002:a05:6402:2c7:b0:565:8e3a:5add with SMTP id b7-20020a05640202c700b005658e3a5addmr4140787edx.15.1708939451603;
        Mon, 26 Feb 2024 01:24:11 -0800 (PST)
Received: from [192.168.0.173] ([79.115.63.202])
        by smtp.gmail.com with ESMTPSA id q4-20020aa7da84000000b00561c666991csm2162886eds.73.2024.02.26.01.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 01:24:11 -0800 (PST)
Message-ID: <0a6fec2f-978c-4290-a189-20120a60d08b@linaro.org>
Date: Mon, 26 Feb 2024 11:24:09 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/39] dt-bindings: crypto: add sam9x7 in Atmel TDES
Content-Language: en-US
To: Varshini Rajendran <varshini.rajendran@microchip.com>,
 herbert@gondor.apana.org.au, davem@davemloft.net, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20240223171342.669133-1-varshini.rajendran@microchip.com>
 <20240223172445.671783-1-varshini.rajendran@microchip.com>
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20240223172445.671783-1-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 23.02.2024 19:24, Varshini Rajendran wrote:
> Add DT bindings for atmel TDES.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

This would have deserved a better commit message, I (we) spent a lot of
time deciding whether this is the correct approach.
https://lore.kernel.org/linux-arm-kernel/342de8f3-852f-9bfa-39c4-4d820f349305@linaro.org/

Anyway:
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

> ---
> Changes in v4:
> - Updated Acked-by tag
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml  | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
> index 3d6ed24b1b00..6a441f79efea 100644
> --- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
> +++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
> @@ -12,7 +12,11 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: atmel,at91sam9g46-tdes
> +    oneOf:
> +      - const: atmel,at91sam9g46-tdes
> +      - items:
> +          - const: microchip,sam9x7-tdes
> +          - const: atmel,at91sam9g46-tdes
>  
>    reg:
>      maxItems: 1
