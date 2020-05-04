Return-Path: <SRS0=Dybx=6S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235B9C47247
	for <linux-crypto@archiver.kernel.org>; Mon,  4 May 2020 22:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF092078C
	for <linux-crypto@archiver.kernel.org>; Mon,  4 May 2020 22:11:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MunwQTK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgEDWK7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726419AbgEDWK7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 18:10:59 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED8CC061A0E;
        Mon,  4 May 2020 15:10:58 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w6so429353ilg.1;
        Mon, 04 May 2020 15:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZk7KO7iCLuHsBzIYCsHCdT3vf2qALdqqTIYGdX8DrM=;
        b=MunwQTK/oZEY08VH24oKY2sqbh9YFifGKbMgAwqtSvL51Uff/DmC7w6GxZGvW1JDj7
         r7qhZeyUfSluCoFmNFKERno/XgtP1/AIy87C8SGX9cRBwrZmGl5N65aQWCTwoklxOaNF
         Y2BWYETGpOZGY9mn7NnJWFFx18tWPwyOdevCtdOxcedFSKMo+fqEFxsCWUT0pQgYfHYP
         g4xOw5797xu9M8YcRUN9pdmj++icvaMIrNy0RqJuw3Q3J1kREak946j1UXw6gmKAeXdy
         wZR/zuqInAvY9IARbZTNFhq/UVT42ura0EQcSwnDBSSS8Ga0fpMV6O8LGx5X35VZlXIC
         aooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZk7KO7iCLuHsBzIYCsHCdT3vf2qALdqqTIYGdX8DrM=;
        b=WtoAykUnzYUr4MdQlhvXqhU6keqSnXc2AJdUfV+dRkUOOe1r3K8Spy8//jP8xy/l5K
         A9FJ3YiH3/wKXfYPXLahYgriYxoR7y1SrTI3ojk3UX2Uz3rS6jMXpJ5ytvB4rbEhmz7Z
         ibK+KuFFdvcS6kOxTOJoNuuU4uvampA9NQFuY9k0B/0mqw1i5aZxnhreqBBvpg42eFF9
         jCiuAJDjqgG6Up54BQdTK9dOo2KQpOqIUkyr+D0grxLR9JDcx87BzxqyIOJ4kbvbyJ1r
         5+T9HHAHfLNCISQvRZwhkdn0oV7USCOOjw7Kulmc8KtWXnemutSQvm8cmoCLNktIBou8
         lV6A==
X-Gm-Message-State: AGi0Pua7uEJEuwzsL4u+cFD40KZ5WcEgbvh+/E2d38xtHY+jWrLqcuTq
        x2vKIVSqqK9rST9u1wd3b86vMaRI/31fn/pvczc=
X-Google-Smtp-Source: APiQypL1oez+uCR9IA4zSBbP8a3jRvUQS3fagi3oYEjM2vFLBDiVuuEvbgDc6vyXatMIS6T7sq3m4OW5DAhBoDuQVMg=
X-Received: by 2002:a92:5f46:: with SMTP id t67mr590358ilb.64.1588630257228;
 Mon, 04 May 2020 15:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com> <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 4 May 2020 15:10:46 -0700
Message-ID: <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
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

On Thu, Apr 30, 2020 at 7:45 PM Daniel Jordan
<daniel.m.jordan@oracle.com> wrote:
>
> Hi Alex,
>
> On Thu, Apr 30, 2020 at 02:43:28PM -0700, Alexander Duyck wrote:
> > On 4/30/2020 1:11 PM, Daniel Jordan wrote:
> > > padata will soon divide up pfn ranges between threads when parallelizing
> > > deferred init, and deferred_init_maxorder() complicates that by using an
> > > opaque index in addition to start and end pfns.  Move the index outside
> > > the function to make splitting the job easier, and simplify the code
> > > while at it.
> > >
> > > deferred_init_maxorder() now always iterates within a single pfn range
> > > instead of potentially multiple ranges, and advances start_pfn to the
> > > end of that range instead of the max-order block so partial pfn ranges
> > > in the block aren't skipped in a later iteration.  The section alignment
> > > check in deferred_grow_zone() is removed as well since this alignment is
> > > no longer guaranteed.  It's not clear what value the alignment provided
> > > originally.
> > >
> > > Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> >
> > So part of the reason for splitting it up along section aligned boundaries
> > was because we already had an existing functionality in deferred_grow_zone
> > that was going in and pulling out a section aligned chunk and processing it
> > to prepare enough memory for other threads to keep running. I suspect that
> > the section alignment was done because normally I believe that is also the
> > alignment for memory onlining.
>
> I think Pavel added that functionality, maybe he could confirm.
>
> My impression was that the reason deferred_grow_zone aligned the requested
> order up to a section was to make enough memory available to avoid being called
> on every allocation.
>
> > With this already breaking things up over multiple threads how does this
> > work with deferred_grow_zone? Which thread is it trying to allocate from if
> > it needs to allocate some memory for itself?
>
> I may not be following your question, but deferred_grow_zone doesn't allocate
> memory during the multithreading in deferred_init_memmap because the latter
> sets first_deferred_pfn so that deferred_grow_zone bails early.

It has been a while since I looked at this code so I forgot that
deferred_grow_zone is essentially blocked out once we start the
per-node init.

> > Also what is to prevent a worker from stop deferred_grow_zone from bailing
> > out in the middle of a max order page block if there is a hole in the middle
> > of the block?
>
> deferred_grow_zone remains singlethreaded.  It could stop in the middle of a
> max order block, but it can't run concurrently with deferred_init_memmap, as
> per above, so if deferred_init_memmap were to init 'n free the remaining part
> of the block, the previous portion would have already been initialized.

So we cannot stop in the middle of a max order block. That shouldn't
be possible as part of the issue is that the buddy allocator will
attempt to access the buddy for the page which could cause issues if
it tries to merge the page with one that is not initialized. So if
your code supports that then it is definitely broken. That was one of
the reasons for all of the variable weirdness in
deferred_init_maxorder. I was going through and making certain that
while we were initializing the range we were freeing the pages in
MAX_ORDER aligned blocks and skipping over whatever reserved blocks
were there. Basically it was handling the case where a single
MAX_ORDER block could span multiple ranges.

On x86 this was all pretty straightforward and I don't believe we
needed the code, but I seem to recall there were some other
architectures that had more complex memory layouts at the time and
that was one of the reasons why I had to be careful to wait until I
had processed the full MAX_ORDER block before I could start freeing
the pages, otherwise it would start triggering memory corruptions.
