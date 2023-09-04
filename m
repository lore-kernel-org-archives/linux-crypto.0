Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9067AC83F2C
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Sep 2023 06:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352385AbjIDG6n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Sep 2023 02:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345038AbjIDG6n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Sep 2023 02:58:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D053F11A
        for <linux-crypto@vger.kernel.org>; Sun,  3 Sep 2023 23:58:39 -0700 (PDT)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RfKBn683PzNmNM;
        Mon,  4 Sep 2023 14:54:57 +0800 (CST)
Received: from [10.67.109.150] (10.67.109.150) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 4 Sep 2023 14:58:36 +0800
Message-ID: <0a324e7d-2edc-0dda-d902-087e90191525@huawei.com>
Date:   Mon, 4 Sep 2023 14:58:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: Fix hungtask for PADATA_RESET
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "Guozihua (Scott)" <guozihua@huawei.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <20230823073047.1515137-1-lujialin4@huawei.com>
 <ZOXRNntcDBuuJ2yg@gondor.apana.org.au>
 <c9b91a0c-5663-c351-3d4b-ad4ff74965f2@huawei.com>
 <ZPVtyXevpj4Fiduw@gauss3.secunet.de>
Content-Language: en-US
From:   Lu Jialin <lujialin4@huawei.com>
In-Reply-To: <ZPVtyXevpj4Fiduw@gauss3.secunet.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.150]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for your suggestion. I will update the patch and remove retry in v3.

On 2023/9/4 13:40, Steffen Klassert wrote:
> On Fri, Sep 01, 2023 at 10:28:08AM +0800, Guozihua (Scott) wrote:
>> On 2023/8/23 17:28, Herbert Xu wrote:
>>> On Wed, Aug 23, 2023 at 07:30:47AM +0000, Lu Jialin wrote:
>>>>
>>>> In order to resolve the problem, we retry at most 5 times when
>>>> padata_do_parallel return -EBUSY. For more than 5 times, we replace the
>>>> return err -EBUSY with -EAGAIN, which means parallel_data is changing, and
>>>> the caller should call it again.
>>>
>>> Steffen, should we retry this at all? Or should it just fail as it
>>> did before?
>>>
>>> Thanks,
>>
>> It should be fine if we don't retry and just fail with -EAGAIN and let
>> caller handles it. It should not break the meaning of the error code.
> 
> Just failing without a retry should be ok.
> 
