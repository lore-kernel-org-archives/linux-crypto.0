Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A3C1E0DCB
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767186756; cv=none; b=gwScU6f8FAJR9wnlCSx9MkaD+L5/aSWV5PhuWd6PbEc/FE1Ma2Req1Fntx4wN/x3o1fQSCaGMadQPpDtd5+IIVUjXCx41n2e1bqANSyVpHxHKniRenlvGHDE9wOzn3K/XyS3+jXmwoKooVMZsPEBHdRuRZs432QihJ+xEauDka8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767186756; c=relaxed/simple;
	bh=+Rj9uS/xKO+b+rZgqDTkOPQ7AM9H+O0zY3sW6JnGIaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUJ657lZ7AV2UjjbdmZDQjqTMvMelCaVEq4yGJd/rWNDb5seuYq1v7xhmmVzeXYJP2QRJxqEwUfefUK7rp++q0rvgg88DH01sw0dZ2ghafZR5bXw3O3emtcO3VxXWIa3sIys070E7yT0ebSw/i7NePEIPZmY42TgBnRmkl8mEDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SiNOf5hC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SiNOf5hC"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47d538fafdfso3024575e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 05:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767186751; x=1767791551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fke3G5rSH2WPZ2DuQdyfqEfEpoI6l76uJNtI0EpEhAo=;
        b=SiNOf5hCQAQ9lih0xDGV7gjR7CfpmOO8AB3s9IeITfpaC328pdo654nC3FNIfPPnYB
         fkd5qD9q+HvWSq536C6BhTSPieAbHLipRfLKE21iDDYtDmghplktpIhdpDtdORPciAcZ
         LQpQ8PKMM8Q6/YUI7t1QvsKoPzRYURS1J27f9/F31nTEFyFQlVX8XQzAr1xtRLQ39GkB
         REQ15nkajDKe1xg9zkDXa/UH9tt1LtbNShtNDDvRc1UpIXkWn8dwnUZCTvot/hexmBta
         XggYEqQC1GM23pJ7GQgNCAuwh+5a70MQJiobGXUg7XwbkgAb1lDG3040If49qmyX801q
         2gDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767186751; x=1767791551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fke3G5rSH2WPZ2DuQdyfqEfEpoI6l76uJNtI0EpEhAo=;
        b=abkpLndpV4m68gu7if1a1Pblk6dTBcIjNFXfhQOt70Dls4b40lMqBTlqRqQJGqAkzY
         lGIWC0ITHrrt4iiQ+nOKDyPJkcqjSQV8ltlDTTT0KW9LJYHmZ6EP/29oXv2TRbac/nNt
         U08OXx7pCVkJ/BZhyAak94TjCp8GC532YWp2iFX7TrMDnBfR5ul/nKX7+KKCvo1LcYKM
         JEuUz0sRzF016PH4+Paqpvd4p8zyvuB3XR0TxBfJwasNNtcZvEyqMQX7iu0+Qhw16h47
         t6fKbUToez/54zvGtfkQkj4A6UCxcdeP5SkQgZFLDbwcWGbzbU7lRrTFlnjgcdIaKMkZ
         ouRA==
X-Forwarded-Encrypted: i=1; AJvYcCW8R1fMPmaxYIHub17b6Su6wdXpaaIDP/NGanwVHf1XH7AeZzscGCpXVC0OVg8RlCjsQhN9f5RSwob+rXc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqs0AL1MIM8LLvKIJDmsTxQTFcaBpgFWrKled5YqhvXXq4yp7I
	Pi3QgsapSMWS/YEdG/3xQ5zXsqZGdtR0U1RU0CWfmEJF2MUeTkZXANcemPL4e2/CCQw=
X-Gm-Gg: AY/fxX4qUpQI8sObzx+F9ZmUoC9ML6a0ToUmUOLIgvLv7axCL81oViBcbYhCC+OZBJn
	czcWd8gFJjORBKeC6X3vTjXy9LGciU3Qdmt1J2dqw06uvmGWCN8XJW+9Af+LPGcdbLfzLwfSY1b
	xXAMQqiiY+bB/SCTcPINmOtP6fn2kcWKtCpjF/fkiwrU7EdKtfFt3TTQHV2yrR9inUN7zQ1Si+c
	mzqskRwglEqFEXJsxT6GY/4SiJQ16cB9eCanCDGEufWAHenIKaf+2njwQi7JDUMGaUpIfAE2CAI
	7bG0hwD6smStccFli5FImSvdkI7WYupvjZTc+rkYYLVVeHiE/SJj7WfIIyVN6Be2IPJ00d4nnbI
	aWe/1Zy6t9vq+CU5+uJcxjrmAlQp46qmMVkhObQwKNVftgPyxKaA5cpTVBigC1V8QFbVLcJdqDw
	kQlVkE5Es55fqF2ACLsxfxEIZA0wY/UAKf1YmBNGFk1P3HW5xTHQPqlKO16JCsF69pGRi4lGgIm
	rWO
X-Google-Smtp-Source: AGHT+IF4mp6GOV5G6x95wPZOhGbqasawR+ZO3M57T/TzQMfUeMdF8kArZ+ePMOUwA5I3JuKmTuDssg==
X-Received: by 2002:a05:600c:3e0b:b0:477:9c73:268a with SMTP id 5b1f17b1804b1-47d195b3d55mr287631655e9.6.1767186751342;
        Wed, 31 Dec 2025 05:12:31 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a20af0sm269524875e9.4.2025.12.31.05.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 05:12:30 -0800 (PST)
Date: Wed, 31 Dec 2025 14:12:24 +0100
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
Subject: Re: [PATCH RFC 00/13] fix DMA aligment issues around virtio
Message-ID: <20251231141224.56d4ce56@mordecai>
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Dec 2025 05:15:42 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Cong Wang reported dma debug warnings with virtio-vsock
> and proposed a patch, see:
> 
> https://lore.kernel.org/all/20251228015451.1253271-1-xiyou.wangcong@gmail.com/
> 
> however, the issue is more widespread.
> This is an attempt to fix it systematically.
> Note: i2c and gio might also be affected, I am still looking
> into it. Help from maintainers welcome.
> 
> Early RFC, compile tested only. Sending for early feedback/flames.
> Cursor/claude used liberally mostly for refactoring, and english.
> 
> DMA maintainers, could you please confirm the DMA core changes
> are ok with you?

Before anyone else runs into the same issue as I did: This patch series
does not apply cleanly unless you first apply commit b148e85c918a
("virtio_ring: switch to use vring_virtqueue for virtqueue_add
variants") from the mst/vhost/vhost branch.

But if you go to the trouble of adding the mst/vhost remote, then the
above-mentioned branch also contains this patch series, and it's
probably the best place to find the patched code...

Now, let me set out for review.

Petr T

> Thanks!
> 
> 
> Michael S. Tsirkin (13):
>   dma-mapping: add __dma_from_device_align_begin/end
>   docs: dma-api: document __dma_align_begin/end
>   dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
>   docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
>   dma-debug: track cache clean flag in entries
>   virtio: add virtqueue_add_inbuf_cache_clean API
>   vsock/virtio: fix DMA alignment for event_list
>   vsock/virtio: use virtqueue_add_inbuf_cache_clean for events
>   virtio_input: fix DMA alignment for evts
>   virtio_scsi: fix DMA cacheline issues for events
>   virtio-rng: fix DMA alignment for data buffer
>   virtio_input: use virtqueue_add_inbuf_cache_clean for events
>   vsock/virtio: reorder fields to reduce struct padding
> 
>  Documentation/core-api/dma-api-howto.rst  | 42 +++++++++++++
>  Documentation/core-api/dma-attributes.rst |  9 +++
>  drivers/char/hw_random/virtio-rng.c       |  2 +
>  drivers/scsi/virtio_scsi.c                | 18 ++++--
>  drivers/virtio/virtio_input.c             |  5 +-
>  drivers/virtio/virtio_ring.c              | 72 +++++++++++++++++------
>  include/linux/dma-mapping.h               | 17 ++++++
>  include/linux/virtio.h                    |  5 ++
>  kernel/dma/debug.c                        | 26 ++++++--
>  net/vmw_vsock/virtio_transport.c          |  8 ++-
>  10 files changed, 172 insertions(+), 32 deletions(-)
> 

