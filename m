Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F45C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 06:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A826109E
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 06:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbhIWG1o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 02:27:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239284AbhIWG1o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 02:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632378372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71fUOImGUODDyJCOfZ+X9xPf/a4pfZ4Afxj/CEjfaLk=;
        b=f6E8+MZIipTbD+3Ktb52dY80XXvlvWG3EkANabixyf8aF0Pw2vU4Ql0vuRGTWyIlsVyaK/
        jxyUObYbJ7+ZVMZN52by4bFVokJZgJd08fDTGrE4T60nl02I/a645T6JircL2I/I9xHRQN
        gafOgpmeSiSmEKexlUUSiMRhQk78otE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-AWU2ZR3VPbySghOIUnuHUg-1; Thu, 23 Sep 2021 02:26:11 -0400
X-MC-Unique: AWU2ZR3VPbySghOIUnuHUg-1
Received: by mail-wr1-f71.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so4248049wrv.6
        for <linux-crypto@vger.kernel.org>; Wed, 22 Sep 2021 23:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=71fUOImGUODDyJCOfZ+X9xPf/a4pfZ4Afxj/CEjfaLk=;
        b=0bBDqwVPAtGyNSYWdK46yqrKVazUU2JMaAzSFOpT1bve7rcL2gRhkNABalPOWSVPCA
         h1NAbpz39x5qvxhvXYC9yDytla9Nb2txUj26ITcJRJjN4sYdarXU7xIAtgCarB3ptPWR
         Fv1zVvda5NZk8//lWkphnKN7GbT4Yt7o/AZlNHtdRWgxEgsE9eCIdbXBFIA2BxWLEa6f
         71iq9HZxpajPQBFIkea5XzfmENXD1ZSofgpixbrHkSOvF5GXfxjZ6e0424m0uMqNL8Py
         sDS8NQu3y4KukuiSWx41GKJREBMK7HC9/xWGrI024kXbGgr/khNjgKtHrSB0QXxb9m5R
         hpLQ==
X-Gm-Message-State: AOAM533id5HEVc7moHu6pLZvCVYkw/r/l3HPlXIu4XCJJwjlOnNJh7Wq
        PnmahGYc27o1tMOCuRCFdAMh7vxwgV/qAkxGgLcra4yQiDjIMr+akt48tCZ3rvSTnV+wciYjb5C
        Y6/7tuaMg8HgK7kk59u9jKOUf
X-Received: by 2002:a05:600c:35d2:: with SMTP id r18mr14004169wmq.97.1632378369831;
        Wed, 22 Sep 2021 23:26:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/DaTIZtdSS0b0eqh6Dbu9+P7YRuw+Cv3OyT69GeFyi7+s2AXNgBTjbFRA58JrR83WfyjtAw==
X-Received: by 2002:a05:600c:35d2:: with SMTP id r18mr14004142wmq.97.1632378369633;
        Wed, 22 Sep 2021 23:26:09 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.21.142])
        by smtp.gmail.com with ESMTPSA id v20sm4386301wra.73.2021.09.22.23.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 23:26:08 -0700 (PDT)
Message-ID: <0dd338bb-0fbe-b9d5-0962-d47ac2de4c4e@redhat.com>
Date:   Thu, 23 Sep 2021 08:26:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/4] hwrng: virtio - add an internal buffer
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Dmitriy Vyukov <dvyukov@google.com>,
        rusty@rustcorp.com.au, amit@kernel.org, akong@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org
References: <20210922170903.577801-1-lvivier@redhat.com>
 <20210922170903.577801-2-lvivier@redhat.com>
 <20210922145651-mutt-send-email-mst@kernel.org>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20210922145651-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/09/2021 21:02, Michael S. Tsirkin wrote:
> On Wed, Sep 22, 2021 at 07:09:00PM +0200, Laurent Vivier wrote:
>> hwrng core uses two buffers that can be mixed in the
>> virtio-rng queue.
>>
>> If the buffer is provided with wait=0 it is enqueued in the
>> virtio-rng queue but unused by the caller.
>> On the next call, core provides another buffer but the
>> first one is filled instead and the new one queued.
>> And the caller reads the data from the new one that is not
>> updated, and the data in the first one are lost.
>>
>> To avoid this mix, virtio-rng needs to use its own unique
>> internal buffer at a cost of a data copy to the caller buffer.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>   drivers/char/hw_random/virtio-rng.c | 43 ++++++++++++++++++++++-------
>>   1 file changed, 33 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
>> index a90001e02bf7..208c547dcac1 100644
>> --- a/drivers/char/hw_random/virtio-rng.c
>> +++ b/drivers/char/hw_random/virtio-rng.c
>> @@ -18,13 +18,20 @@ static DEFINE_IDA(rng_index_ida);
>>   struct virtrng_info {
>>   	struct hwrng hwrng;
>>   	struct virtqueue *vq;
>> -	struct completion have_data;
>>   	char name[25];
>> -	unsigned int data_avail;
>>   	int index;
>>   	bool busy;
>>   	bool hwrng_register_done;
>>   	bool hwrng_removed;
>> +	/* data transfer */
>> +	struct completion have_data;
>> +	unsigned int data_avail;
>> +	/* minimal size returned by rng_buffer_size() */
>> +#if SMP_CACHE_BYTES < 32
>> +	u8 data[32];
>> +#else
>> +	u8 data[SMP_CACHE_BYTES];
>> +#endif
> 
> Let's move this logic to a macro in hw_random.h ?
> 
>>   };
>>   
>>   static void random_recv_done(struct virtqueue *vq)
>> @@ -39,14 +46,14 @@ static void random_recv_done(struct virtqueue *vq)
>>   }
>>   
>>   /* The host will fill any buffer we give it with sweet, sweet randomness. */
>> -static void register_buffer(struct virtrng_info *vi, u8 *buf, size_t size)
>> +static void register_buffer(struct virtrng_info *vi)
>>   {
>>   	struct scatterlist sg;
>>   
>> -	sg_init_one(&sg, buf, size);
>> +	sg_init_one(&sg, vi->data, sizeof(vi->data));
> 
> Note that add_early_randomness requests less:
>          size_t size = min_t(size_t, 16, rng_buffer_size());
> 
> maybe track how much was requested and grow up to sizeof(data)?

I think this problem is managed by PATCH 3/4 as we reuse unused data of the buffer.

> 
>>   
>>   	/* There should always be room for one buffer. */
>> -	virtqueue_add_inbuf(vi->vq, &sg, 1, buf, GFP_KERNEL);
>> +	virtqueue_add_inbuf(vi->vq, &sg, 1, vi->data, GFP_KERNEL);
> 
> 
> BTW no longer true if DMA API is in use ... not easy to fix,
> I think some changes to virtio API to allow pre-mapping
> s/g for DMA might be needed ...

Is there something I can do here?

Thanks,
Laurent

