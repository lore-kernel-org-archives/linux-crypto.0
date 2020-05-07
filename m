Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A91C38A2A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 21:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D3AE206B9
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 21:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5Fue3Ni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgEGVSz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 May 2020 17:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgEGVSy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 May 2020 17:18:54 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D55C05BD43;
        Thu,  7 May 2020 14:18:54 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u11so7834730iow.4;
        Thu, 07 May 2020 14:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udO4Sb82iCWsNZhiezA2rH8QwvtS7hZNZpECyrxMEYE=;
        b=E5Fue3NiV2Sa0bwhkKtkBZ9EYlKC7jO2UA/TxR0Zzp55rChM4VBoqpN3G3WNwgvOK4
         Etth1kwTOdArqEbbDidyJc6e4L7QCUEp0Q2nP31E5RJshu3IFOnSVDISfhHq6usDA85Q
         P7T0zdeP3tvJ6r+kG6GJo1q0h5z5hAXjMndAfupyJpca65jhqbplqqzmdDBgC/0LagZD
         NnUSSYasRKbYA7z+5OSCaO3A6vMBdwxdG4GD+tu3DGRBlGCm+fyM7EKFjJFKlixGQ+AP
         QAMhRFhTJ8be3yscgEezwnbI41F8Hiytde7gIur6AV8MyEgHiQzUU48KZV3U9+wC9sgb
         51Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udO4Sb82iCWsNZhiezA2rH8QwvtS7hZNZpECyrxMEYE=;
        b=jjBwiK6TUkLcdYdwxFBlh7iHSigCnvjv9/JHUalIBRG1TgMWL5DANbFxQSyo44kwVw
         yJnSPrWNqz49ix9YbvTcj6KFvKQpMz9GlUsJbzCc4wV6L4bHlOiB2JfoKVh0SRxrHazy
         SabVdKZ3nqMjqCbzCbLccZr72xnvUlxsSYbO1vvwn4gwL6Z5nsupM8iqO+8Prmn036/i
         fvnhmcNSaLUgt0M5wjRq0XQCNRZHkvB5M5S0gRRxNz4XBmw2e2TIlSMwJOkTqsWVIJ3Q
         FoNWJxrYaXf7dSF4PkUlOFfegwT4umiTSS21MGwHMNI0HElW327o5ebDPuOS88amecdK
         4uZA==
X-Gm-Message-State: AGi0PuZLOrkXZGEfBizCMz4UezqewcN3yabY+6WnZBxDJbG6Dou0nG0q
        y9FwUKXW+z4UFhVTZ/gDwzkSrkMbiVkIpIMypj8=
X-Google-Smtp-Source: APiQypKQsVa+3Ac0kuybFuEjMpbu1Gw6QPdVSV4WuxOxFqaW50OT+aUHTdCjy6GEhr5eAj4kF4MyLtQupFfg3RKGXCs=
X-Received: by 2002:a6b:b9d5:: with SMTP id j204mr16292120iof.38.1588886333619;
 Thu, 07 May 2020 14:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com> <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
 <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com>
 <20200506223923.z6cbixg2mhtjjlfo@ca-dmjordan1.us.oracle.com>
 <CAKgT0UdDcq_PL1hbvkhBvo9tQN1YA9YDQ6hECHL3TnWA-ytPhw@mail.gmail.com> <20200507202058.4mskqbt3vci3xy4k@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200507202058.4mskqbt3vci3xy4k@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 7 May 2020 14:18:42 -0700
Message-ID: <CAKgT0UeELxfuzKes9FyYD_j1X72-xXjEgGdprNmy9so18zMJUQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] mm: move zone iterator outside of deferred_init_maxorder()
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 7, 2020 at 1:20 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Thu, May 07, 2020 at 08:26:26AM -0700, Alexander Duyck wrote:
> > On Wed, May 6, 2020 at 3:39 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> > > On Tue, May 05, 2020 at 08:27:52AM -0700, Alexander Duyck wrote:
> > > > > Maybe it's better to leave deferred_init_maxorder alone and adapt the
> > > > > multithreading to the existing implementation.  That'd mean dealing with the
> > > > > pesky opaque index somehow, so deferred_init_mem_pfn_range_in_zone() could be
> > >
> > > I should have been explicit, was thinking of @i from
> > > () when mentioning the opaque index.
> >
> > Okay, that makes sense. However in reality you don't need to split
> > that piece out. All you really are doing is splitting up the
> > first_init_pfn value over multiple threads so you just need to make
> > use of deferred_init_mem_pfn_range_in_zone() to initialize it.
>
> Ok, I assume you mean that each thread should use
> deferred_init_mem_pfn_range_in_zone.  Yes, that's what I meant when saying that
> function could be generalized, though not sure we should opt for this.

Yes that is what I meant.

> > > > > generalized to find it in the thread function based on the start/end range, or
> > > > > it could be maintained as part of the range that padata passes to the thread
> > > > > function.
> > > >
> > > > You may be better off just implementing your threads to operate like
> > > > deferred_grow_zone does. All your worker thread really needs then is
> > > > to know where to start performing the page initialization and then it
> > > > could go through and process an entire section worth of pages. The
> > > > other bit that would have to be changed is patch 6 so that you combine
> > > > any ranges that might span a single section instead of just splitting
> > > > the work up based on the ranges.
> > >
> > > How are you thinking of combining them?  I don't see a way to do it without
> > > storing an arbitrary number of ranges somewhere for each thread.
> >
> > So when you are putting together your data you are storing a starting
> > value and a length. All you end up having to do is make certain that
> > the size + start pfn is section aligned. Then if you jump to a new
> > section you have the option of either adding to the size of your
> > current section or submitting the range and starting with a new start
> > pfn in a new section. All you are really doing is breaking up the
> > first_deferred_pfn over multiple sections. What I would do is section
> > align end_pfn, and then check the next range from the zone. If the
> > start_pfn of the next range is less than end_pfn you merge the two
> > ranges by just increasing the size, otherwise you could start a new
> > range.
> >
> > The idea is that you just want to define what the valid range of PFNs
> > are, and if there are sizable holes you skip over them. You would
> > leave most of the lifting for identifying exactly what PFNs to
> > initialize to the pfn_range_in_zone iterators since they would all be
> > read-only accesses anyway.
>
> Ok, I follow you.  My assumption is that there are generally few free pfn
> ranges relative to the total number of pfns being initialized so that it's
> efficient to parallelize over a single pfn range from the zone iterator.  On
> the systems I tested, there were about 20 tiny ranges and one enormous range
> per node so that firing off a job per range kept things simple without
> affecting performance.  If that assumption holds, I'm not sure it's worth it to
> merge ranges.

The idea behind merging ranges it to address possible cases where a
range is broken up such that there is a hole in a max order block as a
result. By combining the ranges if they both span the same section we
can guarantee that the entire section will be initialized as a block
and not potentially have partially initialized sections floating
around. Without that mo_pfn logic I had in there I was getting panics
every so often when booting up one of my systems as I recall.

Also the iterator itself is cheap. It is basically just walking a
read-only list so it scales efficiently as well. One of the reasons
why I arranged the code the way I did is that it also allowed me to
get rid of an extra check in the code as the previous code was having
to verify if the pfn belonged to the node. That is all handled
directly through the for_each_free_mem_pfn_range_in_zone[_from] call
now.

> With the series as it stands plus leaving in the section alignment check in
> deferred_grow_zone (which I think could be relaxed to a maxorder alignment
> check) so it doesn't stop mid-max-order-block, threads simply deal with a
> start/end range and deferred_init_maxorder becomes shorter and simpler too.

I still think we are better off initializing complete sections since
the pageblock_flags are fully initialized that way as well. What
guarantee do you have that all of the memory ranges will be max order
aligned? The problem is we have to guarantee all pages are initialized
before we start freeing the pages in a max order page. If we just
process each block as-is I believe we can end up with some
architectures trying to access uninitialized memory in the buddy
allocator as a result. That is why the deferred_init_maxorder function
will walk through the iterator, using the _from version to avoid
unnecessary iteration, the first time initializing the pages it needs
to cross that max order boundary, and then again to free the max order
block of pages that have been initialized. The iterator itself is
farily cheap and only has to get you through the smaller ranges before
you end up at the one big range that it just kind of sits at while it
is working on getting it processed.
