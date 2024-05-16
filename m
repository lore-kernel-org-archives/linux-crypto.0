Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90002147C74;
	Thu, 16 May 2024 21:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715894663; cv=none; b=QlBAsUxHWVVq1T7xRlq6gLDljqN6B3e0HTEqBM7hZlic0b9JwYK4TSonN+cUVPTJ7jTfILB24jN+bhBv37/cY7ktnxh1ib3YWy5k9r+zgDGWyEcuSs4egcJpp7yaqEM3+1eohJi/89iFnmzj99ZCxoMwA3+wk6yfMsXlQ846+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715894663; c=relaxed/simple;
	bh=fhbU3an/e15PDwjFnQlpO/iVx9HuaXgCMdaYynBMhVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e+B4/J2pGlZqdUREPYJsEQYmU7aLs8XiwQxdZsXA4J0SSd+aH0oFs5rRvNEvrLj/V4Hhp9kq+og3rqFYID7H27ZJK0yUfJ7xhtJXra4GOQa1BbXltKFTQKA56bY8j1/y3sZQEi4HNwvY72JuPjIlbYq1DSXnyzcixF2LIhiyXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=h17qqsgo; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="h17qqsgo"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id BF38988410;
	Thu, 16 May 2024 23:24:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1715894659;
	bh=0io0g3AWBQsg1lVWjX0OfURgfAbrBcVZSYkBGvi99/E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h17qqsgof+PMaZHBzXY7LZAtE3I3o/cIG5/yp+yPp0HIrVmE5NxXmFKCI6dTMdSnt
	 IKOrAGM8TJQAcvpVpbOzZYqOGzeGZnqF5QGYwtjbUIyDBuJLStjxl/8BoRzhcvFpv2
	 NDQYZjWtgLpWpfFWPriTS1VffovMM5X8WZRNadeMQzLsSGcclxQgMDnglUt7Qdhsy3
	 5MLJunCFGwE5D35hlU5glrl5/WD2qxcjCStNOloAlVdAiWufeLcK19Ajl8FZTGO5V2
	 WDjwGm7gb0uwOgMNPWrXlPFajtqLNuQs7sUUwIZbTQjhtfReJBXcvwR8m1dfShTu7o
	 lopIPNzcDJ8ag==
Message-ID: <c28e39e3-64d8-4ed7-a2e5-48ee124ef8e3@denx.de>
Date: Thu, 16 May 2024 22:01:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] clk: stm32mp1: Keep RNG1 clock always running
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 linux-crypto@vger.kernel.org
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Michael Turquette <mturquette@baylibre.com>,
 Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
 Stephen Boyd <sboyd@kernel.org>, Yang Yingliang <yangyingliang@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com
References: <20240513220349.183568-1-marex@denx.de>
 <b2d0dfcb-37d6-4375-a4ad-ca96a5339840@foss.st.com>
 <cc6f98eb-f6b2-4a34-a8ed-c0f759fa4c79@denx.de>
 <51951dd4-8e8c-4e67-89f6-6a710022e34f@foss.st.com>
 <3257e8f8-5bb0-4c75-a3a3-e5685b65de2a@denx.de>
 <5b39b5b6-7008-4362-a578-3faab87cd23b@foss.st.com>
 <2eb2b80e-8650-46cf-9d8f-6dd6a884558a@denx.de>
 <eb3a2581-efc6-40c3-a7ea-551865017d40@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <eb3a2581-efc6-40c3-a7ea-551865017d40@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/16/24 4:35 PM, Gatien CHEVALLIER wrote:

Hi,

>>>>>>> What if you add a trace in a random generation function in random.c?
>>>>>>
>>>>>> Do you have a function name or line number for me ?
>>>>>
>>>>> I put a trace in _get_random_bytes() in drivers/char/random.c. I'm not
>>>>> 100% sure but this should be the entry point when getting a random 
>>>>> number.
>>>>
>>>> You're right, there is a read attempt right before the hang, and 
>>>> __clk_is_enabled() returns 0 in stm32_read_rng() . In fact, it is 
>>>> the pm_runtime_get_sync() which is returning -EACCES instead of 
>>>> zero, and this is currently not checked so the failure is not 
>>>> detected before register access takes place, to register file with 
>>>> clock disabled, which triggers a hard hang.
>>>>
>>>> I'll be sending a patch shortly, thanks for this hint !
>>>>
>>>
>>> Great news, indeed the return code isn't checked. Let's use
>>> pm_runtime_resume_and_get().
>>
>> Yes please.
>>
>> I will wonder why we get EACCES though, that basically means we are 
>> suspending already. Is it safe to return -errno from rng read function 
>> in that case ?
> 
> The framework expects a function that can return an error code so I
> don't see why not. Else the framework would have an issue.
> 
> I still haven't figured out what is happening.
> 
> Could it be that the kernel is getting entropy with hwrng_fillfn()
> like it does periodically to feed the entropy pool and it happens at the
> same time as your pm test sequence?

Possibly. I use script as init which contains basically #!/bin/sh , 
mount of a few filesystems like dev, proc, sys, and then the pm_test 
sequence to avoid wasting time booting full userspace.

> FYI, I have been running your script with (echo devices > 
> /sys/power/pm_test) for 5 hours now and haven't been able to reproduce 
> the issue.

Maybe the 'devices' test is not enough and the deeper pm_test states 
have some sort of impact ?

>>>>>>> After this, I'll try to reproduce the issue.
>>>>>>
>>>>>> If you have a minute to test it on some ST MP15 board, that would 
>>>>>> be real nice. Thanks !
>>>>>
>>>>> I tried to reproduce the issue you're facing on a STM32MP157C-DK2 no
>>>>> SCMI on the 6.9-rc7 kernel tag. I uses OP-TEE and TF-A in the 
>>>>> bootchain
>>>>> but this should not have an impact here.
>>>>>
>>>>> How did you manage to test using "echo core > /sys/power/pm_test"?
>>>>> In kernel/power/suspend.c, enter_state(). If the pm_test_level is 
>>>>> core,
>>>>> then an error is fired with the following trace:
>>>>> "Unsupported test mode for suspend to idle, please choose 
>>>>> none/freezer/devices/platform."
>>>>
>>>> Could this be firmware related ?
>>>>
>>>>> I've tried using "echo devices > /sys/power/pm_test" so that I can 
>>>>> at least test that the driver is put to sleep then wakes up. I do not
>>>>> reproduce your issue.
>>>>
>>>> Can you try 'processors' ?
>>>>
>>>
>>> Given this:
>>> #ifdef CONFIG_PM_DEBUG
>>>          if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
>>>              pr_warn("Unsupported test mode for suspend to idle
>>
>> You're supposed to be suspending to 'mem' , not 'idle' . Could that be 
>> it ?
> 
> Yes you're right, I've been missing that. I do not have "deep" available
> in /sys/power/mem_sleep... not upstreamed yet maybe... Have you coded a
> PSCI service for this in U-Boot?
> 
> I'm either missing something or I can't reproduce your setup.

The PSCI provider in U-Boot has been in place for years, there's no need 
to code anything, just compile it and that's all:

$ make stm32mp15_basic_defconfig && make -j`nproc`

This gets you u-boot-spl.stm32 and u-boot.itb as FSBL/SSBL .
