Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4176D31064A
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601384; cv=none; b=ljngQ/UAXgSSegM97CGKB0bymeED9rsoJI5RVD4VnOwTO7j09uzUOD4EXDeafVOob12+DLgGzi7QwE5RzP5t6OquSY8yVKZ5zgIB311mWCoF2RUaITcXxf7yk8GquuOJmH23qOQ5fozRksdYHfYrI3sEtqXen18obK/C0mPabEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601384; c=relaxed/simple;
	bh=OKICx5FGcs8IaWdKqJAnv5nr30MUEvkMmLH/rtLJg90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNPqUaddB8aT8FtTdCxXzCzc6zkuO9csI+W6g8PQSY0+46oELH2U1WM9e4GTRFmKUrGmcUHx1lsfqjoQ2Q6jYIC8/NHfYp163eN/w1rf5391pNiUnnYUtRnRZC/vKK+MfltA48YFAJQk8aYuCh6rmOwGRON2WXxDnmdECKfGI+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WqVz3irm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPkFrgpu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WqVz3irm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPkFrgpu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=flvV58rpfI6B2CbimOq4yKlcklsexX+NampJykNGX78=;
	b=WqVz3irmgl/1ZpP+3Mg4itom3mhS8h0Rbrdtt95M6DwQFX+h30kcTMJGJZHFGGTXx46C9n
	k7QD5ZNc1cE4PvrTUNGjMkSJ8cUXCc4UItybwSIPOawmPH1Lus9RXtQaNSe6Q6nmbZntyM
	9kSdOgbhWt0yWZ60HwGundSiE5kWm3A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-ZC1lBc-UNtGe0KMjDISzQw-1; Mon, 05 Jan 2026 03:22:59 -0500
X-MC-Unique: ZC1lBc-UNtGe0KMjDISzQw-1
X-Mimecast-MFC-AGG-ID: ZC1lBc-UNtGe0KMjDISzQw_1767601378
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso58306015e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601378; x=1768206178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=flvV58rpfI6B2CbimOq4yKlcklsexX+NampJykNGX78=;
        b=QPkFrgpuiBMMFofOQ4jAdxxN6c2Vp4oV1Gg7feN7Brwk3IoZE8tlZBtMewNHdCTmcX
         J89iiXHO8XulT7mvkAYigvNB21HwVkC4UaJh+6qLFH044MYI/AJhC1rir05k3E4D5zAC
         l2oMwTUjnPVcCbl4v5p9sk+ENJbiTovejKy4d238LehbX5oug0hjfbk+5CP0WUf7R0W5
         oAt5vX0zoXLVkMJ/lerxu000WlCDJKWa5kUX14ARIXqnfSsN5oTfZjrjrbgv3FTzfJ+d
         ohL+mLUyGVtzNS0/P3hyS1HSdrurjG/swvLj6tE2/lIvMl2g9uBukt4A5C+bA3B/QfIq
         nkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601378; x=1768206178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=flvV58rpfI6B2CbimOq4yKlcklsexX+NampJykNGX78=;
        b=Oi2iK21xaPzpd+WS7gR0b8P5aWkGO/Drg3/Ve9gGOGMOn09yvVbLQNvRkWtGzgr3lS
         GecG1TXOkmTIQUPp8QYrSScOw3q/C3+9sW4HYWIF8Hv8/Ksxk/pDHFo+vc0qyAEY9iif
         5MSNBfVFnnAtBr56KGPemRVE4qrlcBf2DnAUpM+2mYsnaNqno9x3FO9AhGls/EK2HGZG
         +N0gcDKLby/j4yKPXIt4L71gI6eFNR3dIT7zfbBOIsGL9pDo4KhNoOEEMHEeMd/E8h8W
         u41xKC44TUNyYlP9QaqiHu3JYxaV9vVnvgCO5f2cF0DQKMqE0oWFRW5RW9Ady2ZeqhRg
         HTrA==
X-Forwarded-Encrypted: i=1; AJvYcCXzXcZQqRGgdsP/JBBu9LjmsbV+FDtvjfFLt0a/fPQqutJJkzEK63RFUuTgIdGFpanQWTsFQiHUBzafSBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA6oTCCmzAkt0KYgnWJyoAGaIqIDY16aHemxptDjVwCjpWvogR
	8Ln3ejtSVM98jn+uW+skoNlEA1Yvrvm7BRqgDenK/A6IPlMQbdAw/EQJOdVqyJd4vLBguHaiv3n
	QHAAIorwthaX/ufhEdPLTicNB9k1H+3ceXF+5bt2IX1NLF+/+K+9lbW6CmBjuBPR0KA==
X-Gm-Gg: AY/fxX42GN6B/8pXPNCVVL063+mp1mLe88u3AN45YD5aJSAoUSwtru/raNGpeBLgah0
	IwOAbjQ2//ifKkDWuvnCqDMDol4OH/iXf5ncPfDa4mgGnXHUyQPRUCxaaAgIYRka+BnStOW9837
	AfzqGEz7rmlNUiGxxq6nQn0slzMkDRFiyOQfh0/ziaFUDEzIi7c+7HXf7asZLfd5MeKAPJWqe8F
	6nZ2I+EuS2aSOOeW6OTVOBPwShKaeC/V/FMGw+fUM6CjZZdLHKIGcW9LuoS45Hio9yM0tpGLsds
	ngcb1ZoKCVxYR7HNke8plLQv5nktS3B9ghronNMYy8a+ZlAsHnJ9Zlf/I2VKasz6IYhk3XYu40D
	FwQ6yUentBAZ7RKxLEM5IspyQQvzAyeHd3A==
X-Received: by 2002:a05:600c:a31a:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47d1afcd9e2mr472221665e9.32.1767601378030;
        Mon, 05 Jan 2026 00:22:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuXSIOihQGqTUh73UD1lwUxn/oQlvSzbaEszKjq8q7pmaQg9MTKbAK1XIofFksKZVCqoImYw==
X-Received: by 2002:a05:600c:a31a:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47d1afcd9e2mr472221315e9.32.1767601377489;
        Mon, 05 Jan 2026 00:22:57 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d13ed0asm147684535e9.3.2026.01.05.00.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:22:57 -0800 (PST)
Date: Mon, 5 Jan 2026 03:22:54 -0500
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
Subject: [PATCH v2 01/15] dma-mapping: add
 __dma_from_device_group_begin()/end()
Message-ID: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
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

When a structure contains a buffer that DMA writes to alongside fields
that the CPU writes to, cache line sharing between the DMA buffer and
CPU-written fields can cause data corruption on non-cache-coherent
platforms.

Add __dma_from_device_group_begin()/end() annotations to ensure proper
alignment to prevent this:

struct my_device {
	spinlock_t lock1;
	__dma_from_device_group_begin();
	char dma_buffer1[16];
	char dma_buffer2[16];
	__dma_from_device_group_end();
	spinlock_t lock2;
};

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/dma-mapping.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index aa36a0d1d9df..29ad2ce700f0 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -7,6 +7,7 @@
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
+#include <linux/cache.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -703,6 +704,18 @@ static inline int dma_get_cache_alignment(void)
 }
 #endif
 
+#ifdef ARCH_HAS_DMA_MINALIGN
+#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
+#else
+#define ____dma_from_device_aligned
+#endif
+/* Mark start of DMA buffer */
+#define __dma_from_device_group_begin(GROUP)			\
+	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
+/* Mark end of DMA buffer */
+#define __dma_from_device_group_end(GROUP)			\
+	__cacheline_group_end(GROUP) ____dma_from_device_aligned
+
 static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
-- 
MST

