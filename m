Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4C7175A97
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 00:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471501; cv=pass; b=jw1S4V5vc7qrORLmiXJzJIXLmVyTqyuKrOs2Xq8kZqk8mNJ/3NF5CcG9rUxTw+h3tA0UlsjNxzOGW/vqAf15l1Bzd439k0tSdxtNHhTllhtb3jSNA9J1hUQE8KBbHQLN9H7S99+lKx9okSPNkgr/1T1xSo/zpgA7/WMZuMKBhGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471501; c=relaxed/simple;
	bh=0fq/k62J2WECMkmRL3KK0O5hTskGzbaTBYw8XK34SYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BEDsGhEl/OLSpVfNKOvHX8ar+wboFm3+ILs/6WY7IMWcaHMi4Cdm0iEJGRSho4+pRWRVTYTCcYQ3ARteVX+ro+xvhTwbg//m/YQhMwQsF4T3/6GFUgtgKiy455/hGCvRMeV21P+/3C8FZx0BVaTFGHblt8BaNg6DXdkva65gznk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JLZuBZr5; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JLZuBZr5"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-651bf4a4140so1384060d50.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 17:18:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776471499; cv=none;
        d=google.com; s=arc-20240605;
        b=ghYrywMQXoAEXUkK+n36hWCntG1wwtgs5ne5I/sF/1IOgPAsW7AQtkGKeEPwskQnmX
         83dixSWAQVinomGVJ1/l/KD8U2EbwOCpNd8nBPRPQ0Byv4xPlvxxj24nA7Zykcsv9SBS
         sCF+u4dvWiDFJf3qDZpyPEHLtLiIdyc1ZlBrJL8Z+nbomRS8pRjnHmBoVmoRaioXM7mI
         Y/+xpvyR1yTNobakjiR65XDZOMTcQCqLn5GcfMzQ4LxnDtk3qRyjGn8w7/SSQCmGcQpP
         0mqA7xnv3uTVt4bQoMsuEq6unlmzZHujnPC+4udbpBSjlJyloXjh07LZs/TfgqZSBdtO
         /e9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ufMLHX9gMotUEb7868YGJnmPO3wMbpT/JQ4gCvmvG0E=;
        fh=303idAGN/4S+Vv/J0/C831uXk955Rk8NiuEjvxo5+BI=;
        b=PV6kv5evak6eeLuuw6dczb8Y+lJExInFSh/zMY+wUCCu0Iq5SAJfgp1DcYa3XkDYGh
         MNj7seBmX9kvaPdZ0y8Beb1ToA8XHXHXJWdV5L27FJwZmG1/7ER2ENUUocNgmZATCczq
         W0T7oGopgjX6P1KhF+lTEN2wElirQsPWaCq8BbSehSBxRae4WL+zqGL4c0D34FU6rvDw
         XjIuX18TVowfw60vDzMJmd2zWD8oOVcVJkh3r4RUILXS9ao/UZlKj/28N/EWaZ2ERc+9
         cGkfbwiARVTnHeFsuyw6WOBGGax9Z6hrR7VzsrsBukkOIgfCBY3zW+8Jo6MdTLNRQctT
         TmDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776471499; x=1777076299; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufMLHX9gMotUEb7868YGJnmPO3wMbpT/JQ4gCvmvG0E=;
        b=JLZuBZr5TZaWFT3tTWQY/pqL6XAQUsoaAzOoGy5/VGwfJXpZjb55HbtPrMcstlPl+o
         sna+4Qpwg0v9oYrNL+oCNN3e6a10w3Om5NoX7YfLNDsm2U2hPbZn0cZP8uSGZIuq09rZ
         yvmLzjA+xD1sWgH2B3T8yOU3nUlGFJrJaJzqpqWJLzMbVmGT3/rbzllhvuLzo4s+Lyaq
         WMCpvaIb//yuuGeg3VkLbIh7LdrYI3SxIInOGJQrJWNRyrJ4LP7Af9s/2E5cHi/OL2zi
         cWaFaO2afZSdj1HDZ1+NtkZmx/UxSwT4F9SEs/QUReOGXePiMayjCUD+bSAZBPfMg6qv
         XBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776471499; x=1777076299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ufMLHX9gMotUEb7868YGJnmPO3wMbpT/JQ4gCvmvG0E=;
        b=RGpHQjoiaK/FlYwqFzwAQ7VIzjl2ZOnbtDJQmk8nwIe7+wZyVdOj+imC0Pwe6O3d0o
         Lx6ddzhGM22ZC5hPclapNbU1Q/LqByc0eVASK7GynAPeEyiX7vHSqBywnnQmVG97EGQl
         S4ALHdkDTtBGxswXgBd0UyZADncHZz1DCVdvWiqwlLn/4ZMWP73XshjJDXdP0Z7V1uLP
         FJw0AEimwy9nCzJGQ7DasCZXwIsWIcmavV/dUZ6hdmmVuZfUaufbSm7yIT7L8jm8naBJ
         iwSo30JK3LXYvIl2Z/QcGl7SBCkxglsosTUZjPHsNXtXIuiRFUFaZoODYa39RPsOYheJ
         51xw==
X-Forwarded-Encrypted: i=1; AFNElJ88PvRmowp4nxoLgRnV0wyuJpfGk3YUV9Uxe20k7JCnRQ6e8p3YFydnTf78lS+aOqkpW3dhGvS1NybfKDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLA7zzxhcQIj+tQ87hOzy7IlzOByLEIAKqYLeEw3myMz9NDOq9
	f3n/5jdLNGKSMOCpHbANq6gq2nrmw0R5ib3eYlS8t5nPgUV8EQRt0druup4WPGY0t6rRfN+L+D0
	F5dBwLWCeP7+91+9MnKmI9OKrC9mZvAI=
X-Gm-Gg: AeBDieuodGsLRRkdLO6JQrZ6S1gpMATSUq7M2r8bBwlpwp6tL22sJUxn1x2wqireK7B
	qNpOvQfflDhZp7BeEdybsgkqcb6ETnDHNUt2mvYkdUGuF39wcOA8BfBNRScKgIw/gFgSA43jmti
	VqtHtFi8f+ip/tXdafD9oQP9Tt4RUqnvySY3cQUoFiEc90ZwaUR5QQF4pcaTjBeoJMyEAJkE57w
	MmjbCmN8wqo9OjpU+HRogSfPcw9eynkKqGxCcnZ8iV0xcU8A95ayIaJ0/CkJaTdEdPxV63z6IGf
	BSfuHLmcWGonUKDNgE4vk4QfcantGcxkne7o8Ro1SGpQ78mR/myrC6sZ8Q==
X-Received: by 2002:a05:690e:1441:b0:64e:7a8c:73b3 with SMTP id
 956f58d0204a3-6531087e139mr4610575d50.27.1776471499015; Fri, 17 Apr 2026
 17:18:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418000020.1847122-1-michael.bommarito@gmail.com> <20260417201129-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260417201129-mutt-send-email-mst@kernel.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Fri, 17 Apr 2026 20:18:06 -0400
X-Gm-Features: AQROBzDE4M9mnsEFp1jVk6NfdmxsSKNHM1WT8Y-f3Y3t3kuojWCBO1MST0bLLBE
Message-ID: <CAJJ9bXzhKTBx4m3-SCM+ccGd6ZhTXTAbRxKekCzidnXY6yXbWg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: virtio: reject invalid used.len from the device
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

"Actionable" is probably the better word there, sorry.  If it were
otherwise, I wouldn't have filed publicly

If you end up ACKing the correctness change, I can send v2 with better log

Thanks,
Michael Bommarito

On Fri, Apr 17, 2026 at 8:13=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, Apr 17, 2026 at 08:00:20PM -0400, Michael Bommarito wrote:
> > random_recv_done() stored the device-reported used.len directly into
> > vi->data_avail without validating it against the posted buffer size
> > sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32 or 64).  A
> > malicious or buggy virtio-rng backend could set used.len beyond
> > vi->data so that the subsequent copy_data() in virtio_read() issues
> > memcpy() from vi->data + vi->data_idx past the end of the inline
> > array, reading adjacent kmalloc-1k slab bytes into the hwrng core's
> > buffer and from there into /dev/hwrng consumers and the kernel
> > entropy pool.
> >
> > Exploitable most clearly in threat models that do not trust the
> > hypervisor (confidential-compute guests on SEV-SNP or TDX; vhost-user
> > split backends).
>
> Exploitable? I don't get it. How is reading this data into hwrng
> a problem?
>
>
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
> > hwrng_fillfn is a kernel thread that runs as soon as the device is
> > probed; no guest userspace interaction is needed.
> >
> > Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer overflow =
in USB transport layer"),
> > which hardened usb9pfs_rx_complete against unchecked device-reported
> > length in the USB 9p transport.
> >
> > With the added len-vs-sizeof(vi->data) clamp in place the same
> > harness boots cleanly: the driver logs "bogus used.len" once and
> > subsequent reads wait for a honest response.
> >
> > Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Assisted-by: Claude:claude-opus-4-7
> > ---
> >  drivers/char/hw_random/virtio-rng.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_rand=
om/virtio-rng.c
> > index 0ce02d7e5048..6cff480787ca 100644
> > --- a/drivers/char/hw_random/virtio-rng.c
> > +++ b/drivers/char/hw_random/virtio-rng.c
> > @@ -47,6 +47,18 @@ static void random_recv_done(struct virtqueue *vq)
> >       if (!virtqueue_get_buf(vi->vq, &len))
> >               return;
> >
> > +     /*
> > +      * The device sets used.len; a malicious or buggy backend can
> > +      * report more bytes than we posted.  Clamp before it reaches
> > +      * copy_data() which indexes vi->data[].
> > +      */
> > +     if (len > sizeof(vi->data)) {
> > +             dev_err(&vq->vdev->dev,
> > +                     "bogus used.len %u > buffer size %zu\n",
> > +                     len, sizeof(vi->data));
> > +             len =3D 0;
> > +     }
> > +
> >       smp_store_release(&vi->data_avail, len);
> >       complete(&vi->have_data);
> >  }
> > --
> > 2.53.0
>
