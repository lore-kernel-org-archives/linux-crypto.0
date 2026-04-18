Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7F42DC78C
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776533947; cv=none; b=brTk7OCiaT+vFJoNnQRIGrsc8Fvy9NKNI52JJrteZFqOT+nUVXSorwCNWJsdrvDA1+4iYZUSk7mhdBNoj6xHW9iJulsZvVJJyK7kyOy3BydUgApQO/K68nBFdgVaYqgVhgFHGoqdN3UuB/wjZ/b1eFvgGAJIy1Ee+rtS/ZnJx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776533947; c=relaxed/simple;
	bh=llDeGbmz2A+QdJNJmtoYg0HsCG5svSKrZtPZxGU6lYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncJr5EGR7zaGp6EKfaFA318lksEu28v4uQ0uePdfV6QnOcCVWpo3+RD73Qi8i9jSQW5CY30sy1ckwGRYHOvecGO+OwFtOuGbu6QE90DvmDaoUS6H0tdDmCZn/BlemgrOJ138YZukFfa6LyogFipmvErT1CtkDJzLKtIWc74ZkmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cgam7ewV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s9j+z5cB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cgam7ewV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s9j+z5cB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776533943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9iy6MKv1dqfzDMGfIVAIu1M4pOZDOIff+mEjmJN5Vsc=;
	b=Cgam7ewV7/4TZSIUTFbxnFEEE8akB7QWdOmyMq/Z3P/nqJSribkR173DaK/QK0eAsdLX0Y
	52S2ZqDKLfCM8I0uy2mGNmF+08BsZ/f06opAUrD4LJVOTfPGy9argT03j2KuZgGa6MMzSu
	G0QRpoFnBG3j2i7zJBfFmkE9ynW2+A0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-D3ah5Y3vM7eunpWbbA6WgQ-1; Sat, 18 Apr 2026 13:39:02 -0400
X-MC-Unique: D3ah5Y3vM7eunpWbbA6WgQ-1
X-Mimecast-MFC-AGG-ID: D3ah5Y3vM7eunpWbbA6WgQ_1776533941
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488c2a4e257so12099795e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 10:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776533941; x=1777138741; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9iy6MKv1dqfzDMGfIVAIu1M4pOZDOIff+mEjmJN5Vsc=;
        b=s9j+z5cBcq1wRP8xDt05qX+6hZj2Qns7kkA6wFz1iZLkBrifZHkhBsdaC9upyXnEEo
         nd0v2jt4okpXcG3P3gvhs2PWiEDUj5/eh2OnHFc7+Fyg+7w7mamWXJt7FI4tFVKAX5dL
         dKUBlGPL3BUFYl8m2aGVnsxKR3FyVVKrAZPpUmbiVJIhqyM6SIjxua5s56CUz9PN4llF
         td3u82/ZrrAeHXgQ4s/6WJ3zDUvRHDshK79IpcQB3P6GNl391j/mKQdQ8xe4wLVHry/w
         d4wgGnv3xyLjFHPd68zsK013vX8X13QR5DeAOObKaOZbqPUhK68Kad9ifl1FM8Y7t9l/
         CgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776533941; x=1777138741;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9iy6MKv1dqfzDMGfIVAIu1M4pOZDOIff+mEjmJN5Vsc=;
        b=ShokPTqg98hQf5JYA41fp+IeIyN4Lk9RPKOmrUg+NPdQwtaIszI3usrW5VpnzD7V41
         POADhsGKLyDUj1TlbOFQ2kWTQkUcx+i3/Hux9/bDlBTKuAjn5vlewm3p4Jzpm1TIM34S
         aGxsYqkkeiL3REg5m2flO9rmWQvAOVXSnCLts5ldrYkaVa+KuJ70T1//vnWgbOJWF+yc
         l3TGeH1FYZNCtyEiQe9MFIgNXEUTLLqH5kKLyG7Ngrl0BGydkStIR3jnGWbS1dK6w/Ms
         D8IrwC9fv4phVj96kEkgyk1C89IIUZQLrQZ4Xo4woE8HBecOO69IdS/0jxhEJ3lQg4Ut
         yQXg==
X-Forwarded-Encrypted: i=1; AFNElJ9muuwBY8jktCy3SwWSsllDFFJ9kTmNbbEJSo1BkUPVbaBz9/Lziw+ZO4xHiCQ524Ky7xkIsQymZfs6IYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYQkVvD7oVraPa3X8YFsl2t4yCnyL9xj4cT37ElUvVyLfIEN48
	8d4i3RrRlG1gNH7wXCoUl34UguTUG0znArN9TE0fxkoNW1ElDvyGShvIne729IYn4rB+7fDhgFi
	ROtz91eb22OovJFqocyq2T8ZRVmbA9x1vlThEWg0E3qMeDnyubeHHjat4a3cdkn0sYA==
X-Gm-Gg: AeBDies//t1DndD5hf9auLPQUf3ohdonhqOpivT7vwsgYOZTsB5jHZIiemMLrfFy7HG
	Q2CQdgWvIm1vnBnx1LFDM+mcCQJeC9RHtcLd7RcsDs7XtzMVtbLsIpNjB6O59Yw9tCoI379M3wn
	GxuhbWvTXEMBqA5TuLFfeCL3j67Snv4z+FmY+BmO6feRFS0tbjAOcoH8a4auggVzM4juP2FVtVe
	60CD/KiPnQL7RoQ4uhZLN2uJBaFSbtDRp5hnhtRTfy3ffu3dUu1C8x2am4edssoAUP+45xqeMpD
	1RedQn0TxBLaQUpSqwhGx22zilEs/mOyJRpBolrUuMjUKLSqskYF+5fcD42YLFUi5EB4gBKkVH5
	UM28iRtaboopvX3kwb6wbOTVBrrtGJgFAsUO0LyAo3O4Nb8xkKrdlIA==
X-Received: by 2002:a05:600c:c4a2:b0:488:c078:bfda with SMTP id 5b1f17b1804b1-488fb78eebdmr104610005e9.26.1776533940869;
        Sat, 18 Apr 2026 10:39:00 -0700 (PDT)
X-Received: by 2002:a05:600c:c4a2:b0:488:c078:bfda with SMTP id 5b1f17b1804b1-488fb78eebdmr104609765e9.26.1776533940363;
        Sat, 18 Apr 2026 10:39:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc13938fsm213361595e9.10.2026.04.18.10.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 10:38:59 -0700 (PDT)
Date: Sat, 18 Apr 2026 13:38:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: virtio: clamp device-reported used.len at
 copy_data()
Message-ID: <20260418133030-mutt-send-email-mst@kernel.org>
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260418150613.3522589-1-michael.bommarito@gmail.com>
 <20260418131110-mutt-send-email-mst@kernel.org>
 <CAJJ9bXzgpAR3Gm+mZu=mZJyUrc6bpd+_crOGa7HLxteKxw1DzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJ9bXzgpAR3Gm+mZu=mZJyUrc6bpd+_crOGa7HLxteKxw1DzA@mail.gmail.com>

On Sat, Apr 18, 2026 at 01:25:35PM -0400, Michael Bommarito wrote:
> I think the difference comes back to how much you care about the
> threat model and something like Spectre on the memcpy later in
> copy_data. 

Maybe we do I'm just not sure I understand how do
all these checks help, and for what threat.
It could be just me being dense.

The commit log merely describes use.len being OOB
and also mentions data_idx.
Requests are always for sizeof(vi->data)
and they reset data_idx to 0:

static void request_entropy(struct virtrng_info *vi)
{
        struct scatterlist sg;

        reinit_completion(&vi->have_data);
        vi->data_idx = 0;

        sg_init_one(&sg, vi->data, sizeof(vi->data));

        /* There should always be room for one buffer. */
        virtqueue_add_inbuf(vi->vq, &sg, 1, vi->data, GFP_KERNEL);

        virtqueue_kick(vi->vq);
}


so to me, it looks like
clamping that at sizeof(vi->data) addresses that.


is there another threat you are worried about then?




> The more verbose patch would keep the barrier at the cost
> of the code complexity and a few extra cycles, but then we're back to
> same tradeoffs that have haunted just about everyone.
> 
> Will obviously defer to you on which path is really preferred, so let
> me know if you want v3 with the simple nospec clamp.
> 
> Thanks,
> Michael Bommarito
> 
> On Sat, Apr 18, 2026 at 1:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sat, Apr 18, 2026 at 11:06:13AM -0400, Michael Bommarito wrote:
> > > random_recv_done() stores the device-reported used.len directly into
> > > vi->data_avail.  copy_data() then indexes vi->data[] using
> > > vi->data_idx (advanced by previous copy_data() calls) and issues a
> > > memcpy() without re-validating either value against the posted
> > > buffer size sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32
> > > or 64).
> > >
> > > A malicious or buggy virtio-rng backend can set used.len beyond
> > > sizeof(vi->data), steering the memcpy() past the end of the inline
> > > array into adjacent kmalloc-1k slab bytes.  hwrng_fillfn() mixes
> > > those bytes into the guest RNG, and guest root can also observe
> > > them directly via /dev/hwrng.
> > >
> > > Concrete impact is inside the guest:
> > >
> > >  - Memory-safety / hardening: any virtio-rng backend that
> > >    over-reports used.len causes the driver to read past vi->data
> > >    into unrelated slab contents.  hwrng_fillfn() is a kernel thread
> > >    that runs as soon as the device is probed; no guest userspace
> > >    interaction is required to first-trigger the OOB.
> > >
> > >  - Cross-boundary leak (confidential-compute threat model): a
> > >    malicious hypervisor cooperating with a malicious or compromised
> > >    guest root userspace can use /dev/hwrng as a leak channel for
> > >    guest-kernel heap data.  The host sets a large used.len, guest
> > >    root reads /dev/hwrng, and the returned bytes contain guest
> > >    kernel slab contents that were adjacent to vi->data.  In
> > >    practice, confidential-compute guests (SEV-SNP, TDX) usually
> > >    disable virtio-rng entirely, so this path is narrow, but the
> > >    fix is still worth carrying because the underlying
> > >    memory-safety bug contaminates the guest RNG on any host.
> > >
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
> > > Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
> > > overflow in USB transport layer"), which hardened
> > > usb9pfs_rx_complete() against unchecked device-reported length in
> > > the USB 9p transport.
> > >
> > > With the clamp at point of use and array_index_nospec() in place,
> > > the same harness boots cleanly: copy_data() returns zero for the
> > > bogus report, the device-supplied bytes after data_idx are
> > > discarded, and the driver issues a fresh request.


there should be --- here, btw.

> > > Changes in v2 (per Michael S. Tsirkin review):
> > > - move the bound check from random_recv_done() into copy_data(),
> > >   so the clamp sits immediately next to the memcpy it protects
> > > - clamp to sizeof(vi->data) rather than substituting len = 0, so a
> > >   previously-working but buggy device that occasionally over-reports
> > >   used.len does not start returning zero-length reads
> > > - add array_index_nospec() on vi->data_idx to defeat a speculative
> > >   out-of-bounds read given the malicious-backend threat model
> > > - expand the commit message to describe the /dev/hwrng observation
> > >   path and the hypervisor + guest-root cooperation scenario
> > >
> > > Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> > > Cc: stable@vger.kernel.org
> > > Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> > > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > > Assisted-by: Claude:claude-opus-4-7
> > > ---
> > >  drivers/char/hw_random/virtio-rng.c | 23 +++++++++++++++++++++--
> > >  1 file changed, 21 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > > index 0ce02d7e5048..5e83ffa105e4 100644
> > > --- a/drivers/char/hw_random/virtio-rng.c
> > > +++ b/drivers/char/hw_random/virtio-rng.c
> > > @@ -7,6 +7,7 @@
> > >  #include <asm/barrier.h>
> > >  #include <linux/err.h>
> > >  #include <linux/hw_random.h>
> > > +#include <linux/nospec.h>
> > >  #include <linux/scatterlist.h>
> > >  #include <linux/spinlock.h>
> > >  #include <linux/virtio.h>
> > > @@ -69,8 +70,26 @@ static void request_entropy(struct virtrng_info *vi)
> > >  static unsigned int copy_data(struct virtrng_info *vi, void *buf,
> > >                             unsigned int size)
> > >  {
> > > -     size = min_t(unsigned int, size, vi->data_avail);
> > > -     memcpy(buf, vi->data + vi->data_idx, size);
> > > +     unsigned int idx, avail;
> > > +
> > > +     /*
> > > +      * vi->data_avail was set from the device-reported used.len and
> > > +      * vi->data_idx was advanced by previous copy_data() calls.  A
> > > +      * malicious or buggy virtio-rng backend can drive either past
> > > +      * sizeof(vi->data).  Clamp at point of use and harden the index
> > > +      * with array_index_nospec() so the memcpy() below cannot be
> > > +      * steered into adjacent slab memory, including under
> > > +      * speculation.
> > > +      */
> > > +     avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
> > > +     if (vi->data_idx >= avail) {
> > > +             vi->data_avail = 0;
> > > +             request_entropy(vi);
> > > +             return 0;
> > > +     }
> > > +     size = min_t(unsigned int, size, avail - vi->data_idx);
> > > +     idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> > > +     memcpy(buf, vi->data + idx, size);
> > >       vi->data_idx += size;
> > >       vi->data_avail -= size;
> > >       if (vi->data_avail == 0)
> > > --
> >
> >
> > This came out quite complex.
> > Tell me, will the following do the trick?
> >
> >
> > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > index 0ce02d7e5048..e887a68cc151 100644
> > --- a/drivers/char/hw_random/virtio-rng.c
> > +++ b/drivers/char/hw_random/virtio-rng.c
> > @@ -47,6 +47,8 @@ static void random_recv_done(struct virtqueue *vq)
> >         if (!virtqueue_get_buf(vi->vq, &len))
> >                 return;
> >
> > +       len = array_index_nospec(len, sizeof(vi->data));
> > +
> >         smp_store_release(&vi->data_avail, len);
> >         complete(&vi->have_data);
> >  }
> >
> >
> >
> > > 2.53.0
> >

