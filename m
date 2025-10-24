Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8BC242D7B
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 05:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761285489; cv=none; b=oQU3adaKiUODQ4a2rnqDGoiOLyjwdRPU0cFRzMEyW/f9KdmcwM8A6e39be6WjKHI/UZP7COpEgkEYfXwVBy5n5HtqSWrRs0nHirLMoZA87SlSgarBQFwcGrGfNgFRZu4rAS/Cba3bdiWS+wKNpAZQuRu2QzFyxPdcCUluOUhxn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761285489; c=relaxed/simple;
	bh=NmsrupTRkisYQFGhFjZ0bRbIdltnfvRER/RQe8hkLqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HcjWVSxE/yHtKBxEqOtFl8fgKXQKGqs9yf0emChnbDqvyXJ+LDYmv+9eaMp8tFO2Qcp/rQ3+UwIy/QlWi7vRdshbzUNWPGsg6Ev+BlV+itiyznz3PwGA1yuTDaVUyj7vODg5CLs/eo+Lbd0XUiYvnBXYJCIA3zTcbJTiSu2mWs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PH5RI428; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PH5RI428"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso796050f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Oct 2025 22:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761285484; x=1761890284; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WlbgzRvJgE4Sx6EeAuF7s2GqiVQJOvGqllksow3opC4=;
        b=PH5RI428SNOsHpUF7L5WveuXG45u84EWGn778+3Wr8bMdv+wkVkqB49ktt4SK7xIHj
         Tncr5zM4G6R8tSxbmhiHD6juJAH2sQxz2za0S6PGE4mXwEaNctpDMKkn6STQASqJme2e
         pMIv19vxtvk/unKYgHvS5Dg3InBKAt9dmXDE2huuB1GxdXvdHTY8+tFrsNES3Rf382ae
         Kqgfv+/8L2sxsOqv9QtP2utjHEClW3Txz9Pup/PpINbpc/XbsbrLWgRsXHjyRAf8S1fG
         DbDFc+11K0EfswLo1VmQyR7wLkTmePf4g55KqAEzGPySCRFmcXzID++dMRKkWq8vhBoz
         FkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761285484; x=1761890284;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WlbgzRvJgE4Sx6EeAuF7s2GqiVQJOvGqllksow3opC4=;
        b=vYUUlxoOlvcDf9RbZF7f4ENMZTgI3X+fLASVMKUxWMghVJYshyyyxgy547BnDucb+1
         8WvvdSQQBoYjgbJyEOCPvb+jvBIUmm2gPJDARbXMIQWp8vsu33zgo66PoLKVPCzVEkKm
         OG/oxRVidGmSIwOjK3atVPqEdOvINFzbPOFPH9F9yLRT/GJwHYvy3KsEPnIRgfF/nrXU
         5/iSDa2eQ99CpsCmJ41oZIG+VgcWNZpH7bheRpIe1NnFK4KmyiMT0t9xlREdZ4LHeybK
         aq0jmaZ8xQXhlku/u6osKgs9h+7MDOAjxKZtK2TNRsYG7uj6fDKlgtKtSgFPRgiJPT77
         gAHw==
X-Forwarded-Encrypted: i=1; AJvYcCVJxu3npGSJyta4c3CEjOzL8E9v0leR80wK6xvTpTTikrqc8uO36ynmD+2sapsbB4GylavAkvmDALZd2rQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXtpwmkkOQrquCLyVAsRDZ3qtE7uEv2lo+rIVqXpFJIO67LMDb
	eLWHTeHw0dLKne7C8afase69m4aXTGVHGzCr+YQLFlx8S+eIFsqmkvCvwnX+RXSY2vA=
X-Gm-Gg: ASbGncvMaPH6uj3jzsfC2gzMParBVHlc0EsgeZWUM3con9RDGR3y9yopV5SVawX4tHr
	gW2yLq+q2x5bGz0UDm2EU0Qvn7xbon82DTPfAg/bSmikxPseqtSSLlT8c0xWswEKff7SHjuSNO7
	auu4gNbn+ihTAz2fIBFlkHcKTZmlQV5j9lnPf2WrOB0GdB4Zkw+0A+f0Q910uEZMXMW+BhCTLGl
	cHe96tr3I7+MIcrxesVX9gQHvI2kpwQkh7Tf9CYVkoguslDbj03qJSq4P+o6Bb+bqmYy8mBn+9E
	sK46sPpiC3LXkxALGow+12GNG2I9NV0/uHnq5L+8Z1MOTTmQ0e0HJaM99FfrtxKYkYYjxRYu7Pm
	kVviJs4MLSPGxiBpokilHJxB1HTXDN2yFGt+cl3J9P2JW+mGZ5aqyVzhcDrsu3/pn8p2/ru0der
	NwbN69H5cKHRucopIx0h8=
X-Google-Smtp-Source: AGHT+IF4FcOKkucmDNCM2/KKpneCA+i1yPeXTsA/LVynPTPJC5AXKg32KTh4dcKAlcjbp/p6c5h7Xg==
X-Received: by 2002:a05:6000:2387:b0:429:8d0f:e92 with SMTP id ffacd0b85a97d-4298d0f106emr1607568f8f.6.1761285484311;
        Thu, 23 Oct 2025 22:58:04 -0700 (PDT)
Received: from [10.11.12.107] ([79.115.63.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496c14a26sm76466825e9.4.2025.10.23.22.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 22:58:03 -0700 (PDT)
Message-ID: <b1b6271a-1f75-4cfb-9af0-4d60b578f2dd@linaro.org>
Date: Fri, 24 Oct 2025 06:57:54 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: rng: add google,gs101-trng compatible
To: Krzysztof Kozlowski <krzk@kernel.org>,
 =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: semen.protsenko@linaro.org, willmcvicker@google.com,
 kernel-team@android.com, linux-samsung-soc@vger.kernel.org,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
 <20251022-gs101-trng-v1-1-8817e2d7a6fc@linaro.org>
 <113ee339-566a-4cc2-9786-89252ae072e0@kernel.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <113ee339-566a-4cc2-9786-89252ae072e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/25 5:31 PM, Krzysztof Kozlowski wrote:
> On 22/10/2025 13:19, Tudor Ambarus wrote:
>> Add support for the TRNG found on GS101. It works well with the current
>> exynos850 TRNG support.
>>
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
>> ---
>>  .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml       | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> 
> No power domains here? I would prefer to see such additions together
> with the compatible, if that is possible.

It's part of the misc power domain.

I'll add the following in v2 and keep your R-b tag. Thanks!

+  power-domains:
+    maxItems: 1
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Best regards,
> Krzysztof

