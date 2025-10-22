Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42383321DB
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 11:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761132277; cv=none; b=T+S7tkHHGtndYRhzuzotauPZNmU24Yn49cMNPLbq7H/6q4uZiFebdhyHR28BQO+U4TUZ7enNpAGkCpMZ43vYbAcVXf96DtaMCSYBsa1HdESG02EwE9Fkuy0fFX3EWf2FG+Xk7K7T0oN+/HS532dv6ZwCdqgmLo1wQVF0yZr1q28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761132277; c=relaxed/simple;
	bh=4D8tvphMGIr2s84sTEq6X1ry1GAv1OlmyNqaGX6YgUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nZyrI+KgHKf+tldraYJ5EbJz3Ja7CcpFoPlqKMPnxcbaUxI/CcMuyy4fVc9Xi800/BiJXcnZLiP6/z0sAYiLj6kyb66zfEjwwHIbKZHUDqsJS7BHMCxAynlyV/gyD3OKZ9gBPKbvEXGvFGvxy6GalyadSgJlvu7CXlTbkywQ0vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gK4c788o; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gK4c788o"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4711f3c386eso34929895e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 04:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761132274; x=1761737074; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NE6ALi4oCIm+yd7a3yOvtFqmufCiCdrMy/7EGT/KVX4=;
        b=gK4c788o2dUERwLeI5fVMForfuiRyVpYluEl/tRSkBoSWiDvE+fhYQHMY4v1RDEHmW
         Pn32t2Z9nrd2ltd0HzveMoV2j44OKM2spAJpQ/kTqrqa96vwz8mjQrHD6yztYlXqy0ek
         UZOiaWSWatF3L5vc7Yq8Shupkx8yzWitt7geBvedGjAczs5gM5KbSAmMo5EPGFA0huQt
         H+ED/Uy9kyRKkag3A5Iu24SLNSwT+4QWusL8lSpn+m86vQHp11JnLcL+XYAHQtTL2k+V
         ewP+h2jtRFI+U9PrZhDMfo5eEyK2v73AAd6S0ZGQJtGgZccm4VWQ9vlhRmuhFsxFzJF0
         p7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761132274; x=1761737074;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NE6ALi4oCIm+yd7a3yOvtFqmufCiCdrMy/7EGT/KVX4=;
        b=S3SisExN+us9qY7vRGODss3yqA0Y0qZAsuP/xVApbLNF7BNIlCZBBzxBeIe6jJJcO1
         y66dFBZXIoFYwpdP5m9xTO8Q4Gk1f6LO3u0q6cvID4DN3w1p6HKYlNy+P7ikV6JV4AjB
         Oz5HIKBz5S/v1JjdGFGDxDpgc1ttuzBiVQm+hrVZO7TYjIebsBLbQet2NskCk5guYJ5G
         V4s4Pyw6O4sXyJDXDy6o1ijVIV2SCH6zF4N0hTomuBgteLbTmxm/Bi2D8OKfw94uZNR6
         GStFdQNEvxfsbKj8T0Ksc28ST4achFJKL09URdghjyAYv9vkV2NRbD64QWQcdynooR5J
         cohw==
X-Forwarded-Encrypted: i=1; AJvYcCW2KWuKbIG/bA22yQqksTE/ybkPk0mWm1weqgPwF1W0ENkyqciaKzjNIzw0PtWSdhMs+aNGdUiLMQN3Y5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzngmoktgULdYIsH99iYu2arJWsuzFi7kcgVwqAY9hmFEESbQKg
	2GlpA+3jzyNPkO2zUOii87BrkI5VILBj3wOYgRrwIKdbw8WACpVn3H/f3Ekw55jiO14=
X-Gm-Gg: ASbGncufk5I/rCTYel2lwEl1Xdcu4yDU1MspIAdTC1kC5lf02S1s+opRBvQ8QP7txyH
	4AK0hT+YeIv1uj1+/7pdDA8NlwHi7ws4iR2kHZxWlhiEnypg/7vSeYY7kZzb8HYtA6k5puZRuBx
	lXTdQb2sm5QaRLEIKjGLzeDoDj90PbzTj7YidpXabCPAIrhsoEMMT4TBJDs1dbJ0bqcIUZ35E2k
	Hbg1yrL0Fvdd6CXUAJRnGPlWsMEdm5669eqgDuEXOx6X1GQd0gId3HjwnOnpaU+Ms8ShHA/R+Iw
	3NEpt3/QZTXN8f4iHSU2aSe/Tner3gvaDJvOtUHw0zLui7qDNJrzaz2pya4C6NBAjdLVAuHZjNd
	MEyNcmTeee//EP0ptxUYJJwluSkIY61ZUXCkNirH+7xn7TJ8DEO9B3a5Z9BGbf3XRRtoRsKKItr
	YeAF6etUk/EwGqCmZc1VM=
X-Google-Smtp-Source: AGHT+IFHudZFCqpsdF3BziLjxKHgkZc7fTsjSbocAq1uyR2DAIJq/pryZEZ8IbOeeE5y3RSm6MSLNg==
X-Received: by 2002:a05:600c:3e12:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-471178a74demr147513535e9.12.1761132274047;
        Wed, 22 Oct 2025 04:24:34 -0700 (PDT)
Received: from [10.11.12.107] ([79.115.63.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428a534sm45864405e9.6.2025.10.22.04.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 04:24:33 -0700 (PDT)
Message-ID: <61813f89-3015-4fdb-a182-5c4159f7bb1e@linaro.org>
Date: Wed, 22 Oct 2025 12:24:31 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] hwrng: exynos: enable GS101 TRNG support
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, semen.protsenko@linaro.org,
 willmcvicker@google.com, kernel-team@android.com,
 linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/22/25 12:19 PM, Tudor Ambarus wrote:
> Hi,
> 
> I propose the bindings to go through the Samsung tree as well so that we
> can match the compatible with the schema when pulling the DT patch.
> 
> Thanks!
> ta
> 
> ---
> Enable GS101 TRNG support. It works well with the current Exynos850 TRNG
> support. Tested on pixel 6 like this:
> 

the commands started with # and were removed from the cover letter.
I fill them in to avoid a resubmit:

# cat /sys/devices/virtual/misc/hw_random/rng_current> 10141400.rng
> 

dd if=/dev/hwrng bs=100000 count=1 > /dev/null> 1+0 records in
> 1+0 records out
> 100000 bytes (100 kB, 98 KiB) copied, 2.03619 s, 49.1 kB/s
> 

# rngtest -c 1000 < /dev/hwrng> rngtest 6.17
> ...
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 1000
> rngtest: FIPS 140-2 failures: 0
> rngtest: FIPS 140-2(2001-10-10) Monobit: 0
> rngtest: FIPS 140-2(2001-10-10) Poker: 0
> rngtest: FIPS 140-2(2001-10-10) Runs: 0
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=380.570; avg=385.422; max=386.964)Kibits/s
> rngtest: FIPS tests speed: (min=75.092; avg=81.784; max=84.771)Mibits/s
> rngtest: Program run time: 50908949 microseconds
> 
> To: Łukasz Stelmach <l.stelmach@samsung.com>
> To: Olivia Mackall <olivia@selenic.com>
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: Rob Herring <robh@kernel.org>
> To: Krzysztof Kozlowski <krzk+dt@kernel.org>
> To: Conor Dooley <conor+dt@kernel.org>
> To: Alim Akhtar <alim.akhtar@samsung.com>
> To: Peter Griffin <peter.griffin@linaro.org>
> To: André Draszik <andre.draszik@linaro.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: semen.protsenko@linaro.org
> Cc: willmcvicker@google.com
> Cc: kernel-team@android.com
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> 
> ---
> Tudor Ambarus (2):
>       dt-bindings: rng: add google,gs101-trng compatible
>       arm64: dts: exynos: gs101: add TRNG node
> 
>  .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml       | 10 +++++++---
>  arch/arm64/boot/dts/exynos/google/gs101.dtsi                   |  9 +++++++++
>  2 files changed, 16 insertions(+), 3 deletions(-)
> ---
> base-commit: 8ebc2add3e2d076adc5cc3e8c9bef268f7f1cb31
> change-id: 20251022-gs101-trng-54b710218424
> 
> Best regards,

