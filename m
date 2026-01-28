Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1227E37419B
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 20:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769632291; cv=none; b=dMkLNhlgljYAuDmMDwIaZcqiM29o1wYheX4b3XA6gGRJj2g2G7r7OJ475hIRPpTDRen+jbv+4xkZoOwqDsZ2ek0BhocxFEKphT9mlhqnCYlihhLl0rCEkTs5R5c3Pfil8c2ZrQuSmaZnvjUSSLkxclFpWtMDAllcISKCwVIrCHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769632291; c=relaxed/simple;
	bh=2qvxf/62yttfNIZNAODh63qlXVSL99Ksrx5/ufwbejY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=spWucQeEZPdp7UK+KxSI6ZoQOBGAbRpIHGgcb9Gr0IgpplNp611/Jp+D3hgWRqtLoCArVjQsProuiI/E0Tngj2EQ2FJAwJCkr5uDVf2+7fpbQNJoxeEdaN1cpgCKuvxTsstz3T+alKPu9rcxbLvcL54eo2wUDb3Y5DaE7YevUUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XUXXe7xE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwcBGGuw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUXXe7xE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwcBGGuw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769632288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=6AqTWTOgRm78zpGWundx5DPK3QN0XJ8tGQTS1p8e64k=;
	b=XUXXe7xETErab3wRuyukJ0+lVBhbKkaCcNv8QLKZwc4IIIOHcz3YCrmR6f3vNH/wlZJpjk
	RnC4h+hm/NmAXYcWToR0nweZcgFZTxuS7xUNA6G2dCk/ERzre7e1N9gkt+KnsEx7+IwE5O
	OR9QHTRzknUlppVd6rQJVsvP5dNvT5I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-iWlGb3jUNo6mp8swAqWisw-1; Wed, 28 Jan 2026 15:31:26 -0500
X-MC-Unique: iWlGb3jUNo6mp8swAqWisw-1
X-Mimecast-MFC-AGG-ID: iWlGb3jUNo6mp8swAqWisw_1769632285
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-432a9ef3d86so116671f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 12:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769632285; x=1770237085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6AqTWTOgRm78zpGWundx5DPK3QN0XJ8tGQTS1p8e64k=;
        b=fwcBGGuw7IqQDPevelrNI5mPPr97koUxkOdPBeevIRXEdn2WQmQxRqzM4vbWV5CQ1K
         GzG9MFQtT4t1UxM8me4DW4lGDGZMEMK2FdX8SYol2akxmRNKL/MKMwIty3VtcOZAXl9Y
         wWS67ozLZW0GAsRqnPn39uwB0neig513SYS7rQ4feyTLBzJhhqABshCSXW7vNqJZmDFf
         A4TdMWerNpSOIlJWmzAwR31lzurm2R3U59p0qiXMV54wKq1LH3nxg60LZ94v/n0WM/10
         YOFMpQJ7sMCG/fIm2pvP57/YDw7JqNTudoYipg0ZAcyARnfbopdd6agIeA4ATotjkCEM
         Kigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769632285; x=1770237085;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AqTWTOgRm78zpGWundx5DPK3QN0XJ8tGQTS1p8e64k=;
        b=ZLwiHSoL7DF3w1ELnV3FwAZG7o+9Sxw5QpX41mMPcYpBgJW2GUT2rmV27gW/ShnJHq
         O3UKvMphXHgSmR4UtZUds/QZ456AVH9tU59QbT3KVYXZtEWxK02XJuhbvKhfjM9Mrgdn
         4cWtW9Tbf5+sp3n2QgiCsdixNYzb8/PDzbdcbkNp+MYmSlZk0r4htNZBJSG1/20MAdGx
         MV1FlgfmqSPaMP5LaoxgOn9p4ccSJZtRHVNwFTmeUwDrwBc7VLtndpuPxnVxly82uHHq
         au0rnMzQlYxofAuN6afzqtmPLF9sGjO18J7oDbvxWmFebTfgvU7CfmxH8pYkG6sX7UDg
         HlpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJV5lpTCX4Q3ScFoUEtRZ58D5/Ao7UN9mBpEAte4EsqBwRzwHf1dr6YWHz76Br9FTKXHDtyP6W3eCXHeE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfy/4ZeAEQRZYSjGjlBpzybaeJ53oLNRBdnJrSj9v7eULZq8cf
	mLMon3Ohr2oFHWrptbXg3gOlG0p2+NhuLbvZix6Q4w7DPAfvSnmIa5RTf1yB2ILPKRB+dbTAtkW
	JGkOlQccGEjuT1UD6Ug1YVPflZ66vGg/zS+ej6fJ+M/W5m6j0WoU9E/zWZaOiI3L6hw==
X-Gm-Gg: AZuq6aK5Rlp2VzmrYztkTv3wDsHckGQBh1hllvgW8iRUfZqJa6a8YIqYJnMuQVLx0RP
	7g8zPuFIs7KcbJ05EIp956+yAPc4GQdAI0HfJX9FJFLKM4ycfpwzHePzkYyhTNV+O7DVDqgSsgy
	IIViLuMDhqyx9eL1JmN9kdE0scWUteN3GOhjXhsOVkyesbJpukmWA5L3idHhf9t7GAgige7Hlg6
	w55MOaF7s3X699KG2N3b4sHt8re7HJ9nefHG6ysKsCEtsufKDLTwBrxEjTW/ddQgWnEKW1+QM6e
	mrIBcjkx49b0e1XkBqVWAXTf5Rmvx5YxqOLL+AYQsCxboYp+OvsOFXVdl2CP6ZbVBK6Z/FE48H3
	uqrsSBfWhgvPM3FYt4pZLOVKwMLhcXxshHA==
X-Received: by 2002:a05:600c:6995:b0:477:7af8:c8ad with SMTP id 5b1f17b1804b1-48069c92c03mr93433915e9.31.1769632285345;
        Wed, 28 Jan 2026 12:31:25 -0800 (PST)
X-Received: by 2002:a05:600c:6995:b0:477:7af8:c8ad with SMTP id 5b1f17b1804b1-48069c92c03mr93433305e9.31.1769632284808;
        Wed, 28 Jan 2026 12:31:24 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066beeaf9sm161529595e9.6.2026.01.28.12.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 12:31:24 -0800 (PST)
Date: Wed, 28 Jan 2026 15:31:21 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 15/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <ce44f61af415521e00ab7492aa16d3d19f00bd5e.1769632071.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>

Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
last. This eliminates the padding from aligning the struct size on
ARCH_DMA_MINALIGN.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

changes from v2:
	move event_lock and event_run too, to keep
	event things logically together, as suggested by
	Stefano Garzarella.

Note: this is the only change in v3 and it's cosmetic, so I am
not reposting the whole patchset.


 net/vmw_vsock/virtio_transport.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 999a0839726a..b333a7591b26 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -55,15 +55,6 @@ struct virtio_vsock {
 	int rx_buf_nr;
 	int rx_buf_max_nr;
 
-	/* The following fields are protected by event_lock.
-	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
-	 */
-	struct mutex event_lock;
-	bool event_run;
-	__dma_from_device_group_begin();
-	struct virtio_vsock_event event_list[8];
-	__dma_from_device_group_end();
-
 	u32 guest_cid;
 	bool seqpacket_allow;
 
@@ -77,6 +68,15 @@ struct virtio_vsock {
 	 */
 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
+
+	/* The following fields are protected by event_lock.
+	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
+	 */
+	struct mutex event_lock;
+	bool event_run;
+	__dma_from_device_group_begin();
+	struct virtio_vsock_event event_list[8];
+	__dma_from_device_group_end();
 };
 
 static u32 virtio_transport_get_local_cid(void)
-- 
MST

