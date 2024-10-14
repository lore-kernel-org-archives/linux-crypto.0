Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A8C14A60F;
	Mon, 14 Oct 2024 09:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898615; cv=none; b=ZNJHMRgyc8MOxg3vnK7zeGn/OGvjbp0aCK3F3HNdZCyMdJil779YiSAQmuuYOQKweLlX1MUd4Ja1NTinMEn+fjYyJW9ZkOrDAXDWOMK+nZAlwbJ65hz6Qi3R4NFk1nzY7O1TbG01EYzM8AdaxuzMjFBytXgT8kGN5qDeMsffysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898615; c=relaxed/simple;
	bh=SsDzFXoQvN4gh5FLsiwia3cjb9QC2/XbGclc+wnSFVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UPTmNyp2PZzRIrtvAhm7zpghq3q+zzozmIyqaKe+p/B+CCTc/mQ7V432enQUsDyBwaZcNZf++PUzqsVBKF1lUVfhF0uYlHPLXsuovUEjKrHq8XQuQLyAcER/uB6Kr9p2QtEWntAN2R+jQMTMoRWmDWmvlO67th4baAMwACxBmQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=WqQK5CrW; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="WqQK5CrW"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49E54WgY026996;
	Mon, 14 Oct 2024 11:36:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	Y1wWLgOdlus18jZTNI/TrhpX0Z0nvcFkl1+WB4i8ztY=; b=WqQK5CrWjeZU47tj
	TsOh53c8+xSff02acMn8k+DhbbZPamiST1OctOcQIaKOHg7ry+zkJAgEMZOYiVjx
	clyOOSGk4Kd5XVYJr0NE6rzaSHY32/152XI4UACSiC0q18GkTDPwgiwY0knbE/yJ
	67b/yOpXeKzXu+6OOnz84sDQXeAcdRpX/yfsjUPsPdgQ8+CWgPaixmbhAa4Ba4Zj
	axUgqsFOJDFxop5hMmG66RMt9CKftlLcPdtHVM5WtdYy5YxhsINrwF/7ya9qOZz0
	+Gs9T2KAb6iDk1aGz4Hajs9U5uyXsa++0tGpviOVcKq34Lbffg3RhNrqNVjou6eO
	BOcK9A==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 427e85qff8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 11:36:05 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id A30B64004C;
	Mon, 14 Oct 2024 11:34:48 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4277D25F512;
	Mon, 14 Oct 2024 11:31:41 +0200 (CEST)
Received: from [10.252.14.29] (10.252.14.29) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 14 Oct
 2024 11:31:40 +0200
Message-ID: <f8c4de66-1d4f-480b-9137-f91e0323ecde@foss.st.com>
Date: Mon, 14 Oct 2024 11:31:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Krzysztof Kozlowski <krzk@kernel.org>
CC: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Rob Herring <robh@kernel.org>,
        Krzysztof
 Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime
 Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>, <marex@denx.de>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
 <20241011-rng-mp25-v2-v2-1-76fd6170280c@foss.st.com>
 <v4c7vwoqfposhm3bxnidjzwb7via7flf2em45qbgjjncwfvv74@n2rsz3ujpdoc>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <v4c7vwoqfposhm3bxnidjzwb7via7flf2em45qbgjjncwfvv74@n2rsz3ujpdoc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/14/24 09:29, Krzysztof Kozlowski wrote:
> On Fri, Oct 11, 2024 at 05:41:41PM +0200, Gatien Chevallier wrote:
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
>> @@ -57,6 +65,26 @@ allOf:
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
>> +    else:
>> +      properties:
>> +        clocks:
>> +          minItems: 2
>> +          maxItems: 2
> 
> Missing clock-names constraint. They *always* go in sync with clocks.
> 
> Best regards,
> Krzysztof
> 

Done for V3,

Best regards,
Gatien
