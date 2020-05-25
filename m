Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B07C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 03:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24CC2075F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 03:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgEYDpi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 May 2020 23:45:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5276 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388211AbgEYDpi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 May 2020 23:45:38 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 55077FD852DCAC4B1805;
        Mon, 25 May 2020 11:45:32 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.204) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 25 May
 2020 11:45:24 +0800
Subject: Re: [PATCH 1/2] crypto: virtio: fix src/dst scatterlist calculation
To:     Jason Wang <jasowang@redhat.com>, <linux-crypto@vger.kernel.org>
CC:     Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        LABBE Corentin <clabbe@baylibre.com>
References: <20200525005627.707-1-longpeng2@huawei.com>
 <20200525005627.707-2-longpeng2@huawei.com>
 <25cff618-601c-e899-a3cc-b289863a7407@redhat.com>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <bd31398c-e81b-993f-99ae-37dc364b0e40@huawei.com>
Date:   Mon, 25 May 2020 11:45:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <25cff618-601c-e899-a3cc-b289863a7407@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On 2020/5/25 11:12, Jason Wang wrote:
> 
> On 2020/5/25 上午8:56, Longpeng(Mike) wrote:
>> The system will crash when we insmod crypto/tcrypt.ko whit mode=38.
>>
>> Usually the next entry of one sg will be @sg@ + 1, but if this sg element
>> is part of a chained scatterlist, it could jump to the start of a new
>> scatterlist array. Let's fix it by sg_next() on calculation of src/dst
>> scatterlist.
>>
>> BTW I add a check for sg_nents_for_len() its return value since
>> sg_nents_for_len() function could fail.
>>
>> Cc: Gonglei <arei.gonglei@huawei.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: virtualization@lists.linux-foundation.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> Reported-by: LABBE Corentin <clabbe@baylibre.com>
>> Signed-off-by: Gonglei <arei.gonglei@huawei.com>
>> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>> ---
>>   drivers/crypto/virtio/virtio_crypto_algs.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c
>> b/drivers/crypto/virtio/virtio_crypto_algs.c
>> index 372babb44112..2fa1129f96d6 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_algs.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
>> @@ -359,8 +359,14 @@ __virtio_crypto_skcipher_do_req(struct
>> virtio_crypto_sym_request *vc_sym_req,
>>       unsigned int num_out = 0, num_in = 0;
>>       int sg_total;
>>       uint8_t *iv;
>> +    struct scatterlist *sg;
>>         src_nents = sg_nents_for_len(req->src, req->cryptlen);
>> +    if (src_nents < 0) {
>> +        pr_err("Invalid number of src SG.\n");
>> +        return src_nents;
>> +    }
>> +
>>       dst_nents = sg_nents(req->dst);
>>         pr_debug("virtio_crypto: Number of sgs (src_nents: %d, dst_nents: %d)\n",
>> @@ -446,12 +452,12 @@ __virtio_crypto_skcipher_do_req(struct
>> virtio_crypto_sym_request *vc_sym_req,
>>       vc_sym_req->iv = iv;
>>         /* Source data */
>> -    for (i = 0; i < src_nents; i++)
>> -        sgs[num_out++] = &req->src[i];
>> +    for (sg = req->src, i = 0; sg && i < src_nents; sg = sg_next(sg), i++)
> 
> 
> Any reason sg is checked here?
> 
> I believe it should be checked in sg_nents_for_len().
> 
Do you means：
for (sg = req->src, i = 0; i < src_nents; sg = sg_next(sg), i++) ?

> 
>> +        sgs[num_out++] = sg;
>>         /* Destination data */
>> -    for (i = 0; i < dst_nents; i++)
>> -        sgs[num_out + num_in++] = &req->dst[i];
>> +    for (sg = req->dst, i = 0; sg && i < dst_nents; sg = sg_next(sg), i++)
>> +        sgs[num_out + num_in++] = sg;
> 
> 
> I believe sg should be checked in sg_nents().
>
How about
for (sg = req->dst; sg; sg = sg_next(sg)) ?

> Thanks
> 
> 
>>         /* Status */
>>       sg_init_one(&status_sg, &vc_req->status, sizeof(vc_req->status));
> 
> .
> 

-- 
---
Regards,
Longpeng(Mike)
