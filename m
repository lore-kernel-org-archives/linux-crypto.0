Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D8BC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 19:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF3161156
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 19:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbhIVTDr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 15:03:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237146AbhIVTDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 15:03:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632337336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YkGM074Sqzm2cnA7q+tjffVmS5yQ7D3vt1VWpyzRhSw=;
        b=QW+4WLKUCfc6bs5o2X33mOSeRtA0Mx8Pttr3DLinbjCQtmIIrtV7dUhJX/zMuyWppctRE5
        yWIJUVU7OQ19+6saV9zSeQP9AnFDdbvfQfaa97wyJQtJVhJQFNxFS+mnX6ics8ooi+/+tj
        UZTMyjfiRgoPhY5ucfGMj9nhR2MnLgk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-2tYS08dhOyur1VpG_bCAuA-1; Wed, 22 Sep 2021 15:02:15 -0400
X-MC-Unique: 2tYS08dhOyur1VpG_bCAuA-1
Received: by mail-wr1-f72.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so3051231wrv.6
        for <linux-crypto@vger.kernel.org>; Wed, 22 Sep 2021 12:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YkGM074Sqzm2cnA7q+tjffVmS5yQ7D3vt1VWpyzRhSw=;
        b=bTPQX1zrzaPsrpaDpsvf1el5Q9zZhbMnDrByo+sCf48NUStyzcd1L/Bc/URq5TUlq7
         cHSWe90Ik91TDnyMwGwBNuU/Vdm9GvkG3+dck9C6Oqd88AJR7U5N+Z6ZDa6gA5eG0sl0
         ods7om+Z2iKPtClVFmG4xTto7tXH5LIm/4XvhcwlP3lbT13vp6QEwevxwqnauXoA5O14
         G7pIUrx/1J0hlAukoNso3zdRHPNb0N4UmgiOh9Jb7YQX+Y8d2hO/G/2S3yMFicen5A0Z
         98pI/G+Oik1EMKNVQmvo0weh+LU7C36yXNiSDzN5/3SRqFt02MD8dPqvTD75v74/lZ36
         QgGg==
X-Gm-Message-State: AOAM532GRzpkjEUJ/PBub8USWwnTETA6ekk7hN2KQnK3VLTkHVLrUAAf
        oTKRDF6/y7XtYHgUi2hqaLWNIMZjyIJjTSZeSUkmv+sMR7/W7nFt4Ip0Vr4iYP8IXCpF3tHiVU5
        /GRqsW4fHZ957OclWUSq5cZx6
X-Received: by 2002:a5d:688a:: with SMTP id h10mr566218wru.331.1632337333591;
        Wed, 22 Sep 2021 12:02:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1QZokQycw03rSq+x5aZ0qJCIjw+WMM0ILYk/1Fa7uZgHUbxN1UVcifVfv8Bu6EbjHNVe80A==
X-Received: by 2002:a5d:688a:: with SMTP id h10mr566190wru.331.1632337333363;
        Wed, 22 Sep 2021 12:02:13 -0700 (PDT)
Received: from redhat.com ([2.55.11.56])
        by smtp.gmail.com with ESMTPSA id y8sm2972877wrh.44.2021.09.22.12.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 12:02:10 -0700 (PDT)
Date:   Wed, 22 Sep 2021 15:02:06 -0400
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
Message-ID: <20210922145651-mutt-send-email-mst@kernel.org>
References: <20210922170903.577801-1-lvivier@redhat.com>
 <20210922170903.577801-2-lvivier@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922170903.577801-2-lvivier@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 22, 2021 at 07:09:00PM +0200, Laurent Vivier wrote:
> hwrng core uses two buffers that can be mixed in the
> virtio-rng queue.
> 
> If the buffer is provided with wait=0 it is enqueued in the
> virtio-rng queue but unused by the caller.
> On the next call, core provides another buffer but the
> first one is filled instead and the new one queued.
> And the caller reads the data from the new one that is not
> updated, and the data in the first one are lost.
> 
> To avoid this mix, virtio-rng needs to use its own unique
> internal buffer at a cost of a data copy to the caller buffer.
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  drivers/char/hw_random/virtio-rng.c | 43 ++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index a90001e02bf7..208c547dcac1 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -18,13 +18,20 @@ static DEFINE_IDA(rng_index_ida);
>  struct virtrng_info {
>  	struct hwrng hwrng;
>  	struct virtqueue *vq;
> -	struct completion have_data;
>  	char name[25];
> -	unsigned int data_avail;
>  	int index;
>  	bool busy;
>  	bool hwrng_register_done;
>  	bool hwrng_removed;
> +	/* data transfer */
> +	struct completion have_data;
> +	unsigned int data_avail;
> +	/* minimal size returned by rng_buffer_size() */
> +#if SMP_CACHE_BYTES < 32
> +	u8 data[32];
> +#else
> +	u8 data[SMP_CACHE_BYTES];
> +#endif

Let's move this logic to a macro in hw_random.h ?

>  };
>  
>  static void random_recv_done(struct virtqueue *vq)
> @@ -39,14 +46,14 @@ static void random_recv_done(struct virtqueue *vq)
>  }
>  
>  /* The host will fill any buffer we give it with sweet, sweet randomness. */
> -static void register_buffer(struct virtrng_info *vi, u8 *buf, size_t size)
> +static void register_buffer(struct virtrng_info *vi)
>  {
>  	struct scatterlist sg;
>  
> -	sg_init_one(&sg, buf, size);
> +	sg_init_one(&sg, vi->data, sizeof(vi->data));

Note that add_early_randomness requests less:
        size_t size = min_t(size_t, 16, rng_buffer_size());

maybe track how much was requested and grow up to sizeof(data)?

>  
>  	/* There should always be room for one buffer. */
> -	virtqueue_add_inbuf(vi->vq, &sg, 1, buf, GFP_KERNEL);
> +	virtqueue_add_inbuf(vi->vq, &sg, 1, vi->data, GFP_KERNEL);


BTW no longer true if DMA API is in use ... not easy to fix,
I think some changes to virtio API to allow pre-mapping
s/g for DMA might be needed ...

>  
>  	virtqueue_kick(vi->vq);
>  }
> @@ -55,6 +62,8 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
>  {
>  	int ret;
>  	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
> +	unsigned int chunk;
> +	size_t read;
>  
>  	if (vi->hwrng_removed)
>  		return -ENODEV;
> @@ -62,19 +71,33 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
>  	if (!vi->busy) {
>  		vi->busy = true;
>  		reinit_completion(&vi->have_data);
> -		register_buffer(vi, buf, size);
> +		register_buffer(vi);
>  	}
>  
>  	if (!wait)
>  		return 0;
>  
> -	ret = wait_for_completion_killable(&vi->have_data);
> -	if (ret < 0)
> -		return ret;
> +	read = 0;
> +	while (size != 0) {
> +		ret = wait_for_completion_killable(&vi->have_data);
> +		if (ret < 0)
> +			return ret;
> +
> +		chunk = min_t(unsigned int, size, vi->data_avail);
> +		memcpy(buf + read, vi->data, chunk);
> +		read += chunk;
> +		size -= chunk;
> +		vi->data_avail = 0;
> +
> +		if (size != 0) {
> +			reinit_completion(&vi->have_data);
> +			register_buffer(vi);
> +		}
> +	}
>  
>  	vi->busy = false;
>  
> -	return vi->data_avail;
> +	return read;
>  }
>  
>  static void virtio_cleanup(struct hwrng *rng)
> -- 
> 2.31.1

