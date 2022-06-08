Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FBAC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jun 2022 12:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbiFHMR4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jun 2022 08:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239222AbiFHMRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jun 2022 08:17:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06AAE31D0CB
        for <linux-crypto@vger.kernel.org>; Wed,  8 Jun 2022 05:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YcjX7Mzre3/CuVSw3ObM9yGuU5oHF1kPeGtO/PJKO5Q=;
        b=Spy4wFreMH2WB7t/RiqunKzf3kY+4uCQwGMvBLP1ZdvLs4eIqb5d9LQTzNeW9p78NBhOC7
        PNP6ZzLtfHLLY7DzPcLC3rFr8wU4/J42QY6ROEpDjGLmIBLkkL4y3PhcgUwwMVl6ZU/CRo
        HFVam9n0Bl38F4NeE6d9fKX/TqQrnOw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-GV_VVaCxOCWhTcwtraKJcA-1; Wed, 08 Jun 2022 08:17:46 -0400
X-MC-Unique: GV_VVaCxOCWhTcwtraKJcA-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so6898372wmr.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jun 2022 05:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YcjX7Mzre3/CuVSw3ObM9yGuU5oHF1kPeGtO/PJKO5Q=;
        b=ylqDv7YpG+K/qeQr7tvdI2XGqhTNKgPwt64O8DHkM1cPexSNc3mdmJbPTQ4/W64ICT
         tFD6/bHJSQsx10gw+eqJdBEX1VLWc8CpYdIQ9LAuNqnLTUTkbfS2j0MoMYy44nd+UVtl
         RuUl9ItXJFC2B0ctbXf2pnPiNmxcxEG9vBPJY8iv8VTPrDi0m81hi3v1QB+JbonspvGt
         kkYRfYnkFUamG1UrSgZp6qHWsD4b6NyfZwKdc2aK5npntBglWP93CQdEOwC3oD8lR+Li
         0UttRFkMHu7/zd5r5F+KPh2nVS0B528b/mWmewK7JSLzM7ZCPT7uQgOBT3anqmLCYBDw
         xyBQ==
X-Gm-Message-State: AOAM531JJdWdruuTgzWGh77alG6Ef37OJvsFbOSbXqpSrq+F3xSCXrUC
        GkqUPcO7pyNGv7qacOSnS1YJYUQBGB0IHNZpon4PaJUuPtnQfh5W+kmCoWdMFQtHXMy/+L4L62D
        6hn3sDT0fIhKx4ixIKzl8Wcrg
X-Received: by 2002:a7b:c456:0:b0:39c:5d1e:661d with SMTP id l22-20020a7bc456000000b0039c5d1e661dmr6766268wmi.15.1654690665618;
        Wed, 08 Jun 2022 05:17:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhB5F/YKBuA1EQJjZy/6+/2wi5xPPNaYbmj+q+lC1WIQOtuFnB+ySu91ByQwH9OU7QY+fscw==
X-Received: by 2002:a7b:c456:0:b0:39c:5d1e:661d with SMTP id l22-20020a7bc456000000b0039c5d1e661dmr6766240wmi.15.1654690665312;
        Wed, 08 Jun 2022 05:17:45 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id z14-20020adfd0ce000000b00215bd1680a8sm13919633wrh.79.2022.06.08.05.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 05:17:44 -0700 (PDT)
Message-ID: <8733913f-b04b-f2c7-d7e2-d22740ab99af@redhat.com>
Date:   Wed, 8 Jun 2022 14:17:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] virtio-rng: make device ready before making request
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, mpm@selenic.com,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
References: <20220608061422.38437-1-jasowang@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20220608061422.38437-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/06/2022 08:14, Jason Wang wrote:
> Current virtio-rng does a entropy request before DRIVER_OK, this
> violates the spec and kernel will ignore the interrupt after commit
> 8b4ec69d7e09 ("virtio: harden vring IRQ").
> 
> Fixing this by making device ready before the request.
> 
> Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
> Reported-and-tested-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/char/hw_random/virtio-rng.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index e856df7e285c..a6f3a8a2aca6 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -159,6 +159,8 @@ static int probe_common(struct virtio_device *vdev)
>   		goto err_find;
>   	}
>   
> +	virtio_device_ready(vdev);
> +
>   	/* we always have a pending entropy request */
>   	request_entropy(vi);
>   

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

