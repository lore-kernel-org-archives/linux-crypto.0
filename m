Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287F77462;
	Fri,  8 Nov 2024 01:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731028108; cv=none; b=YKOmYFO9gYiLOIxVmiTQ7m4P/wrSeCqvrlVkN7uNucbnFn2S4cW5/AjATnS2yHy3hKUUvl0qiSdQg9mN1psCp6+7eGjlMjJA6nuZrpvZDyj20mmNzCtaGIKQ9Sv4JmmoD6tweay/GKMOdSmhy21xWnDYFMnFf4WXPjWmkGHLi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731028108; c=relaxed/simple;
	bh=v/BsvlPFLlLYWQV7psW00BQ02tLfLpnnxbV2EVPidvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ShC1esLNwlMd6OjjESopODXvq0qmQ5rjIgYK9VvCRsmN1XlAuH+PjsCfnXLat9ibHvl3Zz9rBUFstbq7jZbteMwcEvPk60TMJp7n9/G5mmLol+DHnZin7CytnueKPBukjARsVio36EorCXlKQdNxD3oYX2sd+Sbti9kSJp4Mrpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xl13l1XK0z10V7h;
	Fri,  8 Nov 2024 09:06:27 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id 9DA6C1402C8;
	Fri,  8 Nov 2024 09:08:15 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 8 Nov
 2024 09:08:14 +0800
Message-ID: <5fd81139-9469-4893-bc53-852b994ad6ec@huawei.com>
Date: Fri, 8 Nov 2024 09:08:13 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: tegra - do not transfer req when tegra_sha_init
 returns an error
To: Akhil R <akhilrajeev@nvidia.com>, Chen Ridong
	<chenridong@huaweicloud.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"thierry.reding@gmail.com" <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"wangweiyang2@huawei.com" <wangweiyang2@huawei.com>
References: <20241107125211.1679517-1-chenridong@huaweicloud.com>
 <PH7PR12MB8178FB2C64F990DFD3D9D5BAC05C2@PH7PR12MB8178.namprd12.prod.outlook.com>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <PH7PR12MB8178FB2C64F990DFD3D9D5BAC05C2@PH7PR12MB8178.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2024/11/7 21:13, Akhil R wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The tegra_sha_init function may return an error when memory is exhausted.
>> It should not transfer the request when tegra_sha_init returns an error.
>>
>> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>> ---
>>  drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-
>> hash.c
>> index 4d4bd727f498..7e888bf5f66a 100644
>> --- a/drivers/crypto/tegra/tegra-se-hash.c
>> +++ b/drivers/crypto/tegra/tegra-se-hash.c
>> @@ -612,6 +612,7 @@ static int tegra_sha_finup(struct ahash_request *req)
>>
>>  static int tegra_sha_digest(struct ahash_request *req)
>>  {
>> +       int ret;
> 
> I would suggest moving this variable to below other variables for aesthetics.
> Same with the other patch for tegra_cmac_init() as well.
> .
>>         struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
>>         struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>>         struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
>> @@ -619,9 +620,11 @@ static int tegra_sha_digest(struct ahash_request *req)
>>         if (ctx->fallback)
>>                 return tegra_sha_fallback_digest(req);
>>
>> -       tegra_sha_init(req);
>> -       rctx->task |= SHA_UPDATE | SHA_FINAL;
>> +       ret = tegra_sha_init(req);
>> +       if (ret)
>> +               return ret;
>>
>> +       rctx->task |= SHA_UPDATE | SHA_FINAL;
>>         return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
>>  }
>>
>> --
>> 2.34.1
> 
> I think this can be combined with the other patch for tegra_cma_init() as both are similar
> fix. Apart from the minor comment above regarding the variable position, LGTM.
> 
> Acked-by: Akhil R <akhilrajeev@nvidia.com>
> 

Thanks，will update

Best regards,
Ridong
