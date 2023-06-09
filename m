Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AEEC7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 13:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbjFINuA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbjFINtu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 09:49:50 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C86018D;
        Fri,  9 Jun 2023 06:49:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0VkiId6T_1686318579;
Received: from 30.236.10.144(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VkiId6T_1686318579)
          by smtp.aliyun-inc.com;
          Fri, 09 Jun 2023 21:49:41 +0800
Message-ID: <91aa6ce0-e8a3-21ac-d29e-b2a47f6386d1@linux.alibaba.com>
Date:   Fri, 9 Jun 2023 21:49:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] virtio-crypto: fixup potential cpu stall when free
 unused bufs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@alibaba-inc.com>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
 <2023060924-skinning-reset-e256@gregkh>
 <2023060940-wrongdoer-wince-5701@gregkh>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
In-Reply-To: <2023060940-wrongdoer-wince-5701@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


在 2023/6/9 下午9:41, Greg KH 写道:
> On Fri, Jun 09, 2023 at 03:39:24PM +0200, Greg KH wrote:
>> On Fri, Jun 09, 2023 at 09:18:15PM +0800, Xianting Tian wrote:
>>> From: Xianting Tian <tianxianting.txt@alibaba-inc.com>
>>>
>>> Cpu stall issue may happen if device is configured with multi queues
>>> and large queue depth, so fix it.
>>>
>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>> ---
>>>   drivers/crypto/virtio/virtio_crypto_core.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
>>> index 1198bd306365..94849fa3bd74 100644
>>> --- a/drivers/crypto/virtio/virtio_crypto_core.c
>>> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
>>> @@ -480,6 +480,7 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
>>>   			kfree(vc_req->req_data);
>>>   			kfree(vc_req->sgs);
>>>   		}
>>> +		cond_resched();
>> that's not "fixing a stall", it is "call the scheduler because we are
>> taking too long".  The CPU isn't stalled at all, just busy.
>>
>> Are you sure this isn't just a bug in the code?  Why is this code taking
>> so long that you have to force the scheduler to run?  This is almost
>> always a sign that something else needs to be fixed instead.
> And same comment on the other 2 patches, please fix this properly.
>
> Also, this is a tight loop that is just freeing memory, why is it taking
> so long?  Why do you want it to take longer (which is what you are doing
> here), ideally it would be faster, not slower, so you are now slowing
> down the system overall with this patchset, right?

yes, it is the similar fix with one for virtio-net

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/virtio_net.c?h=v6.4-rc5&id=f8bb5104394560e29017c25bcade4c6b7aabd108 
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/virtio_net.c?h=v6.4-rc5&id=f8bb5104394560e29017c25bcade4c6b7aabd108>

>
> thanks,
>
> greg k-h
