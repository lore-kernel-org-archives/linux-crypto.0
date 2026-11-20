Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173994;
	b=CYSKFEDb5sJ9Cj9Cm2/bgw5ytvOsKRx9QgSfQKy/fxdYtWnh5r+s5qDxDz4m7mQJq/3a
	 9RRFXob1ywkgQGeKhY38MP9+hzurbCl/sx6gH1SffB0ge2KTZuFPxdkGlYpG9xa0lkdky
	 Frxm0bwF9kLU44yeq8yKc1FMi+zae5EsCn4YRXM6pNI/T4i16FjRkKrs8Wfz+g3bXbe4d
	 wfAFx/iGYDK74Uq4l3y9xT7+g91O+ctx7Pc5mdgYV5V2MDcCTVZXBthkM83boaBwNOBVm
	 QihliFbbSszSyZaoi/An9/+xEs+5S6aqreVKEM7NlRirC7qQsn2HlbG0A9yYzPPjhgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173994;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c0vTB14/4H+8vfOMI5C25istiHS/+dTrhfXaA4w3yNM=;
	b=Vc3ralyKWH3v3kuVNWzBpgPYeP8d6459ds0aBsh61i89P9czCc8DvTB8T/7GkQmBvKFS
	 WOcnK4hHpgtoltX0LOVmncAqC792u5+n92HabiVspuGa87neJHExafmt5pjG/RTEbsXL4
	 h4GHf54rnWecxSXSexTd683Qv3nzJSToxHAudwIbOCZ8Dp+SJZo6Rymzl5hNKy4AGAvM/
	 2TPY3Y7KgCP0T4GeicIL2gJDiUTptCZpxpsl31d2p8mcurIcgGRVI2XOKu1vS9tmA62i3
	 IbFjOc3KXn0oObt5I0ZInbVWlH8yuvPW1L0A7mPiCpVfVBYLJ6LjSRnymzrLw09Wp2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ig0FoKyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8928606A320
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ig0FoKyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D6E1F000C4;
	Fri, 20 Nov 2026 11:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173994;
	bh=c0vTB14/4H+8vfOMI5C25istiHS/+dTrhfXaA4w3yNM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ig0FoKyu9ae7/iCJXtjI5X4zjVcGA91GjTdqd5+ix6cIzb5/fA3WO3SqXI6vAGasi
	 GE2JnfRoki6mjgUW8gZwCvK1M5AJp5DAhNxAUm0Wtgn0ZX/P7cIqxs73P0O5JOsOCz
	 RiGfB3CPCPhYGbzwE/9xpzRSG0gkOnbrgQt35gqW8y3ehGHts1YE1gMqPYkVo3s7Uf
	 1wf9oASYfd8vRQt4b4G9fnfhLedyiomHlq7NaXiu9KYG1hViWEmfA3iizek0b44/PG
	 2lJn2L7CIXl69O6ya3xNSIjdEoljv4M/ple2Jp8FmWurCGpokT8x3l92NoBbIgWV8q
	 TCDF8sbOwJ/FQ==
Message-ID: <sashiko-outbox-225037@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/2] crypto: caam - Use bounce buffer for unaligned
 RSA destination buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changwei Zou" <changwei.zou@canonical.com>, herbert@gondor.apana.org.au, sahil.malhotra@nxp.com
Cc: davem@davemloft.net, horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, jeffbarnes@linux.microsoft.com, stephane.debusne@cynove.com, iuliana.prodan@nxp.com, "Martin
 Kepplinger-Novakovic" <Martin.Kepplinger-Novakovic@ginzinger.com>, lukas@wunner.de, sahil.malhotra@oss.nxp.com, linux-crypto@vger.kernel.org
In-Reply-To: <20261120110525.1170175-3-changwei.zou@canonical.com>
References: <20261120110525.1170175-1-changwei.zou@canonical.com>
 <20261120110525.1170175-3-changwei.zou@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 11:26:33 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] crypto: caam - missing Fixes trailer for unaligned RSA
  destination fix
--

commit 9904aef7526cc6f78c558230d818097bb074e798
Author: Changwei Zou <changwei.zou@canonical.com>

> crypto: caam - Use bounce buffer for unaligned RSA destination buffers
>
> The rsa-caam driver directly DMA-maps the destination buffer supplied by
> the caller via req->dst without checking whether it meets the cacheline
> alignment requirements of DMA-incoherent hardware such as i.MX8.
>
> On CPUs with non-coherent DMA caches, if the destination buffer shares a
> cacheline with other data (i.e. it is not cacheline-aligned), cache
> writeback/invalidation during DMA can corrupt adjacent memory or cause
> stale data to be read back. This manifests as intermittent -EKEYREJECTED
> errors when loading signed kernel modules.
>
> Such a destination is produced in the module-signature verification path
> by rsassa_pkcs1_verify() (and crypto_akcipher_sync_prep()), which place
> the I/O buffer right after the request context in a single kmalloc()
> allocation; the buffer therefore starts at an offset into a larger
> allocation and shares a cacheline with that context. The DMA API does not
> cover this: on CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC systems
> dma_kmalloc_needs_bounce() only considers the buffer size, not its offset,
> so a buffer that is size-wise DMA-safe but starts at a non-cacheline-
> aligned offset is not bounced. The driver must detect and bounce it.
>
> When any segment of req->dst is not cacheline-aligned in either its start
> offset or length, allocate a single contiguous aligned bounce buffer
> (dst_len rounded up to a cacheline multiple) and run the operation on it
> via req_ctx->fixup_dst, leaving the caller's req->dst untouched. The RSA
> output (key->n_sz bytes) is copied back to req->dst once the hardware has
> completed successfully.
>
> Introduce a helper sg_is_dma_aligned() that checks both sg->offset and
> sg->length for cacheline alignment. Checking sg->offset suffices for
> the start address since physical pages are always page-aligned and
> PAGE_SIZE is a multiple of dma_get_cache_alignment(). sg->length is
> also checked to ensure the buffer end does not share a cacheline with
> adjacent memory.
>
> The bounce scatterlist is described with the aligned allocation size, not
> the possibly-unaligned dst_len, so that dma_map_sg() does not re-bounce or
> reject it on CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC systems.
>
> The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
> can be triggered when loading signed kernel modules:
>
>     for i in $(seq 1 100); do
>         sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
>         && sudo rmmod xfs || echo "FAILED on attempt $i"
>     done
>
> Reported-by: Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@gin=
zinger.com>
> Closes: https://lore.kernel.org/r/6029acc0f0ddfe25e2537c2866d54fd7f54bc18=
2.camel@ginzinger.com
> Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
> Tested-by: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzi=
nger.com>
> Tested-by: Stephane Debusne <stephane.debusne@cynove.com>
> Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>

[Severity: Low]
This fixes a bug where rsa_edesc_alloc() DMA-mapped unaligned req->dst
buffers without bouncing them.  Should this include:

  Fixes: 8c419778ab57 ("crypto: caam - add support for RSA algorithm")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120110525.1170=
175-1-changwei.zou@canonical.com?part=3D2
