Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C59AC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 07:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A27D6115A
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 07:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhIWHGE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 03:06:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239450AbhIWHGD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 03:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632380672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sHWe/4xEkfiCD6fVR0vhWpP/mCzT888yzZbNxm0TXDw=;
        b=HX8/gKkn/bu9LovOtCZEpVf6npKfCCc0WZVmaKk3wLoiRHRbY1j7OYys1vbeJ8ZKePjRLV
        b8I+ZXJe3akHuWhAbDj1NNyP0M77dkHnUDO9voPaYXXyO2gfrlBjrEXGqzpNtMsLdlhM8D
        2jK+f6KUsXU7VuyRtXarz1q+YycvA2g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-2102Wq7OP7eqYxhs2JHgTg-1; Thu, 23 Sep 2021 03:04:31 -0400
X-MC-Unique: 2102Wq7OP7eqYxhs2JHgTg-1
Received: by mail-wr1-f72.google.com with SMTP id m1-20020a056000180100b0015e1ec30ac3so4314882wrh.8
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 00:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sHWe/4xEkfiCD6fVR0vhWpP/mCzT888yzZbNxm0TXDw=;
        b=vw5uln15Jfwb2R54Vi9DqcBDJNirp6OJpbb0xbuqn/v+5oCr875Frrv7tXg+xkn+zM
         Vfp+8sO7LX/iC8I1KYmlBZOnX2/qKBBDx7PJI/8MODu8sGfaRT1L3zCfWzPJMlSwbBVq
         U3seQ1OGgXTClW60iswH7bVPwlS6IBW85d7BepEI/0ApH4pvFfrw88hHA7IVV66XyZAh
         BpvxJOFpBZ0aK4bj2e2UMkCUQCKdFkI0E4dWqyBNIg07KBK3A+gQ3SX3AyWCqOkGHxDH
         XQjZ2QJXuXPiLtYx9ih+Pskpg6bz1JHnipWNQWe5RV+jTiLH+X0rEb1lwda4OFVgbqIx
         gN5A==
X-Gm-Message-State: AOAM5311FfuxKc+oLb6a9PamAONAXLR9+uVfC2ClW3npSPO1dw9Qfhlx
        ZwyqOOZaua3VFQf8+A9oUbK25icQLeDLYGJCgL+BzvSdfQhbfNzJO9ni/QIBd2wgnAPqYGwulJJ
        S0L6s0eCTomZYe1AI7fXa0VVe
X-Received: by 2002:adf:d1eb:: with SMTP id g11mr3231300wrd.194.1632380669937;
        Thu, 23 Sep 2021 00:04:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyhNcyRrQ0UISVsN6EX3ylQ1wmCRTHutBo4vW6SvawXhtq0ItioLRisgG4k4kuB/oaOyTIpg==
X-Received: by 2002:adf:d1eb:: with SMTP id g11mr3231280wrd.194.1632380669659;
        Thu, 23 Sep 2021 00:04:29 -0700 (PDT)
Received: from redhat.com ([2.55.11.56])
        by smtp.gmail.com with ESMTPSA id o26sm8181379wmc.17.2021.09.23.00.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 00:04:28 -0700 (PDT)
Date:   Thu, 23 Sep 2021 03:04:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Dmitriy Vyukov <dvyukov@google.com>,
        rusty@rustcorp.com.au, amit@kernel.org, akong@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] hwrng: virtio - add an internal buffer
Message-ID: <20210923030026-mutt-send-email-mst@kernel.org>
References: <20210922170903.577801-1-lvivier@redhat.com>
 <20210922170903.577801-2-lvivier@redhat.com>
 <20210922145651-mutt-send-email-mst@kernel.org>
 <0dd338bb-0fbe-b9d5-0962-d47ac2de4c4e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dd338bb-0fbe-b9d5-0962-d47ac2de4c4e@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 23, 2021 at 08:26:06AM +0200, Laurent Vivier wrote:
> On 22/09/2021 21:02, Michael S. Tsirkin wrote:
> > On Wed, Sep 22, 2021 at 07:09:00PM +0200, Laurent Vivier wrote:
> > > hwrng core uses two buffers that can be mixed in the
> > > virtio-rng queue.
> > > 
> > > If the buffer is provided with wait=0 it is enqueued in the
> > > virtio-rng queue but unused by the caller.
> > > On the next call, core provides another buffer but the
> > > first one is filled instead and the new one queued.
> > > And the caller reads the data from the new one that is not
> > > updated, and the data in the first one are lost.
> > > 
> > > To avoid this mix, virtio-rng needs to use its own unique
> > > internal buffer at a cost of a data copy to the caller buffer.
> > > 
> > > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > > ---
> > >   drivers/char/hw_random/virtio-rng.c | 43 ++++++++++++++++++++++-------
> > >   1 file changed, 33 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > > index a90001e02bf7..208c547dcac1 100644
> > > --- a/drivers/char/hw_random/virtio-rng.c
> > > +++ b/drivers/char/hw_random/virtio-rng.c
> > > @@ -18,13 +18,20 @@ static DEFINE_IDA(rng_index_ida);
> > >   struct virtrng_info {
> > >   	struct hwrng hwrng;
> > >   	struct virtqueue *vq;
> > > -	struct completion have_data;
> > >   	char name[25];
> > > -	unsigned int data_avail;
> > >   	int index;
> > >   	bool busy;
> > >   	bool hwrng_register_done;
> > >   	bool hwrng_removed;
> > > +	/* data transfer */
> > > +	struct completion have_data;
> > > +	unsigned int data_avail;
> > > +	/* minimal size returned by rng_buffer_size() */
> > > +#if SMP_CACHE_BYTES < 32
> > > +	u8 data[32];
> > > +#else
> > > +	u8 data[SMP_CACHE_BYTES];
> > > +#endif
> > 
> > Let's move this logic to a macro in hw_random.h ?
> > 
> > >   };
> > >   static void random_recv_done(struct virtqueue *vq)
> > > @@ -39,14 +46,14 @@ static void random_recv_done(struct virtqueue *vq)
> > >   }
> > >   /* The host will fill any buffer we give it with sweet, sweet randomness. */
> > > -static void register_buffer(struct virtrng_info *vi, u8 *buf, size_t size)
> > > +static void register_buffer(struct virtrng_info *vi)
> > >   {
> > >   	struct scatterlist sg;
> > > -	sg_init_one(&sg, buf, size);
> > > +	sg_init_one(&sg, vi->data, sizeof(vi->data));
> > 
> > Note that add_early_randomness requests less:
> >          size_t size = min_t(size_t, 16, rng_buffer_size());
> > 
> > maybe track how much was requested and grow up to sizeof(data)?
> 
> I think this problem is managed by PATCH 3/4 as we reuse unused data of the buffer.

the issue I'm pointing out is that we are requesting too much
entropy from host - more than guest needs.

> > 
> > >   	/* There should always be room for one buffer. */
> > > -	virtqueue_add_inbuf(vi->vq, &sg, 1, buf, GFP_KERNEL);
> > > +	virtqueue_add_inbuf(vi->vq, &sg, 1, vi->data, GFP_KERNEL);
> > 
> > 
> > BTW no longer true if DMA API is in use ... not easy to fix,
> > I think some changes to virtio API to allow pre-mapping
> > s/g for DMA might be needed ...
> 
> Is there something I can do here?
> 
> Thanks,
> Laurent

We can let it be for now, but down the road I think we should
support a way to pre-map memory for DMA.

-- 
MST

