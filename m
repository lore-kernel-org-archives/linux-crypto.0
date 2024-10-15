Received: from mx08-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E451CBA07;
	Tue, 15 Oct 2024 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005232; cv=none; b=hnqH6U7oUHUCZKjAVYdOAgcIhAoP8EJSxrdPPflCUAEpGMwawOSU4wI0Z7V01+BOB3QXCnogOY7nxDmA38NBQTqlFIv8wtUMEeJ7kQleOmYMVCbE0OheLr2iYKJTqCwYyhU9ywrVc3RMW3hOvDDeqyp3AkOEJdq56X1GOQE8N/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005232; c=relaxed/simple;
	bh=+86IxgdbxFu5HPifRMcvxvMw5j37XxVXLVL3jKuTy78=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dCXJpCXspdULzu9QPR29cr19Wued/bZNLIK42zcJebip/WZSIRWjqkZj2raNJ1azg6cl41/NGYXIns0PA49ejHvzfasBCy9ShEaL2NZCtOLN6y2fOpACZ3mZiqCiICYCUdp7TzCTRwTrRINE21GyvPsRgIIo/evCS0BOdcJMNDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=GDlG9Xxr; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="GDlG9Xxr"
Received: from pps.filterd (m0369457.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FBfd0r018076;
	Tue, 15 Oct 2024 17:13:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	A880Q2OSXTrE9WU64cKIX0T+jtcm1ta1QT9Gr1T9Cjw=; b=GDlG9XxrD0ZiJF55
	6g4imFbr0sP/QNSHD5H8aM6tnUZXaO5hzxCiAWDLVbUv3SkSL4uBBjMV8+xHlX3N
	+KCOSHPabgorYURUTTZ6l7nZRkckiX/+iWC6vAtPaqZoICr9ve3gYP5Ya8+yHpg+
	sTOK+rSutGZ9YwTkW4+KoGW9C+FysH+4qs8toe+ISKVXLibY3dOTCXSRBK9OKnwe
	42Ye9HE/5SFru6rrn1K6kYiQ5LW5MVsbzBPy8pFfKiDyhpjAhIBPEEw8J8q11WjO
	R2NlhWbxACeyzZBwRdsh9sbSp9rcKxTD/fpnHzRiXf8j+wbnDJe53aCa9cGNZuuh
	S3MWDA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 42842jb63c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 17:13:21 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id CFBEB40068;
	Tue, 15 Oct 2024 17:12:04 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id A917523CB46;
	Tue, 15 Oct 2024 17:11:04 +0200 (CEST)
Received: from [10.48.86.225] (10.48.86.225) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Tue, 15 Oct
 2024 17:11:03 +0200
Message-ID: <b06b5d09-190b-4567-aecd-4be1f1dee172@foss.st.com>
Date: Tue, 15 Oct 2024 17:10:58 +0200
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
 <d862765e-e396-4f7c-97ff-76df9aa03216@foss.st.com>
 <dca83197-3484-4d6b-8507-118bf9e80e19@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <dca83197-3484-4d6b-8507-118bf9e80e19@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/14/24 20:55, Marek Vasut wrote:
> On 10/14/24 2:36 PM, Gatien CHEVALLIER wrote:
>>
>>
>> On 10/14/24 10:52, Marek Vasut wrote:
>>> On 10/14/24 10:38 AM, Gatien CHEVALLIER wrote:
>>>>
>>>>
>>>> On 10/11/24 18:17, Marek Vasut wrote:
>>>>> On 10/11/24 5:41 PM, Gatien Chevallier wrote:
>>>>>
>>>>> [...]
>>>>>
>>>>>> @@ -551,6 +565,41 @@ static int stm32_rng_probe(struct 
>>>>>> platform_device *ofdev)
>>>>>>       priv->rng.read = stm32_rng_read;
>>>>>>       priv->rng.quality = 900;
>>>>>> +    if (!priv->data->nb_clock || priv->data->nb_clock > 2)
>>>>>> +        return -EINVAL;
>>>>>> +
>>>>>> +    priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * 
>>>>>> sizeof(*priv->clk_bulk),
>>>>>> +                      GFP_KERNEL);
>>>>>> +    if (!priv->clk_bulk)
>>>>>> +        return -ENOMEM;
>>>>>
>>>>> Try this:
>>>>>
>>>>> ret = devm_clk_bulk_get(dev, priv->data->nb_clock, priv->clk_bulk);
>>>>> ...
>>>>> // Swap the clock if they are not in the right order:
>>>>> if (priv->data->nb_clock == 2 &&
>>>>>      strcmp(__clk_get_name(priv->clk_bulk[0].clk), "core"))
>>>>> {
>>>>>   const char *id = priv->clk_bulk[1].id;
>>>>>   struct clk *clk = priv->clk_bulk[1].clk;
>>>>>   priv->clk_bulk[1].id = priv->clk_bulk[0].id;
>>>>>   priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
>>>>>   priv->clk_bulk[0].id = id;
>>>>>   priv->clk_bulk[0].clk = clk;
>>>>> }
>>>>>
>>>>
>>>> Hi Marek,
>>>>
>>>> This won't work as the name returned by this API is clk->core->name.
>>>> AFAICT, it doesn't correspond to the names present in the device tree
>>>> under the "clock-names" property.
>>>> Any other idea or are you fine with what's below?
>>> Hmmm, it is not great, but at least it reduces the changes throughout 
>>> the driver, so that is an improvement.
>>>
>>> I guess one could do some of_clk_get() and clk_is_match() in probe to 
>>> look up the clock in OF by name and then compare which clock is which 
>>> before swapping them in clk_bulk[] array, but that might be too 
>>> convoluted?
>>
>> Yes, probably too much. What's present in the patch is not close to
>> perfection but has the advantage of being straightforward. If we agree
>> on that, I'll send a V3 containing the modifications in the bindings
>> file.
> Errr, I'm sorry, maybe there is a way to do this better. Look at 
> drivers/clk/clk-bulk.c :
> 
>   15 static int __must_check of_clk_bulk_get(struct device_node *np, int 
> num_clks,
>   16                                         struct clk_bulk_data *clks)
>   17 {
>   18         int ret;
>   19         int i;
>   20
>   21         for (i = 0; i < num_clks; i++) {
>   22                 clks[i].id = NULL;
>   23                 clks[i].clk = NULL;
>   24         }
>   25
>   26         for (i = 0; i < num_clks; i++) {
>   27                 of_property_read_string_index(np, "clock-names", i, 
> &clks[i].id);
>   28                 clks[i].clk = of_clk_get(np, i);
> 
> If I read this right, then clks[i].id should be the DT clock name. So 
> the swap conditional above could use .id to identify whether the first 
> position is core clock or not, like this:
> 
> if (priv->data->nb_clock == 2 &&
>      strcmp(__clk_get_name(priv->clk_bulk[0].id), "core"))
>                                              ^^
> 
> You might need to use devm_clk_bulk_get_all() to access the 
> of_clk_bulk_get() .
> 
> Or am I missing something still ?

Oooooh I see, devm_clk_bulk_get() and devm_clk_bulk_get_all() use
a different path. I don't understand why, to be honest... The doc
doesn't state this difference either.

I'll give this a try while also correcting the issue that the robot
highlighted.

Best regards,
Gatien
