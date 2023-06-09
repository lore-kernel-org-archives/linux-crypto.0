Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72949C7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 15:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242008AbjFIP7a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 11:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241928AbjFIP73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 11:59:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1448359E
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 08:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686326322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZASR5/BmaalzeTJJhd66JJTvqi7hh0GteSbPgdTii+8=;
        b=c2tHB9ucQKJbQcFjEAaGNNW6Piqb12NY6w63KgTHxiIHOuGgMLu8anFm3HQRpshZaLviNs
        swYwmjPzMx6pCUi3WP99YZgO+R2s7WgfJU97/OMtI6MzYB9rcsE81pvug6Rte61ag9EKNP
        qh3njru1yl67Z67nl2Kvcu9Nu8ig2TE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-0Z3ZwgkEPAOgl-MZ7OrASQ-1; Fri, 09 Jun 2023 11:58:40 -0400
X-MC-Unique: 0Z3ZwgkEPAOgl-MZ7OrASQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f7eb415010so9440765e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2023 08:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686326318; x=1688918318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZASR5/BmaalzeTJJhd66JJTvqi7hh0GteSbPgdTii+8=;
        b=dpkg2Cqlqwb+7qlCt0q6R7PNb/G8VlmXzHOJcktMdRV+/MQEHl94MrxvL3+fJQgYyB
         y/qvs/MQ19cfCK/jUxqdSEVRSLRY12EPeMcPQaDQ8T+xkpgS4ZzPF5K0dUedsZF/nJeJ
         bxKQNQCMIXOWF3I93Oga9IulRDbK7ViaBEWjFfd46IxrGS14sIL2AWs1wO9JbgKWUZAd
         YZLp9la7yrak1zxEQMmhJL+J7BWvJ/unQNBz+wymYNCVyBGuhy0bou2MC+seygXB0N4x
         8gQCWPAQAqXoFEK/EWJjXtHaV2o8boq6Drhu77l6deEbAY/2A1giP7HnWSh5rgzhVezV
         UZWw==
X-Gm-Message-State: AC+VfDylj2HpX69P41OUGwyE1VKEa0rZ/EGaS7NT/WcoGKsM/0/OsIua
        a7OaUlO6nuYg0MfJWCIMaOYFlyu7rvV7mFIJ4Px2f0nBH+qIrSScPL2Q7RUniUrhiVJjn3VwxfL
        2B9v8le1KZ6Srb+vjHUG3n2qHkyhnSWM4
X-Received: by 2002:a05:600c:3547:b0:3f7:f589:b5ca with SMTP id i7-20020a05600c354700b003f7f589b5camr4161989wmq.15.1686326318079;
        Fri, 09 Jun 2023 08:58:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OksjCtzrynIHd9z5LBpzNB7HtKW+xrrc3WbUfllkzb+rfhixTGuyBW8eVv2rOaSpPAX44dg==
X-Received: by 2002:a05:600c:3547:b0:3f7:f589:b5ca with SMTP id i7-20020a05600c354700b003f7f589b5camr4161975wmq.15.1686326317767;
        Fri, 09 Jun 2023 08:58:37 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7403:2800:22a6:7656:500:4dab])
        by smtp.gmail.com with ESMTPSA id y19-20020a05600c365300b003f7f60203ffsm3065248wmq.25.2023.06.09.08.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:58:37 -0700 (PDT)
Date:   Fri, 9 Jun 2023 11:58:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@alibaba-inc.com>
Subject: Re: [PATCH 1/3] virtio-crypto: fixup potential cpu stall when free
 unused bufs
Message-ID: <20230609115818-mutt-send-email-mst@kernel.org>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 09, 2023 at 09:18:15PM +0800, Xianting Tian wrote:
> From: Xianting Tian <tianxianting.txt@alibaba-inc.com>
> 
> Cpu stall issue may happen if device is configured with multi queues
> and large queue depth, so fix it.
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>

include a Fixes tag?

> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index 1198bd306365..94849fa3bd74 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -480,6 +480,7 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
>  			kfree(vc_req->req_data);
>  			kfree(vc_req->sgs);
>  		}
> +		cond_resched();
>  	}
>  }
>  
> -- 
> 2.17.1

