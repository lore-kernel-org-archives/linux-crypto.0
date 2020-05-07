Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F796C38A2A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 15:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8FC2084D
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 15:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EsbGz21g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgEGP0i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 May 2020 11:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725914AbgEGP0i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 May 2020 11:26:38 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A857C05BD43;
        Thu,  7 May 2020 08:26:38 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t12so2043506ile.9;
        Thu, 07 May 2020 08:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hk/usxye0al9ZgtntC4dBmCGFqC4YKRv3P4aQcMq2qw=;
        b=EsbGz21gQVsZznU50EtHjz5rdZhFZ34GjZhj67iFxuR+pDLE3ZVuonZE7tJZ8+dpo+
         he9P3YvGb+o2GcorrrdOs5szZm2d5TxFtpuWxCHKPgcxNrujvYgvcvQTazVOmSY/aw1+
         1yKNOJZXEp1/BVsQEFBqF1gpFQvNkw56+iSWryosih4d/s6iWTKt2FHxWRhOslcpo45Q
         kw0XFJ7nZY8DkZKZPLHTgsvGQn86Al0wrWOI7Jms4HmyNqILgpf+19hUtPVhyW+KDWTW
         CpaVlTuG9wTlu47KhatY4F00lmfxznp/gaiCLtFCdlOD2MPvmg0XeDnCS1kwlQL6pHVB
         tcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hk/usxye0al9ZgtntC4dBmCGFqC4YKRv3P4aQcMq2qw=;
        b=Fevy7B1+gQs/vfB6L4uBF6GfnGtYZbgZnnOG3WCMw61LZgzQO7hlY04iIdwCG/P5BM
         OBTJLvmjpPo/uHMbw5swzWr9ezg7JTNTMn2kSsgpa82MDaCKiHyMoEhjnZ4xHGI5v7SE
         +u0XCis+ndH50fFzIErGLQuOn/G3075a+Iak92ARCQFWf9wNdnhGVQmemHEI9kOVT0te
         XWu73Q1OCZg5D1kIke23GXCZ9QWgNSFcxu8QLuQRY7plSdxksS84ms0Z1DIXmqr+AoTC
         0hLJH+1l77OGjZwy39jVt5nE+Xx0qWJSDsl54P0BZMcZO4MIH4cfEIiij1RgoBeNe0Yi
         oizw==
X-Gm-Message-State: AGi0PubxGgIdQous7qflCuY7kBvrZ0w2NXe9z1JCaHY7uoB1jbYWNl/l
        ZHQuwEdYNUcGV5KSEu2vVWHtYeqsIN0pLdxZCFk=
X-Google-Smtp-Source: APiQypKPIND1TJ1N6+fkbutod7Ow6h3SeTzodjKUisN+DdBNw/vdSqyS77niETGLoFyjyqp3L5XO+Je8oVYaovNKzLg=
X-Received: by 2002:a92:858b:: with SMTP id f133mr13709831ilh.97.1588865197283;
 Thu, 07 May 2020 08:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com> <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
 <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com> <20200506223923.z6cbixg2mhtjjlfo@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200506223923.z6cbixg2mhtjjlfo@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 7 May 2020 08:26:26 -0700
Message-ID: <CAKgT0UdDcq_PL1hbvkhBvo9tQN1YA9YDQ6hECHL3TnWA-ytPhw@mail.gmail.com>
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

On Wed, May 6, 2020 at 3:39 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Tue, May 05, 2020 at 08:27:52AM -0700, Alexander Duyck wrote:
> > As it turns out that deferred_free_range will be setting the
> > migratetype for the page. In a sparse config the migratetype bits are
> > stored in the section bitmap. So to avoid cacheline bouncing it would
> > make sense to section align the tasks so that they only have one
> > thread touching one section rather than having the pageblock_flags
> > getting bounced between threads.
>
> That's a good point, I'll change the alignment.
>
> I kicked off some runs on the Skylake bare metal system to check how this did
> and the performance stayed the same, but see below.
>
> > It should also reduce the overhead
> > for having to parallelize the work in the first place since a section
> > is several times larger than a MAX_ORDER page and allows for more
> > batching of the work.
>
> I think you may be assuming that threads work in MAX_ORDER batches, maybe
> because that's the job's min_chunk, but padata works differently.  The
> min_chunk is a lower bound that establishes the smallest amount of work that
> makes sense for a thread to do in one go, so in this case it's useful to
> prevent starting large numbers of threads to initialize a tiny amount of pages.
>
> Internally padata uses total job size and min chunk to arrive at the chunk
> size, which on big machines will be much larger than min_chunk.  The idea is
> the chunk size should be large enough to minimize multithreading overhead but
> small enough to permit load balancing between threads.
>
> This is probably why the results didn't change much when aligning by section,
> but that doesn't mean other systems won't benefit.

Okay, that makes sense.

> > > Maybe it's better to leave deferred_init_maxorder alone and adapt the
> > > multithreading to the existing implementation.  That'd mean dealing with the
> > > pesky opaque index somehow, so deferred_init_mem_pfn_range_in_zone() could be
>
> I should have been explicit, was thinking of @i from
> () when mentioning the opaque index.

Okay, that makes sense. However in reality you don't need to split
that piece out. All you really are doing is splitting up the
first_init_pfn value over multiple threads so you just need to make
use of deferred_init_mem_pfn_range_in_zone() to initialize it.

> > > generalized to find it in the thread function based on the start/end range, or
> > > it could be maintained as part of the range that padata passes to the thread
> > > function.
> >
> > You may be better off just implementing your threads to operate like
> > deferred_grow_zone does. All your worker thread really needs then is
> > to know where to start performing the page initialization and then it
> > could go through and process an entire section worth of pages. The
> > other bit that would have to be changed is patch 6 so that you combine
> > any ranges that might span a single section instead of just splitting
> > the work up based on the ranges.
>
> How are you thinking of combining them?  I don't see a way to do it without
> storing an arbitrary number of ranges somewhere for each thread.

So when you are putting together your data you are storing a starting
value and a length. All you end up having to do is make certain that
the size + start pfn is section aligned. Then if you jump to a new
section you have the option of either adding to the size of your
current section or submitting the range and starting with a new start
pfn in a new section. All you are really doing is breaking up the
first_deferred_pfn over multiple sections. What I would do is section
align end_pfn, and then check the next range from the zone. If the
start_pfn of the next range is less than end_pfn you merge the two
ranges by just increasing the size, otherwise you could start a new
range.

The idea is that you just want to define what the valid range of PFNs
are, and if there are sizable holes you skip over them. You would
leave most of the lifting for identifying exactly what PFNs to
initialize to the pfn_range_in_zone iterators since they would all be
read-only accesses anyway.

> > If you are referring to the mo_pfn you shouldn't even need to think
> > about it.
>
> (clarified "opaque index" above)

Thanks.

> > All it is doing is guaranteeing you are processing at least
> > a full max order worth of pages. Without that the logic before was
> > either process a whole section, or just process all of memory
> > initializing it before it started freeing it. I found it made things
> > much more efficient to process only up to MAX_ORDER at a time as you
> > could squeeze that into the L2 cache for most x86 processors at least
> > and it reduced the memory bandwidth by quite a bit.
>
> Yes, that was clever, we should keep doing it that way.

Thanks.
