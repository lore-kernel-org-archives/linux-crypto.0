Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0167B67A
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 10:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089787; cv=none; b=TncwlSDBvbyP9RZa92rJrVyFhNIjGuRF+pKjg3OR6/ON8osfp8F0aY7U9Rknl+0mZmxWlYSvcynoPe72OWFa+HcVayoijnPcIUYWozMHbWvstyd/AwHLdyzZRC0scBYOjupb+O1TACQSqRytE5mVN6EvoS+2V0Y82OHaHXecR8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089787; c=relaxed/simple;
	bh=GajfymOgkcPkdkaB0RAuWogZvPX10QSebBxhGC7QBSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KntJxXKemoShuqvgwowkt3bV2HQiHA/CClfc+5KKRbWPZq7Pk77wbZfdbnkJ3U3FrQarR8lrZgjQG9898py4IKy/6gw3AUWe11zMRl/KOKtmZiPCGuft96rL5ohC2wHj9UjlJo3UCm73iMAUWgN7+5qWMTjtpW20LjOCu/aVWu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GtakrPnD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2y2cdSA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GtakrPnD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2y2cdSA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGgwtCzFbkcOM+PDCBbTUD1kyCibNYOBRdnG12nNQ/w=;
	b=GtakrPnD9VVF77RKXUv5av0bgB58CRcxJ4hjMSeD50drQAJiksqcggGsoK6cFAbsgIViOP
	Q/CTu/yIkyAhh02nGNBBjpWNWfO2rdUo3/SWvp/u2vCK+q33Xr3iQHBmm8EnmSnaSLnTgr
	KC8qXZDYrG7Lf++5d3BDEXv5bl9w9SU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-yrclIHrHNMKZhiQzkM1j2w-1; Tue, 30 Dec 2025 05:16:23 -0500
X-MC-Unique: yrclIHrHNMKZhiQzkM1j2w-1
X-Mimecast-MFC-AGG-ID: yrclIHrHNMKZhiQzkM1j2w_1767089782
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430f8866932so7996209f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 02:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089782; x=1767694582; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QGgwtCzFbkcOM+PDCBbTUD1kyCibNYOBRdnG12nNQ/w=;
        b=A2y2cdSAR39FCx/iw/+1ov9QmY5nnpDSF12sGmOmeivdLCVvkEyI2LwIA7RYqBWgZg
         Q+BZrZbnaXTCn5FIZab5H9g6e823x3F6J0X1jKqqArC8DJhgX3GcGqTCbUnqOIrL53Qn
         0TSzyaXuDi73OdzfqBC7/1s2W+eHbpK4MsDhuhjfa6diu3CmIvWXPvLuG49jnspIiyGY
         Q4YKcaUuMzk2znQfINVQn047hSMCRmNHKEPq7LO13y8OAgzwtFdJTjOQxTb9keMueGHH
         1oHgG6okXHS84f75pjEVaVlboTahWjim3Rmya9YOEEIDwNyJclZB0FKXgMlP5viKPk8P
         Cm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089782; x=1767694582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QGgwtCzFbkcOM+PDCBbTUD1kyCibNYOBRdnG12nNQ/w=;
        b=lBFZCXogKXVGJXHxnDe6peWNLdnqAVtpGXy+AIoqd3ggiechVa4x0WyFgbrPxHN1mi
         SWeKFqsZltVVbF6R1y174F7DvuEekYz8vyq/HCoubd1otUaJlC3OfTvfLqfOEvUZ3Dym
         04rhtLRzyv9bJygzsnu/GKUTiEjCnih2O5WEK/yS7RE7uaeoNs1I4b6Qul8mGWe6e+97
         O1Dj5Nt3OR/Z2SJAQvBaJRshfQ5HZoAGD5L0VXd6YxU3SSsFI38lmze4J424Va1LWgyA
         2quUCW3aC4i3VIF5BPX+x5j/sBlr71Pu0aqTNXgJGzeyH/YckU4+L/+ir3cw2uRmfSkE
         vUgg==
X-Forwarded-Encrypted: i=1; AJvYcCXqZNpS8H2GMdMwwE51gtS3pqzS1bflVCHsiE/4bztX2HiUmT+IS6KVK0KJEv54IKYTSL9wmNh9MHEJ+3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrVJUXcYW1O9divRnAKCiUkbl6Shg0OcoCRHVbW1I91Jo6sJwj
	Qr6z1ZF91doS3H5wonWQ3U5jr+23gWjzqqB8T6zfTDdoYqT+hsklUM5t+WBEmrv0cQJDa+Wyru+
	SWJsR23wMUuouEK2iaFgEiXzoLC+L0TIfdWhBzRgTtKaT+CpssEqTMN+uJqIlbrx1LA==
X-Gm-Gg: AY/fxX4m93WJXtpCGevdxSkgZeL4YjIPe9Z18BZ2WbVsIS+Qp6UyEPL3+i48ACEowvi
	brfnBP/Ajt+u25t6AzMWwUhBa1j0JFOz4k+oiBHI4Nisb5WM/1BEiD5deuOCibFdVyIkif3T7i8
	8gFSVcd7ryCAUZEZlF3byd77qMwLTi4N3BM+PCQBzpwh5BnLpiD8046n2iW7oc2fb+OVLWFhjtL
	qjn64DA3OCcKVL5nE6WPLrKqi75cDurOex5ujqJDWBeYZRzNKiDE2ahwkf7CAPjtePWKUOabV7m
	S1VjD5mgLDGTZ9caO/0uxzRcQSi3PpYG9djEWMzrf+ccWtQCKZAV/wppUlKBY8L/NP79LlY/4em
	iqj8INv9p5aQQOjR7A+cb/4BV/NgQZUglRg==
X-Received: by 2002:a05:6000:40db:b0:42c:b8fd:21b3 with SMTP id ffacd0b85a97d-4324e70b2c0mr42681806f8f.57.1767089782068;
        Tue, 30 Dec 2025 02:16:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4XayC4ymFC/bWs00E9fRypXNJ9u10o1pYrVldfljsEtp9WZrRKo/7Fbn9vwkm8J3pD7bCzw==
X-Received: by 2002:a05:6000:40db:b0:42c:b8fd:21b3 with SMTP id ffacd0b85a97d-4324e70b2c0mr42681761f8f.57.1767089781587;
        Tue, 30 Dec 2025 02:16:21 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432613f7e6esm57256214f8f.21.2025.12.30.02.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:21 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:18 -0500
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
Subject: [PATCH RFC 10/13] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <c238ea28521dc0433350f848361b46e7d451b96c.1767089672.git.mst@redhat.com>
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

Current struct virtio_scsi_event_node layout has two problems:

The event (DMA_FROM_DEVICE) and work (CPU-written via
INIT_WORK/queue_work) fields share a cacheline.
On non-cache-coherent platforms, CPU writes to work can
corrupt device-written event data.

If DMA_MIN_ALIGN is large enough, the 8 events in event_list share
cachelines, triggering CONFIG_DMA_API_DEBUG warnings.

Fix the corruption by moving event buffers to a separate array and
aligning using __dma_from_device_aligned_begin/end.

Suppress the (now spurious) DMA debug warnings using
virtqueue_add_inbuf_cache_clean().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 96a69edddbe5..b0ce3884e22a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -29,6 +29,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_devinfo.h>
 #include <linux/seqlock.h>
+#include <linux/dma-mapping.h>
 
 #include "sd.h"
 
@@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
 
 struct virtio_scsi_event_node {
 	struct virtio_scsi *vscsi;
-	struct virtio_scsi_event event;
+	struct virtio_scsi_event *event;
 	struct work_struct work;
 };
 
@@ -89,6 +90,12 @@ struct virtio_scsi {
 
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
+
+	/* DMA buffers for events - aligned, kept separate from CPU-written fields */
+	__dma_from_device_aligned_begin
+	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
+	__dma_from_device_aligned_end
+
 	struct virtio_scsi_vq req_vqs[];
 };
 
@@ -237,12 +244,12 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	unsigned long flags;
 
 	INIT_WORK(&event_node->work, virtscsi_handle_event);
-	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-	err = virtqueue_add_inbuf(vscsi->event_vq.vq, &sg, 1, event_node,
-				  GFP_ATOMIC);
+	err = virtqueue_add_inbuf_cache_clean(vscsi->event_vq.vq, &sg, 1, event_node,
+					      GFP_ATOMIC);
 	if (!err)
 		virtqueue_kick(vscsi->event_vq.vq);
 
@@ -257,6 +264,7 @@ static int virtscsi_kick_event_all(struct virtio_scsi *vscsi)
 
 	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++) {
 		vscsi->event_list[i].vscsi = vscsi;
+		vscsi->event_list[i].event = &vscsi->events[i];
 		virtscsi_kick_event(vscsi, &vscsi->event_list[i]);
 	}
 
@@ -380,7 +388,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	struct virtio_scsi_event_node *event_node =
 		container_of(work, struct virtio_scsi_event_node, work);
 	struct virtio_scsi *vscsi = event_node->vscsi;
-	struct virtio_scsi_event *event = &event_node->event;
+	struct virtio_scsi_event *event = event_node->event;
 
 	if (event->event &
 	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
-- 
MST

