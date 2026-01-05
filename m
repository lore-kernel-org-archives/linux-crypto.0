Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3834A327C00
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601407; cv=none; b=Fs+7sAhvw0dbK908tzr0cmohW8WSza2pCGSt2skkWtxFLRUCdVvmZgujvFJyiHkbkbFOPrPW8aD8f6hU0dyXux1s9lV5AybDU1HrLKPN8rGcBhomEhsMbqOhVUdxkHDtkhiSIwtGS/oT+NzqEWhsDbJOu3wFHnywvNP5cTwmGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601407; c=relaxed/simple;
	bh=UZnbRwVvRPHcRgRCzpxYejrN2eYzh6K3qUvMvD+slXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyjzvR+24bkTL0Au30B5YlX9PeBfZXqJHIS64Er8Oy/yj/cVMRVf2IzC73Y/pBXDEZGZXhySPBVvLtG3utvPc1aAynxy3lkHj3HE3qaFqpTlDZb4633WdQ1uAafVg77ejqW3m7fl6micAMtbDVbqf0J9ih6uXfl4Z7e83sYyZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Va5i9zMe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eVeVMVFL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Va5i9zMe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVeVMVFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ixiBJgqmLTQwR4hP1VcNBLxgwUtr+SaYhPMs/HYsyIA=;
	b=Va5i9zMeMtbcRHGkO3omiS2lnbjK7NHJmRV04pl1aei+cXj/VonDubjoano/21Gzm6DJza
	NuqsI5jUFDMBOOIBPpcc5KxS9XpfJzugdzZmrvHTih1SwK+tDbSBdheB81od2wtPh6Ji6w
	llfG0vjl4L4Fd7EkQ7ac2tMIxB6DT/k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-_rgVnkD1O9Wtwj0a6YEDZg-1; Mon, 05 Jan 2026 03:23:23 -0500
X-MC-Unique: _rgVnkD1O9Wtwj0a6YEDZg-1
X-Mimecast-MFC-AGG-ID: _rgVnkD1O9Wtwj0a6YEDZg_1767601402
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42fd46385c0so7407560f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601402; x=1768206202; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ixiBJgqmLTQwR4hP1VcNBLxgwUtr+SaYhPMs/HYsyIA=;
        b=eVeVMVFLCc/3+rlgiQ+uX1PuOEip3OVCtfW/FVbq3GmJAX2XPqgSzQu3DI/Sx9Y491
         1T7yEOJ+KvzNBcr/zxt4mKErGzWZZWXEi6p1dpNvdFl0loa445T/D3jyFCRSMehYMKyb
         Izb7utSZY8hYoW9yguzTL9X1LbFZQc/wOUjgQmwsCPNV94gLcNt8TAqV7i0cpZW5VIz5
         pijgiyaL/lHySq/iE7pgV8Rp9v2LST+0Fw+KNsciR4l7nP0T4YUq7b2xK1P+6SZEL5aq
         N51P2VPsKgGYixHYeKCDmFq056ciBxj/kk1E3cSwu12el3grzvjWTjRJI1S+p3GQOPjH
         qb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601402; x=1768206202;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ixiBJgqmLTQwR4hP1VcNBLxgwUtr+SaYhPMs/HYsyIA=;
        b=nw3HprcXbjI46o38Hu3+rA4iG0dRMMp0CET4y4a4jpYUlREU1mTfIJ9JxZmsWVpIDp
         t+HSQZj/Bd7ESjETaH9aGDD8DoHr1ryijlC8H7zeh4RtI5Zd+RZ7JF5zVmpc9rzbuUGr
         T54fgjkz28kdJa97p2ky/ft/a+V0ssVs0wfsxHDO4pPnLOjzheBMV/307LNfaoSCZMWH
         fEKzqNVtVp4oT+EBq2zC/eWQTYRJC6eRKkwI7xfZqfAkgFWeg2nQsAjXIA04mKv4O37Q
         pFwgo2s0BtwuWZjxH58CDajLoMi6+sZw0JGpwvKqo4kyzDBk6fdKwJ0UvCjbSCia8ete
         0Vfw==
X-Forwarded-Encrypted: i=1; AJvYcCWuDDWl/FMlKCE9rb7X62UkKPxNC2EUCcBc1NKvlIeeTqgeyFZBfM5xQ9CiH0j0WimRerJHI/f0S/U3Ppk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdNZtslXVKaXT43p9084D4hbtjJWaEjX/bWPKTdk5eBYLwYQsF
	Iwp/6t01+FQOwXFtOf5dKKH/552d7cNH2Wm3KJ+M1c9zAliv+RMQtftuZuEdWC2eEcMCVeML5XT
	EVYbn1WPGA+B61K/rQx/WTDXvIUdPPIktf6iE59B3RyB8a+aiZFlxfZ236i+8vgUp3Q==
X-Gm-Gg: AY/fxX6AHATNWK8ExoEA3CBxb0J/iFOtjvvVHBFIYrgx+QbYNY+RDhWlClp8DYbfY19
	gMNhITf6Qfz0ypbaDb0EierSEQe9KbIVqUcS83tKtcCEb2qCev6kbF4lywcZ1s53ELNCmIk2+xG
	lKiFwKnLlYyojOCAueP85Gk9P8dwqH5e7+81YAzd+QU90uxtEHEuH07rkIMO8LomC/fYj3IzAK+
	U4GJIJBUzspc0LMQ0/OlrNUWELHAiq/1eeYZQXW/mrqKSJsZIQodi0orq0FseUQ2Rvcv6sUCm9L
	KndNRCS9t6jr7eU9C3oo0a1kUAXT4cPjXix0l/9cCWPdb9ySRzDj2LwIdXLv+NyQOrHnAOqOgZi
	HrFuWVqjnUKOa+tozQ5IkikRCZdhDTj6sTA==
X-Received: by 2002:a05:6000:220b:b0:430:fbce:f382 with SMTP id ffacd0b85a97d-4324e4d04d4mr58561459f8f.25.1767601401668;
        Mon, 05 Jan 2026 00:23:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGx1Nl8KRgrNe9z8PJkEy+oAdnaqu11UpBKN0xrzW8x/NIJB12I9Y53VIEzJyG5l7t+8XCSPQ==
X-Received: by 2002:a05:6000:220b:b0:430:fbce:f382 with SMTP id ffacd0b85a97d-4324e4d04d4mr58561401f8f.25.1767601401124;
        Mon, 05 Jan 2026 00:23:21 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa4749sm100730503f8f.37.2026.01.05.00.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:20 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:17 -0500
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
Subject: [PATCH v2 07/15] vsock/virtio: fix DMA alignment for event_list
Message-ID: <f19ebd74f70c91cab4b0178df78cf6a6e107a96b.1767601130.git.mst@redhat.com>
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

On non-cache-coherent platforms, when a structure contains a buffer
used for DMA alongside fields that the CPU writes to, cacheline sharing
can cause data corruption.

The event_list array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent event_run and guest_cid fields are
written by the CPU while the buffer is available, so mapped for the
device. If these share cachelines with event_list, CPU writes can
corrupt DMA data.

Add __dma_from_device_group_begin()/end() annotations to ensure event_list
is isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 8c867023a2e5..bb94baadfd8b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -17,6 +17,7 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_vsock.h>
+#include <linux/dma-mapping.h>
 #include <net/sock.h>
 #include <linux/mutex.h>
 #include <net/af_vsock.h>
@@ -59,8 +60,9 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
+	__dma_from_device_group_begin();
 	struct virtio_vsock_event event_list[8];
-
+	__dma_from_device_group_end();
 	u32 guest_cid;
 	bool seqpacket_allow;
 
-- 
MST

