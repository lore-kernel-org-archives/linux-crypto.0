Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C5EC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Apr 2022 08:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389290AbiDVIj2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Apr 2022 04:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiDVIjY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Apr 2022 04:39:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC5F344FD
        for <linux-crypto@vger.kernel.org>; Fri, 22 Apr 2022 01:36:31 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t12so9353895pll.7
        for <linux-crypto@vger.kernel.org>; Fri, 22 Apr 2022 01:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2ZaF+7x5j8EGvfZR/hPJBSSFpx+zcdUd34wqFnAI3iY=;
        b=ucLp03ZekVES5pEcDMCxraT9TPuUq7R2oEVpMoIUWh6/+793pL+TrNflIJUbnI8UIu
         tlDRDTXScif4ivk2JdkQvfdGtavOIDD/Zih09FBsu83DDO83LFziejuhUnJ40W1Q825b
         oiCa0Omb364J8rMS96Et8ckM9yIQ5ik2AVokH0wpV5099iPETLKftnZmUog6XewuF1Lb
         KYo2repqF1JT7Qx5iIPEZfPARwkTew5B9MmBPpr3kwzpgSPHhTSCrYTncbjwZD9dUYs5
         GDA3ay7dXu4j5maDdkPCDyCCLwc8YfQal4w6V0g8TdojxsRwKtz4rUkze3K1meZNq9vB
         g1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ZaF+7x5j8EGvfZR/hPJBSSFpx+zcdUd34wqFnAI3iY=;
        b=FexTsAvCOmsqr7VZ/j7HsRSThm/ouIC2kWS7cWUHCKJypAps09EeDENAdgztG3CB7O
         SotkN7h3eDOWfgeomnp2rm+RY5y8ZHvm9neul3kpR8VRGAEf+MxpE2CZUH8TiC3JilUs
         oJ922k81zWK/ivnBDVUEaF+3uP4vJUKxkJDsJBX0Y3PczBTWdCVBgbaxTUyLw0+v/rXM
         D9fyWamzYv9IoRnRb0f+fD8J1/Dy+ZHVXOk8cwZH8jgc6OedbgCsaSve6Nm3p5S8DTE2
         8Z+qvR4cFib2TFO+kZ84YVmA3NGtGsqhdyDCvNLH6gTqHF2HU6U6u2+0tfV3vBWvSlH2
         7XrQ==
X-Gm-Message-State: AOAM532PfPifVB6m6yRJwfcYJJhuDRQ8gZz8zuEd6h7L2K8O7GpPFQiv
        2QQPmYVpo7f85+/fCUY2WpwwZw==
X-Google-Smtp-Source: ABdhPJxQLmaE8ktG45aZc7K3QwdXs61JjeSeX95gRatX5MpKUH7CX/ljXEirzTbLsYZ/Bb9JD10qcQ==
X-Received: by 2002:a17:902:ef46:b0:153:81f7:7fc2 with SMTP id e6-20020a170902ef4600b0015381f77fc2mr3551999plx.26.1650616590806;
        Fri, 22 Apr 2022 01:36:30 -0700 (PDT)
Received: from [10.76.15.169] ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm1830537pfk.88.2022.04.22.01.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 01:36:30 -0700 (PDT)
Message-ID: <67690268-0bd9-688e-8bf1-8df28351682e@bytedance.com>
Date:   Fri, 22 Apr 2022 16:32:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Re: [PATCH v3 2/5] virtio-crypto: wait ctrl queue instead of busy
 polling
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, arei.gonglei@huawei.com,
        mst@redhat.com
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net
References: <20220421104016.453458-1-pizhenwei@bytedance.com>
 <20220421104016.453458-3-pizhenwei@bytedance.com>
 <0cac99a6-8479-394b-4a0e-32df7c8af8d7@redhat.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <0cac99a6-8479-394b-4a0e-32df7c8af8d7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/22/22 15:46, Jason Wang wrote:
> 
> 在 2022/4/21 18:40, zhenwei pi 写道:
>> Originally, after submitting request into virtio crypto control
>> queue, the guest side polls the result from the virt queue. This
>> works like following:
>>      CPU0   CPU1               ...             CPUx  CPUy
>>       |      |                                  |     |
>>       \      \                                  /     /
>>        \--------spin_lock(&vcrypto->ctrl_lock)-------/
>>                             |
>>                   virtqueue add & kick
>>                             |
>>                    busy poll virtqueue
>>                             |
>>                spin_unlock(&vcrypto->ctrl_lock)
>>                            ...
>>
>> There are two problems:
>> 1, The queue depth is always 1, the performance of a virtio crypto
>>     device gets limited. Multi user processes share a single control
>>     queue, and hit spin lock race from control queue. Test on Intel
>>     Platinum 8260, a single worker gets ~35K/s create/close session
>>     operations, and 8 workers get ~40K/s operations with 800% CPU
>>     utilization.
>> 2, The control request is supposed to get handled immediately, but
>>     in the current implementation of QEMU(v6.2), the vCPU thread kicks
>>     another thread to do this work, the latency also gets unstable.
>>     Tracking latency of virtio_crypto_alg_akcipher_close_session in 5s:
>>          usecs               : count     distribution
>>           0 -> 1          : 0        |                        |
>>           2 -> 3          : 7        |                        |
>>           4 -> 7          : 72       |                        |
>>           8 -> 15         : 186485   |************************|
>>          16 -> 31         : 687      |                        |
>>          32 -> 63         : 5        |                        |
>>          64 -> 127        : 3        |                        |
>>         128 -> 255        : 1        |                        |
>>         256 -> 511        : 0        |                        |
>>         512 -> 1023       : 0        |                        |
>>        1024 -> 2047       : 0        |                        |
>>        2048 -> 4095       : 0        |                        |
>>        4096 -> 8191       : 0        |                        |
>>        8192 -> 16383      : 2        |                        |
>>     This means that a CPU may hold vcrypto->ctrl_lock as long as 
>> 8192~16383us.
>>
>> To improve the performance of control queue, a request on control 
>> queue waits
>> completion instead of busy polling to reduce lock racing, and gets 
>> completed by
>> control queue callback.
>>      CPU0   CPU1               ...             CPUx  CPUy
>>       |      |                                  |     |
>>       \      \                                  /     /
>>        \--------spin_lock(&vcrypto->ctrl_lock)-------/
>>                             |
>>                   virtqueue add & kick
>>                             |
>>        ---------spin_unlock(&vcrypto->ctrl_lock)------
>>       /      /                                  \     \
>>       |      |                                  |     |
>>      wait   wait                               wait  wait
>>
>> Test this patch, the guest side get ~200K/s operations with 300% CPU
>> utilization.
>>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Cc: Gonglei <arei.gonglei@huawei.com>
>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>> ---
>>   drivers/crypto/virtio/virtio_crypto_common.c | 42 +++++++++++++++-----
>>   drivers/crypto/virtio/virtio_crypto_common.h |  8 ++++
>>   drivers/crypto/virtio/virtio_crypto_core.c   |  2 +-
>>   3 files changed, 41 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/crypto/virtio/virtio_crypto_common.c 
>> b/drivers/crypto/virtio/virtio_crypto_common.c
>> index e65125a74db2..93df73c40dd3 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_common.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_common.c
>> @@ -8,14 +8,21 @@
>>   #include "virtio_crypto_common.h"
>> +static void virtio_crypto_ctrlq_callback(struct 
>> virtio_crypto_ctrl_request *vc_ctrl_req)
>> +{
>> +    complete(&vc_ctrl_req->compl);
>> +}
>> +
>>   int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, 
>> struct scatterlist *sgs[],
>>                     unsigned int out_sgs, unsigned int in_sgs,
>>                     struct virtio_crypto_ctrl_request *vc_ctrl_req)
>>   {
>>       int err;
>> -    unsigned int inlen;
>>       unsigned long flags;
>> +    init_completion(&vc_ctrl_req->compl);
>> +    vc_ctrl_req->ctrl_cb =  virtio_crypto_ctrlq_callback;
> 
> 
> Is there a chance that the cb would not be virtio_crypto_ctrlq_callback()?
> 

Yes, it's the only callback function used for control queue, removing 
this and calling virtio_crypto_ctrlq_callback directly in 
virtcrypto_ctrlq_callback seems better. I'll fix this in the next version.
> 
>> +
>>       spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
>>       err = virtqueue_add_sgs(vcrypto->ctrl_vq, sgs, out_sgs, in_sgs, 
>> vc_ctrl_req, GFP_ATOMIC);
>>       if (err < 0) {
>> @@ -24,16 +31,31 @@ int virtio_crypto_ctrl_vq_request(struct 
>> virtio_crypto *vcrypto, struct scatterl
>>       }
>>       virtqueue_kick(vcrypto->ctrl_vq);
>> -
>> -    /*
>> -     * Trapping into the hypervisor, so the request should be
>> -     * handled immediately.
>> -     */
>> -    while (!virtqueue_get_buf(vcrypto->ctrl_vq, &inlen) &&
>> -        !virtqueue_is_broken(vcrypto->ctrl_vq))
>> -        cpu_relax();
>> -
>>       spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
>> +    wait_for_completion(&vc_ctrl_req->compl);
>> +
>>       return 0;
>>   }
>> +
>> +void virtcrypto_ctrlq_callback(struct virtqueue *vq)
>> +{
>> +    struct virtio_crypto *vcrypto = vq->vdev->priv;
>> +    struct virtio_crypto_ctrl_request *vc_ctrl_req;
>> +    unsigned long flags;
>> +    unsigned int len;
>> +
>> +    spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
>> +    do {
>> +        virtqueue_disable_cb(vq);
>> +        while ((vc_ctrl_req = virtqueue_get_buf(vq, &len)) != NULL) {
>> +            spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
>> +            if (vc_ctrl_req->ctrl_cb)
>> +                vc_ctrl_req->ctrl_cb(vc_ctrl_req);
>> +            spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
>> +        }
>> +        if (unlikely(virtqueue_is_broken(vq)))
>> +            break;
>> +    } while (!virtqueue_enable_cb(vq));
>> +    spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
>> +}
>> diff --git a/drivers/crypto/virtio/virtio_crypto_common.h 
>> b/drivers/crypto/virtio/virtio_crypto_common.h
>> index d2a20fe6e13e..25b4f22e8605 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_common.h
>> +++ b/drivers/crypto/virtio/virtio_crypto_common.h
>> @@ -81,6 +81,10 @@ struct virtio_crypto_sym_session_info {
>>       __u64 session_id;
>>   };
>> +struct virtio_crypto_ctrl_request;
>> +typedef void (*virtio_crypto_ctrl_callback)
>> +        (struct virtio_crypto_ctrl_request *vc_ctrl_req);
>> +
>>   /*
>>    * Note: there are padding fields in request, clear them to zero 
>> before sending to host,
>>    * Ex, 
>> virtio_crypto_ctrl_request::ctrl::u::destroy_session::padding[48]
>> @@ -89,6 +93,8 @@ struct virtio_crypto_ctrl_request {
>>       struct virtio_crypto_op_ctrl_req ctrl;
>>       struct virtio_crypto_session_input input;
>>       struct virtio_crypto_inhdr ctrl_status;
>> +    virtio_crypto_ctrl_callback ctrl_cb;
>> +    struct completion compl;
>>   };
>>   struct virtio_crypto_request;
>> @@ -141,7 +147,9 @@ void virtio_crypto_skcipher_algs_unregister(struct 
>> virtio_crypto *vcrypto);
>>   int virtio_crypto_akcipher_algs_register(struct virtio_crypto 
>> *vcrypto);
>>   void virtio_crypto_akcipher_algs_unregister(struct virtio_crypto 
>> *vcrypto);
>> +void virtcrypto_ctrlq_callback(struct virtqueue *vq);
>>   int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, 
>> struct scatterlist *sgs[],
>>                     unsigned int out_sgs, unsigned int in_sgs,
>>                     struct virtio_crypto_ctrl_request *vc_ctrl_req);
>> +
> 
> 
> Unnecessary changes.
> 
> Thanks
> 
> 
>>   #endif /* _VIRTIO_CRYPTO_COMMON_H */
>> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c 
>> b/drivers/crypto/virtio/virtio_crypto_core.c
>> index c6f482db0bc0..e668d4b1bc6a 100644
>> --- a/drivers/crypto/virtio/virtio_crypto_core.c
>> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
>> @@ -73,7 +73,7 @@ static int virtcrypto_find_vqs(struct virtio_crypto 
>> *vi)
>>           goto err_names;
>>       /* Parameters for control virtqueue */
>> -    callbacks[total_vqs - 1] = NULL;
>> +    callbacks[total_vqs - 1] = virtcrypto_ctrlq_callback;
>>       names[total_vqs - 1] = "controlq";
>>       /* Allocate/initialize parameters for data virtqueues */
> 

-- 
zhenwei pi
