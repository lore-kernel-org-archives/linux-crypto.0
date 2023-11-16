Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qoOcWce6"
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CCFAD
	for <linux-crypto@vger.kernel.org>; Thu, 16 Nov 2023 06:43:00 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-3b6a837a2e1so505538b6e.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Nov 2023 06:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700145780; x=1700750580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5dkiDOD0edMHc6i19uEv53Dbvkb1NCyGOSkmTqkZ2w8=;
        b=qoOcWce6j5Y25SebhJINMYwA6+bLrLFuExKQutFeyaFW1ykOGs7QAKkhKN/pBG5UX+
         Ka6WhQ3lUwZx5ipy8/CT/pSI17r64Lq6jZTM/zdA1bh0vy9fHtS2CVJ4HBvb81bEsZ//
         cpPF4CGdx38RrX7cS93DFExvI8AwwIaisKcnwACHlqQPPztnOvr9QnVfi/3pm8eKgd5W
         Phr9Z2hEEEP3bvpnjkBQjWjKik4L4Fxl+1pPenfHp/IchREMRRCoRWpkIzUWW4iyoJ7X
         x+IEcuR2NvJodAfev4aB8wGVmUz6RkKopqYeXtcVC1fSHRAaS9D6D4niZd6lo1mlC1NU
         S4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700145780; x=1700750580;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5dkiDOD0edMHc6i19uEv53Dbvkb1NCyGOSkmTqkZ2w8=;
        b=QuFIYlI5sIGd5gim5F3+aHE1BHqBUHV00WnZg+eZZMNCJE6pFV/MZe0wYpcIg6B5j+
         LzX4Q7WZzD2z4toE2DeT/rijFA/FF6mBtKjXClQkI/AlEOf9GlJTmMJTbErEJdbccd+2
         IgtZIQp3JyEYGMvPvXkr50SIpkaXunYEHDMpWrB0HSL+WsmENM00cDxiEZam34sYkEuC
         PAgRwQJ0KKy6Q5IrY1ylz+SnSByEe+xvKcC8SYa4c5YJ6Pl3OCsW7NhJxdwgesxEcSzv
         /ZpY3/tAJfpanM0gbfRcEtSxWa5eX6fXPMbb3ILXQnn4IfNLI34m360Xa8mtNNP7ILkZ
         owBQ==
X-Gm-Message-State: AOJu0YyAzeEUT5DRYHwEaFIZzkBwjQbCz9DmXwN/qiJYBosh1XOfpulJ
	pthm/pfJegd2nInB6pfTXoZ+kA==
X-Google-Smtp-Source: AGHT+IHfGUDJksX+0tKafsL4AYpamlQdbfqzvjOkxCaacxXW43sLD+zdxeuck9zaP1DCwr2lNjXSoA==
X-Received: by 2002:a05:6808:4449:b0:3b6:d04c:d9b0 with SMTP id ep9-20020a056808444900b003b6d04cd9b0mr20127533oib.0.1700145779871;
        Thu, 16 Nov 2023 06:42:59 -0800 (PST)
Received: from [10.50.4.74] ([50.201.115.146])
        by smtp.gmail.com with ESMTPSA id o17-20020a05620a131100b007659935ce64sm4290257qkj.71.2023.11.16.06.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 06:42:59 -0800 (PST)
Message-ID: <3f9f31e9-ead3-438a-bbd9-818b98ba1b3b@linaro.org>
Date: Thu, 16 Nov 2023 15:42:58 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: crypto: convert Inside Secure SafeXcel to
 the json-schema
Content-Language: en-US
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>
Cc: Antoine Tenart <atenart@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <rafal@milecki.pl>
References: <20231116130620.4787-1-zajec5@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20231116130620.4787-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 16/11/2023 14:06, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This helps validating DTS files.
> 
> Cc: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../crypto/inside-secure-safexcel.txt         | 40 ---------
>  .../crypto/inside-secure-safexcel.yaml        | 84 +++++++++++++++++++
>  2 files changed, 84 insertions(+), 40 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> deleted file mode 100644
> index 3bbf144c9988..000000000000
> --- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -Inside Secure SafeXcel cryptographic engine
> -
> -Required properties:
> -- compatible: Should be "inside-secure,safexcel-eip197b",
> -	      "inside-secure,safexcel-eip197d" or
> -              "inside-secure,safexcel-eip97ies".
> -- reg: Base physical address of the engine and length of memory mapped region.
> -- interrupts: Interrupt numbers for the rings and engine.
> -- interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
> -
> -Optional properties:
> -- clocks: Reference to the crypto engine clocks, the second clock is
> -          needed for the Armada 7K/8K SoCs.
> -- clock-names: mandatory if there is a second clock, in this case the
> -               name must be "core" for the first clock and "reg" for
> -               the second one.
> -
> -Backward compatibility:
> -Two compatibles are kept for backward compatibility, but shouldn't be used for
> -new submissions:
> -- "inside-secure,safexcel-eip197" is equivalent to
> -  "inside-secure,safexcel-eip197b".
> -- "inside-secure,safexcel-eip97" is equivalent to
> -  "inside-secure,safexcel-eip97ies".
> -
> -Example:
> -
> -	crypto: crypto@800000 {
> -		compatible = "inside-secure,safexcel-eip197b";
> -		reg = <0x800000 0x200000>;
> -		interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
> -			     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
> -		interrupt-names = "mem", "ring0", "ring1", "ring2", "ring3",
> -				  "eip";
> -		clocks = <&cpm_syscon0 1 26>;
> -	};
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml
> new file mode 100644
> index 000000000000..4dfd5ddd90bb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.yaml

Filename like compatible, so:
inside-secure,safexcel.yaml

> @@ -0,0 +1,84 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/inside-secure-safexcel.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Inside Secure SafeXcel cryptographic engine
> +
> +maintainers:
> +  - Antoine Tenart <atenart@kernel.org>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: inside-secure,safexcel-eip197b
> +      - const: inside-secure,safexcel-eip197d
> +      - const: inside-secure,safexcel-eip97ies
> +      - const: inside-secure,safexcel-eip197
> +        description: Equivalent of inside-secure,safexcel-eip197b
> +        deprecated: true
> +      - const: inside-secure,safexcel-eip97
> +        description: Equivalent of inside-secure,safexcel-eip97ies
> +        deprecated: true

Wait, some new entries appear here and commit msg said nothing about
changes in the binding. Commit says it is pure conversion. You must
document all changes made.

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 6

Drop

> +    maxItems: 6
> +
> +  interrupt-names:
> +    items:
> +      - const: ring0
> +      - const: ring1
> +      - const: ring2
> +      - const: ring3
> +      - const: eip
> +      - const: mem
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: core
> +      - const: reg
> +
> +allOf:
> +  - if:
> +      properties:
> +        clocks:
> +          minItems: 2
> +    then:
> +      required:
> +        - clock-names

Did you test that it actually works? Considering other patchset which
you did not, I have doubts that this was...

> +
> +additionalProperties: false
> +
> +required:

required goes just after properties:.

> +  - reg
> +  - interrupts
> +  - interrupt-names

Best regards,
Krzysztof

