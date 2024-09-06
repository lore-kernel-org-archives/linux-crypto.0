Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF2314A604
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 07:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725608344; cv=none; b=N8OH3vS35O47jhBxzcqPVVBO8qhLoon/I3Dg92keHEQkj/gkbMIi2qi5G260ix6OoIk9vvJkgG+28D2MwW96f0hStxaRlrZedkf1vpGVZ7M7laqNEQOoe5VKBuMWxE1T0U/0UI/TWEjGyQQSgC0ihGn9N3DCMg3fp2VutDKNkLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725608344; c=relaxed/simple;
	bh=/VfN5TZBKFESX0ktdJnLpkP+3s1XJrbvW7+e2JjstSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7A2HiPADBetCQqKS6t8bEK1he0LFv8DqYxEcQq6UUD+AMNL0LdioKWqU8HuhArzEZPg4uvT7KL3MUgUtCjaF9laCKrRjgzMcHIKTJAwuK4dankzZK7TbjPJ0fixlIpWqSPdsdXQ0H5qmZFfjPdG4Bbr+bg29LvISHocL7JWnnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cB0wo8oG; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cB0wo8oG"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-374bd059b12so936390f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2024 00:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725608339; x=1726213139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xz9IdLmzy/T20GbDRPSYjXR1GKGx3xeoUvnivTDuQzM=;
        b=cB0wo8oGQ4gkqzsJUvwKF2bKsP3JPyJcvK8bOlIjlrk+jEwF2DTaekiQ5x9nIxU/UZ
         HaCsFa7RX/okxuGsDJAAUa9wIbIqORlQfJwHEEqjhATDZFBZXnh4K0gjB8TM9nBNytTH
         Lpx4ZaujIBV1Y4PChxe/m+H3cnhkvFDulli0meNFfyNDTGKB6IYEnbfb+WZVDITwgwyf
         Mtg9oW5A2dL3K3TxhVhVOTy8lY0hnWAOlVabsmGFF1FagxFC2iQ5AdRCVdjFdzQ4DQI1
         aRafG/lG6ZWwZAaCW2b0/DfSRhZ0jDCKGlajtSZAp+/RjNDaPd4p0xjNgqps9c0zsTCp
         8UzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725608339; x=1726213139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xz9IdLmzy/T20GbDRPSYjXR1GKGx3xeoUvnivTDuQzM=;
        b=Zmdc5CddCt3NDTLs69eem3dXS833AHcfw4t/hfA6cXQtc9RC9pipgV/Qv0QIRGma3K
         pQ4AGM4Vh2l8C8ClTbPCU5STGmdZ6V2Lm24/OmQgmZgtPr4lwE4WxDQqM7IkDtT3YqmM
         uAvj6i+IPT+/hLid/4LGUcB9FILwwRK1glvr3xORgsYGpHqPRMvXcEbTV1nFmWuSju2S
         gKQklCEBHbkeQgPNgHct6Vdf9YpJRNeSOa0AmcTCLOqZcy5i+uxU4Jovn7RgaNezekhc
         PO7Mry68kd1OaMH7TkPeQ8m7r8YU4VBoA22d5Hzqvvjp3kqr15tUJg6fz1V6da9GzMuG
         /V8A==
X-Forwarded-Encrypted: i=1; AJvYcCVHw2VGOyMGYLGIYKEXln6ex46z3cGKBjdwYp4eqlQKHKwXTibbuXwb0a0Han1w8wSgIm0A5NqEzEYqdtM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSSXUzKAmiuv39V8LGgU299gtcS+gy//U6WCrKxKNZAZ5vJIi9
	iueRKEEu9kWOXDoE+U6d+ANw3DrAqXl8FvYf8Jgy74IglGGGHV/tIACgAbMhIvU=
X-Google-Smtp-Source: AGHT+IGFHwFQ99mHOKHLLsrCtuLnOv+VrrxaTcWgKFCATGwuZhLv7Zk5Z474pGF9RhYDinH0QTPZug==
X-Received: by 2002:a5d:5f4a:0:b0:374:c269:df79 with SMTP id ffacd0b85a97d-374c269e0d7mr16000044f8f.22.1725608338871;
        Fri, 06 Sep 2024 00:38:58 -0700 (PDT)
Received: from [192.168.10.46] (146725694.box.freepro.com. [130.180.211.218])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3749eea60e2sm21002351f8f.62.2024.09.06.00.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 00:38:58 -0700 (PDT)
Message-ID: <64758ccf-7ad4-4490-b938-864ade9ae74c@linaro.org>
Date: Fri, 6 Sep 2024 09:38:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/21] dt-bindings: thermal: tsens: document support on
 SA8255p
To: Nikunj Kela <quic_nkela@quicinc.com>
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, rafael@kernel.org,
 viresh.kumar@linaro.org, herbert@gondor.apana.org.au, davem@davemloft.net,
 sudeep.holla@arm.com, andi.shyti@kernel.org, tglx@linutronix.de,
 will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 jassisinghbrar@gmail.com, lee@kernel.org, linus.walleij@linaro.org,
 amitk@kernel.org, thara.gopinath@gmail.com, broonie@kernel.org,
 cristian.marussi@arm.com, rui.zhang@intel.com, lukasz.luba@arm.com,
 wim@linux-watchdog.org, linux@roeck-us.net, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
 arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-i2c@vger.kernel.org, iommu@lists.linux.dev,
 linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-watchdog@vger.kernel.org,
 kernel@quicinc.com, quic_psodagud@quicinc.com,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20240828203721.2751904-1-quic_nkela@quicinc.com>
 <20240903220240.2594102-1-quic_nkela@quicinc.com>
 <20240903220240.2594102-13-quic_nkela@quicinc.com>
Content-Language: en-US
From: Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20240903220240.2594102-13-quic_nkela@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04/09/2024 00:02, Nikunj Kela wrote:
> Add compatible for sensors representing support on SA8255p.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Nikunj Kela <quic_nkela@quicinc.com>
> ---

Applied, thanks


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
