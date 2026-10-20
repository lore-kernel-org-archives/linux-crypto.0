Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497659;
	b=KjnUJNLWQ+bE1LEkQnyo5JK1DktSB7sAD0Krsuk3CYPe4Ji8v5zfy2mrv4Wgc58yaG77
	 WnCX5GZagold8LkA8JJNcca4dwomEMRMZq4va7OQgeLpnLeIkEiO7IKdjkC/JE6BMUvvl
	 rGyEStq33MLlXyOgAvbrgeTAawtMRw/3aJnVqf7k3xgQxQ3bhVoiMkZI0AA8OCNKDFuSc
	 hzn8ds6ykJ9fqfNiITQBGo3xC/HdL5VJxua2uXA1T3DlupgCkf1k2ZpSLD0igVcvU3NW8
	 ipz845KUfZ54tiziVJArrOQokyG1Dwvy8/YwIFyngGujNgKAO+eYOIQzWRbmzGqmmMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497659;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=eFZVTyF20/Zx4HBaZT3lO0bzlutBA0qs6TPlDnVyFyY=;
	b=fuw9jtD+7y5PAGwkk+XBCFTFqBmjeD+RIiM9p/XIx2uQxD/9cKg8wePpcv6CeP8zmDxl
	 73icKuD7Yo98gBuE+XULpYX2ytcCCgEHe2iYdLmbCTtLKOLq869DZ2sP+7rW23hJhRNhk
	 F7kYoq/zu6d56k6lw5baaNaR7k5TJeQnVOqtDX6dFIltRvyZJFoDyzPFWp1yCHd1pStZw
	 ZXXKZ7pex7xuJglOXo8KGt1giORiCTJZEZY7Jbu32GLWVGrot0LfAbMaF0VfNLoI5ykia
	 7MFb5SDhbI+oWLh9HNAyFduYdY5fy28+RtnZY5flko0K9k29dJDUochW//+kOk8LAVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=lpQgG4gD;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7C8606A319;
	Tue, 20 Oct 2026 12:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A7C8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=lpQgG4gD
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4j89wb5pJ5zLmB0;
	Tue, 20 Oct 2026 14:00:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1792497647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFZVTyF20/Zx4HBaZT3lO0bzlutBA0qs6TPlDnVyFyY=;
	b=lpQgG4gDp/QVBZrN7bzzPbOIUMUd/0raix82VZ5dsf5pVSZ6zrZYHnEbyl2k+LeXyxYsM5
	QrCR1MdiYmCJeA/uRyYm0PWxxJIMBA06P7zq6aANLzyK/eI/BfNDweDAiIlnYiCV8e6wbq
	xMqAPvhjchlva8cp0f3976vHWhPWXUgaBURKlBAFGJT4+IVmOiPe5emUZPn7R7bKs9uOUJ
	4QKfxXuCBF4WwwTb/qkJOL7cjqVe5ByrJ8skgw6+uz4N+U64QuiuTvzzUHP3W9JRzbE6oO
	vOuCFI0HKCWMirQw0K4F9Zamyuac1HPPvfmdLWLXREjDNXPTMc1EnEIMpb7xjg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Tue, 20 Oct 2026 14:00:42 +0200
Message-ID: <20261020120042.359215-1-ralf@mandelbit.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <atHquk_AUj2Ys7Su@gondor.apana.org.au>
References: <atHquk_AUj2Ys7Su@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4j89wb5pJ5zLmB0

Hi Herbert,

On Fri, 16 Oct 2026 20:13:30 +1100, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Sep 15, 2026 at 01:32:12PM +0200, Ralf Lici wrote:
> >
> > @@ -748,8 +833,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
> >  			return -EINVAL;
> >  		}
> >  		if (sreq->nr_src > 0) {
> > -			src_mapped = dma_map_sg(priv->dev, src, sreq->nr_src,
> > -						DMA_BIDIRECTIONAL);
> > +			if (ctx->aead)
> > +				src_mapped =
> > +					safexcel_map_aead(priv->dev, src,
> > +							  sreq->nr_src,
> > +							  sreq->output_offset,
> > +							  sreq->output_len,
> > +							  true);
> > +			else
> > +				src_mapped = dma_map_sg(priv->dev, src,
> > +							sreq->nr_src,
> > +							DMA_BIDIRECTIONAL);
>
> This path doesn't actualy matter because BIDIRECTIONAL is safe
> even if you use it unnecessarily.
>
> > @@ -775,8 +869,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
> >  		}
> >  
> >  		if (sreq->nr_dst > 0) {
> > -			dst_mapped = dma_map_sg(priv->dev, dst, sreq->nr_dst,
> > -						DMA_FROM_DEVICE);
>
> So this is the really buggy path.  Why don't you just change it to
> BIDRECTIONAL, perhaps with a comment referring to the assoc data?
>

I tried that simplification on the MT7986 before respinning, but
unfortunately mapping the complete AEAD destination DMA_BIDIRECTIONAL
does not fix the corruption.

The relevant ovpn layout is physically:

    [ AAD ][ tag ][ payload ]

and is described to the AEAD implementation in logical order as:

    [ AAD ][ payload ][ tag ]

The entries do not overlap in bytes, but a small AAD entry and an
adjacent output entry can share a cache line. When mapped
DMA_BIDIRECTIONAL on this non-coherent system, the AAD entry is bounced.
After the accelerator has written the output to RAM, unmapping the AAD
copies its unchanged bytes back through the CPU. This dirties the CPU's
stale copy of the cache line corresponding to the memory where part of
the accelerator output now resides. Cache maintenance, while unmapping
the adjacent output entry, can then clean that line and overwrite the
output with stale pre-crypto bytes.

This also affects the in-place path. Although an in-place request uses
the same scatterlist as source and destination, its AAD entry remains
input-only. Mapping the whole list DMA_BIDIRECTIONAL therefore gives
that entry an unnecessary and harmful copyback.

So I don't think the source/in-place handling can be dropped on this
platform. I can add the physical/logical layout and the simplified A/B
result to the next cover letter to make the reason for the finer-grained
mapping clearer.

Thanks!

-- 
Ralf Lici
Mandelbit Srl
