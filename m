Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD452FFF8C
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 10:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089810; cv=none; b=Bc+rTNCeHI9R9mbPdg/77oOE3bcv2nP+avWjTkAXeFdPo/ohY3WxYTbWUZNonH1roYnZaQTnDDeIMqTVT2V+9BJO+x3JjpQY5PUmmZ5Hpvnfk/9q3xXr+lpcE2rRiJ3pFEz8LVz2pW0zTDomNpRQEsxjMAbnDQOnuKLEicP7Lv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089810; c=relaxed/simple;
	bh=t25qf9RPlFFNCOYEONgor27ZqKrRgzzuNghNz/03y7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFNbDCtYq1vKeqUikN7ZCz8xsVFyqilGF72ZPJir4RuYYl+5sXK+SM12jPdfgNXxJLeK7//577eb93e//3ZI80AqOXNko6WgvBlROP7+xl+trHuAPtmeGfv7X3cp1Brran6R1iHoqFUbRrWgJdLEgXUSXxonlRTeUTdZrbg/gUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (0-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q9U2zEPU reason="key not found in DNS"; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZO31RtaE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9U2zEPU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZO31RtaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BWhPgbCVUCKqyPHyev/7ivEXEOB+Fryu/YrpJpGLduY=;
	b=Q9U2zEPULaDpd0Q+BpKJZ9l9z/5jLwEjJn6Co5+nq2V6LoT+u5KH6/zBGnNotw/ksCsB0v
	Cm/gvA7EkW5BMeTqDy29bDbhYLKK1Ui+KwuwVPAh0bQJXFDVe+ihQVTsktSjaRiGwU4hJz
	mZZ57GgkweUS9hsIvTLBnGZm+72sdrM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-zyVHjtt6MOiUTaCrAw2PhQ-1; Tue, 30 Dec 2025 05:16:42 -0500
X-MC-Unique: zyVHjtt6MOiUTaCrAw2PhQ-1
X-Mimecast-MFC-AGG-ID: zyVHjtt6MOiUTaCrAw2PhQ_1767089801
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d40e8a588so21717745e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 02:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089801; x=1767694601; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWhPgbCVUCKqyPHyev/7ivEXEOB+Fryu/YrpJpGLduY=;
        b=ZO31RtaEnbRwXI0pZvzk7MmrN6X1+J8FWRvLdtMprqkQxtlxzAaySEyLAPtuUG4ahV
         BBL2Cfzvzv5yMQ5FfEgrnrR1XMrzbiiLwHNSlU/RiA6N/JiLIVcUldUMPrE4veCkQEi/
         cOypKUHHdU9cRHuejX32Es47rs1z5YqfnBSAkipXOGs7Rz3Kddf5iIA6ZDHCKVNbBKQx
         7geuz1xOqix+CC4hB7szuvVNA2MOj6Z+CJe7yq5ya9yAiGvLFRYw05DzqI56EmKxcdmv
         g6umauV3bEm1g7SkR173wyFuK1+wh9H0DJzovyUrHoBeH31nGx6KsjzZaEcf12qsp+AX
         mWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089801; x=1767694601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWhPgbCVUCKqyPHyev/7ivEXEOB+Fryu/YrpJpGLduY=;
        b=fobHzb1/UI1RyEG0SIHlhnG5ABvwWclFzO0D6Grb9ubb41BtAcaOM5W2wBMYUYOKp8
         ET3gTmAC2IrrTKAbXFIPffRqEZd2Oz4CvNDmuv+h3DFxYVF8vncN+gpl6DrNjl3O+kW6
         11fXHkpOkFN77hK2CWiskcarOjK99DSd+1VbywwYn65UrfeI90UOiOV8+Mc3yarHID5l
         SoDLsGhL/BnCLZnjfFoJVLFGX7nHJPAj95goEOzotEvlJhDv2sVKFPQtKSrwGfRfUErJ
         J3g9criat0VwNbXbPp7JPRcgJ3lSh1k6qzPTEUF4s0fh8OgrudXha7liGCCLK4kwIrCZ
         LPsw==
X-Forwarded-Encrypted: i=1; AJvYcCXrgjopkSPAaIumb7y6dmTzf8YeHS4DUjfw6b6d8w6Wwm+TSgWJ61zSVJ3KVa07vHCSUnbBDePUn3XPQnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyksaBEZbOJPVlqpqDz9eoEOMGPNFsVuJYtEpk28hXfhRJNl2kg
	Sv8coiLBPa9/4vmdOohT68xe28RtkPVgvzs1uErVlVDHjpOao+mL12+eAzaL/1ZowEt9cyeSWMb
	577D0FLjUF60OsnKAvOLMYpvmuD51hVXjfMv/TK1yqgnxnOXifb6bkr9RHsmsRa+rhw==
X-Gm-Gg: AY/fxX7YMt18afH+6rKsmzyJlVLv8YkvpJfPZvcnpeVqUwP6eSUzL26V1xjEHFc+5EO
	OaZMlQtFXAk0lErJyDJ1o6tKx8O/nkskxSEDgxy1Bi0Jvauen0Bw1y7RB1d8f7G3bHOyd5iLw5M
	lTWOgKy5fD+ShD0aQP9l9fZxr24VVc343jVvvaF4msDo/xfzWeD++J7+L9V69SfDDQPI+dfkXiE
	1cfX40sEnW3wfegbBUjIzRxHICk5FFCEmRXXMxdbK8ouGUfHwlLm2hdYo4ArH24L9AGBUrV3XNR
	iR3IbYIkHv8mEYbfLHQJHzjZsggbjSx9T7Grto5FTo5okTjmEzTsOu9JVOVxxl2fYkuLBLoxjdb
	5av4d4rqngXqWGQrpCfUpzPhtz3yumykJVQ==
X-Received: by 2002:a05:600c:a413:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-47d1cec8f39mr297842035e9.18.1767089801358;
        Tue, 30 Dec 2025 02:16:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEf8BCC/QkGwDEfP5RddRZimNY2rmw3JwKmzFqtMOWIF8UhfXRlD/gfjFTVaD3LdsD6J0zJDw==
X-Received: by 2002:a05:600c:a413:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-47d1cec8f39mr297841845e9.18.1767089800959;
        Tue, 30 Dec 2025 02:16:40 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be279c5f8sm610553745e9.9.2025.12.30.02.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:40 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:37 -0500
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
Subject: [PATCH RFC 11/13] virtio-rng: fix DMA cacheline alignment for data
 buffer
Message-ID: <b2e350ee2542c5c372b2973fb68d4fee67929d5c.1767089257.git.mst@redhat.com>
References: <cover.1767089257.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089257.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Add __dma_from_device_aligned_begin annotation before the data buffer
in struct virtrng_info to ensure proper cacheline alignment on
non-cache-coherent platforms.

The data buffer is used for DMA_FROM_DEVICE via virtqueue_add_inbuf()
and is adjacent to CPU-written fields (data_avail, data_idx). Without
proper alignment, the device writing to the DMA buffer and the CPU
writing to adjacent fields could corrupt each other's data on
platforms where DMA cache maintenance is at cacheline granularity.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index dd998f4fe4f2..fb3c57bee3b1 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -28,6 +29,7 @@ struct virtrng_info {
 	unsigned int data_avail;
 	unsigned int data_idx;
 	/* minimal size returned by rng_buffer_size() */
+	__dma_from_device_aligned_begin
 #if SMP_CACHE_BYTES < 32
 	u8 data[32];
 #else
-- 
MST

