Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F4A199E89
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776532696; cv=none; b=SWMiCY2fzw/7PEXqRqScc8f+aRdZxluL0WxF0fxF9moAcpnjr7sxpCR2Z7Rbrk22CNSY6gqrTsP9TZlNJUdYQhk8d9JsGQqActI8yBmUvuJ9GOyRZG+nDaGzWVArcoiaHy9mCvm1s+YnYampzYLEdRGGfrRjJMxfjfEyyJ7Ditg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776532696; c=relaxed/simple;
	bh=Gu8eeLkTFWApFqN/pJd9fwrbx7MTr5fi31lrqj7DrzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjwcKMJ8VLDguH+ZtLA9EPO1meCIoGqD+D7LozmI9MdRjLZIW8huQMA9ohLSsZWhn4MYrRoH4JBrgsS3xRXYi075HtgBCnkdvIq8RA62rcqiT5gW8eJxEYoCe35pyDrO6lctjc4eu3AfQ5PEAKwPZpei3jjKYZHPo/0m9iB+73o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpUOmx3A; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYmgwv/g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpUOmx3A";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYmgwv/g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776532694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lg1X2HhPqDML25PLvODz8bdExDJw0JHd2gmFAwXJGFI=;
	b=bpUOmx3AGLgCBTkSiVmfE/wBdqIVjgX05Q6REY+VMK1/hCxuu3Bf7I1PNUiHK1O2VDYnK3
	piIatKR1ulrEl+18+iLuuLfAUegkV85VbRdkOh9ZgGwC46/AoKdLSL/s0Ritg8RdsoXDOT
	zhYp+Mtw42nyH1iG6f/Xyh0cSnywBsc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-PQBKvlhTPEqj3eXOVENcqg-1; Sat, 18 Apr 2026 13:18:12 -0400
X-MC-Unique: PQBKvlhTPEqj3eXOVENcqg-1
X-Mimecast-MFC-AGG-ID: PQBKvlhTPEqj3eXOVENcqg_1776532691
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488e12db7e0so14173525e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 10:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776532691; x=1777137491; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lg1X2HhPqDML25PLvODz8bdExDJw0JHd2gmFAwXJGFI=;
        b=JYmgwv/gyIF7qHnmlAieciyXmOfKbqLwSjd/KlCYhCSL/9CTaQpdT9WU4aUV9E4RoP
         EcowiG0N5BYK/pM3KqWj8DVxROPiw4732ZdsdTbC2VdjpVq5HGYClkS7k0OkuPzWbrO4
         qlNHwYUCyCUftL6ugDfx85/WuqeUt/aNMDwkRa7kGX4jFK40iF2nQi6WuYKoR+0NAIGS
         PFKEXlmm0emr6Y88KpEHYfC4TUiHqDvNSxdIN2x5Jc5CF08pWIzHYAQyxK3t2PVrXPJM
         X5pLfxLUPiApeqhEQVFUrMIHYcNJECtMFfvhaIoFy5PEHCEh9Fnxm7HIbVeGAIxzZhUn
         g1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776532691; x=1777137491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lg1X2HhPqDML25PLvODz8bdExDJw0JHd2gmFAwXJGFI=;
        b=sWeS4Muoq4JufvI8dqd8pDG35i6JbrrUhFoMVAuzIxHK+Ipwp7Bg1uUH90T1WVu8bn
         lPgbxzILMdgF0zl0A5Ifqcd8ucLAEzCL37oi/23lzEkIFi2xKhr89p3OhOBLjUWYsH7j
         nsP6N8zC+CRpjzzv8/Dg304uIaTsdA0Gr2YEdmDqMx70Oc1p6jAaPk98ZOoynP+taQ6f
         4Kp+O5tJYs32cytiuMpgs300zU03NTIfkF7lz33m/SXXbhJgm3VDZxVDsJC0tJQFu5Ne
         29m6WTWqjaPanENB5LzEXV5V0U5LoMmMVrHX4htMVDQS9WR7f054TtkZOUm6iwtG2eIX
         xFrw==
X-Forwarded-Encrypted: i=1; AFNElJ+5yOZVvQLBBFnHe0oTIdWhL6TZD2qp5AuVzk///4FGfBUzFSQoCfYqaEHG2dQxOYF2022eKVr/uyKgCQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7DIP9SZ5G6Fg4y+egpynqAs5ID0qOJkldwJVTAqtmeRKqN3Zp
	tH2u03RdlZ5as0oY+cyKbyiZI0vzQZY1hysdoZFl5IXB0Zn0RePLfZQL5wQtRBkS3Xtfvb0Utv7
	FBG/SUetZQtgyRATNdLnSYAofu2sYUX9mI2dJS4dDvPXiM/v6JjO57atXPIA7LlgHQQ==
X-Gm-Gg: AeBDiet4dHAmk6PHENHUfiuBvGiLWfcJu72xb4G4398FuP6YMMu33HqlZ/+nTM/yAEX
	iAiBdIHxcoulyDiIN+fpRYT+7fYVQXkZfH6dld7d8MYp2Vkf6s3CfcF/gFjM3F0ckjdTvS8yZGf
	exbqiHFGjbTdm2ESSCViDOYtMbhOrekPBwaWpR9wsOkzOVocv+0rX89zRj1kVyo8IdlytBMcv7a
	I+BWD0l3QR/OhhLaWsHSNja+nEGDj8BajK/UtHIaWQGFyC6UcOWtSEyUVpyY2idNxK4FR8N9cTc
	RoGK4TAORQuIbyLibN/W3TaVOA4SQUDV5j//DGJd4279LLdPF+hgC9vjDwNzCYzvWI1/QDDR+ZA
	YAnajF/3HcSBI9DymKpKgZQx5O4o5knIFfWdoLWVqkFsTTO48LQsw0Q==
X-Received: by 2002:a05:600c:8b38:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-488fb6e815amr111086585e9.0.1776532691209;
        Sat, 18 Apr 2026 10:18:11 -0700 (PDT)
X-Received: by 2002:a05:600c:8b38:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-488fb6e815amr111085965e9.0.1776532690536;
        Sat, 18 Apr 2026 10:18:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1c0354sm129158345e9.11.2026.04.18.10.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 10:18:09 -0700 (PDT)
Date: Sat, 18 Apr 2026 13:18:07 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: virtio: clamp device-reported used.len at
 copy_data()
Message-ID: <20260418131110-mutt-send-email-mst@kernel.org>
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260418150613.3522589-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418150613.3522589-1-michael.bommarito@gmail.com>

On Sat, Apr 18, 2026 at 11:06:13AM -0400, Michael Bommarito wrote:
> random_recv_done() stores the device-reported used.len directly into
> vi->data_avail.  copy_data() then indexes vi->data[] using
> vi->data_idx (advanced by previous copy_data() calls) and issues a
> memcpy() without re-validating either value against the posted
> buffer size sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32
> or 64).
> 
> A malicious or buggy virtio-rng backend can set used.len beyond
> sizeof(vi->data), steering the memcpy() past the end of the inline
> array into adjacent kmalloc-1k slab bytes.  hwrng_fillfn() mixes
> those bytes into the guest RNG, and guest root can also observe
> them directly via /dev/hwrng.
> 
> Concrete impact is inside the guest:
> 
>  - Memory-safety / hardening: any virtio-rng backend that
>    over-reports used.len causes the driver to read past vi->data
>    into unrelated slab contents.  hwrng_fillfn() is a kernel thread
>    that runs as soon as the device is probed; no guest userspace
>    interaction is required to first-trigger the OOB.
> 
>  - Cross-boundary leak (confidential-compute threat model): a
>    malicious hypervisor cooperating with a malicious or compromised
>    guest root userspace can use /dev/hwrng as a leak channel for
>    guest-kernel heap data.  The host sets a large used.len, guest
>    root reads /dev/hwrng, and the returned bytes contain guest
>    kernel slab contents that were adjacent to vi->data.  In
>    practice, confidential-compute guests (SEV-SNP, TDX) usually
>    disable virtio-rng entirely, so this path is narrow, but the
>    fix is still worth carrying because the underlying
>    memory-safety bug contaminates the guest RNG on any host.
> 
> KASAN confirms the OOB on a guest booted under a QEMU 9.0 whose
> virtio-rng backend has been patched to report used.len = 0x10000:
> 
>   BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
>   Read of size 64 at addr ffff8880089c2220 by task hwrng/52
>   Call Trace:
>    __asan_memcpy
>    virtio_read+0x394/0x5d0
>    hwrng_fillfn+0xb2/0x470
>    kthread
>   Allocated by task 1:
>    probe_common+0xa5/0x660
>    virtio_dev_probe+0x549/0xbc0
>   The buggy address belongs to the object at ffff8880089c2000
>    which belongs to the cache kmalloc-1k of size 1024
>   The buggy address is located 0 bytes to the right of
>    allocated 544-byte region [ffff8880089c2000, ffff8880089c2220)
> 
> Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
> overflow in USB transport layer"), which hardened
> usb9pfs_rx_complete() against unchecked device-reported length in
> the USB 9p transport.
> 
> With the clamp at point of use and array_index_nospec() in place,
> the same harness boots cleanly: copy_data() returns zero for the
> bogus report, the device-supplied bytes after data_idx are
> discarded, and the driver issues a fresh request.
> 
> Changes in v2 (per Michael S. Tsirkin review):
> - move the bound check from random_recv_done() into copy_data(),
>   so the clamp sits immediately next to the memcpy it protects
> - clamp to sizeof(vi->data) rather than substituting len = 0, so a
>   previously-working but buggy device that occasionally over-reports
>   used.len does not start returning zero-length reads
> - add array_index_nospec() on vi->data_idx to defeat a speculative
>   out-of-bounds read given the malicious-backend threat model
> - expand the commit message to describe the /dev/hwrng observation
>   path and the hypervisor + guest-root cooperation scenario
> 
> Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> Cc: stable@vger.kernel.org
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7
> ---
>  drivers/char/hw_random/virtio-rng.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 0ce02d7e5048..5e83ffa105e4 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -7,6 +7,7 @@
>  #include <asm/barrier.h>
>  #include <linux/err.h>
>  #include <linux/hw_random.h>
> +#include <linux/nospec.h>
>  #include <linux/scatterlist.h>
>  #include <linux/spinlock.h>
>  #include <linux/virtio.h>
> @@ -69,8 +70,26 @@ static void request_entropy(struct virtrng_info *vi)
>  static unsigned int copy_data(struct virtrng_info *vi, void *buf,
>  			      unsigned int size)
>  {
> -	size = min_t(unsigned int, size, vi->data_avail);
> -	memcpy(buf, vi->data + vi->data_idx, size);
> +	unsigned int idx, avail;
> +
> +	/*
> +	 * vi->data_avail was set from the device-reported used.len and
> +	 * vi->data_idx was advanced by previous copy_data() calls.  A
> +	 * malicious or buggy virtio-rng backend can drive either past
> +	 * sizeof(vi->data).  Clamp at point of use and harden the index
> +	 * with array_index_nospec() so the memcpy() below cannot be
> +	 * steered into adjacent slab memory, including under
> +	 * speculation.
> +	 */
> +	avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
> +	if (vi->data_idx >= avail) {
> +		vi->data_avail = 0;
> +		request_entropy(vi);
> +		return 0;
> +	}
> +	size = min_t(unsigned int, size, avail - vi->data_idx);
> +	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> +	memcpy(buf, vi->data + idx, size);
>  	vi->data_idx += size;
>  	vi->data_avail -= size;
>  	if (vi->data_avail == 0)
> -- 


This came out quite complex.
Tell me, will the following do the trick?


diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 0ce02d7e5048..e887a68cc151 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -47,6 +47,8 @@ static void random_recv_done(struct virtqueue *vq)
 	if (!virtqueue_get_buf(vi->vq, &len))
 		return;
 
+	len = array_index_nospec(len, sizeof(vi->data));
+
 	smp_store_release(&vi->data_avail, len);
 	complete(&vi->have_data);
 }



> 2.53.0

