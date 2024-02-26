Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25E45103E
	for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 09:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708939432; cv=none; b=LCrVMHGUlPeSSZfjrx8FmnU7h/1ono5JF27rrb8oZTl7j0Sy4RulghdpQomM49dcOLy04jeYI3s0sKrJFRT+sPP4cTSunBEwVdXqNA4T7DhoZA4MmqrEogsk+oDpgLHSmeYGJHzhuWfP2inf5aBdhGpXodSfkwr1e9AiPZj26ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708939432; c=relaxed/simple;
	bh=cTKp7I7tMsOYO+FE2cmRKjJmbV/rXCzUzDsR+lFOveA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QF4sBvp9INEn+KontM/fgmM9NzRIJxwTewDliAhEFcsaCAIpr50jgqc6Ny3ZR1NElb1ROzQ7etoZ2Aad00CdYScw21OASfAxMaEDS/rBZ1E9iAEzJtyd6IXQDmtEG8nMBqIozwsWBOzF4ggOl48sW1ZbhS69UrLYJc2f6dlQxBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rAhg3e80; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rAhg3e80"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5648d92919dso3628109a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 01:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708939428; x=1709544228; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T7OjFVe5PDNtQzE17tQvV5A65uLfZ7ptZnYanBGxUvI=;
        b=rAhg3e80JLFvc0KEP6IgvlhYeBswLeUynHfuDG523+fRY85VGw1OpTjqQJ4Y2JwlV3
         KV6xxqL0R0lG2LV/26ZvxOq3VttM918sKweMvyGamSGmRMlo2N7zHqeXpq1l4eHTs8cQ
         KgPumCqFPcFAzcURIy7j3oe+harkM3iQYFjw7ldwaA0bvpcShU5is/uK+75SNMuB6vZ2
         O80C0CNj12F136ocLvn16GN8WltZltTZDfAtcXfIRPchwa7c+4hlOGLRn3Jp+QzPINaC
         2LFLlDMsCElXgE/ZzYgEmQA5+Q7VfRPlvS0SmeYVpP10RvPOJFqB/uhoXxMXqjoLNAas
         Qy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708939428; x=1709544228;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7OjFVe5PDNtQzE17tQvV5A65uLfZ7ptZnYanBGxUvI=;
        b=hwypctY5jEKg3FCWBaFvZtvgzLpItHIcJCw3MyvpFSC7/d/kNMoMlvsJJF1L8IKiDZ
         IzbqHntyyDDFy2Ro/JOVrMetmtwlDDQu5nHM/+ucByvGE1xnsk/08nXg0cociwm/x7Na
         THNp8jdQCOwyt5CHWEvUiDMydU/k0UE8cxkqAaw9Jwqc/X/pc9LBENDdde3mbUtsW4Ih
         eOlnaEw2jwv+fNmf9XsG14yNmqAc9geAIgpja4OtKxMcat6FqikwcMTBGdSU4R8lOjHx
         lxW+KAjBCeOqMjLq9tc/hXnwJI2qQq014O4IjCfay+122pNfjhS8ePQSHDOBAu/krY00
         0hDA==
X-Forwarded-Encrypted: i=1; AJvYcCWUj9ybVVgZQYkXfE+ZU3OmeOKS7T77uqQvZfWo/aMGvI39lmSgi2yxp8FKTOOIVNwdKveGFOylcssyZehiPeuFfLNhJWGcELmYbaDG
X-Gm-Message-State: AOJu0Yx6iSd5hF7WaSEitPh9xqj9qTR4mDOco4Br8AMaG1PD8S0d4hMW
	hLYoe6TzdQEZvqGks+sCUxGW08+e56WOjNMoFFMx+i0nWkJE+2Trj5g1FPHg4HI=
X-Google-Smtp-Source: AGHT+IGhBE81nPEf+chevVvQz+h7t1vDmYCmTB+TvBshethkzppVWVqOetGXmNDfcMP1hD40qGV/8g==
X-Received: by 2002:aa7:cccd:0:b0:565:f7c7:f23c with SMTP id y13-20020aa7cccd000000b00565f7c7f23cmr1075740edt.3.1708939428224;
        Mon, 26 Feb 2024 01:23:48 -0800 (PST)
Received: from [192.168.0.173] ([79.115.63.202])
        by smtp.gmail.com with ESMTPSA id q4-20020aa7da84000000b00561c666991csm2162886eds.73.2024.02.26.01.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 01:23:47 -0800 (PST)
Message-ID: <40691b0e-864d-4818-9fd0-338bf750f46b@linaro.org>
Date: Mon, 26 Feb 2024 11:23:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/39] dt-bindings: crypto: add sam9x7 in Atmel SHA
Content-Language: en-US
To: Varshini Rajendran <varshini.rajendran@microchip.com>,
 herbert@gondor.apana.org.au, davem@davemloft.net, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
References: <20240223171342.669133-1-varshini.rajendran@microchip.com>
 <20240223172358.671722-1-varshini.rajendran@microchip.com>
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20240223172358.671722-1-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 23.02.2024 19:23, Varshini Rajendran wrote:
> Add DT bindings for atmel SHA.

This would have deserved a better commit message, I (we) spent a lot of
time deciding whether this is the correct approach.
https://lore.kernel.org/linux-arm-kernel/342de8f3-852f-9bfa-39c4-4d820f349305@linaro.org/

Anyway:
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> Changes in v4:
> - Updated Acked-by tag
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml   | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
> index ee2ffb034325..d378c53314dd 100644
> --- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
> +++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
> @@ -12,7 +12,11 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: atmel,at91sam9g46-sha
> +    oneOf:
> +      - const: atmel,at91sam9g46-sha
> +      - items:
> +          - const: microchip,sam9x7-sha
> +          - const: atmel,at91sam9g46-sha
>  
>    reg:
>      maxItems: 1
