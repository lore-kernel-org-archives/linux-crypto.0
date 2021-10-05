Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE981C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 11:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D52610A2
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 11:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhJELmP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Oct 2021 07:42:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230500AbhJELmO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Oct 2021 07:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633434024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jng+t/KM35rvlrjpFOnhlmQDfLsDuNmByDqJMmcgxQ=;
        b=Kgq3VI3mG6TPvUhfnt7RXpsaOSwukeO8aWPcZCOtcQXEpN5F/nkGfOeB7E7Jb10Y6/v3E1
        F2G7lMmgqwW8JQMvGrdD5bKYCDDs1/+1aLRF5PmagkB93ydnyIRR5ln9XgDoB1RBSyI4Ue
        ++k25W/jZ8gvacf/s00BsEFD4gcTTik=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-Flxz6DGqM8CtA_P3zIv7Ew-1; Tue, 05 Oct 2021 07:40:22 -0400
X-MC-Unique: Flxz6DGqM8CtA_P3zIv7Ew-1
Received: by mail-wm1-f69.google.com with SMTP id 129-20020a1c1987000000b0030cd1616fbfso1189481wmz.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Oct 2021 04:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5jng+t/KM35rvlrjpFOnhlmQDfLsDuNmByDqJMmcgxQ=;
        b=hFY/ELYTwMqoLjkJWLopkKRNicOzkNU0fIuk066nBAc1eFSh/a2QUEZB2aU4tS6R/9
         omrbLliN3SONCAZit4zQnMuBBSOXEuvK1Njxn7qcEg/1c/h1HG0ALLdQwPCm04FDyKNM
         MDCqhXIXP9tKLY4y/d+JaZmTcRgV0oy+pzxFzt8a3GCFfOmfjwprrKeMy31eqvi+EVvx
         6T5o1rpy2AUTRqYJWGuaWt7775k/1ST9hw9qkJqp+Yh5z7pf+1r6Y88CUMKh8oKoJAuM
         ydkgyaFVy28x68BvQjqq0H0fem2k19UPBM4OG6/2OyP+Xw7AdbjzcP/8P967cltob/Z1
         rtjA==
X-Gm-Message-State: AOAM5317MDeubZ20lYDv9uIrHNTi+Y9nLLlQfmB0uAPa0cYdEXfrQ1Jg
        fIxYca4v1lxOq+jkredDoDgGWLD0a0KMWb85PSjg/3KLkpQ+2ItY+tOERwkh9JVxUu2VmhPc4gJ
        YHp6xEySpsvRWLFyxBRZKuGQC
X-Received: by 2002:adf:f946:: with SMTP id q6mr20800999wrr.437.1633434021613;
        Tue, 05 Oct 2021 04:40:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyazp3VBDOnWtSY8G3MjsohPMvzJyMJLtngLNsfvR7sWs6QI+KrltPbhmkHqKDnOIrXSYvmXQ==
X-Received: by 2002:adf:f946:: with SMTP id q6mr20800984wrr.437.1633434021441;
        Tue, 05 Oct 2021 04:40:21 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.3.114])
        by smtp.gmail.com with ESMTPSA id n14sm1823048wms.0.2021.10.05.04.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 04:40:21 -0700 (PDT)
Message-ID: <637cd2e5-8584-3ef5-6de8-bf43b581d0d6@redhat.com>
Date:   Tue, 5 Oct 2021 13:40:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/4] hwrng: virtio - add an internal buffer
Content-Language: en-US
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Dmitriy Vyukov <dvyukov@google.com>,
        rusty@rustcorp.com.au, amit@kernel.org, akong@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org
References: <20210922170903.577801-1-lvivier@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20210922170903.577801-1-lvivier@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/09/2021 19:08, Laurent Vivier wrote:
> hwrng core uses two buffers that can be mixed in the virtio-rng queue.
> 
> This series fixes the problem by adding an internal buffer in virtio-rng.
> 
> Once the internal buffer is added, we can fix two other problems:
> 
> - to be able to release the driver without waiting the device releases the
>    buffer
> 
> - actually returns some data when wait=0 as we can have some already
>    available data
> 
> It also tries to improve the performance by always having a buffer in
> the queue of the device.
> 
> Laurent Vivier (4):
>    hwrng: virtio - add an internal buffer
>    hwrng: virtio - don't wait on cleanup
>    hwrng: virtio - don't waste entropy
>    hwrng: virtio - always add a pending request
> 
>   drivers/char/hw_random/virtio-rng.c | 84 +++++++++++++++++++++--------
>   1 file changed, 63 insertions(+), 21 deletions(-)
> 

Any comment?

Do we need a v2?

Thanks,
Laurent

