Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869951459E2
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 11:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715860131; cv=none; b=uKJHQl/vQSDvJuh0YQ9UbFqYPfTjuzcd2RRuM9ILj+kFWJG1mCmqhIkI3HMhZOcKE/SrGckuOaqkDKShoIwpg+8kOuog4CIZKvKWeEIiKoospFcLRgyhcc3svfMWNRQzdeVuZaFQRN7824hiSVs5dGg9EgW/kD865pQYv4BDXCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715860131; c=relaxed/simple;
	bh=w2O7BmCT8tbRCqTEeX1EUl+Wlb/ivOo9ljHrj0hMsM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MPh4JfJLtFKZHFkQGnoliKjZ8+r2RxvBImN4lHcP8afC4F5VarueSODjJdk2cQhX53507OYTXLMSIrPEP5cHfTwuk7mtwqlIWRerMFhM2yp04kdsTQ8cRm/ozv5I9VPOC6sMchTC0OPL4ZHYwSoQR5h4y5LD2QxBostP9kLnmOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=swyyqX7O; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="swyyqX7O"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44G75xZv015041;
	Thu, 16 May 2024 13:48:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=FyX+6EeX2zYSgDjp5p8BhJzA6/x8bIKgkLN30SXYigU=; b=sw
	yyqX7OpzrgCwcEqYkUTPKAjdJuxzbZPKbyE/oSVpph7W+q+0MkUL7kp3Y4iXOMQ3
	ztZOX1efIXcDNYfD97e7KrJLT0rYXt976vy4NfE++5iyjg96+IufoX36K5akdCnp
	z2EGTfWBr5RLGLb/Wgicz7q+qfxUaE4iED5byimWT1Kevv5+BcgfwOoLNpVJUYCI
	x2X6mTdsYmgdC/IdS0hD5h+HTQ+HJBCUkPRmzMnrnjVcTUAIc3DceUD/dxG1FZSV
	eP9Cwcakx53NrZcWOuaRVX9X1o0/G/x5b6HDZbSL0AGjoQliCSKoHR+ZUxvOVtqd
	BzMsMl+dvvNGiecIWvOw==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y4sxv5ehv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 13:48:08 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 033AC4002D;
	Thu, 16 May 2024 13:48:01 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E7E8F218604;
	Thu, 16 May 2024 13:47:14 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 16 May
 2024 13:47:14 +0200
Message-ID: <8ec4286e-3477-4fcd-8176-5c3a6606f0a1@foss.st.com>
Date: Thu, 16 May 2024 13:47:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] hwrng: stm32 - cache device pointer in struct
 stm32_rng_private
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
 <20240516012210.128307-2-marex@denx.de>
 <1e2da893-efff-4f7c-9842-a9484e4c2230@foss.st.com>
 <404122b2-75fe-4da6-8167-fb98eba7f941@denx.de>
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <404122b2-75fe-4da6-8167-fb98eba7f941@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_05,2024-05-15_01,2023-05-22_02



On 5/16/24 12:52, Marek Vasut wrote:
> On 5/16/24 11:37 AM, Gatien CHEVALLIER wrote:
> 
> Hi,
> 
>>> diff --git a/drivers/char/hw_random/stm32-rng.c 
>>> b/drivers/char/hw_random/stm32-rng.c
>>> index 6dec4adc49853..00012e6e4ccc8 100644
>>> --- a/drivers/char/hw_random/stm32-rng.c
>>> +++ b/drivers/char/hw_random/stm32-rng.c
>>> @@ -70,6 +70,7 @@ struct stm32_rng_config {
>>>   struct stm32_rng_private {
>>>       struct hwrng rng;
>>> +    struct device *dev;
>>>       void __iomem *base;
>>>       struct clk *clk;
>>>       struct reset_control *rst;
>>> @@ -99,7 +100,7 @@ struct stm32_rng_private {
>>>    */
>>>   static int stm32_rng_conceal_seed_error_cond_reset(struct 
>>> stm32_rng_private *priv)
>>>   {
>>> -    struct device *dev = (struct device *)priv->rng.priv;
>>> +    struct device *dev = priv->dev;
>>>       u32 sr = readl_relaxed(priv->base + RNG_SR);
>>>       u32 cr = readl_relaxed(priv->base + RNG_CR);
>>>       int err;
>>> @@ -171,7 +172,7 @@ static int stm32_rng_conceal_seed_error(struct 
>>> hwrng *rng)
>>>   {
>>>       struct stm32_rng_private *priv = container_of(rng, struct 
>>> stm32_rng_private, rng);
>>> -    dev_dbg((struct device *)priv->rng.priv, "Concealing seed 
>>> error\n");
>>> +    dev_dbg(priv->dev, "Concealing seed error\n");
>>>       if (priv->data->has_cond_reset)
>>>           return stm32_rng_conceal_seed_error_cond_reset(priv);
>>> @@ -187,7 +188,7 @@ static int stm32_rng_read(struct hwrng *rng, void 
>>> *data, size_t max, bool wait)
>>>       int retval = 0, err = 0;
>>>       u32 sr;
>>> -    retval = pm_runtime_resume_and_get((struct device 
>>> *)priv->rng.priv);
>>> +    retval = pm_runtime_resume_and_get(priv->dev);
>>>       if (retval)
>>>           return retval;
>>> @@ -206,7 +207,7 @@ static int stm32_rng_read(struct hwrng *rng, void 
>>> *data, size_t max, bool wait)
>>>                                      sr, sr,
>>>                                      10, 50000);
>>>               if (err) {
>>> -                dev_err((struct device *)priv->rng.priv,
>>> +                dev_err(priv->dev,
>>>                       "%s: timeout %x!\n", __func__, sr);
>>
>> Nit: Fits in one line
> 
> The limit is now 100 instead of 80 chars, right ?
> 
> btw I found one more and fixed it.

Yes it is,

thanks
