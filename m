Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1950919DF41
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jan 2025 04:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736310189; cv=none; b=bWqB6zaD8mWesoBO17ssP4xi28g0884knfo6wpH1sNklFfYsp/DwjgtRHEx53yu6vZezE6FB+UpuvLnP7PiP3axvnT2ISWl9njyPpxp8ix9iK4zOx4UR8HNfTxXlgnw9H8ZgKZWNY2Xa1dbAg5lI6y0P0Whyh7TqdOWtL63Hhd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736310189; c=relaxed/simple;
	bh=/5i5hnmoOFLW4Y3LRZxMa9xXtGZM3tJfjJg8lSP+8Lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUTU5Lvnm3Rg3TzmYa2vtF9nJIp3zr4sunwiQA7XboO8tHxkEPyDBkLwquaLgpKGVLYu7YIpf+tO3bjrU0KpACGg9Jh1Rcr8fn2UNvo0+xqURFeSGZ7nUUvkmkNEpf/p9UG95nIxM774AZ4fi/l+TkA0cPHI94muw5kZeaR4st0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eUUGZGuv; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eUUGZGuv"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4679eacf2c5so153811531cf.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jan 2025 20:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736310186; x=1736914986; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dGPpQ6VJIV9xnsCD1bMq8dKJH1L2LIGUbC/YN69ZewQ=;
        b=eUUGZGuvYZaZNRD6r1HPUQnK/vKwor4FyajafYbKXgG2Kq70HXFyr0mmc0ifKOruyb
         q6f+BmaChOk2xLXloUWZyLG0J81KMgBik85XZjyYJcl9+fQEWZdbUUe0GyKoF+w19Lpz
         5+fhVqHEynPOHI22cSfGAtjT+g1sI8mvEhrHcktnga65Bc409Q3WiQrlJtzwpRpEY7Fe
         ZC9ck0mhnPGE0KEyE0JXRaYPhDXMSmEH/Rm8ZfXKMPpIrKPhp3YFQmlqs9s6dFOwgwCs
         akx3wuof/B1a2iVD7LhgGy8N0kiT8obWZBwzDjyZAeF/RpxpvRiEebew9xRTA+NQ9wLc
         U85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736310186; x=1736914986;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dGPpQ6VJIV9xnsCD1bMq8dKJH1L2LIGUbC/YN69ZewQ=;
        b=v3QRTKAMv4bkP+/DOIy5hUkOx/lVGi7HE3SmZVvW+KSKi2SCoS/ZY9DS2J1jeGLexS
         JDZHyZlxyrEXSq4FbAVnRPRmP4NVP6sC/iGZIxAVZV3i65Jxee4oPoHjkaXuCXBOOznR
         iXnL8lcstyC7PFVTPjATrhLNfnmM1ygN0S8ukFyVT1BCAQvsmvg5jxFglzqFMbuTpuW0
         Qb2MqQdYt8ohNc3Q4eyw6i/EGKl5pE4MC/OK5dOdWlddTsMmZt599Tww9wQNnWi3ShKy
         n1tvR/nR4cQlUhjZ9Bl6E1exzNXQbFRvy23ZnY1baeXnOqAeT+FZy4oFFRvfkm44q4k8
         gbUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1QmXgt8AMOglS34rdIqXiuaRFsJAUoqym9Zynf66o9M8d565kHDKIFlHlZu25taa6wCy4fldvNAoOQk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhjLvo/5Xma47rM3E1v6SSYeOnb4/lRnc3Yv3H8lf50lHNi4HQ
	qeN8dRGllp2H4UDdWNKKXrJ1QI+tjd1mqPGtVnAT16OQksD9IO+KK1bKynAA9JqvW1Jm8ps49OI
	WrdXGO+Crcik+k9OC6OzGREdUrg39egzpM8t+
X-Gm-Gg: ASbGncs7O1VnXqwPlN3jaMZXFIX3nqNzDf2G5homezfw5snfQCaELqS/8qzQISFs6jb
	zrQPUIJVSFOODsbI4AvZ1/Gt8S4PbFObCzho=
X-Google-Smtp-Source: AGHT+IFJk+LnjgzfAgjKMHkGNMZINBuze+9KKgJnWmwTidN5rr18hYT2maqgMy22Lp3yaIP9FHYwKKIkEhmdmvdMiN0=
X-Received: by 2002:a05:6214:2263:b0:6d8:871d:49f1 with SMTP id
 6a1803df08f44-6df9b2d875amr26384756d6.44.1736310185822; Tue, 07 Jan 2025
 20:23:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-12-kanchana.p.sridhar@intel.com> <CAJD7tkYFcxtvD7GEQa3mDzKWURfseVsLvFh6m5yN36B8hefctg@mail.gmail.com>
 <SJ0PR11MB56786A69A03DD1E5780D3347C9122@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB56786A69A03DD1E5780D3347C9122@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 7 Jan 2025 20:22:29 -0800
X-Gm-Features: AbW1kvahJqqOC4RLQWaNTlCxRD-xLkUmXDWJfgFp5dXM9_qBnCBSg5cYKQkB1W4
Message-ID: <CAJD7tkbF6D4d2kLvXv3-Tgq=LE5i3O2mXZc5qBvPS9wToFV2rQ@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] mm: zswap: Restructure & simplify zswap_store()
 to make it amenable for batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"

[..]
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 99cd78891fd0..1be0f1807bfc 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -1467,77 +1467,129 @@ static void shrink_worker(struct work_struct
> > *w)
> > >  * main API
> > >  **********************************/
> > >
> > > -static ssize_t zswap_store_page(struct page *page,
> > > -                               struct obj_cgroup *objcg,
> > > -                               struct zswap_pool *pool)
> > > +static bool zswap_compress_folio(struct folio *folio,
> > > +                                struct zswap_entry *entries[],
> > > +                                struct zswap_pool *pool)
> > >  {
> > > -       swp_entry_t page_swpentry = page_swap_entry(page);
> > > -       struct zswap_entry *entry, *old;
> > > +       long index, nr_pages = folio_nr_pages(folio);
> > >
> > > -       /* allocate entry */
> > > -       entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > > -       if (!entry) {
> > > -               zswap_reject_kmemcache_fail++;
> > > -               return -EINVAL;
> > > +       for (index = 0; index < nr_pages; ++index) {
> > > +               struct page *page = folio_page(folio, index);
> > > +
> > > +               if (!zswap_compress(page, entries[index], pool))
> > > +                       return false;
> > >         }
> > >
> > > -       if (!zswap_compress(page, entry, pool))
> > > -               goto compress_failed;
> > > +       return true;
> > > +}
> > >
> > > -       old = xa_store(swap_zswap_tree(page_swpentry),
> > > -                      swp_offset(page_swpentry),
> > > -                      entry, GFP_KERNEL);
> > > -       if (xa_is_err(old)) {
> > > -               int err = xa_err(old);
> > > +/*
> > > + * Store all pages in a folio.
> > > + *
> > > + * The error handling from all failure points is consolidated to the
> > > + * "store_folio_failed" label, based on the initialization of the zswap
> > entries'
> > > + * handles to ERR_PTR(-EINVAL) at allocation time, and the fact that the
> > > + * entry's handle is subsequently modified only upon a successful
> > zpool_malloc()
> > > + * after the page is compressed.
> > > + */
> > > +static ssize_t zswap_store_folio(struct folio *folio,
> > > +                                struct obj_cgroup *objcg,
> > > +                                struct zswap_pool *pool)
> > > +{
> > > +       long index, nr_pages = folio_nr_pages(folio);
> > > +       struct zswap_entry **entries = NULL;
> > > +       int node_id = folio_nid(folio);
> > > +       size_t compressed_bytes = 0;
> > >
> > > -               WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n",
> > err);
> > > -               zswap_reject_alloc_fail++;
> > > -               goto store_failed;
> > > +       entries = kmalloc(nr_pages * sizeof(*entries), GFP_KERNEL);
> >
> > We can probably use kcalloc() here.
>
> I am a little worried about the latency penalty of kcalloc() in the reclaim path,
> especially since I am not relying on zero-initialized memory for "entries"..

Hmm good point, for a 2M THP we could be allocating an entire page here.

[..]
> > > @@ -1549,8 +1601,8 @@ bool zswap_store(struct folio *folio)
> > >         struct mem_cgroup *memcg = NULL;
> > >         struct zswap_pool *pool;
> > >         size_t compressed_bytes = 0;
> > > +       ssize_t bytes;
> > >         bool ret = false;
> > > -       long index;
> > >
> > >         VM_WARN_ON_ONCE(!folio_test_locked(folio));
> > >         VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> > > @@ -1584,15 +1636,11 @@ bool zswap_store(struct folio *folio)
> > >                 mem_cgroup_put(memcg);
> > >         }
> > >
> > > -       for (index = 0; index < nr_pages; ++index) {
> > > -               struct page *page = folio_page(folio, index);
> > > -               ssize_t bytes;
> > > +       bytes = zswap_store_folio(folio, objcg, pool);
> > > +       if (bytes < 0)
> > > +               goto put_pool;
> > >
> > > -               bytes = zswap_store_page(page, objcg, pool);
> > > -               if (bytes < 0)
> > > -                       goto put_pool;
> > > -               compressed_bytes += bytes;
> > > -       }
> > > +       compressed_bytes = bytes;
> >
> > What's the point of having both compressed_bytes and bytes now?
>
> The main reason was to cleanly handle a negative error value returned in "bytes"
> (declared as ssize_t), as against a true total "compressed_bytes" (declared as size_t)
> for the folio to use for objcg charging. This is similar to the current mainline
> code where zswap_store() calls zswap_store_page(). I was hoping to avoid potential
> issues with overflow/underflow, and for maintainability. Let me know if this is Ok.

It makes sense in the current mainline because we store the return
value of each call to zswap_store_page() in 'bytes', then check if
it's an error value, then add it to 'compressed_bytes'. Now we have a
single call to zswap_store_folio() and a single return value. AFAICT,
there is currently no benefit to storing it in 'bytes', checking it,
then moving it to 'compressed_bytes'. The compiler will probably
optimize the variable away anyway, but it looks weird.
