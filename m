Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5819415B99E;
	Mon, 27 Jan 2025 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737996207; cv=none; b=YghAQhpnySulhfObYaHkmmj3MKQXJRyr6h+bVq6TL2hIgJF7rhwDBR+jXiQychBsc6ejWz94Mi+myRG/SyQH/+/g67LjbQdFS2MBt5j9YspupS8m8annBX2wW1j1VeEQIp4CSJZKH1NG4WtFuFUxmmG4hK1dtF7/qi5I5XYwQgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737996207; c=relaxed/simple;
	bh=2vh3gQBcWDjHl3OPtCSsuv42E0/7QPCTsCxMXy7tHoQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EhkdhuXkpGaufvSKforr9X136WxfIbKdhOUdlmDxl6jnOD+dBatulmYM+c5QTqveR6io4JgbatTIkWDQ6ArNNrooMlG/3+ZA4JqQDU1Zi2/CkBiORoYDFZCceBeS4ah+dOjZJeVB5abip0AOw1sDMwTYxTPdUbg3z/B2iRoztp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=fNFKjOdX; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="fNFKjOdX"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 50RGg5ok1861149
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 27 Jan 2025 10:42:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1737996125;
	bh=snJzHLGLUFIgdc5a6ktVN6chVPoIl5sBLs6+wMwFcoA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=fNFKjOdXWJ0cifidahgVl0rRh3l6sGMWgVOPOBf81Y9wcKy+xdLTZ4BYTNQ59fHXa
	 cCR+vbwihFWxo3i9zpkIdSLKMibDLu38B9ac8ik/h/PkpLLtCKS/B5sob2ntzs0TMZ
	 qKd7JDcpMFbRWWsggPlUjOkomV9k0CkaxWAim1Gk=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTP id 50RGg5cA127456;
	Mon, 27 Jan 2025 10:42:05 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 27
 Jan 2025 10:42:05 -0600
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 27 Jan 2025 10:42:05 -0600
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 50RGg4r1125338;
	Mon, 27 Jan 2025 10:42:05 -0600
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Martin Kaiser <martin@kaiser.cx>, Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Martin Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH] hwrng: imx-rngc - add runtime pm
In-Reply-To: <20250118160701.32624-1-martin@kaiser.cx>
References: <20250118160701.32624-1-martin@kaiser.cx>
Date: Mon, 27 Jan 2025 22:12:03 +0530
Message-ID: <87wmegi4ys.fsf@kamlesh.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Martin Kaiser <martin@kaiser.cx> writes:
...
> @@ -169,7 +178,11 @@ static int imx_rngc_init(struct hwrng *rng)
>  {
>  	struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
>  	u32 cmd, ctrl;
> -	int ret;
> +	int ret, err;
> +
> +	err = pm_runtime_resume_and_get(rngc->dev);
> +	if (err)
> +		return err;
>  
>  	/* clear error */
>  	cmd = readl(rngc->base + RNGC_COMMAND);
> @@ -186,15 +199,15 @@ static int imx_rngc_init(struct hwrng *rng)
>  		ret = wait_for_completion_timeout(&rngc->rng_op_done,
>  						  msecs_to_jiffies(RNGC_SEED_TIMEOUT));
>  		if (!ret) {
> -			ret = -ETIMEDOUT;
> -			goto err;
> +			err = -ETIMEDOUT;
> +			goto out;
>  		}
>  
>  	} while (rngc->err_reg == RNGC_ERROR_STATUS_STAT_ERR);
>  
>  	if (rngc->err_reg) {
> -		ret = -EIO;
> -		goto err;
> +		err = -EIO;
> +		goto out;
>  	}
>  
>  	/*
> @@ -205,23 +218,30 @@ static int imx_rngc_init(struct hwrng *rng)
>  	ctrl |= RNGC_CTRL_AUTO_SEED;
>  	writel(ctrl, rngc->base + RNGC_CONTROL);
>  
> +	err = 0;
is this really needed? The only time control reaches here when err = 0
in below equation
	err = pm_runtime_resume_and_get(rngc->dev);
	if (err)
		return err;

or am I missing something?

Regards,
Kamlesh

> +out:
>  	/*
>  	 * if initialisation was successful, we keep the interrupt
>  	 * unmasked until imx_rngc_cleanup is called
>  	 * we mask the interrupt ourselves if we return an error
>  	 */
> -	return 0;
> +	if (err)
> +		imx_rngc_irq_mask_clear(rngc);
>  
> -err:
