Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0EF10A23
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 09:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47FB1991
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 01:09:34 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
	by ex01.ufhost.com (Postfix) with ESMTP id 763CF24E3E6;
	Thu,  9 Nov 2023 17:09:32 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 9 Nov
 2023 17:09:32 +0800
Received: from [192.168.155.75] (202.188.176.82) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 9 Nov
 2023 17:09:26 +0800
Message-ID: <93d63708-a2a8-9931-de9c-2c94fe288a88@starfivetech.com>
Date: Thu, 9 Nov 2023 17:09:04 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] crypto: jh7110 - Correct deferred probe return
To: Chanho Park <chanho61.park@samsung.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	William Qiu <william.qiu@starfivetech.com>, <linux-crypto@vger.kernel.org>
References: <CGME20231109063323epcas2p13d88ce8e8251dfa4eba4662c38cc08c9@epcas2p1.samsung.com>
 <20231109063259.3427055-1-chanho61.park@samsung.com>
Content-Language: en-US
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
In-Reply-To: <20231109063259.3427055-1-chanho61.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [202.188.176.82]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag

On 9/11/2023 2:32 pm, Chanho Park wrote:
> This fixes list_add corruption error when the driver is returned
> with -EPROBE_DEFER. It is also required to roll back the previous
> probe sequences in case of deferred_probe. So, this removes
> 'err_probe_defer" goto label and just use err_dma_init instead.
> 
> Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/crypto/starfive/jh7110-cryp.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
> index 08e974e0dd12..3a67ddc4d936 100644
> --- a/drivers/crypto/starfive/jh7110-cryp.c
> +++ b/drivers/crypto/starfive/jh7110-cryp.c
> @@ -180,12 +180,8 @@ static int starfive_cryp_probe(struct platform_device *pdev)
>  	spin_unlock(&dev_list.lock);
>  
>  	ret = starfive_dma_init(cryp);
> -	if (ret) {
> -		if (ret == -EPROBE_DEFER)
> -			goto err_probe_defer;
> -		else
> -			goto err_dma_init;
> -	}
> +	if (ret)
> +		goto err_dma_init;
>  
>  	/* Initialize crypto engine */
>  	cryp->engine = crypto_engine_alloc_init(&pdev->dev, 1);
> @@ -233,7 +229,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
>  
>  	tasklet_kill(&cryp->aes_done);
>  	tasklet_kill(&cryp->hash_done);
> -err_probe_defer:
> +
>  	return ret;
>  }
>  

Reviewed-by: Jia Jie Ho <jiajie.ho@starfivetech.com>

Thanks for catching this.

Regards,
Jia Jie
