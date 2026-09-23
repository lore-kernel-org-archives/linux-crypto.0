Received: from mout-b-107.mailbox.org (mout-b-107.mailbox.org [195.10.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C0344F57E;
	Wed, 23 Sep 2026 07:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.10.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148903; cv=none; b=sI12kuvIhFGxRhXhSbolFoYDbVBI2g0FgauX5HHrCYkYW+2iou4IxT1PWp0yYd6VukeIAr+0OATlzn+8vRneIRIpUuzYIi331AOYyiJAwy+fqtlxj37JhLsMhC+LXj6B1RRwRvHocmYZYWep4qpSJLWguYoChKZOcxy4AF4owmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148903; c=relaxed/simple;
	bh=k50KGPGFkD/+zhfKGx4TvDohZoIvh3Oi+UUfRz+lEXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg8yJJV783oFgThEJfqr0ctCo7Oxpo0lHUHOS4C7oSYy6D51iEaMBMYyq6qmfZmCbLWbLtGJrD8QbMB5P6cQPLlZoyg32tJGBiJznMZPuLHTKsUNtMTxzzNyFOODObE9Nkg7vXBtalZ+m3XNl33S4YxtgP94vaIMMTOM17z7Me8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=nb7vGeFJ; arc=none smtp.client-ip=195.10.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="nb7vGeFJ"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-107.mailbox.org (Postfix) with ESMTPS id 4hqT736LZgz3yGG;
	Wed, 23 Sep 2026 09:26:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1790148415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ZAvX7lKeS+iD/aIh19Vk7XMq9lmYzDDGnXDfgfROII=;
	b=nb7vGeFJSQRAO8X1sP/EoQMs6m/5MCRjseAcc5AQaXTG4m7RcQcYaag1Z5wWJ4Q5HO3b4R
	JUoPtyS6GGS9B7he0zJVmbHuJCdQG6+mxxtXZU83bxIzAoDXUwEPJqIVisP8wEpS02Z2Eh
	sD1rSGV+5vJPZ9UgyEo5OVRFEAmS2K+ZDBucORkXFz99HGPLk6asMsdwwzD1KBVSsjOZy9
	SBI/Cm7Zhkra888uQr7E2GkrWHm/oPH2JeM3Tzlo32eBuqDu9y5Lj9dWVBQFe/4SNs7nb/
	CHtIHG9v9f/fgSQYEN8hmtx26oWz7u0zSccMzhMPHkxrM01LxyqTr5eEQYiM3A==
From: Ralf Lici <ralf@mandelbit.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Wed, 23 Sep 2026 09:26:46 +0200
Message-ID: <20260923072646.86229-1-ralf@mandelbit.com>
In-Reply-To: <arNj5SOwXf_TV6eK@gondor.apana.org.au>
References: <arNj5SOwXf_TV6eK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

On Wed, 23 Sep 2026 15:30:13 +1000, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Sep 15, 2026 at 01:32:12PM +0200, Ralf Lici wrote:
> >
> > +static int safexcel_map_aead(struct device *dev, struct scatterlist *sgl,
> > +			     int nents, unsigned int output_offset,
> > +			     unsigned int output_len, bool inplace)
> > +{
> > +	struct scatterlist *sg;
> > +	unsigned int offset = 0;
> > +	int i;
> > +
> > +	for_each_sg(sgl, sg, nents, i) {
> > +		enum dma_data_direction dir;
> > +
> > +		dir = safexcel_aead_dma_dir(offset, sg->length, output_offset,
> > +					    output_len, inplace);
> > +		sg_dma_address(sg) = dma_map_page(dev, sg_page(sg), sg->offset,
> > +						  sg->length, dir);
> > +		if (dma_mapping_error(dev, sg_dma_address(sg)))
> > +			goto err_unmap;
> > +		sg_dma_len(sg) = sg->length;
> > +		offset += sg->length;
> > +	}
> > +
> > +	return nents;
> > +
> > +err_unmap:
> > +	safexcel_unmap_aead(dev, sgl, i, output_offset, output_len, inplace);
> > +	return 0;
> > +}
>
> Is this assuming that the SG list actually contains one entry for
> each type of data? What if the input is completely linear, i.e.,
> the AD, cipher and tag are all described by a single SG entry?
>
> In IPsec this is often the case.
>

No, the regions do not need to occupy separate sg entries, the patch
selects the direction conservatively for the whole entry.

For a completely linear in-place request, the entry overlaps the output
range and is therefore mapped DMA_BIDIRECTIONAL. For an out-of-place
request, the source is mapped DMA_TO_DEVICE. For example, a single
destination entry covering:

    [ AAD | ciphertext | tag ]

has a logical output range covering only:

          [ ciphertext | tag ]

Since the entry also contains the preserved AAD prefix, it is classified
as mixed and mapped DMA_BIDIRECTIONAL. The same applies if an entry
extends beyond the end of the output range.

Only entries wholly outside the output range use DMA_TO_DEVICE, while
only entries wholly contained within an out-of-place output range use
DMA_FROM_DEVICE.

-- 
Ralf Lici
Mandelbit Srl
