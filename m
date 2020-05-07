Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49081C4724C
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 20:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 256FA2495C
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 20:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JtWRvxPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEGUVb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 May 2020 16:21:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEGUVb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 May 2020 16:21:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047KHrqL057929;
        Thu, 7 May 2020 20:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nd5DdgG3fn6gi3FUpqauceZ8VNUcmEBV6Yu0oAQgeCg=;
 b=JtWRvxPPTESJSiimjfZzQhUWBp6qN1IEJZwPwUpm2oat+M/NTOb2tDnWMhstnHpaO+/B
 jvWKOxWG1a4ucX5X6PBZZSY60/MMsIpR+wwmDRbNwOQHeA+Eo0qaxjKSr68lQaV2QiUt
 es/zSycvoZlzxhQ2UVYNqrsjF+hmSBtRQejUI0Io95LcPB61N0wtYM+d/jI/E+y21t/r
 QD2eS9YdotPxQXLKFSEmsuYm1v4On7rcEN6mCr8gLlHnAGL8BskddBiAng6tZhu+5/t+
 Rfb1ulee1Ap9bD/2IKKKTa4aRhERO2NCeiNUQA2al+TUEdb/5r1ett6t7gAKYi9R2WPj VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30vpwd8rj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 20:20:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047KChsB068594;
        Thu, 7 May 2020 20:20:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30us7rd3rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 20:20:49 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 047KKaFD002298;
        Thu, 7 May 2020 20:20:36 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 13:20:36 -0700
Date:   Thu, 7 May 2020 16:20:58 -0400
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
Message-ID: <20200507202058.4mskqbt3vci3xy4k@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com>
 <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
 <20200501024539.tnjuybydwe3r4u2x@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uctro3+PWeJTi=O3Yc2qUF8Oy+HrypzCUzkaCt=XH0Lkg@mail.gmail.com>
 <20200505005432.bohmaa6zeffhdkgn@ca-dmjordan1.us.oracle.com>
 <CAKgT0Uegw2vFSCOcsCMATfDu0Q8NP2ZVi-2Fgm8P2RwU_B2c3A@mail.gmail.com>
 <20200506223923.z6cbixg2mhtjjlfo@ca-dmjordan1.us.oracle.com>
 <CAKgT0UdDcq_PL1hbvkhBvo9tQN1YA9YDQ6hECHL3TnWA-ytPhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdDcq_PL1hbvkhBvo9tQN1YA9YDQ6hECHL3TnWA-ytPhw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=2 impostorscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070160
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 07, 2020 at 08:26:26AM -0700, Alexander Duyck wrote:
> On Wed, May 6, 2020 at 3:39 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> > On Tue, May 05, 2020 at 08:27:52AM -0700, Alexander Duyck wrote:
> > > > Maybe it's better to leave deferred_init_maxorder alone and adapt the
> > > > multithreading to the existing implementation.  That'd mean dealing with the
> > > > pesky opaque index somehow, so deferred_init_mem_pfn_range_in_zone() could be
> >
> > I should have been explicit, was thinking of @i from
> > () when mentioning the opaque index.
> 
> Okay, that makes sense. However in reality you don't need to split
> that piece out. All you really are doing is splitting up the
> first_init_pfn value over multiple threads so you just need to make
> use of deferred_init_mem_pfn_range_in_zone() to initialize it.

Ok, I assume you mean that each thread should use
deferred_init_mem_pfn_range_in_zone.  Yes, that's what I meant when saying that
function could be generalized, though not sure we should opt for this.

> > > > generalized to find it in the thread function based on the start/end range, or
> > > > it could be maintained as part of the range that padata passes to the thread
> > > > function.
> > >
> > > You may be better off just implementing your threads to operate like
> > > deferred_grow_zone does. All your worker thread really needs then is
> > > to know where to start performing the page initialization and then it
> > > could go through and process an entire section worth of pages. The
> > > other bit that would have to be changed is patch 6 so that you combine
> > > any ranges that might span a single section instead of just splitting
> > > the work up based on the ranges.
> >
> > How are you thinking of combining them?  I don't see a way to do it without
> > storing an arbitrary number of ranges somewhere for each thread.
> 
> So when you are putting together your data you are storing a starting
> value and a length. All you end up having to do is make certain that
> the size + start pfn is section aligned. Then if you jump to a new
> section you have the option of either adding to the size of your
> current section or submitting the range and starting with a new start
> pfn in a new section. All you are really doing is breaking up the
> first_deferred_pfn over multiple sections. What I would do is section
> align end_pfn, and then check the next range from the zone. If the
> start_pfn of the next range is less than end_pfn you merge the two
> ranges by just increasing the size, otherwise you could start a new
> range.
> 
> The idea is that you just want to define what the valid range of PFNs
> are, and if there are sizable holes you skip over them. You would
> leave most of the lifting for identifying exactly what PFNs to
> initialize to the pfn_range_in_zone iterators since they would all be
> read-only accesses anyway.

Ok, I follow you.  My assumption is that there are generally few free pfn
ranges relative to the total number of pfns being initialized so that it's
efficient to parallelize over a single pfn range from the zone iterator.  On
the systems I tested, there were about 20 tiny ranges and one enormous range
per node so that firing off a job per range kept things simple without
affecting performance.  If that assumption holds, I'm not sure it's worth it to
merge ranges.

With the series as it stands plus leaving in the section alignment check in
deferred_grow_zone (which I think could be relaxed to a maxorder alignment
check) so it doesn't stop mid-max-order-block, threads simply deal with a
start/end range and deferred_init_maxorder becomes shorter and simpler too.
