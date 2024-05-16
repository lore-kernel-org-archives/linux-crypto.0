Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C994614293
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 09:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715852333; cv=none; b=h+PVaaYzDj2GKIIbLDc3iDmQ+X7btXcXN3lAH3gCy41jCKSmDjdYgNZqmaBGxH4BT+yY4xO8kRH1jBiyxbEzD1qmKjou5oe3j3aT//ALIDzVQqRnqHHQLZQR9trbl6zSucJhqh6ys+rpYxqXdUgkjpoLPJ1LHDJKY6Is1FXuIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715852333; c=relaxed/simple;
	bh=qShbgtqD3PMj+x8YhMStAtk/Em05+MHyb5SJaZLOPKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=phdbg3+Tgf4pZEd1eO2ByHU/HY9oRaWsSfEdhcWupXcY/CJfbG3dtoUFSQTYR4m/TzftNMRKThggJXQu1gwdxV7gvYS9Oi4TDKJ4ZJ2hwINESRG9RVqvHUjxk1wc2h/T/12OoUe73CHLjWvzya9yexarxB856DVRMaOnuA7G584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=2lbLnQtw; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="2lbLnQtw"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44G79DP5015056;
	Thu, 16 May 2024 11:37:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	selector1; bh=vjJD8Q5ZIW3BNP+cyeOls+AMVj9R7UNnLDd07n6em6U=; b=2l
	bLnQtwi9Gb9Ej2Agf86/kV9MJCaLw901af2vGTW6YveyzwX2dzHOlrxsOl6yX5xV
	iaim7Fg2cQiQMeBBtjlJIme3qmzsFSfC145P+Ulq1mKsPdRGswYkV4+x20DLeP7W
	stkC54pK3Wt/YyPSB8twqQddlsinoFqL4m2TDWUPIxIUMX/fpQg08c4mqZIGqEp6
	VUKN1Nb4pd9g2dM2FUIY/A9h80CQw1ycS4U7r7e9a37eqC8AEmRrwEx+1uV+6Mvs
	kk04uWcVkA+ZgQlId9a3zu8i4VHHPaBVRsLBl5lW1XQVLmtrEjY0IjXfFMXkqFnj
	tL9uBJyvI1WZr9pVIkVw==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3y4sxv4xw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 11:37:53 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 8471340048;
	Thu, 16 May 2024 11:37:44 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7CA65210753;
	Thu, 16 May 2024 11:37:27 +0200 (CEST)
Received: from [10.48.87.204] (10.48.87.204) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 16 May
 2024 11:37:26 +0200
Message-ID: <1e2da893-efff-4f7c-9842-a9484e4c2230@foss.st.com>
Date: Thu, 16 May 2024 11:37:26 +0200
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
Content-Language: en-US
From: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <20240516012210.128307-2-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_05,2024-05-15_01,2023-05-22_02



On 5/16/24 03:20, Marek Vasut wrote:
> Place device pointer in struct stm32_rng_private and use it all over the
> place to get rid of the horrible type casts throughout the driver.
> 
> No functional change.
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
>   drivers/char/hw_random/stm32-rng.c | 25 +++++++++++++------------
>   1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> index 6dec4adc49853..00012e6e4ccc8 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -70,6 +70,7 @@ struct stm32_rng_config {
>   
>   struct stm32_rng_private {
>   	struct hwrng rng;
> +	struct device *dev;
>   	void __iomem *base;
>   	struct clk *clk;
>   	struct reset_control *rst;
> @@ -99,7 +100,7 @@ struct stm32_rng_private {
>    */
>   static int stm32_rng_conceal_seed_error_cond_reset(struct stm32_rng_private *priv)
>   {
> -	struct device *dev = (struct device *)priv->rng.priv;
> +	struct device *dev = priv->dev;
>   	u32 sr = readl_relaxed(priv->base + RNG_SR);
>   	u32 cr = readl_relaxed(priv->base + RNG_CR);
>   	int err;
> @@ -171,7 +172,7 @@ static int stm32_rng_conceal_seed_error(struct hwrng *rng)
>   {
>   	struct stm32_rng_private *priv = container_of(rng, struct stm32_rng_private, rng);
>   
> -	dev_dbg((struct device *)priv->rng.priv, "Concealing seed error\n");
> +	dev_dbg(priv->dev, "Concealing seed error\n");
>   
>   	if (priv->data->has_cond_reset)
>   		return stm32_rng_conceal_seed_error_cond_reset(priv);
> @@ -187,7 +188,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   	int retval = 0, err = 0;
>   	u32 sr;
>   
> -	retval = pm_runtime_resume_and_get((struct device *)priv->rng.priv);
> +	retval = pm_runtime_resume_and_get(priv->dev);
>   	if (retval)
>   		return retval;
>   
> @@ -206,7 +207,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   								   sr, sr,
>   								   10, 50000);
>   			if (err) {
> -				dev_err((struct device *)priv->rng.priv,
> +				dev_err(priv->dev,
>   					"%s: timeout %x!\n", __func__, sr);

Nit: Fits in one line

>   				break;
>   			}
> @@ -220,7 +221,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   				err = stm32_rng_conceal_seed_error(rng);
>   				i++;
>   				if (err && i > RNG_NB_RECOVER_TRIES) {
> -					dev_err((struct device *)priv->rng.priv,
> +					dev_err(priv->dev,
>   						"Couldn't recover from seed error\n");

Nit: Fits in one line

>   					retval = -ENOTRECOVERABLE;
>   					goto exit_rpm;
> @@ -239,7 +240,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   			err = stm32_rng_conceal_seed_error(rng);
>   			i++;
>   			if (err && i > RNG_NB_RECOVER_TRIES) {
> -				dev_err((struct device *)priv->rng.priv,
> +				dev_err(priv->dev,
>   					"Couldn't recover from seed error");

Nit: Fits in one line

>   				retval = -ENOTRECOVERABLE;
>   				goto exit_rpm;
> @@ -255,8 +256,8 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   	}
>   
>   exit_rpm:
> -	pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
> -	pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
> +	pm_runtime_mark_last_busy(priv->dev);
> +	pm_runtime_put_sync_autosuspend(priv->dev);
>   
>   	return retval || !wait ? retval : -EIO;
>   }
> @@ -331,8 +332,7 @@ static int stm32_rng_init(struct hwrng *rng)
>   							10, 50000);
>   		if (err) {
>   			clk_disable_unprepare(priv->clk);
> -			dev_err((struct device *)priv->rng.priv,
> -				"%s: timeout %x!\n", __func__, reg);
> +			dev_err(priv->dev, "%s: timeout %x!\n", __func__, reg);
>   			return -EINVAL;
>   		}
>   	} else {
> @@ -360,7 +360,7 @@ static int stm32_rng_init(struct hwrng *rng)
>   						10, 100000);
>   	if (err || (reg & ~RNG_SR_DRDY)) {
>   		clk_disable_unprepare(priv->clk);
> -		dev_err((struct device *)priv->rng.priv,
> +		dev_err(priv->dev,
>   			"%s: timeout:%x SR: %x!\n", __func__, err, reg);

Nit: Fits in one line

>   		return -EINVAL;
>   	}
> @@ -467,7 +467,7 @@ static int __maybe_unused stm32_rng_resume(struct device *dev)
>   
>   		if (err) {
>   			clk_disable_unprepare(priv->clk);
> -			dev_err((struct device *)priv->rng.priv,
> +			dev_err(priv->dev,
>   				"%s: timeout:%x CR: %x!\n", __func__, err, reg);
>   			return -EINVAL;
>   		}
> @@ -543,6 +543,7 @@ static int stm32_rng_probe(struct platform_device *ofdev)
>   
>   	priv->ced = of_property_read_bool(np, "clock-error-detect");
>   	priv->lock_conf = of_property_read_bool(np, "st,rng-lock-conf");
> +	priv->dev = dev;
>   
>   	priv->data = of_device_get_match_data(dev);
>   	if (!priv->data)

With nits applied,

Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
