Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550C9EB8FA5
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Sep 2023 07:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjIFHth (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Sep 2023 03:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjIFHth (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2023 03:49:37 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E022C9
        for <linux-crypto@vger.kernel.org>; Wed,  6 Sep 2023 00:49:33 -0700 (PDT)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RgZGl3TlMz1M8yq;
        Wed,  6 Sep 2023 15:47:43 +0800 (CST)
Received: from [10.67.109.150] (10.67.109.150) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 6 Sep 2023 15:49:30 +0800
Message-ID: <f06917ed-a0ba-30f1-4b65-57fe96bbf741@huawei.com>
Date:   Wed, 6 Sep 2023 15:49:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto: Fix hungtask for PADATA_RESET
Content-Language: en-US
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guo Zihua <guozihua@huawei.com>, <linux-crypto@vger.kernel.org>
References: <20230904133341.2528440-1-lujialin4@huawei.com>
 <ZPb4ovJ+eatyPk1E@gauss3.secunet.de>
From:   Lu Jialin <lujialin4@huawei.com>
In-Reply-To: <ZPb4ovJ+eatyPk1E@gauss3.secunet.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.150]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Steffen,

padata_do_parallel is only called by pcrypt_aead_encrypt/decrypt, 
therefore, changing in padata_do_parallel and changing in 
pcrypt_aead_encrypt/decrypt have the same effect. Both should be ok.

Thanks.

Herbert, the two ways look both right. What is your suggestion?

On 2023/9/5 17:45, Steffen Klassert wrote:
> On Mon, Sep 04, 2023 at 01:33:41PM +0000, Lu Jialin wrote:
>> ---
>>   crypto/pcrypt.c | 4 ++++
>>   kernel/padata.c | 2 +-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
>> index 8c1d0ca41213..d0d954fe9d54 100644
>> --- a/crypto/pcrypt.c
>> +++ b/crypto/pcrypt.c
>> @@ -117,6 +117,8 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
>>   	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
>>   	if (!err)
>>   		return -EINPROGRESS;
>> +	if (err == -EBUSY)
>> +		return -EAGAIN;
>>   
>>   	return err;
>>   }
>> @@ -164,6 +166,8 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
>>   	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
>>   	if (!err)
>>   		return -EINPROGRESS;
>> +	if (err == -EBUSY)
>> +		return -EAGAIN;
>>   
>>   	return err;
>>   }
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index 222d60195de6..81c8183f3176 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -202,7 +202,7 @@ int padata_do_parallel(struct padata_shell *ps,
>>   		*cb_cpu = cpu;
>>   	}
>>   
>> -	err =  -EBUSY;
>> +	err = -EBUSY;
> Why not just returning -EAGAIN here directly?
>
>
