Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10D329C5D
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601420; cv=none; b=dOb0Q2HXfqibKaBUAxGG6pvtSQpicEQowM+5WUwXzyac/aBN5rLGNY2M0BF2LK9iy4vyv2CHk0wpketH+W3X1TWxR5v1sAfw8sMnY85Cr+XwrrE35nKLnczE+Maa9ooBYoM3NCCtEkPj4ypi46wL+H/HyJdo7Veb0QBPWLr1dnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601420; c=relaxed/simple;
	bh=S9cU9rMSKLAHqC3C9VUi030/VnGNztyhDP4UPj+0Vaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M507vWNDf+sLv5t1F6xtYt6+PG8EDETedIboRMS8eJN34EH7bLRghdi7xtJQoRWVy1d8GhUqDlNRVQ2jlZZEwW1YThwYPfdNeTOIo9qKHCkvcZToKVchig+LsgBNZN0wzMc6QhRuWDp9FRctwbz2xe17i00wqdVuSNiZj/Zs2Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHMu/bTI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5VSpuzC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHMu/bTI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5VSpuzC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TvLvTQPEJKAtkqGovGo2GHeF0+EOLKvEuwFpv+PiquM=;
	b=EHMu/bTID2Pkdo8VYM7TcofOJpTzj5lUk+sMHN10g8txKZJs1CMvhGbw1AN4kWdsL0Z4CE
	xC6eTh0UAZi74kMJopaoU/gMxdhSH44OOcyWIPpI6KTEkuZGqrAepHBPVmYjo6neohyHHT
	UQm0PfYG2F7IAtYpmUCD667zyFUqdSs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-7C33eDGHMC2Go3OBDgQLAg-1; Mon, 05 Jan 2026 03:23:34 -0500
X-MC-Unique: 7C33eDGHMC2Go3OBDgQLAg-1
X-Mimecast-MFC-AGG-ID: 7C33eDGHMC2Go3OBDgQLAg_1767601414
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430ffc4dc83so13294121f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601413; x=1768206213; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TvLvTQPEJKAtkqGovGo2GHeF0+EOLKvEuwFpv+PiquM=;
        b=J5VSpuzCfEHaaV0PfngwJ/PAHynoUlG+tVufyQ1It+kh+BWnkL/pDXkLquPvP8PhaE
         RTkkg+5x8fqgihaCUpJZpFJAgqYL8ICnp+FRHSEDIQLIBoTaVdSxtFHlzGdXIjRLvKiI
         LOw9l3ILo5anD1bPQovJIXG3YH8o2P0bPOoK0hsSplrw49jxfi5FpRHrZHiCVfRMNwBi
         bhgwMNhrGDrYP7Q37rAK8EfOwEfopGXHftivLnRz67hPRVFHp/LlhvCihl50f1fsorSk
         rbPD/iAw1E//M4PMcKsOljyg/HT+Z+5LJXzBzFwgUXasV50sdG6MMsj8Yz+vjiVysoUX
         D6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601413; x=1768206213;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvLvTQPEJKAtkqGovGo2GHeF0+EOLKvEuwFpv+PiquM=;
        b=G2Y9cpxWegvlYL/qGGx6lNZeDoAgvWffjjKCDthSUd29mOaJjEHAI+xM18qiCFVBTJ
         72Rmi5jranU7NIHbWXqBspot/pxRNm0F7uLBhXehoCOt6e+b/PMUktz0a/XqPrOti+Pg
         ITouFhh2uh4RTeAjVjuRK2FzPUzMHPCNQgmFnh8Jb2TsE6oQyczbQ45rO/qq6PiKkL/K
         3YrBvpZ7D6WmNDdLaJmoPK8qhStfAiOIHDsIWG8VCgZa2MXDTzw98aRO9bXA0xTul5yM
         PEmZcw5/oac0dH7Efl4Fzl9mCCOclKGrjmr76tzyEQLAA13IFopIYUTzQt4IyffzqgUD
         ALcA==
X-Forwarded-Encrypted: i=1; AJvYcCWckzWiW65EFowg3rNDJhkQd5pcT83cGFL12mxjDDR+wo2InDyroRIurfUfraaPSSM0IpdCULNMAF6lReE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ9Tk+PDYeYjyHWE9l7BVhDg8oN8EV1il57yrIohS0mu5cGWGk
	5Uukvm8LhTg101aQFYM6kpA2jENrS9MD+Gg/YwHlSqhbn9boTMvVgo2yai4GRqvLnkwtFzV/EHz
	IxklZjvSPcoKO65pl0lJoYITpH/NKj/OXFpY1ZZC3iAdfWi8tZvqo0fEJuaTMgjO0YA==
X-Gm-Gg: AY/fxX5j+N8GDScvxzkrG5NDvMphAgq6QDjyhQt6dbjCsbnhQiwZNqIJWDHrSGjcz2y
	GmAdiG18zYvlHShD0yN7nqLQb1IfUxKsne5Qqmu/AnJ0McTYPpjxZ0bX0UBTagvMmFo86oHS3D5
	+po+wabzyvTT1B/7lSREaduBjZWFwVfXwKrDuS42SYpzhmcA9+OuC/N66d7++071BouIGgWug+2
	FztY/qRhdkYKPCj9/zYBb3M5S4/n9LOgDjcmfxi9UHHVOhza73sva97V8fa5A2Ga+1wDhE6N3zx
	RVIZFl6uTnVnGB6hq26xNHXk9FM2O74JWabe4czGrXqEMu6BRL7nTEUDIcMKN9IY0Pa64nMkf6B
	uBqVGxnzNPUTLinDBSAMocPSG5jpUefBOrw==
X-Received: by 2002:adf:eb04:0:b0:432:84ef:841f with SMTP id ffacd0b85a97d-43284ef8d0cmr31362900f8f.38.1767601413471;
        Mon, 05 Jan 2026 00:23:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFx7eWbROO38mdjmsXsZ8eTRhzoo1KnfbPFeP9XiXzVU5+PKMGQRYrz1a7izR0YG2kvu7gW1Q==
X-Received: by 2002:adf:eb04:0:b0:432:84ef:841f with SMTP id ffacd0b85a97d-43284ef8d0cmr31362856f8f.38.1767601412963;
        Mon, 05 Jan 2026 00:23:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa2beasm98160481f8f.33.2026.01.05.00.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:32 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:29 -0500
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
Subject: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
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

Current struct virtio_scsi_event_node layout has two problems:

The event (DMA_FROM_DEVICE) and work (CPU-written via
INIT_WORK/queue_work) fields share a cacheline.
On non-cache-coherent platforms, CPU writes to work can
corrupt device-written event data.

If ARCH_DMA_MINALIGN is large enough, the 8 events in event_list share
cachelines, triggering CONFIG_DMA_API_DEBUG warnings.

Fix the corruption by moving event buffers to a separate array and
aligning using __dma_from_device_group_begin()/end().

Suppress the (now spurious) DMA debug warnings using
virtqueue_add_inbuf_cache_clean().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 96a69edddbe5..6ff53fc8adb0 100644
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
 
@@ -89,6 +90,11 @@ struct virtio_scsi {
 
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
+
+	__dma_from_device_group_begin();
+	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
+	__dma_from_device_group_end();
+
 	struct virtio_scsi_vq req_vqs[];
 };
 
@@ -237,12 +243,12 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
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
 
@@ -257,6 +263,7 @@ static int virtscsi_kick_event_all(struct virtio_scsi *vscsi)
 
 	for (i = 0; i < VIRTIO_SCSI_EVENT_LEN; i++) {
 		vscsi->event_list[i].vscsi = vscsi;
+		vscsi->event_list[i].event = &vscsi->events[i];
 		virtscsi_kick_event(vscsi, &vscsi->event_list[i]);
 	}
 
@@ -380,7 +387,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	struct virtio_scsi_event_node *event_node =
 		container_of(work, struct virtio_scsi_event_node, work);
 	struct virtio_scsi *vscsi = event_node->vscsi;
-	struct virtio_scsi_event *event = &event_node->event;
+	struct virtio_scsi_event *event = event_node->event;
 
 	if (event->event &
 	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
-- 
MST

