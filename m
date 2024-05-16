Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E691C143C56
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 10:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715856929; cv=none; b=twy8x2BpZ1xAZ3laq7w6S2uSXeP6kDYEQTJ3gO2nSBUwS+BWVg3LzA++AuDbG/y6W5jHa3/RnECxLZ3TdtXMyCWg6R2PNHZMkBfYd4/k9oSnWzQO5CVeYVwp9G2Wg8Ng97369srER3J8JIG4mJl5CeIUBSY2HPREbIKXKzMKtNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715856929; c=relaxed/simple;
	bh=1BQrR/D4/ofBTHHDkcwbt24he94YKvQFBsyQwJRtu8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kD5yOijxvXSijrAH4H3PYb/VAtH+NYKjcGRWuMOQ3CQIzuz42U+qyko5nla915F3VEUA8BPUeOJegA2RM6eEMQZKMrUPIu+kIK4SJaOPn+24EfDhD/KVykpa5RQ6qzJI3ezLHOZh6l2vWXwWjS7T2+P/+Fm30/qMYigCkX6W9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=xsKg0yQD; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="xsKg0yQD"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 31B3188080;
	Thu, 16 May 2024 12:55:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1715856925;
	bh=BGm4j+MAQe7qfEJLKK5z2ee+wgmO36NawXxM+a6a8nA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=xsKg0yQDBLIMUsiKakUMaV7SAhce4/DrXzOWuX+f3NJe7msr2rsA9OeJwSeHn9zcf
	 8cFO/1nGDh/1GdgADV3RN7zE2dKFrGXNthYMFOGKiIQiCNmLIwwATB9UbYT0NbvEUg
	 tDLdWhudVfW0H+IM+iS2jzBLdv3ZGc3ZlzGn8jx0S1fgkKhlEh3qTXJl9PyMoGosNz
	 /r8c91iE7TIVSDyJPU2JJrR6FV1v7e5R14hblgF+fdR4V1Focki0H0WsaOQ17ZmqCT
	 JRh41rX/rpdImixcgoxn+oI8jKE9sQD8kqVpDhEa4QEBF5YSnrNFcak7Fh7dUqf7El
	 VtZP4nhnb3j7A==
Message-ID: <404122b2-75fe-4da6-8167-fb98eba7f941@denx.de>
Date: Thu, 16 May 2024 12:52:22 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] hwrng: stm32 - cache device pointer in struct
 stm32_rng_private
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 linux-crypto@vger.kernel.org
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
 Yang Yingliang <yangyingliang@huawei.com>, kernel@dh-electronics.com,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com
References: <20240516012210.128307-1-marex@denx.de>
 <20240516012210.128307-2-marex@denx.de>
 <1e2da893-efff-4f7c-9842-a9484e4c2230@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <1e2da893-efff-4f7c-9842-a9484e4c2230@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/16/24 11:37 AM, Gatien CHEVALLIER wrote:

Hi,

>> diff --git a/drivers/char/hw_random/stm32-rng.c 
>> b/drivers/char/hw_random/stm32-rng.c
>> index 6dec4adc49853..00012e6e4ccc8 100644
>> --- a/drivers/char/hw_random/stm32-rng.c
>> +++ b/drivers/char/hw_random/stm32-rng.c
>> @@ -70,6 +70,7 @@ struct stm32_rng_config {
>>   struct stm32_rng_private {
>>       struct hwrng rng;
>> +    struct device *dev;
>>       void __iomem *base;
>>       struct clk *clk;
>>       struct reset_control *rst;
>> @@ -99,7 +100,7 @@ struct stm32_rng_private {
>>    */
>>   static int stm32_rng_conceal_seed_error_cond_reset(struct 
>> stm32_rng_private *priv)
>>   {
>> -    struct device *dev = (struct device *)priv->rng.priv;
>> +    struct device *dev = priv->dev;
>>       u32 sr = readl_relaxed(priv->base + RNG_SR);
>>       u32 cr = readl_relaxed(priv->base + RNG_CR);
>>       int err;
>> @@ -171,7 +172,7 @@ static int stm32_rng_conceal_seed_error(struct 
>> hwrng *rng)
>>   {
>>       struct stm32_rng_private *priv = container_of(rng, struct 
>> stm32_rng_private, rng);
>> -    dev_dbg((struct device *)priv->rng.priv, "Concealing seed error\n");
>> +    dev_dbg(priv->dev, "Concealing seed error\n");
>>       if (priv->data->has_cond_reset)
>>           return stm32_rng_conceal_seed_error_cond_reset(priv);
>> @@ -187,7 +188,7 @@ static int stm32_rng_read(struct hwrng *rng, void 
>> *data, size_t max, bool wait)
>>       int retval = 0, err = 0;
>>       u32 sr;
>> -    retval = pm_runtime_resume_and_get((struct device *)priv->rng.priv);
>> +    retval = pm_runtime_resume_and_get(priv->dev);
>>       if (retval)
>>           return retval;
>> @@ -206,7 +207,7 @@ static int stm32_rng_read(struct hwrng *rng, void 
>> *data, size_t max, bool wait)
>>                                      sr, sr,
>>                                      10, 50000);
>>               if (err) {
>> -                dev_err((struct device *)priv->rng.priv,
>> +                dev_err(priv->dev,
>>                       "%s: timeout %x!\n", __func__, sr);
> 
> Nit: Fits in one line

The limit is now 100 instead of 80 chars, right ?

btw I found one more and fixed it.
