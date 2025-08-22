Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5E9145355;
	Fri, 22 Aug 2025 02:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755831299; cv=none; b=QuyOgUxNzCG7g7LVaHiEisdiEZdHAFxifdjjJBhSDde6XwhW5EN6Ic895gMcs72TK/kzSy0SukrYhFi7HdkzJF8FAJHO2LnHVsMCK6zszCaXPjsZ6wh2a9DZbdMLPAyYZ19tPEmupBuYixqbEYazQP8lnesDl3p+KjSFq17gvyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755831299; c=relaxed/simple;
	bh=/C0nOkhfT4rkXgUlzKjyIlwlgMcpTPLqBpx4YH2OqLA=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jqbl9qtGbcE2SoMordrjdUq1cxZxc1+42uexzByAXAMxs5IAUZ2BnVhGhGI70pen3EnUs8+p3kH0xPdRURq4aKv7X0KrBPJKQIKvkTnIXfKfiJtjMvlHocnSnuyrC+dOfZ6qTgt88l667NvyLogQxGIRkwWnNnEDfs9Kg7m6U4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c7PsD4m2YztTKM;
	Fri, 22 Aug 2025 10:53:52 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 447D6180495;
	Fri, 22 Aug 2025 10:54:51 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 10:54:50 +0800
Subject: Re: [PATCH] crypto: hisilicon - use kcalloc() instead of kzalloc()
To: Qianfeng Rong <rongqianfeng@vivo.com>, Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Yang Shen <shenyang39@huawei.com>, Zhou Wang
	<wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20250821142732.34952-1-rongqianfeng@vivo.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <156232fe-f13a-f463-626f-152d4020bace@huawei.com>
Date: Fri, 22 Aug 2025 10:54:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250821142732.34952-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/21 22:27, Qianfeng Rong wrote:
> As noted in the kernel documentation [1], open-coded multiplication in
> allocator arguments is discouraged because it can lead to integer overflow.
> 
> Use devm_kcalloc() to gain built-in overflow protection, making memory
> allocation safer when calculating allocation size compared to explicit
> multiplication.
> 
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index f5b47e5ff48a..e1e428bdcf8f 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -1171,7 +1171,7 @@ static int hpre_pre_store_cap_reg(struct hisi_qm *qm)
>  	size_t i, size;
>  
>  	size = ARRAY_SIZE(hpre_cap_query_info);
> -	hpre_cap = devm_kzalloc(dev, sizeof(*hpre_cap) * size, GFP_KERNEL);
> +	hpre_cap = devm_kcalloc(dev, size, sizeof(*hpre_cap), GFP_KERNEL);
>  	if (!hpre_cap)
>  		return -ENOMEM;
>  
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 72cf48d1f3ab..10171bc6c05d 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -1169,7 +1169,7 @@ static int sec_pre_store_cap_reg(struct hisi_qm *qm)
>  	size_t i, size;
>  
>  	size = ARRAY_SIZE(sec_cap_query_info);
> -	sec_cap = devm_kzalloc(&pdev->dev, sizeof(*sec_cap) * size, GFP_KERNEL);
> +	sec_cap = devm_kcalloc(&pdev->dev, size, sizeof(*sec_cap), GFP_KERNEL);
>  	if (!sec_cap)
>  		return -ENOMEM;
>  
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index d8ba23b7cc7d..f0aecb8bc1c9 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -1273,7 +1273,7 @@ static int zip_pre_store_cap_reg(struct hisi_qm *qm)
>  	size_t i, size;
>  
>  	size = ARRAY_SIZE(zip_cap_query_info);
> -	zip_cap = devm_kzalloc(&pdev->dev, sizeof(*zip_cap) * size, GFP_KERNEL);
> +	zip_cap = devm_kcalloc(&pdev->dev, size, sizeof(*zip_cap), GFP_KERNEL);
>  	if (!zip_cap)
>  		return -ENOMEM;
>  
> 

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.
Longfang.

