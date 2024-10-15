Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FBE1CBA1C;
	Tue, 15 Oct 2024 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011345; cv=none; b=p+gxuj7Bj6XS78Dvnpzol0WD7KaAhleiISgxZBJJdheZC9E830Q4mzBGOKV4meFskZInoCKNru/fWcN9aW3C3YRSHwpA1fELbUYduBsr3JgKXswA/8MbALI5JTY8Z8r5FrzVWEaXp6TYbkBkDeudaKbjb61k91WqjWlHWX7gIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011345; c=relaxed/simple;
	bh=k2jFwJTmdqC0fGzcYrR+i3TTR8BBLw7WSqbSYcCyFUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3sghSmLdu4PwOE1LYfvH+sItMU9S47KJkMg8mEZXq4ZsD4QlzE095yxjlvDPfx8Im7MGA2aYOjfuBR84rFCIekXxKVHbyUiuHJYWphvkk9fuHvZSh9eIeTr3D3EUfPAnLsbxCZcc4lHyYrwiJEIXgwP0yrxZCcGD8ICPtEv9II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=dyJ8JWfX; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="dyJ8JWfX"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 3DE6488902;
	Tue, 15 Oct 2024 18:55:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1729011336;
	bh=QHhwrY1OnwvNGfEUyssvc2Kp8cTGixua2i+C3QVWTJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dyJ8JWfXSmudK9OM2hQM9dVmZrvvT0iXNqJHyvWZ2VXUoxwgWLMBMweWn8T9fNOKs
	 vxSZYUaq2/c1SZ86iItJjYMIilm+xFL2O2j2TGYi1u8bgAxShISfHxDeAE85OFCHEJ
	 UhX8yVhFntN8moe94pz6c/4ZncANv18yFo9e2DHS0SVT6iXCuNFyQIyXm5FJohniSm
	 kEwF7ivBjfZGaVAzP15erINsaoQggG02WZw7urXusgY3IuYGw9S69czOEfJv9HXIMm
	 wJd2OzP1yAp9GleZrhHiUuLapMmg+NvX1xbspUSwJxv5yI0Nr1ZzSRlrRaDnel7Vh3
	 ivKinliNgLcOg==
Message-ID: <e5a21bb8-00c3-41f1-9a4d-856eb1465d45@denx.de>
Date: Tue, 15 Oct 2024 17:39:51 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Lionel Debieve <lionel.debieve@foss.st.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
 <20241011-rng-mp25-v2-v2-2-76fd6170280c@foss.st.com>
 <318dbd5e-f547-4d78-b42e-4dcacc08d328@denx.de>
 <f191d034-4116-4169-8c05-201450412bbd@foss.st.com>
 <8c13b0aa-7fb1-493c-9abc-5e5cfd982855@denx.de>
 <d862765e-e396-4f7c-97ff-76df9aa03216@foss.st.com>
 <dca83197-3484-4d6b-8507-118bf9e80e19@denx.de>
 <b06b5d09-190b-4567-aecd-4be1f1dee172@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <b06b5d09-190b-4567-aecd-4be1f1dee172@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/15/24 5:10 PM, Gatien CHEVALLIER wrote:
> 
> 
> On 10/14/24 20:55, Marek Vasut wrote:
>> On 10/14/24 2:36 PM, Gatien CHEVALLIER wrote:
>>>
>>>
>>> On 10/14/24 10:52, Marek Vasut wrote:
>>>> On 10/14/24 10:38 AM, Gatien CHEVALLIER wrote:
>>>>>
>>>>>
>>>>> On 10/11/24 18:17, Marek Vasut wrote:
>>>>>> On 10/11/24 5:41 PM, Gatien Chevallier wrote:
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> @@ -551,6 +565,41 @@ static int stm32_rng_probe(struct 
>>>>>>> platform_device *ofdev)
>>>>>>>       priv->rng.read = stm32_rng_read;
>>>>>>>       priv->rng.quality = 900;
>>>>>>> +    if (!priv->data->nb_clock || priv->data->nb_clock > 2)
>>>>>>> +        return -EINVAL;
>>>>>>> +
>>>>>>> +    priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * 
>>>>>>> sizeof(*priv->clk_bulk),
>>>>>>> +                      GFP_KERNEL);
>>>>>>> +    if (!priv->clk_bulk)
>>>>>>> +        return -ENOMEM;
>>>>>>
>>>>>> Try this:
>>>>>>
>>>>>> ret = devm_clk_bulk_get(dev, priv->data->nb_clock, priv->clk_bulk);
>>>>>> ...
>>>>>> // Swap the clock if they are not in the right order:
>>>>>> if (priv->data->nb_clock == 2 &&
>>>>>>      strcmp(__clk_get_name(priv->clk_bulk[0].clk), "core"))
>>>>>> {
>>>>>>   const char *id = priv->clk_bulk[1].id;
>>>>>>   struct clk *clk = priv->clk_bulk[1].clk;
>>>>>>   priv->clk_bulk[1].id = priv->clk_bulk[0].id;
>>>>>>   priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
>>>>>>   priv->clk_bulk[0].id = id;
>>>>>>   priv->clk_bulk[0].clk = clk;
>>>>>> }
>>>>>>
>>>>>
>>>>> Hi Marek,
>>>>>
>>>>> This won't work as the name returned by this API is clk->core->name.
>>>>> AFAICT, it doesn't correspond to the names present in the device tree
>>>>> under the "clock-names" property.
>>>>> Any other idea or are you fine with what's below?
>>>> Hmmm, it is not great, but at least it reduces the changes 
>>>> throughout the driver, so that is an improvement.
>>>>
>>>> I guess one could do some of_clk_get() and clk_is_match() in probe 
>>>> to look up the clock in OF by name and then compare which clock is 
>>>> which before swapping them in clk_bulk[] array, but that might be 
>>>> too convoluted?
>>>
>>> Yes, probably too much. What's present in the patch is not close to
>>> perfection but has the advantage of being straightforward. If we agree
>>> on that, I'll send a V3 containing the modifications in the bindings
>>> file.
>> Errr, I'm sorry, maybe there is a way to do this better. Look at 
>> drivers/clk/clk-bulk.c :
>>
>>   15 static int __must_check of_clk_bulk_get(struct device_node *np, 
>> int num_clks,
>>   16                                         struct clk_bulk_data *clks)
>>   17 {
>>   18         int ret;
>>   19         int i;
>>   20
>>   21         for (i = 0; i < num_clks; i++) {
>>   22                 clks[i].id = NULL;
>>   23                 clks[i].clk = NULL;
>>   24         }
>>   25
>>   26         for (i = 0; i < num_clks; i++) {
>>   27                 of_property_read_string_index(np, "clock-names", 
>> i, &clks[i].id);
>>   28                 clks[i].clk = of_clk_get(np, i);
>>
>> If I read this right, then clks[i].id should be the DT clock name. So 
>> the swap conditional above could use .id to identify whether the first 
>> position is core clock or not, like this:
>>
>> if (priv->data->nb_clock == 2 &&
>>      strcmp(__clk_get_name(priv->clk_bulk[0].id), "core"))
>>                                              ^^
>>
>> You might need to use devm_clk_bulk_get_all() to access the 
>> of_clk_bulk_get() .
>>
>> Or am I missing something still ?
> 
> Oooooh I see, devm_clk_bulk_get() and devm_clk_bulk_get_all() use
> a different path. I don't understand why, to be honest... The doc
> doesn't state this difference either.

Indeed, but maybe git log could clarify that ? I learnt about this 
useful trick at last year Embedded Recipes:

$ git log -L:clk_bulk_get_all:drivers/clk/clk-bulk.c

> I'll give this a try while also correcting the issue that the robot
> highlighted.
Thank you !
