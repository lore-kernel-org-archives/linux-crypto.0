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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599E9C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 07:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4028261107
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 07:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbhIWHfy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 03:35:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233089AbhIWHfy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 03:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632382462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O8cUyI9/HMZ0M0mF4x4BdIxxtOl/YPdtt2A3oRUwwgY=;
        b=GvrcOq15WtJ1K0mWErwcDLsUZu2GaqHvO4Y5giOsw9iq2wqSiOOV3FJOK8A0OzZa60A8ri
        O203f7kv80E6sqDwY+cmnjTNm2nJ6mpCCa1/W92VaUnrQ/AV+WKeUD4KXxyp8HCV/hn/9/
        7p/D4GTDPRYFbzzoGVFpWpwKLVj+i78=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-RkWRJWUSOV-s1J_Y3eVJUw-1; Thu, 23 Sep 2021 03:34:21 -0400
X-MC-Unique: RkWRJWUSOV-s1J_Y3eVJUw-1
Received: by mail-wr1-f72.google.com with SMTP id h5-20020a5d6885000000b0015e21e37523so4366536wru.10
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 00:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O8cUyI9/HMZ0M0mF4x4BdIxxtOl/YPdtt2A3oRUwwgY=;
        b=nCQ8liVMkmpDsH2byAAB23OUCTjCUpwUTAYxaKj546mtiDku/6whfrFv/jQMkJeYZY
         PhtAGbvD1/P6l8Yb6pguJzC7OUOkn+4PekVb4vQdlsvUqvuiO1Lyp9S5S8IQF6TtEKuT
         yrkpNj+0yXBKANRoTiphyfDU2gJxQ2nsWZTpAn3UddUbbGdHiGwLBeS8hQ14YzOtmoAe
         jpJye8WHPnNpsbPXcvPto7pxBjjJlYZn4zRMtEwp/wRARUuj/5UQ+Xz41Sozfy/JDmNb
         MyW/G9Z4vrHns2wLuRDzb28FVusB6HJ/rf+lcfH1Xg0RoAmGrMFHycxF0udJHdMwi7Wt
         3eUA==
X-Gm-Message-State: AOAM533EDmF6W6uEV8+zD9fSwgIsjk1tMw0fqHDHeHeOX1SwnNtbMt/B
        mH7kWppJp4YYqr4yrqvwDFcmJanSYfF4EfSf/8aTyGyucmxDVTmdmZiTyZ4nqqQEV/EGK4jRwCS
        +FbcrTpS0etw173lKU+/U/MEZ
X-Received: by 2002:adf:e88e:: with SMTP id d14mr3370965wrm.207.1632382460395;
        Thu, 23 Sep 2021 00:34:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHVpu+hYgQv3Vr9qakA2clcHQvzESskHQMHwX41kpOJMu4ZLSK8S3ymUHXSpW20Q4DX9HJdw==
X-Received: by 2002:adf:e88e:: with SMTP id d14mr3370927wrm.207.1632382460011;
        Thu, 23 Sep 2021 00:34:20 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.21.142])
        by smtp.gmail.com with ESMTPSA id t6sm8021355wmj.12.2021.09.23.00.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 00:34:19 -0700 (PDT)
Message-ID: <fcd17df1-5aed-346b-e7cd-abe4dfb67e69@redhat.com>
Date:   Thu, 23 Sep 2021 09:34:18 +0200
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
 <0dd338bb-0fbe-b9d5-0962-d47ac2de4c4e@redhat.com>
 <20210923030026-mutt-send-email-mst@kernel.org>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20210923030026-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/09/2021 09:04, Michael S. Tsirkin wrote:
> On Thu, Sep 23, 2021 at 08:26:06AM +0200, Laurent Vivier wrote:
>> On 22/09/2021 21:02, Michael S. Tsirkin wrote:
>>> On Wed, Sep 22, 2021 at 07:09:00PM +0200, Laurent Vivier wrote:
>>>> hwrng core uses two buffers that can be mixed in the
>>>> virtio-rng queue.
>>>>
>>>> If the buffer is provided with wait=0 it is enqueued in the
>>>> virtio-rng queue but unused by the caller.
>>>> On the next call, core provides another buffer but the
>>>> first one is filled instead and the new one queued.
>>>> And the caller reads the data from the new one that is not
>>>> updated, and the data in the first one are lost.
>>>>
>>>> To avoid this mix, virtio-rng needs to use its own unique
>>>> internal buffer at a cost of a data copy to the caller buffer.
>>>>
>>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>>> ---
>>>>    drivers/char/hw_random/virtio-rng.c | 43 ++++++++++++++++++++++-------
>>>>    1 file changed, 33 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
>>>> index a90001e02bf7..208c547dcac1 100644
>>>> --- a/drivers/char/hw_random/virtio-rng.c
>>>> +++ b/drivers/char/hw_random/virtio-rng.c
>>>> @@ -18,13 +18,20 @@ static DEFINE_IDA(rng_index_ida);
>>>>    struct virtrng_info {
>>>>    	struct hwrng hwrng;
>>>>    	struct virtqueue *vq;
>>>> -	struct completion have_data;
>>>>    	char name[25];
>>>> -	unsigned int data_avail;
>>>>    	int index;
>>>>    	bool busy;
>>>>    	bool hwrng_register_done;
>>>>    	bool hwrng_removed;
>>>> +	/* data transfer */
>>>> +	struct completion have_data;
>>>> +	unsigned int data_avail;
>>>> +	/* minimal size returned by rng_buffer_size() */
>>>> +#if SMP_CACHE_BYTES < 32
>>>> +	u8 data[32];
>>>> +#else
>>>> +	u8 data[SMP_CACHE_BYTES];
>>>> +#endif
>>>
>>> Let's move this logic to a macro in hw_random.h ?
>>>
>>>>    };
>>>>    static void random_recv_done(struct virtqueue *vq)
>>>> @@ -39,14 +46,14 @@ static void random_recv_done(struct virtqueue *vq)
>>>>    }
>>>>    /* The host will fill any buffer we give it with sweet, sweet randomness. */
>>>> -static void register_buffer(struct virtrng_info *vi, u8 *buf, size_t size)
>>>> +static void register_buffer(struct virtrng_info *vi)
>>>>    {
>>>>    	struct scatterlist sg;
>>>> -	sg_init_one(&sg, buf, size);
>>>> +	sg_init_one(&sg, vi->data, sizeof(vi->data));
>>>
>>> Note that add_early_randomness requests less:
>>>           size_t size = min_t(size_t, 16, rng_buffer_size());
>>>
>>> maybe track how much was requested and grow up to sizeof(data)?
>>
>> I think this problem is managed by PATCH 3/4 as we reuse unused data of the buffer.
> 
> the issue I'm pointing out is that we are requesting too much
> entropy from host - more than guest needs.

Yes, guest asks for 16 bytes, but we request SMP_CACHE_BYTES (64 on x86_64), and these 16 
bytes are used with add_device_randomness(). With the following patches, the remaining 48 
bytes are used rapidly by hwgnd kthread or by the next virtio_read.

If there is no enough entropy the call is simply ignored as wait=0.

At this patch level the call is always simply ignored (because wait=0) and the data 
requested here are used by the next read that always asks for a SMP_CACHE_BYTES bytes data 
size.

Moreover in PATCH 4/4 we always have a pending request of size SMP_CACHE_BYTES, so driver 
always asks a block of this size and the guest takes what it needs.

Originally I used a 16 bytes block but performance are divided by 4.

Do you propose something else?

Thanks,
Laurent

