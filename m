Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4020334372;
	Tue, 23 Dec 2025 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766493432; cv=none; b=TnPbni6pbOetojivg3KsiE64keT3S/IQ1u7ernBys7UR5jlyRPL6iz3L9i6gLK5b3QzcZlahAsfN6RDpbMEntipmrcvkY4/fEwxyt86w1KTnz6zviMGi2I/lW2EW8mk+7Pn4T3DhO5Gu4kMlGtySmU74an3t7/qxyoIJXQ4ABkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766493432; c=relaxed/simple;
	bh=U0mlBN/a9wqcJASzRDO6wPqklOXQbPIDla5bEny9SuM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qG7yo0pF88lP0WZkK7pJvKt9VQrWFT6x01vrbR/r9pSDPMkQXxjcJmxXMUqGiXwRHK2/usYcEFA1ZIr3nFk3D/AZM6smBfctJ18m5fofgUQJmvM5+PTBGeAQ6qgfXoixm7IESmkqPZ2sMwsFXGFajH9YW3tMP+2bjTM1TbcoMUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=UschpVYa; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="UschpVYa"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4eMQndOFhFyDdiBLQYcmtuiUxJsRkqaeHDw00uhkZjY=;
	b=UschpVYavj7ulCG+2AsQNwg+707gf8EUgyRHt9hOsM4BensGDSQXA49o83FRi5j/YuWjo7S2Z
	9inVBRRzv1DzSTebFWxsl/C3xXq7CI8ZRuy6wIJDNJG9PV4HIozaPcrd0Aic8tD0iAXgzdYOxty
	DYSCdnabxWsxDUWkr9YXMM0=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dbDvm6Gsyz1cyPx;
	Tue, 23 Dec 2025 20:33:56 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id C09494056C;
	Tue, 23 Dec 2025 20:37:02 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Dec 2025 20:37:01 +0800
Subject: Re: [PATCH] crypto: hisilicon/sgl - fix inconsistent map/unmap
 direction issue
To: Chenghai Huang <huangchenghai2@huawei.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
References: <20251219033619.1871450-1-huangchenghai2@huawei.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <7569c3cd-92ea-81c1-b57e-cebcacee66e7@huawei.com>
Date: Tue, 23 Dec 2025 20:37:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251219033619.1871450-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2025/12/19 11:36, Chenghai Huang wrote:
> Ensure that the direction for dma_map_sg and dma_unmap_sg is
> consistent.
> 
> Fixes: 2566de3e06a3 ("crypto: hisilicon - Use fine grained DMA mapping direction")
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sgl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index 24c7b6ab285b..d41b34405c21 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -260,7 +260,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev, struct scatterlist *sgl,
>  	return curr_hw_sgl;
>  
>  err_unmap:
> -	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
> +	dma_unmap_sg(dev, sgl, sg_n, dir);
>  
>  	return ERR_PTR(ret);
>  }

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks for fixing it!

Zenghui
