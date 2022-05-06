Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660F5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 09:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390648AbiEFKDM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 06:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358846AbiEFKDK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 06:03:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40294754F
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 02:59:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 204so3064240pfx.3
        for <linux-crypto@vger.kernel.org>; Fri, 06 May 2022 02:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qkYBPtwwXh8wrjml5xjZWpmnyYJc8bz2oezaS0TP4h4=;
        b=yhN7HQkibzNKkcborAKfIJZ1+KFI5v7ka0JP/YFaO15M7iM5JCX3y28qvb6yrz1Qm+
         tsZzBSDZERZUoFnpycq2P8Gv8LylAFM5wybHMOsa26wbefo5t8aY5EF7nPp4hBwBGoKJ
         WeaxwleR2hasu1mCnXJ1eHbEprtWOiowLkefXtZGcDB8f+Yb6LwivSXUXWG85ve/qV9d
         RnGIzxJq40E9JIQsAjAIucr3YNMxnBfLL23bvh5Gr6zC5dU/CMeP49CeUEiTNfFktIZN
         xUve1G3ty7FkdL2P7bww2ONlixR4c/z1MErH2hnRyOVQicRhg5a00l+OEfpFrGLzkyeK
         T43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qkYBPtwwXh8wrjml5xjZWpmnyYJc8bz2oezaS0TP4h4=;
        b=XASp2r6uDfPuZAoMunzGjZfIE6ST8Ltuu1byXmluFvs0nYaJxLSRj6BS52fKIiax8i
         oYUFf3Bj3n8eLLBzsOyQ9bcUh8tM3zz6KdsGzwucf6aFN6R/jRH+DrOB+/2vvIZQjEI0
         ijf0zBP7sIjyXqz0CEeFCisbyle39dGV8L6KCtJQAelnVRsnRa4jJivlmrBJz2iJUClS
         uh6HHWYWGJNAepsGfe11k73uJKWw+PMMbpyly4bC2lFOOOoVenb8+jn1xnxmmSHdYHbw
         bwwc4PASBqjhhkXZqgeUXSEdy3MvqHmapU6Z2SQS621yQzF9LW4mBKKS/AbcxAigIDCU
         pM8A==
X-Gm-Message-State: AOAM533XFnNppjnCz0cNc9jAmbONW16w2XfAWZ17Cds1RmWojQjhxKcG
        PDLJXBTC3eCCUyUTqAy4wVvQ34XmaCCN4g==
X-Google-Smtp-Source: ABdhPJx1UzxZt5oKWOW8EfeuMSxPFYdmNFuHrO7gIAc3jSJG3YfatOtyNZDK/sM/J50XFzYZ7hQiig==
X-Received: by 2002:a65:615a:0:b0:3a9:f4ad:68a8 with SMTP id o26-20020a65615a000000b003a9f4ad68a8mr2168328pgv.108.1651831167259;
        Fri, 06 May 2022 02:59:27 -0700 (PDT)
Received: from [10.255.89.252] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d26c7d5aacsm3300603pjb.13.2022.05.06.02.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 02:59:26 -0700 (PDT)
Message-ID: <48c9b073-0b03-5769-633b-5b668cea6fa4@bytedance.com>
Date:   Fri, 6 May 2022 17:55:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: RE: [PATCH v5 5/5] virtio-crypto: enable retry for
 virtio-crypto-dev
Content-Language: en-US
To:     "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20220505092408.53692-1-pizhenwei@bytedance.com>
 <20220505092408.53692-6-pizhenwei@bytedance.com>
 <ad61b1ae4bd145eaa18fc28696e9502a@huawei.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <ad61b1ae4bd145eaa18fc28696e9502a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/6/22 17:34, Gonglei (Arei) wrote:
> 
> 
>> -----Original Message-----
>> From: zhenwei pi [mailto:pizhenwei@bytedance.com]
>> Sent: Thursday, May 5, 2022 5:24 PM
>> To: Gonglei (Arei) <arei.gonglei@huawei.com>; mst@redhat.com
>> Cc: jasowang@redhat.com; herbert@gondor.apana.org.au;
>> linux-kernel@vger.kernel.org; virtualization@lists.linux-foundation.org;
>> linux-crypto@vger.kernel.org; helei.sig11@bytedance.com;
>> pizhenwei@bytedance.com; davem@davemloft.net
>> Subject: [PATCH v5 5/5] virtio-crypto: enable retry for virtio-crypto-dev
>>
>> From: lei he <helei.sig11@bytedance.com>
>>
>> Enable retry for virtio-crypto-dev, so that crypto-engine can process
>> cipher-requests parallelly.
>>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Cc: Gonglei <arei.gonglei@huawei.com>
>> Signed-off-by: lei he <helei.sig11@bytedance.com>
>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>> ---
>>   drivers/crypto/virtio/virtio_crypto_core.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c
>> b/drivers/crypto/virtio/virtio_crypto_core.c
>> index 60490ffa3df1..f67e0d4c1b0c 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_core.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
>> @@ -144,7 +144,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
>>   		spin_lock_init(&vi->data_vq[i].lock);
>>   		vi->data_vq[i].vq = vqs[i];
>>   		/* Initialize crypto engine */
>> -		vi->data_vq[i].engine = crypto_engine_alloc_init(dev, 1);
>> +		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true,
>> NULL, 1,
>> +						virtqueue_get_vring_size(vqs[i]));
> 
> Here the '1' can be 'true' too.
> 
> Sure, you can add
> 
> Reviewed-by: Gonglei <arei.gonglei@huawei.com>
> 
> Regards,
> -Gonglei
> 
>>   		if (!vi->data_vq[i].engine) {
>>   			ret = -ENOMEM;
>>   			goto err_engine;
>> --
>> 2.20.1
> 

Thanks to Lei!

Hi, Michael
I would appreciate it if you could apply this minor change, or I send 
the v6 series, which one do you prefer?

-- 
zhenwei pi
