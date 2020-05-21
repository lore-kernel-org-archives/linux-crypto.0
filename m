Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E69AC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 16:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 072892072C
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 16:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cw+7faZu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgEUQqs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgEUQqs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 12:46:48 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CF3C061A0E;
        Thu, 21 May 2020 09:46:47 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e18so8115344iog.9;
        Thu, 21 May 2020 09:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+BI4Y/IhEnafeGyBGSGjlcIw4R7Lmkc4NHcATOFMKjg=;
        b=cw+7faZuvs44ljIdu4Sd4sVIn5JbDCnF36z02Eq8tVn5ba9c27fu9BuUEpoZKURAYn
         ayxIZRh5e7ALCwx8DGtVPIPFlC9N/HWevCeXyVdRgsTRSFLbqgIRCOfKDP0KHX6sYX1o
         GrAFRPD9NkxNj4uR0mLLYV/2t4V5WCiyvMFIgLNXcWuaRV9ABmnNiO6RBRnAXuVafJc/
         FL1AnAtApSjn/RpDX2oeY7t1sYhArYn5Jh3cLfrGRZhIPFkfpbAL0LnTBp9VyUogYTHZ
         m0cIcVtLoGy05tuiOdBqtvXCI5a2/AtPCSpK/huiObhr+vxnqyHD/Sssy4BkIK5M3/Lu
         OIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+BI4Y/IhEnafeGyBGSGjlcIw4R7Lmkc4NHcATOFMKjg=;
        b=uN/JC0t6LnZXv7NbU/fBoPDhD8X4P9L+9gIb/LNaCrmY+ArNm7GYOK8EoKLUR6jgGJ
         Ah8/zb+uEAm5EBp4G1wcBTJyrM5bzDHpzrjvzB/j/EylPugY7GUEv9OiqyYL/2MYzyvg
         +KD1XH2WzwUGgmblzOPVC/O4ErcCc1oicgIWi5RO/M0vyTLJcq5Wls2rBd9mQnsoYzi9
         DL3OiBsR2GAut8NprQazM61DPp3+7uOelAkXx+U7MSTPRA2hqJ/qt9rfIXvJHQoGh4rs
         VQtcArfQ+uBw1bfuRtcjpciWseq4vAv7tyHt+d1HsShkdcCHhZ+UTvpJekP3ApKOov9n
         KxeQ==
X-Gm-Message-State: AOAM530uLN0L997NFjx1Vc5ePTgDCTx4tZePbuILiPCDTAAz/hTnun0C
        q2X+9acvMpr7SlhC7FJoCxau3zW2XUsKZnPYios=
X-Google-Smtp-Source: ABdhPJzuIjcvKCgULzND1O6hAerS0COAuiC8FxCpEWs7qHfEgK3AuCrlKRl3+xQxGIKehLx3/qDNb7lseA64oH2B8OI=
X-Received: by 2002:a5e:c817:: with SMTP id y23mr8451925iol.5.1590079607030;
 Thu, 21 May 2020 09:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200520182645.1658949-1-daniel.m.jordan@oracle.com>
 <20200520182645.1658949-6-daniel.m.jordan@oracle.com> <CAKgT0UfWOe-_rA+o5Uh-mTKSodsv9pFvApun=oYeAsOpMpP83Q@mail.gmail.com>
 <20200521153743.ymrwhgceazzc6ccb@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200521153743.ymrwhgceazzc6ccb@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 21 May 2020 09:46:35 -0700
Message-ID: <CAKgT0Uc_LNe+KuyYxFnQ44GAfygEOQNubxwzxmTDVBvFA=WZkA@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] mm: parallelize deferred_init_memmap()
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Robert Elliott <elliott@hpe.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 21, 2020 at 8:37 AM Daniel Jordan
<daniel.m.jordan@oracle.com> wrote:
>
> On Wed, May 20, 2020 at 06:29:32PM -0700, Alexander Duyck wrote:
> > On Wed, May 20, 2020 at 11:27 AM Daniel Jordan
> > > @@ -1814,16 +1815,44 @@ deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
> > >         return nr_pages;
> > >  }
> > >
> > > +struct definit_args {
> > > +       struct zone *zone;
> > > +       atomic_long_t nr_pages;
> > > +};
> > > +
> > > +static void __init
> > > +deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> > > +                          void *arg)
> > > +{
> > > +       unsigned long spfn, epfn, nr_pages = 0;
> > > +       struct definit_args *args = arg;
> > > +       struct zone *zone = args->zone;
> > > +       u64 i;
> > > +
> > > +       deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
> > > +
> > > +       /*
> > > +        * Initialize and free pages in MAX_ORDER sized increments so that we
> > > +        * can avoid introducing any issues with the buddy allocator.
> > > +        */
> > > +       while (spfn < end_pfn) {
> > > +               nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> > > +               cond_resched();
> > > +       }
> > > +
> > > +       atomic_long_add(nr_pages, &args->nr_pages);
> > > +}
> > > +
> >
> > Personally I would get rid of nr_pages entirely. It isn't worth the
> > cache thrash to have this atomic variable bouncing around.
>
> One of the things I tried to optimize was the managed_pages atomic adds in
> __free_pages_core, but performance stayed the same on the biggest machine I
> tested when it was done once at the end of page init instead of in every thread
> for every pageblock.
>
> I'm not sure this atomic would matter either, given it's less frequent.

It is more about not bothering with the extra tracking. We don't
really need it and having it doesn't really add much in the way of
value.

> > You could
> > probably just have this function return void since all nr_pages is
> > used for is a pr_info  statement at the end of the initialization
> > which will be completely useless now anyway since we really have the
> > threads running in parallel anyway.
>
> The timestamp is still useful for observability, page init is a significant
> part of kernel boot on big machines, over 10% sometimes with these patches.

Agreed.

> It's mostly the time that matters though, I agree the number of pages is less
> important and is probably worth removing just to simplify the code.  I'll do it
> if no one sees a reason to keep it.

Sounds good.

> > We only really need the nr_pages logic in deferred_grow_zone in order
> > to track if we have freed enough pages to allow us to go back to what
> > we were doing.
> >
> > > @@ -1863,11 +1892,32 @@ static int __init deferred_init_memmap(void *data)
> > >                 goto zone_empty;
> > >
> > >         /*
> > > -        * Initialize and free pages in MAX_ORDER sized increments so
> > > -        * that we can avoid introducing any issues with the buddy
> > > -        * allocator.
> > > +        * More CPUs always led to greater speedups on tested systems, up to
> > > +        * all the nodes' CPUs.  Use all since the system is otherwise idle now.
> > >          */
> > > +       max_threads = max(cpumask_weight(cpumask), 1u);
> > > +
> > >         while (spfn < epfn) {
> > > +               epfn_align = ALIGN_DOWN(epfn, PAGES_PER_SECTION);
> > > +
> > > +               if (IS_ALIGNED(spfn, PAGES_PER_SECTION) &&
> > > +                   epfn_align - spfn >= PAGES_PER_SECTION) {
> > > +                       struct definit_args arg = { zone, ATOMIC_LONG_INIT(0) };
> > > +                       struct padata_mt_job job = {
> > > +                               .thread_fn   = deferred_init_memmap_chunk,
> > > +                               .fn_arg      = &arg,
> > > +                               .start       = spfn,
> > > +                               .size        = epfn_align - spfn,
> > > +                               .align       = PAGES_PER_SECTION,
> > > +                               .min_chunk   = PAGES_PER_SECTION,
> > > +                               .max_threads = max_threads,
> > > +                       };
> > > +
> > > +                       padata_do_multithreaded(&job);
> > > +                       nr_pages += atomic_long_read(&arg.nr_pages);
> > > +                       spfn = epfn_align;
> > > +               }
> > > +
> > >                 nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> > >                 cond_resched();
> > >         }
> >
> > This doesn't look right. You are basically adding threads in addition
> > to calls to deferred_init_maxorder.
>
> The deferred_init_maxorder call is there to do the remaining, non-section
> aligned part of a range.  It doesn't have to be done this way.

It is also doing the advancing though isn't it?

> > In addition you are spawning one
> > job per section instead of per range.
>
> That's not what's happening, all the above is doing is aligning the end of the
> range down to a section.  Each thread is working on way more than a section at
> a time.

Yeah, now that I reread it I see that. For some reason I was thinking
you were aligning spfn, not epfn.

> > Really you should be going for
> > something more along the lines of:
> >
> >         while (spfn < epfn) {
> >                 unsigned long epfn_align = ALIGN(epfn,
> > PAGE_PER_SECTION);
> >                 struct definit_args arg = { zone, ATOMIC_LONG_INIT(0)
> > };
> >                 struct padata_mt_job job = {
> >                         .thread_fn   = deferred_init_memmap_chunk,
> >                         .fn_arg      = &arg,
> >                         .start       = spfn,
> >                         .size        = epfn_align - spfn,
> >                         .align       = PAGES_PER_SECTION,
> >                         .min_chunk   = PAGES_PER_SECTION,
> >                         .max_threads = max_threads,
> >                 };
> >
> >                 padata_do_multithreaded(&job);
> >
> >                 for_each_free_mem_pfn_range_in_zone_from(i, zone,
> > spfn, epfn) {
> >                         if (epfn_align <= spfn)
> >                                 break;
> >                 }
> >         }
>
> I can see what you're getting at even though I think this can leave ranges
> uninitialized.  Starting with range [a,b), b is aligned up to d and the inner
> loop skips [c,e).
>
> a    b  c d        e
> |         |         |   section boundaries
> [    )  [          )

I think I resolved this with the fix for it I described in the other
email. We just need to swap out spfn for epfn and make sure we align
spfn with epfn_align. Then I think that takes care of possible skips.

> We could use deferred_init_mem_pfn_range_in_zone() instead of the for_each
> loop.
>
> What I was trying to avoid by aligning down is creating a discontiguous pfn
> range that get passed to padata.  We already discussed how those are handled
> by the zone iterator in the thread function, but job->size can be exaggerated
> to include parts of the range that are never touched.  Thinking more about it
> though, it's a small fraction of the total work and shouldn't matter.

So the problem with aligning down is that you are going to be slowed
up as you have to go single threaded to initialize whatever remains.
So worst case scenario is that you have a section aligned block and
you will process all but 1 section in parallel, and then have to
process the remaining section one max order block at a time.

> > This should accomplish the same thing, but much more efficiently.
>
> Well, more cleanly.  I'll give it a try.

I agree I am not sure if it will make a big difference on x86, however
the more ranges you have to process the faster this approach should be
as it stays parallel the entire time rather than having to drop out
and process the last section one max order block at a time.

> > The
> > only thing you really lose is the tracking of nr_pages which really
> > doesn't add anything anyway since the value could shift around
> > depending on how many times deferred_grow_zone got called anyway.
> >
> > Also the spfn should already be sectioned aligned, or at least be in a
> > new section unrelated to the one we just scheduled, so there is no
> > need for the extra checks you had.
>
> I was doing it to be robust to future changes.  Otherwise epfn_align - spfn
> could be huge when aligning down, but with aligning up it won't matter and can
> be removed.

Right. So that was to catch the case where you could potentially align
down below spfn.
