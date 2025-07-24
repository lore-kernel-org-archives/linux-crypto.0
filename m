Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E46273D98
	for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 08:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344525; cv=none; b=FKHJWCHQw5y5O+23Yb6a7WL9Lq3dNLPrOqo0Vh7c6qUS/+Dl02cRYUQJ3PMrTuKMgk5xZ7V0oh0pRJuHNLKp4kuTOzgiiK0lj32O0ghTH83Lb0iKPO3bLTfxY4lO46ZCg0L0YCaohyam1RMvq3YBgPB9jia1qn7/vm17K7tPYJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344525; c=relaxed/simple;
	bh=FCUZqDD6J0JS8ls1i9soYcA/RpHR7beqpYXfAk3fdUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LUrTrNy+XTii2u1yx1eXfQQs1+LFKKFN+t5+am0kRBwXIAOAh2AGXaWLgaMQ1aG68zxYBAOaxScqwtNi8mrS7zOt544a9/GAJyWnHo4SKmdbhPxG8l4sltha2cpnSxztCHXTnKFz3PYNAAT+KoBZtDMKtYbQlVeWmll/NJIebfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bvj8CXAr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bvj8CXAr"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-456107181f8so229565e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753344521; x=1753949321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X6feK6OFgHACtKacI1BI+FbR93W3Tq/Mf7RC2mQiLrc=;
        b=bvj8CXAre/DPCbHw8xCq5dUoTaEIIWGUPwPc02wouerJZqzsbG8Gu0hn6J5yfpLsuD
         4x1qTiCZef1IDTZitdGD6R8mG4NdWuKnYog+dtSI4cVGZf/QCQySTdezhHdfOojK/jfh
         CkNb2rbsSAQd65+DluY22y6zj2s/8qrk8+ELP+3S8zDy3VkvXkc8Z8b7HPk+ul3gA2FL
         BBjRmHLHGnYGBhD7UmJYRs2cR3Q3xR/E4ZeX7s84aeg/KNlOyGx3/WH8/kczVnkaVecV
         ce7uUijyQJoB3AHIoIASNxBWaApZ3Y+1YHPgjIS7JM0MvpnIKjVtxrUqqJY2T4pvWCOa
         1Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753344521; x=1753949321;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6feK6OFgHACtKacI1BI+FbR93W3Tq/Mf7RC2mQiLrc=;
        b=CnWtzPNrQ7ROklazsDiiDL9qTF/nwXm0gLh3KnOpfFqZ+gHljRZ5jyQxUZDyfsejLX
         nINgApqI9+U+sTL+hn0ZhQlnAqKGMsK7inlzpEeV2R05LB/kFrTjC0R8B1zwSi0lyosI
         37nPpNgqCKFv8jTS7d6Dbv6PC4O7sWx3V5rKciVNO+WeRiV4YD3QpKKeJkM16IXMLKAX
         PD1w+Bm53uM9IbDQ2fYWcuhZAyLji2Vv/wquk/FqEwLdjVIrpCtxsOxQKZ9Ragoa4+Y5
         Xqdyzisvn2wo7eXy0bqD2LXaeKTyCVatDyLF/hyKo7PHFLPCMNhEqASjwcu6VBtQgV8O
         5YOA==
X-Forwarded-Encrypted: i=1; AJvYcCXO7yBhcehO5tlPkp5YoXxc5h5jeISb+6ckJhXEoFJsC3pW8Q7NcUfx3pxXxZqZX2x71pkACrwLQwcX2lw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdrjusWrumXtfsjOWy8/FQPDz5HmbEZnG5G3K2L/FhLRZpqATx
	V/cTMWLUQ2yHpq3quSqOD8zkAvuPN/OsG0T8zXh2mqWAuqtJyGeMDS5lmuu22Od9d9M=
X-Gm-Gg: ASbGnct8h0jw2YtUl1IsE5HArDHLYOPlw4qceuMKk0QoNSyP7hwJg0Ze0c5kD86rMiD
	/3mkANc2PO89/keaZCCzS8EQ2I9VA+xgsO9kMv9FBXHOgaUaYxIVGeb62pQtT6KwnuzoGD3THtZ
	EKTpo5z7GJe1huEo1u7rXMCanwcf+xvXPzRg46+t6fodfFHu8OMTgfyEMwRRDvxzmpOyxaJK+K3
	DbhL/rqbiYtbbhOptbw5uzqEnqRn0wgPca2bkR8yktZuDMEMvw+3++xp6onKcSjeHvuw8gMoETW
	bXy4kdodCCNXgdLmNKOiMkc3kdEYA8oV0uutMvV8Vb9TZmLSMZHKQ1gyaUaLX4ML55KNvUXZr48
	t3R6bqk5mXVWx3iEcfIGH2sBjRET2o+Y1eNf6Bpv2MQ==
X-Google-Smtp-Source: AGHT+IGNvZ9ZfabdgNPRQVULYvd6vF+PtGhm7iC6xOezk4H3zJPBVtSBlI43GvHwQ4wXtxX/owN69w==
X-Received: by 2002:a05:6000:310d:b0:3a4:dc42:a0c2 with SMTP id ffacd0b85a97d-3b768edf03emr1779405f8f.1.1753344521209;
        Thu, 24 Jul 2025 01:08:41 -0700 (PDT)
Received: from [192.168.1.29] ([178.197.203.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870568fb1sm10289275e9.27.2025.07.24.01.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 01:08:40 -0700 (PDT)
Message-ID: <ab0294da-1ae3-434c-aa37-75532e538e56@linaro.org>
Date: Thu, 24 Jul 2025 10:08:38 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random
 Number Generator
To: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "Botcha, Mounika" <Mounika.Botcha@amd.com>,
 "Savitala, Sarat Chand" <sarat.chand.savitala@amd.com>,
 "Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
 "Simek, Michal" <michal.simek@amd.com>,
 "smueller@chronox.de" <smueller@chronox.de>,
 "robh@kernel.org" <robh@kernel.org>, "krzk+dt@kernel.org"
 <krzk+dt@kernel.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>
References: <20250723182110.249547-1-h.jain@amd.com>
 <20250723182110.249547-2-h.jain@amd.com>
 <a350e9b6-9bbe-4045-8d9c-e3886b758a99@kernel.org>
 <DS0PR12MB9345EDA907BB0438C32EF12F975EA@DS0PR12MB9345.namprd12.prod.outlook.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 2+47PN9NZAOyb771QoVr8A==
In-Reply-To: <DS0PR12MB9345EDA907BB0438C32EF12F975EA@DS0PR12MB9345.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 24/07/2025 10:04, Jain, Harsh (AECG-SSW) wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzk@kernel.org>
>> Sent: Thursday, July 24, 2025 12:52 PM
>> To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>; herbert@gondor.apana.org.au;
>> davem@davemloft.net; linux-crypto@vger.kernel.org; devicetree@vger.kernel.org;
>> Botcha, Mounika <Mounika.Botcha@amd.com>; Savitala, Sarat Chand
>> <sarat.chand.savitala@amd.com>; Dhanawade, Mohan
>> <mohan.dhanawade@amd.com>; Simek, Michal <michal.simek@amd.com>;
>> smueller@chronox.de; robh@kernel.org; krzk+dt@kernel.org; conor+dt@kernel.org
>> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Subject: Re: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random
>> Number Generator
>>
>> Caution: This message originated from an External Source. Use proper caution
>> when opening attachments, clicking links, or responding.
>>
>>
>> On 23/07/2025 20:21, Harsh Jain wrote:
>>> From: Mounika Botcha <mounika.botcha@amd.com>
>>>
>>> Add TRNG node compatible string and reg properities.
>>>
>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> Why did you placed my tag here?
> 
> You shared Reviewed-by on v3. It’s the same patch. Isn't I am supposed to add it in subsequent patches if there is not change?
> 
> https://lore.kernel.org/linux-crypto/20250617-rational-benign-woodpecker-6ee31a@kuoka/

And who sent the patch? Who received the tag? Why the tag is above
existing SoB chain?

> 
>>
>>> Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
>>> Signed-off-by: Harsh Jain <h.jain@amd.com>
>>
>> Who received the tag? When was the patch prepared?
> 
> Did I missed something here?

Yes, using standard tools for the job - b4 -  or following the process
if you do not want to use the tools.

Best regards,
Krzysztof
