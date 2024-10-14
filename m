Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4C014F9D7;
	Mon, 14 Oct 2024 08:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728895342; cv=none; b=BTThrDw3tCde3+QU2yOKioa509I7pOGlY785OJ2OWNqo9Q/lS0oaEGPOGm6Fo0v2r/T8o5t6F4QGMJvZJwTuuD5vcM7SJrigsHCibK/EQU5umcX01AtwV55mUlAlF0vDr2ZhJdlXUKA5TL4axh2H4+PjRL53DNbXW4GRRt4C0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728895342; c=relaxed/simple;
	bh=TwZlYjD13UqeLN+DlUIDduikX8JN0RpSVvnJbYRu89U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=l54fj7kLklZ74azkeeWx4nSghwyUMPW95QukNWrrlq5CizRVLVJNDqAQOulR7puo1EIuEv0/JzSQ0ilckdBq9vtG/iImATXvqQAfvg23/eSimwgLMnNh8Nms35H1+vOZOuSL10Wh9TviOSthWvXJi0bE5Nn8qxXTpRXFMkcCc+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=U8LGMsmr; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="U8LGMsmr"
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49E54nkx027926;
	Mon, 14 Oct 2024 10:41:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	5esNFNUTDUNqlWySOqU6hZQiJIQS2bs1dT2iyHYhZiQ=; b=U8LGMsmrHBNIGI+A
	yCEYAvn1pY2AklzSiwRyoXsWjgxAJfdtNwMAi6Mkc/NiEgXx0a98lxxDwOAjxdDi
	tkiMGumOlzzh9LefvAgUeb15mDpgsUKxcyuW/sCEtiCevgydE2ZfzIQ+qb+uZIlQ
	aZE+53QTmCiDFuVLXEC20q95gLgRa8o3gSuqfZikIixc3wzGEFA6CeSfuts0VjcM
	3QXWC1ccOkBfSZDqcs/bv8fB1GdG8gxSk4a/G2Unuzy/Wm9mOZb0AFyppoXwmAjH
	9N158NDDaBk5DUunG3Id0kCog9xxbalwc8MP8SQiUkuAUMGfVPpERyi6BPFJaYpj
	gAkGSw==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 427gewq6jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 10:41:28 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 941EC40050;
	Mon, 14 Oct 2024 10:39:59 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C17BF269E1E;
	Mon, 14 Oct 2024 10:38:41 +0200 (CEST)
Received: from [10.252.14.29] (10.252.14.29) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 14 Oct
 2024 10:38:40 +0200
Message-ID: <f191d034-4116-4169-8c05-201450412bbd@foss.st.com>
Date: Mon, 14 Oct 2024 10:38:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Marek Vasut <marex@denx.de>, Olivia Mackall <olivia@selenic.com>,
        Herbert
 Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh@kernel.org>,
        Krzysztof
 Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime
 Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
 <20241011-rng-mp25-v2-v2-2-76fd6170280c@foss.st.com>
 <318dbd5e-f547-4d78-b42e-4dcacc08d328@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <318dbd5e-f547-4d78-b42e-4dcacc08d328@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/11/24 18:17, Marek Vasut wrote:
> On 10/11/24 5:41 PM, Gatien Chevallier wrote:
> 
> [...]
> 
>> @@ -551,6 +565,41 @@ static int stm32_rng_probe(struct platform_device 
>> *ofdev)
>>       priv->rng.read = stm32_rng_read;
>>       priv->rng.quality = 900;
>> +    if (!priv->data->nb_clock || priv->data->nb_clock > 2)
>> +        return -EINVAL;
>> +
>> +    priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * 
>> sizeof(*priv->clk_bulk),
>> +                      GFP_KERNEL);
>> +    if (!priv->clk_bulk)
>> +        return -ENOMEM;
> 
> Try this:
> 
> ret = devm_clk_bulk_get(dev, priv->data->nb_clock, priv->clk_bulk);
> ...
> // Swap the clock if they are not in the right order:
> if (priv->data->nb_clock == 2 &&
>      strcmp(__clk_get_name(priv->clk_bulk[0].clk), "core"))
> {
>   const char *id = priv->clk_bulk[1].id;
>   struct clk *clk = priv->clk_bulk[1].clk;
>   priv->clk_bulk[1].id = priv->clk_bulk[0].id;
>   priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
>   priv->clk_bulk[0].id = id;
>   priv->clk_bulk[0].clk = clk;
> }
> 

Hi Marek,

This won't work as the name returned by this API is clk->core->name.
AFAICT, it doesn't correspond to the names present in the device tree
under the "clock-names" property.
Any other idea or are you fine with what's below?

Thanks,
Gatien

>> +    if (priv->data->nb_clock == 2) {
>> +        struct clk *clk;
>> +        struct clk *bus_clk;
>> +
>> +        clk = devm_clk_get(&ofdev->dev, "core");
>> +        if (IS_ERR(clk))
>> +            return PTR_ERR(clk);
>> +
>> +        bus_clk = devm_clk_get(&ofdev->dev, "bus");
>> +        if (IS_ERR(clk))
>> +            return PTR_ERR(bus_clk);
>> +
>> +        priv->clk_bulk[0].clk = clk;
>> +        priv->clk_bulk[0].id = "core";
>> +        priv->clk_bulk[1].clk = bus_clk;
>> +        priv->clk_bulk[1].id = "bus";
>> +    } else {
>> +        struct clk *clk;
>> +
>> +        clk = devm_clk_get(&ofdev->dev, NULL);
>> +        if (IS_ERR(clk))
>> +            return PTR_ERR(clk);
>> +
>> +        priv->clk_bulk[0].clk = clk;
>> +        priv->clk_bulk[0].id = "core";
>> +    }
> 
