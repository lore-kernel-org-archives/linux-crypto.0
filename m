Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4849156F42
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717163431; cv=none; b=HKIYD8tpl6RjF4UiAbgSbbKP3yJx4GX1pxHr7wBPj910U/VJjeZ4fCaVEFi4pbhNFAA9BCpzNbkWN7KrzmcgOH8JPNR0da9wq4HyQV14AqvvjaQzSeYIOi0r3M8QyyQV6sCfKSoKoOC0FSFwmrApP/DIZs+HngDHHw1MPU71HFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717163431; c=relaxed/simple;
	bh=gyCd2JCrZSc2KqvwJg3jmiGsdp/xrKTUD5lWSZcbiiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F/Zvfm7/K5cOMXJsxhkp1DYQ2A1qaq2qhpRomevjakW2+AjmsR5rQrQDYcYf56Tw6R9kf0aT6UY3MH/gu/gMUmE3lap3KGfo11Ws15ui8xDcCJkMgVzx8+1hqMMdDuriPtfBANp1pZxlcKTE03HAgyud5AGTktPmIpAEYfedi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=A5+PpJ9t; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="A5+PpJ9t"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44VDnIO2015872;
	Fri, 31 May 2024 15:49:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	rNaZhZrMyXcFydlXNaczEwmwbt5T3dPMpJwK9++wRKk=; b=A5+PpJ9tKnNiPlJA
	tdGtz0mvABWtKgJaAlXH4TTwhcF6UY95h7PFCwwdh9/MSJ/oz78IyHIRE/a5zQAp
	Yiqsoy9zXAWqdV1RL0ZmEV3Vq3vQwSlUHn00BhbUV3LXwXfBAji+gir3Lvz3PTjs
	RA4NiuD16dj8kZciIKYHpEzdFk9yCQ/QfY2vn95Pu+Ar3aE+cRIcGoxw1QbvSH0w
	C5a/XMs+Ulddj2fc23fv/iqM84jY1cSUtnMriv075s7U9+UFzqTD/u1vzny7WCmK
	DuxVoHX5Mn3Suw7GqkRlkfuiO+EhwvI7QXv2f41oDl6JA8WIYKLoJOkV2eBj+XvE
	hZHtAg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3yba52c3us-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 15:49:25 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 0E19140047;
	Fri, 31 May 2024 15:48:52 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id A47F521BF55;
	Fri, 31 May 2024 15:47:37 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 31 May
 2024 15:47:36 +0200
Message-ID: <0ed57257-b1c5-42a0-b605-d1b924570677@foss.st.com>
Date: Fri, 31 May 2024 15:47:23 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: stm32 - use sizeof(*priv) instead of sizeof(struct
 stm32_rng_private)
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
References: <20240531085749.42863-1-marex@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <20240531085749.42863-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_10,2024-05-30_01,2024-05-17_01

Hi Marek,

On 5/31/24 10:57, Marek Vasut wrote:
> Use sizeof(*priv) instead of sizeof(struct stm32_rng_private), the
> former makes renaming of struct stm32_rng_private easier if necessary,
> as it removes one site where such rename has to happen. No functional
> change.
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
>   drivers/char/hw_random/stm32-rng.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index d08c870eb8d1f..9d041a67c295a 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -517,7 +517,7 @@ static int stm32_rng_probe(struct platform_device *ofdev)
>   	struct stm32_rng_private *priv;
>   	struct resource *res;
>   
> -	priv = devm_kzalloc(dev, sizeof(struct stm32_rng_private), GFP_KERNEL);
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>   	if (!priv)
>   		return -ENOMEM;
>   

Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>

Thanks,
Gatien
