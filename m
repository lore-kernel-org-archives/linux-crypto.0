Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE53221D92
	for <linux-crypto@vger.kernel.org>; Sat,  7 Jun 2025 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749296516; cv=none; b=rAuvCsguOSzfFk89eQVfQ4QXg3ssBCwQa75OEwiSLKBiXQ76+fChh+evqNKFZCT+wEDyz6TDUQRaqinfnohQd1OE8Hrlbd/oNx38wwH3NSnb5ruyOy+70Fw5aW8xrTzpGdMmO1nRXBVkw7Ruu1HKY/i8k5fUijf0tlAo7XTVg9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749296516; c=relaxed/simple;
	bh=n9BLRiYHp/pW68m9cNwDmNZcQuNo9c+EYcVWkQCKl/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B0TiybHs64idmJGNnGi5W15GELNzRy2uhL3kGZSM3VVsqQuWeI5JiwlEPywQBmPJUZ7zMgSM6qHSzFRVs7oCYEZ1NTuHOd59frc808QgFmBQsbWuJnsonGNyTyH8R2NWc6jsSniY3l9CHV85Lw/qfGiiH5z0xK5rH6E8ZXVLvz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=N5Ss5/xf; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="N5Ss5/xf"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ad8826c05f2so542266666b.3
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jun 2025 04:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1749296513; x=1749901313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hHhYe6pzYBYGqwKCCAoMr63vtu8LUhyKvXIdPxuXhzg=;
        b=N5Ss5/xfQFbF0pfSdsUliAuW1l7OXrya0ipva4o1vQ3+MeQntkTc815PRK4jP+XkyI
         pj3EJnEPgiHhpfSxwVJbLUsKEb1e0V9I/Meg+kJLlyift3dw+pL8rTN/v1SJy7SQMvdb
         19LKmZiMQPLzNVHV8uxS3gzQpWAkfgcA++ITseCxYyf7kZHgVX1xrHWfSsTAT9lpQb3y
         gnlxZ3cQH/kEMuR+5rPSR26yrJnmIDfcLoFEbtPBEHK7A/HlkI0isdy5WTRpmYQL0qEs
         OFhN8hA4aKOssKzc17b/pIlC0ZC+knexq3f1Vq/Znl1QQ24bVGUJ1zGYyB9lYtu90dOt
         OfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749296513; x=1749901313;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHhYe6pzYBYGqwKCCAoMr63vtu8LUhyKvXIdPxuXhzg=;
        b=QukOfruNv3hpQIb3f/W68fPHlkGSbwbrUn3RU8c+5ErHLm+DfYRvQd/s8MgRh6iczR
         0ZpvAv+h0UQZwsSOFD2Y6BrCb1DlO27OZO0QiNKL0tzb75zkTfbhY8+NCp+b55b+BVY1
         WJOd9al3Jn+hbEjej/nVZArzroUH7NoaXgBF0QkADvfJyEB8bpje7AktznbHGIhYWVoJ
         4xfZ/lYpOfb41lw/7JRuhcJnLMYlOO8n+vdf+Z3XnfK54eT8d98k+RsiWJ+tfp1dzpON
         vJa1J4u4lCATvtPdWmQUmw4K61fBvj7ztmYUoL4h3oZMbRIAmBbNbJT9UkUkCVZrKlQK
         NlEQ==
X-Gm-Message-State: AOJu0YzvDrmKIH3qsYu1i5D+4kskqbXu9nQyiRKGyurq5uWwjjH7hnnX
	A95l5bzLGHxprYUXnZ0+uKLaxyuASApkHjJ7wDouRqaAJqB41UAwLDHKGS16KFMQJKY=
X-Gm-Gg: ASbGncuvBrymGUcoRxK2fXANSW1maJf1z9TfMuABEqC9vMw8rWqprddFv/0NrmYHf+x
	4aekYlaSsoFpeF1ZBgku/5rAlVDOqGqdSG/Zbgxvh3Z9aq/k71U0kPmw1ECsX6XAoJmLE6CTOAR
	YtBzVYwxh6Ek2b7pJC3KRF2kFB+bzLqXr+QcVa9qWSjfK1hQO6TaGTzAvudNXQ5LxWNGPOyZ6fZ
	YSSkjFVvV/dmt+g9ValvukaZrpxdOXRCTGyfh+/wFKV7f3M9n6KOiYpxmoTw9ZUAhg6dw8gmkkF
	vBQTlliyD8fZuf6IC5OdU0PCvrrdEu5qwIXXMLY0plIfpXtbZ8uEozRqwztKUIl0XQZQiKw=
X-Google-Smtp-Source: AGHT+IEHOrHRiEO3rlu+EznwzAVzUrSE49TkufXjg7ZU/CfkAver/3Sye31MfxSallpfyQfqoyrzfw==
X-Received: by 2002:a17:907:7282:b0:ad8:9c97:c2dc with SMTP id a640c23a62f3a-ade1a9fcf5fmr648072866b.15.1749296501262;
        Sat, 07 Jun 2025 04:41:41 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.126])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade38c11d28sm137366866b.12.2025.06.07.04.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 04:41:40 -0700 (PDT)
Message-ID: <84184dc6-2f6b-43ae-ae44-c081b8d510fa@tuxon.dev>
Date: Sat, 7 Jun 2025 14:41:39 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
To: Ryan.Wanner@microchip.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, olivia@selenic.com
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <68e45a56e70e0b0b001870905917e8f7ddac61a3.1747077616.git.Ryan.Wanner@microchip.com>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <68e45a56e70e0b0b001870905917e8f7ddac61a3.1747077616.git.Ryan.Wanner@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12.05.2025 22:27, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add compatible for Microchip SAMA7D65 SoC TRNG.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>


> ---
>  Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
> index b38f8252342e..f78614100ea8 100644
> --- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
> +++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
> @@ -24,6 +24,7 @@ properties:
>        - items:
>            - enum:
>                - microchip,sam9x7-trng
> +              - microchip,sama7d65-trng
>            - const: microchip,sam9x60-trng
>  
>    clocks:

