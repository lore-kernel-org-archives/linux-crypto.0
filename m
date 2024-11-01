Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5D14F12D
	for <linux-crypto@vger.kernel.org>; Fri,  1 Nov 2024 06:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730443810; cv=none; b=Gm+Kes0wHrvK0hHe/dW2ZBkwPDrbT86m8ETt4Gtdm9pj7sBeI6di9VoTqcvjD9sBjqYH/3c7BLTY7RdVlIQZ2ZYPsQui5QxqmeD39OHsrjNzkKSl9IFjm/ZIY2Yxxych/zoQTS0Qw8sGvORNGaLh/HhDaHuC/H9dizBwlnEw19g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730443810; c=relaxed/simple;
	bh=ODJ1U56tKN/dg4KO8D11FzeojPk4P9LEzQa3wCw6N0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TqF1hpMgcSGxdSUk6QsLptPo5U/fEZlMvK5H7IUGT8/YXhxniC9MBUj4NoT1fvT8SjApGllfPU/5JQy8Y5r2Xr9qnKoC09pVFLOidpWqKnqOFfqi/hOzSQ29eKJ7OvvhKJOm7KL+gBgnCkbpcUfI6ZZKh8JH7BiSXPopPZtdbco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vqXvCOO9; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vqXvCOO9"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a039511a7so25185566b.0
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 23:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730443807; x=1731048607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BoHoD7USV7MEAnZlU2UJzxgFTmdUTbHvC51Pi8erYfk=;
        b=vqXvCOO9PmuaTgLkDPEkIzZuuHnYKs2Y6KSafQ9z2I4LXgSRA4yaiomz2zWfSCrsTr
         hO0lADObW1nlJdBRidy9tVJ5TFaWo6Az73X8HiuTakIB2rZI8ntnTHkj50zWd8yRHLD4
         oEazAqaxcAYjwhHUm2pUJnn0l6roI2Quv60lvy+kmgKNqWZfbsY/EnNLt4kQBbau47wk
         vuJlxUJqnb60FCZW/oPW+AXI+YCDOGNCgT1nLm7sT6rwY0MD2OK2O/tL6lhkjaiEswD8
         g4jgBeJ1bOcqekyDZyXAsneJXQli68KWOFwEcU73y1qnd8ua6++Of/EnKRTCfzgK64ju
         drxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730443807; x=1731048607;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoHoD7USV7MEAnZlU2UJzxgFTmdUTbHvC51Pi8erYfk=;
        b=owtz1sYmpr/c82D5q5kyv20dqb98f2dSoH8iMnlqxez1F6nxoV7ZMQlFZ/vk9BUeCH
         GuGRH4calzbJ6G8YnAoMZrBUKh4NYqvXYZMvCDiBnHFkqRg+GeOedVXzUHJq0LOWFKw1
         OLEoqTy6ETaTzPBF1Oju3xer0jqun2H/pocFJERna0vKXEV0esFomiHceg7oTECyQeQn
         dIc00I88m6CbCDs5EqUQnTDGkBpxJqVIB/7yRrGHbFiMBONRv2Ugn0b++oRjBhtEwdDp
         V//JRqGIEwmVZzapqpu2KeRZtfYQq6DO8F/DhfIWykbpQoINpQXESuRw5izAFcBGt4e9
         IePA==
X-Forwarded-Encrypted: i=1; AJvYcCW9CWsZfviidgRqhiZ4KDAmqExiSrZl2BTgduPwS5FbqebUC+XzMXxK5N9fFFu9pubAPhDBLV9j8bokqaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywrFM9aROkuTEd0O+QW8OSMec28Cd9kBcF9pojJ7Cz50uiwlKh
	M14OCuPGtTgIhR9aqtZnIFRivrnUQKnYtPmU3NxHvcj1jJ1XEqx7bx8Wt21OBRY=
X-Google-Smtp-Source: AGHT+IEAYHZTjJ6/KrgtwRF4vrEkWZBl/PoMNQCnKqHSKQ5lDc5aBqd9u5WLmF5kBRtx87lGmWqLNA==
X-Received: by 2002:a05:6402:5256:b0:5cb:b616:5ed5 with SMTP id 4fb4d7f45d1cf-5cbbf936330mr7700329a12.5.1730443806785;
        Thu, 31 Oct 2024 23:50:06 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.211.167])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ceac74cba4sm1252114a12.6.2024.10.31.23.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 23:50:05 -0700 (PDT)
Message-ID: <aa6b6171-24ad-4dea-b0cc-28d7111416b7@linaro.org>
Date: Fri, 1 Nov 2024 07:50:02 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: rng: add binding for BCM74110 RNG
To: Markus Mayer <mmayer@broadcom.com>
Cc: Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Aurelien Jarno <aurelien@aurel32.net>, Conor Dooley <conor+dt@kernel.org>,
 Daniel Golle <daniel@makrotopia.org>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Francesco Dolcini <francesco.dolcini@toradex.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>,
 Device Tree Mailing List <devicetree@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20241030213400.802264-1-mmayer@broadcom.com>
 <20241030213400.802264-2-mmayer@broadcom.com>
 <db7b7745-404d-45f7-a429-c1c747de8e6b@linaro.org>
 <CAGt4E5ud=0rwSKBTOAsx0RMB3Pkjo+HHxZ_JLPBFbOSZUTCRVg@mail.gmail.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <CAGt4E5ud=0rwSKBTOAsx0RMB3Pkjo+HHxZ_JLPBFbOSZUTCRVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 31/10/2024 19:55, Markus Mayer wrote:
> On Thu, 31 Oct 2024 at 00:29, Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 30/10/2024 22:33, Markus Mayer wrote:
>>> Add a binding for the random number generator used on the BCM74110.
>>>
>>> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
>>> ---
>>>  .../bindings/rng/brcm,bcm74110.yaml           | 35 +++++++++++++++++++
>>>  1 file changed, 35 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
>>> new file mode 100644
>>> index 000000000000..acd0856cee72
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
>>
>> Filename as compatible.
> 
> I am not sure what you mean by this. That the filename should match
> the compatible string? I did change the filename to

Yes.

Best regards,
Krzysztof

