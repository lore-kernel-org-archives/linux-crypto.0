Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EEF2D5C83
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767341707; cv=none; b=qM4wrwQJqDjIxa5wAzVSfKqXDOBfjXUvAzTQGIawnEjoEOkgfRF3ocUJmQadTeRbZoD2FF12AP53uo+I+a7XbPG1gXAiuwQTMiXLnm9qUv49bzfgzyWSuUz5SSo+LtB81o3Se8TWGgVWCDUsgIMeCOAXu+1acHNGdOAzmRZr09Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767341707; c=relaxed/simple;
	bh=pR9J2JcpyuSslYDA7lsLX4ZhILZRZva1Jx7LQCRL2xc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bo9VcTY6+fiQVK43tNWQVbJp54c6p/3D6i8gQ16FcTQP4pcOy4J/qkuNbJGYAJl5Q7TM1j/B8YKTB2PPeXpo7Np/Z6HR2Ml8G/LEKb77pDsg1VID6Q5HkOlUzS2Nzf9kTtBBIXvggrFPIQk83FWGRqRGKBXfXtYD3eJZjpcDNJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YA76nKi/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YA76nKi/"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477aa91e75dso12208645e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 00:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767341702; x=1767946502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7B5OROvqw/DgiaRfLYZJf4GjF/wj6CLJOtpsQ8Z+Uq0=;
        b=YA76nKi/w+4r6QrU3u2zf5Le8V9XRZBLFbZgcDqg8nvt9MckDoEaO8By8k5rFaH2zj
         M6FOWUp+8LwZBjF7Ct+EYIO0kH0S0v+Pr9wSVpl4cXLp1lFB/7/Pb3+7EkRYFZ3ouqef
         b8TA2l7ZzYNtFHMUb7pVDcW0ZmWyV8GwubCAvrstaOiHAncUBTCHGnjdqJUtd1u693Nf
         pm12hnFgGAbipqxoZBPGus+ExXjFykcTzIXHpoBAw8wzK/IcFi5XxjN/gsygR6pDcVF0
         P1iYMU4BuJYFaPN7BknV7Vy3fKB9GXy/u40sq+1UrdlhP1knI9/5NYPkaXLxDyogj33o
         q9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767341702; x=1767946502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7B5OROvqw/DgiaRfLYZJf4GjF/wj6CLJOtpsQ8Z+Uq0=;
        b=ssN4AQxDIp5GKqTj6gvgpQkF8XzoDIQbZK2YYpcMH2qR2snGVNOOni4/zRzg4CajqB
         gHWWKg5WybGfanFyr0yqVhdlDDdiiduHNbuzCbOVm1+i359ouWSVXmej0R07mAiRWQpU
         0GZzdUsT69tebz5ZTLWnapmHq8Q4FcD9i/Bt+BGMYyEbsvjePUkK8V88HR3Zi8IIugTe
         m1hqv27lNhDQKiiVojMR9G+az4CakeG6w9unrhucISJWagJfNYOeKdDyuNArzTGuAwBJ
         oyVKn+Sp2wzJtVdXo3A7seWFswf1ZM9DNsW9I3ok/qO20k9GeIEkuLiOsKf8sQtoBO5w
         TQdw==
X-Forwarded-Encrypted: i=1; AJvYcCUvdCCnpBmWyER4ibF57lBtjX/dwJsDrQ2yp9QaxBTFK4r7Vvmu7gNfJC398hdHbjBQcviJRn7tRqpVcVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNuvF/MmyouHIv1STOLZMRfBiX1kW9cXsHfbDhKBTmlms25+pN
	t0uyyeHmXe6XEJWkxg6Bb3dlZT2A9e7AzZMUNMYjYQpY3VrGPPziBp7+UpCoUzZ5Hjc=
X-Gm-Gg: AY/fxX5+kUZKL8/zij3mPWU3GcaK5oFW0RgZDNmRK/Sq2QlUbu29MeRqMUOMKI+Qkg9
	45rFtKhsV1Hczxfx+/ltlZZ+9tSiquCv5+YOseaslXNlS98SZl6yiljvpgqfVqP3IRcpdZjyUOx
	NWvity5io7FOhchHff1/CUCnUeUJlepLyoatevVPQUhYDMlaBMy+eo64PPJoq4CJr+EkZypmXLI
	YAnDtqOysdB8z5xgLS+VLcFZvEYLCpotLoJCxS4d7qdVyt72tvIxQbqv0U+G2yG7yfrGOOuPmY9
	4GZQ7pUkdoru7PuTpRyi/+yWqtTruhRGu9I3RawAxiJEbseVMH7s8e0p9OTlgV9Xmz3lUYWS76P
	IrR9yBQ3A6UQAp2FRekxeFuOzlC7rpXRQHw4t3kedzaP0M0J8e4PBzz8uurqLAxzIakLGkdE/IY
	7ZblYige081vKpCGF8kE+JWspCYlQTwA3r73E04V380zwKh5mD8wTUJdH7IiDEeZ69LtloiUCcu
	Kk3
X-Google-Smtp-Source: AGHT+IEG7/UqWg/6ELIcyq0mVb3xfMQn4RI8cpiRrR5W4zXnA35xM+TJgjTRoe1XllkShxIti5fDKg==
X-Received: by 2002:a05:600c:3151:b0:477:a203:66dd with SMTP id 5b1f17b1804b1-47d197f69demr322547935e9.2.1767341702410;
        Fri, 02 Jan 2026 00:15:02 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b0d5asm792930555e9.13.2026.01.02.00.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 00:15:01 -0800 (PST)
Date: Fri, 2 Jan 2026 09:14:59 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 01/13] dma-mapping: add
 __dma_from_device_align_begin/end
Message-ID: <20260102091459.6bec60c2@mordecai>
In-Reply-To: <20251231154722-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
	<ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
	<20251231150159.1779b585@mordecai>
	<20251231154722-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 Dec 2025 15:48:26 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Dec 31, 2025 at 03:01:59PM +0100, Petr Tesarik wrote:
> > On Tue, 30 Dec 2025 05:15:46 -0500
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >   
> > > When a structure contains a buffer that DMA writes to alongside fields
> > > that the CPU writes to, cache line sharing between the DMA buffer and
> > > CPU-written fields can cause data corruption on non-cache-coherent
> > > platforms.
> > > 
> > > Add __dma_from_device_aligned_begin/__dma_from_device_aligned_end
> > > annotations to ensure proper alignment to prevent this:
> > > 
> > > struct my_device {
> > > 	spinlock_t lock1;
> > > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > > 	char dma_buffer2[16];
> > > 	__dma_from_device_aligned_end spinlock_t lock2;
> > > };
> > > 
> > > When the DMA buffer is the last field in the structure, just
> > > __dma_from_device_aligned_begin is enough - the compiler's struct
> > > padding protects the tail:
> > > 
> > > struct my_device {
> > > 	spinlock_t lock;
> > > 	struct mutex mlock;
> > > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > > 	char dma_buffer2[16];
> > > };  
> > 
> > This works, but it's a bit hard to read. Can we reuse the
> > __cacheline_group_{begin, end}() macros from <linux/cache.h>?
> > Something like this:
> > 
> > #define __dma_from_device_group_begin(GROUP)			\
> > 	__cacheline_group_begin(GROUP)				\
> > 	____dma_from_device_aligned
> > #define __dma_from_device_group_end(GROUP)			\
> > 	__cacheline_group_end(GROUP)				\
> > 	____dma_from_device_aligned
> > 
> > And used like this (the "rxbuf" group id was chosen arbitrarily):
> > 
> > struct my_device {
> > 	spinlock_t lock1;
> > 	__dma_from_device_group_begin(rxbuf);
> > 	char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > 	__dma_from_device_group_end(rxbuf);
> > 	spinlock_t lock2;
> > };
> > 
> > Petr T  
> 
> Made this change, and pushed out to my tree.
> 
> I'll post the new version in a couple of days, if no other issues
> surface.

FTR except my (non-critical) suggestions for PATCH 5/13, the updated
series looks good to me.

Thank you!

Petr T
