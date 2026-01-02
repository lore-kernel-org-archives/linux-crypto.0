Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C52D94A5
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 11:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767352659; cv=none; b=PMMEjLgB0Dg3TKIpRR3qprdVCdN8NYVFWveRqpFLRFCLAIEWvCwWrVdoOdqcJ7elPz3fN6GY3Y+45a1FR76LA5QyhLIsQsE/bxRgqurBqF20VTziGeyVp1PAIK6czYoQndQ03t/WdkSHh9YShZZEnQpFHfPZOLoZEG2phvolbbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767352659; c=relaxed/simple;
	bh=j+gjzPCCCvl+UXjwVGUBYvSZkC6L6hIK3UJ/XrmwLcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVSAlfbmykUYpEZzKkb7sCm3zLVee568ZmMOut50YxGQlx5D0Jp18672yOCW1Os2nwlrWhbnYu6/dT1Gaj+OOeJSKRZniSRnG5wBnys8MuyneHYPOzcdYs4LvbvOgJtjyn/rhMZq/R7lxkZv+L8SO9mC/NyBVoIroRjFLDmiu4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxLa9th3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OFiNjMgh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxLa9th3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OFiNjMgh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767352655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GCWlh8uBOmDSQEd79VDuimcUgjfVQxRp6qQ9KdZZbfc=;
	b=bxLa9th3CB1FYl0CJxgRcGw6+NaErVsT/OyzhoNg6EMnOyAt80kd65c5K0xH6OCvhqG0R3
	Xe0TfMMy7+V2ICp237oPH0eRTtP/TmGDUUp1ud08+PzDLHBco7bGiiFb0waRzPqG+Dro8v
	g0kyyAhs2hD0eFXkc2yd8Qj56nfi52M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-DjCWbOzmOROCZjIBF6fCUQ-1; Fri, 02 Jan 2026 06:17:34 -0500
X-MC-Unique: DjCWbOzmOROCZjIBF6fCUQ-1
X-Mimecast-MFC-AGG-ID: DjCWbOzmOROCZjIBF6fCUQ_1767352653
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477c49f273fso149803225e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 03:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767352653; x=1767957453; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GCWlh8uBOmDSQEd79VDuimcUgjfVQxRp6qQ9KdZZbfc=;
        b=OFiNjMghDz5ZfGRrUJQ9UHJtcEXhq/KsxmK+8JhcKE0fuWHKTeUWpUN9X4LJcDmQaj
         vhlR1dCDC5ePe8G+RPB3hu+xjnRYQsZB7TKM3kQjWrWlo75TNhvBJlTZdRfn+rPyLlPu
         9MzW50u2uD8JGuh53XSqSN1KU3fRUypYRCBJXJ/GnttT3Stf/FJmZvBIGxf5m6N732Le
         QuF61lzF7G7T/9+ACRJ5LM41zXpB3SxTozQLtw86CA1LgfOLP5jb7tczVa1ApKjPV9SR
         58Pq8JMDe6tmdBUxf5J3+b+lotYShBIBEhr1qgwkoXFcfa8K0WlzKqBaxE1evrdbqaYu
         AHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767352653; x=1767957453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GCWlh8uBOmDSQEd79VDuimcUgjfVQxRp6qQ9KdZZbfc=;
        b=tnuGjPr4LJcVkVq5L7kgn+sxHe6vWHcq5tqIMuYHLrsVuKpeL1AEScVBC5WcaUpz0/
         WfR/AFgqKZXL+XcSbJmmMaoYcKTPGK+ZO7rGHlckBZuqKQ0V4TRgBg2z4dMsy8QUAC3u
         vW8f7O8Kij0O/6Dxt1HNijsn+sFvxWgQmQCg8q8lnMSMIXeZ157drdPMjFH8Bd8RoUmW
         czZFmvloYWAkptEHnnyChcMBwtgJJBNiUYlU4qPrzNiBacthy+CCNhDyIUzLShcyHwBD
         yOB3cjajGEVcDASxfwYModUkp5Nmw2NsYZyQC43rTb7ZYkOlGCx/ZPlexbbhQRLqnWYH
         6UDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzDMMiSp/Pmompj+fVaDLfdFltd3Xxve4A0CoTnGvTWlpzVIgA7HMk1GhlRTCz9R1qWXzRH1/AT7IBb/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO1rqsJH0gAY0IXl0Jv9aRr8oEqpX7izOvVTg+Yf+cHh0nXNa+
	c8jdjLmlkkWQWN548aFdCCWuE9whLE8gc0Ul6XEjWxBTNiUu9Wj77wpM1ru57bgIAj7mW2WvC+1
	ChpcLb4V00d6pti5nEU4dKkA8/D8YsmgBFbStJNI9F0cGAPaPtpizqzlwcFkzzHY86Q==
X-Gm-Gg: AY/fxX4jz0+ibay7CCLgEQ/TX5kc5dNTUe9+ma93a55eLIkh0/S6PZP8nEwm7N4AJMx
	MuG6NWdLPqZFo+0rxqZSbblwWQ1tyZr05yTjclQuz48dOzJtYO6Bzd4ED5Jx+CkcxLHO3tZFp8F
	r/S3XHADEJHFQtlbynQNVtngb3aTo+QH2nBmWPZA9ME2Bwj99ZgpexwE6mu31DosEiZ/CskI17T
	AS/PTLyz4qKSPQjxUKKUxI0vqIrQV8A7TDBP0tBpxj/OS3wEtLjies3fEYLSsob0rR+IpJaLl9c
	k7fZUv306E5pi/NflQJ1QSDR0gHQ+T9aLo2FFPeomk7grxPU66jCdkC1pc51YivH5z31GR+B7y2
	+HeNi9C82Zftv+1d+mT6/23QidV3a7vjcrA==
X-Received: by 2002:a05:600c:8107:b0:477:c478:46d7 with SMTP id 5b1f17b1804b1-47d19595f00mr527615155e9.22.1767352653107;
        Fri, 02 Jan 2026 03:17:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwa61BzDAQlV9N6kMzOmYy7Hkb8vOAXLv3Qn/Wfyxm7iktYYakDvEJC0kSxdzWUaE/ZHihdA==
X-Received: by 2002:a05:600c:8107:b0:477:c478:46d7 with SMTP id 5b1f17b1804b1-47d19595f00mr527614555e9.22.1767352652542;
        Fri, 02 Jan 2026 03:17:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab257asm84882883f8f.38.2026.01.02.03.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 03:17:31 -0800 (PST)
Date: Fri, 2 Jan 2026 06:17:28 -0500
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
Subject: Re: [PATCH RFC 05/13] dma-debug: track cache clean flag in entries
Message-ID: <20260102060336-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <c0df5d43759202733ccff045f834bd214977945f.1767089672.git.mst@redhat.com>
 <20260102085933.2f78123b@mordecai>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102085933.2f78123b@mordecai>

On Fri, Jan 02, 2026 at 08:59:33AM +0100, Petr Tesarik wrote:
> On Tue, 30 Dec 2025 05:16:00 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > If a driver is bugy and has 2 overlapping mappings but only
> > sets cache clean flag on the 1st one of them, we warn.
> > But if it only does it for the 2nd one, we don't.
> > 
> > Fix by tracking cache clean flag in the entry.
> > Shrink map_err_type to u8 to avoid bloating up the struct.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  kernel/dma/debug.c | 25 ++++++++++++++++++++-----
> >  1 file changed, 20 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> > index 7e66d863d573..9bd14fd4c51b 100644
> > --- a/kernel/dma/debug.c
> > +++ b/kernel/dma/debug.c
> > @@ -63,6 +63,7 @@ enum map_err_types {
> >   * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
> >   * @paddr: physical start address of the mapping
> >   * @map_err_type: track whether dma_mapping_error() was checked
> > + * @is_cache_clean: driver promises not to write to buffer while mapped
> >   * @stack_len: number of backtrace entries in @stack_entries
> >   * @stack_entries: stack of backtrace history
> >   */
> > @@ -76,7 +77,8 @@ struct dma_debug_entry {
> >  	int		 sg_call_ents;
> >  	int		 sg_mapped_ents;
> >  	phys_addr_t	 paddr;
> > -	enum map_err_types  map_err_type;
> > +	u8		 map_err_type;
> 
> Where exactly is the bloat? With my configuration, the size of struct
> dma_debug_entry is 128 bytes, with enough padding bytes at the end to
> keep it at 128 even if I keep this member an enum...

Ah, I missed ____cacheline_aligned_in_smp.  Fixed.

> 
> Anyway, if there is a reason to keep this member small, I prefer to
> pack enum map_err_types instead:
> 
> @@ -46,9 +46,9 @@ enum {
>  enum map_err_types {
>  	MAP_ERR_CHECK_NOT_APPLICABLE,
>  	MAP_ERR_NOT_CHECKED,
>  	MAP_ERR_CHECKED,
> -};
> +} __packed;

Wow I didn't realize __packed can apply to enums.

>  #define DMA_DEBUG_STACKTRACE_ENTRIES 5
>  
>  /**
> 
> This will shrink it to a single byte but it will also keep the type
> information.
> 
> > +	bool		 is_cache_clean;
> >  #ifdef CONFIG_STACKTRACE
> >  	unsigned int	stack_len;
> >  	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> > @@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
> >  	return active_cacheline_set_overlap(cln, --overlap);
> >  }
> >  
> > -static int active_cacheline_insert(struct dma_debug_entry *entry)
> > +static int active_cacheline_insert(struct dma_debug_entry *entry,
> > +				   bool *overlap_cache_clean)
> >  {
> >  	phys_addr_t cln = to_cacheline_number(entry);
> >  	unsigned long flags;
> >  	int rc;
> >  
> > +	*overlap_cache_clean = false;
> > +
> >  	/* If the device is not writing memory then we don't have any
> >  	 * concerns about the cpu consuming stale data.  This mitigates
> >  	 * legitimate usages of overlapping mappings.
> > @@ -487,8 +492,14 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
> >  
> >  	spin_lock_irqsave(&radix_lock, flags);
> >  	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
> > -	if (rc == -EEXIST)
> > +	if (rc == -EEXIST) {
> > +		struct dma_debug_entry *existing;
> > +
> >  		active_cacheline_inc_overlap(cln);
> > +		existing = radix_tree_lookup(&dma_active_cacheline, cln);
> > +		if (existing)
> > +			*overlap_cache_clean = existing->is_cache_clean;
> 
> *nitpick*
> 
> IIUC radix_tree_insert() returns -EEXIST only if the key is already
> present in the tree. Since radix_lock is not released between the
> insert attempt and this lookup, I don't see how this lookup could
> possibly fail. If it's not expected to fail, I would add a WARN_ON().
> 
> Please, do correct me if I'm missing something.
> 
> Other than that, LGTM.
> 
> Petr T

Sure, thanks!

> > +	}
> >  	spin_unlock_irqrestore(&radix_lock, flags);
> >  
> >  	return rc;
> > @@ -583,20 +594,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
> >   */
> >  static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
> >  {
> > +	bool overlap_cache_clean;
> >  	struct hash_bucket *bucket;
> >  	unsigned long flags;
> >  	int rc;
> >  
> > +	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
> > +
> >  	bucket = get_hash_bucket(entry, &flags);
> >  	hash_bucket_add(bucket, entry);
> >  	put_hash_bucket(bucket, flags);
> >  
> > -	rc = active_cacheline_insert(entry);
> > +	rc = active_cacheline_insert(entry, &overlap_cache_clean);
> >  	if (rc == -ENOMEM) {
> >  		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
> >  		global_disable = true;
> >  	} else if (rc == -EEXIST &&
> > -		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
> > +		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
> > +		   !(entry->is_cache_clean && overlap_cache_clean) &&
> >  		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
> >  		     is_swiotlb_active(entry->dev))) {
> >  		err_printk(entry->dev, entry,

