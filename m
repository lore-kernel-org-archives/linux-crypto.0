Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A9FC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 11:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECBB161409
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 11:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhJEL5A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Oct 2021 07:57:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234431AbhJEL47 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Oct 2021 07:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633434908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=751Mq58IyY6njGZql4czNj7G+CX1GwSnnuMROueTMmM=;
        b=eH0pIe3ZZBU4NCfNOuIBCbPcZR0NLBzepRX38LF45wC3iU62TdeFxk7nHbmd6GlSxdr6jR
        +D2/gHlJDu5hE+9z9InxX0tgtMWUqaopSqzUxmeBkuHtvVMIDGcmoMPeixNGZvZMlrRU84
        hQlHlSMGpG5Cih9Nld129vX49wH56BM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-t0JujKEYM6GRBNXduQ9wAg-1; Tue, 05 Oct 2021 07:55:08 -0400
X-MC-Unique: t0JujKEYM6GRBNXduQ9wAg-1
Received: by mail-ed1-f72.google.com with SMTP id k2-20020a50ce42000000b003dadf140b15so8714576edj.19
        for <linux-crypto@vger.kernel.org>; Tue, 05 Oct 2021 04:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=751Mq58IyY6njGZql4czNj7G+CX1GwSnnuMROueTMmM=;
        b=6xGpHMysUDrEnaRvGzbVzxStYopglI5pAp30/bbufqqmihxiHtm1uQY7jOmJMyqGXr
         mq6xjjQuJA0/AuVpqjDfBUOiQMzzfxa2w4a0Tyf1WAMeveoAXCNn1mo0nrk0qo4JNa87
         pfSRgiN+j6XUC4gv9wyQSfu8qp5NXMKW/oF2ivLADWON3vguN8xHcmNXoTElBSxl3dp/
         nntrBF/kk6rIWpvbRmb0EsfyF6d3zQxW9Qiq6wtPmQif8YaV5agNgBQxtkRnqFBkpIuO
         fHG2V1TtkAqEqVjro6868UFM4769y3UPsfSU63t5yp333OZC5D+ct7CTfC/GLAJJc3ST
         DtZQ==
X-Gm-Message-State: AOAM531TQwQSyNtzG6kyi4wd7EkP3gvToeiRHeZNZiaAPY0P6w5wEwN/
        zwVJ2cKaeaPyxpUULthcAP13f/tKEwemECG239/3avBYmkkIeNBdj6qJimtHoepztjQQTc4UPN3
        4GL/m/UbiFIkdbfogy7aLyExW
X-Received: by 2002:aa7:dcca:: with SMTP id w10mr9306079edu.113.1633434906575;
        Tue, 05 Oct 2021 04:55:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKDDgPsgNIUpsi1sJPCxnLqF7SOpHow7WZJ20HTv9RycP25PPJd6O0cpLj5bn/LJOFxmdAmA==
X-Received: by 2002:aa7:dcca:: with SMTP id w10mr9306046edu.113.1633434906347;
        Tue, 05 Oct 2021 04:55:06 -0700 (PDT)
Received: from redhat.com ([2.55.147.134])
        by smtp.gmail.com with ESMTPSA id k23sm1850590edv.22.2021.10.05.04.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 04:55:05 -0700 (PDT)
Date:   Tue, 5 Oct 2021 07:55:02 -0400
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
Message-ID: <20211005075433-mutt-send-email-mst@kernel.org>
References: <20210922170903.577801-1-lvivier@redhat.com>
 <20210922170903.577801-2-lvivier@redhat.com>
 <20210922145651-mutt-send-email-mst@kernel.org>
 <0dd338bb-0fbe-b9d5-0962-d47ac2de4c4e@redhat.com>
 <20210923030026-mutt-send-email-mst@kernel.org>
 <fcd17df1-5aed-346b-e7cd-abe4dfb67e69@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcd17df1-5aed-346b-e7cd-abe4dfb67e69@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 23, 2021 at 09:34:18AM +0200, Laurent Vivier wrote:
> On 23/09/2021 09:04, Michael S. Tsirkin wrote:
> > On Thu, Sep 23, 2021 at 08:26:06AM +0200, Laurent Vivier wrote:
> > > On 22/09/2021 21:02, Michael S. Tsirkin wrote:
> > > > On Wed, Sep 22, 2021 at 07:09:00PM +0200, Laurent Vivier wrote:
> > > > > hwrng core uses two buffers that can be mixed in the
> > > > > virtio-rng queue.
> > > > > 
> > > > > If the buffer is provided with wait=0 it is enqueued in the
> > > > > virtio-rng queue but unused by the caller.
> > > > > On the next call, core provides another buffer but the
> > > > > first one is filled instead and the new one queued.
> > > > > And the caller reads the data from the new one that is not
> > > > > updated, and the data in the first one are lost.
> > > > > 
> > > > > To avoid this mix, virtio-rng needs to use its own unique
> > > > > internal buffer at a cost of a data copy to the caller buffer.
> > > > > 
> > > > > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > > > > ---
> > > > >    drivers/char/hw_random/virtio-rng.c | 43 ++++++++++++++++++++++-------
> > > > >    1 file changed, 33 insertions(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > > > > index a90001e02bf7..208c547dcac1 100644
> > > > > --- a/drivers/char/hw_random/virtio-rng.c
> > > > > +++ b/drivers/char/hw_random/virtio-rng.c
> > > > > @@ -18,13 +18,20 @@ static DEFINE_IDA(rng_index_ida);
> > > > >    struct virtrng_info {
> > > > >    	struct hwrng hwrng;
> > > > >    	struct virtqueue *vq;
> > > > > -	struct completion have_data;
> > > > >    	char name[25];
> > > > > -	unsigned int data_avail;
> > > > >    	int index;
> > > > >    	bool busy;
> > > > >    	bool hwrng_register_done;
> > > > >    	bool hwrng_removed;
> > > > > +	/* data transfer */
> > > > > +	struct completion have_data;
> > > > > +	unsigned int data_avail;
> > > > > +	/* minimal size returned by rng_buffer_size() */
> > > > > +#if SMP_CACHE_BYTES < 32
> > > > > +	u8 data[32];
> > > > > +#else
> > > > > +	u8 data[SMP_CACHE_BYTES];
> > > > > +#endif
> > > > 
> > > > Let's move this logic to a macro in hw_random.h ?
> > > > 
> > > > >    };
> > > > >    static void random_recv_done(struct virtqueue *vq)
> > > > > @@ -39,14 +46,14 @@ static void random_recv_done(struct virtqueue *vq)
> > > > >    }
> > > > >    /* The host will fill any buffer we give it with sweet, sweet randomness. */
> > > > > -static void register_buffer(struct virtrng_info *vi, u8 *buf, size_t size)
> > > > > +static void register_buffer(struct virtrng_info *vi)
> > > > >    {
> > > > >    	struct scatterlist sg;
> > > > > -	sg_init_one(&sg, buf, size);
> > > > > +	sg_init_one(&sg, vi->data, sizeof(vi->data));
> > > > 
> > > > Note that add_early_randomness requests less:
> > > >           size_t size = min_t(size_t, 16, rng_buffer_size());
> > > > 
> > > > maybe track how much was requested and grow up to sizeof(data)?
> > > 
> > > I think this problem is managed by PATCH 3/4 as we reuse unused data of the buffer.
> > 
> > the issue I'm pointing out is that we are requesting too much
> > entropy from host - more than guest needs.
> 
> Yes, guest asks for 16 bytes, but we request SMP_CACHE_BYTES (64 on x86_64),
> and these 16 bytes are used with add_device_randomness(). With the following
> patches, the remaining 48 bytes are used rapidly by hwgnd kthread or by the
> next virtio_read.
> 
> If there is no enough entropy the call is simply ignored as wait=0.
> 
> At this patch level the call is always simply ignored (because wait=0) and
> the data requested here are used by the next read that always asks for a
> SMP_CACHE_BYTES bytes data size.
> 
> Moreover in PATCH 4/4 we always have a pending request of size
> SMP_CACHE_BYTES, so driver always asks a block of this size and the guest
> takes what it needs.
> 
> Originally I used a 16 bytes block but performance are divided by 4.
> 
> Do you propose something else?
> 
> Thanks,
> Laurent

Maybe min(size, sizeof(vi->data))?

-- 
MST

