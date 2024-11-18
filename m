Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46F6152166;
	Mon, 18 Nov 2024 11:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731929524; cv=none; b=ipkIS/NSTbVsS/G2NO2+Q/DN6U8xXLdenATSMqP+wQf2FsxQn/3yf3n3o1OZoxiTJRbDCe1vcCIAqOMBVO1iBudmMCq3dmWzWiYs0VbTBlG45yxmV9Ul1tS8AkDpyW/8fyOD/SjtmtWavzXsDJcRkGA1+qrIeJlRSN85jQFBvS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731929524; c=relaxed/simple;
	bh=iTDV+eWFB/b5UZJGsQSTWjcVwlsjgGRQi2yQPUpFiAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YbiOdqX9F4Vh1xcBJ8Tiwovd3oo8/I+Elb1Ts9PvR0esRLP0ronhePYT4OY5E0hqVoPcmpQGc0R9IBcaPf3nPh7U879UkvMw+4hHiHvABZGjkryrtZWUw7XcYELlE6whSVzkW2N3fq0Vf9v9A+UWteZ70cR7+OllttDRiBbycG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XsQRC2pNNzQtwn;
	Mon, 18 Nov 2024 19:30:31 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id 95B031800D9;
	Mon, 18 Nov 2024 19:31:51 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Mon, 18 Nov
 2024 19:31:50 +0800
Message-ID: <9a3b08c7-f9e2-4446-8a33-1de7ded85bb5@huawei.com>
Date: Mon, 18 Nov 2024 19:31:50 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: tegra - do not transfer req when tegra init
 fails
To: Chen Ridong <chenridong@huaweicloud.com>, <akhilrajeev@nvidia.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>
CC: <linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<wangweiyang2@huawei.com>
References: <20241111012827.1788341-1-chenridong@huaweicloud.com>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <20241111012827.1788341-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2024/11/11 9:28, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The tegra_cmac_init or tegra_sha_init function may return an error when
> memory is exhausted. It should not transfer the request when they return
> an error.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Akhil R <akhilrajeev@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c  | 7 +++++--
>  drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
> index 9d130592cc0a..d734c9a56786 100644
> --- a/drivers/crypto/tegra/tegra-se-aes.c
> +++ b/drivers/crypto/tegra/tegra-se-aes.c
> @@ -1750,10 +1750,13 @@ static int tegra_cmac_digest(struct ahash_request *req)
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>  	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
>  	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
> +	int ret;
>  
> -	tegra_cmac_init(req);
> -	rctx->task |= SHA_UPDATE | SHA_FINAL;
> +	ret = tegra_cmac_init(req);
> +	if (ret)
> +		return ret;
>  
> +	rctx->task |= SHA_UPDATE | SHA_FINAL;
>  	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
>  }
>  
> diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
> index 4d4bd727f498..0b5cdd5676b1 100644
> --- a/drivers/crypto/tegra/tegra-se-hash.c
> +++ b/drivers/crypto/tegra/tegra-se-hash.c
> @@ -615,13 +615,16 @@ static int tegra_sha_digest(struct ahash_request *req)
>  	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>  	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
> +	int ret;
>  
>  	if (ctx->fallback)
>  		return tegra_sha_fallback_digest(req);
>  
> -	tegra_sha_init(req);
> -	rctx->task |= SHA_UPDATE | SHA_FINAL;
> +	ret = tegra_sha_init(req);
> +	if (ret)
> +		return ret;
>  
> +	rctx->task |= SHA_UPDATE | SHA_FINAL;
>  	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
>  }
>  
Friendly ping.
