Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1754933123B
	for <linux-crypto@vger.kernel.org>; Tue,  6 Jan 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711012; cv=none; b=bvhCLqx1+6wIUcpGSsbiRIZucNYmYvgvBVPF93xfMFkMsgcVrNQfXODexJ3aeUoMAx5gZqIYm8BHFqIyCD/TrKwfH8sChRZAioQeQypY7m7XLJ0Xd+Q1JDQ8U25U9PUul42mn4AuPIcpVndAGeWBdRdHVkhFvuMRXVjMcYgT2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711012; c=relaxed/simple;
	bh=RqfJjI32FdZ7MpeaFMqvXp4bO7LyOB4RofYVb7BWxmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nu5QZS/SrZ31K8k+tuiBkdnqIM9hc4VHpJaNIQbxXLOHcuwl6Y4zT0YWFy3QW4ok4KpON11TDCBmQwHOIY+gmq3kIoYiI1zmsH2zX9RTLSzPAW3zlHBxWXds9KAKahBrn+9CL+qOv0yebNvAlQVH4dWQN6eVXwkKnxTcJ6mrHTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6N9B7rq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aoAHoHrm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6N9B7rq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aoAHoHrm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767711008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
	b=Q6N9B7rqBOy0edULfnPlNXw7pyLqnuaZ2kNeNi/0yvEpuUlPAM74/ALShcP0D8LK8pl7aE
	RyAIL7DkJq/N2Ik4ubtpFZ3y3dt9u5EJyLMNZ0u8EGrDZmXZAP3Y4N4X5EElvXoGhAjASm
	9e+El8SlpopjnrZbBE0ZpFD7PJKDNUA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-N25-La51NYuZT2ZpApm1JQ-1; Tue, 06 Jan 2026 09:50:06 -0500
X-MC-Unique: N25-La51NYuZT2ZpApm1JQ-1
X-Mimecast-MFC-AGG-ID: N25-La51NYuZT2ZpApm1JQ_1767711005
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so10907905e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jan 2026 06:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767711005; x=1768315805; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
        b=aoAHoHrmwMZxBs2Qp69OPcSFyaa1ig8teHOPJlTckRJ36lo6MAUEbtcC31JPG6FdXt
         r8wn0YoUmXby44f4lHbgR1uSQGC250mufP2o8GPX7n8jjsh3a/4d0o7zyVeYiY7or4wP
         5fNAD2ypUG6iOfyMx50WuECY+vE25qV7VYCmDh2JcvSmkuCmk0jV6tgIRzf+JgvRWkZV
         /tyDnQ8+btDHVPo2V53lrmTUi6h1X5KXIFtPigLUhEhrf0OZfRoIPXQSNa8Sq6KPyslf
         ekrDkyLn4FoULpuMDI1pdSm/qjS0v7F1JRtZwgfRIfIsynaHmQ0FNYWqHLh8MavZgcjF
         OJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711005; x=1768315805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
        b=XE5hgHexbqrxru2WhzUfR2qeGStNG6kqZf4hQDUCpjo1ksJ7O/iigerf6EwDue/DXm
         5TMRt/EJojWSsrh76t477HT+538HmowbDJYkvAx6qmdmYUuf+BEKs/v5C6FLs7HzIHI1
         efD5b/iXDm6BaLcZe1vdJ9v9nA3rUyDdqon3hyW8qqZ8l1omdatWrvlAcEzgl1a+eNOW
         va+IAvoJC4KeT8Np/jZbDTA7q3XPIssFA4WyZfZzmaHfRWHLbIOxf2q5A4EOrC41eyJF
         Qd7czXuv/nfbFRHLcsuyWNtmDe/1X8NQgHcYCVvctJsXxdxukOvbGbNqqKWgQg+PweaA
         Z6LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHsRDWmLP9xEsgbflXo7BXVRuh+8FUjfb4d4XeqoAuOTSRVv9NyIPhsAkxR0KUK7i2YJ3tIPLcVWzD1z0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhd2WRvgAtZrvxRYiOt1TxelyM19uFY6hHbQa6+Wh+4r62ijZm
	91KX1YpfQMkeg81G7hL2fk/x9O+HTroWPTagCdRbGwHmPgUzMXkQ3lOWqS6lOAma7lT9CJealH6
	fNZVsClyu1pKURW1PfI9p5BxsXzMF8gLuypVbaRw0UcPDlF/DJwKjyxq+UjGrNGcyRA==
X-Gm-Gg: AY/fxX4+1+84xWteLJK2BHFYIYoJVR8w5UR93Obu4stuzuHidbnVASA/4m+uAu7EzRI
	fekP6khDif8OK8hMjDBuYiqLW9LzAF8dp/I+FIFSxZjeov6qpwRjv77zwPP1szyzh7cUXkoc9X7
	JPtLFcBP+VQ1K4VsCnOH4+V0G+t0XoD8GO3JktRC6vy+8t4HemIROglJSg+biK8JFKqLc8qv3Tx
	ACDUXqBtwFO8ykepDWKFZzmZlBHhEnvsY+SjbxqvLEimYLIrN0vK3QsMlB1LwXqdAI5rYGLHmdN
	7LPEg4N8uoaPlSosKtFbvF+HrnbrwsxWqUFLMxLyjjuMDDRItIIrywzLJ0N5ElhQ7PudWhWTTs8
	CXOfqm/oWOLdtR6PHbvXS/JFiQmE9wM2nrA==
X-Received: by 2002:a05:600c:c0c5:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-47d8383d75cmr7820695e9.23.1767711005512;
        Tue, 06 Jan 2026 06:50:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXHeGoEH1PxicAu3pvp2IKmLzneQBM5bSFfOKMFfLat4mQRdOWLJ6nIuVR4bStC0oG3LJdHw==
X-Received: by 2002:a05:600c:c0c5:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-47d8383d75cmr7820345e9.23.1767711004990;
        Tue, 06 Jan 2026 06:50:04 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f695956sm48129575e9.6.2026.01.06.06.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:50:04 -0800 (PST)
Date: Tue, 6 Jan 2026 09:50:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <20260106094824-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
 <20260105181939.GA59391@fedora>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105181939.GA59391@fedora>

On Mon, Jan 05, 2026 at 01:19:39PM -0500, Stefan Hajnoczi wrote:
> On Mon, Jan 05, 2026 at 03:23:29AM -0500, Michael S. Tsirkin wrote:
> > @@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
> >  
> >  struct virtio_scsi_event_node {
> >  	struct virtio_scsi *vscsi;
> > -	struct virtio_scsi_event event;
> > +	struct virtio_scsi_event *event;
> >  	struct work_struct work;
> >  };
> >  
> > @@ -89,6 +90,11 @@ struct virtio_scsi {
> >  
> >  	struct virtio_scsi_vq ctrl_vq;
> >  	struct virtio_scsi_vq event_vq;
> > +
> > +	__dma_from_device_group_begin();
> > +	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
> > +	__dma_from_device_group_end();
> 
> If the device emits two events in rapid succession, could the CPU see
> stale data for the second event because it already holds the cache line
> for reading the first event?

No because virtio does unmap and syncs the cache line.

In other words, CPU reads cause no issues.

The issues are exclusively around CPU writes dirtying the
cache and writeback overwriting DMA data.

> In other words, it's not obvious to me that the DMA warnings are indeed
> spurious and should be silenced here.
> 
> It seems safer and simpler to align and pad the struct virtio_scsi_event
> field in struct virtio_scsi_event_node rather than packing these structs
> into a single array here they might share cache lines.
> 
> Stefan


