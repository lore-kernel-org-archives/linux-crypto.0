Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E0926ED2A
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767192045; cv=none; b=MkU+uYMC3IM1hxyjW8FhMOtRtyO1WWymZbIYJUkrLjicxPUyEN/Z/2cZTnhTr3pc+ezH3bG9iKY2VkZiFArohciyuL15XNnHqu8i5GVo7lIGReXezjD4oCZRyY/n8k1p4++MhfpT0pFw2ksIffQ2QSnczvGwGRvNz3AFr7BkswU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767192045; c=relaxed/simple;
	bh=uCJpKbQgK1JDZeWrhG0sD4sWy8cW8kDi8pCaSJxqzWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJrHxMY3xjWOZJ/YhZokPyspDi0GVI2SXt6eA6pthK6ZpJKgzp6lTUwNR1Y7SKSLnsTuNjLQHm0mtAcaJiTBeTrBs2RK1it9hEVpOwXaCaObTMbdwoAyHRk+GRpgspemwhTBK3yI+kZzT1Z4VT0PeFEzfLok8l86mQRoMAiNRt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5iYxZnv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OUPcxx4T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5iYxZnv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OUPcxx4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767192042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n0eNh1PwPkp66fDhwYL8c44iVldZ6MxzxhBv6XJLUek=;
	b=J5iYxZnvSQIqmiKLOTWoOeC+n5Y1mDaq769ttcC9zSfqvV+Ssn7pW0XZ4NmkxLzIfS271D
	/0rAD+fTtuzejdPzCeMA9ed/KpI5ut0VR4vWzIKHMGY22HdD9+ah8zturKbgLo6nE/Gx+i
	ONnkIvAdublIwQUppAkGQP4W/WoK7kU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-g_RhFyzuMM2lqoo3lJD5kQ-1; Wed, 31 Dec 2025 09:40:40 -0500
X-MC-Unique: g_RhFyzuMM2lqoo3lJD5kQ-1
X-Mimecast-MFC-AGG-ID: g_RhFyzuMM2lqoo3lJD5kQ_1767192039
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so109869855e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 06:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767192039; x=1767796839; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n0eNh1PwPkp66fDhwYL8c44iVldZ6MxzxhBv6XJLUek=;
        b=OUPcxx4TcY8oIazW0j05RQ+fBwXK6dVnvRKGVVtsfOea04Jdvd7GJs4iaLtSJ27Yfy
         SMhJHXnaZyuB38co1vH7ROc+20AWAIKUV3FLm0wqz89/a4OoH0rejlT0OatejEoZye+r
         +S0PJZgV5f8riwSnNknTY1CeMcu0Y/KSglDf/Z8U+XGy2byq8cK/+zmIcpOIKYuKlSQ3
         8alwrl9vDI+MpaonjOc/8FuYyyjoJMGNMImUFcUG7ExRe3p6KMTgYLbmpsjUmItGvwpb
         JrlzLRpaxJe09bL7vC5PaXdLyK470z4j3bo8x3RQAwqjeSWPIwqDGquJ4ghBMjhXXWJI
         /lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767192039; x=1767796839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0eNh1PwPkp66fDhwYL8c44iVldZ6MxzxhBv6XJLUek=;
        b=iBG+3GcKREFm2Ju3UgPQroZUrI7BFRn2I4uPpbOvFNGbs9EyiB7DLH47dHSQnYwMQQ
         62BSuOvo3CNl8nPOKr489+FE88MjIpmOOeJ/b8Pp8/3PuK746sNLcxVB1hjIO2eXNrZc
         s/3kSizU6PbuIHxUdCWfeqp1Kri0jCTOnDvSuTMFl9G/hPT96TDuNgDyz8CkKOKHlcDo
         b6s0rP6MrLI0GDtx9svCB/DhHN7/ynbbHZ2etmy6IbAhDRz/Ld4g/43EMbMHEwQikbmX
         /1BP65hzwZHFfjdRa1eiOmTW0azKvGkzDQLwIsyZpB5a3PRy9hoO7U496AhRXXJewg2H
         /SNg==
X-Forwarded-Encrypted: i=1; AJvYcCVssK+2SDSRpH7awhQs8EuOpUaaL9hLM8wf6CTOdjE/enHmT1SSu2GgZwgdfQn2TXui5xZRnN+4I9NCBJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwmQ348MrQV2y6tn5lEp4Z5zGzur7vIaVr5RdKpAW7jmtsxOhg
	pdWy8+iXifkIC3JP4OlNu2zPpT3mTtY7fgUZWoopWa1CF9yU1QA9CVpUrzwz9r1r2Z7PG1SrO30
	mnlOOPU+BIMfYp8sMacR7ULQGRUBKtr+Ph7STbOeoCMqXeES8ZbyxZvXNFBud8y0SEg==
X-Gm-Gg: AY/fxX6KhU8Zr4jBDix/aBz/Qs4R3tqAZ9s+AzFAKOw32RxKw6/bXhA+FODNCm4Jsrb
	N7kOju8eSKNaLAVEQYffE/Em8lntxH3BQ6q39+M7iSIaWJ85+V5XGJF3EasG9rGgCWZhqW2o6Dr
	hAYUGkoVFCQ/E+Zf1UFiisvBjeF/wRXOWufzVVHYoERzZIpsNbOwMJ0kvT0q1cB5OKkkxc0eoVa
	f7c9uQpQ++hxjRHtS0S5yPdlimrKh0iPFd16+FKlNgI9jiLUW2d1zBY68KFp+fIDVx9cT5Vjg44
	h8tWhAymxocnMuLmmPuq/pe7R9dOIYxlOouv1Nb2HORrSiWWbAxqtVTSxVIVNWYobNzoQXmT1rE
	IaZ4FAmKZCTDzsZdJZOdzKRoMEbS+rkictA==
X-Received: by 2002:a05:600c:1d29:b0:477:1af2:f40a with SMTP id 5b1f17b1804b1-47d1957f946mr504015575e9.17.1767192039253;
        Wed, 31 Dec 2025 06:40:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFftjQcUwvXMCaEXUnp/nGSfuL085M1yJ9YObPox1uDg3/ci/kM4qMkiO89pT6mz04eQEDKgA==
X-Received: by 2002:a05:600c:1d29:b0:477:1af2:f40a with SMTP id 5b1f17b1804b1-47d1957f946mr504014855e9.17.1767192038655;
        Wed, 31 Dec 2025 06:40:38 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be2724fe8sm835831745e9.1.2025.12.31.06.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 06:40:38 -0800 (PST)
Date: Wed, 31 Dec 2025 09:40:34 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Petr Tesarik <ptesarik@suse.com>
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
	Simon Horman <horms@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 01/13] dma-mapping: add
 __dma_from_device_align_begin/end
Message-ID: <20251231092346-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
 <20251231150159.1779b585@mordecai>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231150159.1779b585@mordecai>

On Wed, Dec 31, 2025 at 03:01:59PM +0100, Petr Tesarik wrote:
> On Tue, 30 Dec 2025 05:15:46 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > When a structure contains a buffer that DMA writes to alongside fields
> > that the CPU writes to, cache line sharing between the DMA buffer and
> > CPU-written fields can cause data corruption on non-cache-coherent
> > platforms.
> > 
> > Add __dma_from_device_aligned_begin/__dma_from_device_aligned_end
> > annotations to ensure proper alignment to prevent this:
> > 
> > struct my_device {
> > 	spinlock_t lock1;
> > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > 	__dma_from_device_aligned_end spinlock_t lock2;
> > };
> > 
> > When the DMA buffer is the last field in the structure, just
> > __dma_from_device_aligned_begin is enough - the compiler's struct
> > padding protects the tail:
> > 
> > struct my_device {
> > 	spinlock_t lock;
> > 	struct mutex mlock;
> > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > };
> 
> This works, but it's a bit hard to read. Can we reuse the
> __cacheline_group_{begin, end}() macros from <linux/cache.h>?
> Something like this:
> 
> #define __dma_from_device_group_begin(GROUP)			\
> 	__cacheline_group_begin(GROUP)				\
> 	____dma_from_device_aligned
> #define __dma_from_device_group_end(GROUP)			\
> 	__cacheline_group_end(GROUP)				\
> 	____dma_from_device_aligned
> 
> And used like this (the "rxbuf" group id was chosen arbitrarily):
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin(rxbuf);
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end(rxbuf);
> 	spinlock_t lock2;
> };
> 
> Petr T

Oh, that's a clever idea!

Will do! And GROUP is optional if there's only one group in a structure.


> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/dma-mapping.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index aa36a0d1d9df..47b7de3786a1 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -703,6 +703,16 @@ static inline int dma_get_cache_alignment(void)
> >  }
> >  #endif
> >  
> > +#ifdef ARCH_HAS_DMA_MINALIGN
> > +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> > +#else
> > +#define ____dma_from_device_aligned
> > +#endif
> > +/* Apply to the 1st field of the DMA buffer */
> > +#define __dma_from_device_aligned_begin ____dma_from_device_aligned
> > +/* Apply to the 1st field beyond the DMA buffer */
> > +#define __dma_from_device_aligned_end ____dma_from_device_aligned
> > +
> >  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
> >  		dma_addr_t *dma_handle, gfp_t gfp)
> >  {

