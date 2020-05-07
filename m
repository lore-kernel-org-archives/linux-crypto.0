Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDD8C35280
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 22:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CAF20870
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 22:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mp6OwwTT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEGWaa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 May 2020 18:30:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEGWa3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 May 2020 18:30:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047M4FEK034892;
        Thu, 7 May 2020 22:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XQApXYA3T4kif5cGsekr95q1Lc6vxeCkbW+u6MJO0e4=;
 b=mp6OwwTTQvURCkvxniCOY2GVCGC+2v4Oz+Hmn+/UzvE+Gvdd3DjjpNTFutiyMqD0QHMy
 3G795BTDFbnVYdLY4neNQJDCogb1P19Bx7cLHknVtniiW6z8Awg6NcMbIqkIz21XQ2st
 x6qyrBNtQGBWEooLXllqlxVdFamj5FsqI0Kss+owRTIfDANJlV3cxQwkXfPRCKKe9YXA
 6SR/EtukSu2Hi1k5zf5Haq3MafcOme97OPvUo/zIoMYqhiDHr1oiASDdpOurdOOyZXnR
 k/ovvmmJK2HXxDczzYJJKHPqNQDw4M5D7Yx/LEcU1ViyuRiE44fnp+tYGVnbhb8SA24w 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30vtexr3b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 22:15:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047M6j8a087163;
        Thu, 7 May 2020 22:15:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30vtef9qtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 22:15:16 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 047MF70T011899;
        Thu, 7 May 2020 22:15:07 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 15:15:06 -0700
Date:   Thu, 7 May 2020 18:15:24 -0400
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
Message-ID: <20200507221524.xufi6rpw42fmdnuw@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-6-daniel.m.jordan@oracle.com>
 <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
 <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com>
 <20200506223923.z6cbixg2mhtjjlfo@ca-dmjordan1.us.oracle.com>
 <CAKgT0UdDcq_PL1hbvkhBvo9tQN1YA9YDQ6hECHL3TnWA-ytPhw@mail.gmail.com>
 <20200507202058.4mskqbt3vci3xy4k@ca-dmjordan1.us.oracle.com>
 <CAKgT0UeELxfuzKes9FyYD_j1X72-xXjEgGdprNmy9so18zMJUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeELxfuzKes9FyYD_j1X72-xXjEgGdprNmy9so18zMJUQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=2 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070176
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 07, 2020 at 02:18:42PM -0700, Alexander Duyck wrote:
> The idea behind merging ranges it to address possible cases where a
> range is broken up such that there is a hole in a max order block as a
> result.

Gah, yes, you're right, there could be multiple ranges in a max order block, so
the threads have to use the zone iterators to skip the holes.

> By combining the ranges if they both span the same section we
> can guarantee that the entire section will be initialized as a block
> and not potentially have partially initialized sections floating
> around. Without that mo_pfn logic I had in there I was getting panics
> every so often when booting up one of my systems as I recall.
> 
> Also the iterator itself is cheap. It is basically just walking a
> read-only list so it scales efficiently as well. One of the reasons

Agreed, it's not expensive, it's just gnarliness I was hoping to avoid, but
obviously it's not gonna work.

> why I arranged the code the way I did is that it also allowed me to
> get rid of an extra check in the code as the previous code was having
> to verify if the pfn belonged to the node. That is all handled
> directly through the for_each_free_mem_pfn_range_in_zone[_from] call
> now.
> 
> > With the series as it stands plus leaving in the section alignment check in
> > deferred_grow_zone (which I think could be relaxed to a maxorder alignment
> > check) so it doesn't stop mid-max-order-block, threads simply deal with a
> > start/end range and deferred_init_maxorder becomes shorter and simpler too.
> 
> I still think we are better off initializing complete sections since
> the pageblock_flags are fully initialized that way as well.

Fair enough.

> What
> guarantee do you have that all of the memory ranges will be max order
> aligned?

Sure, it's a problem with multiple ranges in a maxorder block, the rest
could've been handled.

> The problem is we have to guarantee all pages are initialized
> before we start freeing the pages in a max order page. If we just
> process each block as-is I believe we can end up with some
> architectures trying to access uninitialized memory in the buddy
> allocator as a result. That is why the deferred_init_maxorder function
> will walk through the iterator, using the _from version to avoid
> unnecessary iteration, the first time initializing the pages it needs
> to cross that max order boundary, and then again to free the max order
> block of pages that have been initialized. The iterator itself is
> farily cheap and only has to get you through the smaller ranges before
> you end up at the one big range that it just kind of sits at while it
> is working on getting it processed.

Right.


Ok, I think we're on the same page for the next version.  Thanks for the
thorough review!
