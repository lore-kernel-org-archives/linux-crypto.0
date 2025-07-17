Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F421D7E42
	for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2025 08:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752741934; cv=none; b=ev4p+TRtIpW8NtVNTAhtWNm7OkSHmujC6ZiD+wVcW8a7QFJgSezwVf/4NtECefp8TILOCzjCUjwEpWBqNgzA1FNkzWoHQ/+IN9mbImUpt5GyD/OVtTzoIkW2s/v78pnuyh7/v2fbNezmBWDs3MDAiaAqvzzD8756ftIRibxF2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752741934; c=relaxed/simple;
	bh=KeBoICQi5vCriX+lE0bMVyU8SmgjFFfJAbuXSXLwOvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXES18/SN7de0ovJi89i+HviB9fQQKC/w9UvFmElqYC22IaonaGOVs/E+tinSZiy8SYs0SWQH3zvHH68nCw41NppJ8TF/mvG885O8uMx5AMypwEkj7NV/fwYyAtC3epE8w+e3mEoQqqpAYME2yNmf5Zzxfq7y/Lvtyczi0vacP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z9p5phMy; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z9p5phMy"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b49ffbb31bso390103f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2025 01:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752741930; x=1753346730; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lI0pEfmVhQWkOv8EPGMn/xg7zISwfZGg3TSb4XZEXe4=;
        b=Z9p5phMyeHNhIDU3Bgy2gPhCpHerknLxBYm7WCG/LwPrxjMpI4USLbCyaOjiVnN2Bc
         0akJB43+4J3uta7FFI0j6VAD1cP64fyKo/TvC47bs35lBzsSewyivPQegM6s9TIKd63z
         zLB0zu4ZpRlUhXJHIcCrIoDgY4BSLNerw6TUyhoKJeJMG21cVl/AazO7JVwTdN92tt7v
         099tssRKwqNSXSCtTIWnjJPEs728HkTSydhzSa/WbaKLaFxrfvfE+FWEOlo2CKKsRJqK
         XTw3F5eThczER5JNuWtg/B8Qf9LF5GvqrgYn4O2CPnmm9LqxPQNtQaAJIFAaheUVJEwl
         x0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752741930; x=1753346730;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lI0pEfmVhQWkOv8EPGMn/xg7zISwfZGg3TSb4XZEXe4=;
        b=XLCEI5nE5Tj4FCtdqPLhCB6joVFBv8Cl/DtYGbp7SClx2XL6fSw+3hKLzJ3F3nrbF5
         RsHuIDFcwrftPSosp+5I2Orn2pBkMJv7cGDt1KHVY+8ZR0+7pJULlkQVot+TTOoHjdCl
         NYHntpXah6V91LheesKR+ABoiBpFRwzHNzOORi69wjlkUyGAVYdtoR2ShqYzpGDvk+/d
         yWR/ebGqiX3WDXBZwPjjgjkYmerhStH489jAOkABesdkvDfJ4rrFtyqLSCugvXOCV+s6
         rST33x4TY6Y/Ciro13Of1nIhBu9WB3DgyXlJkr3ZGgAj9SqYTyw081QhXIqhcWFSEHMw
         xmBg==
X-Forwarded-Encrypted: i=1; AJvYcCXPU/3lKlw2E4Hyd+sOZrPkLwRKXRq9WrAE/l23o7ViUfoLu9JV5LOtib2b3z6VgwdQGn65Wgj0af4chMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXmAEJ8caYOgWXBnfm1jJr5ow1mrNtXOpQZdMTjcYIKzvmTwbH
	Fyq4wlR5ZLkqFQ1MVX9CCUQfgx2YSX/JIpp0v8x2UXOp5hzp3CtMnKRLbx+S63awXwU=
X-Gm-Gg: ASbGncv+P9KVmq1tUqwxepMF640Wgr0C38VDeAOHU52KYM6fEw6xX/LCRca348DhfdU
	QtO08/zhen9KgOjywCa6MTEZgWXjKbtU+CqsazNv8kixXGGeJ+R3RgXnFTZ/2RSqUqVaL8u3TRu
	AwG2EN1D0vEChRLxAXv7K2koMNCrjD8n2f/XeslQM1pUZnunQtko2+oylLUMF80opFIQdPLdOOh
	xmGE+fAJP7iiUz3Mv5U8RFe4h8rXWboufO73nAqsGN9Grl5VlJM4gyVmDoiJaXW7Xgm95ar1mTU
	SshPIDdv9vup4SM6EKkeUgaIZjf5iVZOOWBEzU3zpTeXsXScgezAZARlylRlRb9rv9jO5/H8BK8
	x9vjax4Q27NaX6m/w9dIqxy8Z3T5+ho4JO2kQen9b7ueZjAdIdWUY/GNSZRe2R7JpnnCX8kPGBx
	Sa
X-Google-Smtp-Source: AGHT+IHynfEiO6GXy/zERfnUna5/ILOl/Jpu2n8FLydUo9tQGpFN5rGKrkj6TlP/t2+2sNcZBF+q3Q==
X-Received: by 2002:a05:6000:250d:b0:3a5:58a5:6a83 with SMTP id ffacd0b85a97d-3b613e66eaemr1561801f8f.13.1752741929767;
        Thu, 17 Jul 2025 01:45:29 -0700 (PDT)
Received: from ?IPV6:2a0d:e487:37e:ce58:94c8:a752:de4:96bb? ([2a0d:e487:37e:ce58:94c8:a752:de4:96bb])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-45634f5cad3sm15783305e9.9.2025.07.17.01.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 01:45:29 -0700 (PDT)
Message-ID: <d1e84ad9-eeea-4d0b-9f29-1dd4be49225c@linaro.org>
Date: Thu, 17 Jul 2025 10:45:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/15] dt-bindings: thermal: qcom-tsens: document the
 Milos Temperature Sensor
To: Luca Weiss <luca.weiss@fairphone.com>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Robert Marko <robimarko@gmail.com>,
 Das Srinagesh <quic_gurus@quicinc.com>, Thomas Gleixner
 <tglx@linutronix.de>, Jassi Brar <jassisinghbrar@gmail.com>,
 Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>,
 Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
 Ulf Hansson <ulf.hansson@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-mmc@vger.kernel.org
References: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
 <20250713-sm7635-fp6-initial-v2-8-e8f9a789505b@fairphone.com>
Content-Language: en-US
From: Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20250713-sm7635-fp6-initial-v2-8-e8f9a789505b@fairphone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/13/25 10:05, Luca Weiss wrote:
> Document the Temperature Sensor (TSENS) on the Milos SoC.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>   Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
> index 0e653bbe9884953b58c4d8569b8d096db47fd54f..94311ebd7652d42eb6f3ae0dba792872c90b623f 100644
> --- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
> +++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
> @@ -49,6 +49,7 @@ properties:
>         - description: v2 of TSENS
>           items:
>             - enum:
> +              - qcom,milos-tsens
>                 - qcom,msm8953-tsens
>                 - qcom,msm8996-tsens
>                 - qcom,msm8998-tsens
> 

Applied, thanks

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
