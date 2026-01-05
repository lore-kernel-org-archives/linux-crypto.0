Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1BC32ABD0
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601433; cv=none; b=GN6drKAz2VZdEeVDgkwhMdXAvwNX+3jNgVzQ+Qwv9cgoAEFdyvyXHOeNtJ7e3dUvnjCKUC12ahmP9W7at4XGyKtURg5aOCKTyxAOs4cKTm3zs0Waob1czahMfFz9Pqss5rkKxhmiG/eKgo/NE1fLHcg/9yJwz0Jblx+gj7ftuTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601433; c=relaxed/simple;
	bh=SZ7yoG8PLS6oSz/uClprybkzflRSWBjZBPmgt2pUyWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8gWJpuJyt90Lae/JT8zh1s6I+vqg9lueKi4TGJvYygYC8bQNoywTTwHXcHGsqxJQYACLesaiibi1lItj3JLrkx81Trcm7PL7kL6OX2RqjeZOCWAeDqxiF82y573vhQgSbiiCTG/ZP8aeUxOrfCjRirR9A3SWYbi5+x1oOGRcxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Io/btUN1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qtt1gD9p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Io/btUN1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qtt1gD9p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UCCLeq+lwQP+R3LKzuvNuhkNhAmceABICngBBmDYRE8=;
	b=Io/btUN14Pz93JGjiSMLn8JU4k3jep6SAudvCUMDNbgMvcAm2YiJl2peavOlnsbE3tNs9W
	RS3bNAH4RsEwQR5x43TvQxfxwUrHlRmlJ0bniPMQ/RN82e8xmwbFtqQH9OiNWkEoxz9iEz
	H9Bb+vvTkYL05LQ8Dy1BccJ7DxXDg78=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-rpzkuOSCOe-bWYtN1uSgWg-1; Mon, 05 Jan 2026 03:23:47 -0500
X-MC-Unique: rpzkuOSCOe-bWYtN1uSgWg-1
X-Mimecast-MFC-AGG-ID: rpzkuOSCOe-bWYtN1uSgWg_1767601426
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d28e7960fso89214075e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601426; x=1768206226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCCLeq+lwQP+R3LKzuvNuhkNhAmceABICngBBmDYRE8=;
        b=qtt1gD9poIHpzjauiXtVKb1u88sTn7Wwbfi00HKlGMPnuFWOhzi+vYbAQiA6E+/QOy
         KHA1rws1YgxHL3D+ZGXGlsplhJBj1Xcxi0JKkOJ4sFAjpsHNb9ZS08H9jbEmcnM7vZnl
         RK7P3fTatZ/EWpjeFzLDDJoZL+87zOa90w7aj72Had0j0ntALOHFkMwbzOKcchnCq0Av
         wmwv/ZZjPGhAvvLs19IXb29uwOB3Tm5qZvnBmugl+i6s4BeM6sHQCR5u7Czf5RCGzkYR
         jHYq07piUzqY53pdXGmmnXX4TXosiZaYUteYthXVUIuM2Fec/06gqy85cfBDx3zAqzHe
         jckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601426; x=1768206226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UCCLeq+lwQP+R3LKzuvNuhkNhAmceABICngBBmDYRE8=;
        b=e2XM1h1M7gT7dYg8K3nGeUFVjaIDaNaTmkYxp9aI1RVYs+YMO/RNCUwBr8DIjuVjMY
         tPKLoq7volvi81Ld5QvtI/xqZ1MsQgrRaPYKHTBVyoU07bfsEyF5VJLBf1gqz344Fhnu
         dch41dIYPJyHtC9CDWftrLA7wTS5Op58ZzFFonfg/loYd+t4K4+vf5HUFyDm0LymVV0g
         /eWqRDIOHDB1S900aDeR4oY3HtQAFxnfZqf6WRiE0C3LeqOLKCQJ3esjBhEBLooD00r1
         B8cy+YDsFnqXUhuv6kAkLqSPK7TcXz62N+OZ3mxuhjXFIwyEzICdT+9pBvOWmXFDuBFa
         Ezgw==
X-Forwarded-Encrypted: i=1; AJvYcCWKRcn1XKj7IMXs08Ya2Vwl7iy+BkEvuP/Z+TeuevK/xchf73kPu+a2m21gJf85+ND5+4s2c+wPvJxbwxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqp6CK/By5VmaHIUehBLrhRCuXvJNKBwq4W2nmpm79O24pP6aA
	j/6dlUAf4W89wqnDZKllGOS54WHxvhqVOIOrTQEay0Jn8EmYSiovnimJSFIZgsJWw8AR/4jncFL
	I0mK/bUGQ1vbLJ6MKprZBmp9BzwXgkXi7N3GOVzI7jqUyrKzVvnOHSgesbfKaIDHKzA==
X-Gm-Gg: AY/fxX6UmqTIpglAcyY/0YuWBJ7Xo4HSuOnYsYfLLBheNS+x5MZp325E3cGERcJnioO
	7MipUeQK3Ico8eXaX7T8tVw/q58axP8fEsoWlSgNFEgBPOc8+VodjVXGXmLtvL7HagDjtCl2s4r
	dwTVpENio+Rkbj2KFmRg4NO4EeOPloWFa1d1qImgReH+6wBuwqlADNhCBViBtKbL/ajru3soWEl
	ZaMWg8AVGOuIXo5VG5U3hynUKvAFxWHkOYKvrJuoXp0LmrETCCuZOEqRyg9BPQThS0HzaeKEEEb
	Af8HpL2WJyN8CjS/gedMVKblQrT3uJ2HFsPDj+MutqvKGgqDlbkM9PZqfq3CHsSeaJhymEFqPZI
	NKMcIJpfBp81kKtOMqcNoog/7fEoRIPT0WQ==
X-Received: by 2002:a05:600c:6287:b0:47d:5dae:73b1 with SMTP id 5b1f17b1804b1-47d5dae7628mr228845915e9.23.1767601425882;
        Mon, 05 Jan 2026 00:23:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF11RG7JP48/6nhX1x0r6bivcNnxiVBPQ+hub/0+kajaGoE0Knx7g5Xjp0dkxgQjwSwKtknIQ==
X-Received: by 2002:a05:600c:6287:b0:47d:5dae:73b1 with SMTP id 5b1f17b1804b1-47d5dae7628mr228845285e9.23.1767601425245;
        Mon, 05 Jan 2026 00:23:45 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea830fesm100331450f8f.20.2026.01.05.00.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:44 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:41 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
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
Subject: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
last. This eliminates the padding from aligning the struct size on
ARCH_DMA_MINALIGN.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ef983c36cb66..964d25e11858 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -60,9 +60,7 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
-	__dma_from_device_group_begin();
-	struct virtio_vsock_event event_list[8];
-	__dma_from_device_group_end();
+
 	u32 guest_cid;
 	bool seqpacket_allow;
 
@@ -76,6 +74,10 @@ struct virtio_vsock {
 	 */
 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
+
+	__dma_from_device_group_begin();
+	struct virtio_vsock_event event_list[8];
+	__dma_from_device_group_end();
 };
 
 static u32 virtio_transport_get_local_cid(void)
-- 
MST

