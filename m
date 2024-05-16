Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D1B1DFEF;
	Thu, 16 May 2024 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715870246; cv=none; b=cgGQfaYJtaTTgUgIbQh3reb1SkfuscaPie3bdfuf6LPEPGJMC/YYM3bYWmlFp4vFevdY5/4x3dua0TGFNHgb4jynBWnjA5jMqFSXIM6Z+L6AbHA8zfUHheii9H5XEDpJRcBM8+qVxGARmjxxui5TTaha2HclGXMoxdbe2wttpHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715870246; c=relaxed/simple;
	bh=o1gMEjFi/WHr2qKAmFjmxfC7395/RL7/fXI1xGCNG40=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=APd87ve+uvWbeqOyXxrdtmc7wjjh5EXnNk2vH7rfRqhO/41ZDT9hMoG4xPqGZ1I6rX26pg7sMWrG4/mexsAQmKeOQh8Vm1nP/aEaRvNhgD56Ccziy5zJ7Y4gMP73DV6/0yZCpw/Hsrw91nvtK7NI16J4O7LXBcbrL1c8f6ZynvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=TMtep9Ft; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="TMtep9Ft"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44GDhYKP005402;
	Thu, 16 May 2024 16:36:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=3ZOCADbz3OwcSrpGlTG7JoHBwcrSFGYRtD/O02Jz6P8=; b=TM
	tep9Ft/091Dsf51h3LVxZejBEVKw8E43mdTVikDAwUvcwfA3C869shJ+MPBV36gh
	bi+N2PWjTaJkMfPfCX3MiKzDca+F8z8/AzKXgf2SmB602osq3OL59phinPzZZcBb
	tNV7LcgAHv8OZS1xV121KFrxr+ArV5nf6DHBK3J1sOn0bVU+kBaU/+8Bgq79gcLo
	ESnJnh1l37xWfKU00ErNSC1+Ih8J+GhuFaZGX10U2DWI1stwjyNnViYsXv8XdsQI
	u3cEBtCaxAkFA7czVIiPoPRMNXolYIuEF7ugpAjpp/tqZWNffHAk3zKE61kR1jZm
	lVMAavVlaMBbbwDfFhLg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y4symdu0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 16:36:34 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 8DC5940044;
	Thu, 16 May 2024 16:36:26 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 894BD220B76;
	Thu, 16 May 2024 16:35:29 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 16 May
 2024 16:35:28 +0200
Message-ID: <eb3a2581-efc6-40c3-a7ea-551865017d40@foss.st.com>
Date: Thu, 16 May 2024 16:35:28 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] clk: stm32mp1: Keep RNG1 clock always running
To: Marek Vasut <marex@denx.de>, <linux-crypto@vger.kernel.org>
CC: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Gabriel Fernandez
	<gabriel.fernandez@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Turquette
	<mturquette@baylibre.com>,
        Olivia Mackall <olivia@selenic.com>, Rob Herring
	<robh@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Yang Yingliang
	<yangyingliang@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
References: <20240513220349.183568-1-marex@denx.de>
 <b2d0dfcb-37d6-4375-a4ad-ca96a5339840@foss.st.com>
 <cc6f98eb-f6b2-4a34-a8ed-c0f759fa4c79@denx.de>
 <51951dd4-8e8c-4e67-89f6-6a710022e34f@foss.st.com>
 <3257e8f8-5bb0-4c75-a3a3-e5685b65de2a@denx.de>
 <5b39b5b6-7008-4362-a578-3faab87cd23b@foss.st.com>
 <2eb2b80e-8650-46cf-9d8f-6dd6a884558a@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <2eb2b80e-8650-46cf-9d8f-6dd6a884558a@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02



On 5/16/24 12:43, Marek Vasut wrote:
> On 5/16/24 9:42 AM, Gatien CHEVALLIER wrote:
> 
> Hi,
> 
>>>>>> What if you add a trace in a random generation function in random.c?
>>>>>
>>>>> Do you have a function name or line number for me ?
>>>>
>>>> I put a trace in _get_random_bytes() in drivers/char/random.c. I'm not
>>>> 100% sure but this should be the entry point when getting a random 
>>>> number.
>>>
>>> You're right, there is a read attempt right before the hang, and 
>>> __clk_is_enabled() returns 0 in stm32_read_rng() . In fact, it is the 
>>> pm_runtime_get_sync() which is returning -EACCES instead of zero, and 
>>> this is currently not checked so the failure is not detected before 
>>> register access takes place, to register file with clock disabled, 
>>> which triggers a hard hang.
>>>
>>> I'll be sending a patch shortly, thanks for this hint !
>>>
>>
>> Great news, indeed the return code isn't checked. Let's use
>> pm_runtime_resume_and_get().
> 
> Yes please.
> 
> I will wonder why we get EACCES though, that basically means we are 
> suspending already. Is it safe to return -errno from rng read function 
> in that case ?

The framework expects a function that can return an error code so I
don't see why not. Else the framework would have an issue.

I still haven't figured out what is happening.

Could it be that the kernel is getting entropy with hwrng_fillfn()
like it does periodically to feed the entropy pool and it happens at the
same time as your pm test sequence?

FYI, I have been running your script with (echo devices > 
/sys/power/pm_test) for 5 hours now and haven't been able to reproduce 
the issue.

> 
>>>>>> After this, I'll try to reproduce the issue.
>>>>>
>>>>> If you have a minute to test it on some ST MP15 board, that would 
>>>>> be real nice. Thanks !
>>>>
>>>> I tried to reproduce the issue you're facing on a STM32MP157C-DK2 no
>>>> SCMI on the 6.9-rc7 kernel tag. I uses OP-TEE and TF-A in the bootchain
>>>> but this should not have an impact here.
>>>>
>>>> How did you manage to test using "echo core > /sys/power/pm_test"?
>>>> In kernel/power/suspend.c, enter_state(). If the pm_test_level is core,
>>>> then an error is fired with the following trace:
>>>> "Unsupported test mode for suspend to idle, please choose 
>>>> none/freezer/devices/platform."
>>>
>>> Could this be firmware related ?
>>>
>>>> I've tried using "echo devices > /sys/power/pm_test" so that I can 
>>>> at least test that the driver is put to sleep then wakes up. I do not
>>>> reproduce your issue.
>>>
>>> Can you try 'processors' ?
>>>
>>
>> Given this:
>> #ifdef CONFIG_PM_DEBUG
>>          if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
>>              pr_warn("Unsupported test mode for suspend to idle
> 
> You're supposed to be suspending to 'mem' , not 'idle' . Could that be it ?

Yes you're right, I've been missing that. I do not have "deep" available
in /sys/power/mem_sleep... not upstreamed yet maybe... Have you coded a
PSCI service for this in U-Boot?

I'm either missing something or I can't reproduce your setup.

Thanks,
Gatien

