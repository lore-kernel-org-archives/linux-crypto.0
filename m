Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB82324B23
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601403; cv=none; b=Kj5oEfspyG67BR1J1p4ejxeSNOsXzdjSSLrmUUzTn2387+9z++lwJtlkmKoqlxxFeVEcPU8dEfqZ2xG9ebDJm5+TZhgDUC7RkF0yKPd3IC+NzMOlK9ki3YGeMuElbvax2ta47N9mNNn/Ao4GVv0x3mrbpPxasuiUbl23IGUxghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601403; c=relaxed/simple;
	bh=3EF4beueqssYSrJr7jAiyWtRxi/ynmIi31SbgxtAbxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Un8Mz4z2TGP27Dj+jMRr+4Ir7MX2EcXdpAVQR86+QQWf5AAqLBpmVZtJwsUN2GfJGMXH2LOJUtcn0V6rKJ7r7g83huqmr3/rQiDNvsIdHXRtDsmsDsK5xW4UdQ4nNaI6CpITnTNtxg9bOZ6cUvkY/ZCQLvQIxiWA1oA9rbmwOSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hG44LKg0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FzAXECaK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hG44LKg0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FzAXECaK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
	b=hG44LKg0UqFQ5Rw9u1tVV1RIAG6Sgam1FLyjupbV8RQEbf4WmOnVeq59Cq+Cslrv4SPmel
	ETMywnQ1G46GlZWBp1ZKLFJ9tIeTmcEzlAVpKOvwOkU7U7AH+ltxsoH4k2AAFkspEiMfTn
	sUZ3dIKVTD5oxjCngayq1S081kEI3rQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-w8iyxzHlMD23Rkjfg1xUzA-1; Mon, 05 Jan 2026 03:23:14 -0500
X-MC-Unique: w8iyxzHlMD23Rkjfg1xUzA-1
X-Mimecast-MFC-AGG-ID: w8iyxzHlMD23Rkjfg1xUzA_1767601391
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42fb1c2c403so8750711f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601391; x=1768206191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=FzAXECaK9cpyvzSFZy2EhuHAzlJYHYh1Ucgh0W27TOzjOUZxhoOG8f84Akx1O9zwx4
         CC0i5zi+JAF8JUzNa7jRnGOZgifzp6xP185MLdaxTMhpb3BVub6wsldVxzkRMP7sKCTF
         Wh/9qnZIFH/gtILXIgimM1Q5mF9HE/JX85wGVPpWlctAAhY18PWOK37gvJbETMTa+Spt
         42RiCPItEDLPj+tnu4dl2DVDx41dLyN2aEcuuR2R8kpPrI9Bdk9r7F9OUYvygjmLA4ap
         M0wbuEybZHozcmrIpXIOxIo5REsr3F6Y+qMZG2Jrxljck8M9b1jbMaSbfzVjBHILnQ7A
         q+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601391; x=1768206191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=o5896HIkIUBppr7jz/rJH7jUSwSTY9wLONOHlFGBLD4uri43BAI+A+UXpPgw89F/ae
         wQ7WdqckTHzBEUz/WPXmqiB8OyFSoeDAGVwZa3bAUtxusyfaWGdD57AbBYqdPbvt3ZUe
         A3Zen9CO7i4S4wfjsY2DK4n47oeBi0XrWsRpY55eybbAuQWI/hlT96s5IELHnJd0YCD7
         5nOEXg0WfdyKEtH+WwY9rY4+/wCNi4cN0XJcm1oYonAZPUMvqxv4cVND0N4AoIzr+r8J
         HKs8apDb9m1yOy0ql10Kt4bPQ5TqTJP5RFoNZbfxupJzPkAyFl5puCVcSNIOcePe0QOx
         eFnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1aUiF0I54iRNDLoHBkMOjZt1Ro/PqpGCge/qSZ7w66flOebVb95Np1jegrrsjwlGVB+iUgD0D/UPZJb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV/9yHyNoIpJYCJV0hU36EqsVJXkgTuDlvJdzhduK3P1C00tt5
	qcH7MTpKGWlr5AhCLIhltPBdBzRxFcBKHJFdWpqNOKF83EujN3h2/b0Dc2/CLybB8mwU9AQfun9
	Zkr20BhBtQF+OsafNSq1UqxNSWgNQLS4RGlOhyodwX66d3uj/Ms2y/HVUjdAfRmuErw==
X-Gm-Gg: AY/fxX4/fSEBfi3mtaonUC4MCz3grF9zT6O5WeC4/xHdj67VbSEVBhC4TZ21woV3tDl
	yCKBxmI7NvDEuj6GfLS0cHt9pnLnzdK9MUIOynss6USU59nBIC+dfDWMJJk1s15djoq2zsoMp7R
	mSuXxlIFBxbZG0Q4dBS2G6/kOVViZoB5f6dawHfNaPk3/4Agg/bK2E0ZG4PnZYASm4Qj1LQTXYH
	Ksy/cngpMGZ7uSdXCViOmRpSu0tEKTtSVcjzYd1gQysxVnAcO5wsCzwlhsSUawt7RONLW61llxB
	oaAejkwGY9GUkuqphW3h/ARkALMzABwN2J+IrzhUpJvD4sWDXJJBwdql+FvzzAnI2TRW+J1Tvzc
	6l+vYjZcvB8Nl+M6KhI+M2VBx1PFFGfgSCg==
X-Received: by 2002:a05:6000:2c03:b0:42f:bbc6:edc1 with SMTP id ffacd0b85a97d-4324e4c1230mr54966702f8f.1.1767601390664;
        Mon, 05 Jan 2026 00:23:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwk1Ttr1N2m9x2GBHG1pWtih6zeyM7Sr9HAGjGkjK9L3/ihsrFeD/P27Wy0cj6YonFT6KolQ==
X-Received: by 2002:a05:6000:2c03:b0:42f:bbc6:edc1 with SMTP id ffacd0b85a97d-4324e4c1230mr54966659f8f.1.1767601390077;
        Mon, 05 Jan 2026 00:23:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa64cesm99604028f8f.35.2026.01.05.00.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:09 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:05 -0500
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
Subject: [PATCH v2 04/15] docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
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

Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
previous patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-attributes.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 0bdc2be65e57..1d7bfad73b1c 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
 For architectures that require cache flushing for DMA coherence
 DMA_ATTR_MMIO will not perform any cache flushing. The address
 provided must never be mapped cacheable into the CPU.
+
+DMA_ATTR_CPU_CACHE_CLEAN
+------------------------
+
+This attribute indicates the CPU will not dirty any cacheline overlapping this
+DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
+multiple small buffers to safely share a cacheline without risk of data
+corruption, suppressing DMA debug warnings about overlapping mappings.
+All mappings sharing a cacheline should have this attribute.
-- 
MST

