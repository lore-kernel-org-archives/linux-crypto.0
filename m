Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E804C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 12:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353718AbiDOMiK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 08:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353726AbiDOMhn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 08:37:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40D19D399E
        for <linux-crypto@vger.kernel.org>; Fri, 15 Apr 2022 05:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650026001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ftgpEXExt/Q8tapC3VPgV4SRlTmXUpdTzVH1uq6974U=;
        b=Vm3EknRC8h2v4we23afVqCxsYAqTZabeiZy4jWUVwASS6KE8sHqgb43hQS/aNw+sn54ZHx
        pan/P/DJhp+/HGaxKKrf3K42Pa8/gVq4qvscJKpIoBo5VA44bS9vLO/3IdpStcP7PsTpRR
        SNOZAy6CbKtEs6RTskttgDL6cHb+E4I=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-Xy-llsKPP4S5f689Nj_FmQ-1; Fri, 15 Apr 2022 08:33:20 -0400
X-MC-Unique: Xy-llsKPP4S5f689Nj_FmQ-1
Received: by mail-ej1-f70.google.com with SMTP id oz37-20020a1709077da500b006e88d00043dso3146984ejc.15
        for <linux-crypto@vger.kernel.org>; Fri, 15 Apr 2022 05:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ftgpEXExt/Q8tapC3VPgV4SRlTmXUpdTzVH1uq6974U=;
        b=j28QzfNCzhWyaFgGMAaU++Ny1vUt3kwxSAnbdGlBrhrbTXoSfPhj898dr5DNRMini0
         W7al85os49oOVlGRVX/qzST1dCtkLCwiKWHJLZKTA/iNz7p3G/JLel5+aA6exzX7kChE
         axdBHir1bcJ6kdNTgR6FJq9gg59Xn2MTpEul/N7Vq9QM95iOCUe9SZqL3rf3hJjdRTzv
         yUvv88XrndvEQ6xgk3x7MVPxgPtwIeszbEtsMvB//NRInDOEgfMC00hhOwsB1ckS9YQS
         mePO8isYIyVacWtqQyXZer1RAggZFuBIHO6BExQlqvEOI9dllYCgEWojtLol+g0ceAcN
         DLsg==
X-Gm-Message-State: AOAM530VkuTXp6q6tN8hsMJzeY7UqhdzhTuwxAGtgZ4UA8rT5/UhPkb7
        gFoyO91p+8F8eOip8l2VDHwWWHTF0gESgcGQEAW/DDgpu4mPANnIBNv1ap0DEeOGUtn+1N9uJbG
        xUJ85ipwBe4Yvm88IgQxyWs5y
X-Received: by 2002:a17:907:6e0d:b0:6e0:59ae:21f1 with SMTP id sd13-20020a1709076e0d00b006e059ae21f1mr6240182ejc.362.1650025999038;
        Fri, 15 Apr 2022 05:33:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuKmlTty+4i2feqbobmTM30rT7DiZ0fmBwHM9hMPpc7VE0xAYd1NkDNPZxHO77k5Tbr4RyuQ==
X-Received: by 2002:a17:907:6e0d:b0:6e0:59ae:21f1 with SMTP id sd13-20020a1709076e0d00b006e059ae21f1mr6240091ejc.362.1650025997535;
        Fri, 15 Apr 2022 05:33:17 -0700 (PDT)
Received: from redhat.com ([2.53.138.98])
        by smtp.gmail.com with ESMTPSA id w7-20020a1709061f0700b006ec8197e8a4sm1135508ejj.97.2022.04.15.05.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:33:16 -0700 (PDT)
Date:   Fri, 15 Apr 2022 08:33:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net
Subject: Re: Re: [PATCH 1/4] virtio-crypto: wait ctrl queue instead of busy
 polling
Message-ID: <20220415082750-mutt-send-email-mst@kernel.org>
References: <20220415064136.304661-1-pizhenwei@bytedance.com>
 <20220415064136.304661-2-pizhenwei@bytedance.com>
 <20220415042555-mutt-send-email-mst@kernel.org>
 <eba72a32-aa94-0d9c-b927-a9e6b965ca44@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eba72a32-aa94-0d9c-b927-a9e6b965ca44@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 15, 2022 at 06:50:19PM +0800, zhenwei pi wrote:
> On 4/15/22 16:41, Michael S. Tsirkin wrote:
> > > diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> > > index f3ec9420215e..bf7c1aa4be37 100644
> > > --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> > > +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> > > @@ -102,107 +102,100 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
> > >   {
> > >   	struct scatterlist outhdr_sg, key_sg, inhdr_sg, *sgs[3];
> > >   	struct virtio_crypto *vcrypto = ctx->vcrypto;
> > > +	struct virtio_crypto_ctrl_request *vc_ctrl_req = NULL;
> > 
> > this is initialized down the road, I think you can skip = NULL here.
> > 
> OK.
> > >   	uint8_t *pkey;
> > > -	unsigned int inlen;
> > > -	int err;
> > > +	int err = -ENOMEM;
> > 
> > I would assign this in the single case where this value is used.
> > 
> OK
> > >   	unsigned int num_out = 0, num_in = 0;
> > > +	int node = dev_to_node(&vcrypto->vdev->dev);
> > are you sure it is
> > better to allocate close to device and not to current node
> > which is the default?
> > 
> Also with this part:
>  /* Internal representation of a data virtqueue */
> @@ -65,11 +66,6 @@ struct virtio_crypto {
>  	/* Maximum size of per request */
>  	u64 max_size;
> 
> -	/* Control VQ buffers: protected by the ctrl_lock */
> -	struct virtio_crypto_op_ctrl_req ctrl;
> -	struct virtio_crypto_session_input input;
> -	struct virtio_crypto_inhdr ctrl_status;
> -
>  	unsigned long status;
>  	atomic_t ref_count;
> 
> Orignally virtio crypto driver allocates ctrl&input&ctrl_status per-device,
> and protects this with ctrl_lock. This is the reason why the control queue
> reaches the bottleneck of performance. I'll append this in the next version
> in commit message.
> 
> Instead of the single request buffer, declare struct
> virtio_crypto_ctrl_request {
>         struct virtio_crypto_op_ctrl_req ctrl;
>         struct virtio_crypto_session_input input;
>         struct virtio_crypto_inhdr ctrl_status;
> 	... }
> 
> The motivation of this change is to allocate buffer from the same node with
> device during control queue operations.

But are you sure it's a win?  quite possibly it's a win to
have it close to driver not close to device.
This kind of change is really best done separately with some
testing showing it's a win. If that is too much to ask,
make it a separate patch and add some analysis explaining
why device accesses the structure more than the driver.


> > 
> > >   	pkey = kmemdup(key, keylen, GFP_ATOMIC);
> > >   	if (!pkey)
> > >   		return -ENOMEM;
> > > -	spin_lock(&vcrypto->ctrl_lock);
> > > -	memcpy(&vcrypto->ctrl.header, header, sizeof(vcrypto->ctrl.header));
> > > -	memcpy(&vcrypto->ctrl.u, para, sizeof(vcrypto->ctrl.u));
> > > -	vcrypto->input.status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
> > > +	vc_ctrl_req = kzalloc_node(sizeof(*vc_ctrl_req), GFP_KERNEL, node);
> > > +	if (!vc_ctrl_req)
> > > +		goto out;
> > 
> > do you need to allocate it with kzalloc?
> > is anything wrong with just keeping it part of device?
> > even if yes this change is better split in a separate patch, would make the patch smaller.
> Because there are padding field in
> virtio_crypto_op_ctrl_req&virtio_crypto_session_input, I suppose the
> original version also needs to clear padding field.
> So I use kzalloc to make sure that the padding field gets cleared.
> If this is reasonable, to separate this patch is OK to me, or I append this
> reason into commit message and comments in code.

Not sure I understand. Maybe add a code comment explaining
what is cleared and why.

> > > +
> > > +void virtcrypto_ctrlq_callback(struct virtqueue *vq)
> > > +{
> > > +	struct virtio_crypto *vcrypto = vq->vdev->priv;
> > > +	struct virtio_crypto_ctrl_request *vc_ctrl_req;
> > > +	unsigned long flags;
> > > +	unsigned int len;
> > > +
> > > +	spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
> > > +	do {
> > > +		virtqueue_disable_cb(vq);
> > > +		while ((vc_ctrl_req = virtqueue_get_buf(vq, &len)) != NULL) {
> > 
> > 
> > you really need to break out of this loop if vq is broken,
> > virtqueue_get_buf will keep returning NULL in this case.
> > 
> I'm a little confused here, if virtqueue_get_buf return NULL, this loop will
> break. Could you please give me more hints?

Oh right. Sorry was confused.

> > 
> > > +			spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
> > > +			if (vc_ctrl_req->ctrl_cb)
> > > +				vc_ctrl_req->ctrl_cb(vc_ctrl_req);
> > > +			spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
> > > +		}
> > > +		if (unlikely(virtqueue_is_broken(vq)))
> > > +			break;
> > > +	} while (!virtqueue_enable_cb(vq));
> > > +	spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
> > 
> > speaking of which existing code does not handle vq broken case
> > all that well but it looks like this patch makes it a bit worse.
> > want to try fixing? basically report an error ...
> > 
> > if virtqueue is broken, I can print log.
> 
> > > diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> > > index c6f482db0bc0..e668d4b1bc6a 100644
> > > --- a/drivers/crypto/virtio/virtio_crypto_core.c
> > > +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> > > @@ -73,7 +73,7 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
> > >   		goto err_names;
> > >   	/* Parameters for control virtqueue */
> > > -	callbacks[total_vqs - 1] = NULL;
> > > +	callbacks[total_vqs - 1] = virtcrypto_ctrlq_callback;
> > >   	names[total_vqs - 1] = "controlq";
> > >   	/* Allocate/initialize parameters for data virtqueues */
> > > diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> > > index a618c46a52b8..b8999dab3e66 100644
> > > --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> > > +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> > > +	err = 0;
> > > +out:
> > > +	kfree_sensitive(vc_ctrl_req);
> > 
> > it is interesting that you use kfree_sensitive here. why is that?
> > is there in fact anything sensitive here? if yes this is a security
> > improvement and might need its own patch, or at least documentation.
> > 
> 
> OK, kfree is good enough here, I'll fix this.
> 
> 
> Thanks a lot!
> 
> 
> -- 
> zhenwei pi

