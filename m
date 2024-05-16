Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67FD282EF
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 08:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715847271; cv=none; b=oVe7mQ6TCLkRAevfdtPXG4SvNZM0xlUxijCRkwVMl/4EkzP0fe6bJkS7eAMmo5Efm30psPSffXMYmEotSZC6ZoM+bV7ELtNZ+zHo/gWwB4GQSzM6dCK8b150EayjbxNmJMLkQ5S2WADB5+PZdB996Vl4RyBHqH7UDieHJlfHidU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715847271; c=relaxed/simple;
	bh=GJYIoxXtm1FJsRPU9W4XdmUkrmPA7ZDe6MUe5OHlrR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SP5AHkPPqeURuuhvxU66rra0S9RdjZOwH0jjCinanNJCS58n2n3Oy39WM8HA6SF4G4XGjzhyx8d6LfxmZZuk4y+r/Fo0AZP47IQfqdWe9C2XhOO9waGBT9YaypqkwIojrcUwbRA2istV5LFamsbtbV8kzNVgNwQDannS3Gjd7m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ZvFoatxb; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ZvFoatxb"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44G7mxDh002240;
	Thu, 16 May 2024 10:13:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=zsebgqL7ME1csjyfoz1MEw6bVhUR+QtHfWqn47Yy6Es=; b=Zv
	Foatxbf8NVvCbuOSQfGXHE1SkqeW9cluSq3uZxNTrpQU/9cAAxkiz0etBZzNTJdt
	ZB5RzL5nUDpIoelVVCx6DwBGMaO2HiWPcHbclL/niBQzTAKnDBXQj5mnrAbYaocX
	Q+1aUeL0npOqrQTYpNL70K/TI9VA7j+7kUxmnyMVgukUPr2tnU2jb/6kkoPO1dEB
	8T06x96m8xaluiS0oN6NU0kQYw93FS24DuerDIPrAPh6KEEfitSYpLtGW2iMwcuT
	LWHn2/2mGU6yAC8huIJvlr6gTSTKNiLk9kgVY8EbG2Wky03Lc1pKAsz+cHmyXqmO
	8XLdqVjDHkicnZSub0/w==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y4sxvmacv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 10:13:49 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id C96DE4002D;
	Thu, 16 May 2024 10:13:43 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id F1C53210582;
	Thu, 16 May 2024 10:12:56 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 16 May
 2024 10:12:56 +0200
Message-ID: <e4650db9-569f-417d-b559-bf6854c6e32a@foss.st.com>
Date: Thu, 16 May 2024 10:12:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] hwrng: stm32 - use pm_runtime_resume_and_get()
To: Marek Vasut <marex@denx.de>, <linux-crypto@vger.kernel.org>
CC: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
        Yang
 Yingliang <yangyingliang@huawei.com>,
        <kernel@dh-electronics.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
References: <20240516012210.128307-1-marex@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <20240516012210.128307-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_03,2024-05-15_01,2023-05-22_02

On 5/16/24 03:20, Marek Vasut wrote:
> include/linux/pm_runtime.h pm_runtime_get_sync() description suggests to
> ... consider using pm_runtime_resume_and_get() instead of it, especially
> if its return value is checked by the caller, as this is likely to result
> in cleaner code.
> 
> This is indeed better, switch to pm_runtime_resume_and_get() which
> correctly suspends the device again in case of failure. Also add error
> checking into the RNG driver in case pm_runtime_resume_and_get() does
> fail, which is currently not done, and it does detect sporadic -EACCES
> error return after resume, which would otherwise lead to a hang due to
> register access on un-resumed hardware. Now the read simply errors out
> and the system does not hang.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Olivia Mackall <olivia@selenic.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: kernel@dh-electronics.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> ---
>   drivers/char/hw_random/stm32-rng.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index 0e903d6e22e30..6dec4adc49853 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -187,7 +187,9 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   	int retval = 0, err = 0;
>   	u32 sr;
>   
> -	pm_runtime_get_sync((struct device *) priv->rng.priv);
> +	retval = pm_runtime_resume_and_get((struct device *)priv->rng.priv);
> +	if (retval)
> +		return retval;
>   
>   	if (readl_relaxed(priv->base + RNG_SR) & RNG_SR_SEIS)
>   		stm32_rng_conceal_seed_error(rng);

Hi Marek,

I'll check in other stm32 drivers as well.

Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>

Thanks,
Gatien
