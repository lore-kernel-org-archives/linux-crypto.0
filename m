Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D30939FD1
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jan 2024 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O79X0DzI"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-557535489d0so3553418a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jan 2024 07:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704813711; x=1705418511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bj6NDQcUdJldid13ftpp0zM4/H4UFixWiFSBodj1jj4=;
        b=O79X0DzIxEVawPKCP++DlxLc099f9TtVHLfqLH1oukFGozRx47/7pPeN9BKlfCJ6fs
         rgchRTUTzXLRZyDZinXtYHKg28xN/gza9fO6PeFrnbGBVMDfDuq/6qgFODdCSjqSU+GK
         +JF5o7mtcbgfiANXigK6eT4QRyk/y+62LfUnkkOefOpO8tbIp3tFz4qV1kMwHJ1GilLs
         Mf3xi5ykbccwuvnLRF61kJCkaw6xgSAifAFvSXcXckLUV5/RIwXXwuvz1tO1HbwxwdrW
         4oScdAiW848yde6YDxp3ICsYVh0SDZ0jmihEJxFY7Gy1G3doSTk4Pl+R/jaDaSP1xjX4
         A+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704813711; x=1705418511;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bj6NDQcUdJldid13ftpp0zM4/H4UFixWiFSBodj1jj4=;
        b=XF7tXlHVkkwuKrTw5Ylq8a1lrIXHWut5AHP06rMYzu7JM3zApe4KIQBx7LvFZ3NZ3C
         SPUkDkH5+g5gL7pbnN3EW4IvhAd7L4BGz2gipPf97LVO1WJTqKbggA0SraRANO96sI4j
         LVDDHOVhFgLX+CtZNgBywr23457L30+jFEpKNYjZ2b5OCgXkVUyh0O+EwT9lrqTKz1Z5
         MGviTyjSLyHtBZ0UVgPWZgJBEcza+2RV9YRaPs/vtCrFFjjUNcLW3yGH43Z9ccvFR67G
         p3LHPR+sZBTdh2GR+m+HH5shE/C7u2BPQ2AB/ZUnl99zN/zKQEqXo+f/vhEWvri0AAIQ
         Zntg==
X-Gm-Message-State: AOJu0YwNSZ18lws5y1bczJpWFDauWYqLFqmcDqSHmysXPV93UEdTGL+Y
	sPnYjaCakVeYscC4xKoUPIJp8PL8fPYhCQ==
X-Google-Smtp-Source: AGHT+IEtj6/VJROwfg+XweGIBvNmcPlD9tcYc0YZtIMc0fNzc23YXJ/6Ri7aeDvRYAvhx+V8SM4p+w==
X-Received: by 2002:a50:baa2:0:b0:557:368d:e028 with SMTP id x31-20020a50baa2000000b00557368de028mr3315873ede.59.1704813711370;
        Tue, 09 Jan 2024 07:21:51 -0800 (PST)
Received: from [192.168.1.20] ([178.197.223.112])
        by smtp.gmail.com with ESMTPSA id g7-20020a056402180700b0055706e6b1f5sm1067613edy.89.2024.01.09.07.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 07:21:50 -0800 (PST)
Message-ID: <d9a1695a-3747-4fb9-b76e-c2599266a3c1@linaro.org>
Date: Tue, 9 Jan 2024 16:21:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] dt-bindings: crypto: Add Tegra Security Engine
Content-Language: en-US
To: Akhil R <akhilrajeev@nvidia.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
 catalin.marinas@arm.com, will@kernel.org, mperttunen@nvidia.com,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, krzk@kernel.org
References: <20240109091708.66977-1-akhilrajeev@nvidia.com>
 <20240109091708.66977-2-akhilrajeev@nvidia.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20240109091708.66977-2-akhilrajeev@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/01/2024 10:17, Akhil R wrote:
> Add DT binding document for Tegra Security Engine.
> The AES and HASH algorithms are handled independently by separate
> engines within the Security Engine. These engines are registered
> as two separate crypto engine drivers.
> 

...

> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - iommus
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>

This does not look used.

> +    #include <dt-bindings/memory/tegra234-mc.h>
> +    #include <dt-bindings/clock/tegra234-clock.h>
> +
> +    crypto@15820000 {
> +        compatible = "nvidia,tegra234-se-aes";
> +        reg = <0x15820000 0x10000>;
> +        clocks = <&bpmp TEGRA234_CLK_SE>;
> +        iommus = <&smmu TEGRA234_SID_SES_SE1>;
> +        dma-coherent;
> +    };
> +...
> diff --git a/Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-hash.yaml b/Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-hash.yaml
> new file mode 100644
> index 000000000000..7fb32568756d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-hash.yaml
> @@ -0,0 +1,53 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/nvidia,tegra234-se-hash.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NVIDIA Tegra Security Engine for HASH algorithms
> +
> +description:
> +  The Tegra Security HASH Engine accelerates the following HASH functions -
> +  SHA1, SHA224, SHA256, SHA384, SHA512, SHA3-224, SHA3-256, SHA3-384, SHA3-512
> +  HMAC(SHA224), HMAC(SHA256), HMAC(SHA384), HMAC(SHA512)
> +
> +maintainers:
> +  - Akhil R <akhilrajeev@nvidia.com>
> +
> +properties:
> +  compatible:
> +    const: nvidia,tegra234-se-hash
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  iommus:
> +    maxItems: 1
> +
> +  dma-coherent: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - iommus
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>

This does not look used.

> +    #include <dt-bindings/memory/tegra234-mc.h>
> +    #include <dt-bindings/clock/tegra234-clock.h>
> +

With both above fixed:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


---

This is an automated instruction, just in case, because many review tags
are being ignored. If you know the process, you can skip it (please do
not feel offended by me posting it here - no bad intentions intended).
If you do not know the process, here is a short explanation:

Please add Acked-by/Reviewed-by/Tested-by tags when posting new
versions, under or above your Signed-off-by tag. Tag is "received", when
provided in a message replied to you on the mailing list. Tools like b4
can help here. However, there's no need to repost patches *only* to add
the tags. The upstream maintainer will do that for tags received on the
version they apply.

https://elixir.bootlin.com/linux/v6.5-rc3/source/Documentation/process/submitting-patches.rst#L577

Best regards,
Krzysztof

