Return-Path: <SRS0=2pnx=6U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF644C28CBC
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 22:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA632075E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 22:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hKkK6wQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgEFWjl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 May 2020 18:39:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgEFWjk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 May 2020 18:39:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046Md8fV084203;
        Wed, 6 May 2020 22:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aCIY+Io9IQgcDfA/xk5CfyLiRyvGAA+dPyySxT7CoMU=;
 b=hKkK6wQ0eZZ6OQVjb3f6tDu/lNqpxy3FIqrcWyI+ov2s/ycUFTKndQjhipREHsjOKYsl
 3tjZ/q/Oijmo0zHu0gNERO0p3ExsbM+lq4wX2xTfa61+crGvm7JleOpyGEvVu0Jzlgnj
 8js1oUgfHBvSEsL0h5ibLDkssUHGMWU7dvH2tG9brXU3Q4o84HHs4q4DVTzLPBnh5PAh
 xf+vCQ5G+i+O1rkABhZ4kfL4BDPQt6qayNJaQgewkiW57Rxh4QE8YJIwYW3brc9Lczk9
 nWFwNNGcj7yIuDLQlHoT1A2me/xKxbcKQJsx/b2is4S6Qqv6poNHVh+JEqlIGcM41YfX 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gncwry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 22:39:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046MbX2i092751;
        Wed, 6 May 2020 22:39:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnkxrba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 22:39:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046Md1w3005656;
        Wed, 6 May 2020 22:39:01 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 15:39:01 -0700
Date:   Wed, 6 May 2020 18:39:23 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
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
Subject: Re: [PATCH 5/7] mm: move zone iterator outside of
 deferred_init_maxorder()
Message-ID: <20200506223923.z6cbixg2mhtjjlfo@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com>
 <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
 <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 05, 2020 at 08:27:52AM -0700, Alexander Duyck wrote:
> As it turns out that deferred_free_range will be setting the
> migratetype for the page. In a sparse config the migratetype bits are
> stored in the section bitmap. So to avoid cacheline bouncing it would
> make sense to section align the tasks so that they only have one
> thread touching one section rather than having the pageblock_flags
> getting bounced between threads.

That's a good point, I'll change the alignment.

I kicked off some runs on the Skylake bare metal system to check how this did
and the performance stayed the same, but see below.

> It should also reduce the overhead
> for having to parallelize the work in the first place since a section
> is several times larger than a MAX_ORDER page and allows for more
> batching of the work.

I think you may be assuming that threads work in MAX_ORDER batches, maybe
because that's the job's min_chunk, but padata works differently.  The
min_chunk is a lower bound that establishes the smallest amount of work that
makes sense for a thread to do in one go, so in this case it's useful to
prevent starting large numbers of threads to initialize a tiny amount of pages.

Internally padata uses total job size and min chunk to arrive at the chunk
size, which on big machines will be much larger than min_chunk.  The idea is
the chunk size should be large enough to minimize multithreading overhead but
small enough to permit load balancing between threads.

This is probably why the results didn't change much when aligning by section,
but that doesn't mean other systems won't benefit.

> > Maybe it's better to leave deferred_init_maxorder alone and adapt the
> > multithreading to the existing implementation.  That'd mean dealing with the
> > pesky opaque index somehow, so deferred_init_mem_pfn_range_in_zone() could be

I should have been explicit, was thinking of @i from
for_each_free_mem_pfn_range_in_zone_from() when mentioning the opaque index.

> > generalized to find it in the thread function based on the start/end range, or
> > it could be maintained as part of the range that padata passes to the thread
> > function.
> 
> You may be better off just implementing your threads to operate like
> deferred_grow_zone does. All your worker thread really needs then is
> to know where to start performing the page initialization and then it
> could go through and process an entire section worth of pages. The
> other bit that would have to be changed is patch 6 so that you combine
> any ranges that might span a single section instead of just splitting
> the work up based on the ranges.

How are you thinking of combining them?  I don't see a way to do it without
storing an arbitrary number of ranges somewhere for each thread.

> If you are referring to the mo_pfn you shouldn't even need to think
> about it.

(clarified "opaque index" above)

> All it is doing is guaranteeing you are processing at least
> a full max order worth of pages. Without that the logic before was
> either process a whole section, or just process all of memory
> initializing it before it started freeing it. I found it made things
> much more efficient to process only up to MAX_ORDER at a time as you
> could squeeze that into the L2 cache for most x86 processors at least
> and it reduced the memory bandwidth by quite a bit.

Yes, that was clever, we should keep doing it that way.
