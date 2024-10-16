Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A4165F1A;
	Wed, 16 Oct 2024 08:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729065804; cv=none; b=j1cuTavDx1gbq1mjt20dkL/Q1P+lo889l0EhcL16q3vRsvkWgEVCrCF8hvG9yEUnOHBF+aiC2FziTj3nnbX3xYqdVTAyP6/WzBn0jBLENkkTZLGoo9CiETJ+NiQCljuUFSkLczuZFZ/e8wob2XbezcJtFAsGO1hh+fGj7PMW/zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729065804; c=relaxed/simple;
	bh=DFikqo19SayUhwxpFxCxaYbGjVZY1En2Hg2xOPgktIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CxdRt2ezrwCgl95XFrD8mTrilHSZQZLFO9aOCWL8CdZZf6SD1fjYTIEnzzWLBhHdlEx4fOE4vuiM9+Lv80htaY49UfL3dgSCrVBKSAEPvEIUQitsbVvHDciBvfbI9mHzRxXtb5c2/ZPjDka+l+ngTYOmE+p8Dyr2oixRZnE02Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=wZQ8W61S; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="wZQ8W61S"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G6sjMl018446;
	Wed, 16 Oct 2024 10:03:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	dDbXP1ypjZvqBpQf3NNZh4juY6YR5BwVX+yEcMU8AeY=; b=wZQ8W61S+g48IfSZ
	Xw6brGKtcXYpt7dv3cY1g6wBH/z7ifinQCnpJFyrxz21zNv66Iiykwwbi6FlUnx+
	V7GC5q50s2ePjF2SS7ih61LJ4r8n6Wr4j99sdlvUJVwGi6qaTFLhhF//oDLaJT4Y
	jZSW/e9SWZ7TRdGHVNmNBUaWIdMXXvp0jkNb1FFUUVT9QNeM/+YgVoZ1cFdQ0eqO
	PC6mNTFL8jFrbALX+lY/fciBjM58IzF8R4z/qZNL7Bdu4GeWXblB/95v2pqwZayI
	OX9PWZi5ZS431p0765koJ60H1/zPMLVMdqKoLEQVB830vY343fcBwsyXgsX5nD3f
	qRwZ8Q==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 42a8mv8bmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:03:00 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 095D7400BD;
	Wed, 16 Oct 2024 10:01:35 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id CEF8323B7AF;
	Wed, 16 Oct 2024 10:00:22 +0200 (CEST)
Received: from [10.48.86.225] (10.48.86.225) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Wed, 16 Oct
 2024 10:00:22 +0200
Message-ID: <050d36ef-b674-4204-a731-7bcfb936e3aa@foss.st.com>
Date: Wed, 16 Oct 2024 10:00:21 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Rob Herring <robh@kernel.org>
CC: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime Coquelin
	<mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>, <marex@denx.de>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
 <20241015-rng-mp25-v2-v3-1-87630d73e5eb@foss.st.com>
 <20241015221740.GA2100600-robh@kernel.org>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <20241015221740.GA2100600-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/16/24 00:17, Rob Herring wrote:
> On Tue, Oct 15, 2024 at 06:48:54PM +0200, Gatien Chevallier wrote:
>> Add RNG STM32MP25x platforms compatible. Update the clock
>> properties management to support all versions.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> ---
>> Changes in V3:
>> 	- Add constraint on clock-names for st,stm32mp25-rng compatible
>>
>> Changes in V2
>> 	-Fix missing min/maxItems
>> 	-Removed MP25 RNG example
>> 	-Renamed RNG clocks for mp25 to "core" and "bus"
>> ---
>>   .../devicetree/bindings/rng/st,stm32-rng.yaml      | 34 +++++++++++++++++++++-
>>   1 file changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> index 340d01d481d12ce8664a60db42182ddaf0d1385b..c276723d566ce4a0d6deca10c491510644d842f8 100644
>> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> @@ -18,12 +18,20 @@ properties:
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
>> +    minItems: 1
>> +    items:
>> +      - const: core
>> +      - const: bus
>>   
>>     resets:
>>       maxItems: 1
>> @@ -57,6 +65,30 @@ allOf:
>>         properties:
>>           st,rng-lock-conf: false
>>   
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          contains:
>> +            enum:
>> +              - st,stm32-rng
>> +              - st,stm32mp13-rng
>> +    then:
>> +      properties:
>> +        clocks:
>> +          maxItems: 1
>> +        clock-names: false
> 
> It makes no sense that you allowed 1 entry, but then disallow the
> property. Either drop the 'minItems: 1' at the top level (keeping this)
> or put 'maxItems: 1' here,
> 
>> +    else:
>> +      properties:
>> +        clocks:
>> +          minItems: 2
>> +          maxItems: 2
> 
> maxItems is already 2. Only need minItems.
> 
>> +        clock-names:
>> +          items:
>> +            - const: core
>> +            - const: bus
> 
> You already defined the names, don't do it again. You need either
> nothing or 'minItems: 2' depending on the above.
> 

Actually, I'll do it the other way around, sorry for the noise.
I'll remove this and remove minItems at the top level to keep the
item list.

>> +      required:
>> +        - clock-names
>> +
>>   additionalProperties: false
>>   
>>   examples:
>>
>> -- 
>> 2.25.1
>>
