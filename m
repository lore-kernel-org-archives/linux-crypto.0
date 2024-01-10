Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F21F3FB0E
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 10:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pTTr8bPi"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cd0f4797aaso43301871fa.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 02:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704884147; x=1705488947; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XovDo6g71dUW3xxSlFZ5p2kN6+6ojspuCXXtemQJf10=;
        b=pTTr8bPi4cOMTVM2Z7l6d6g6datRjbDOQJrbsgodBNOeDvd+yyw1poWVPQWoU49W+F
         61dm0GUT0F4X60md0voYZ6BGI/PPYc51xph3HPTffWn3ANR6kTHhQjPmvdd91N+Tf19u
         oEzUdtppV18u1+c1wD+Ba0Ic/1fi3G0H7E4N/IVh3OOIVR2+ofq7qXc5CzGzEoKlXyJ3
         t4tl2DoF8hP9OWJcXZ/IdhyLJ+HbHDNTWZZAR6WkTFDEvq9SRJMz3ZW8U9FTlXz9+/Gd
         7cxNBmAtaInzSSjN7JSYvVUSSe5rNrKxDFvtZgG5n1Oi3w31LCGt1xto+6in+dJzwJCe
         lcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704884147; x=1705488947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XovDo6g71dUW3xxSlFZ5p2kN6+6ojspuCXXtemQJf10=;
        b=VOQ7eI7Y2A266Ck9JQNqZcNJjoDE7EcoTz2rEXR979hVWeOrOtNeh6bFqoY+JX2YEq
         dL3ix11BgLEVXW+k9gHWutUvQ4mdwkdImzE0OgRNgA2KaddVMugC5hch+7whLZrncBVg
         bnTGDwrVkrHNcQVBDqViYDQKgNlA2SUy9d/caxcZm3FZPU7lwet7+io/0mzNz6B+I1r1
         iB3B8DFLAaHV7VC3yH65sIxjbYkBeaFhPQnHl/jpb0WJm4WjSW5X4S3wYdCP9XVrlUYZ
         yvKkZAQRvSEo9QEY9xXBhL81W/06k7NYPwXbG4lY1/FK3h+yZdr/R88Zlgr8w/WnvBzA
         JieA==
X-Gm-Message-State: AOJu0YxlQewH/DIxPlSwbTeTqC4Ko2KwAORAzYW/Riu/9MFwVtAClY2t
	rKARTwklglMVaKweUw9dGg9V9xr3T3HzBA==
X-Google-Smtp-Source: AGHT+IEd1AqxwxGdLm94IyI73PfJOK48J7QaBzT7SKGTGndUmAHxRQneQCtPTI9QE5aJOSdY1d+CIQ==
X-Received: by 2002:a05:651c:169a:b0:2cd:230c:cc40 with SMTP id bd26-20020a05651c169a00b002cd230ccc40mr404636ljb.42.1704884147334;
        Wed, 10 Jan 2024 02:55:47 -0800 (PST)
Received: from [172.30.205.119] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id y27-20020a05651c021b00b002cd77293ddcsm196596ljn.12.2024.01.10.02.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 02:55:47 -0800 (PST)
Message-ID: <9daba002-2c49-49cf-a8e3-5b8350270df8@linaro.org>
Date: Wed, 10 Jan 2024 11:55:44 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Add Crypto Engine support for SM6350
Content-Language: en-US
To: Luca Weiss <luca.weiss@fairphone.com>, Andy Gross <agross@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240105-sm6350-qce-v1-0-416e5c7319ac@fairphone.com>
 <c3e82c7a-fc03-44c6-bf83-97dffaf22dba@linaro.org>
 <CYA51QMVFQZF.3NEPC3R2QY2VM@fairphone.com>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CYA51QMVFQZF.3NEPC3R2QY2VM@fairphone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/9/24 12:27, Luca Weiss wrote:
> On Mon Jan 8, 2024 at 1:40 PM CET, Konrad Dybcio wrote:
>> On 5.01.2024 17:15, Luca Weiss wrote:
>>> Add the compatible and nodes for the QCE found on SM6350 SoC.
>>>
>>> Not completely sure how to fully test it but "kcapi-speed --all" shows
>>> no issues. Let me know if I can/should test this more.
>>
>> I think I used `cryptsetup benchmark` with and without the ICE enabled
>> a couple years back. IIRC the CPU should be faaar faster but also chug
>> power while at it.
> 
> Are you sure you mean QCE here (which this patch is about) and not ICE?

I.. think I do. It's been a while.

> 
> I'm not aware of them working together somehow but I wouldn't be
> surprised if there's something since I don't know much of this area at
> all.

No idea

Konrad
