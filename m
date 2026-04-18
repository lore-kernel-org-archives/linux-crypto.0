Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACB8175A5
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 00:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776472270; cv=none; b=ExiOZKWyTQfLHUG5QekpOtMgGeKz+0UnIg0S7LxQPYm2+UejAqjsDMorsoaTw3pfiMBdJRyeWCBAGpaOXr3bp6Ty3rEv5teHKsz46vb4EhqACKTFtXeJzrEkK2CMkjkT4pwLgFPjpUqQS+EteGG4jQCNzkmTyl7ZT/NAyDiz0Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776472270; c=relaxed/simple;
	bh=bH3XTTI13kA5J/Ns082dZsYWHK1cNLvuDe4MsdGZb04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKGKPYXFuvCs5LTF1XwbuVwhi0RjC7fc1Std4u6BxOMHr6JzMwc5dAgHHcLwhq8uT2S8OIKbBHO3iISTup2zjcuTAtLuMfN1EgrbwWOY1BRFurdEJCuVska6pEhg4H98QSC0hPc3aDV0JDvMfMb8WlqDWHECcHetfAqNip3Py88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CLCMAFTn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mEUF5rVf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLCMAFTn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mEUF5rVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776472268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gntGGQguH0Am4pdEgFT88PvB7XjJHe+6hBodNgxy/CU=;
	b=CLCMAFTnyOKxTvYOSE4cokl6a4e1+wMzMLUZZe/W3lCLHhUWVgEGYZdDZ6xAuqwH1X2cZ/
	CKrLanS/jFdSrENGMZbDQPxMbQKYn2wwSVrebY0/g3jML3e1irVybt85OqVgq8r0JveUYg
	jnLgsQSZ1mS9cDTj5zDAO047DGKmLtQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-oU-w-szlPuuc6iIx4BHFqQ-1; Fri, 17 Apr 2026 20:31:06 -0400
X-MC-Unique: oU-w-szlPuuc6iIx4BHFqQ-1
X-Mimecast-MFC-AGG-ID: oU-w-szlPuuc6iIx4BHFqQ_1776472265
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488e12db7e0so10194835e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 17:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776472265; x=1777077065; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gntGGQguH0Am4pdEgFT88PvB7XjJHe+6hBodNgxy/CU=;
        b=mEUF5rVfAUkJ6aPOF6ObI71NTLAyI0Hd260j8suzS49UCCIPp7Bnjibz5Zf3FfN9Bn
         +qARWzokIbbb0593m3PjJpylb6UuPCs2rDQ5qXGiNNrBmlc426uaZGOPG5IwrsJjo/8n
         KZ2KNnE/l+FXrvhKeJKBSKiI0phPa0UViZHCOtMbOFk33ja7vVhPDk4cTu/dgX7NofCA
         mMhiXTvka6QY/yZJty6tMvcaAm7qc75UYmpmeH/+S/a/GzQXU2PJYX+bRmVbo5t8kTRk
         RVQx0YOExmMD58Q18gQlh+6qmGutcXmBWZxAey9YHn9sDZwb1n9sxFevE1SdYNH4tLCb
         5njQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776472265; x=1777077065;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gntGGQguH0Am4pdEgFT88PvB7XjJHe+6hBodNgxy/CU=;
        b=KP77QOOfowF47UZQtHfWYFMONnTA19bcJM72x1WGIWP+Vqkkj0cUnOO1i4A3m7UhsU
         yLlmPOGnbeu9m0UmF9/5sPL/zuFbxhg1hqok7ojaHQr+xdc0r6fPPWm9uLMIOmw3Ur8+
         yv2fEWoYdo4d6EpYgb76HhlkEAyU8GwDaqfxxczSECvqQ6AyPAk3h+/Gvwas769Q7eng
         74qgrqt1E2SxW1+4nj49SXde+xPjnNwusWnZ6IZauChzpLNRB8ChaEjXqNO/0sqN2Da5
         VFkHKuQZwo7iI/3J+Cc3hUaxmeuC7INbzkdneDjyykqk4wE2NIfwa7I8fcc6UH9GJIuh
         xt3w==
X-Forwarded-Encrypted: i=1; AFNElJ/3FT8/kpmxnepDTup9Zt4wIV2brj8i5Wwq7EDFrOzK4mmV9UuB6AtYgD1mpg53j2JewdCvBFP3XbRVf9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6sK8XmylYqg6YFRUj6W/PcAcz8dSSadSTHtVvfmJXe9k7YRvF
	ehb3+OQYVtuIzQurwJXjNft/Dvm5Z+6aS+MMnvznG52BgCP79FUeQyxDWF9qRZQOKUh6WUfPdXL
	ZUV2UxeB2urpWX1kWttMFX39dqx9SBFrX5pWTUxIlMA7+885SXtoF5uBkVjMsqLwo3Q==
X-Gm-Gg: AeBDiesRR1zqmnraQreaxZvHJb/blnnLHzb61sthMn81Qurjq6kM6YQbb+RHSFDSjbl
	fsUZ2j4KC8vQmIfkdo9BCeizj/Fn1i0Iv6iAD146UP5UOC55hOHBpZJ3HKvfc8Y5qSUCZZKNVBT
	RI0WInzk/WPD3FEK7+jI9EGtWrYhG8Bjf/Dbu6RVCmltSNCENG/LLWhdrsTRKUG9jGzxmJhJKyB
	54hAzdyoP5VvBA7OylaqAelKoY0Nw/8Fp6KpPrR/wuTH7NpJNA9rTcT+ANVcByhiJWrLJCALWKO
	XQu8pKK16tBs5tyLc4qRINrI6t4ibVFlVIIarEOpiOhvGakLWBOgl5kxrxgKWEjSv31Fp3+fj5Z
	fwu5pyebNSrxF4S4X9UuJUdcCeoKcaapp7ZToOuiooqJgDqNCs+dsnw==
X-Received: by 2002:a05:600c:c085:b0:488:acbc:b2e with SMTP id 5b1f17b1804b1-488fb765b04mr53093785e9.17.1776472265220;
        Fri, 17 Apr 2026 17:31:05 -0700 (PDT)
X-Received: by 2002:a05:600c:c085:b0:488:acbc:b2e with SMTP id 5b1f17b1804b1-488fb765b04mr53093615e9.17.1776472264708;
        Fri, 17 Apr 2026 17:31:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a79esm10108821f8f.17.2026.04.17.17.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 17:31:03 -0700 (PDT)
Date: Fri, 17 Apr 2026 20:31:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev
Subject: Re: [PATCH] hwrng: virtio: reject invalid used.len from the device
Message-ID: <20260417202330-mutt-send-email-mst@kernel.org>
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260417201129-mutt-send-email-mst@kernel.org>
 <CAJJ9bXzhKTBx4m3-SCM+ccGd6ZhTXTAbRxKekCzidnXY6yXbWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJ9bXzhKTBx4m3-SCM+ccGd6ZhTXTAbRxKekCzidnXY6yXbWg@mail.gmail.com>

On Fri, Apr 17, 2026 at 08:18:06PM -0400, Michael Bommarito wrote:
> "Actionable" is probably the better word there, sorry.

Actionable meaning what?

>  If it were
> otherwise, I wouldn't have filed publicly
> 
> If you end up ACKing the correctness change, I can send v2 with better log
> 
> Thanks,
> Michael Bommarito
> 
> On Fri, Apr 17, 2026 at 8:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Apr 17, 2026 at 08:00:20PM -0400, Michael Bommarito wrote:
> > > random_recv_done() stored the device-reported used.len directly into
> > > vi->data_avail without validating it against the posted buffer size
> > > sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32 or 64).  A
> > > malicious or buggy virtio-rng backend could set used.len beyond
> > > vi->data so that the subsequent copy_data() in virtio_read() issues
> > > memcpy() from vi->data + vi->data_idx past the end of the inline
> > > array, reading adjacent kmalloc-1k slab bytes into the hwrng core's
> > > buffer and from there into /dev/hwrng consumers and the kernel
> > > entropy pool.
> > >
> > > Exploitable most clearly in threat models that do not trust the
> > > hypervisor (confidential-compute guests on SEV-SNP or TDX; vhost-user
> > > split backends).
> >
> > Exploitable? I don't get it. How is reading this data into hwrng
> > a problem?
> >
> >
> > > KASAN confirms the OOB on a guest booted under a QEMU 9.0 whose
> > > virtio-rng backend has been patched to report used.len = 0x10000:
> > >
> > >   BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
> > >   Read of size 64 at addr ffff8880089c2220 by task hwrng/52
> > >   Call Trace:
> > >    __asan_memcpy
> > >    virtio_read+0x394/0x5d0
> > >    hwrng_fillfn+0xb2/0x470
> > >    kthread
> > >   Allocated by task 1:
> > >    probe_common+0xa5/0x660
> > >    virtio_dev_probe+0x549/0xbc0
> > >   The buggy address belongs to the object at ffff8880089c2000
> > >    which belongs to the cache kmalloc-1k of size 1024
> > >   The buggy address is located 0 bytes to the right of
> > >    allocated 544-byte region [ffff8880089c2000, ffff8880089c2220)
> > >
> > > hwrng_fillfn is a kernel thread that runs as soon as the device is
> > > probed; no guest userspace interaction is needed.
> > >
> > > Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer overflow in USB transport layer"),
> > > which hardened usb9pfs_rx_complete against unchecked device-reported
> > > length in the USB 9p transport.
> > >
> > > With the added len-vs-sizeof(vi->data) clamp in place the same
> > > harness boots cleanly: the driver logs "bogus used.len" once and
> > > subsequent reads wait for a honest response.
> > >
> > > Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > > Assisted-by: Claude:claude-opus-4-7
> > > ---
> > >  drivers/char/hw_random/virtio-rng.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > > index 0ce02d7e5048..6cff480787ca 100644
> > > --- a/drivers/char/hw_random/virtio-rng.c
> > > +++ b/drivers/char/hw_random/virtio-rng.c
> > > @@ -47,6 +47,18 @@ static void random_recv_done(struct virtqueue *vq)
> > >       if (!virtqueue_get_buf(vi->vq, &len))
> > >               return;
> > >
> > > +     /*
> > > +      * The device sets used.len; a malicious or buggy backend can
> > > +      * report more bytes than we posted.  Clamp before it reaches
> > > +      * copy_data() which indexes vi->data[].




> > > +      */
> > > +     if (len > sizeof(vi->data)) {
> > > +             dev_err(&vq->vdev->dev,
> > > +                     "bogus used.len %u > buffer size %zu\n",
> > > +                     len, sizeof(vi->data));
> > > +             len = 0;
> > > +     }


Maybe clamp at sizeof(vi->data) then? 0 might break buggy devices that
were working earlier.  
Or just clamp where it's used, for clarity.
And maybe we need the array_index dance, given
you are worried about malicious.


> > > +
> > >       smp_store_release(&vi->data_avail, len);
> > >       complete(&vi->have_data);
> > >  }
> > > --
> > > 2.53.0
> >

