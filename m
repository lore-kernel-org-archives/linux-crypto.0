Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89820C462;
	Fri, 11 Oct 2024 10:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728640935; cv=none; b=s/LxQFyRbtaLcmdw2Pg/pQX5hCwDrCkp3vppfQs7gI9micdzsq1CJF/rk7ISoKvE/Kmc7NJuOiDnR58T5xVr/5tlEvyOb8zEnUjBzq4qL6SYkCwwTdYdN7l66AQ+ZSLKH9UWwn564AOl+q0mBgNoRqAyGjK3cgmge/di9E2EHZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728640935; c=relaxed/simple;
	bh=3p58vwjm0mX+q1bBDxCzK98sObgMUqPvTC/bY3+/RIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ELgB0LJ26T8cULSq8L+AoqUMaG1+k+DTdQIy2S8s1Q0Ns/X3OuMpxNPJ1YovaZO2D7nRu1jFUjpU6YoOgVdg3WlnDR0OEgsLGZZBOQLiGtYoB4lXsI1FhgHS0iSEF+RyvUr3KfTjSA3/wDA3Urc+VUggT6xgj9Px1T4eqNEJK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=8cTmyw6+; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="8cTmyw6+"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49B7kBUt015393;
	Fri, 11 Oct 2024 12:01:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	95TUYhry6R22ZNdbrt7ktasqRqP2EG69mmNh12OjVR8=; b=8cTmyw6+tRX/sJJC
	S1mUbCmn8/44Xw1kBz0ZjAyazUxFFtlm8/d107770OLw9sKNYJBsyrgWkHNow2Tn
	Nv18PIqhVR6zoU5THcZwZwWscbb75v+/70jw5iFcuTV5NTPdxxvI1DGBNt3o0vCQ
	30KngZPY3jxSxKBb0FhzE2R6eXIDjCS/CGfbgEGLhBWUAwXjaRn1JduNdwn52n3h
	l+WnJgZopoP8pir8djXJdzQq9/jlAD1fUIcgbAbJrKHpSBGZ+559AjjoBF9lieeS
	WiyL0pjz+STfUkgEGZkpQHWZ7am0R4msIF54fjHMJu75Gwg7jYVKNyKb2oQ5Ue1m
	kKoVGA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 425q9839mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 12:01:38 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id D904C40054;
	Fri, 11 Oct 2024 12:00:05 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 6566E268186;
	Fri, 11 Oct 2024 11:57:06 +0200 (CEST)
Received: from [10.252.28.117] (10.252.28.117) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Fri, 11 Oct
 2024 11:57:05 +0200
Message-ID: <9283caeb-1b84-43c2-a8a4-6b43a6962f34@foss.st.com>
Date: Fri, 11 Oct 2024 11:55:59 +0200
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
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <2fad1566-49f9-4586-b0d4-8a4a12f9e69e@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01



On 10/7/24 15:54, Marek Vasut wrote:
> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>> Implement the support for STM32MP25x platforms. On this platform, a
>> security clock is shared between some hardware blocks. For the RNG,
>> it is the RNG kernel clock. Therefore, the gate is no more shared
>> between the RNG bus and kernel clocks as on STM32MP1x platforms and
>> the bus clock has to be managed on its own.
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> A bit of a higher-level design question -- can you use 
> drivers/clk/clk-bulk.c clk_bulk_*() to handle all these disparate count 
> of clock easily ?

Hi, I'd like to make sure that we enable the core clock before the bus
clock so that the RNG hardware block can start its internal tests while
we ungate the bus clock. It's not a strong opinion but it feels better.

Cheers,
Gatien
