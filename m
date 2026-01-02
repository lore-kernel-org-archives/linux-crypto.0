Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0E8276051
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767358967; cv=none; b=kkpbU5E06jwSqnglsn9tM7+/HQy7ezTchZR9nYjbPk/TuEkefTNTDmtatTxi23Ogy4APNKI9Q/GL2H2tKWPOEcTNE0GTWsWE0QaeEfBC04L8c1b/JOzXxjLdcFQj2ZqGU5uGZdj+Eni0GE99NpodJqkuyG/9cEBJwWpbX8jKUmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767358967; c=relaxed/simple;
	bh=MzslOykd8x14UYRASjqMHG8WwlyrJUbVhQ0wOUaMEeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVBLHnJVY64/P5lkDja1IlGFqII3lMa4EQ5w7tU6UoZUrUzxQuPNKjRTHIdqW99DWdH+FkFmpEQ0ray3UYNGm1aKVgs5NcqAxe74pklUq6DJVnUv+V2buHtX9DSiMds2cv+qVRmRTt7HcXGv4FZ+NLXhfEVInr71+bPjCxynckQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y06vawIW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ruf3khPa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y06vawIW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ruf3khPa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767358964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WmDmlKfsEAT3FFZsP/TiPm94jNR+IqB/SohCa4X10es=;
	b=Y06vawIWBnbKDzI2gaRETBnHIbrgy6y5/pCIkANcKyzqiSl+5oyDSeQt/2VIuzE22+AP+e
	WWCfB85rSIy2LBTgIDGJTofUcl8H1Iqa4E9cAFfX3LQjKqMvBljvsZV57l9hvnpzbLgtQP
	SR1/eBMt5382jEX2inMjIOa5NxEbMCQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-I8lQnLpsOfuZdnO0btzDKg-1; Fri, 02 Jan 2026 08:02:43 -0500
X-MC-Unique: I8lQnLpsOfuZdnO0btzDKg-1
X-Mimecast-MFC-AGG-ID: I8lQnLpsOfuZdnO0btzDKg_1767358962
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47d1622509eso73534195e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 05:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767358962; x=1767963762; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WmDmlKfsEAT3FFZsP/TiPm94jNR+IqB/SohCa4X10es=;
        b=Ruf3khPaNH8M9NxijcWmnqF1uGroWh2HoBxkyeczM+hJb4+uD/NOyRdvR+09ZwKHGJ
         burTy8fRY0gU/FLGFYWteU53mqULab/AUNyMBvoFqWMBrfCjdzymDZqlVLYp1lHifqfb
         HIcacXAF2RW6LIv9nwPSChhLRmIrO/gWssbsZlfD33VuDHNaZqwEq6i6fFRR0K9mej/b
         OFXwWJq/Hbo10sp18oOp2rvNyt2Dnqzk6jO7c6vjCRCIM5StfFKx3BecQIvBSjVY85eV
         IzC3xUDPskmvLiYurzGloEs4xsX8mInpc3Sdx8e52cskh8+aFahgk2EDs5E7Kibg354S
         Zfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767358962; x=1767963762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmDmlKfsEAT3FFZsP/TiPm94jNR+IqB/SohCa4X10es=;
        b=aX/e5ramf26lSqo5O/L/EjWCmQdTn1YOI6dtiY6rXZnkuxxp0TH1mjPN9HC8sTPVsO
         isxerZdKc4GZ93gwdxqybp860NPE4xGErQIpLAmHKgukkNFoxCnwzbg8yU0xVKyu7r7f
         lyhEr2SwvrEgEsNLMuVjuFSn3GS0aJlPu4nbxJcZuEHkKsd8VXybnUedk6qNHViyKESg
         /KbyaOZ5j62JcsglyWBt2MK83N1I6TrbbLdVbgJbduyx4gLK+4JEdeOLpDUS544tTYP+
         vLHu5xj20F53ieRsjR/iM2Y6J11IiHQo8jv4h/Ht7WhwTGRcS6q0wkQQHCkaBgrWpwxZ
         DzzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPon3zDTxEH3wXapquuuZLFeL5398mFVH1uvV/064l5BWe8dmCHdtI9ci15R7QqTjJM70y5xz8BGBpAn0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4bljJBq7r0JseAYEefIM1nLzdiJOrkLInxyo6VRcD/lQvWC4W
	OCfetr4vBCQtVBbQhUVY5L0Cgv+K+0MxRA1y8kC4Yvkdm5LaMZMeW9Vev0rK8hbZHkDFcXmxlwx
	r2yP1LyTkBCm5arMU3r58DYzJ9IpL6VWRleHybZ5KUkZHJyR549ktWaxxP5eV3A0JVQ==
X-Gm-Gg: AY/fxX42yzyBQi9k3E8BKp02J+G3tAMxKvl5nZ2Ct3vaVjBihGcfk4Wc3/qtzDsfWN/
	qoN7Ci2JB0HtbyggOBX5QMl0hGb3UUny+wtm7ZwnJNjRcRATPzKQ7McYwgP0qrqVZ0RHrBjtXUz
	TeJB/GBXBWL6c5PELYWLMArFE77/8qTOUYTfHvYhDCTky5xSFYQXx1mEvUyJCQQVqlgpn6ZapVo
	rWS1aCQ6E7G6xKLitLdll5MEXDclEcYdNngLehajiZzXECFXxKSM7NwZDkkYDZccQfeaP/QdJlS
	PPMMxBqXwC2+KDTEnsc7CXyOfs0sVmW2ZEgGxKcsV2hQVm2S295byUHdRb/kGhGy5dTqFqGoo+Z
	NYm+SplUNCkVOebfFyi3vcuE6iqnfyybu6w==
X-Received: by 2002:a05:600c:3508:b0:477:1bb6:17de with SMTP id 5b1f17b1804b1-47d19590bbemr512375265e9.30.1767358962196;
        Fri, 02 Jan 2026 05:02:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBPpH0ihQmD8Y4wAGqUXdjbUDmUwQhrGC4bvR7Khhg9b0D8Nv1fILL/X18iGX7aRdaW+Lc0w==
X-Received: by 2002:a05:600c:3508:b0:477:1bb6:17de with SMTP id 5b1f17b1804b1-47d19590bbemr512374585e9.30.1767358961687;
        Fri, 02 Jan 2026 05:02:41 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4e91sm720685835e9.13.2026.01.02.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 05:02:40 -0800 (PST)
Date: Fri, 2 Jan 2026 08:02:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bartosz Golaszewski <brgl@kernel.org>
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
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>, linux-gpio@vger.kernel.org
Subject: Re: [PATCH RFC 15/13] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <20260102080135-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>
 <CAMRc=MfWX5CZ6GL0ph1g-KupBS3gaztk=VxTnfC1QwUvQmuZrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MfWX5CZ6GL0ph1g-KupBS3gaztk=VxTnfC1QwUvQmuZrg@mail.gmail.com>

On Fri, Jan 02, 2026 at 12:47:04PM +0000, Bartosz Golaszewski wrote:
> On Tue, 30 Dec 2025 17:40:33 +0100, "Michael S. Tsirkin" <mst@redhat.com> said:
> > Reorder struct virtio_gpio_line fields to place the DMA buffers (req/res)
> > last. This eliminates the need for __dma_from_device_aligned_end padding
> > after the DMA buffer, since struct tail padding naturally protects it,
> > making the struct a bit smaller.
> >
> > Size reduction estimation when ARCH_DMA_MINALIGN=128:
> > - request is 8 bytes
> > - response is 2 bytes
> > - removing _end saves up to 128-6=122 bytes padding to align rxlen field
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/gpio/gpio-virtio.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> > index 32b578b46df8..8b30a94e4625 100644
> > --- a/drivers/gpio/gpio-virtio.c
> > +++ b/drivers/gpio/gpio-virtio.c
> > @@ -26,12 +26,11 @@ struct virtio_gpio_line {
> >  	struct mutex lock; /* Protects line operation */
> >  	struct completion completion;
> >
> > +	unsigned int rxlen;
> > +
> >  	__dma_from_device_aligned_begin
> >  	struct virtio_gpio_request req;
> >  	struct virtio_gpio_response res;
> > -
> > -	__dma_from_device_aligned_end
> > -	unsigned int rxlen;
> >  };
> >
> >  struct vgpio_irq_line {
> > --
> > MST
> >
> >
> 
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

Thanks! There's a new API as suggested by Petr so these patches got changed,
but the same idea. Do you want me to carry your ack or you prefer to
re-review?

-- 
MST

