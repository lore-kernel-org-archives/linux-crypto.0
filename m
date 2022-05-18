Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44297C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 01:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiERBBN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 May 2022 21:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiERBBF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 May 2022 21:01:05 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485093465B;
        Tue, 17 May 2022 18:01:02 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L2vmT1ljWzhZ8Z;
        Wed, 18 May 2022 09:00:25 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 09:01:00 +0800
Message-ID: <33dbb913-821c-e5a3-a7db-ac055baa69f8@huawei.com>
Date:   Wed, 18 May 2022 09:01:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] crypto: Use struct_size() helper in kmalloc()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <davem@davemloft.net>, <dhowells@redhat.com>,
        <herbert@gondor.apana.org.au>, <gustavoars@kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <20220517080532.31015-1-guozihua@huawei.com>
 <202205171424.CF36CE58@keescook>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <202205171424.CF36CE58@keescook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/5/18 5:26, Kees Cook wrote:
> On Tue, May 17, 2022 at 04:05:32PM +0800, GUO Zihua wrote:
>> Make use of struct_size() heler for structures containing flexible array
>> member instead of sizeof() which prevents potential issues as well as
>> addressing the following sparse warning:
>>
>> crypto/asymmetric_keys/asymmetric_type.c:155:23: warning: using sizeof
>> on a flexible structure
>> crypto/asymmetric_keys/asymmetric_type.c:247:28: warning: using sizeof
>> on a flexible structure
>>
>> Reference: https://github.com/KSPP/linux/issues/174
>>
>> Signed-off-by: GUO Zihua <guozihua@huawei.com>
>> ---
>>   crypto/asymmetric_keys/asymmetric_type.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
>> index 41a2f0eb4ce4..96a99a91bf17 100644
>> --- a/crypto/asymmetric_keys/asymmetric_type.c
>> +++ b/crypto/asymmetric_keys/asymmetric_type.c
>> @@ -152,7 +152,7 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
>>   {
>>   	struct asymmetric_key_id *kid;
>>   
>> -	kid = kmalloc(sizeof(struct asymmetric_key_id) + len_1 + len_2,
>> +	kid = kmalloc(struct_size(kid, data, len_1 + len_2),
> 
> Please use the size_add() helper for this open-coded add here.
> 
>>   		      GFP_KERNEL);
>>   	if (!kid)
>>   		return ERR_PTR(-ENOMEM);
>> @@ -244,7 +244,7 @@ struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
>>   	if (asciihexlen & 1)
>>   		return ERR_PTR(-EINVAL);
>>   
>> -	match_id = kmalloc(sizeof(struct asymmetric_key_id) + asciihexlen / 2,
>> +	match_id = kmalloc(struct_size(match_id, data, asciihexlen / 2),
> 
> There is no size_div(), but that's ok here because the denominator is an
> constant expression.
> 
>>   			   GFP_KERNEL);
>>   	if (!match_id)
>>   		return ERR_PTR(-ENOMEM);
>> -- 
>> 2.36.0
>>
> 

Thanks Kees,

A v2 patch has been submitted.

-- 
Best
GUO Zihua
