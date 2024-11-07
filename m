Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9CE79F6;
	Thu,  7 Nov 2024 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730942321; cv=none; b=DN7igjg3OGM0e6h0V6FLlUxMdNAip8Qk/ujFxHZbxy/4bXZHI8PkpMbczKrOj1hvndeOXwTdlI0YWGyBg4DgGfhSp19VgMgwxOr9c+ImLcQYVYfvbUWzkj+MMQg2i68zp8mS6uceMGALSsVmWPfeRwKV1pcwLddZT5gGfB7hxAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730942321; c=relaxed/simple;
	bh=TA+YjaFzbIJ3QWx6+XPLwyJ47JqlFrfEdxMALTCLQuo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Gmd649LWMa9BIycogwlC65Tv9kv359Vtw5maO9IRWGXjFvkTpsmyBZdwU1RW1SDEVCun/30oLCQo0hvly6aBVkXMuaC+rCyoydfkmZNa96u2yfnxc+z0oRyabg8cWskgBW8CsxC3Be4824OlZSXXs2LeYo+MwXfIs/2wir2o4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XkPLv0QdFz20pNZ;
	Thu,  7 Nov 2024 09:17:27 +0800 (CST)
Received: from kwepemf500004.china.huawei.com (unknown [7.202.181.242])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B3961402E2;
	Thu,  7 Nov 2024 09:18:34 +0800 (CST)
Received: from [10.67.110.237] (10.67.110.237) by
 kwepemf500004.china.huawei.com (7.202.181.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 7 Nov 2024 09:18:34 +0800
Subject: Re: [PATCH] crypto: inside-secure - Fix the return value of
 safexcel_xcbcmac_cra_init()
To: Antoine Tenart <atenart@kernel.org>, <davem@davemloft.net>,
	<herbert@gondor.apana.org.au>, <pliem@maxlinear.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241031112755.2949815-1-lihuafei1@huawei.com>
 <173082242323.5505.14169181853894683603@kwain>
From: Li Huafei <lihuafei1@huawei.com>
Message-ID: <b4fd8b58-1736-d2ef-0c81-6cb97a7987d4@huawei.com>
Date: Thu, 7 Nov 2024 09:18:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <173082242323.5505.14169181853894683603@kwain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemf500004.china.huawei.com (7.202.181.242)



On 2024/11/6 0:00, Antoine Tenart wrote:
> Quoting Li Huafei (2024-10-31 12:27:55)
>> The commit 320406cb60b6 ("crypto: inside-secure - Replace generic aes
>> with libaes") replaced crypto_alloc_cipher() with kmalloc(), but did not
>> modify the handling of the return value. When kmalloc() returns NULL,
>> PTR_ERR_OR_ZERO(NULL) returns 0, but in fact, the memory allocation has
>> failed, and -ENOMEM should be returned.
>>
>> Fixes: 320406cb60b6 ("crypto: inside-secure - Replace generic aes with libaes")
>> Signed-off-by: Li Huafei <lihuafei1@huawei.com>
> 
> Acked-by: Antoine Tenart <atenart@kernel.org>
> 
> Thanks!
> 

Thank you for reviewing.

>> ---
>>  drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
>> index e17577b785c3..f44c08f5f5ec 100644
>> --- a/drivers/crypto/inside-secure/safexcel_hash.c
>> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
>> @@ -2093,7 +2093,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
>>  
>>         safexcel_ahash_cra_init(tfm);
>>         ctx->aes = kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
>> -       return PTR_ERR_OR_ZERO(ctx->aes);
>> +       return ctx->aes == NULL ? -ENOMEM : 0;
>>  }
>>  
>>  static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
>> -- 
>> 2.25.1
>>
> .
> 
