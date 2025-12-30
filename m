Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A231322B68
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767112840; cv=none; b=Fl2u+V4Z1UONLy9q4CgbrK0K6ZZ/DNBsv9UYraufFBk/qBIhww6jjgeOy8h2JDNZ0pexDTknq+1MQM4th+ky8qAzMjvCzrIAd5BmCsGKxUDrjlGUZN/0piVSpfvtbhSsBOkgMd2gyXaHB1rcRAxpQfKRKxpUAmEwBwVJYpSDEMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767112840; c=relaxed/simple;
	bh=R3ssxNR/IfKvvzigNkiBKuIwzZmdFCE30Vek2VE5a/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGkFh2CZsE6zb1NBUFKmCoz62fgCJ3uA06EI85goSWBHkm4liVy4FJcl8xYYpiyIGx40bhFSnU8o/XlT1XTAR4pLOTnQoVQJAd6IkPnbzqZwAd7KlvR52LDOkT+dQ6JmlcwXdynYzKjPKdzy/uEw1gVqd7QOrf88xG6eWuFfNx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XhmTzisR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tGsVd1OR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XhmTzisR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tGsVd1OR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767112838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7J8z1fD7DSMGZ6iKBx0OqXIx7XfW+ZYePKweShXuH2A=;
	b=XhmTzisRBqDXP2zya0WkEnQmEFPM/N7ix44c4yTCVblE/BwU9BU6z4CYPKbfVPOOakG7Dn
	2L7Ft9kT7gKOuN/qp5NpGx2XBY1vL6Kqi3tVjYeFsQfNFKKzxOAZcoraUGqD53PYB++B1B
	xl87hYgfqjHI6PXHFJmCQHWJfX/TsN8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-PTEYVz3vO3e1puGwwStQTg-1; Tue, 30 Dec 2025 11:40:34 -0500
X-MC-Unique: PTEYVz3vO3e1puGwwStQTg-1
X-Mimecast-MFC-AGG-ID: PTEYVz3vO3e1puGwwStQTg_1767112833
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43101a351c7so8064217f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 08:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767112833; x=1767717633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7J8z1fD7DSMGZ6iKBx0OqXIx7XfW+ZYePKweShXuH2A=;
        b=tGsVd1ORU0Eh9v8efXZT1lh+FgCYbl5O7LiFefA28EVmRKhFwjKIK+BkIFPA+HquNW
         I/iCySQ/Hi/bFw5TujZNT95fbDuwnDGI5r2pHqghiLDrfJvQvWAK2OtX6kVUYKSdDHP5
         MzILer/dNKCGfsj9rQs5AUI4Y6CUNV8J6pMAB2WE94zrFEkLHx9rWvO9YDwfm5VrO+VR
         Kl3R35DSLBsN9u6Q9JLMx2Ew0qnQqn4QpfMGN6a9DbosJnFKLKUNTjaoDhXVO+Oh0812
         dSSgXSlQks9mbZxqnSW/569qUnJLt2nbu1hdPQdOW8Hob/Bsg2dhVoSViq+DAHYiHGpJ
         1LGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767112833; x=1767717633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7J8z1fD7DSMGZ6iKBx0OqXIx7XfW+ZYePKweShXuH2A=;
        b=ej8Pu77c/je9RBUBF7Yog33exL00Ie24LWSMbqjOWbCn00h+3Z233gwNa2adTu4ELl
         RUGk1KuNEaM53Grasf8GwaY9/KEbNOJTQRKRB2sSrtwV2o8tJGt8yrJCjz0eIq2gHtBq
         YLlAX0h5D1zD8yf6PfsP4vuLQVmKdQ9KU6uJ3Ul75mbPTHsU+ATvHSwjPVvL+rA4JS7L
         gSZHy00K7xGJEvRCSu6XCWpi9jD//YksBtO2mej6uYUxA4u+EXxpwxL0pzr3NWaoZ2qL
         yuy4+brAmlhy651aIvTYoAWgGAJTTTZ8M04I/5GMeXpmHy28ejA2YV/FiGoRN1GkbNrN
         HQgw==
X-Forwarded-Encrypted: i=1; AJvYcCUb0UaGvFRJnacdyWSNC2AOhccKX48ZPgBGb2EjYP6zhWbbLFCIBLoTpfpsZzFaZ3ZJetXhLdlG95+Vq1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDnxze2weBRAceb+RqQdTeNlO3oU0OFxkzi6PIDWCiVEdSc0TC
	pLfPGJjIjxLaKSdF67CXZjA5DIU+tjzYi76bLPVl2FJJBGb99UTqjAP4oYnkUORZfrq+3fZ/MLK
	NBdYXhsM6xMJCR2KilWwOyWGCswLMF99W6ljRK+uzeG/hwfW84ug+OVCWdlyJ9pD39w==
X-Gm-Gg: AY/fxX4YceamYVkQK9wPpI5KqymcXseLXHXqpbz/1mI1mX7Aa7ALGW16o9taRPRfnJJ
	KSQLQ8gIEtcES4zuj/YPAbe4PbIp0L+/C7a+rwtnOWXAqWgDjjlsDrHK3ltGA1irOH6t96hK+pc
	zwRuQwUVRnh7E0WOjWEdyn6XifvMfHPv7qMjREgsgBHqE3VX0kEjb0qRdUnPe+I3iYERCDeUQyd
	/+9SYJ0JhZkPHbW5FTBwMJuRg0J1fbmj8BmpoCBcR52ktmzr5UVnJkgmC3w8Ew4hOefPXhlAzI5
	pYsc1YSf0+RSH62+FRzApSLvAdGPAGhk6LFZUY0N5gdRv0AUDlgt3X0s1//cKGnGAdPSRRVw+dy
	Z7cqZ815f/L6QjUv/cYbyb0TT6RDEkmXaUQ==
X-Received: by 2002:adf:f144:0:b0:431:855:c791 with SMTP id ffacd0b85a97d-4324e4c1501mr32588436f8f.3.1767112833335;
        Tue, 30 Dec 2025 08:40:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECVSdNBMTG9k8N96cOa931b+MOajxv263SWbXaTmkKbkTS3ub+IC9yjT+L/YMFbjvC3biqWw==
X-Received: by 2002:adf:f144:0:b0:431:855:c791 with SMTP id ffacd0b85a97d-4324e4c1501mr32588393f8f.3.1767112832791;
        Tue, 30 Dec 2025 08:40:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1aef7sm69573295f8f.7.2025.12.30.08.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 08:40:32 -0800 (PST)
Date: Tue, 30 Dec 2025 11:40:28 -0500
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
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH RFC 14/13] gpio: virtio: fix DMA alignment
Message-ID: <6f2f2a7a74141fa3ad92e001ee276c01ffe9ae49.1767112757.git.mst@redhat.com>
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

The res and ires buffers in struct virtio_gpio_line and struct
vgpio_irq_line respectively are used for DMA_FROM_DEVICE via virtqueue_add_sgs().
However, within these structs, even though these elements are tagged
as ____cacheline_aligned, adjacent struct elements
can share DMA cachelines on platforms where ARCH_DMA_MINALIGN >
L1_CACHE_BYTES (e.g., arm64 with 128-byte DMA alignment but 64-byte
cache lines).

The existing ____cacheline_aligned annotation aligns to L1_CACHE_BYTES
which is now always sufficient for DMA alignment. For example,
with L1_CACHE_BYTES = 32 and ARCH_DMA_MINALIGN = 128
  - irq_lines[0].ires at offset 128
  - irq_lines[1].type at offset 192
both in same 128-byte DMA cacheline [128-256)

When the device writes to irq_lines[0].ires and the CPU concurrently
modifies one of irq_lines[1].type/disabled/masked/queued flags,
corruption can occur on non-cache-coherent platform.

Fix by using __dma_from_device_aligned_begin/end annotations on the
DMA buffers. Drop ____cacheline_aligned - it's not required to isolate
request and response, and keeping them would increase the memory cost.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/gpio/gpio-virtio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index 17e040991e46..32b578b46df8 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/completion.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
@@ -24,8 +25,12 @@
 struct virtio_gpio_line {
 	struct mutex lock; /* Protects line operation */
 	struct completion completion;
-	struct virtio_gpio_request req ____cacheline_aligned;
-	struct virtio_gpio_response res ____cacheline_aligned;
+
+	__dma_from_device_aligned_begin
+	struct virtio_gpio_request req;
+	struct virtio_gpio_response res;
+
+	__dma_from_device_aligned_end
 	unsigned int rxlen;
 };
 
@@ -37,8 +42,9 @@ struct vgpio_irq_line {
 	bool update_pending;
 	bool queue_pending;
 
-	struct virtio_gpio_irq_request ireq ____cacheline_aligned;
-	struct virtio_gpio_irq_response ires ____cacheline_aligned;
+	__dma_from_device_aligned_begin
+	struct virtio_gpio_irq_request ireq;
+	struct virtio_gpio_irq_response ires;
 };
 
 struct virtio_gpio {
-- 
MST

