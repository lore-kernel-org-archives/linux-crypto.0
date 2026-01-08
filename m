Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809F640F8C6
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881521; cv=none; b=nzI+EXGtI4w8VaftL23UxtlGhJBJjYVTwIdxJNAob8vAWNGCCDq3OjqIvnlaAdC/acFwsOAXLHdObH6ZtjxCwO3Ti4AR00FVUcn44NSK4RDYSXjjchy/okckpX9hbV++6oEA9SjQugxPDxqyIIDp+PN61cLDqwouyoiVkg0ItgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881521; c=relaxed/simple;
	bh=AFb8yUemGFVP+E1zn7JOJ8f6bE4z7sRVkT9bi0zm4eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Js0CPSRua3r/GFb8+O5yZTAkMZkYUyaFHGE7Sck/GnDCBCGy6NogeWy5Acxq7XV9L140Pi+tIbbLLFYaeFLEytzvNQj3hV1EFskp6xyLIiG41rWkaY1xbaNSf0/GrVnOj0ujaY6oHCiQ77dc74Ee37gayAcZ9+luFMrLQ8Tm040=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kc3ggdT7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipTnwXHD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kc3ggdT7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipTnwXHD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
	b=Kc3ggdT7E0NoSWHyCnv4q/pbWNqacQEz6wL1vvPeMUwdHK7D5sqSNJxHqA44sbm4on07Ch
	x+Gol3uIsl5VzFonifXE6GOhMP9yPz2Jt8FtwiRiNiuPHfSd+c7crisE+jEp3LaHy7PGOt
	Vj82iNNWH1onyAgUQLRtdj9WXgW859o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-Qm6mjZIYPZCPdOBWWeOgfQ-1; Thu, 08 Jan 2026 09:11:56 -0500
X-MC-Unique: Qm6mjZIYPZCPdOBWWeOgfQ-1
X-Mimecast-MFC-AGG-ID: Qm6mjZIYPZCPdOBWWeOgfQ_1767881515
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-64ba9c07ea2so4537252a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 06:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881515; x=1768486315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
        b=ipTnwXHD+dLvDSmgaJopVLl/1O8dnyQsR1tZk+lqtAATXWbvS/P0QG+tojhsdu5HPI
         pv5SSJgMhShvO/6FGq1gyrxXpQRtHTmRjq3kjiQi9db2f/u50YyurFdq2eA3tMPFMu83
         7b8j8EaUsH6N949qWInjMDr7NqkFx/UWgc43C0n1jTdBjSsmOFeiF1PCSICFd/n0TZgm
         x6dZC343KryZI6rn/qDuvOHK5pI4LEQYtoBQ5GqsLvA1BeDZ2DYxZE+Og3+3EgLCiSOU
         /aQrIKL82HTc/43aEnyErBjIAbEEsAVicFXAYKgmaOPlK63fvd6vWuHbAo46exB5OpAR
         5ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881515; x=1768486315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
        b=RTVeDZZzuWITMOy5UQ4Yxtf2ku9n+Dx4i9q1GHjC/UUzXaf98kMeLi++EQI7PEXRSE
         Sn27+X548u9St0WG7NicjhxqlEQ4SleHA7Zx+94LheG9qMj6jxRT60rkdjjHsFpTr2hL
         qlbuLbNYVi7ws4F9lKAGvhcaP+XmnbrvG8VumvJyMECB9+mzVDVxvqpAoa0w6CRlpfgQ
         7e7+JWDFcBq64Tr8IAZa9hZdrrLM57cuJgkXLUpy5fkWz2SUVq9bf9s9MlyEO8DBWlV1
         76Rv7k++XkyNlEFo2Pdhu8c7m7fo0UTv0xldUUP4amL0F7ZL0QPgVyvGKPlp9owINq0a
         ZrZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXG1GXq8cIj4zefmFnLYR0szANroJVj74F3hnntXeFlEIEfCtBqWsCAgJG8uILTBHZGKrVrCVqzxCClx/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6ulJkpd5rFq+IXQv3iXcP7c17Y/iq+4hdHSnmeBQtBOUtRUqT
	/TjSqDmQSDwO/DJrcJTFGopiaXyyI1Mj9NnigRwD8OcL10gHYB8jW8spKWaoPUCbslu5oE64mdb
	xA9/BQsrvNkRQcpy6V0ezSa1w5Dw4sTVg36Xxziv/9+pH3tvP5z3H1psRX9QXx3a6bA==
X-Gm-Gg: AY/fxX6sH9alEZQrs+GDqnKsY3BOO5cjysX1tAqKHDkqT9ERZDAsBBlMOotJ1vCQYZJ
	6BtSF3mJAd50Y22XJQwKD6+vg/gdJSYh0UR/5H6o4XumStG6bBuq2+j59ae1qTUT8lljplokPZQ
	VyL4JAYEDhfSZXcTY+Rm6O0I/zoRYSAtIKYW4TVjt676M8HDQzTtG4jW/+e09lThNRW/G/KjhiR
	pBJ8AXWV/uU6twB/9AtvZoG1KyZeowbA4otkpE6K2if+xZ7gTEUmLnVukkzH6ZbBfBRDMnCjbHq
	bgoGOuwLKks17qSm0Qsg3/e79kLZTaSlbMoQKFDahNmgK1RLxhK4ewqmOQQvyosRQrugPxRKi4i
	gfxC+c5DbWrwkVjxR
X-Received: by 2002:a05:6402:358c:b0:64d:1bbf:954a with SMTP id 4fb4d7f45d1cf-65097e01237mr6010691a12.15.1767881514759;
        Thu, 08 Jan 2026 06:11:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFH4GSSsuHOuOKzAWjnLjL93ZyftULQdKpADud0o+HUDbYN/JI+jAlKmTdijyyr2Y36a7d4Rw==
X-Received: by 2002:a05:6402:358c:b0:64d:1bbf:954a with SMTP id 4fb4d7f45d1cf-65097e01237mr6010647a12.15.1767881514187;
        Thu, 08 Jan 2026 06:11:54 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf65ca0sm7641163a12.24.2026.01.08.06.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:11:53 -0800 (PST)
Date: Thu, 8 Jan 2026 15:11:36 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <aV-6gniRnZlNvkwc@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>

On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
>Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
>last. This eliminates the padding from aligning the struct size on
>ARCH_DMA_MINALIGN.
>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> net/vmw_vsock/virtio_transport.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index ef983c36cb66..964d25e11858 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -60,9 +60,7 @@ struct virtio_vsock {
> 	 */
> 	struct mutex event_lock;
> 	bool event_run;
>-	__dma_from_device_group_begin();
>-	struct virtio_vsock_event event_list[8];
>-	__dma_from_device_group_end();
>+
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>
>@@ -76,6 +74,10 @@ struct virtio_vsock {
> 	 */
> 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>+

IIUC we would like to have these fields always on the bottom of this 
struct, so would be better to add a comment here to make sure we will 
not add other fields in the future after this?

Maybe we should also add a comment about the `event_lock` requirement we 
have in the section above.

Thanks,
Stefano

>+	__dma_from_device_group_begin();
>+	struct virtio_vsock_event event_list[8];
>+	__dma_from_device_group_end();
> };
>
> static u32 virtio_transport_get_local_cid(void)
>-- 
>MST
>

