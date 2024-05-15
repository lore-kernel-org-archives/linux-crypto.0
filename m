Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47FF56458;
	Wed, 15 May 2024 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715764732; cv=none; b=SazW6IgepcpSe7GmJbf9fuoRJWm6Mn/AjF8WBD9ErMT+vYA/cNKKuG9PnwepAxp/ieSBkQlLsvxR0sBbIBHUHrZTtjfozFNf01PUNVpieLfamE3Zk/oCU4jyi0ouWKHr81f17H64UXBGih88dc8n+7GrK/Pb3igj/GZUCsbPKOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715764732; c=relaxed/simple;
	bh=3kpZN3+gpG+3pWQ9Ub6m1a/EpCdt/xYM2Cy8NlRGPDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=o+aT290zvrV1KH1nnboOD+kfPTeUdTY+qWZ60Hpb2cV6TRFcqXkcgZjstBingts1nqjivzxo2R5xUCTF4e8u8h7V+L7wQaFiPRHWtJNFxAV/j1jNzBtFb5kaQj0LMjYvIthFgmf+UxsIYYLFdvloR1+7xlpmnwz5LxQCY8huBo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=bCaJ0EHa; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="bCaJ0EHa"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44F8vps7015034;
	Wed, 15 May 2024 11:17:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=P9HRaZf/HRKRXBcbWf8Sn90169F5hwUmhun9zIpDsWM=; b=bC
	aJ0EHaE+ojA0V//atzBk13ngDco8uuvmuN+y9BFUod9zjThwH1UaqjldeeiA+cii
	1lfbdDm4DMvb8qY03rJiohJtiJIK8Xu0u+J7b4YlADMfrrOnrCbaT2PLuE7vEjZQ
	nazJ8mlv9O5uORtlqV+wgcdgKTIHyIM3Atsy0NLT7CbWbqTTd4naVhGaKansTTML
	7sAwpQVMdyPbtafbLTG9J8fCMkyHa5za/o09TgFx4ml8w33YhBIqya9s0WkQ4byy
	QsxZ2jwmRr/PxLChuDZ60cq9t932VQ3SaHGkRYf2JpgUbicCWCWpca1U5dM56Uyo
	m9m6eAGXIuvwMlTbgeaA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y4sxv0420-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 11:17:58 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 421864002D;
	Wed, 15 May 2024 11:17:48 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 1B8DB214D3B;
	Wed, 15 May 2024 11:16:52 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 15 May
 2024 11:16:51 +0200
Message-ID: <51951dd4-8e8c-4e67-89f6-6a710022e34f@foss.st.com>
Date: Wed, 15 May 2024 11:16:45 +0200
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
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <cc6f98eb-f6b2-4a34-a8ed-c0f759fa4c79@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_04,2024-05-14_01,2023-05-22_02

Hi Marek,

On 5/14/24 16:37, Marek Vasut wrote:
> On 5/14/24 10:10 AM, Gatien CHEVALLIER wrote:
>> Hi Marek,
> 
> Hi,
> 
>> Strange indeed.
> 
> Yes.
> 
>> A potential reason that comes to my mind would be that something tries 
>> to get a random number after the driver suspended and fails to do so.
> 
> Possibly.
> 
>> Else it might just be a bad clock balance.
> 
> I don't think so, this would be reported by the kernel and it would show 
> up in /sys/kernel/debug/clk/clk_summary as incrementing use count. It 
> would also not happen in a non-deterministic manner like this happens 
> here, the hang doesn't always happen after well defined suspend/resume 
> cycle count.
> 
>> Can you describe the software ecosystem that you're running please?
>> (SCMI/no SCMI)?
> 
> STM32MP157C DHCOM PDK2 with mainline U-Boot 2024.07-rc2 , no SCMI.
> 
>> Do you have the 3 fixes of stm32_rng.c that you've sent recently in your
>> software when testing?
> 
> Yes, but this happens even without them.
> 
>> What if you add a trace in a random generation function in random.c?
> 
> Do you have a function name or line number for me ?

I put a trace in _get_random_bytes() in drivers/char/random.c. I'm not
100% sure but this should be the entry point when getting a random number.

> 
>> After this, I'll try to reproduce the issue.
> 
> If you have a minute to test it on some ST MP15 board, that would be 
> real nice. Thanks !

I tried to reproduce the issue you're facing on a STM32MP157C-DK2 no
SCMI on the 6.9-rc7 kernel tag. I uses OP-TEE and TF-A in the bootchain
but this should not have an impact here.

How did you manage to test using "echo core > /sys/power/pm_test"?
In kernel/power/suspend.c, enter_state(). If the pm_test_level is core,
then an error is fired with the following trace:
"Unsupported test mode for suspend to idle, please choose 
none/freezer/devices/platform."

I've tried using "echo devices > /sys/power/pm_test" so that I can at 
least test that the driver is put to sleep then wakes up. I do not
reproduce your issue.

[  169.026421] Filesystems sync: 0.013 seconds
[  169.031087] Freezing user space processes
[  169.036562] Freezing user space processes completed (elapsed 0.002 
seconds)
[  169.042238] OOM killer disabled.
[  169.045383] Freezing remaining freezable tasks
[  169.051408] Freezing remaining freezable tasks completed (elapsed 
0.001 seconds)
[  169.238226] dwc2 49000000.usb-otg: suspending usb gadget 
configfs-gadget.g1
[  169.270236] In stm32_rng_suspend
[  169.275501] PM: suspend debug: Waiting for 5 second(s).
[  174.283418] In stm32_rng_resume
[  174.284291] stm32-dwmac 5800a000.ethernet end0: configuring for 
phy/rgmii-id link mode
[  174.337714] dwmac4: Master AXI performs any burst length
[  174.341699] stm32-dwmac 5800a000.ethernet end0: No Safety Features 
support found
[  174.349138] stm32-dwmac 5800a000.ethernet end0: IEEE 1588-2008 
Advanced Timestamp supported
[  174.363442] dwc2 49000000.usb-otg: resuming usb gadget configfs-gadget.g1
[  174.667669] onboard-usb-hub 2-1: reset high-speed USB device number 2 
using ehci-platform
[  174.989075] OOM killer enabled.
[  174.990848] Restarting tasks ... done.
[  175.003976] random: crng reseeded on system resumption
[  175.009464] PM: suspend exit
[  175.011473] random: ASKING FOR 96 BYTES
[  175.011468] random: ASKING FOR 96 BYTES
[  175.015747] random: ASKING FOR 16 BYTES
[  175.044933] random: ASKING FOR 96 BYTES
[  175.059399] random: ASKING FOR 96 BYTES
[  175.070925] random: ASKING FOR 16 BYTES
[  175.079285] random: ASKING FOR 96 BYTES
[  175.082113] random: ASKING FOR 16 BYTES
[  175.096759] random: ASKING FOR 16 BYTES
[  175.098674] random: ASKING FOR 96 BYTES
[  175.295584] random: ASKING FOR 16 BYTES
[  175.302357] random: ASKING FOR 96 BYTES
[  175.311525] random: ASKING FOR 16 BYTES
[  175.312989] random: ASKING FOR 16 BYTES


Can you give it another shot with the trace so that we can ensure that
no random is asked after the driver is suspended in your case please?

Thanks,
Gatien



