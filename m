Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA9182B9
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146129; cv=none; b=iy/qAdnY+MY3pPECc6bPL2wlC9VZQ+gbHpC/1oMq7htfDQznSjiIqv3wWiSclK0/EcAOgCqZawaqDrW9HziQPkHg3vlIyIpwy7rM6QvSqyU73HOH44uYzf3/rcGYyBtnM6XUs5+Bd3CZdgb76Tb75Rr7PJfmXZIroV+UMlBX9GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146129; c=relaxed/simple;
	bh=6q0+QveQn5QuSf1ysE2YsK+MEXD55Sxc+h8vb2IM/uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UqPpQNC9x4UUCKDgIOvvqfB3H/rDW2CIZ21IpPR6OyabbeTLaEgXs3l5Ol05vX2zaBJCIXP7b6b2+xLaMVy5Ut0LK7rgQRI1HVj6eiPoTbSj3jhakhbxLXjyRVZxaRCKY7NkCRNAwVNEs+aiXm7nPKDI2XdQ5+5i2IGjYXNj77E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nqQuEwDQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nqQuEwDQ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4211e42e362so19375245e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 02:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717146126; x=1717750926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TTXr+xSsHyu5ij5RcIGy/AJermRyYvxwESBJmWGPSs4=;
        b=nqQuEwDQntDWEEpuBY7FhAgQgVQB3UwU/sUtu9XzSJwLLuLIbeUP1FvLtb0YmtYZ/G
         wwtstR8G5qRxR7Rfo1Zy+4fFeqP9zcpRxbf65mT3rvAm+ybAsnkWN1PvrPuC4Hm0rXxO
         ggWNfssLjMTDusLIWZyq+yBPTka8zTTs0GyMOF89KcxHEl7pnU3eL899OH1CsbHlXKZI
         3/LB+hyyPH4Na6ePSWXVEZNG6vVOquISbfQlwMrcQ41n5NyRxHTyv6ZihlGfyUri3UyH
         vLolJ69e36wRUo9DD1yaSCNn7pskaLYjKPvLrFH9Glz0kPaPnhxweSYwXXvpYwJ0LM/j
         Qndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717146126; x=1717750926;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTXr+xSsHyu5ij5RcIGy/AJermRyYvxwESBJmWGPSs4=;
        b=nSbTlc3bqulqXaQJAnAYb4zVrq5+KUx12iT4lydWJdqxhkEsi/dDgVjSSY/hyFxX27
         affTCaoiffSOKctLLm4wQPLbaOn4fW+Qy2hI4gHrLyx7iUw1lrSozXkvbRmH7KTlx83N
         IhALDCw8k85FbNDPIzPZYRn2R5eAdQUrhTJg6EZOHHPzuPAgIlOpn4x+9PhEr9LuciBA
         sDQhbt5qv7otJf77AZ6hLvMfQ2olsFILaP00UqV68mbubA1h2ppAqi/PLSqS5Am7G0xX
         tylQjTSCsq4BcyQl2vAX8Iz8xD1ysmlsl3J35HVOSyF0PqDNK7evVYctuSrr2GGvJzK1
         aE5w==
X-Forwarded-Encrypted: i=1; AJvYcCXghW4kURPtSV81mQA0LtCvHhOTktPkRzU44NGhIvBsCtbkUqUUrJ4TabP++dFbp3zwmloKJRYBiu3m2nAdNVfcj0VrK1Kr/+ym+BqS
X-Gm-Message-State: AOJu0YwlrFMvEs713NdEjkJbqXLys7mrndo27craMxv3Uf6Dbv8rXKhT
	t8KakEMsmCXsEQn8AKt0VVCs2xvbN0J1n28kysAO4BNxk90DDMso8yQQH2PUgV0=
X-Google-Smtp-Source: AGHT+IFxSaZmLdNyNJrRAZ/s878meKXqK4clH/qW7Uc/rZ3GtoBkSTJM3Ai2OijktpIgJNW8ufPECg==
X-Received: by 2002:a05:600c:a0b:b0:420:215c:b010 with SMTP id 5b1f17b1804b1-4212e0c3065mr9179415e9.41.1717146126253;
        Fri, 31 May 2024 02:02:06 -0700 (PDT)
Received: from [192.168.2.24] ([110.93.11.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42127062149sm48366475e9.14.2024.05.31.02.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 02:02:05 -0700 (PDT)
Message-ID: <2429dd47-d528-4090-ab1c-994209d4b446@linaro.org>
Date: Fri, 31 May 2024 11:02:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] dt-bindings: crypto: Add Texas Instruments MCRC64
To: kamlesh@ti.com, herbert@gondor.apana.org.au, kristo@kernel.org,
 will@kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com, robh@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, vigneshr@ti.com,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
 <20240524-mcrc64-upstream-v3-3-24b94d8e8578@ti.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20240524-mcrc64-upstream-v3-3-24b94d8e8578@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/05/2024 14:24, kamlesh@ti.com wrote:
> From: Kamlesh Gurudasani <kamlesh@ti.com>
> 
> Add binding for Texas Instruments MCRC64

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

