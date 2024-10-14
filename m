Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D80B1A0726;
	Mon, 14 Oct 2024 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909731; cv=none; b=AVmDu2VMkOEsawegQOagFfDaCQf55XL6C3xQKQCMlh2PFRFcnPQeDw9SOJQ9hC8vWYOJLdX8ev0C6mZqR95uf39VuDK/utFgky29dI09dLSG0Fh4OS6bCero0FvWWjosdZe4ZJIRoDRhbuz7MQrTO2h/ra8VrJgW2m+N6gEtpT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909731; c=relaxed/simple;
	bh=siwxZ990WVReYQTp5BU84u61TZnBwHllWJmTTlrmi/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kvKzJDyvXUNxEnKKv+uJ8zjh+3i5W1xbzDWxWihf98Xgf7GbflEXYcUlkNT1aMbVW7eq/TCQY1Uv4Iwj0DsBN4i/3FXfh6tP9bVTI1Cgs2s6c2NRz6Tf9I+rgVQ6hBwGYBSQ1odGqbFZezsxLf/mmxZ8B3LKzis22gTDPHOvLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=S1L6QIFM; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="S1L6QIFM"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EA1LYb021364;
	Mon, 14 Oct 2024 14:41:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	meVxP/72UxtTH816mMUL0SiTexlDHbve/hY9rxQg5uA=; b=S1L6QIFMEQcaz9px
	3ku77xK3UU2Y7DIxrJZFE4j/dQGFBDrlNZItWy6CSRTht823n520KH2PspoWzSHv
	I2vmI50o1j8yuiD73MYRitb1LmGdvaoJM2qQMCA73twaXkdklcR8P6KhfJQKt7Xe
	pT+lZs830jyeGjO6J7YgRLaaiIjB2WBrdsO6LvkDx9XGrQc2M9w5d1heKpYIU4/A
	nrO2aegzI6J/b3LLpnBQPkzFJLVZDkrgsXVeO3628JeSKypiR/BjQhnzAqW43JJ/
	ub7GHFYhZIuMEHw+KQiDGb/6LzzjENxun5ZV6/VUn1ErSvZ8bF0UvydBh7zkVx3d
	nY6O2w==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 427g0bg2pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 14:41:41 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 468D24004F;
	Mon, 14 Oct 2024 14:40:25 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7066526B65F;
	Mon, 14 Oct 2024 14:36:51 +0200 (CEST)
Received: from [10.252.25.66] (10.252.25.66) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 14 Oct
 2024 14:36:50 +0200
Message-ID: <d862765e-e396-4f7c-97ff-76df9aa03216@foss.st.com>
Date: Mon, 14 Oct 2024 14:36:39 +0200
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
 <f191d034-4116-4169-8c05-201450412bbd@foss.st.com>
 <8c13b0aa-7fb1-493c-9abc-5e5cfd982855@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <8c13b0aa-7fb1-493c-9abc-5e5cfd982855@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE1.st.com (10.75.129.72) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/14/24 10:52, Marek Vasut wrote:
> On 10/14/24 10:38 AM, Gatien CHEVALLIER wrote:
>>
>>
>> On 10/11/24 18:17, Marek Vasut wrote:
>>> On 10/11/24 5:41 PM, Gatien Chevallier wrote:
>>>
>>> [...]
>>>
>>>> @@ -551,6 +565,41 @@ static int stm32_rng_probe(struct 
>>>> platform_device *ofdev)
>>>>       priv->rng.read = stm32_rng_read;
>>>>       priv->rng.quality = 900;
>>>> +    if (!priv->data->nb_clock || priv->data->nb_clock > 2)
>>>> +        return -EINVAL;
>>>> +
>>>> +    priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * 
>>>> sizeof(*priv->clk_bulk),
>>>> +                      GFP_KERNEL);
>>>> +    if (!priv->clk_bulk)
>>>> +        return -ENOMEM;
>>>
>>> Try this:
>>>
>>> ret = devm_clk_bulk_get(dev, priv->data->nb_clock, priv->clk_bulk);
>>> ...
>>> // Swap the clock if they are not in the right order:
>>> if (priv->data->nb_clock == 2 &&
>>>      strcmp(__clk_get_name(priv->clk_bulk[0].clk), "core"))
>>> {
>>>   const char *id = priv->clk_bulk[1].id;
>>>   struct clk *clk = priv->clk_bulk[1].clk;
>>>   priv->clk_bulk[1].id = priv->clk_bulk[0].id;
>>>   priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
>>>   priv->clk_bulk[0].id = id;
>>>   priv->clk_bulk[0].clk = clk;
>>> }
>>>
>>
>> Hi Marek,
>>
>> This won't work as the name returned by this API is clk->core->name.
>> AFAICT, it doesn't correspond to the names present in the device tree
>> under the "clock-names" property.
>> Any other idea or are you fine with what's below?
> Hmmm, it is not great, but at least it reduces the changes throughout 
> the driver, so that is an improvement.
> 
> I guess one could do some of_clk_get() and clk_is_match() in probe to 
> look up the clock in OF by name and then compare which clock is which 
> before swapping them in clk_bulk[] array, but that might be too convoluted?

Yes, probably too much. What's present in the patch is not close to
perfection but has the advantage of being straightforward. If we agree
on that, I'll send a V3 containing the modifications in the bindings
file.

Thanks for reviewing,
Gatien
