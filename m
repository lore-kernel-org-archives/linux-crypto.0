Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D10DF59
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 00:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471222; cv=none; b=ktuDsHPkvH08yb0fhU/J+9SF+c6raZT3yaV9HlpGw+gxihYqNT62MXGP07bctTn5G8volZbCFD93PNOomRAiigtHZMnDRpY6kfB2bbJoECwqIKEAJv64TKj/ICEB215fZzRZ0W+3am9X9QwGpzhs9omP9hlHNFmjT8WBukaVmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471222; c=relaxed/simple;
	bh=t413uR2z+VC95wnVTYrHIk0J3dXWJAB9CuV5ei4kcJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKX+wzRHcxMbyb9REGIVcz8uJeSivAhBR62c+KxUGiUg9FeHvou3tnPEMM3ZY66msnJOI4qbNqe4ifLjRb6t0lN1CXdSE3DWKTQqDJhzBKlVHmoy/HxsOs2+RGH0KF7kU24dxO88KYT53lPTA4X/09WJITWh6PRmT2yqr14y6CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NJn7zydr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WOVudNme; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJn7zydr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WOVudNme"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776471219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DLc6i5hTDljAXhin+tlCr4ec80GPJxXVTT+TZFT5DQo=;
	b=NJn7zydrZgkShAJqv3bt9FObmLpWlnDOafon91IILFTIatMKq4EhQ889wZa+cYrc60YNAy
	bsepouMmEYl37mGSzlrnu/g8DphC6xxAP2qFeEkCu6W44NIBe2VkbxorPywwqF+bdr3/7/
	a2ClKY4XKdJX5TZN2b7Y7P3za4IsLco=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-T-pZtFs_PvG_O9SuqfjFRA-1; Fri, 17 Apr 2026 20:13:37 -0400
X-MC-Unique: T-pZtFs_PvG_O9SuqfjFRA-1
X-Mimecast-MFC-AGG-ID: T-pZtFs_PvG_O9SuqfjFRA_1776471217
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d1ceb2ddfso918644f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2026 17:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776471216; x=1777076016; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DLc6i5hTDljAXhin+tlCr4ec80GPJxXVTT+TZFT5DQo=;
        b=WOVudNmeQdiHGuOHdl2M7Xa3IZ9M1eXtEXlD841vpTKtyrmYzJhR3XTfdY+Qo7Vc4/
         5KzNyCBbnhhOtZjKzhMRK25MXSdyt3MBol3wcx2ERHOebxzpQdkGoqHDE+I14pOS15Mw
         XQAzP3ub3txcckAg6rnfY9TmL5Dn/7uWuoVKDTWzF0jd/W9p3fIBus3G7T9PrMh/gtNv
         SdQRlGz92Igj5KqRCH2cLrEij1J7ZNf/RH+QTgcXjs2i1Lq+AtnjRW/aJvqETSzt5n4r
         msW9N/OiBGDUiaIctYpEVgpAa9Y0V9QnGbty/wu9KcOfLm5n1ZpuUuwJkt7f4+RLm66g
         SCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776471216; x=1777076016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLc6i5hTDljAXhin+tlCr4ec80GPJxXVTT+TZFT5DQo=;
        b=n7wQAsxZCixqIAnNdT2u1Q/fYND4IwAsZ8tr2h2nz50p19uN3aurW9vlKCx7ukgvkB
         b3zgaYlwZKKAdUosPpxVyavu2Bt/1Y8WRKb1vY91LuwSQAOKC7KqqQQFgOxaWf5rwPEU
         wz9hnFqY3orbKtUJW2u+/E34J+WdoeHQT4bUicPHbSHBMLkTm9/41uBVCa60o9mB5pX/
         iJ9jXXpOl0c/bqg02WmM16tlLMiflvjpPMQBaCFlVDrjGznflfeynftQkQ0DgsfMF0PM
         d2PYPRrCeaLFdaiw408hPlQVb0VoO0ssS0UV9DTgY3c/4t7xfVcfDUjjRmmiAndbQuuK
         4Ydg==
X-Forwarded-Encrypted: i=1; AFNElJ9SPyHHjEOvHhBlkSUUhSTUwU8gpGvCnWPh43Y5G2y8vD4VLxipWyPSCES266afyMHn3YqyO2Eh8t4QWyU=@vger.kernel.org
X-Gm-Message-State: AOJu0YySokZd15vfzV7mPI2GQqASnvtZbOstbYYkdMXVnzQE0zysWG62
	PS97xk8KN8aZALYiFcS0NJqHcR9oY+/aPvGJVUo2Mw+Upu6g+MUuctW5R3g7hJlYJNIovyCkh+2
	W1rxkKlscPlLrBvE2JNmeOi0jQPGfO2BewnPkuO1m3e2eoiwn0+7wCzAQUKHN2esPjLx700H6fg
	==
X-Gm-Gg: AeBDieuhqyt11JwFwnPoRit7ZW7f9WP+Ed0rFBKdxDfe8iWUQN8YvZJ3TgWV8NcKCWY
	5fSykeEcpNO5pL2yPvr+Eo7O84u8EeK1MjqNTskq24BupGnT8Opoyu2nR+JveSZXmXu+wB0Wcdb
	lD2dUeDxP95zGvlOH+xnC9zo53YFUVZr6YnxaSmULXXziIsVgVHzCM3S4WLSQuhXUFihR+wRYRd
	gK5jMH9uUJSNk87NLJnhBuCvy0LbuRQK1z9rg8PTru7rPbA+WHcv0F+FLAVIJl+8NBpp7XY2GKz
	hQNuSHJ0vCa31Dmc87uTVCpTwq+tEeYmEHEWPQx/euvPBNjSZdjXZG+gVtrgRKYZN1i9FQ9pfYU
	nuyGhJUKn8DFPKoprQJJWUqvZgHafxm2KrZpbO0AUsc4W2ZRDjouLhw==
X-Received: by 2002:a5d:588f:0:b0:43d:2be:e54 with SMTP id ffacd0b85a97d-43fe3dfd4aemr7384205f8f.39.1776471216303;
        Fri, 17 Apr 2026 17:13:36 -0700 (PDT)
X-Received: by 2002:a5d:588f:0:b0:43d:2be:e54 with SMTP id ffacd0b85a97d-43fe3dfd4aemr7384180f8f.39.1776471215734;
        Fri, 17 Apr 2026 17:13:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb13a0sm8364547f8f.8.2026.04.17.17.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 17:13:34 -0700 (PDT)
Date: Fri, 17 Apr 2026 20:13:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev
Subject: Re: [PATCH] hwrng: virtio: reject invalid used.len from the device
Message-ID: <20260417201129-mutt-send-email-mst@kernel.org>
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418000020.1847122-1-michael.bommarito@gmail.com>

On Fri, Apr 17, 2026 at 08:00:20PM -0400, Michael Bommarito wrote:
> random_recv_done() stored the device-reported used.len directly into
> vi->data_avail without validating it against the posted buffer size
> sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32 or 64).  A
> malicious or buggy virtio-rng backend could set used.len beyond
> vi->data so that the subsequent copy_data() in virtio_read() issues
> memcpy() from vi->data + vi->data_idx past the end of the inline
> array, reading adjacent kmalloc-1k slab bytes into the hwrng core's
> buffer and from there into /dev/hwrng consumers and the kernel
> entropy pool.
> 
> Exploitable most clearly in threat models that do not trust the
> hypervisor (confidential-compute guests on SEV-SNP or TDX; vhost-user
> split backends).

Exploitable? I don't get it. How is reading this data into hwrng
a problem?


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
> hwrng_fillfn is a kernel thread that runs as soon as the device is
> probed; no guest userspace interaction is needed.
> 
> Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer overflow in USB transport layer"),
> which hardened usb9pfs_rx_complete against unchecked device-reported
> length in the USB 9p transport.
> 
> With the added len-vs-sizeof(vi->data) clamp in place the same
> harness boots cleanly: the driver logs "bogus used.len" once and
> subsequent reads wait for a honest response.
> 
> Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7
> ---
>  drivers/char/hw_random/virtio-rng.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 0ce02d7e5048..6cff480787ca 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -47,6 +47,18 @@ static void random_recv_done(struct virtqueue *vq)
>  	if (!virtqueue_get_buf(vi->vq, &len))
>  		return;
>  
> +	/*
> +	 * The device sets used.len; a malicious or buggy backend can
> +	 * report more bytes than we posted.  Clamp before it reaches
> +	 * copy_data() which indexes vi->data[].
> +	 */
> +	if (len > sizeof(vi->data)) {
> +		dev_err(&vq->vdev->dev,
> +			"bogus used.len %u > buffer size %zu\n",
> +			len, sizeof(vi->data));
> +		len = 0;
> +	}
> +
>  	smp_store_release(&vi->data_avail, len);
>  	complete(&vi->have_data);
>  }
> -- 
> 2.53.0

