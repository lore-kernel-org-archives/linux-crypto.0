Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60192C77B75
	for <linux-crypto@archiver.kernel.org>; Wed,  3 May 2023 11:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjECLTg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 May 2023 07:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjECLTf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2023 07:19:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689323C24
        for <linux-crypto@vger.kernel.org>; Wed,  3 May 2023 04:19:34 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-95678d891d6so1013575966b.1
        for <linux-crypto@vger.kernel.org>; Wed, 03 May 2023 04:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683112773; x=1685704773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nzkx9OdHMX23vf26tcTtm7snpFPKTJ2GvIjRzw+zdVo=;
        b=hj5yuKoBkypdtVct09e6dqRmoiNZcEKJXEKrP/7g4X8avTqxuYu4YH7uxyn+ylgjwW
         8mVn174tpzJXR2ub34QPhHGgiELiljsriqAHZq22GHafah4Q6435F8IZBfzcolgT00li
         ovr1fZ8c7780dpIxWi3pkwMuubGzz6neWQnrVwvFSQgYKOIGEpwYovWu9lpFxzxFU0cQ
         saSFb5PFCp014H+x+ZvVGS+KoX89T25rauyMX4ffKizhkHDq4VD810O0xXgvYwukZRvW
         AVAGmJMSENj6BFUr52UteBuZAqFHgf/eVbbL/gEOCMcFvIEsF1tqvhmzcXyXYTAWy2+b
         LsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683112773; x=1685704773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nzkx9OdHMX23vf26tcTtm7snpFPKTJ2GvIjRzw+zdVo=;
        b=gC2CrbZgwADPyYx15EoGJphmnWZ5b+2owZaQSBmTcnbfSrBic/CCowpl4kKjtF41nG
         R7Y46zj3rYOavx1uLyN96qIjxSrW5JM1CG9MUFpS65eym51NX4djZ+k2W1I7mk2vEVNY
         ZVZGOmFkeWhGzpBRBzmdBzHyFNANblZTNqVXEh6u2t67DJihTqSgkt+WT1QPANGMoezW
         HCWUcBKWH4FzyLwyI6xbqDUJ8SLgfseI+tc+4/CBwos28QcMqQD/b7EI+0S2ANRAjg8+
         WPzuJVDkqJ7/HgQT4OypOj7W6ArmZEwev9bVjN5l9sE2/2dNCZvy8Zim6qvD/5+5fPcw
         8eYg==
X-Gm-Message-State: AC+VfDyoDOgd5lcFTGW8FO3tfJPoquhRDLqE/zJ6xuXSVQgrSKDDIZvW
        0yZ7nhJCGqxR24JX7wLoX6XEnQ==
X-Google-Smtp-Source: ACHHUZ7SCcODqqgSt1zl4Nd28Rh1r4PB3cjdO6bhGbEs3lZPg/dyq7II7TvTTn2gnwsf/TvoKYKbFA==
X-Received: by 2002:a17:907:6e0e:b0:957:2e48:5657 with SMTP id sd14-20020a1709076e0e00b009572e485657mr2821518ejc.68.1683112772853;
        Wed, 03 May 2023 04:19:32 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.230])
        by smtp.gmail.com with ESMTPSA id jo2-20020a170906f6c200b009538cc79241sm17385557ejb.56.2023.05.03.04.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 04:19:32 -0700 (PDT)
Message-ID: <ede92183-bef3-78a7-abae-335c6c5cca1e@linaro.org>
Date:   Wed, 3 May 2023 12:19:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] hwrng: virtio - Fix race on data_avail and actual data
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, olivia@selenic.com,
        syzkaller-bugs@googlegroups.com, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
References: <00000000000050327205f9d993b2@google.com>
 <CACT4Y+awU85RHZjf3+_85AvJOHghoOhH3c9E-70p+a=FrRDYkg@mail.gmail.com>
 <ZFI9bHr1o2Cvdebp@gondor.apana.org.au>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <ZFI9bHr1o2Cvdebp@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 5/3/23 11:54, Herbert Xu wrote:
> On Fri, Apr 21, 2023 at 04:52:13PM +0200, Dmitry Vyukov wrote:
>>
>> Here this:
>>
>> size = min_t(unsigned int, size, vi->data_avail);
>> memcpy(buf, vi->data + vi->data_idx, size);
>> vi->data_idx += size;
>> vi->data_avail -= size;
>>
>> runs concurrently with:
>>
>> if (!virtqueue_get_buf(vi->vq, &vi->data_avail))
>>     return;
>> vi->data_idx = 0;
>>
>> I did not fully grasp how/where vi->data is populated, but it looks
>> like it can lead to use of uninit/stale random data, or even to out of
>> bounds access, say if vi->data_avail is already updated, but
>> vi->data_idx is not yet reset to 0. Then concurrent reading will read
>> not where it's supposed to read.
> 
> Yes this is a real race.  This bug appears to have been around
> forever.
> 
> ---8<---
> The virtio rng device kicks off a new entropy request whenever the
> data available reaches zero.  When a new request occurs at the end
> of a read operation, that is, when the result of that request is
> only needed by the next reader, then there is a race between the
> writing of the new data and the next reader.
> 
> This is because there is no synchronisation whatsoever between the
> writer and the reader.
> 
> Fix this by writing data_avail with smp_store_release and reading
> it with smp_load_acquire when we first enter read.  The subsequent
> reads are safe because they're either protected by the first load
> acquire, or by the completion mechanism.
> 
> Reported-by: syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com

Link: https://syzkaller.appspot.com/bug?extid=726dc8c62c3536431ceb

Please add the dashboard link if applying as searching for the syzbot ID
rarely gives meaningful results.

Cheers,
ta

> Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index f7690e0f92ed..e41a84e6b4b5 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -4,6 +4,7 @@
>   *  Copyright (C) 2007, 2008 Rusty Russell IBM Corporation
>   */
>  
> +#include <asm/barrier.h>
>  #include <linux/err.h>
>  #include <linux/hw_random.h>
>  #include <linux/scatterlist.h>
> @@ -37,13 +38,13 @@ struct virtrng_info {
>  static void random_recv_done(struct virtqueue *vq)
>  {
>  	struct virtrng_info *vi = vq->vdev->priv;
> +	unsigned int len;
>  
>  	/* We can get spurious callbacks, e.g. shared IRQs + virtio_pci. */
> -	if (!virtqueue_get_buf(vi->vq, &vi->data_avail))
> +	if (!virtqueue_get_buf(vi->vq, &len))
>  		return;
>  
> -	vi->data_idx = 0;
> -
> +	smp_store_release(&vi->data_avail, len);
>  	complete(&vi->have_data);
>  }
>  
> @@ -52,7 +53,6 @@ static void request_entropy(struct virtrng_info *vi)
>  	struct scatterlist sg;
>  
>  	reinit_completion(&vi->have_data);
> -	vi->data_avail = 0;
>  	vi->data_idx = 0;
>  
>  	sg_init_one(&sg, vi->data, sizeof(vi->data));
> @@ -88,7 +88,7 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
>  	read = 0;
>  
>  	/* copy available data */
> -	if (vi->data_avail) {
> +	if (smp_load_acquire(&vi->data_avail)) {
>  		chunk = copy_data(vi, buf, size);
>  		size -= chunk;
>  		read += chunk;
