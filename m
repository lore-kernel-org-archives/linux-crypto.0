Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6DA284B36
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 10:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089777; cv=none; b=gTDL0AXF2+YR1jp97eew1SlInh0bAL9PXOSeQlvR3rqIkNRVyV/sOdROM/5M/8XDmSRlQG1MnW7+9fPJhYP/UacL/wwEKciSmbxsD7mdWrtT8+gVG3qDDY+kdP/WHxCWnNEk7ilnnxXxSFdy4oJO3LhUxLlvLsYs3PUNQ53BsPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089777; c=relaxed/simple;
	bh=1nvGVVfYMss4t3CEcUrrF8Nk2cSppyMGKm3YyiTIiKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bm2jmql13zg90hb2QWkYqZAZace7ZLu8+jVmNjpSnWisGJxqk50ZE+XzWuvJvEWn6dzlYrQ4miuI31a0gwp5klGjFXmUFDDs92YZcy9jmfKrzFHAJcks/Zh/UMQtxSGrNmFTJ9PZCgXehpqJtmkDC7ufn/6FYvgpgGEaFEjeJwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUV93+Gv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8kiRJdc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUV93+Gv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8kiRJdc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
	b=JUV93+GvNWX3nxpTw8cau2vP30RBijuoxCYWrIDxyYcvX4p3XvCk95xccbON6+L/U3eb9t
	si8hWuSvT4Mt3QErEjU5PTb0AlztpEMPM3HXaJlVfXud/33UjYfqDajJuESmoRTs+TkhT4
	8bBFTetu85d5QnbDKsQ6WrE2G/IJ4h8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-I8pM8He8MdWY1fgNEaNdgQ-1; Tue, 30 Dec 2025 05:16:12 -0500
X-MC-Unique: I8pM8He8MdWY1fgNEaNdgQ-1
X-Mimecast-MFC-AGG-ID: I8pM8He8MdWY1fgNEaNdgQ_1767089771
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47d17fff653so34875635e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 02:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089771; x=1767694571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
        b=D8kiRJdccnjA7UBfQdPD1dIdRkpZkqA8vResLYU9t9f20l4nQJx5GuLg0IRRo4HmkA
         Ez9QUd8ztax/ZM6qlWpStt6ig9rAwGG18m9odbjAYC7V/8aib3iWrs8f6Glxnfo92e6M
         kbzp51OUt/jpLMIaQ9dSi354rrPCe5h6M+dOEHdwzUrk1FtyKjQU3A+QpWIY5VrGfgPZ
         GasDPxSRI4RFXD/RE1XwOWs4ZpqcTdTHkb9bC/VEyiOzSm70/GLjGNOKak5FNDBdiJa7
         ZMR2k8LgePJspuqK6/IhpTuKlpvOtJWOoqS7UikPR07hhtZjj/ERppykuPbLuGVi1fLU
         yJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089771; x=1767694571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
        b=I77ns9rIFb/WjUaLo9v0BlkcOcIKA/yS0G/MmMYE1t0ifFUDvWc6exkEnJXJ5q9jIt
         u/E4fd9YIPGxPoLHOHT5wuWtN5oS/x6ugxsNWIJWRF4NXqHAVlp/P2xND1mDcsNkitd3
         4IOLzo3qk3odDfyjhpzqovNAsPQKocM3VCAMduopKUXz087hNcdPx2He6NtUSTq7+7kw
         r8N2mRLpsWus6e453AcaX76sMHwwbGGXijDk263vVZq+9Fe0ViwxIgqyUMNdBfpj0za4
         CYdxWPuX0mXIXYkWg5Z2XdQevVz/fa1VUfyPI88Cdufy4HgIwtr/Kpz7NU6YV9+qxmW9
         4pcg==
X-Forwarded-Encrypted: i=1; AJvYcCWY6/UZFCyzhcY8Rj/O+6IB32kgpT9WwYaz9Sst8fcKr5zp0F66wIVMTPaQNa/LLa/coSfHqKqiG1Yhusw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHVqlI4/s4Acz4VaeiITcc5Cf9tKl/88JRFkE/5dsFaiwnxGP1
	2bf2p5ggeEakvqdaQyV9CGgyyi/NdL6EHLlB5lj3diBGAbbJ7zF01yq+eJ5IUJxOHGqExic+BdA
	IdxVK4Vhuj0+6ZS/zdIuva5goms7yWvqEfyJBT28vnyYfBnrMlzB0oDW1SRWk2MgRPg==
X-Gm-Gg: AY/fxX4lEmGNfYC+DDCA4F/Haqog4rUtlya9ahOiV//bruUQwp7367a/X2GGQtwPzcz
	0E3hROElCq+xpOPKUTgn1nJWW8qeBfFcXi1N7NuwURXrFJybjwLoNyj36B6Mua7bFquthHfSmav
	fXigA2XSQEYfMiwO3zZgxndQRyqOGOyLkHOGPGy5YQrwIfLidzLyHMpomj76PcT0BqXKCm7WUt4
	jyDxNJBElr92weJomKDZND8AgLaUruBPkrD5J87AmxY3H8fVvSa+7WErx/w0h0uIsdnvL4M3tDf
	MPNLe/Y114IZLevfvfgTOqKHcwkb2liguRJ6KbvlYL6IH2QBFehR/eVMD3awVvNGCTITSRPN3o8
	li5BfRjrDFIPmxeoapoqMvpxHXOsgE3VNCA==
X-Received: by 2002:a05:600c:45c8:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-47d195558bemr375729545e9.11.1767089771372;
        Tue, 30 Dec 2025 02:16:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjzVX0GYuttaIVhsj3PIAp1ZJ2Zp++QasW4yFBwV4WaDkrZ/icz8/Y8CMg+xDJDk6ilEld2g==
X-Received: by 2002:a05:600c:45c8:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-47d195558bemr375729355e9.11.1767089770967;
        Tue, 30 Dec 2025 02:16:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4e91sm569777955e9.13.2025.12.30.02.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:09 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:07 -0500
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
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 07/13] vsock/virtio: fix DMA alignment for event_list
Message-ID: <c195bc45032be85c3f0bad7362f0ba0a4e8a7726.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
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

Add __dma_from_device_aligned_begin/end annotations to ensure event_list
is isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 8c867023a2e5..76099f7dc040 100644
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
@@ -59,8 +60,10 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
+	__dma_from_device_aligned_begin
 	struct virtio_vsock_event event_list[8];
 
+	__dma_from_device_aligned_end
 	u32 guest_cid;
 	bool seqpacket_allow;
 
-- 
MST

