Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB78121F;
	Fri, 11 Oct 2024 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728662312; cv=none; b=NlU/k01P085Rrj0CrvkRpW6CYZLFQk8QEC6Y6mfZyxzwDY4+KE51CPjEqOMyqT0cjDNEy0sipFlfzJtWZ4sW57Eiue2/RaPBoNmSGhSRWTnL+8atiaCkSh4CXZxtHTuLLRqRjDc2NiC/39nUUII8sqsbfdcGktCPXB4zv1kIvW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728662312; c=relaxed/simple;
	bh=/s8DCE6D6Ua9EmUIktxcY8jd/379RJ43MxlXPbFrHJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Wb6N0HPat7oZflByVr7NwODE2IkQOZtc/EFlDCotbu5/qzlK8SSuD1bgGmXrfk4mV1dCNH8BgdXZGxzExcfYn53fm5HjsztGZ4ywP2hZLNhsM/HhfHNX63/HljKchfq00/S6cbLKwy8HhI8HFG81zOSskc1zPPVCXFCQPFlR5J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=7nccX1ru; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="7nccX1ru"
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BC8t96019689;
	Fri, 11 Oct 2024 17:58:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	OHz3y/5Y8VHqEKFRloReVKDmCuuarSXTQ79JSws0eF8=; b=7nccX1ruGj+/RJf9
	rK/uSIr4NPAKKO8VIXpBqEOA4lntUsw+0JRg4gtm6sYhEUEGUzJdThCPkOeuByAO
	ixoLsOYlGzxysELO7+kBOD2w5YocEqPI3pmDfcFT2mvC3bOrzA4xuzEsI1q+ciU6
	rmGmsClwiV+v4BY9iJSXpIKF6gtZSEP6y0Afe8osLqknFKnY0YgUhu2LChWSpzsF
	6U4p8MpDjXN+lZAfjNXm8QaLHUPUrx2EIS2Tn4eOSWZKlfb9mgY6pviYJ5tPvx5f
	zNWcs/12q2vUeWFXGZqpeol7G/HhMPFoiKD84AR5bDwA7Yi5Hl2PYnGCZsUJUTUx
	MPIR6A==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 4263439v5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 17:58:00 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id C685440048;
	Fri, 11 Oct 2024 17:56:29 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 35AE229ADFB;
	Fri, 11 Oct 2024 17:51:34 +0200 (CEST)
Received: from [10.252.28.117] (10.252.28.117) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Fri, 11 Oct
 2024 17:51:33 +0200
Message-ID: <3817a22e-72aa-45d3-8e16-19c703f7f7af@foss.st.com>
Date: Fri, 11 Oct 2024 17:51:32 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
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
 <20241007132721.168428-3-gatien.chevallier@foss.st.com>
 <2fad1566-49f9-4586-b0d4-8a4a12f9e69e@denx.de>
 <9283caeb-1b84-43c2-a8a4-6b43a6962f34@foss.st.com>
 <b4932f99-cda4-42ef-88d8-461ca6e8cefd@denx.de>
 <6a4cccb4-9e55-437d-925b-5f5bb1804159@foss.st.com>
 <c59f3593-cb69-48c6-ab0e-f1275c7e5477@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <c59f3593-cb69-48c6-ab0e-f1275c7e5477@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/11/24 14:38, Marek Vasut wrote:
> On 10/11/24 2:07 PM, Gatien CHEVALLIER wrote:
>>
>>
>> On 10/11/24 13:24, Marek Vasut wrote:
>>> On 10/11/24 11:55 AM, Gatien CHEVALLIER wrote:
>>>>
>>>>
>>>> On 10/7/24 15:54, Marek Vasut wrote:
>>>>> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>>>>>> Implement the support for STM32MP25x platforms. On this platform, a
>>>>>> security clock is shared between some hardware blocks. For the RNG,
>>>>>> it is the RNG kernel clock. Therefore, the gate is no more shared
>>>>>> between the RNG bus and kernel clocks as on STM32MP1x platforms and
>>>>>> the bus clock has to be managed on its own.
>>>>>>
>>>>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>>>> A bit of a higher-level design question -- can you use drivers/clk/ 
>>>>> clk-bulk.c clk_bulk_*() to handle all these disparate count of 
>>>>> clock easily ?
>>>>
>>>> Hi, I'd like to make sure that we enable the core clock before the bus
>>>> clock so that the RNG hardware block can start its internal tests while
>>>> we ungate the bus clock. It's not a strong opinion but it feels better.
>>> Maybe this could still work if the struct clk_bulk_data {} is ordered 
>>> that way, so the bus clock are first, and the rest afterward ?
>>
>> I guess you meant, the core first.
> 
> Err, yes, core.
> 
>> Putting the bus clock first with the updated YAML doc generates a
>> warning when checking the bindings. I guess what you propose is OK
>> then. Core clock is defined first in the device tree.
> 
> Not in DT, leave DT as-is. Look at struct clk_bulk_data , I think when 
> you use the clk_bulk_*() functions, you pass in a list of struct 
> clk_bulk_data, which each describes one clock, so just make sure that 
> list of struct clk_bulk_data in the driver is ordered the way you need 
> it to be ordered and you should be fine.

I've sent a V2 with something that is functional but not aesthetic.
You'll tell me if that's what you had in mind.

Best regards,
Gatien
