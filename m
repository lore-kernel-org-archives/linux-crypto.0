Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F11D90AD
	for <linux-crypto@vger.kernel.org>; Wed,  6 Nov 2024 09:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885345; cv=none; b=GoVwU+G6ogSHYche5OWKy6kRLUyrEKIU3jlLXeZ7ULlYke2dbA+dcnTLNLQWNp6QKUWcXCzFBdEdbPFwjk5KRKqZKRjumq0prF2SGr+hb4bSO05iwgteDICAyfwySTOHDhWl3Ko4ddbJl6936ITe9i21Fn0TxMzhMUviOr70pJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885345; c=relaxed/simple;
	bh=gD3ymZXOf1Xp+zXbXqMleltiFT4RiaNkSbFjDmEzFhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMtCYrxIerYSdS8wnxb+Uy8YFOrISJjWOQSdZsv0UvAIL57Kn0fWK1kLTg19uNjtvmk+PFbE0n1to1P1V+Z35E+CUwqkAI8XRclodPKSO3ekqm+opLwiSWckLT4ryxub9ezV1qb2yCkqZJmRmLIeUm64jsRn7xZsujgpnUMoXkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iB+tcl+1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iB+tcl+1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730885342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ejx68tuVg9mOD/4Icv7MBobbv6b7kreS3ffjJVREaDU=;
	b=iB+tcl+1AEaOuyaVACays+4G27L/FXGrXL2dIbuCiqxKb1V5xuW0i/yjHNXzMTcdHe1E+b
	PWni14ixHNeddukW9H0Tzo6ukUoP646w2iZ1n9jCmyQMDM6ZDI8Swg/CEnelnZ77vfDwRN
	1hmqSy9qpt2Y32oC5YzzpsWlc64I1u0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-BoYqk9_NNv-XbIF8xz8SEA-1; Wed, 06 Nov 2024 04:29:00 -0500
X-MC-Unique: BoYqk9_NNv-XbIF8xz8SEA-1
X-Mimecast-MFC-AGG-ID: BoYqk9_NNv-XbIF8xz8SEA
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315dd8fe7fso54994055e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2024 01:29:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730885339; x=1731490139;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ejx68tuVg9mOD/4Icv7MBobbv6b7kreS3ffjJVREaDU=;
        b=OjSrcTgtR64V/iAJUsmd8pTaPiRIskiAfKLF3GkLb0ZDRaK/JqtwNrO2KsL69gzlX+
         /JCCLL33GOYD9dXYp24okUIsMvL9Qz2mLlaL9hiwnWMuK06KsOr6cf71cH1rEXQweKZr
         r/6sYQzdIZLX4pYCtwD3e1PvTlkB2YGIrf5IMlwkY4snIWTwmxQ/rITJyoIpbJVnzC8E
         8WXOB3k7xWpKd5dj71Ja7LnPOkOTmCOW08C7w95OY0pGhArY05O0cijHqiHcssocDETa
         C4ntm36SW9jiGP89YJ4Br19X8T19xygI26EhJRUVFmlAq9+rd22QTHmj9a4LQpq/rW6L
         H74w==
X-Forwarded-Encrypted: i=1; AJvYcCXwH6Zii0/Eon0126sLjx5iZhTgorfcPEhJOEKUA9pJTOW/qLaxDICba55LaCcWVBOlpEU49lRZ1KbAmSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YysuuItQayqy9RHevXss7caeZUuThmKRTidv5J+34wbqqW+JEGA
	KR8lR2grUGdbv5qTaVwXpBcyGAH9ATXbBxs3UJUpjSBT/F+Lxj4d0Cs3PUN+IFjmWkC6jHk16m6
	NCtoqfVtiduS8jUDUaoV27mBshxXWAt9uA605TImcDYJElDR99rBuln4/ZRQeWA==
X-Received: by 2002:a05:600c:4689:b0:431:52a3:d9d5 with SMTP id 5b1f17b1804b1-432831cb9demr222901185e9.0.1730885339656;
        Wed, 06 Nov 2024 01:28:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWjjkdr5r4V7Q+Qj0G1hCbvfLQeB4lT/9xr2DmAO0MVtWQKCdBKQf0iOb506nFA0FTNUYXlA==
X-Received: by 2002:a05:600c:4689:b0:431:52a3:d9d5 with SMTP id 5b1f17b1804b1-432831cb9demr222900675e9.0.1730885339211;
        Wed, 06 Nov 2024 01:28:59 -0800 (PST)
Received: from redhat.com ([2a02:14f:178:e74:5fcf:8a69:659d:f2b2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa5b60cfsm15505215e9.7.2024.11.06.01.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 01:28:58 -0800 (PST)
Date: Wed, 6 Nov 2024 04:28:53 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: qiang4.zhang@linux.intel.com, Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jens Axboe <axboe@kernel.dk>, Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Chen, Jian Jun" <jian.jun.chen@intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Qiang Zhang <qiang4.zhang@intel.com>,
	virtualization@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH v2] virtio: only reset device and restore status if
 needed in device resume
Message-ID: <20241106042828-mutt-send-email-mst@kernel.org>
References: <20241031030847.3253873-1-qiang4.zhang@linux.intel.com>
 <20241101015101.98111-1-qiang4.zhang@linux.intel.com>
 <CACGkMEtvrBRd8BaeUiR6bm1xVX4KUGa83s03tPWPHB2U0mYfLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtvrBRd8BaeUiR6bm1xVX4KUGa83s03tPWPHB2U0mYfLA@mail.gmail.com>

On Fri, Nov 01, 2024 at 10:11:11AM +0800, Jason Wang wrote:
> On Fri, Nov 1, 2024 at 9:54 AM <qiang4.zhang@linux.intel.com> wrote:
> >
> > From: Qiang Zhang <qiang4.zhang@intel.com>
> >
> > Virtio core unconditionally reset and restore status for all virtio
> > devices before calling restore method. This breaks some virtio drivers
> > which don't need to do anything in suspend and resume because they
> > just want to keep device state retained.
> 
> The challenge is how can driver know device doesn't need rest.

I actually don't remember why do we do reset on restore. Do you?


> For example, PCI has no_soft_reset which has been done in the commit
> "virtio: Add support for no-reset virtio PCI PM".
> 
> And there's a ongoing long discussion of adding suspend support in the
> virtio spec, then driver know it's safe to suspend/resume without
> reset.
> 
> >
> > Virtio GPIO is a typical example. GPIO states should be kept unchanged
> > after suspend and resume (e.g. output pins keep driving the output) and
> > Virtio GPIO driver does nothing in freeze and restore methods. But the
> > reset operation in virtio_device_restore breaks this.
> 
> Is this mandated by GPIO or virtio spec? If yes, let's quote the revelant part.
> 
> >
> > Since some devices need reset in suspend and resume while some needn't,
> > create a new helper function for the original reset and status restore
> > logic so that virtio drivers can invoke it in their restore method
> > if necessary.
> 
> How are those drivers classified?
> 
> >
> > Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
> 
> Thanks

