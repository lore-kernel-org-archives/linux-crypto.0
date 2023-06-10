Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4890EC7EE25
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 03:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjFJDTM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 23:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjFJDTL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 23:19:11 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55548E1;
        Fri,  9 Jun 2023 20:19:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VkjxUgb_1686367143;
Received: from 30.13.188.136(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VkjxUgb_1686367143)
          by smtp.aliyun-inc.com;
          Sat, 10 Jun 2023 11:19:05 +0800
Message-ID: <5149dde8-b6b2-e720-2e32-5c79684a99db@linux.alibaba.com>
Date:   Sat, 10 Jun 2023 11:19:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] virtio_console: fixup potential cpu stall when free
 unused bufs
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-3-xianting.tian@linux.alibaba.com>
 <20230609120332-mutt-send-email-mst@kernel.org>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
In-Reply-To: <20230609120332-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


在 2023/6/10 上午12:05, Michael S. Tsirkin 写道:
> On Fri, Jun 09, 2023 at 09:18:16PM +0800, Xianting Tian wrote:
>> Cpu stall issue may happen if device is configured with multi queues
>> and large queue depth, so fix it.
> "may happen" is ambigous.
>
> So is this: "for virtio-net we were getting
> stall on CPU was observed message, this driver is similar
> so theoretically the same logic applies"

It is this one

  “this driver is similar so theoretically the same logic applies”

>
> or is this
>
> "the following error occured: ....."
>
> ?
>
>
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   drivers/char/virtio_console.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
>> index b65c809a4e97..5ec4cf4ea919 100644
>> --- a/drivers/char/virtio_console.c
>> +++ b/drivers/char/virtio_console.c
>> @@ -1935,6 +1935,7 @@ static void remove_vqs(struct ports_device *portdev)
>>   		flush_bufs(vq, true);
>>   		while ((buf = virtqueue_detach_unused_buf(vq)))
>>   			free_buf(buf, true);
>> +		cond_resched();
>>   	}
>>   	portdev->vdev->config->del_vqs(portdev->vdev);
>>   	kfree(portdev->in_vqs);
>> -- 
>> 2.17.1
