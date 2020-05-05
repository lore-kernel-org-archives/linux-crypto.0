Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388B9C47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 15:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1189E2078D
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 15:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ns9BAO8Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgEEP2E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 11:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729403AbgEEP2E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 11:28:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E036C061A0F;
        Tue,  5 May 2020 08:28:04 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w4so2363324ioc.6;
        Tue, 05 May 2020 08:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b//WyoKMoOWyknzMDwAntqpnlFg9r6X0WW+350J/1yI=;
        b=ns9BAO8YqpS1sAuldx8uWARkY5qyrGWrAOpg6uCV3k+MLyCqop9mCBaHHj89E4v0N+
         6XSAEH4CgAV1naXoyGmgRPnxurfKpXb/oGlkGKHWtS6WxFdqDtU8owmyzzgtUhO9crJ0
         Wah7omW86KzoFYxgbiKJ182JNj0OCAtEq2lVQ8QPzqSIMbygjkwBUz8whHphk66EsyTH
         gc5mBj7UyJ+8nCBrHdLB+g0RkeC4aVOADiHCHBp0CvmjYghZ1QESa61mOfNSD1Htw3NG
         HLZtaCh0qTka3kXfeEW2Qq+rFyxqOIjYpx4bn9xl6ld0OY9X7Pb8H47piuNFQUa5bDYG
         /jVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b//WyoKMoOWyknzMDwAntqpnlFg9r6X0WW+350J/1yI=;
        b=MrFrDXujMdIZ8m/ZdWrUZKrHsmEmoNKvjDI9p2FXen80Py2DpprJUphibC34+MY0FF
         bKMj6siwBCWJMRAqH5IDIO52sZq4UzXsux9IePJ52X7ft/vYswEAJv4TKngTMDQlxd/R
         AE2OluSbliROxQKXVHMaOKvmGFjAEWu+IKoJ9+vrREzW7oY5Hm458Y9LK1xdwiccvdvF
         RDjbf0v/Zu3XbBMC0ALa54KmCd864Ru7HTCi2GXNeXrZrLPM9fuHEESDEueNGxlfsh1+
         MAhsporBIB5fbUM9osRsql4HNNvJ0QU8VCV2JvJo8yp+boH5YH3zeZzbUDDilraZr80O
         svmA==
X-Gm-Message-State: AGi0PubsaTz4GqZMA8FE0i87N8FBlMtuYuLAA/ekEpFi7iBMQRzd89e2
        fpJBAMUITyLnJzOd+Q1gUG8jfGddtIqWdAakyWg=
X-Google-Smtp-Source: APiQypICZLOIAWPDMlYJr/jbilaov2atkz+fIoCy6F3ev9oqNozYB3WFgJcfcMdbAQytemQqFANXBtFhBCKd5m+hzUA=
X-Received: by 2002:a6b:b9d5:: with SMTP id j204mr3962700iof.38.1588692483399;
 Tue, 05 May 2020 08:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com> <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com> <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 5 May 2020 08:27:52 -0700
Message-ID: <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com>
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

On Mon, May 4, 2020 at 5:54 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Mon, May 04, 2020 at 03:10:46PM -0700, Alexander Duyck wrote:
> > So we cannot stop in the middle of a max order block. That shouldn't
> > be possible as part of the issue is that the buddy allocator will
> > attempt to access the buddy for the page which could cause issues if
> > it tries to merge the page with one that is not initialized. So if
> > your code supports that then it is definitely broken. That was one of
> > the reasons for all of the variable weirdness in
> > deferred_init_maxorder. I was going through and making certain that
> > while we were initializing the range we were freeing the pages in
> > MAX_ORDER aligned blocks and skipping over whatever reserved blocks
> > were there. Basically it was handling the case where a single
> > MAX_ORDER block could span multiple ranges.
> >
> > On x86 this was all pretty straightforward and I don't believe we
> > needed the code, but I seem to recall there were some other
> > architectures that had more complex memory layouts at the time and
> > that was one of the reasons why I had to be careful to wait until I
> > had processed the full MAX_ORDER block before I could start freeing
> > the pages, otherwise it would start triggering memory corruptions.
>
> Yes, thanks, I missed the case where deferred_grow_zone could stop
> mid-max-order-block.

As it turns out that deferred_free_range will be setting the
migratetype for the page. In a sparse config the migratetype bits are
stored in the section bitmap. So to avoid cacheline bouncing it would
make sense to section align the tasks so that they only have one
thread touching one section rather than having the pageblock_flags
getting bounced between threads. It should also reduce the overhead
for having to parallelize the work in the first place since a section
is several times larger than a MAX_ORDER page and allows for more
batching of the work.

> Maybe it's better to leave deferred_init_maxorder alone and adapt the
> multithreading to the existing implementation.  That'd mean dealing with the
> pesky opaque index somehow, so deferred_init_mem_pfn_range_in_zone() could be
> generalized to find it in the thread function based on the start/end range, or
> it could be maintained as part of the range that padata passes to the thread
> function.

You may be better off just implementing your threads to operate like
deferred_grow_zone does. All your worker thread really needs then is
to know where to start performing the page initialization and then it
could go through and process an entire section worth of pages. The
other bit that would have to be changed is patch 6 so that you combine
any ranges that might span a single section instead of just splitting
the work up based on the ranges.

If you are referring to the mo_pfn you shouldn't even need to think
about it. All it is doing is guaranteeing you are processing at least
a full max order worth of pages. Without that the logic before was
either process a whole section, or just process all of memory
initializing it before it started freeing it. I found it made things
much more efficient to process only up to MAX_ORDER at a time as you
could squeeze that into the L2 cache for most x86 processors at least
and it reduced the memory bandwidth by quite a bit. If you update the
code to only provide section aligned/sized ranges of of PFNs to
initialize then it can pretty much be ignored since all it is doing is
defining the break point for single MAX_ORDER chunks which would be
smaller than a section anyway.
