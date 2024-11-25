Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE95188724
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 22:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732572569; cv=none; b=MgH+tqtRrZMPs8tBGApIXJ3tn1K0D+6Aqcci4Zn9JGWSwvy1PZ+WYNd9kXjVHj9nixAjzwSWUWTk4lh7lDZ8klm/PEj8wqJUxMMAKqrPadJ4DhA7ajTCy2iR5rCYgRJGC+WHAbRD/d7XHURpPEtzyBg8Oh9ZDE3Af+jLkTxF+aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732572569; c=relaxed/simple;
	bh=lUmPdpv3cWFE01UvO9BTTTKy/U67ChqHO/ofw2Pa6+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZMySd6uKnhTwTCEtvAqo82KrgdY09AMUBR+pMAh27vyFdVlopqRoFqWCIkb479kdsPumcsBiLmP7i0Mby1zfS6rtMNlg9ZEyT/peofAFrcbLEXgwDJpniTGVqrw/q+pUrMzlgbLzoLimINGw10TTdMhNG1wjz6HyRIW63vHq9zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W+FEHLr7; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W+FEHLr7"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6d846307673so15968676d6.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 14:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732572565; x=1733177365; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hkPFNXiSO82mQaladEsQkAF2R6GvjjxU5ay6NuI1SY0=;
        b=W+FEHLr7OflDaQCK2Xdh5fnunuAdVBjHfXzw5fQP1KRPCG8s0TMLeR1fKfoKAmohEO
         bTz3wsyuBypxwcQNApcrNK8fPI4XR6qNXJjCT2NOqecjNe8EGPjyx2XT7q3hqvlKKKuj
         zS2kE1ZFbeW6GZARwVpVUJLAkg8SGNBHI+lCBhrXBHNRV+j/Vzs14pgNtYOPqHgAn6f8
         +aEC70dxLiWlI3jckQmfuhjWZnOH8a18lBSxMZV36U4Cytvwlj9G+BdAMfPXSTyn+miv
         GtFoiNEOtxxxAESAtDjALa1990YKF1yL8Z1ZL7lcLuy157IkUDo7dftbovn+aEVDKySp
         vM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732572565; x=1733177365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hkPFNXiSO82mQaladEsQkAF2R6GvjjxU5ay6NuI1SY0=;
        b=QLTqtktYHOqaCw8JIQIBgVyOnsYs1NGnLVu1C66mGfIGoDYR12cmjhvG8zUAtBzsnB
         5Gwv9vAd81PwzWk9OrqfTLM5NiYpiNrHx3HQTRiLLysY/jNZArbIr1w8EmtjtiX/fZux
         3rdx62t6UfL77S3Zid2o000XdrGJk80s/trJV8OQvCLyWWIKCqgSpHWDGGVF3kgfMBLT
         1qcQ/ii5DJHvHZbit1tRbdRA9gRpU0BapT2FgMKtaWvNn2aTIzbSruA/qjUoNKibUMQj
         FOuWqhT36Wz9VB4bZmebnIKc+70nMe7MspJqcrWcvnVFpq0Tiqb0bQhyltPeq+clUNMn
         XC+A==
X-Forwarded-Encrypted: i=1; AJvYcCXs1ToB43YVIRXI3tp8MWjUoc2ybtNoLKINK6BWPlgX53w7t3IZucc0Z6XLUS6ew31GysmvSitG9wgpaBc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRvigIJvNiEFUmnLx92ZH78ouFn9jn9zdx9nk8vkYz7Y6mla2T
	yPgM8CHHdoEgnK7SuO1FhsyjBa5IPzCfpwn+HiyqNe0tF850O4CuY6RzBtq7erdORUCASqFGSad
	UttvNDhA2g2RIxLnEDhTdsnMkhDSnsYsZaEjz
X-Gm-Gg: ASbGncvwmqLhVAIvkaqvK2oWptfscWXQARjOFTORA4cCGbK1HmS5Au0BoNGweYb5WZa
	tStM8qNeTtJj5Vi/cdcm7Y+PxQAPbQe6s/KVO1iUGt73Vc3HB3u0TWX2IWkFpjw==
X-Google-Smtp-Source: AGHT+IGVQmYoBVpN5RvRdxpCzs9ETs2LPxJY2hxoPO9iI/z2/AoWXumN7ElMl7egPxBfuWUYtgJnTK4SOW0j/TC3aTc=
X-Received: by 2002:ad4:5d6c:0:b0:6d4:238e:35ba with SMTP id
 6a1803df08f44-6d450e87024mr275882526d6.21.1732572565331; Mon, 25 Nov 2024
 14:09:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-11-kanchana.p.sridhar@intel.com> <CAJD7tkb0WyLD3hxQ5fHWHogyW5g+eF+GrR15r0PjK9YbFO3szg@mail.gmail.com>
 <SJ0PR11MB56782CF74C6D6904DDDDAB95C92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB56782CF74C6D6904DDDDAB95C92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 25 Nov 2024 14:08:48 -0800
Message-ID: <CAJD7tkY3_pCBsFJ2-+NC5JrYnSGCxsusH81bdLL-fz=G3MwibQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in
 zswap_batch_store() of large folios.
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
> > > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > > Suggested-by: Yosry Ahmed <yosryahmed@google.com>
> >
> > This is definitely not what I suggested :)
> >
> > I won't speak for Johannes here but I suspect it's not quite what he
> > wanted either.
>
> Thanks for the comments Yosry. I was attributing these suggestions noted
> in the change log:
>
> 5) Incorporated Johannes' suggestion to not have a sysctl to enable
>    compress batching.
> 6) Incorporated Yosry's suggestion to allocate batching resources in the
>    cpu hotplug onlining code, since there is no longer a sysctl to control
>    batching. Thanks Yosry!
> 7) Incorporated Johannes' suggestions related to making the overall
>    sequence of events between zswap_store() and zswap_batch_store() similar
>    as much as possible for readability and control flow, better naming of
>    procedures, avoiding forward declarations, not inlining error path
>    procedures, deleting zswap internal details from zswap.h, etc. Thanks
>    Johannes, really appreciate the direction!
>    I have tried to explain the minimal future-proofing in terms of the
>    zswap_batch_store() signature and the definition of "struct
>    zswap_batch_store_sub_batch" in the comments for this struct. I hope the
>    new code explains the control flow a bit better.
>
> I will delete the "Suggested-by" in subsequent revs, not a problem.

I wasn't really arguing about the tag, but rather that this
implementation is not in the direction that we suggested.

FWIW, the way I usually handle "Suggested-by" is if the core idea of a
patch was suggested by someone. In this case, these are normal review
comments that you addressed, so I wouldn't add the tag. The only case
in which I add the tag in response to review comments is if they
resulted in a new patch that was the reviewer's idea.

Just my 2c, perhaps others do it differently.

[..]
> > > @@ -276,7 +276,21 @@ int swap_writepage(struct page *page, struct
> > writeback_control *wbc)
> > >                  */
> > >                 swap_zeromap_folio_clear(folio);
> > >         }
> > > -       if (zswap_store(folio)) {
> > > +
> > > +       if (folio_test_large(folio) && zswap_can_batch()) {
> > > +               struct folio_batch batch;
> > > +               int error = -1;
> > > +
> > > +               folio_batch_init(&batch);
> > > +               folio_batch_add(&batch, folio);
> > > +               zswap_batch_store(&batch, &error);
> > > +
> > > +               if (!error) {
> > > +                       count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
> > > +                       folio_unlock(folio);
> > > +                       return 0;
> > > +               }
> >
> > First of all, why does the code outside of zswap has to care or be changed?
> >
> > We should still call zswap_store() here, and within that figure out if
> > we can do batching or not. I am not sure what we gain by adding a
> > separate interface here, especially that we are creating a batch of a
> > single folio and passing it in anyway. I suspect that this leaked here
> > from the patch that batches unrelated folios swapout, but please don't
> > do that. This patch is about batching compression of pages in the same
> > folio, and for that, there is no need for the code here to do anything
> > differently or pass in a folio batch.
>
> This was the "minimal future proofing" and "error handling simplification/
> avoiding adding latency due to rewinds" rationale I alluded to in the
> change log and in the comments for "struct zswap_batch_store_sub_batch"
> respectively. This is what I was trying to articulate in terms of the benefits
> of the new signature of zswap_batch_store().
>
> The change in swap_writepage() was simply an illustration to show-case
> how the reclaim batching would work, to try and explain how IAA can
> significantly improve reclaim latency, not just zswap latency (and get
> suggestions early-on).
>
> I don't mind keeping swap_writepage() unchanged if the maintainers
> feel strongly about this. I guess I am eager to demonstrate the full potential
> of IAA, hence guilty of the minimal future-proofing.

While I do appreciate your eagerness, I will be completely honest
here. The change to batch reclaim of unrelated folios, while can be
reasonable, is an order of magnitude more controversial imo. By
tightly coupling this to this series, you are doing yourself a
disservice tbh. I would say drop any changes specific to that for now.
Leave that to a completely separate discussion. This is the easiest
way to make forward progress on this series, which I am sure is what
we all want here (and I do very much appreciate your work!).

[..]
> > I didn't look too closely at the code, but you are essentially
> > replicating the entire  zswap store code path and making it work with
> > batches. This is a maintenance nightmare, and the code could very
> > easily go out-of-sync.
> >
> > What we really need to do (and I suppose what Johannes meant, but
> > please correct me if I am wrong), is to make the existing flow work
> > with batches.
> >
> > For example, most of zswap_store() should remain the same. It is still
> > getting a folio to compress, the only difference is that we will
> > parallelize the page compressions. zswap_store_page() is where some
> > changes need to be made. Instead of a single function that handles the
> > storage of each page, we need a vectorized function that handles the
> > storage of N pages in a folio (allocate zswap_entry's, do xarray
> > insertions, etc). This should be refactoring in a separate patch.
> >
> > Once we have that, the logic introduced by this patch should really be
> > mostly limited to zswap_compress(), where the acomp interfacing would
> > be different based on whether batching is supported or not. This could
> > be changes in zswap_compress() itself, or maybe at this point we can
> > have a completely different path (e.g. zswap_compress_batch()). But
> > outside of that, I don't see why we should have a completely different
> > store path for the batching.
>
> You are absolutely right, and that is my eventual goal. I see no reason
> why zswap_batch_store() cannot morph into a vectorized implementation
> of zswap_store()/zswap_store_batch(). I just did not want to make a
> drastic change in v4.

I wouldn't send intermediate versions that are not the code you want
to be merged. It's not the best use of anyone's time to send code that
both of us agree is not what we want to merge anyway. Even if that
means a rewrite between versions, that's not uncommon as long as you
describe the changes in the changelog.

>
> As per earlier suggestions, I have tried to derive the same structure
> for zswap_batch_store() as is in place for zswap_store(), plus made some
> optimizations that can only benefit the current zswap_store(), such as
> minimizing the rewinding of state from must-have computes for a large
> folio such as allocating zswap_entries upfront. If zswap_batch_store()
> replaces zswap_store(), this would be an optimization over-and-above
> the existing zswap_store().
>
> For sure, it wouldn't make sense to maintain both versions.
>
> There are some minimal "future-proofing" details such as:
>
> 1) The folio_batch: This is the most contentious, I believe, because it
>      is aimed toward evolving the zswap_batch_store() interface for
>      reclaim batching, while allowing the folio-error association for the
>      partial benefits provided by (2). As mentioned earlier, I can delete this
>      in the next rev if the maintainers feel strongly about this.

Yeah I would drop this for now as I mentioned earlier.

> 2) int* error signature: benefit can be realized today due to the latency
>     optimization it enables from detecting errors early, localized cleanup,
>     preventing unwinding state. That said, the same benefits can be realized
>     without making it a part of the interface.

If this is a pure optimization that is not needed initially, I would
do it in a separate patch after this one. Even better if it's a follow
up patch, this is already dense enough :)

To summarize, I understand your eagerness to present all the work you
have in mind, and I appreciate it. But it's most effective to have
changes in independent digestible chunks wherever possible. For next
versions, I would only include the bare minimum to support the
compression batching and showcase its performance benefits. Extensions
and optimizations can be added on top once this lands. This makes both
your life and the reviewers' lives a lot easier, and ultimately gets
things merged faster.
