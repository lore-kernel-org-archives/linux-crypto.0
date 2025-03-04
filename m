Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3875156C76
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 20:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741121277; cv=none; b=U3vMmngaXjNdSpPpRTf4nFZ5ahSWlqHqaWGI4lVgkHHmLxD2wxKt6JIgzVb1+BKqNWzGfEgiXyBt22A4cyERkhuhZ9If+tN2ktk09n0UJXuCkupJy4MFi8CA1W8zQW/1EKctr73a4ag4tcl68CevOBF4ugymD9X3JAygtAMJLhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741121277; c=relaxed/simple;
	bh=vsML5xaPJVkGrYNxS8NCDzDtPJIUeJ695/4RtufH1HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgnQAUNn5Q2aDWfLOQrx1NJvJYJMF3740V6Ct5oNyDi1i5a8QVvSnAJqDbgO62WqLCD+Z+FEfPloUQ6TVV7ew5rFOX4wx4U40M/mzGxf/58l1PgEZww/N2Fy0lVNyD18eAQbevHUAHdQGgDO2FCl7HZUEQM0bR9OWF9Iek1r7DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JKqWnzP+; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JKqWnzP+"
Date: Tue, 4 Mar 2025 20:47:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741121272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X99rcIZ7WjEg9GvuSuB4QRdl5cFkDXpH18r5TwlZpiI=;
	b=JKqWnzP+aoryMF1BdHdqg8rEOeYkf/q8iqJpFnKHXcvvxlIo4AsavhnHRdmJO+NK4SPbQ5
	dBGzilvuBEpMFuBvoVG7f8dRhN1nLmqP4BxGRtinoUMoy5ueLZn126otQrN02t7hkF/b7g
	cY8iN7vFP+0G1Bgz1irKhMYBcsekGrk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8dm9HF9tm0sDfpt@google.com>
References: <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 04, 2025 at 10:19:51PM +0900, Sergey Senozhatsky wrote:
> On (25/03/04 14:10), Herbert Xu wrote:
> > +static void zs_map_object_sg(struct zs_pool *pool, unsigned long handle,
> > +			     enum zs_mapmode mm, struct scatterlist sg[2])
> > +{
> [..]
> > +	sg_init_table(sg, 2);
> > +	sg_set_page(sg, zpdesc_page(zpdescs[0]),
> > +		    PAGE_SIZE - off - handle_size, off + handle_size);
> > +	sg_set_page(&sg[1], zpdesc_page(zpdescs[1]),
> > +		    class->size - (PAGE_SIZE - off - handle_size), 0);
> > +}
> > +
> > +static void zs_unmap_object_sg(struct zs_pool *pool, unsigned long handle)
> > +{
> > +	struct zspage *zspage;
> > +	struct zpdesc *zpdesc;
> > +	unsigned int obj_idx;
> > +	unsigned long obj;
> > +
> > +	obj = handle_to_obj(handle);
> > +	obj_to_location(obj, &zpdesc, &obj_idx);
> > +	zspage = get_zspage(zpdesc);
> > +	migrate_read_unlock(zspage);
> > +}
> 
> One thing to notice is that these functions don't actually map/unmap.
> 
> And the handling is spread out over different parts of the stack,
> sg list is set in zsmalloc, but the actual zsmalloc map local page is
> done in crypto, and then zswap does memcpy() to write to object and so
> on.  The "new" zsmalloc map API, which we plan on landing soon, handles
> most of the things within zsmalloc.  Would it be possible to do something
> similar with the sg API?

Yeah I have the same feeling that the handling is all over the place.
Also, we don't want to introduce new map APIs, so anything we do for
zswap should ideally work for zram.

We need to agree on the APIs between zsmalloc <-> zswap/zcomp <->
crypto.

In the compression path, zswap currently passes in the page to the
crypto API to get it compressed, and then allocates an object in
zsmalloc and memcpy() the compressed page to it. Then, zsmalloc may
internally memcpy() again.

These two copies should become one once zswap starts using
zs_obj_write(), and I think this is the bare minimum because we cannot
allocate the object before we are done with the compression, so we need
at least one copy.

In the decompression path, zswap gets the compressed object from
zsmalloc, which will memcpy() to a buffer if it spans two pages. Zswap
will memcpy() again if needed (highmem / not sleepable). Then we pass
it to the crypto API. I am not sure if we do extra copies internally,
but probably not.

The not sleepable case will disappear with the new zsmalloc API as well,
so the only copy in the zswap code will be if we use highmem. This goes
away if the crypto API can deal with highmem addresses, or if we use
kmap_to_page() in the zswap code.

IIUC, what Herbert is suggesting is that we rework all of this to use SG
lists to reduce copies, but I am not sure which copies can go away? We
have one copy in the compression path that probably cannot go away.
After the zsmalloc changes (and ignoring highmem), we have one copy in
the decompression path for when objects span two pages. I think this
will still happen with SG lists, except internally in the crypto API.

So I am not sure what is the advantage of using SG lists here? The only
improvement that we can make is to eliminate the copy in the highmem
case, but I think we don't really need SG lists for this.

Am I missing something?
