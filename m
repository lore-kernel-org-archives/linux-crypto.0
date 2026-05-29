Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8E1352014;
	Fri, 29 May 2026 11:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780054021; cv=none; b=fex4BhPE8gJUxfBIbaw9A5RYKQZQcANrzFxm1KVUHlciYzuSG7qya1bUKFjtR3RhjgX0nKpwu6BBsFlPH93Q5YwTxCbW+Qqxyivlr9LD0KhPBgHM92bPc3gmEsnKCPlpsQBP+qi0Cywjd3A/0JNv7c+5B4Gloo/r4VR09YQn9EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780054021; c=relaxed/simple;
	bh=IwpqKO61SyqnSZJbnC/9wFDQXvwb8ejU/febmQ/AthI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHSvqplzOGTkwaXMAdUtNfKmAbnvbgkhD0ZEy7yBEVojl5KCsoQuCW7j0YiUqf9EbPu5hTfaDI1b+PTLKHFwxGszYlp2yjcKAwzu0Vjdg+YntJdZTtwwTnoTHkELUgjm6nO1JJJxsuAScGJw05YNsK+Ljym/V4m/XCU2JqCbBEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRAU7mxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRAU7mxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30DE1F00893;
	Fri, 29 May 2026 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780054020;
	bh=m9q06nkO84F+uAapM5OGgoWRKfUUx033NsUvJB/uPs4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FRAU7mxUK05UBDKK+gD/VkaJLIvlu1nHyku4yQNVb8/R0UBodheOKokl7e7RYQ53o
	 p+RlyOt4FKRjpNruxrBPTnzAqQG+8deP1cLb95YJxNzj27V8V6fPeBV/exRSgmod/Z
	 RS41a9xL/TAiJ/XbMTqJw5VHyVHyPB/MAcnJtgpmHwoyapdU5zxwKSKqhyW9BGjCRX
	 RawsaRpcM423FRvI1RAhgny5CiGzdHuwMbW+9TQnf5KGvud/mAwyQcRAZ6UrriP82n
	 AYYv+KtkjknqhCMtmh+OgHG4YKigbMPKFObZcJQt0/38Vxou3E0MSBzBR6gPUR/9Sy
	 2YbL1TWkegz/g==
Message-ID: <d6f4f508-65ce-4753-b326-a2de54e1bc2d@kernel.org>
Date: Fri, 29 May 2026 13:26:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/29] crypto: talitos/hwrng - Move into separate file
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-4-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-4-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Move the hardware random number generator implementation from
> talitos.c into a dedicated talitos-rng.c file.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/talitos/Makefile      |  2 +
>   drivers/crypto/talitos/talitos-rng.c | 93 ++++++++++++++++++++++++++++++++++++
>   drivers/crypto/talitos/talitos.c     | 83 --------------------------------
>   drivers/crypto/talitos/talitos.h     |  5 ++
>   4 files changed, 100 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
> index fcc5db5e63c2..901ec681f010 100644
> --- a/drivers/crypto/talitos/Makefile
> +++ b/drivers/crypto/talitos/Makefile
> @@ -1 +1,3 @@
>   obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
> +
> +talitos-y := talitos.o talitos-rng.o
> diff --git a/drivers/crypto/talitos/talitos-rng.c b/drivers/crypto/talitos/talitos-rng.c
> new file mode 100644
> index 000000000000..3aa00de33b25
> --- /dev/null
> +++ b/drivers/crypto/talitos/talitos-rng.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +/*
> + * Freescale SEC (talitos) device hardware random number generator implementation
> + *
> + * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +
> +#include "talitos.h"
> +
> +static int talitos_rng_data_present(struct hwrng *rng, int wait)
> +{
> +	struct device *dev = (struct device *)rng->priv;
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	u32 ofl;
> +	int i;
> +
> +	for (i = 0; i < 20; i++) {
> +		ofl = in_be32(priv->reg_rngu + TALITOS_EUSR_LO) &
> +		      TALITOS_RNGUSR_LO_OFL;
> +		if (ofl || !wait)
> +			break;
> +		udelay(10);
> +	}
> +
> +	return !!ofl;
> +}
> +
> +static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
> +{
> +	struct device *dev = (struct device *)rng->priv;
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	/* rng fifo requires 64-bit accesses */
> +	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO);
> +	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO_LO);
> +
> +	return sizeof(u32);
> +}
> +
> +static int talitos_rng_init(struct hwrng *rng)
> +{
> +	struct device *dev = (struct device *)rng->priv;
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	unsigned int timeout = TALITOS_TIMEOUT;
> +
> +	setbits32(priv->reg_rngu + TALITOS_EURCR_LO, TALITOS_RNGURCR_LO_SR);
> +	while (!(in_be32(priv->reg_rngu + TALITOS_EUSR_LO)
> +		 & TALITOS_RNGUSR_LO_RD)
> +	       && --timeout)
> +		cpu_relax();
> +	if (timeout == 0) {
> +		dev_err(dev, "failed to reset rng hw\n");
> +		return -ENODEV;
> +	}
> +
> +	/* start generating */
> +	setbits32(priv->reg_rngu + TALITOS_EUDSR_LO, 0);
> +
> +	return 0;
> +}
> +
> +int talitos_register_rng(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	int err;
> +
> +	priv->rng.name		= dev_driver_string(dev);
> +	priv->rng.init		= talitos_rng_init;
> +	priv->rng.data_present	= talitos_rng_data_present;
> +	priv->rng.data_read	= talitos_rng_data_read;
> +	priv->rng.priv		= (unsigned long)dev;
> +
> +	err = hwrng_register(&priv->rng);
> +	if (!err)
> +		priv->rng_registered = true;
> +
> +	return err;
> +}
> +
> +void talitos_unregister_rng(struct device *dev)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	if (!priv->rng_registered)
> +		return;
> +
> +	hwrng_unregister(&priv->rng);
> +	priv->rng_registered = false;
> +}
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index 8ca587b98d92..f5feff8f7d3d 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -820,89 +820,6 @@ DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
>   DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
>   		       1)
>   
> -/*
> - * hwrng
> - */
> -static int talitos_rng_data_present(struct hwrng *rng, int wait)
> -{
> -	struct device *dev = (struct device *)rng->priv;
> -	struct talitos_private *priv = dev_get_drvdata(dev);
> -	u32 ofl;
> -	int i;
> -
> -	for (i = 0; i < 20; i++) {
> -		ofl = in_be32(priv->reg_rngu + TALITOS_EUSR_LO) &
> -		      TALITOS_RNGUSR_LO_OFL;
> -		if (ofl || !wait)
> -			break;
> -		udelay(10);
> -	}
> -
> -	return !!ofl;
> -}
> -
> -static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
> -{
> -	struct device *dev = (struct device *)rng->priv;
> -	struct talitos_private *priv = dev_get_drvdata(dev);
> -
> -	/* rng fifo requires 64-bit accesses */
> -	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO);
> -	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO_LO);
> -
> -	return sizeof(u32);
> -}
> -
> -static int talitos_rng_init(struct hwrng *rng)
> -{
> -	struct device *dev = (struct device *)rng->priv;
> -	struct talitos_private *priv = dev_get_drvdata(dev);
> -	unsigned int timeout = TALITOS_TIMEOUT;
> -
> -	setbits32(priv->reg_rngu + TALITOS_EURCR_LO, TALITOS_RNGURCR_LO_SR);
> -	while (!(in_be32(priv->reg_rngu + TALITOS_EUSR_LO)
> -		 & TALITOS_RNGUSR_LO_RD)
> -	       && --timeout)
> -		cpu_relax();
> -	if (timeout == 0) {
> -		dev_err(dev, "failed to reset rng hw\n");
> -		return -ENODEV;
> -	}
> -
> -	/* start generating */
> -	setbits32(priv->reg_rngu + TALITOS_EUDSR_LO, 0);
> -
> -	return 0;
> -}
> -
> -static int talitos_register_rng(struct device *dev)
> -{
> -	struct talitos_private *priv = dev_get_drvdata(dev);
> -	int err;
> -
> -	priv->rng.name		= dev_driver_string(dev);
> -	priv->rng.init		= talitos_rng_init;
> -	priv->rng.data_present	= talitos_rng_data_present;
> -	priv->rng.data_read	= talitos_rng_data_read;
> -	priv->rng.priv		= (unsigned long)dev;
> -
> -	err = hwrng_register(&priv->rng);
> -	if (!err)
> -		priv->rng_registered = true;
> -
> -	return err;
> -}
> -
> -static void talitos_unregister_rng(struct device *dev)
> -{
> -	struct talitos_private *priv = dev_get_drvdata(dev);
> -
> -	if (!priv->rng_registered)
> -		return;
> -
> -	hwrng_unregister(&priv->rng);
> -	priv->rng_registered = false;
> -}
>   
>   /*
>    * crypto alg
> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
> index 56e36a65ddcc..fa8c71b1f90f 100644
> --- a/drivers/crypto/talitos/talitos.h
> +++ b/drivers/crypto/talitos/talitos.h
> @@ -431,3 +431,8 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
>   #define DESC_PTR_LNKTBL_JUMP			0x80
>   #define DESC_PTR_LNKTBL_RET			0x02
>   #define DESC_PTR_LNKTBL_NEXT			0x01
> +
> +/* Hardware RNG */
> +
> +int talitos_register_rng(struct device *dev);
> +void talitos_unregister_rng(struct device *dev);
> 

