Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58E5C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 07:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF5120704
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 07:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEZHVS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 03:21:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5282 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726768AbgEZHVR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 03:21:17 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2A7C01AD7E6CF8F5A02A;
        Tue, 26 May 2020 15:21:16 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.208) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 26 May
 2020 15:21:06 +0800
Subject: Re: [PATCH v2 1/2] crypto: virtio: Fix src/dst scatterlist
 calculation in __virtio_crypto_skcipher_do_req()
To:     Markus Elfring <Markus.Elfring@web.de>,
        <linux-crypto@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Gonglei <arei.gonglei@huawei.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-2-longpeng2@huawei.com>
 <d58a046a-e559-55be-16ba-64db43a06568@web.de>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <e1864c6d-6380-831f-9c2f-85611a78779b@huawei.com>
Date:   Tue, 26 May 2020 15:21:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d58a046a-e559-55be-16ba-64db43a06568@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Markus,

On 2020/5/26 15:03, Markus Elfring wrote:
>> Fix it by sg_next() on calculation of src/dst scatterlist.
> 
> Wording adjustment:
> … by calling the function “sg_next” …
> 
OK, thanks.

> 
> …
>> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
>> @@ -350,13 +350,18 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
> …
>>  	src_nents = sg_nents_for_len(req->src, req->cryptlen);
>> +	if (src_nents < 0) {
>> +		pr_err("Invalid number of src SG.\n");
>> +		return src_nents;
>> +	}
>> +
>>  	dst_nents = sg_nents(req->dst);
> …
> 
> I suggest to move the addition of such input parameter validation
> to a separate update step.
> 
Um...The 'src_nents' will be used as a loop condition, so validate it here is
needed ?

'''
 	/* Source data */
-	for (i = 0; i < src_nents; i++)
-		sgs[num_out++] = &req->src[i];
+	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
+		sgs[num_out++] = sg;
'''

> Regards,
> Markus
> 

-- 
---
Regards,
Longpeng(Mike)
