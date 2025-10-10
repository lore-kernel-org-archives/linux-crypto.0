Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE670280CC8
	for <linux-crypto@vger.kernel.org>; Fri, 10 Oct 2025 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105238; cv=none; b=GuuGJXVDwxpsZ4ZVSRb9EjhLuPWSDD7TSpPcjrCR4lrM1ZT0gbvBKmAl2/D+GAbhutAIbO2QYL4SuysjEXUu0sLOqJeU1lARObRscdv20gxmEw35DPpN8TI/pBPpfMbsF1lF0ejFGs6IPRFTKnEh84WCnyj8oRwJO2pMaxEUTgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105238; c=relaxed/simple;
	bh=EpvvbYbzvU6zmy28zGsL/hrDErMFtA16oSibI9TggNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C0ls0AhATYZkAyPchs9lkrVM24ITK0HEOTDfLP2RBbDi4V+HKVZX0rYpfxK/y8WBCoAaxmF9e6lqJeQqCaXedHdojVcQ27K0Mb0lOpRXGIUCOFQYxhjzStEVcYpXR5QNiyc6EcdtpMQQcs/g6ucKncUezVXAEiiNnS4E6hFxWuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lZLZwCgd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lZLZwCgd"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so19212985e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Oct 2025 07:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760105234; x=1760710034; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Enu1DPq85k1M2WpWSEeI3rs72YHXo8vk1sE+FawP+Qo=;
        b=lZLZwCgdincZK8sEABhFZMr0j9WNDZ4uPN4WK/DvAn026vQAcW5o5YK5QHcF+wiBrI
         Uwgzn4TlduPRKm8j+0sjSq6AekZY32zPs3MgWugCxV+hkGBcbmGMXX44ghV0MC94LGKg
         NEJGxN3jnKHXtYaMhTa7VXCcasAtY21Wtm1pxv3wTmsXBI07CIRi4vkhW91WWuY9wlKw
         VLixueMZgw/NoUkB9d0Ey21l1zSp0G3D5/dXM68c1d2Seq7no5ONZ/MU7kLzl8AB2YRl
         bm4eKyarbpUi4HpQV/rEoP8QJpT9jz9A8FMynLzG6YTkPjUzUAdQnUh3opbL6Bm2wWJ1
         3AiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760105234; x=1760710034;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Enu1DPq85k1M2WpWSEeI3rs72YHXo8vk1sE+FawP+Qo=;
        b=PXCzETXWP28oNblpRv1+hr63lgY5rqTi2QUzPtRCbaIQJUH2kRCWKiQavTypX6NYiq
         aLiz9GeBdu6BOinJ9Syu8VNnYPZbq+nAixuIwswER5i1TPCRadLIPASn7uLCTeLCsfbZ
         H+cazofKSja7FtPIGbkFy1HVl2G9knhXuWi/CQKPqMxew/t/2vqOh/40MkHybTafU8sx
         pOIXLzQvnZe3ie1pZT0ZckBsJlKSvaJEbfy+L8mMvlD8xZqPY5KQ8yPGJOhzbINUfD6G
         FmE7Y933RclAPQKOpjwWo047GgqQFinR6xlYkq9F6FPfCAch0ZUE2B1J89Vwjc6MdzB+
         0hfA==
X-Forwarded-Encrypted: i=1; AJvYcCXo9IbvGi+GRmDyxcbPAK2+vl9k/FF7TtmdRLTKgKisi54E/Ek6a0bi+zapTl7djJrrqDCdze9QCPnOKt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqV4FoCGNL/PVuSKrqpbwhCGE8WWt2u1KzYsRp+IC+sJRLMg1u
	EeTt5JgWmUuZwuOMHySqK/BXKr1qdjC6us0ebciwJGB+63LgpucOCX5Co0MFBfm4F4Q=
X-Gm-Gg: ASbGncvF+U5TapLNZUNMqQEcFig5mpITv6Jo0Q1yJCno6SzON7yXrCA7W1n5rAER6Y9
	1V1OFTuhmEvIWm3A1ai2VY8d7Y8hrDPaALBSPNUuGZDAygQKGUvIx2mVDGkT0X9MHNiWPXEoxv+
	nyZdknNQbGg6aDw5pLWxzOY2c76phA+7R1Vrkjaki8Z/TpEoWcYWcTt+dXjCXZfWRLrpCTKmHU9
	l+mo084IuftFbtfFfgTZrL8pe6sOLdOMJSmiJTS/K+zDGNZ9FlOgcGEu5C7g+7pYz4Btxr+Z64V
	2GKO3fWIL7AymLHkIb3lj/wRhvogme5TlOIumYsnA5oz4iFoixDkJOIAnQAqL3LP4qYSmPWyPJK
	D3xS38Vaenw2tHepV8JkC3KVOraRThrixQD7KcJ0iO2Zz2N8nl9KsLvJrAug1REI=
X-Google-Smtp-Source: AGHT+IFolS4C8hT0Zmg7bmr6SzhI/cPbFJ3OA3Pjp2+/sYyehoF+n9CTxeFrReeZKbRbn30lJJ9YTw==
X-Received: by 2002:a05:600c:138a:b0:45f:2ed1:d1c5 with SMTP id 5b1f17b1804b1-46fa9b171f2mr80864615e9.36.1760105234051;
        Fri, 10 Oct 2025 07:07:14 -0700 (PDT)
Received: from [192.168.0.36] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583335sm4343474f8f.18.2025.10.10.07.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 07:07:13 -0700 (PDT)
Message-ID: <f033a8eb-df80-4f71-a941-09ba209f5901@linaro.org>
Date: Fri, 10 Oct 2025 17:07:12 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document
 the kaanapali ICE
To: Krzysztof Kozlowski <krzk@kernel.org>,
 Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
 trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
 Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
References: <20250924-knp-ice-v1-1-1adfc2d9e83c@oss.qualcomm.com>
 <36759154-4e7b-4cc9-b50f-ffb51a0b8aaf@kernel.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <36759154-4e7b-4cc9-b50f-ffb51a0b8aaf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/25 13:51, Krzysztof Kozlowski wrote:
> On 25/09/2025 08:29, Jingyi Wang wrote:
>> From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
>>
>> Document the Inline Crypto Engine (ICE) on the kaanapali platform.
>>
>> Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
>> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Best regards,
> Krzysztof
> 

Reviewed-by: Eugen Hristev <eugen.hristev@linaro.org>
