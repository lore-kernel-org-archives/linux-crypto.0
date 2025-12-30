Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6E12DFF1D
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 10:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089767; cv=none; b=XWGl8CNFzlhvIhDCRZnp+0txqVAvvtyqFde+TyAAxFebIqEaVXDH4ykuZA+YgnZ88Ca6pEyolgQ1OWxAnzPuCEvOeE03lCYt4AkCiXowQu7Hl3nHfKeoetIqQQM4l5tiK7Qk7KbfB6OE2CB4MT8Y5ZupdIUZG+NuZxuUoIZBk+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089767; c=relaxed/simple;
	bh=3EF4beueqssYSrJr7jAiyWtRxi/ynmIi31SbgxtAbxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTSovoY5g3kcmZ89zl8wkyHrUREygdKiBKqLK21rFPzflw0PS2KPqM/KvqjrFTmZiBwji9di349Ra6HE2ls094lyc5Xyciy8tcp3V78NJnwgKCuSA0BF3d0dhWcG3FmbBUv1dHg2ziPwhkTfHufsTteSvz/3a1A1vXA+ARD+14Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3l+yGxi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7FQ8isQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3l+yGxi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7FQ8isQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
	b=f3l+yGxi+96trfuT0Q9P98vl1dnYa+2T6xzDNpKpdOzPCus6zu93ULTJJ3Liiq6kkMPG7J
	Nkk5yhuJcMbxXs/AfFmO1uVAGLVpE8DEz/oTEkmYJeRT4ErA/RX23HMUTUnbBUWjCj2txh
	N/U9EqTw8i7jrVg8vYHTdpff9GBp0E0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-6-z70EmiMgKhbRuB0OWhtg-1; Tue, 30 Dec 2025 05:16:01 -0500
X-MC-Unique: 6-z70EmiMgKhbRuB0OWhtg-1
X-Mimecast-MFC-AGG-ID: 6-z70EmiMgKhbRuB0OWhtg_1767089761
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fdaba167so5224331f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 02:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089760; x=1767694560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=Z7FQ8isQq14I1KaSH1zw/UXjxfl4vbX2ZEFt82yb0xF9HrF5cGDa24nsifnCDpFx+d
         ZJVEGcAaQcquK7ruSxLov+mmtNZm6Z1cY1l5h155mMjVQFrApi3LDOd28jAvqGiPFSet
         LdpFwLkIn/ZjyF4pQkW4zmY53q3amnxzSS9IUxJai+v6NViiTMCFUhYnCxRcxm5uZESt
         Aw1V9bQXYW7Fl52Vl/JGM8eclURT8majQKzcf5P/SfKE9+ou1xx5sGSTMLsUXNKdhfjL
         R5z2Dr7EADU/6enDMzGahCI5t7S/9eDh/HfytF8+YyTZ1fvM3mPQmNW/lQt+yUskX7rr
         0rRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089760; x=1767694560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=i3LsnLOi3PaakghYJ1APRhuGz4KAVZHK2+5Sa5mzntrcJk50bcw3cc1UqJZ/FpqEM0
         TpPOlY1iizXl8k6RTDljyjyo9ihfpoCyRmRCAYFWfE4J2uluMdj498optCXVtysTNLPl
         HY1PoI9wK7YLPhyqpYp4F4ec420lDxZrUbldG9jRax8l6e6OatU3qOhJfBVg90wogzrZ
         HvyS9/b9BwLw88AMC+Q3WJ2eBx7I1tApZ0BIHw4VxCjOfQksFZdqsGqYNmjpfIqpv0a9
         r6ETLgXTafDbEk+JHJizBM1NcUsWQ+sQ/rslcr5okprf1N5C6YgMD8dhZBzJQAjfx9P0
         Ik4w==
X-Forwarded-Encrypted: i=1; AJvYcCXiFhcojhhhVQAxLJk2I0cjRFyDcxlRZNp5ARE4H3z3MvgDxwBw9A0l3VbW9A1rKLxpKiJEQV2hXfYjAKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwsdiOAcpGgQrvUdwn6DzMC2FT5YioGDuaiiFb1lDeZG2NhTj1
	3UPoUY0sfuhdzS/T02JwmuNE39r+50KSaXsn+uNg9ZkrI0WzFLkzudfnmbc0dzi8UqIrt6fq6UB
	j2uyHSc4Inl02YBT1ObD0Bgv2H9p0IFqd7g2FLJ8H5QLMihW2ELNpnSNWgiUpYrj0Bg==
X-Gm-Gg: AY/fxX74NUmMhQEkx880RALRqFDSC5S7NUE9N13m1cedoyIyRTwQzdLcPdDKIekbOR0
	Gr+LLSRLo8vEEPMJxjOr245ACXLM9zrVNNaMTZXDifrZLA+4tgnKsHKYxz6zwoWv5eD5eZio5EW
	yf0U3eAWB6L3rXSEGS6+l7VMd8j1QpRlq9ZezYkeZFKXFO1NxUcDKa+6XohW9G+U/wOijP3iYRi
	g+qis4cDNfQvloJQ2lgEBGg48BczKF+0nvIKzgB6RBq+AEADOsE3CIMFZmVQbuC5YQaifZKoAXa
	5SMhtQfjfaodv15+w/7wUqPvWd5XcnAPKy4KHSznfbd9TGF3lgScm9+7ZxMBUclH2FBsGhkXXs2
	gGNWrg41UeZKVCZjxHJBoyN7aqVAequPwwQ==
X-Received: by 2002:a05:6000:2906:b0:430:fd84:3171 with SMTP id ffacd0b85a97d-4324e4c9e98mr39750106f8f.22.1767089760409;
        Tue, 30 Dec 2025 02:16:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHondA4WovcXdLOT45Lj3uVr7rduhIOKgQxT45AJwE7sF5CS5LqWM7ii/WKiPGqmcKK8QLbHQ==
X-Received: by 2002:a05:6000:2906:b0:430:fd84:3171 with SMTP id ffacd0b85a97d-4324e4c9e98mr39750079f8f.22.1767089759925;
        Tue, 30 Dec 2025 02:15:59 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea830fesm68448837f8f.20.2025.12.30.02.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:59 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:56 -0500
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
Subject: [PATCH RFC 04/13] docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <818c7ea78e43b93d1bb3995738a217e5e414e208.1767089672.git.mst@redhat.com>
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

