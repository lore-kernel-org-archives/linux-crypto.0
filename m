Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D3423177
	for <linux-crypto@vger.kernel.org>; Wed,  4 Feb 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770228639; cv=none; b=Dm97cR78i5cAGDJ7AYsnWBozm+NWCJO1uxxy99dHHYyLDjkNTDrPeoN/uOupVcLXD1om1s7j8bE2J5RAZmyoL+nEsbYwhDif2NAj9whYkrpHxcIcHraS2DXFF80CK/w79PrL4Q5DvBaBSzDRjha0fironeV9Qo3AQPQybGQzZDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770228639; c=relaxed/simple;
	bh=/KpJEGMn2AmDgHb08+wpQnjGwQdN3/xNspEm+5b9U2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bckbmmF4dyPnfDGqPG0PV/AgmI5lrbJX+7pNVvsrsAXxOkp6zC6paHiwlAQ7gI+PxAYdLeugpAF1Cr1f0CmOvELa5F0fYXrkEnPDNhxoVZBSFnE5qqUYXRCjDx4Nu1se+4FgeDdON/kUHKierddwgCM55aEl9d8QnK5TRQDTufM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ts6WVzg5; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ts6WVzg5"
Date: Wed, 4 Feb 2026 18:10:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770228626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s+9Ex6m35FJGBhaP+VFOv6lmRGp/pb8Fu0SpZi9M1j4=;
	b=Ts6WVzg5dL7EdUrUvy14pppIoCPBnKPIGZ5LzbHrUdbmdChWkgnNc/axaomSUN5fPCWuP6
	iqPNF10sW+x4RqcHmBHdyDgPOCvmBYN8cnu+E8hV84klRiYxxEXCtu2ZN9ZDQ56xjUc/xO
	ptlQ8CCqC/ocdNrwr/TjpE9L9E7IzYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com, 
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org, senozhatsky@chromium.org, 
	sj@kernel.org, kasong@tencent.com, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Message-ID: <lfb3wm5mmxyjbsiw4i2mgyoot7o64645unmoufloyyeuk3qkqv@rkerijymxnaw>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
 <CAKEwX=ONeMBRwr+4mJt76+zWZ4dXL+LCEAMELYeT6Nx-hej2-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=ONeMBRwr+4mJt76+zWZ4dXL+LCEAMELYeT6Nx-hej2-g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 03, 2026 at 04:30:48PM -0800, Nhat Pham wrote:
[..]
 > @@ -900,84 +923,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >         return ret;
> >  }
> >
> > -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> > -                          struct zswap_pool *pool, bool wb_enabled)
> > +/*
> > + * zswap_compress() batching implementation for sequential and batching
> > + * compressors.
> > + *
> > + * Description:
> > + * ============
> > + *
> > + * Compress multiple @nr_pages in @folio starting from the @folio_start index in
> > + * batches of @nr_batch_pages.
> > + *
> > + * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
> > + * sure of this by design and zswap_store_pages() warns if this is not true.
> > + *
> > + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
> > + * support batching.
> > + *
> > + * If @nr_batch_pages is 1, each page is processed sequentially.
> > + *
> > + * If @nr_batch_pages is > 1, compression batching is invoked within
> > + * the algorithm's driver, except if @nr_pages is 1: if so, the driver can
> > + * choose to call it's sequential/non-batching compress routine.
> 
> Hmm, I'm a bit confused by this documentation.
> 
> Why is there extra explanation about nr_batch_pages > 1 and nr_pages
> == 1? That cannot happen, no?
> 
> nr_batch_pages is already determined by the time we enter
> zswap_compress() (the computation is done at its callsite, and already
> takes into account nr_pages, since it is the min of nr_pages, and the
> compressor batch size).
> 
> I find this batching (for store), then sub-batching (for compression),
> confusing, even if I understand it's to maintain/improve performance
> for the software compressors... It makes indices in zswap_compress()
> very convoluted.
> 
> Yosry and Johannes - any thoughts on this?

Yeah, not a big fan either. I am really wondering if the perf hit is
real enough to justify this. I would much rather we use the same batch
size for both.

IIUC the problem is that we cannot use the crypto batching interface for
SW compressors as it requires compressor support, and we cannot avoid
batching altogether for SW compressors because they regress.

I wonder if we can add support in the crypto layer to handle batching
for SW compressors without compressor support (just loop on the batch
and compress one-by-one)?

Alternatively, I did suggest we at least introduce an intermediate
function to do the sub-batching to simplify zswap_compress() (e.g.
zswap_compress() and __zswap_compress()).  I think this also caused
regressions but I wonder if we can force inline it or sth.

The current design is really confusing.
