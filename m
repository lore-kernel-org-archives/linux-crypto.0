Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C42FB965
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776533148; cv=pass; b=poEvogDaq0Hj1o4krdyG0k4lH4e7a6ENL6aZxciZ7i5VMwIQVy5nQMSnjKaGuPi2dTsCddNGTrzwwip8Gu29DQDe7CequgWaDkCciEIxV/kqCHz9gpFrGAfJyQJo/oDX0zIxIBNV43jjVSMPPDoH6eqhYVbmWWNtEMBlDjqlRV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776533148; c=relaxed/simple;
	bh=PXs6wNz75xIBGdCbRKGTDNq3jTK8HB4Mt+I/IXfIlfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBf9SGWmyDCPwURcf61bYB6sJclp+KYSYuYSJkO/2fCUtbEu3pJQrail082MsWJ4PGqpQigvf+FKyUaHJcc8ljCFrnpYzWqzePdnk5xFipxL5Bpt0j+96eR8N8hWw/Zyjv8p5qZAflbCw/NCwlxlE6QK0Im5y1vsoU5RnACDA04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HG9EZ8pz; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HG9EZ8pz"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-79a535e7c00so17670547b3.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 10:25:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776533146; cv=none;
        d=google.com; s=arc-20240605;
        b=fy6/NVuzXxL0QjD8Gt8iqEqNa8Vvv6sPxCVv2kRU5xLy8ODfUboMkZOtconquW5WMQ
         P7pXCUoG9OzM0gGdrRRL3ec88B1Nc01CIGQaPUQFz0e57g6JlTI4xWYrfo26y6FPI5IM
         eU76/I54c1NdRaXvmampOpX+WrAZGqZlhExmTdKvO/4k4RAKi40fPDVjfiOblxMzHsF7
         /Gu0pf5WQ3o2AxuM2vZt4svchreqOJqzMuU0iKIp5D5Hg3nEhsjh/acwUHK9hbldcjOi
         uRss2C7zjtlIdehKfVkbzQrjkMR7lnDcBPZiTt6cWjWZRwfQGsF5BA9zaI9XRV65jtra
         dKxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dSTI/WkTQ8ZEaBBDiJFn9nk0Gv0pkdWzZ/x/WhPv15g=;
        fh=FTP0BGhJdRjPZ765IKTJ5fKuGxKWFvdeS1k8vC2QKHg=;
        b=Q/d1VSyXtSLU6pg6a3VPiPKSBpy193UZEkKqnyOUxMDdU59D2VUcVZyanyc/PVCg2K
         OXr316QeqrclNrcFqknLnMkZS6bZCwbd3pCm6BpisLTbYcTg7wkCUyuw4GR8e5CW/lKY
         hGXV9/a+TApHMF0UBwJNVcBhevIezWiUFjqvD/ELxZejlbgc93oZKckCevb927W/gil+
         mJJbumXCcN3iUXmMOS1z2daOm12RO1/ljfYCE4d5x5QbmovxXBW7v4XKBCjbIS0LHnLL
         T5d2oDQ8/zHsUnqJPzUb3VdeLPSQHczZ4mjzEy3p6XEQiBQLgiMGwa0U3ELPQ3UMT6Bi
         aocw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776533146; x=1777137946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dSTI/WkTQ8ZEaBBDiJFn9nk0Gv0pkdWzZ/x/WhPv15g=;
        b=HG9EZ8pzvApCbW2BJjco/pD2iXO1b+6bV+DaBtlxJCTgKJgI82J9vY98vEWMxgo/x5
         SZh4QVYVzvDMFdMguBvs34OTCjlscOOtSQFzeop2uWXRgUAX6DwOdiFU8d4U8JOiCugK
         SWo7u5feONxdWe7r7hfCbV59uZFYcj47LbN7IGWDC4kS5baMdQRRqI8dcYGHTxz3Vc9B
         anSm/4/8xFXxPumXxtZx6LMx0SMuQqqwErVC+wMfuMVXEsvIV9GStBKdMOz7GuFh/9V+
         1C/KiRfI1/Hxzk7tIhmpjPrKmHt8mh4EYUnxE60In+eIuOS/bf3IxAQ2vwsD37Hwoe3N
         pung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776533146; x=1777137946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dSTI/WkTQ8ZEaBBDiJFn9nk0Gv0pkdWzZ/x/WhPv15g=;
        b=o6ab17QrPEPngHKh9w95ux/r6IdUuvffOrv6PzFLcCz/lELuG7MhVCJI2dxFI5SmBS
         tfQspawuTaqnI34cxeiLFEbRzozc8i276X6RBi0O3qS8AklTkEPXbxcIdqQyGtC9DZFL
         Epz3tSZamD8e+oQCKEuuQIkn5qLQZHI2JdQ6/lp3kcGWww/ZI3o0DFXs7GmKAi3hnhMq
         t37+hOdMoaPsW17TweUBJJkfYVyrPAYT7Wc71/Ra1LdQG9xlQL1SuyLNHEpXhdVJiCmI
         C7Lw6zG0soFmSSrAAKTovcrmHXKYTdJPDCR6YOgkRzio5dIWBw9UalPpcj+HO7dRb0zu
         v+gQ==
X-Forwarded-Encrypted: i=1; AFNElJ88cU125jorO6NU7orMsyhg71wGKS4TDgEj2LKthI6L5dvfah0/QhIxGW1jmOZM6w4xEn567rp/2d7/8qQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhfaea6VOi7Lj074KCJ1W1lecowYTpP2mi3In/atb6Oz8fI8Fm
	V/mGQN65NUmt7HTyYimmAb/Y3GEWSshwnx7yj+TO9NYdDZZOSaZgSk1FK3Yx2PlH1D1VPhKlsvN
	7K1y4gKE3p/rT1PnR8ZpU2vek1iBSwTw=
X-Gm-Gg: AeBDietsxgxGAjVEUVY4YvaGvPMeA5v6E1xAUvVC0Oeqzg9ak0gyb6/dD8+uLEc5iYl
	X4Om2nayrOQrlhma4vDm+p9c0nX4mqCx865GSJMeva0fVBFQmIcrOlHan2fj8a2UWiD/tnvAcWU
	YS9ol4mmX1oSVxrv7XZZAB5d2hmJS52o/ShxfCp4xSRywBCvnVfQKgdcHPZtm4SQEyAZdCDKKA0
	kuHO237/pjaKfVHepI0lZlIVPYdJ6QKPdGS3m0lVIOekDTbYzRFKRk/hLa09rRTR9+X8nS45uuH
	Dx5Pto4Oif6nywIivtOTYUxWQ09XBwbP3ElWgO2HKHCV1vE=
X-Received: by 2002:a05:690c:6287:b0:7b7:c5a2:fa49 with SMTP id
 00721157ae682-7b9eced6930mr77017957b3.18.1776533146371; Sat, 18 Apr 2026
 10:25:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260418150613.3522589-1-michael.bommarito@gmail.com> <20260418131110-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260418131110-mutt-send-email-mst@kernel.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Sat, 18 Apr 2026 13:25:35 -0400
X-Gm-Features: AQROBzDT3kYQN6FTEB39CbF7ifYRqJlh98jShRI2O0kpza3_E2SMt54ZBVdorkI
Message-ID: <CAJJ9bXzgpAR3Gm+mZu=mZJyUrc6bpd+_crOGa7HLxteKxw1DzA@mail.gmail.com>
Subject: Re: [PATCH v2] hwrng: virtio: clamp device-reported used.len at copy_data()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Jason Wang <jasowang@redhat.com>, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I think the difference comes back to how much you care about the
threat model and something like Spectre on the memcpy later in
copy_data.  The more verbose patch would keep the barrier at the cost
of the code complexity and a few extra cycles, but then we're back to
same tradeoffs that have haunted just about everyone.

Will obviously defer to you on which path is really preferred, so let
me know if you want v3 with the simple nospec clamp.

Thanks,
Michael Bommarito

On Sat, Apr 18, 2026 at 1:18=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Sat, Apr 18, 2026 at 11:06:13AM -0400, Michael Bommarito wrote:
> > random_recv_done() stores the device-reported used.len directly into
> > vi->data_avail.  copy_data() then indexes vi->data[] using
> > vi->data_idx (advanced by previous copy_data() calls) and issues a
> > memcpy() without re-validating either value against the posted
> > buffer size sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32
> > or 64).
> >
> > A malicious or buggy virtio-rng backend can set used.len beyond
> > sizeof(vi->data), steering the memcpy() past the end of the inline
> > array into adjacent kmalloc-1k slab bytes.  hwrng_fillfn() mixes
> > those bytes into the guest RNG, and guest root can also observe
> > them directly via /dev/hwrng.
> >
> > Concrete impact is inside the guest:
> >
> >  - Memory-safety / hardening: any virtio-rng backend that
> >    over-reports used.len causes the driver to read past vi->data
> >    into unrelated slab contents.  hwrng_fillfn() is a kernel thread
> >    that runs as soon as the device is probed; no guest userspace
> >    interaction is required to first-trigger the OOB.
> >
> >  - Cross-boundary leak (confidential-compute threat model): a
> >    malicious hypervisor cooperating with a malicious or compromised
> >    guest root userspace can use /dev/hwrng as a leak channel for
> >    guest-kernel heap data.  The host sets a large used.len, guest
> >    root reads /dev/hwrng, and the returned bytes contain guest
> >    kernel slab contents that were adjacent to vi->data.  In
> >    practice, confidential-compute guests (SEV-SNP, TDX) usually
> >    disable virtio-rng entirely, so this path is narrow, but the
> >    fix is still worth carrying because the underlying
> >    memory-safety bug contaminates the guest RNG on any host.
> >
> > KASAN confirms the OOB on a guest booted under a QEMU 9.0 whose
> > virtio-rng backend has been patched to report used.len =3D 0x10000:
> >
> >   BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
> >   Read of size 64 at addr ffff8880089c2220 by task hwrng/52
> >   Call Trace:
> >    __asan_memcpy
> >    virtio_read+0x394/0x5d0
> >    hwrng_fillfn+0xb2/0x470
> >    kthread
> >   Allocated by task 1:
> >    probe_common+0xa5/0x660
> >    virtio_dev_probe+0x549/0xbc0
> >   The buggy address belongs to the object at ffff8880089c2000
> >    which belongs to the cache kmalloc-1k of size 1024
> >   The buggy address is located 0 bytes to the right of
> >    allocated 544-byte region [ffff8880089c2000, ffff8880089c2220)
> >
> > Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
> > overflow in USB transport layer"), which hardened
> > usb9pfs_rx_complete() against unchecked device-reported length in
> > the USB 9p transport.
> >
> > With the clamp at point of use and array_index_nospec() in place,
> > the same harness boots cleanly: copy_data() returns zero for the
> > bogus report, the device-supplied bytes after data_idx are
> > discarded, and the driver issues a fresh request.
> >
> > Changes in v2 (per Michael S. Tsirkin review):
> > - move the bound check from random_recv_done() into copy_data(),
> >   so the clamp sits immediately next to the memcpy it protects
> > - clamp to sizeof(vi->data) rather than substituting len =3D 0, so a
> >   previously-working but buggy device that occasionally over-reports
> >   used.len does not start returning zero-length reads
> > - add array_index_nospec() on vi->data_idx to defeat a speculative
> >   out-of-bounds read given the malicious-backend threat model
> > - expand the commit message to describe the /dev/hwrng observation
> >   path and the hypervisor + guest-root cooperation scenario
> >
> > Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Assisted-by: Claude:claude-opus-4-7
> > ---
> >  drivers/char/hw_random/virtio-rng.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_rand=
om/virtio-rng.c
> > index 0ce02d7e5048..5e83ffa105e4 100644
> > --- a/drivers/char/hw_random/virtio-rng.c
> > +++ b/drivers/char/hw_random/virtio-rng.c
> > @@ -7,6 +7,7 @@
> >  #include <asm/barrier.h>
> >  #include <linux/err.h>
> >  #include <linux/hw_random.h>
> > +#include <linux/nospec.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/virtio.h>
> > @@ -69,8 +70,26 @@ static void request_entropy(struct virtrng_info *vi)
> >  static unsigned int copy_data(struct virtrng_info *vi, void *buf,
> >                             unsigned int size)
> >  {
> > -     size =3D min_t(unsigned int, size, vi->data_avail);
> > -     memcpy(buf, vi->data + vi->data_idx, size);
> > +     unsigned int idx, avail;
> > +
> > +     /*
> > +      * vi->data_avail was set from the device-reported used.len and
> > +      * vi->data_idx was advanced by previous copy_data() calls.  A
> > +      * malicious or buggy virtio-rng backend can drive either past
> > +      * sizeof(vi->data).  Clamp at point of use and harden the index
> > +      * with array_index_nospec() so the memcpy() below cannot be
> > +      * steered into adjacent slab memory, including under
> > +      * speculation.
> > +      */
> > +     avail =3D min_t(unsigned int, vi->data_avail, sizeof(vi->data));
> > +     if (vi->data_idx >=3D avail) {
> > +             vi->data_avail =3D 0;
> > +             request_entropy(vi);
> > +             return 0;
> > +     }
> > +     size =3D min_t(unsigned int, size, avail - vi->data_idx);
> > +     idx =3D array_index_nospec(vi->data_idx, sizeof(vi->data));
> > +     memcpy(buf, vi->data + idx, size);
> >       vi->data_idx +=3D size;
> >       vi->data_avail -=3D size;
> >       if (vi->data_avail =3D=3D 0)
> > --
>
>
> This came out quite complex.
> Tell me, will the following do the trick?
>
>
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random=
/virtio-rng.c
> index 0ce02d7e5048..e887a68cc151 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -47,6 +47,8 @@ static void random_recv_done(struct virtqueue *vq)
>         if (!virtqueue_get_buf(vi->vq, &len))
>                 return;
>
> +       len =3D array_index_nospec(len, sizeof(vi->data));
> +
>         smp_store_release(&vi->data_avail, len);
>         complete(&vi->have_data);
>  }
>
>
>
> > 2.53.0
>
