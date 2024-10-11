Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A37F199941;
	Fri, 11 Oct 2024 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728663531; cv=none; b=IqSjC1emxMXTNVeQYLK/UqJ+ntcFMDlGwuBQqV0uLUaqUnonHcVFnEiE4Ej+0Wv2cvnde7SPLk5qFWXsxxsYiILvzTUsFmGgIfsp8h4z8NCPqh7uNjtCU6fWp+3zqO2M04+0Q8IrvCytW4CR/t10Dunplxp3GZWu+mG4DNyAAzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728663531; c=relaxed/simple;
	bh=K8T7vhTjxPwqAkaEtzLdQLN6TXzL+1tWceYblP+OEbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3NY1nxnZR4J7TnQepxj3l/niXgLOtn/0LtS1I1MX02bWCfsawDsqPZwgLfB3CCp3QOiswrQJ8DUAd6SaQ8prec4q5JPu3x6WwgMz0HdZfOrWr1iFfhEpViELjtd0v/g/SxhujmKcJJQg31mjUVaCb/3BndNB3w1zXELL7p6BKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CdN6M5+6; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CdN6M5+6"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 50E0A89386;
	Fri, 11 Oct 2024 18:18:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728663527;
	bh=knbUJOYVVLigaFfV1Maa2Dmr2xPGKb/0OGh2oD7ajnc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CdN6M5+61CW/RsuLF2CiAF7HwXoGjWwV3QO2LOJZnE5aPSwVMz6r+Zqnze/igo3Ve
	 sKuAzGuS2xr+hFxb4CRng2n7vK/0cdRVXLSnUZ47aoGg2AQw0AMHIXweUbbU6xu/bc
	 o9dvSJ/AeAi4Ml+PN5mmA82aU/jg4gkEtFb0yMDdi3N4UeFd01X/q/Q/k9NAAopkgh
	 M38tnEEooMrO//ioA5EDR83nD+qISHOokq2DX0zp5NI6p7h+LHlpigF4sfKxFgu9gX
	 J+IQr6sdOLvw3RH4gUVNdAXyeE4PHDU5Fugl1vHF/VfSFgsZOpbM6bo2V9X5x6eYZs
	 ucOPxHN824bTA==
Message-ID: <5db8deb4-8da6-44ef-91ab-7489975cc9e5@denx.de>
Date: Fri, 11 Oct 2024 18:18:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Lionel Debieve <lionel.debieve@foss.st.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Yang Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-3-gatien.chevallier@foss.st.com>
 <2fad1566-49f9-4586-b0d4-8a4a12f9e69e@denx.de>
 <9283caeb-1b84-43c2-a8a4-6b43a6962f34@foss.st.com>
 <b4932f99-cda4-42ef-88d8-461ca6e8cefd@denx.de>
 <6a4cccb4-9e55-437d-925b-5f5bb1804159@foss.st.com>
 <c59f3593-cb69-48c6-ab0e-f1275c7e5477@denx.de>
 <3817a22e-72aa-45d3-8e16-19c703f7f7af@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <3817a22e-72aa-45d3-8e16-19c703f7f7af@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/11/24 5:51 PM, Gatien CHEVALLIER wrote:
> 
> 
> On 10/11/24 14:38, Marek Vasut wrote:
>> On 10/11/24 2:07 PM, Gatien CHEVALLIER wrote:
>>>
>>>
>>> On 10/11/24 13:24, Marek Vasut wrote:
>>>> On 10/11/24 11:55 AM, Gatien CHEVALLIER wrote:
>>>>>
>>>>>
>>>>> On 10/7/24 15:54, Marek Vasut wrote:
>>>>>> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>>>>>>> Implement the support for STM32MP25x platforms. On this platform, a
>>>>>>> security clock is shared between some hardware blocks. For the RNG,
>>>>>>> it is the RNG kernel clock. Therefore, the gate is no more shared
>>>>>>> between the RNG bus and kernel clocks as on STM32MP1x platforms and
>>>>>>> the bus clock has to be managed on its own.
>>>>>>>
>>>>>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>>>>> A bit of a higher-level design question -- can you use drivers/ 
>>>>>> clk/ clk-bulk.c clk_bulk_*() to handle all these disparate count 
>>>>>> of clock easily ?
>>>>>
>>>>> Hi, I'd like to make sure that we enable the core clock before the bus
>>>>> clock so that the RNG hardware block can start its internal tests 
>>>>> while
>>>>> we ungate the bus clock. It's not a strong opinion but it feels 
>>>>> better.
>>>> Maybe this could still work if the struct clk_bulk_data {} is 
>>>> ordered that way, so the bus clock are first, and the rest afterward ?
>>>
>>> I guess you meant, the core first.
>>
>> Err, yes, core.
>>
>>> Putting the bus clock first with the updated YAML doc generates a
>>> warning when checking the bindings. I guess what you propose is OK
>>> then. Core clock is defined first in the device tree.
>>
>> Not in DT, leave DT as-is. Look at struct clk_bulk_data , I think when 
>> you use the clk_bulk_*() functions, you pass in a list of struct 
>> clk_bulk_data, which each describes one clock, so just make sure that 
>> list of struct clk_bulk_data in the driver is ordered the way you need 
>> it to be ordered and you should be fine.
> 
> I've sent a V2 with something that is functional but not aesthetic.
> You'll tell me if that's what you had in mind.
I sent you a slightly tweaked example which should work too and should 
be a bit nicer.
