Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE41BC5C;
	Tue, 14 May 2024 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715674349; cv=none; b=HHpmGMyGcdVI0Xdv2ApsPPTYM/S4FxJNQJNbKUOd1YK4HlHgMZyaKrixBjZlIfXKsBGfp4DNZocR+10X9pL79B3BtvYMmukGtOzcew0apUzt8DPMu05iXrVxW94y1MSt88MTOZpbBuyufX63SQnEGwh/HWmNIeJeFMboRpqfHDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715674349; c=relaxed/simple;
	bh=4eu0K4O0pXHy1GVv+320fmDpTOfwDsSkO/XqXyUf8Pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MZDv9Y3xFa2NFsSQC3kZlP6NmtAhdpDlzriyrgGPxZRNJ2rvvdtHhq/kW0vuOylXxIGIhSCrrtak6OLaF0wlQ7qW50e44H/O2oOozqWWLPrbyH4qRgUqPCRxgPKhp9IoKdSuspZOj26aV3mxTZB9bj2V1NSgdkiRd9Epyonee6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=Flm7kXu1; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="Flm7kXu1"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44E86TOX006213;
	Tue, 14 May 2024 10:11:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=lThsbPGMcYjilyPz6OizppQDy6cRiA+jMAQjjoltJrU=; b=Fl
	m7kXu14EIS5QV8SYKupYVmoGvNh1cB1ld+zKPVmt5FzlcvYwOuaRCM6LrZjrm0LX
	W9H0Vu/8CoaIzlz29wB76g1hTsjHkJdfsCEFN/gVEttGy1su1uwUveXzljpVWICw
	RH3jiDX5kTCngHUnrpCPsbiJjqyhVXEcqPn5vTqDzOhHkq3l1JRHunwvvP9Q5oVX
	q4zMEDhUTPDoIvJuHiuD22Y+l9HxeAxT8p+SxQf5S3UnWPBBQazLT9qisy8oiw1Z
	DHe0qWq1gzrGEj48Uf9/ZeElTqmNf5sV9JM7HLjbVXeNXE2ijsqpOb1aDZR0a3fL
	qpXU672qnJ1jmV4Rmdtg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y1y8na1yu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 10:11:33 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id CB34440044;
	Tue, 14 May 2024 10:11:24 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 34B1D20DD7C;
	Tue, 14 May 2024 10:10:26 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 14 May
 2024 10:10:25 +0200
Message-ID: <b2d0dfcb-37d6-4375-a4ad-ca96a5339840@foss.st.com>
Date: Tue, 14 May 2024 10:10:16 +0200
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
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <20240513220349.183568-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_03,2024-05-10_02,2023-05-22_02

Hi Marek,

Strange indeed.
A potential reason that comes to my mind would be that something tries 
to get a random number after the driver suspended and fails to do so.
Else it might just be a bad clock balance.

Can you describe the software ecosystem that you're running please?
(SCMI/no SCMI)?

Do you have the 3 fixes of stm32_rng.c that you've sent recently in your
software when testing?

What if you add a trace in a random generation function in random.c?

After this, I'll try to reproduce the issue.

Thanks,
Gatien


On 5/14/24 00:02, Marek Vasut wrote:
> In case of STM32MP15xC/F SoC, in case the RNG1 is enabled in DT, the RNG1
> clock are managed by the driver. The RNG1 clock are toggled off on entry
> to suspend and back on on resume. For reason thus far unknown (could this
> be some chip issue?), when the system goes through repeated suspend/resume
> cycles, the system eventually hangs after a few such cycles.
> 
> This can be reproduced with CONFIG_PM_DEBUG 'pm_test' this way:
> "
> echo core > /sys/power/pm_test
> while true ; do
>      echo mem > /sys/power/state
>      sleep 2 ;
> done
> "
> The system locks up after about a minute and if WDT is active, resets.
> 
> If the RNG1 clock are kept enabled across suspend/resume, either using
> this change, or by keeping the clock enabled in RNG driver suspend/resume
> callbacks, the system does not lock up.
> 
> NOTE: This patch is a workaround. It would be good to know why does this
>        change make the hang go away, whether this is a chip issue or some
>        other problem ?
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
> Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Michael Turquette <mturquette@baylibre.com>
> Cc: Olivia Mackall <olivia@selenic.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-clk@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> ---
>   drivers/char/hw_random/stm32-rng.c | 2 ++
>   drivers/clk/stm32/clk-stm32mp1.c   | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index 7d0de8ab5e7f5..ec0314f05ff3e 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -403,6 +403,7 @@ static int __maybe_unused stm32_rng_suspend(struct device *dev)
>   
>   	writel_relaxed(priv->pm_conf.cr, priv->base + RNG_CR);
>   
> +	// Keeping the clock enabled across suspend/resume helps too
>   	clk_disable_unprepare(priv->clk);
>   
>   	return 0;
> @@ -434,6 +435,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
>   	int err;
>   	u32 reg;
>   
> +	// Keeping the clock enabled across suspend/resume helps too
>   	err = clk_prepare_enable(priv->clk);
>   	if (err)
>   		return err;
> diff --git a/drivers/clk/stm32/clk-stm32mp1.c b/drivers/clk/stm32/clk-stm32mp1.c
> index 7e2337297402a..1a6e853d935fa 100644
> --- a/drivers/clk/stm32/clk-stm32mp1.c
> +++ b/drivers/clk/stm32/clk-stm32mp1.c
> @@ -2000,7 +2000,7 @@ static const struct clock_config stm32mp1_clock_cfg[] = {
>   	KCLK(SDMMC3_K, "sdmmc3_k", sdmmc3_src, 0, G_SDMMC3, M_SDMMC3),
>   	KCLK(FMC_K, "fmc_k", fmc_src, 0, G_FMC, M_FMC),
>   	KCLK(QSPI_K, "qspi_k", qspi_src, 0, G_QSPI, M_QSPI),
> -	KCLK(RNG1_K, "rng1_k", rng_src, 0, G_RNG1, M_RNG1),
> +	KCLK(RNG1_K, "rng1_k", rng_src, CLK_IS_CRITICAL, G_RNG1, M_RNG1),
>   	KCLK(RNG2_K, "rng2_k", rng_src, 0, G_RNG2, M_RNG2),
>   	KCLK(USBPHY_K, "usbphy_k", usbphy_src, 0, G_USBPHY, M_USBPHY),
>   	KCLK(STGEN_K, "stgen_k", stgen_src, CLK_IS_CRITICAL, G_STGEN, M_STGEN),
