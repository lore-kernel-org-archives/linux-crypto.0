Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA9E1F471F
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606725; cv=none; b=tr1eqTbE/iKx0iZvCe9dE96CIM3VZJrnUkqXKJfdsCeqjdW2/N5PTU9iuhs35NpxeN6XSONUQo55b6BcavMZ7mVaqLCiwceeFUqLO1jt+PWlfCa4OvXMNCVLeVleWl/Q0UDFjLOe0DSe4VMFLTtVuT/1tf2FmbB/KYcw0f2bZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606725; c=relaxed/simple;
	bh=5ejwvdViHGpZahmzeANBNrpoCx269JspGOeia0IssR8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fqe3G4rlfwOWccAJn/nSEP1A7opR67hTbV9q9nLiIbV1neMFVQAjh8cXN7mEsQiXSLaQap+h0kQKdLKsSzw8YLqBSo5CJmj/IvARtSK1czUcq66rf1FzvmFFy+AUUV+4mUFjtDX5OqtRohaSs5wMwdVGx1Z10uGNmcb5qoPwwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U6x72nMH; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U6x72nMH"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-431037f7c0bso787614f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 01:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606721; x=1768211521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txMxKLJCIQFzStXgaX6zCY9uCsyn60vWSct+HXcfqZM=;
        b=U6x72nMHxpmbQRXs1gnsE0GzwU9BM8OMC8fDOUEuszh/7vfjE3AvoxufBx+ZjziY55
         j9XpiczMVZ2WuGt6gdThIsTQXQ4wJFmMRUuoK1Cd3WyYjsJK/oC6+Z3J4LosaJDZw9L0
         WK7R9vTUx8GashsEauSiZc27QN3PZPeKtbTjQTejebn2GdPST/MM2eS8CEtjk/VZ0BJe
         lAC5Q5bGVIZQ8YyAXXcu/d9ChWPDfUSWxCRTGDfGpmkRA9eYFooxD/yM76hPB3pEAzjQ
         JbSrEg6nhtP08npXldyRH8jEiJwwljOBkglCGAZ+2ihUdiCfnkYpre6UjJl+XUsvU/us
         a0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606721; x=1768211521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=txMxKLJCIQFzStXgaX6zCY9uCsyn60vWSct+HXcfqZM=;
        b=OLciFVIVhfIZya/l90cpZrjtL3Qy8vdJlaLudnXMVyA9LLEZCa2W9Cz2r1JUgp2LzB
         tOSO0T5ZlJMibuYskT/Em8Ye8EBYD4L4cEKkFeqBu+EsRk2PZL+UsABS/7pF35vmLmkh
         ntdbllDDBN02QqJugLTmKa0NyXWk8ez4C8/bS2JVFpDedRddoaydrpqTKmVgPKus+4c9
         0oHzXDIkn4ixrgw3H0JeiGtvur7R32U9qECPPCTpnALmeKXKsmo7HnIPaoRZ24VrhzGJ
         +gM33i9J2gf+t0LhWs2wQ2AfaL0bf2VuWPm1UrF5qCQ9B0qYtRxKRIycYVwm1zOjzVxB
         F3ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE+TGKWI6IR1gM5ebPTWKuSE/5q0Vw9LR3YXRhMTMtT/79BFTzlYxpp9qIocOCgeeKWyRfcpV4Tvm952U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw+CQr3SM1w0y58y8q4LddOTIqkz77/EA22X2U3Zr9vWTNwXfn
	WQjZCK9+8V5Izviras9EcZzAtt0SFNlR0KVQbPqRjX1YKiIu1vOhmgzxRcSA0LgAAyw=
X-Gm-Gg: AY/fxX7wgJjXENPmZeWGfES1j7aluzsU5+p2/cUznOdzc59otMV4cLS0/c9IVJXreTa
	vUkzpx9Zt63Ys2vojD4WhxeFt0OYwZq2JabjynC6uuKSVYMbQEKkdDKJuZDbDMgR5A8x/wd5egJ
	QysO378Rtax0+IFpGLzKesT1IjQ+l58SSgjAK2cX6dcK1i/8GpgBmtM820vgZJyKqf7ICmIH02/
	kmJukupBMvyeQb2H3lpLMKLqYRYbtYIKjIXXMrPr8CGuVpf5bz37LnrOtliK2Pobn3ybAaVdU+d
	0T2uwY5a5WDjjz34MFpHAdUtRw/peees3afvh+bT6NnvXSVJpSLDcf3Ei7dF5CxP+ECDbUX0MW5
	r3c8eIiPNEOn3VgcU2MWkQy9qCbgtf9uYmwkbUtdyY/XzYEU+qG45NPAQHckexPPHHobCPJCV0D
	AzIZ76wtCPiKEIW/a6ZKsyW1k5cdlButX2GqMLfmQpTenWbEPihjMWHOqXgantGiICyvvEK7iSF
	9MJ
X-Google-Smtp-Source: AGHT+IG/wqgOkqwXrB1rsCOv37yZ5+KfBZKuhJz5pDuTeJ4oXS1iaQsQoWFexgrkxGoC7pycuuDd5g==
X-Received: by 2002:a05:6000:2305:b0:429:cf2b:cb0a with SMTP id ffacd0b85a97d-4324e4bf220mr35541794f8f.2.1767606721058;
        Mon, 05 Jan 2026 01:52:01 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4327778e27bsm66263511f8f.12.2026.01.05.01.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:52:00 -0800 (PST)
Date: Mon, 5 Jan 2026 10:51:58 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski
 <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 04/15] docs: dma-api: document
 DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <20260105105158.248b4dd2@mordecai>
In-Reply-To: <0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:23:05 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
> previous patch.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  Documentation/core-api/dma-attributes.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> index 0bdc2be65e57..1d7bfad73b1c 100644
> --- a/Documentation/core-api/dma-attributes.rst
> +++ b/Documentation/core-api/dma-attributes.rst
> @@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
>  For architectures that require cache flushing for DMA coherence
>  DMA_ATTR_MMIO will not perform any cache flushing. The address
>  provided must never be mapped cacheable into the CPU.
> +
> +DMA_ATTR_CPU_CACHE_CLEAN
> +------------------------
> +
> +This attribute indicates the CPU will not dirty any cacheline overlapping this
> +DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
> +multiple small buffers to safely share a cacheline without risk of data
> +corruption, suppressing DMA debug warnings about overlapping mappings.
> +All mappings sharing a cacheline should have this attribute.

