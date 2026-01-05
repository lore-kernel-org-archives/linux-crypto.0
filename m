Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B5313267
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601390; cv=none; b=olM3nzOF2EZ3CJCV1zmgutGDe9GpGESuBZWvOfADQ90hV75TbSLBvLStR5k744ht6O+ZS3zkqDTTyJZgJKbMVxn19Gcu0usOQk/kgCTeDLmTGZgzws++O199LwbunmwXCRdLo44sHq0cqmgyjkIlKx53N9TgBgXVqH3emY7pGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601390; c=relaxed/simple;
	bh=prNYGYHAMpr2WjcHI5N+V/0OjaLMaL48hqD0tOu0jIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5hXNnP7rnJyDbaub91rWNJqpz+1dmbuRR8LyP1slEsgK/9TWlVVBbOjxSGhSrHSMs2JOhKsjZ+pTR+zYTmj9aVglYSA3H0IITgTf92SurQMIB5ehTjB/xhYwexuqRTIM/BNgPVFmQ4BHUHMYHMoBC5N6L1MutD0lv+6ZvnJ6Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zp4syzvk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LlTKn6Vt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zp4syzvk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlTKn6Vt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW7mLQEFNX/sa5+JF2UQBkqoBaqIc5/VpH7fDXfLlqs=;
	b=Zp4syzvknsVRiHXLhr1adTPg7UvYAUgLCBM+Nj+qI7+njQTRCGc78bPqBabNVU5RkubAW1
	S7UyeHODo/3oy3YN1pppwqmkWbsIICJu567/6hTD9+26Y826/ZaRF6vVFkx+yGAz2K7wpS
	RvSNqTBhEB5AEe1BSuFgomhXAxulaZ8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-vm3FmjmhMxKD6oVzDNYAeQ-1; Mon, 05 Jan 2026 03:23:03 -0500
X-MC-Unique: vm3FmjmhMxKD6oVzDNYAeQ-1
X-Mimecast-MFC-AGG-ID: vm3FmjmhMxKD6oVzDNYAeQ_1767601382
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fc153d50so10724427f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601382; x=1768206182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vW7mLQEFNX/sa5+JF2UQBkqoBaqIc5/VpH7fDXfLlqs=;
        b=LlTKn6Vt5VZSlWqvNo95rjH7QcjTqmevzhcFdafBlRMtrFsg393kNfHpLthMx0LnVV
         vNGY4I17PqR5/A1CYAvKuZUVDlnoAfWJ6svgNynzEFVm5+qdyMGprnko1uTM9RiNCUKN
         kF3u7GUAA5b8Gni6esWpiA/RBnDbdbZ5xN0w+G8IAu11M7uHdYjob5i81/H1T+JccJ0j
         qv5P03j7qTAyWBvd1jE7YK3jTOHSs3/jNRdOM7up8oT1SMJEl/1BY7vMBUDs4tZvsQwh
         AR3Tkh1LmBBr5VEQzaQkl7VBfvNUn0CJ3kQTSFprNCIEANiCKV0OhDtkGZcUrxuWh867
         jLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601382; x=1768206182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vW7mLQEFNX/sa5+JF2UQBkqoBaqIc5/VpH7fDXfLlqs=;
        b=anjMC0fR8BtTvGNkcN1iMDkyv/MfDt69jIMkyJWOj49Ba8y47DLM/fevuxyDdepHiP
         zvHx2Uaj7LqZTfuQJU6QA2/TkqSFmhy7+Wh6v/BpGnwe0bruppEj5GhNCChU7x+GI5j+
         O7fR87J2Z8qvmBiCXAn2HJiPy45TTZNPphsPXlPgypgKwz/SkFuQ+IOilDBPcPmfsjmA
         s3QTfkuKtK/26g88lOgTWdt+F1ZvMeFw0HjT3SHCWdwYRUSKFJFnEZITva0lB5hjEE1A
         hj6xGDdaUv5g4lKkKeiDUSPp9CxvCe+WqMS1zOxY/OchYJZNZudmt3cnmg1ihAkLaGCq
         3+7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNx/5KwCIhMzSGf6X/6N4vj1oKZJfAmX4ki/3C7Ie6c5aobQZJ7eB7Nc9DDM3s8WtHv9FxqSi0DsWDkiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLEIaI8bH+EN0aJjLhPSe6u5Yx2paFf+JvtR7cB3xbbzs0nLTO
	ikMWYBDgbSB+xHYNZl/MWbHON+cEtWAnyB/JrHJO+UPoxBmUXw9jpv0NLnorMERZUh7OFzuh2MP
	zpHepVHXjBwrTdwUaxKFeOQKvr1M2/xo8dR4I0zC8zR21c8vgJuJO5pnu0soBuZrkPg==
X-Gm-Gg: AY/fxX6O0N53YunGZf5vbmTBvAJglbT+ABj42tArp01vvXUiCaFEKIbKn+5RFsfCkQu
	TToWrHhbFDYEgUTipFamds3mJw9fuL1VxYQL8924GD7wkBxHyF2q/sYSoDfFqMy6UHSvxCqsDBS
	y2KfAIPiN04wQ2n/KWBuVCHNn6svmqF7z83WFlnsyTqBfcQDzbqu9BQbqWZrDigjsmYMxlylw81
	DzfUklNBAFFwJFN507wGldsug/dWwmu3utBT8BMKrDi7oqgV03d4jUdmDr+QH2SzC1PxNn0lSCP
	tzYNWlPrft1djcTHDdCnSKFI5zeTMA6DTAJqWxnOmbkcqIKrucUOZMb/bLwXdM4VDj0egQ8OIur
	AEnWZ6KxDN7wISeqCrXT+hbjKmKazKb4hRg==
X-Received: by 2002:a05:6000:2403:b0:431:35a:4a7d with SMTP id ffacd0b85a97d-4324e708fe3mr58459623f8f.58.1767601382037;
        Mon, 05 Jan 2026 00:23:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+toNYrDF1foh7qEGgsaPaQu5EoHgXBV6IY+Dg2iZDwh/L3E0Nw+HN1rJa40DHNfa5Ktydrg==
X-Received: by 2002:a05:6000:2403:b0:431:35a:4a7d with SMTP id ffacd0b85a97d-4324e708fe3mr58459566f8f.58.1767601381336;
        Mon, 05 Jan 2026 00:23:01 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa08efsm99942627f8f.29.2026.01.05.00.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:00 -0800 (PST)
Date: Mon, 5 Jan 2026 03:22:57 -0500
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
Subject: [PATCH v2 02/15] docs: dma-api: document
 __dma_from_device_group_begin()/end()
Message-ID: <01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
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

Document the __dma_from_device_group_begin()/end() annotations.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-api-howto.rst | 52 ++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/core-api/dma-api-howto.rst b/Documentation/core-api/dma-api-howto.rst
index 96fce2a9aa90..e97743ab0f26 100644
--- a/Documentation/core-api/dma-api-howto.rst
+++ b/Documentation/core-api/dma-api-howto.rst
@@ -146,6 +146,58 @@ What about block I/O and networking buffers?  The block I/O and
 networking subsystems make sure that the buffers they use are valid
 for you to DMA from/to.
 
+__dma_from_device_group_begin/end annotations
+=============================================
+
+As explained previously, when a structure contains a DMA_FROM_DEVICE /
+DMA_BIDIRECTIONAL buffer (device writes to memory) alongside fields that the
+CPU writes to, cache line sharing between the DMA buffer and CPU-written fields
+can cause data corruption on CPUs with DMA-incoherent caches.
+
+The ``__dma_from_device_group_begin(GROUP)/__dma_from_device_group_end(GROUP)``
+macros ensure proper alignment to prevent this::
+
+	struct my_device {
+		spinlock_t lock1;
+		__dma_from_device_group_begin();
+		char dma_buffer1[16];
+		char dma_buffer2[16];
+		__dma_from_device_group_end();
+		spinlock_t lock2;
+	};
+
+To isolate a DMA buffer from adjacent fields, use
+``__dma_from_device_group_begin(GROUP)`` before the first DMA buffer
+field and ``__dma_from_device_group_end(GROUP)`` after the last DMA
+buffer field (with the same GROUP name). This protects both the head
+and tail of the buffer from cache line sharing.
+
+The GROUP parameter is an optional identifier that names the DMA buffer group
+(in case you have several in the same structure)::
+
+	struct my_device {
+		spinlock_t lock1;
+		__dma_from_device_group_begin(buffer1);
+		char dma_buffer1[16];
+		__dma_from_device_group_end(buffer1);
+		spinlock_t lock2;
+		__dma_from_device_group_begin(buffer2);
+		char dma_buffer2[16];
+		__dma_from_device_group_end(buffer2);
+	};
+
+On cache-coherent platforms these macros expand to zero-length array markers.
+On non-coherent platforms, they also ensure the minimal DMA alignment, which
+can be as large as 128 bytes.
+
+.. note::
+
+        It is allowed (though somewhat fragile) to include extra fields, not
+        intended for DMA from the device, within the group (in order to pack the
+        structure tightly) - but only as long as the CPU does not write these
+        fields while any fields in the group are mapped for DMA_FROM_DEVICE or
+        DMA_BIDIRECTIONAL.
+
 DMA addressing capabilities
 ===========================
 
-- 
MST

