Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6CC15DBD5;
	Mon, 14 Oct 2024 10:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728900613; cv=none; b=Fkoyrx0rsyFrl/0eN6Z8f2Scli4wqrnAl8QigVFBWnhFSoXBnbtxIUHf5H3bMwOIkows8rYmcThyK5DtkYK24Yyd11fAXKp9Dm/0xpd5jKl6pOYSHR4vUoiIr9JvqYOea210X5W++iTlRSA5yFgU3xA0lnNoG4GVf2Tws0GHqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728900613; c=relaxed/simple;
	bh=R9nDdMYCodv3mgjnQ3UUV16ToRI3sVOOcpQ/+cwAnTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6LeCWNmKpCdLuQiGYfs2LLZtz2x0S+3+mLkCoGB50BtgselN/KegKSCHnhcJLWeMLGvfTWk8NyM4zOr5eTWyePEiMzUsPXHymP6VaScWdRa8Pc+RVVMi1rkvaMEb3+rXzBLXWpRjr/IzsfLRnKdfy+IxBHeyJzLsaFhs9fGyO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=LEXhWo72; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="LEXhWo72"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id B3B7589041;
	Mon, 14 Oct 2024 12:10:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728900609;
	bh=QiUcJ5vcf2TcgSQTpOZdp1C5MCiNDwYEw8zZRWzqkOQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LEXhWo72oK2AmGD8j3W9kqbymw42C0DBbUTfe37wOqQys1PXaBp6JVKvvAH5GnACD
	 ek6Em+m1PMzxDRFjkHwSbGeDCe0bgFoNT5hAzDDUNVGbjDIJtY3sgkV2l9vwWwXfDX
	 z6lzHMIVks6PVUSEVTwYeFMRevzWp1zwI0m9nu02C8JwirmjCmu85DgG+r0dqbdPLa
	 eCDQ3/WEnp2EAkSzxzclufuRqiLXeNVfr9g+spBiXgvvQXhxAlzoG60kjC5nH39eQo
	 cKC2Y844XhDSVurTFJ8YG/ZJe0MeUN6UoMJPkK0liyrcZcnXEVJC8ugStDdiSPfUva
	 PfwrYm3wh3WFw==
Message-ID: <8c13b0aa-7fb1-493c-9abc-5e5cfd982855@denx.de>
Date: Mon, 14 Oct 2024 10:52:38 +0200
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
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <f191d034-4116-4169-8c05-201450412bbd@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/14/24 10:38 AM, Gatien CHEVALLIER wrote:
> 
> 
> On 10/11/24 18:17, Marek Vasut wrote:
>> On 10/11/24 5:41 PM, Gatien Chevallier wrote:
>>
>> [...]
>>
>>> @@ -551,6 +565,41 @@ static int stm32_rng_probe(struct 
>>> platform_device *ofdev)
>>>       priv->rng.read = stm32_rng_read;
>>>       priv->rng.quality = 900;
>>> +    if (!priv->data->nb_clock || priv->data->nb_clock > 2)
>>> +        return -EINVAL;
>>> +
>>> +    priv->clk_bulk = devm_kzalloc(dev, priv->data->nb_clock * 
>>> sizeof(*priv->clk_bulk),
>>> +                      GFP_KERNEL);
>>> +    if (!priv->clk_bulk)
>>> +        return -ENOMEM;
>>
>> Try this:
>>
>> ret = devm_clk_bulk_get(dev, priv->data->nb_clock, priv->clk_bulk);
>> ...
>> // Swap the clock if they are not in the right order:
>> if (priv->data->nb_clock == 2 &&
>>      strcmp(__clk_get_name(priv->clk_bulk[0].clk), "core"))
>> {
>>   const char *id = priv->clk_bulk[1].id;
>>   struct clk *clk = priv->clk_bulk[1].clk;
>>   priv->clk_bulk[1].id = priv->clk_bulk[0].id;
>>   priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
>>   priv->clk_bulk[0].id = id;
>>   priv->clk_bulk[0].clk = clk;
>> }
>>
> 
> Hi Marek,
> 
> This won't work as the name returned by this API is clk->core->name.
> AFAICT, it doesn't correspond to the names present in the device tree
> under the "clock-names" property.
> Any other idea or are you fine with what's below?
Hmmm, it is not great, but at least it reduces the changes throughout 
the driver, so that is an improvement.

I guess one could do some of_clk_get() and clk_is_match() in probe to 
look up the clock in OF by name and then compare which clock is which 
before swapping them in clk_bulk[] array, but that might be too convoluted?
