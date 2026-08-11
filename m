Received: from mail.mleia.com (mleia.com [178.79.152.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EADF23BD17;
	Tue, 11 Aug 2026 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.79.152.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786427863; cv=none; b=LlSczBpBkc6L7/KRiCI1GemSekbbQWm/NMi1cYfSv5X4tJ1LKNKcNopG3OlwsXJjNpP6m1RzvJJ5eJw2wyYa3QN8/oZibmapVAHOC6TVduotDHRryJj5bd5M5lr06rjXZjxRcj26ubtBIKhmMWUzIZuG+cDWNBTIEsbXEGHuIcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786427863; c=relaxed/simple;
	bh=Bk+CInxf9FHIERW+dZt8wYMYJu2d5PRYlTnJAf2G6xw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLP5SwNFOoWDWxuYJO8XIxNITYJ4fFjmRsLF2aIrnZUG9h1WT2o6Ve3HxSJ5eZPUn2dN2H5XBqj/V8TgHLu+/ZXxUe/sdz70/FMjF1YMgmN1+hEKJPzUHH83opzizA8SlDnfMGKPY0osoBO6Pa3jCvDC0aqKiFCekvF12XyWHqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mleia.com; spf=none smtp.mailfrom=mleia.com; dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b=N/jJErYM; dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b=N/jJErYM; arc=none smtp.client-ip=178.79.152.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mleia.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mleia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b="N/jJErYM";
	dkim=pass (2048-bit key) header.d=mleia.com header.i=@mleia.com header.b="N/jJErYM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mleia.com; s=mail;
	t=1786427416; bh=Bk+CInxf9FHIERW+dZt8wYMYJu2d5PRYlTnJAf2G6xw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N/jJErYMgWZ11+vumlqXsJaolJHItHkIW/YTt+vfvwQexZO4hEPBIN5IoflpwXCGK
	 FegV2qst8ngvZZBIwGNYRpPiGNIueQ1yt8XjN3zfDetJe2jeuh/yK5C7qDZox7OrHu
	 4MB8ZdsipTy6pHVzTao5iaZ5ipnKLo13dJ/Ve1YGfqXMLGqMKcHFoltJQ1bqRBc4Lp
	 7l7dYWvZc4XO1L5+yR5mWqFQq5LuXu5MvymP28uwUVRmPsXzR9s143qHlePhHR91oi
	 jS0F1T1371IT4qMklCkM8C2SAxO5HXi8zyGgi0mB/KJZCLA3CQBEhA9sAR3jrY3ciC
	 YHHoAXtS27+zA==
Received: from mail.mleia.com (localhost [127.0.0.1])
	by mail.mleia.com (Postfix) with ESMTP id 6D24B3FFE71;
	Tue, 11 Aug 2026 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mleia.com; s=mail;
	t=1786427416; bh=Bk+CInxf9FHIERW+dZt8wYMYJu2d5PRYlTnJAf2G6xw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N/jJErYMgWZ11+vumlqXsJaolJHItHkIW/YTt+vfvwQexZO4hEPBIN5IoflpwXCGK
	 FegV2qst8ngvZZBIwGNYRpPiGNIueQ1yt8XjN3zfDetJe2jeuh/yK5C7qDZox7OrHu
	 4MB8ZdsipTy6pHVzTao5iaZ5ipnKLo13dJ/Ve1YGfqXMLGqMKcHFoltJQ1bqRBc4Lp
	 7l7dYWvZc4XO1L5+yR5mWqFQq5LuXu5MvymP28uwUVRmPsXzR9s143qHlePhHR91oi
	 jS0F1T1371IT4qMklCkM8C2SAxO5HXi8zyGgi0mB/KJZCLA3CQBEhA9sAR3jrY3ciC
	 YHHoAXtS27+zA==
Message-ID: <3d5a5d40-f254-4028-b408-abb4c71d7e90@mleia.com>
Date: Tue, 11 Aug 2026 08:50:15 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s5p-sss: pass s5p_aes_dev to irq handler
To: Rosen Penev <rosenp@gmail.com>, linux-crypto@vger.kernel.org
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "open list:SAMSUNG S5P Security SubSystem (SSS) DRIVER"
 <linux-samsung-soc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260811043358.136042-1-rosenp@gmail.com>
From: Vladimir Zapolskiy <vz@mleia.com>
In-Reply-To: <20260811043358.136042-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20260811_055016_464551_66583C7D 
X-CRM114-Status: GOOD (  18.26  )

On 8/11/26 07:33, Rosen Penev wrote:
> The threaded irq handler takes the platform device and calls
> platform_get_drvdata() to recover the driver data.  Pass the driver
> data directly as the devm_request_threaded_irq() argument instead,
> dropping the platform_get_drvdata() call.
> 
> Assisted-by: opencode:deepseek-v4-flash-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   drivers/crypto/s5p-sss.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index bdda7b39af85..f20c02e9d646 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -638,8 +638,7 @@ static int s5p_hash_rx(struct s5p_aes_dev *dev)
>   
>   static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
>   {
> -	struct platform_device *pdev = dev_id;
> -	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
> +	struct s5p_aes_dev *dev = dev_id;
>   	struct skcipher_request *req;
>   	int err_dma_tx = 0;
>   	int err_dma_rx = 0;
> @@ -2221,7 +2220,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>   	}
>   	err = devm_request_threaded_irq(dev, pdata->irq_fc, NULL,
>   					s5p_aes_interrupt, IRQF_ONESHOT,
> -					pdev->name, pdev);
> +					pdev->name, pdata);
>   	if (err < 0) {
>   		dev_warn(dev, "feed control interrupt is not available.\n");
>   		goto err_irq;

Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>

-- 
Best wishes,
Vladimir
