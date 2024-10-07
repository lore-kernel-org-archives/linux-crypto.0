Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3551D2711;
	Mon,  7 Oct 2024 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728318390; cv=none; b=RoPmetevjkDV5ayvnlzYH/njJdx0VZJzR0GuEhJg4fRWAqEzjCBMBkiS8ozAseMol5RjExVYglue1a0Cox6WpGlXdKdVLWl0cph0/F5yooLtvtvDYDB+KwJSaAbnZuuCo3JGvq5o6glU2voNCkEvCd6bIYX1pzVJXTJfFs/6xIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728318390; c=relaxed/simple;
	bh=+eKgMrdaPBOYQkRIkAx9UUWLoKcyyWqbe+bmsbTse/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=STvJExvEecqjBlZNOtCLaJOJSoVrkptUNXce6x7KDbFHm4J7qbqSQmeHubMLS4MtHkBVb+gbZTrQNMG9vcpWV8B7I6/91whrwQ577mvuSV4HK8zQ0ll45krai5EVihub4gSzZlpyoYW7cb5WEP+Cvhs1UohwojUZ9uGKKUpIbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ygzSG/wY; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ygzSG/wY"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497D1ZBM032450;
	Mon, 7 Oct 2024 18:25:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	LRtzkv5xMyDZ1ZZLcrbVYBvEEe9KziXBz/FhHNmAcJM=; b=ygzSG/wY3z2iznBM
	/mexUEQ3YUW+I4IlY2806Bbs4giEc1T9HOLXuY3Ww96cTzKinNfKcXo1uql0OkkR
	a1jtGmhUyQ7vzH1kUb+7n89CnnhlZEDppookgTtf2M9l6+FXgJt+KqpphRDZxHiq
	lcHTzxiwDySPTEozz3SmP+i2bzgU7YEDzpodtTvgYMGc0Y52EKhxLpLdqTLmjftS
	CvQgJ3FXIFEP1535dnZYIE/KzXDhh3+bdwXCcsux+bdyU4MS+iv2ErvYMMuBg7qL
	y1mXfM0pNa+DsexGxChb9boSvflwE5y0VxF7bBqLWKD5UiV5WhURxYfwyqNwqBoe
	nwapog==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 422xtq1k7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 18:25:50 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 1066040048;
	Mon,  7 Oct 2024 18:23:58 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 010AE238C4F;
	Mon,  7 Oct 2024 18:22:58 +0200 (CEST)
Received: from [10.48.86.225] (10.48.86.225) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 18:22:56 +0200
Message-ID: <c425507f-5e78-408e-8a8d-fe02412a76e7@foss.st.com>
Date: Mon, 7 Oct 2024 18:22:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Olivia Mackall
	<olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring
	<robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>
CC: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Lionel
 Debieve <lionel.debieve@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yang
 Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-2-gatien.chevallier@foss.st.com>
 <ec3cda71-57d0-4ec1-b9d8-62381667f7d6@linaro.org>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <ec3cda71-57d0-4ec1-b9d8-62381667f7d6@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/7/24 17:00, Krzysztof Kozlowski wrote:
> On 07/10/2024 15:27, Gatien Chevallier wrote:
>> Add RNG STM32MP25x platforms compatible. Update the clock
>> properties management to support all versions.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> 
> You CC-ed an address, which suggests you do not work on mainline kernel
> or you do not use get_maintainers.pl/b4/patman. Regardless of the
> reason, process needs improvement: please CC correct address.
> 

Hi,

I'm using get_maintainers.pl so I'll check why I have an issue.

>> ---
>>   .../devicetree/bindings/rng/st,stm32-rng.yaml | 41 +++++++++++++++++--
>>   1 file changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> index 340d01d481d1..c92ce92b6ac9 100644
>> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> @@ -18,12 +18,19 @@ properties:
>>       enum:
>>         - st,stm32-rng
>>         - st,stm32mp13-rng
>> +      - st,stm32mp25-rng
>>   
>>     reg:
>>       maxItems: 1
>>   
>>     clocks:
>> -    maxItems: 1
>> +    minItems: 1
>> +    maxItems: 2
>> +
>> +  clock-names:
> 
> Missing minItems
> 

Ok, will add in V2

>> +    items:
>> +      - const: rng_clk
>> +      - const: rng_hclk
> 
> Drop _clk and come with some reasonable names, e.g. "core" and "bus"?
> 

Sure, makes sense. Will change in V2.

>>   
>>     resets:
>>       maxItems: 1
>> @@ -57,15 +64,43 @@ allOf:
>>         properties:
>>           st,rng-lock-conf: false
>>   
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          contains:
>> +            enum:
>> +              - st,stm32mp25-rng
>> +    then:
>> +      properties:
>> +        clocks:
>> +          description: >
>> +            RNG bus clock must be named "rng_hclk". The RNG kernel clock
>> +            must be named "rng_clk".
> 
> Drop description, useless.
> 
> Missing minItems
> 

Ok, will update in V2

>> +          maxItems: 2
>> +      required:
>> +        - clock-names
>> +    else:
>> +      properties:
>> +        clocks:
>> +          maxItems: 1
> 
> Missing constrain for clock-names.
> 
>> +
>>   additionalProperties: false
>>   
>>   examples:
>>     - |
>> -    #include <dt-bindings/clock/stm32mp1-clks.h>
> 
> Why?
> 
>>       rng@54003000 {
>>         compatible = "st,stm32-rng";
>>         reg = <0x54003000 0x400>;
>> -      clocks = <&rcc RNG1_K>;
>> +      clocks = <&rcc 124>;
> 
> Why?
> 
> 

I have an issue with the generated st,stm32-rng.example.dts example.
Because there are 2 binding files included, I have a collision with
clock bindings names between the "dt-bindings/clock/stm32mp1-clks.h"
and the "dt-bindings/clock/st,stm32mp25-rcc.h" files. For example:
CK_MCO1 or CK_SCMI_HSE. I replaced the bindings with numbers
to avoid this conflict.

If you think this binding update does not need the addition of an
example, I'll completely drop it and we won't have the issue.

Best regards,
Gatien

>>       };
>>   
>> +  - |
>> +    rng: rng@42020000 {
>> +      compatible = "st,stm32mp25-rng";
>> +      reg = <0x42020000 0x400>;
>> +      clocks = <&clk_rcbsec>, <&rcc 110>;
>> +      clock-names = "rng_clk", "rng_hclk";
>> +      resets = <&rcc 97>;
>> +      access-controllers = <&rifsc 92>;
> 
> 
> Difference in one property should not need new example, usually.
> 
> Best regards,
> Krzysztof
> 
