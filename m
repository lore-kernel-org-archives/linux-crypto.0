Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8521D45FF;
	Mon,  7 Oct 2024 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313227; cv=none; b=u5XIiYxv3w4Dlf9nloNBVOfgZDbrLXCXwdaOW7YRkk3eF4gmV1iXvFaD2JlJRggawB9yR9OXUeNcEkk1O9M2F0TPoxH59BHEJavwitC6kXDWwgMSKD4x9E2dd5k1lYuUXkdK0teJRavGGBF1neNu/LSUlyQzVX/+fewy8ZwOxIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313227; c=relaxed/simple;
	bh=XVAzbaIIhFFe5lynUDZs7JKyFb3ss6nsbfmrEvX1kyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=a0lrifR6uao0513Do9N9zEd1zd3SwIX1G3nVFji81UzU3DmUL/zMNMaigAegccw4caN4zi0T9TEozBo5Duu07bU4NJxljtNt5LJIIepyE/FafLk1o5kAeKKwmphmsW6pn/1R/6dYX87HhBKeU2qGGgh0HSLJPXsTPWnhyTWeDoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=faxNql5f; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="faxNql5f"
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497BL5xg003601;
	Mon, 7 Oct 2024 16:59:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	BJ8Knk1OilaXvESuSFI3aU6RMgbAH9yejobycbQkYhg=; b=faxNql5faKfAou6p
	EZ+UECY5U+KLZiBJtDX1R4fkCO+eRfv/PxOodhiM2F9+CfvRiHFNJltQrMyARQu+
	GqXh/y0uf2LAAm0DYLsOOHKKH0nQE4/utct4UE5ErMfuEm5EO7A7DY1Sa2G7Wszh
	nsB72b33nxoXkKlgni+In0vQrPpTTIE98wO9PN392ts5YhC/FwIKtthF62DuNtjb
	RygPljlMDnOfnAsN7ncI/MNIhP2Woteuac0GIijAn1siZe8KcoTEnowX+yOOpbQ3
	E5lVd8jG7FevDcGGtKMe6T4syzrH8i8QGIozLNvOsRQnQMJ5WeKBTnSdawgjdVqh
	8Pl7bw==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 423f10pt0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 16:59:53 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id A773E40048;
	Mon,  7 Oct 2024 16:58:23 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 379592216F8;
	Mon,  7 Oct 2024 16:57:27 +0200 (CEST)
Received: from [10.48.86.225] (10.48.86.225) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 16:57:26 +0200
Message-ID: <2e1ee778-06b1-4cb3-b10a-6f5a97338d82@foss.st.com>
Date: Mon, 7 Oct 2024 16:57:20 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Marek Vasut <marex@denx.de>, Olivia Mackall <olivia@selenic.com>,
        Herbert
 Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre
 Torgue <alexandre.torgue@foss.st.com>
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
 <a7b2d849-ce6c-46b3-bf4f-c619106e2edd@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <a7b2d849-ce6c-46b3-bf4f-c619106e2edd@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/7/24 15:53, Marek Vasut wrote:
> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>> Add RNG STM32MP25x platforms compatible. Update the clock
>> properties management to support all versions.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> ---
>>   .../devicetree/bindings/rng/st,stm32-rng.yaml | 41 +++++++++++++++++--
>>   1 file changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml 
>> b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> index 340d01d481d1..c92ce92b6ac9 100644
>> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>> @@ -18,12 +18,19 @@ properties:
>>       enum:
>>         - st,stm32-rng
>>         - st,stm32mp13-rng
>> +      - st,stm32mp25-rng
>>     reg:
>>       maxItems: 1
>>     clocks:
>> -    maxItems: 1
>> +    minItems: 1
>> +    maxItems: 2
>> +
>> +  clock-names:
>> +    items:
>> +      - const: rng_clk
>> +      - const: rng_hclk
>>     resets:
>>       maxItems: 1
>> @@ -57,15 +64,43 @@ allOf:
>>         properties:
>>           st,rng-lock-conf: false
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          contains:
>> +            enum:
>> +              - st,stm32mp25-rng
> Maybe this match should be inverted, it is likely the next generation of 
> stm32 will also use 2 input clock into the RNG block and it will be only 
> the legacy MP1 that uses one clock.

Hi, sure, makes more sense, I'll change it for V2.

Gatien
