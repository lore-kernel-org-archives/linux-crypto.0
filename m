Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7F3C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 11:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391409AbiEFLhe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 07:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391382AbiEFLhc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 07:37:32 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A07E062100
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 04:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651836813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ucCpzTQkF8XhUkvL7+8cXDWEm9SjV8gZcvK7m79UBU=;
        b=iwQlSqppV8VrifkdFeUlpdDrJO8ITcuW1FkIRqj7JDhKxuvQOCEKysExFcZvv716u950vN
        TZi+f8HSfRE6NEE5SIlwtJRrdgX1QC67FTuO1BS3G8AUksDQg1sypUCOX5+sXaAhVyEz5h
        JJv7ssgzvh0OPTqMj3GA/vVPoZtaZIs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-8oTse6F1NuGwei1FCEF6Ew-1; Fri, 06 May 2022 07:33:32 -0400
X-MC-Unique: 8oTse6F1NuGwei1FCEF6Ew-1
Received: by mail-ej1-f69.google.com with SMTP id gn26-20020a1709070d1a00b006f453043956so4179131ejc.15
        for <linux-crypto@vger.kernel.org>; Fri, 06 May 2022 04:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ucCpzTQkF8XhUkvL7+8cXDWEm9SjV8gZcvK7m79UBU=;
        b=XFglOG16/3uMA+id2eZ5G9ZxM2WthGILdHayfi0HaDjvfiL3r26A/SFTwlr5XYn9A9
         GDeGb8df6StIbuW6XjLbFajiJyvlqG8pGvrdmx0y0D80uA0KjGZk/LmQbXIL1pJDIJ3x
         NdHa88LYu06PZ3//pa7YQ0+69EjawHGK7b25SCkXv67TVqgfNETypIA6vnIpN2xYrilj
         OOLqFX012ktOnxWsoJmXhRxUrVcJK9Q7OFS5Uy3d8war0feiammS1shv/NylPFYZqArd
         beQmk5JyFZzVVEZ/0T2bpMKpgfm7ZmuDEidgZ109stxXfpBQCTpg7zJYDvXokie0PTss
         CpyQ==
X-Gm-Message-State: AOAM532ZOQ9y6tIDd6lE7kJOW4snD1m2v4ecO0stjIVpPlCw9Z7eECGu
        eO4pIInnWIfU6+VbLiquXLtxoYCcE0V5WXvzxcOb493dJuqKjLZ3SfO1TObIKU7+MTEHM+vjBvp
        jqGoL4UY98VumU29wp2EgcgIr
X-Received: by 2002:a17:906:148a:b0:6f3:833d:5a0f with SMTP id x10-20020a170906148a00b006f3833d5a0fmr2560116ejc.49.1651836811509;
        Fri, 06 May 2022 04:33:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWqNhgRcK629dCnuKAST3WbCl+p9Mce05cC+BHLm/aKmxrKARyEIXE+pvxtLSGIpCklwFmrA==
X-Received: by 2002:a17:906:148a:b0:6f3:833d:5a0f with SMTP id x10-20020a170906148a00b006f3833d5a0fmr2560103ejc.49.1651836811295;
        Fri, 06 May 2022 04:33:31 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:107e:a6f7:2ba7:16e9:af89:1a95])
        by smtp.gmail.com with ESMTPSA id hy5-20020a1709068a6500b006f3ef214ddcsm1808167ejc.66.2022.05.06.04.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 04:33:30 -0700 (PDT)
Date:   Fri, 6 May 2022 07:33:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "helei.sig11@bytedance.com" <helei.sig11@bytedance.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: RE: [PATCH v5 5/5] virtio-crypto: enable retry for
 virtio-crypto-dev
Message-ID: <20220506073316-mutt-send-email-mst@kernel.org>
References: <20220505092408.53692-1-pizhenwei@bytedance.com>
 <20220505092408.53692-6-pizhenwei@bytedance.com>
 <ad61b1ae4bd145eaa18fc28696e9502a@huawei.com>
 <48c9b073-0b03-5769-633b-5b668cea6fa4@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c9b073-0b03-5769-633b-5b668cea6fa4@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 06, 2022 at 05:55:33PM +0800, zhenwei pi wrote:
> On 5/6/22 17:34, Gonglei (Arei) wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: zhenwei pi [mailto:pizhenwei@bytedance.com]
> > > Sent: Thursday, May 5, 2022 5:24 PM
> > > To: Gonglei (Arei) <arei.gonglei@huawei.com>; mst@redhat.com
> > > Cc: jasowang@redhat.com; herbert@gondor.apana.org.au;
> > > linux-kernel@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > linux-crypto@vger.kernel.org; helei.sig11@bytedance.com;
> > > pizhenwei@bytedance.com; davem@davemloft.net
> > > Subject: [PATCH v5 5/5] virtio-crypto: enable retry for virtio-crypto-dev
> > > 
> > > From: lei he <helei.sig11@bytedance.com>
> > > 
> > > Enable retry for virtio-crypto-dev, so that crypto-engine can process
> > > cipher-requests parallelly.
> > > 
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Gonglei <arei.gonglei@huawei.com>
> > > Signed-off-by: lei he <helei.sig11@bytedance.com>
> > > Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> > > ---
> > >   drivers/crypto/virtio/virtio_crypto_core.c | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/crypto/virtio/virtio_crypto_core.c
> > > b/drivers/crypto/virtio/virtio_crypto_core.c
> > > index 60490ffa3df1..f67e0d4c1b0c 100644
> > > --- a/drivers/crypto/virtio/virtio_crypto_core.c
> > > +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> > > @@ -144,7 +144,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
> > >   		spin_lock_init(&vi->data_vq[i].lock);
> > >   		vi->data_vq[i].vq = vqs[i];
> > >   		/* Initialize crypto engine */
> > > -		vi->data_vq[i].engine = crypto_engine_alloc_init(dev, 1);
> > > +		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true,
> > > NULL, 1,
> > > +						virtqueue_get_vring_size(vqs[i]));
> > 
> > Here the '1' can be 'true' too.
> > 
> > Sure, you can add
> > 
> > Reviewed-by: Gonglei <arei.gonglei@huawei.com>
> > 
> > Regards,
> > -Gonglei
> > 
> > >   		if (!vi->data_vq[i].engine) {
> > >   			ret = -ENOMEM;
> > >   			goto err_engine;
> > > --
> > > 2.20.1
> > 
> 
> Thanks to Lei!
> 
> Hi, Michael
> I would appreciate it if you could apply this minor change, or I send the v6
> series, which one do you prefer?
> 
> -- 


send v6 with acks and change pls

