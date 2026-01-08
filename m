Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F923EC835
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882754; cv=none; b=Q2dsJWrDg/BA6Br3wSbqnugCcO3Flkjo8anmTFVFKPQseBulGDoSlOLWcpQ0wn+zaimSjIgmZ7sjSGSXjQj9zyTdrJfSm0mfJExqnSImkQczQHE6/qPinvb1792n9rnEOAM8Imoj1Mvs1nE6p3piNax4ZtyjgKHEU6KA5EKCxTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882754; c=relaxed/simple;
	bh=/ul1MI70WNuWUatNq9QXmWY0n1CnY3rQPVMj9RML37Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4VBnNRpT5hG5czFXblFIQ7oVuw+vou9H0KsfVCtOcRO03C79SVhF+UVNUIsgMmQ3hSAJZ7CyeEMRiXxxmR00CH9BDo08/Epm1MLpH+SKfxesDaTlyeh8PiZ+ewaxGHjKwzGW0sjG60M1rWz9asepBDO5Srk0GiT99icnKuozwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bIcUG7v2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cNSjTGmp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bIcUG7v2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNSjTGmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767882751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQ5KldlPLZnW3hZQd/TnLSW7zs03bZTdFv6fpQxf5uk=;
	b=bIcUG7v2nKz9oYVi2iLvIZtWoX845PSheZ69CviFgrx/Ct6iQ8mcdjoyvXTVP/EGFy2uW3
	36CrIHPsFXWZqLoPcbDPuVEBiYstHoHPnfoYDh0GbqN50utWDMdahp/Va3mocrfsg1j4yw
	Kpo5hLdDQpMA1PWCYDcowCMl2HWXmoY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-KUhVhvXwNsauAjnG9WdVEA-1; Thu, 08 Jan 2026 09:32:30 -0500
X-MC-Unique: KUhVhvXwNsauAjnG9WdVEA-1
X-Mimecast-MFC-AGG-ID: KUhVhvXwNsauAjnG9WdVEA_1767882749
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477964c22e0so17235275e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 06:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767882749; x=1768487549; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ5KldlPLZnW3hZQd/TnLSW7zs03bZTdFv6fpQxf5uk=;
        b=cNSjTGmpx2OD2hbzzk3iGl0ks+3AWSN4ekaGROqtixhA1W5CXwAK9Q8hAEQ2IhDoOQ
         GJPpxXjTL0yAhiyZx/3uubM8MJDpcXcY5dAroyeNsPAyFttbm7+2cFWnMB2izCT9nHLf
         DBhwMOhjmco0/QadOCZFMYAt2THMFQRLd7+HRDptXW7IS1lu9vYP/o/b5NK1xkgz0asm
         kqHa0RlaVQUuE4VRbcCulMsS2Y4vzDdhvjmeDZ6WlOeMPB6BCW7ti45d3vksKd+4n2/Y
         Cc6yYYrMc0meN3CEnfOrHmAkhqaP7FUHwxMY8bv64L6b0ttsJ4mUqm+1f5iwYmKWCL7x
         PzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767882749; x=1768487549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ5KldlPLZnW3hZQd/TnLSW7zs03bZTdFv6fpQxf5uk=;
        b=MNarmoedA1f/E/A3OKqMCom8n5FZR/aC+hR67jFQ6bA0dFNrKvG6RZq/7/up7PCyQL
         xtoGnFDEw+5FGSfAa46bWULcIlpZk4uwbCH0bvVyr4J2IqKT4mjRGl8eh2HCx9etfBHY
         MR3P3C5t2tF4bRw5Z1j1eW5vkxLassCbiLFD9K6HeiEVeTnH9W/7Z+bpAOSWxw7KlRwn
         RE7LVR/Ny/PxtaCqSGAMtNjXz6QWjX5mWgKnYAQ3TBdCAMp6I+ZVmnGw8hlulzbYd3BH
         3g2Hi4m1eHW10sI9SbpWgFMnMcj7FfHdtAWZjrRC0V63UwzEtw4yICuwThos9WGYqLSG
         WHBg==
X-Forwarded-Encrypted: i=1; AJvYcCX7/aptYyAne//1AKb4/AwnWO7BK8qOgdB0UV/99FBLpHjp+LoOtkA2NveJL2W3Bkza0sdjjUHkWJ7oZl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8oOgHhTC0oVLWzeYKTkLtyc6cCRSXxJXUN1/3zHrdMRTmzod1
	GQCuiuamSjOBSUM1Y/BP4btReiRWnyzcIH+7lS7EQWBpnRJqxk3HN8tL1VO4N/bFfRUK92Y48+6
	u3nUYxkHQtnB5A/QB0LzCljLrBNbo+AQ311jN263U6K8wmd2Kv5xokhIOyOhHgzSz0w==
X-Gm-Gg: AY/fxX7E6uOw8v0KwRoTyppCNfqr5Lpcx81BCktGZkppXyyGHKH0mtbd6Qet/i5BCOC
	gervaimDRGPk9/rX6hSQ21iXQP+lZSMd3ckJjAEo+M1CMDz6An8mvdhT5TVkElxvo6NshY+bsRq
	e9HsvJ4CjVl1yr0GE8o/x2ly7b+i99U73Ne+/ACVru0QUrvTOvus0QnyIzfDeY/LmM81wx2SG/A
	WDLlF3TAUqob36a5hLxcMK/hA5Ogk6Eq0WdBHxGucFj7KrgUvLrNqNeBS5l57nHx3Xats4WggIh
	F01QJv2TdrKThN1gPIv/ZYi3KG/QYBzqFasFYPUrFfAfppbI9eBsKwmhmOXQNz8//kmtZ9IvJYF
	s7XEgxeKOdcKCu2GzK9q84EG7i+hiblAqXQ==
X-Received: by 2002:a05:600c:6c95:b0:47a:8383:f2b2 with SMTP id 5b1f17b1804b1-47d7f63722dmr100357975e9.17.1767882748602;
        Thu, 08 Jan 2026 06:32:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7Gl8OtqeQkvPJx1M3QhvEhlvzebP4MIt/f4g31duD4E6Ii6eayAMa8grqHGKZjLNtnJFSpw==
X-Received: by 2002:a05:600c:6c95:b0:47a:8383:f2b2 with SMTP id 5b1f17b1804b1-47d7f63722dmr100357545e9.17.1767882748121;
        Thu, 08 Jan 2026 06:32:28 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8717d78fsm38131185e9.9.2026.01.08.06.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:32:27 -0800 (PST)
Date: Thu, 8 Jan 2026 09:32:23 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <20260108092931-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
 <aV-6gniRnZlNvkwc@sgarzare-redhat>
 <20260108091514-mutt-send-email-mst@kernel.org>
 <aV-9F42fMfKGP4Rg@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV-9F42fMfKGP4Rg@sgarzare-redhat>

On Thu, Jan 08, 2026 at 03:27:04PM +0100, Stefano Garzarella wrote:
> On Thu, Jan 08, 2026 at 09:17:49AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 08, 2026 at 03:11:36PM +0100, Stefano Garzarella wrote:
> > > On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
> > > > Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
> > > > last. This eliminates the padding from aligning the struct size on
> > > > ARCH_DMA_MINALIGN.
> > > >
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > > net/vmw_vsock/virtio_transport.c | 8 +++++---
> > > > 1 file changed, 5 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index ef983c36cb66..964d25e11858 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -60,9 +60,7 @@ struct virtio_vsock {
> > > > 	 */
> > > > 	struct mutex event_lock;
> > > > 	bool event_run;
> > > > -	__dma_from_device_group_begin();
> > > > -	struct virtio_vsock_event event_list[8];
> > > > -	__dma_from_device_group_end();
> > > > +
> > > > 	u32 guest_cid;
> > > > 	bool seqpacket_allow;
> > > >
> > > > @@ -76,6 +74,10 @@ struct virtio_vsock {
> > > > 	 */
> > > > 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> > > > 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
> > > > +
> > > 
> > > IIUC we would like to have these fields always on the bottom of this struct,
> > > so would be better to add a comment here to make sure we will not add other
> > > fields in the future after this?
> > 
> > not necessarily - you can add fields after, too - it's just that
> > __dma_from_device_group_begin already adds a bunch of padding, so adding
> > fields in this padding is cheaper.
> > 
> 
> Okay, I see.
> 
> > 
> > do we really need to add comments to teach people about the art of
> > struct packing?
> 
> I can do it later if you prefer, I don't want to block this work, but yes,
> I'd prefer to have a comment because otherwise I'll have to ask every time
> to avoid, especially for new contributors xD

On the one hand you are right on the other I don't want it
duplicated each time __dma_from_device_group_begin is invoked.
Pls come up with something you like, and we'll discuss.

> > 
> > > Maybe we should also add a comment about the `ev`nt_lock`
> > > requirement we
> > > have in the section above.
> > > 
> > > Thanks,
> > > Stefano
> > 
> > hmm which requirement do you mean?
> 
> That `event_list` must be accessed with `event_lock`.
> 
> So maybe we can move also `event_lock` and `event_run`, so we can just move
> that comment. I mean something like this:
> 
> 
> @@ -74,6 +67,15 @@ struct virtio_vsock {
>          */
>         struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
>         struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
> +
> +       /* The following fields are protected by event_lock.
> +        * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
> +        */
> +       struct mutex event_lock;
> +       bool event_run;
> +       __dma_from_device_group_begin();
> +       struct virtio_vsock_event event_list[8];
> +       __dma_from_device_group_end();
>  };
> 
>  static u32 virtio_transport_get_local_cid(void)

Yea this makes sense.

> 
> Thanks,
> Stefano

