Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3023CC28CBC
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 02:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFD420643
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 02:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SteZFnyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgEACp5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 22:45:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46528 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgEACp5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 22:45:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0412gvmu090502;
        Fri, 1 May 2020 02:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jm7TsAjBWi4GDN0ha1K1yz1GP8ie4jzQj6poP7e8Y10=;
 b=SteZFnyjUZpdxBmafcRKm5ibk+Hu+WbQ9Pk8k0P0V8q+4kkHMW2NMYZ9G24Jd4VIZ7jy
 MVx5mmKcx8g2GWufcxbfLprYaficCFCcupj9sufnzOTmD1doYkDifXzvdZAj6eZT04V6
 2FdgeRmjeseqcuw7PQNoqvlxb6/Z8g78doKc7GJyZvSl0hJ8XXk/193kwnKesj4xUeBH
 ZXqf3yr3ERQApsVagVYjgf5LKfUBvsUvSlPxVtmSjhGMT+QtecysnVRAIg1XVhdjDzEQ
 MCuHI2qpOmrXZWslSs1zFJcC0c7NlVCJQs4LizeRsMUU1EA5PSv2jGWPGw3UlUBdhGZ8 Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30r7f3ghx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 02:45:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0412gTBi063787;
        Fri, 1 May 2020 02:45:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30r7f2mx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 02:45:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0412jIiv021097;
        Fri, 1 May 2020 02:45:18 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 19:45:18 -0700
Date:   Thu, 30 Apr 2020 22:45:39 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
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
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mm: move zone iterator outside of
 deferred_init_maxorder()
Message-ID: <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com>
 <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010018
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Alex,

On Thu, Apr 30, 2020 at 02:43:28PM -0700, Alexander Duyck wrote:
> On 4/30/2020 1:11 PM, Daniel Jordan wrote:
> > padata will soon divide up pfn ranges between threads when parallelizing
> > deferred init, and deferred_init_maxorder() complicates that by using an
> > opaque index in addition to start and end pfns.  Move the index outside
> > the function to make splitting the job easier, and simplify the code
> > while at it.
> > 
> > deferred_init_maxorder() now always iterates within a single pfn range
> > instead of potentially multiple ranges, and advances start_pfn to the
> > end of that range instead of the max-order block so partial pfn ranges
> > in the block aren't skipped in a later iteration.  The section alignment
> > check in deferred_grow_zone() is removed as well since this alignment is
> > no longer guaranteed.  It's not clear what value the alignment provided
> > originally.
> > 
> > Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> 
> So part of the reason for splitting it up along section aligned boundaries
> was because we already had an existing functionality in deferred_grow_zone
> that was going in and pulling out a section aligned chunk and processing it
> to prepare enough memory for other threads to keep running. I suspect that
> the section alignment was done because normally I believe that is also the
> alignment for memory onlining.

I think Pavel added that functionality, maybe he could confirm.

My impression was that the reason deferred_grow_zone aligned the requested
order up to a section was to make enough memory available to avoid being called
on every allocation.

> With this already breaking things up over multiple threads how does this
> work with deferred_grow_zone? Which thread is it trying to allocate from if
> it needs to allocate some memory for itself?

I may not be following your question, but deferred_grow_zone doesn't allocate
memory during the multithreading in deferred_init_memmap because the latter
sets first_deferred_pfn so that deferred_grow_zone bails early.

> Also what is to prevent a worker from stop deferred_grow_zone from bailing
> out in the middle of a max order page block if there is a hole in the middle
> of the block?

deferred_grow_zone remains singlethreaded.  It could stop in the middle of a
max order block, but it can't run concurrently with deferred_init_memmap, as
per above, so if deferred_init_memmap were to init 'n free the remaining part
of the block, the previous portion would have already been initialized.
