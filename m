Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85825143866;
	Thu, 16 May 2024 10:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715856928; cv=none; b=OHU6/yfJocXWg+83oHewrwhz26q8ieQojJHuL06oqEi/FF3qkrtvIwEh4JOY69uTNPhSuklem/KUv6mYpq9VdlTWiolkEFyLR2CJXCPCdyCWAMhXSw7/M6kDJ9G0s16Z2zK6HR5ZKkKxW47uP6ssEhRhqwV7oRCZgtPQVfWPfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715856928; c=relaxed/simple;
	bh=JB2NL1M7O1RecxQD/u46GgqoKdAGIcDBhLLcytjCGwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GF1NOuWGRrmutsLSWx6wqu9mBFFT5PqD/65WaTceQk6Zf11keeIHqhV9hwgVym06n5uJzwFWmvjAYNmJgjyf3KnAnEQ7om0jLULg17387baUYqOBd1Mxlj3ohlEAIDNESFRObYRGgW6Ei70PsrDbDyJRDCdrsoXOQ9fCFS+HqiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=dhGZfzCL; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="dhGZfzCL"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 62348882A2;
	Thu, 16 May 2024 12:55:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1715856924;
	bh=5GO3dsCEhV/yq/JtclRgIUNkt8t13jadvqCsqEkQTgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dhGZfzCLZhH3cWcNek5v0vG0MzZ3LLEDx4qKsUGBl++JYd79Czp1VdlloPXMKdaI+
	 1YfiLBkfnd/BHPuMWJKN3u+OLKZVXgRZHcX/m1zngwRrkUBheRmenOj9AmmEx9bhLa
	 7upWN/JH5VaBjw/XXckY5ZA7vXbcm1JUOXYU3cqJupPxeTVZPaO8E+id46ys28+Ssu
	 F69W3W0IUyl3f6Or1JtzcY7Z5KaEUfEsXw1K1MTo9FR0qgKw3ve7RpYkP4G4tdH5L3
	 Jt3ffRYYUE8EOingMMQ/QsRqIYn3VN865JjeLRRAXPDLdaXrZ3kJ+PgmHeNJ5aVAZl
	 nmtlZQjd+SwmQ==
Message-ID: <2eb2b80e-8650-46cf-9d8f-6dd6a884558a@denx.de>
Date: Thu, 16 May 2024 12:43:30 +0200
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
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <5b39b5b6-7008-4362-a578-3faab87cd23b@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/16/24 9:42 AM, Gatien CHEVALLIER wrote:

Hi,

>>>>> What if you add a trace in a random generation function in random.c?
>>>>
>>>> Do you have a function name or line number for me ?
>>>
>>> I put a trace in _get_random_bytes() in drivers/char/random.c. I'm not
>>> 100% sure but this should be the entry point when getting a random 
>>> number.
>>
>> You're right, there is a read attempt right before the hang, and 
>> __clk_is_enabled() returns 0 in stm32_read_rng() . In fact, it is the 
>> pm_runtime_get_sync() which is returning -EACCES instead of zero, and 
>> this is currently not checked so the failure is not detected before 
>> register access takes place, to register file with clock disabled, 
>> which triggers a hard hang.
>>
>> I'll be sending a patch shortly, thanks for this hint !
>>
> 
> Great news, indeed the return code isn't checked. Let's use
> pm_runtime_resume_and_get().

Yes please.

I will wonder why we get EACCES though, that basically means we are 
suspending already. Is it safe to return -errno from rng read function 
in that case ?

>>>>> After this, I'll try to reproduce the issue.
>>>>
>>>> If you have a minute to test it on some ST MP15 board, that would be 
>>>> real nice. Thanks !
>>>
>>> I tried to reproduce the issue you're facing on a STM32MP157C-DK2 no
>>> SCMI on the 6.9-rc7 kernel tag. I uses OP-TEE and TF-A in the bootchain
>>> but this should not have an impact here.
>>>
>>> How did you manage to test using "echo core > /sys/power/pm_test"?
>>> In kernel/power/suspend.c, enter_state(). If the pm_test_level is core,
>>> then an error is fired with the following trace:
>>> "Unsupported test mode for suspend to idle, please choose 
>>> none/freezer/devices/platform."
>>
>> Could this be firmware related ?
>>
>>> I've tried using "echo devices > /sys/power/pm_test" so that I can at 
>>> least test that the driver is put to sleep then wakes up. I do not
>>> reproduce your issue.
>>
>> Can you try 'processors' ?
>>
> 
> Given this:
> #ifdef CONFIG_PM_DEBUG
>          if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
>              pr_warn("Unsupported test mode for suspend to idle

You're supposed to be suspending to 'mem' , not 'idle' . Could that be it ?
