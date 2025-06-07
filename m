Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200221F5413
	for <linux-crypto@vger.kernel.org>; Sat,  7 Jun 2025 11:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749296452; cv=none; b=bAfVOy5R15Zb+FiUOS1WGPoI7c7b7I4GorQBLOudKf6JfgTLSkB5QKuR5DG+u8S2eG65x7WbutRxDx8TdTBD0qzTiH1yFXiTkgZgXULjinQpidocL9AFFzW7r3rqFZmuAR/NQpk6js3C5x/xLk54/41gC6r+A+WffQDNhHto7dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749296452; c=relaxed/simple;
	bh=ubJJtE7i8YMPz9SRvgygJqN81AJ/lnwSeX3JzR7GieA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUeNSRgShnJIGSrYitUUAsBLYYcT9K+IYn/S/MckN5ZxlPvWHy8kWp9rsCWQ9oBp4p/2PYg8nwKrb0Q2XevJWcfnfOF9hZRSwK+Nq7Zo/9I1qakF5tXqsGlQ3dzFtdMcKS1XAZLyU50VOJdr+hOiQc4RxKNkFx0KIa8sAGf4WRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=EzkfRxVu; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="EzkfRxVu"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ad883afdf0cso554379666b.0
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jun 2025 04:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1749296448; x=1749901248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JiKPxyE+L/mL7ntMB6eAW2AGGkAO+xZvdmfN92Ddt1o=;
        b=EzkfRxVuzuJi3pL622gzlOW9f+US+z153IKlduDkd2FOWJp6wK7e33ej7Ljvk9niIY
         +MWoRwBLv3mmE8awEfIVyjrCFtimM7gBo/Y+ZpMCyBVOTFut/yHiNF3K8seYaGFyYi2c
         Ms7C4oJ8+IfvT5PScg0QtoD+/VG4p1hyd9BB9cMcHbwEKp3LkvAhs6OgWyux7IQaFVd5
         dS2YfT26JulgirJyW+z1w+CfQ5o2JSHhDwffSVfXlAHrtZ+gc5KX6vfA5nUfsW2/Nw/s
         /zDAPdyNu4ZpETD5q2eiDXfO06BJC8/nlOvKFb344ZIMagnnAYxRQsD8m/fp42pBhz8B
         LkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749296448; x=1749901248;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JiKPxyE+L/mL7ntMB6eAW2AGGkAO+xZvdmfN92Ddt1o=;
        b=Y0RFyfioT1BNO+djUCzEAO9GLTFUWiCclzx9GIvbH6hZdgS9nyERfJG0XKG8cxUJ6d
         r+QkQJUuNKxzv7mumb+i9hvEjmqG+CyccRkv23LV8E8gK7+MySMz4y+T5nMRuPKTQQoO
         XZDN6yi82ousApeNRJc6HHYsPVa6E5JY78nedqKrr1EQhdihPmR9k2g8AK/qd3456DJz
         W2MVsAglveC3ZiBjvaB79IUY7ibdV75uMVDLMYltkBMORvmvx4aqbO5hrAUS3FnNOjuH
         RCLzh0MaVQ2WvL1IDZdi7nctbFawEMqK6/S56cpOOkUHNjXbcygJnHDA7AfU2KsU2hvw
         Vemg==
X-Gm-Message-State: AOJu0YwmtmwPTLnhOK+lgOZ8g0Qlnsqmc5l5vwXujFOXFx6fvo9Sb22j
	7FNUsv/331KjFZCNOFj20cZ98FpDHq+8IklMhdyBo/XFUZflO5WjnUPjuO9zc18uLhg=
X-Gm-Gg: ASbGnctZ+Y4nZRke9G8NkNg6jCTshEgaRSZ9SwO3a4QXRXe/PIcy2RCcHoUArMW9m1d
	LBP6+s7/rLTWIBUTK21ZjTOs7SObZiYkZO+4HOL6TcwsT94IzQtJi+gBWKuHU8nMXNsoqYiAYKd
	IeA4zZX4nqQbJLZ8hqJYhnc5kRBi3qwyl/AAmiPTB2QPU853oSYtfesXotc76TB9vr6kuafvQVc
	GywtidCQeqFpD1zX8339jTk1RFFVKYhVIK5IFDXv3SP6FhiPoILg9og6LnV/Vo4RZCKxann9ks4
	XhBuKOxf7eiSTMwS2RNrQHTZ6215dl6hxtcMg2vg+PqUVfCuo+auOYCnG1RuO9heH8tDZ1kpuwF
	U95/1EA==
X-Google-Smtp-Source: AGHT+IFH+/W+aC/DziM0dgJNs2fwK23eiIJdn/dAFXAJM2ZH6flXjX0d+7niB19viLz/Kl7VwDI7TQ==
X-Received: by 2002:a17:906:ef0b:b0:acf:15d:2385 with SMTP id a640c23a62f3a-ade1a9fd850mr693582666b.16.1749296448424;
        Sat, 07 Jun 2025 04:40:48 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.126])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc7b3b6sm268238766b.173.2025.06.07.04.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 04:40:47 -0700 (PDT)
Message-ID: <f03c5c49-e890-428d-9c5c-649bad512170@tuxon.dev>
Date: Sat, 7 Jun 2025 14:40:46 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] dt-bindings: crypto: add sama7d65 in Atmel AES
To: Ryan.Wanner@microchip.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, olivia@selenic.com
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <a5509576e211bcf528e088f78e619575a26bbd8f.1747077616.git.Ryan.Wanner@microchip.com>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <a5509576e211bcf528e088f78e619575a26bbd8f.1747077616.git.Ryan.Wanner@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi, Ryan,

On 12.05.2025 22:27, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC in atmel AES.

Would be good to improve the description here, e.g., specify differences,
similarities b/w SAMA7D65 and SAM9X7 or SAM9G46. Same for other similar
patches in this series.

Thank you,
Claudiu

> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml     | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
> index 7dc0748444fd..1de4ee70a05f 100644
> --- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
> +++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
> @@ -15,7 +15,9 @@ properties:
>      oneOf:
>        - const: atmel,at91sam9g46-aes
>        - items:
> -          - const: microchip,sam9x7-aes
> +          - enum:
> +            - microchip,sam9x7-aes
> +            - microchip,sama7d65-aes
>            - const: atmel,at91sam9g46-aes
>  
>    reg:

