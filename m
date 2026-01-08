Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFD040F8E8
	for <linux-crypto@vger.kernel.org>; Thu,  8 Jan 2026 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881908; cv=none; b=FrAiMQI/dLWFcLYVWDgf2md+ZKbA6rGRDGmmdslpzSf/bSHMtxkmXp8qoQUFGfIx85tQikLmgonyXUIYPIaS30QQegswtHdI6joPhO/pcAt7ClFPtHrpXUeiL/oOcSOy+Ny87JOM49n5P8UPtpldKKlF98k0dhETtt91BwAB8dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881908; c=relaxed/simple;
	bh=SJZE4KTbW/+usatKP1Sr4PPUbIQlx0UuUvCG+8I8T1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ls3nxnUJyESdrGT7T92/SXVdC+r+oYBFZoV/kawkMKotVkU0BAx01n8z+f8BSzxgSHOI/7vGjG6hxBXzNLnWZIHHwV12QdC3sVhRNBN5pIyAyySl/WHgKUAC8rH8+QMcgexX3FWXJ1QVjWKwLz/B2UCcHEA/8R0tSpoXmtmfOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R3wFfw2A; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JC7gymIB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3wFfw2A";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JC7gymIB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rqZiGHlphsIXyTZBYYB1RUSRDC4SlQ7PgnKFPfthJ9A=;
	b=R3wFfw2ApP7SxgdllfSlk6Xr+mhi7oYYZcbmMIjmw1iabWKHleyN1zTXPTfqz5F+1B71u+
	trFMeqMvQD5sOnW6N8WIqkuB9xsjXW5myFh4/Z8gnQU4aFc6LmZ3gGj1//PVyqIQdO874e
	NdQSWOClviM6Qrt68NZf050vLdies4o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-hMA5W8MHNt-KBMKIDeN7DQ-1; Thu, 08 Jan 2026 09:18:25 -0500
X-MC-Unique: hMA5W8MHNt-KBMKIDeN7DQ-1
X-Mimecast-MFC-AGG-ID: hMA5W8MHNt-KBMKIDeN7DQ_1767881904
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b7387d9bbb2so218789066b.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Jan 2026 06:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881904; x=1768486704; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqZiGHlphsIXyTZBYYB1RUSRDC4SlQ7PgnKFPfthJ9A=;
        b=JC7gymIBcxw/OfysV7sn+9xCEjaiOlZZ2Karv2EGjt7Br17mK6QduTkk8Pfc6XC3xq
         h0MDzXa08eyZOWQQzhqyBoM47HzUGT+8E8El24O5Th9PM437FB9OEtaD2AnQmm+Oobcy
         dMXFPNxAOxEVsZze9JRT8tH1k7IlNqdWBUo5y8ukWQ/xsziWlP9NJnHNL87T4Y6/IfD2
         6DaGSuE0H1yqdQZrwftzB/Ok/AvI0z0CkFCWhPt4Jbl2w6wSXTZWYht48b/sVh1r7SSB
         RlerkxeIm8yfGt6Yn5oqI6mUob7y3Xs83nKbUKJ6FYmysoIM/Sm/Xve1j32jD2WUUWng
         OwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881904; x=1768486704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqZiGHlphsIXyTZBYYB1RUSRDC4SlQ7PgnKFPfthJ9A=;
        b=ZsmwCFV7fj0mSf/FFO+zxEyjMKztPqrywG4pDDa3A4LO03b1QGeXEgj8aUXMi24KjJ
         7C9ijsbRySKgWxzMgWMOh7+vroZpcongBuZ594YaxoqjHFZPbjsuHb1ZYIWiA85CoRu/
         JASvqUMYgGsQaUIgM9iO99Ix5uZv4K6Y9u8fk+cAh5v+OQcmdbNMc+/KxKt+kH+U6fcl
         dhG2gcZ8UtjCj1ApxhYw/mZMUvUGkQv3Yak90HOvbD994mfEFsQUC05ZPxrz7qz8G2Fa
         g0X9NeNGKmKyEaEHZdePGzM6hIumR+5VpZPqmJasdA614iUqSOtN7HiHxgWER/uQg3A5
         SV6g==
X-Forwarded-Encrypted: i=1; AJvYcCWd5Rp09j8e8E2QitQDOlZ8EuEHVaF+1xMblCjPhVen43RrsdbQWeZxxaCo0lR1HGB57xWYqxFxB048WcM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrjsp+ciHi4tpo8rZpCDrdo2xNoAsNahysjESXqzC1TRMBaCwP
	J4808J7UH2g/ATzGlcwVCOzE8Z+1m+vifTze39+szkbJpVXPH4FIQqzZPExDtB8/CMlt8VirC+F
	8Y3EJjj2d5LaQVIeFXHe4h5QF/3fzaMMJVYBEQAUkDXMjxqEABUZf6qU3ERZ+twjsrQ==
X-Gm-Gg: AY/fxX4F0SyXbc+aR1/trvKDpE1vCCIw3ydt4Cj4lZE/1ZyKomUnBxlTBBh4lZXReMT
	hm/03LkI8v/WZrr/NdykCwMwYE69xwYWx6WfzoePt7emDQc0Ct30va7+zY7UEtQUlByn7fANkmd
	U1MNOmTBuWnl7Z3GUSLgqpvtEwQt8bOc+rNbjiq75fef5OkC4j4I5L59+to6YAXdnOrruzqM+xX
	FxXWEXd7va3tJmETf+e1VZAoG1RSqTk3Spx6lBPqgnq23inMGYBumG6CajMngj2zMeKgb6VS6Mp
	3dFBWrj0+m91hrctIEEW8e03lwcpSYfv0PxeZBDxL2sQtzsK5fl4+Ic1dKJWjHW1QVoDGoY+plv
	9Q6jKokBCopKrTC4h
X-Received: by 2002:a17:907:2d07:b0:b84:1fc7:944b with SMTP id a640c23a62f3a-b8445066498mr627907666b.58.1767881903672;
        Thu, 08 Jan 2026 06:18:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3Dxa4w6bRkF+MtZ8LKCNuWLpqie07t2Imxvb7EeEx+3jZGwolIwvKYG0CWJg5J8bgXET92Q==
X-Received: by 2002:a17:907:2d07:b0:b84:1fc7:944b with SMTP id a640c23a62f3a-b8445066498mr627904166b.58.1767881902999;
        Thu, 08 Jan 2026 06:18:22 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a22ff58sm817309166b.6.2026.01.08.06.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:18:22 -0800 (PST)
Date: Thu, 8 Jan 2026 15:18:13 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 07/15] vsock/virtio: fix DMA alignment for event_list
Message-ID: <aV-7QoTi5AfMcfQa@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <f19ebd74f70c91cab4b0178df78cf6a6e107a96b.1767601130.git.mst@redhat.com>
 <aV-4mPQYn3MUW10A@sgarzare-redhat>
 <20260108090639-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260108090639-mutt-send-email-mst@kernel.org>

On Thu, Jan 08, 2026 at 09:07:53AM -0500, Michael S. Tsirkin wrote:
>On Thu, Jan 08, 2026 at 03:04:07PM +0100, Stefano Garzarella wrote:
>> On Mon, Jan 05, 2026 at 03:23:17AM -0500, Michael S. Tsirkin wrote:
>> > On non-cache-coherent platforms, when a structure contains a buffer
>> > used for DMA alongside fields that the CPU writes to, cacheline sharing
>> > can cause data corruption.
>> >
>> > The event_list array is used for DMA_FROM_DEVICE operations via
>> > virtqueue_add_inbuf(). The adjacent event_run and guest_cid fields are
>> > written by the CPU while the buffer is available, so mapped for the
>> > device. If these share cachelines with event_list, CPU writes can
>> > corrupt DMA data.
>> >
>> > Add __dma_from_device_group_begin()/end() annotations to ensure event_list
>> > is isolated in its own cachelines.
>> >
>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > ---
>> > net/vmw_vsock/virtio_transport.c | 4 +++-
>> > 1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > index 8c867023a2e5..bb94baadfd8b 100644
>> > --- a/net/vmw_vsock/virtio_transport.c
>> > +++ b/net/vmw_vsock/virtio_transport.c
>> > @@ -17,6 +17,7 @@
>> > #include <linux/virtio_ids.h>
>> > #include <linux/virtio_config.h>
>> > #include <linux/virtio_vsock.h>
>> > +#include <linux/dma-mapping.h>
>> > #include <net/sock.h>
>> > #include <linux/mutex.h>
>> > #include <net/af_vsock.h>
>> > @@ -59,8 +60,9 @@ struct virtio_vsock {
>> > 	 */
>> > 	struct mutex event_lock;
>> > 	bool event_run;
>> > +	__dma_from_device_group_begin();
>> > 	struct virtio_vsock_event event_list[8];
>> > -
>> > +	__dma_from_device_group_end();
>>
>> Can we keep the blank line before `guest_cid` so that the comment before
>> this section makes sense? (regarding the lock required to access these
>> fields)
>>
>> Thanks,
>> Stefano
>
>A follow up patch re-introduces it, so I don't think it matters?

Yes, I saw it later. Of course I don't want you to resend the whole 
series just for this. So if you have to resend the series for other 
reasons, I would avoid removing the line here because I don't see any 
value on removing it and add back later.

In both cases:

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

>
>> > 	u32 guest_cid;
>> > 	bool seqpacket_allow;
>> >
>> > --
>> > MST
>> >
>

