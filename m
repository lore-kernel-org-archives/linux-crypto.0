Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF71DDA31
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323748; cv=none; b=X2rns9pbsiNsbJDjcUzDDVAWXn9RtyWgrbFCeQ0VmGyzboJTf9PVIHl3JGtias1IQWOAFrywEJLG46uB4e60rHZCDJpnp9ZAIORM1D4HpxgijB4e8knfR4G6UxjPJ36DefQWd8iEjr9+1uFvvXThjqlmdoE1QDNxcOTVQc5fxPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323748; c=relaxed/simple;
	bh=QNyOS6SY5rWjcHA1h2Z6hmTihcYV3gQNXsAKAvvC7ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KxpDJ+rm3h6hQ5gjkRST1GwJ2pVvDhL+ZfNyfYMiSxxCoA1KGC+sWyaOz4wuNdQaePAH1U/6XEWjRkin9BitZ9bzyiVHfWvYrSF+AiOeuPS+entQL1e9udNRSKz2CbtrZxx4j0lYNH4gk88iCs4VAS3uaHvmWokxhQCnBIAARDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J7iXHwxR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J7iXHwxR"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42f5a663ed5so6851775e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2024 10:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728323744; x=1728928544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzih7sI/8T4550VWhNxKuq/0l4P7WuDuebNVuHyw6E0=;
        b=J7iXHwxR/6uR5qt9wCaRqC0dp0Dr7aQIRS6zTzn3+bOmqfaRGwx5hbJqkbR2bTSXPG
         Xj6319v3EEd0WSVoSL/XXCm1SAUYPL5UQvNzvIH7vJ2VxSDtF9RyDqw8atpyg3mP4J82
         J2G7zofSQN5Q/7WGkFCSq2uHBGIz3DspZO+iiX9bIX/Pb3CH2S3PdqSxWbPSpiLVb3PF
         b/krPU3wil5X2vDcdhDXM1Hzscx8/bM4OEwY5ChlEKXvxSYXgfbC2f976qUmGPUO3RPo
         U7TduHgoGroVcNduBFCkTvw+Bs1HkIg6cwiv1ux291uXFHQcq81Lmrecv3P2Qon736hu
         m+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728323744; x=1728928544;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xzih7sI/8T4550VWhNxKuq/0l4P7WuDuebNVuHyw6E0=;
        b=T7jq0krxvY6YqZX8Q3oLxEZYxJ1QhtZI7dAuYJvCjt4pTFhR0PL37fCq9LzTEakQbs
         gVrlZxMBEo6oJRjQhVVtH7QzGTgTKcsIjOr1QeJbfmPsYtwvOkcatiO+u+dxS1v/orE4
         0iaJ9eqIwr2Zlm/tPpAcxO9AhFjJqTeoi9chuieKct5WQx8hunL/Pv8y5mXXmfFIT2r+
         OZbMjKry2sWBX5+3Er3BdM8tEELloOjcFXKlNPCoeIUePlMpDvd98RMo96oXWnXmVVjO
         TR/YWO+2+RvGwZ6RwrE+FvwV62HfEofNrvh2Y1oMYbCt7pTzLEkMMa0/WBBn9Vg1HY9d
         LsJw==
X-Forwarded-Encrypted: i=1; AJvYcCXc4kaL+RY5tzJPiNrJFjcR3WAn4FSLVi8MYwwvQVZZk7E+quMBWC601jlhWHAtJHm3QYWlKE1ItRoQCcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBulyZJBjV9iaSuvjmiDZjC7lcgRMbZc5pqDmac0QtrQaiG8VE
	324dPG233LtoqcKGbJhD0CjhhoAHY+lai07vccb74tEyCtKh87//sZNttbYMNMc=
X-Google-Smtp-Source: AGHT+IE/zK51ycxsrjk17ShGM1eI1ozlVV9FyAiSj/A1Ydd2EiED38/G70Ht2ZTmM1HzGd0qeNPHtQ==
X-Received: by 2002:a05:600c:4fc8:b0:42c:ba83:3f08 with SMTP id 5b1f17b1804b1-42f85aa35bfmr44118675e9.2.1728323743606;
        Mon, 07 Oct 2024 10:55:43 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.211.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b1d981sm99877705e9.23.2024.10.07.10.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 10:55:43 -0700 (PDT)
Message-ID: <d158c7ab-ad8f-494d-9f26-6e90094df8e7@linaro.org>
Date: Mon, 7 Oct 2024 19:55:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>, Marek Vasut <marex@denx.de>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Lionel Debieve <lionel.debieve@foss.st.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Yang Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-2-gatien.chevallier@foss.st.com>
 <ec3cda71-57d0-4ec1-b9d8-62381667f7d6@linaro.org>
 <c425507f-5e78-408e-8a8d-fe02412a76e7@foss.st.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <c425507f-5e78-408e-8a8d-fe02412a76e7@foss.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/10/2024 18:22, Gatien CHEVALLIER wrote:
> 
> 
> On 10/7/24 17:00, Krzysztof Kozlowski wrote:
>> On 07/10/2024 15:27, Gatien Chevallier wrote:
>>> Add RNG STM32MP25x platforms compatible. Update the clock
>>> properties management to support all versions.
>>>
>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>
>> You CC-ed an address, which suggests you do not work on mainline kernel
>> or you do not use get_maintainers.pl/b4/patman. Regardless of the
>> reason, process needs improvement: please CC correct address.
>>
> 
> Hi,
> 
> I'm using get_maintainers.pl so I'll check why I have an issue.

If you use get_maintainers.pl and produced this cc-list, then clearly
you work on some old kernel or some weird fork (why weird? because which
fork would change these addresses..).

Don't.

Work on mainline or next.

Best regards,
Krzysztof

