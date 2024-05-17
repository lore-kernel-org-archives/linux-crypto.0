Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFFF12F583;
	Fri, 17 May 2024 15:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715960480; cv=none; b=kdo2PsAq5wEbHXEtstWIFD6z1mrYbBVuR6Zsxnzo2ZbcLwwTP9rgWAcquvtSxrA/5FSSwdtcJ3ljrA0wgu0knxaWT34vcnXVGMlYlmYLZgyd79cAjflSVBJakjc+w8zMZJymWYQXdAVh4bq3J4XpLNLclY7SKRINmBBcxGO8L6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715960480; c=relaxed/simple;
	bh=6g3Rrn8XKJ7fM9Zn/omjUdviYnFG+BUlEwMQoIXWZmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LFhjf/jGVRqYX6SVq/H2kgeKUfBcCzQT8HagJHeWUN2WI9HxWDtxXgfuAATJT7bCQ/6I41/KbsA/4ZYfcwehtYhm6kqKQ3seernVUd8fV+29ZALX1CHb2LP33ATXfaN6fwCY6H9MB+fXa9dKiniogMuzdwzwQOIKL9QIpgm4rRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=W1mSMUnB; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="W1mSMUnB"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44HB5A16004163;
	Fri, 17 May 2024 17:40:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=7cu5ONgBosUZx3tFXDIOzdo1cZFIP5906buw+P5jD/o=; b=W1
	mSMUnB9oWw+I+RjaSYqn05GxSO8anep4e7F2g8unMZYQ+e1cG666B20akeC6zKS8
	OyVYB70eGbOMzp+XafU9DbUgpS2LaPvcn5bRZSTEXtElIl1v3egTwQxtFGUAWE9D
	34pT5SFXtunI2h3o5swDCZGfZJ3t0S5NPXAQWEA6yVzVIOIGIAG5qosg0/PR4QIZ
	AX7Iux3Wq8ay8+0s3Fv+Zd+QXfNi5xPhSUkOqqANGkZBlLdm8x0qp97M65dyfpQp
	6d0pNm2EJEvDbxc/p4w5Pm1NVU1kLITad+Npk0Iq9D5YhV0svXE82zMESVRmgxoW
	dBzVh/oSU1hq45JOsVHA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y6628h2nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 17:40:39 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 96E3D4002D;
	Fri, 17 May 2024 17:40:29 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 0A65A221970;
	Fri, 17 May 2024 17:39:33 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 17 May
 2024 17:39:32 +0200
Message-ID: <07d54026-5d2a-49a3-9211-bfc6e62afec3@foss.st.com>
Date: Fri, 17 May 2024 17:39:25 +0200
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
 <eb3a2581-efc6-40c3-a7ea-551865017d40@foss.st.com>
 <c28e39e3-64d8-4ed7-a2e5-48ee124ef8e3@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <c28e39e3-64d8-4ed7-a2e5-48ee124ef8e3@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-17_07,2024-05-17_03,2023-05-22_02



On 5/16/24 22:01, Marek Vasut wrote:
> On 5/16/24 4:35 PM, Gatien CHEVALLIER wrote:
> 
> Hi,
> 
>>>>>>>> What if you add a trace in a random generation function in 
>>>>>>>> random.c?
>>>>>>>
>>>>>>> Do you have a function name or line number for me ?
>>>>>>
>>>>>> I put a trace in _get_random_bytes() in drivers/char/random.c. I'm 
>>>>>> not
>>>>>> 100% sure but this should be the entry point when getting a random 
>>>>>> number.
>>>>>
>>>>> You're right, there is a read attempt right before the hang, and 
>>>>> __clk_is_enabled() returns 0 in stm32_read_rng() . In fact, it is 
>>>>> the pm_runtime_get_sync() which is returning -EACCES instead of 
>>>>> zero, and this is currently not checked so the failure is not 
>>>>> detected before register access takes place, to register file with 
>>>>> clock disabled, which triggers a hard hang.
>>>>>
>>>>> I'll be sending a patch shortly, thanks for this hint !
>>>>>
>>>>
>>>> Great news, indeed the return code isn't checked. Let's use
>>>> pm_runtime_resume_and_get().
>>>
>>> Yes please.
>>>
>>> I will wonder why we get EACCES though, that basically means we are 
>>> suspending already. Is it safe to return -errno from rng read 
>>> function in that case ?
>>
>> The framework expects a function that can return an error code so I
>> don't see why not. Else the framework would have an issue.
>>
>> I still haven't figured out what is happening.
>>
>> Could it be that the kernel is getting entropy with hwrng_fillfn()
>> like it does periodically to feed the entropy pool and it happens at the
>> same time as your pm test sequence?
> 
> Possibly. I use script as init which contains basically #!/bin/sh , 
> mount of a few filesystems like dev, proc, sys, and then the pm_test 
> sequence to avoid wasting time booting full userspace.
> 
Ok,

The strangest thing is not being to enable the clock, maybe there's
something on the clock driver side. Tracking clock enable/disable
may lead to something.

>> FYI, I have been running your script with (echo devices > 
>> /sys/power/pm_test) for 5 hours now and haven't been able to reproduce 
>> the issue.
> 
> Maybe the 'devices' test is not enough and the deeper pm_test states 
> have some sort of impact ?
>

Maybe, I don't have the knowledge to confirm or invalidate this.
Tasks should be frozen before drivers are put to sleep so my instinct
would say no but you can't take it for granted :)

>>>>>>>> After this, I'll try to reproduce the issue.
>>>>>>>
>>>>>>> If you have a minute to test it on some ST MP15 board, that would 
>>>>>>> be real nice. Thanks !
>>>>>>
>>>>>> I tried to reproduce the issue you're facing on a STM32MP157C-DK2 no
>>>>>> SCMI on the 6.9-rc7 kernel tag. I uses OP-TEE and TF-A in the 
>>>>>> bootchain
>>>>>> but this should not have an impact here.
>>>>>>
>>>>>> How did you manage to test using "echo core > /sys/power/pm_test"?
>>>>>> In kernel/power/suspend.c, enter_state(). If the pm_test_level is 
>>>>>> core,
>>>>>> then an error is fired with the following trace:
>>>>>> "Unsupported test mode for suspend to idle, please choose 
>>>>>> none/freezer/devices/platform."
>>>>>
>>>>> Could this be firmware related ?
>>>>>
>>>>>> I've tried using "echo devices > /sys/power/pm_test" so that I can 
>>>>>> at least test that the driver is put to sleep then wakes up. I do not
>>>>>> reproduce your issue.
>>>>>
>>>>> Can you try 'processors' ?
>>>>>
>>>>
>>>> Given this:
>>>> #ifdef CONFIG_PM_DEBUG
>>>>          if (pm_test_level != TEST_NONE && pm_test_level <= 
>>>> TEST_CPUS) {
>>>>              pr_warn("Unsupported test mode for suspend to idle
>>>
>>> You're supposed to be suspending to 'mem' , not 'idle' . Could that 
>>> be it ?
>>
>> Yes you're right, I've been missing that. I do not have "deep" available
>> in /sys/power/mem_sleep... not upstreamed yet maybe... Have you coded a
>> PSCI service for this in U-Boot?
>>
>> I'm either missing something or I can't reproduce your setup.
> 
> The PSCI provider in U-Boot has been in place for years, there's no need 
> to code anything, just compile it and that's all:
> 
> $ make stm32mp15_basic_defconfig && make -j`nproc`
> 
> This gets you u-boot-spl.stm32 and u-boot.itb as FSBL/SSBL .

Ok thanks.

Best regards,
Gatien
