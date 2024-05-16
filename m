Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61882031D;
	Thu, 16 May 2024 07:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845508; cv=none; b=E0cXU0q5Z9F7q8zAWHCt90dM9A1d+roKZ1cXFkPD3utXNm5ceyqhW/rFZBXJR/oEPlEhBqbU6f1N29VmX5x4hbT5v0HLlOMJmcWR0M6Oe1FO7mu/nW+roc28vScZEq5OKDAsNEPOma5oeCcQVbpTjVL7pE7f0r4sc4cOCYeM9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845508; c=relaxed/simple;
	bh=qfYpAbbXpjEyYh4WRvM9+5NG8w1h1rMukIJoCgIKlMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hLTKOt6ZExE8adkTxucWg+Xm91PAAODtfLyKu94M/AGupSsduphWnzgoSncIARMwmG4AioliUaEyAYr6wUaBIxf4lHUtxA2LoNTuumzqIxZ0W3AySulv0QF2WVKtOTTd6fFkt0+Jj8HQujoVUHwPIgVt2dd9oiiElw228wiojCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=oYqfZv8r; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="oYqfZv8r"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44FLuDT2005399;
	Thu, 16 May 2024 09:43:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=fGbR8sYV9QIn7SFPWuDEizW7wFbyJ157IMhZGWfECk8=; b=oY
	qfZv8rDdRNbMc7CuGM5totYTdN9MafA0OvTOD5Bg8sANV7hrr5gE+FzkxDU36Waj
	GZgSqPWrLU9QEO0tgCZh9XoJSVUXHGvM4veRgE+AphbOHcaWPUr46euV2l67MbY3
	79iR7SfUEbRcjoNwffonPiTxIhlRchgK3KbHRHkINnZeOcIYYKRAVfbZR0BSBZ7H
	OC7hJx5YYF/kslkbMKZfXNw8OSEFmLEg4mlJzvOX/1hq4zjC8LdgMs6ClFejYjMd
	mqX3Uxp6rN62bL09ZKrBStE0nXilBa5dETimsczq3HDcs2fuJuk6ugVHm07GaVhO
	PiS051HwTsAgndN36Wkg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y4symc615-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 09:43:59 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 494D140046;
	Thu, 16 May 2024 09:43:51 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 1F791211958;
	Thu, 16 May 2024 09:42:57 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 16 May
 2024 09:42:55 +0200
Message-ID: <5b39b5b6-7008-4362-a578-3faab87cd23b@foss.st.com>
Date: Thu, 16 May 2024 09:42:51 +0200
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
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <3257e8f8-5bb0-4c75-a3a3-e5685b65de2a@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_03,2024-05-15_01,2023-05-22_02

Hi Marek

On 5/16/24 03:06, Marek Vasut wrote:
> On 5/15/24 11:16 AM, Gatien CHEVALLIER wrote:
> 
> Hi,
> 
>>>> What if you add a trace in a random generation function in random.c?
>>>
>>> Do you have a function name or line number for me ?
>>
>> I put a trace in _get_random_bytes() in drivers/char/random.c. I'm not
>> 100% sure but this should be the entry point when getting a random 
>> number.
> 
> You're right, there is a read attempt right before the hang, and 
> __clk_is_enabled() returns 0 in stm32_read_rng() . In fact, it is the 
> pm_runtime_get_sync() which is returning -EACCES instead of zero, and 
> this is currently not checked so the failure is not detected before 
> register access takes place, to register file with clock disabled, which 
> triggers a hard hang.
> 
> I'll be sending a patch shortly, thanks for this hint !
> 

Great news, indeed the return code isn't checked. Let's use
pm_runtime_resume_and_get().

>>>> After this, I'll try to reproduce the issue.
>>>
>>> If you have a minute to test it on some ST MP15 board, that would be 
>>> real nice. Thanks !
>>
>> I tried to reproduce the issue you're facing on a STM32MP157C-DK2 no
>> SCMI on the 6.9-rc7 kernel tag. I uses OP-TEE and TF-A in the bootchain
>> but this should not have an impact here.
>>
>> How did you manage to test using "echo core > /sys/power/pm_test"?
>> In kernel/power/suspend.c, enter_state(). If the pm_test_level is core,
>> then an error is fired with the following trace:
>> "Unsupported test mode for suspend to idle, please choose 
>> none/freezer/devices/platform."
> 
> Could this be firmware related ?
> 
>> I've tried using "echo devices > /sys/power/pm_test" so that I can at 
>> least test that the driver is put to sleep then wakes up. I do not
>> reproduce your issue.
> 
> Can you try 'processors' ?
> 

Given this:
#ifdef CONFIG_PM_DEBUG
		if (pm_test_level != TEST_NONE && pm_test_level <= TEST_CPUS) {
			pr_warn("Unsupported test mode for suspend to idle, please choose 
none/freezer/devices/platform.\n");
			return -EAGAIN;
		}
#endif

and this

static const char * const pm_tests[__TEST_AFTER_LAST] = {
	[TEST_NONE] = "none",
	[TEST_CORE] = "core",
	[TEST_CPUS] = "processors",
	[TEST_PLATFORM] = "platform",
	[TEST_DEVICES] = "devices",
	[TEST_FREEZER] = "freezer",
};

I'm getting the error as well.

> I did also notice it sometimes takes much longer than a minute to hang, 
> but eventually it does hang. Maybe let it cycle for an hour or a few ?
> 

I'll let it loop for some time then for device pm state.

> [...]
> 

Thanks for investigating this.

Cheers,
Gatien
