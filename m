Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A822F1D9582;
	Mon,  7 Oct 2024 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728317194; cv=none; b=G7hGSVG9uXxM5tuB8V8o6hgZX/9KRAyJXkUiUORhxOW05/ggy8WmHTr99LYKkhlGdskHA6bukzZ/grRMcvg6uZtSEvv/bqGi6sMtkTq/fjY376yOzx7Iav3Mu6rjjZyA4Xy1sCgZIvpfSPumBeeuG8uhS2CxiS4EA/qGJTEPntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728317194; c=relaxed/simple;
	bh=ZB7dJsypTuR1cUU9qPEOx0uhoQUFPI2vkMQHPzvOWaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iZDeJc0uUJsblLyN4FjvcnKewdSMZZY789+AVol5LxTr0+3Z/yH70SYIe5FHJekyWI1AC0q06xeP3OZjzBriKyq7CD7LqRmF6XLBnJE3hSb6Zwdb3RxfqWyMGIW5DFD5wh7rGNO7UJrli0OQY+5XExVSfUqH1ZTTT54UycJXE1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gSMDu+29; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gSMDu+29"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 94C2788365;
	Mon,  7 Oct 2024 18:06:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728317187;
	bh=bBYRA6NEh1wZmuhBNUB2eKeJd8Vp9PBvM/JZVxPF1OA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gSMDu+291Aga5QM8YL6kApKlCmxHXLu87h6qft6qEZp+A13AW4MogX5DmmdmCbQdy
	 rVqdKXHwY2WZh2fmJpMzaMxOQ2emWpl5WjZ4TrOXXGVFOAHJIj5PXENRMxlRVuuYLa
	 MhSAKrBS6SMdBjejjWtCp5WMkvavtRECwbT6fdr0bSsEqYvXK6xQOT9Ivo0AOkOmK7
	 uHhij0+CH4bA7UbrDe0zrBAiKlPhsHcWu2sB8Yym4WZQaEud0mcLKq5QN8bDIa4cWA
	 NpzPlWJ43mj2fcfaYEZ998C9iuOwnx3Tidbr8hMiQfzjkE7xHjOux7n9lH95UHZwGd
	 swbrM8lFZTvCA==
Message-ID: <7adc1fb2-8dec-454c-a6e7-edd00c759c70@denx.de>
Date: Mon, 7 Oct 2024 17:42:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] arm64: dts: st: add RNG node on stm32mp251
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
 <20241007132721.168428-5-gatien.chevallier@foss.st.com>
 <869fe073-c20f-4611-ae84-8268a890a12c@denx.de>
 <d4bfc454-5a20-4cee-85f6-118323c46eca@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <d4bfc454-5a20-4cee-85f6-118323c46eca@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/7/24 4:59 PM, Gatien CHEVALLIER wrote:
> 
> 
> On 10/7/24 15:55, Marek Vasut wrote:
>> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>>> Update the device-tree stm32mp251.dtsi by adding the Random Number
>>> Generator(RNG) node.
>>>
>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>> ---
>>>   arch/arm64/boot/dts/st/stm32mp251.dtsi | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/ 
>>> boot/dts/st/stm32mp251.dtsi
>>> index 1167cf63d7e8..40b96353a803 100644
>>> --- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
>>> +++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
>>> @@ -493,6 +493,16 @@ uart8: serial@40380000 {
>>>                   status = "disabled";
>>>               };
>>> +            rng: rng@42020000 {
>>> +                compatible = "st,stm32mp25-rng";
>>> +                reg = <0x42020000 0x400>;
>>> +                clocks = <&clk_rcbsec>, <&rcc CK_BUS_RNG>;
>>> +                clock-names = "rng_clk", "rng_hclk";
>>> +                resets = <&rcc RNG_R>;
>>> +                access-controllers = <&rifsc 92>;
>> It would be good if someone finally sorted the access-controllers 
>> property in all the MP2 nodes alphabetically ; that's separate patch/ 
>> series though.
> 
> I'll pin your comment to take a look into that in the near future.
Thank you !
