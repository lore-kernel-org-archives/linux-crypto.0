Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E14C28CBC
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 02:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69FC220643
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 02:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/Uh7AqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgEACpX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 22:45:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgEACpW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 22:45:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0412dV1l016832;
        Fri, 1 May 2020 02:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=amGI2EKz7GGva1xtOY99+AbL2BZTFlckdCPX0cEjQl4=;
 b=R/Uh7AqVaKevL2Ck3pCGur1QzlL+hEdzg5KEzVOfvonzIWVE4ZqZD2cvqET0X09bw43W
 IlWY0GsjoSKrvZS0VupcRskPM/6ZcrcPgJ+yskR5ONnbkAyPmoTumG8RJDedoaYr37Ip
 YigkseXqa/MSMkhMxqRPWD6nwZLBpFevbHfGK2JwJX0hIvFrSVCfJu/plAS6ksRPRtQ4
 VSvQFsnrA6ksJYl7E3UCDLTILl/ol7MguGC7SVnmZ9jx0sKPrdz9oj7Q9VnLZ8b42+ub
 O9i5O0SfhakbrQXdBdmuWwi7SmbUtPgc9X+4CIdpSUBYnH+ZnGX0mnn91Pca+c8RDBGk TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30r7f80hrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 02:39:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0412ZXkn024150;
        Fri, 1 May 2020 02:39:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30r7ff5jmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 02:39:51 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0412dfxm032165;
        Fri, 1 May 2020 02:39:42 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 19:39:41 -0700
Date:   Thu, 30 Apr 2020 22:40:02 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] padata: parallelize deferred page init
Message-ID: <20200501024002.h7vpf4fxu6elmddn@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430143131.7b8ff07f022ed879305de82f@linux-foundation.org>
 <CA+CK2bDwg=s6RbTCirm4U5gvRsnCMred-pnrW=WzN9hfGuBsiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bDwg=s6RbTCirm4U5gvRsnCMred-pnrW=WzN9hfGuBsiQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010017
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 05:40:59PM -0400, Pavel Tatashin wrote:
> On Thu, Apr 30, 2020 at 5:31 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 30 Apr 2020 16:11:18 -0400 Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> >
> > > Sometimes the kernel doesn't take full advantage of system memory
> > > bandwidth, leading to a single CPU spending excessive time in
> > > initialization paths where the data scales with memory size.
> > >
> > > Multithreading naturally addresses this problem, and this series is the
> > > first step.
> > >
> > > It extends padata, a framework that handles many parallel singlethreaded
> > > jobs, to handle multithreaded jobs as well by adding support for
> > > splitting up the work evenly, specifying a minimum amount of work that's
> > > appropriate for one helper thread to do, load balancing between helpers,
> > > and coordinating them.  More documentation in patches 4 and 7.
> > >
> > > The first user is deferred struct page init, a large bottleneck in
> > > kernel boot--actually the largest for us and likely others too.  This
> > > path doesn't require concurrency limits, resource control, or priority
> > > adjustments like future users will (vfio, hugetlb fallocate, munmap)
> > > because it happens during boot when the system is otherwise idle and
> > > waiting on page init to finish.
> > >
> > > This has been tested on a variety of x86 systems and speeds up kernel
> > > boot by 6% to 49% by making deferred init 63% to 91% faster.
> >
> > How long is this up-to-91% in seconds?  If it's 91% of a millisecond
> > then not impressed.  If it's 91% of two weeks then better :)

The largest system I could test had 384G per node and saved 1.5 out of 4
seconds.

> > Relatedly, how important is boot time on these large machines anyway?
> > They presumably have lengthy uptimes so boot time is relatively
> > unimportant?
> 
> Large machines indeed have a lengthy uptime, but they also can host a
> large number of VMs meaning that downtime of the host increases the
> downtime of VMs in cloud environments. Some VMs might be very sensible
> to downtime: game servers, traders, etc.
>
> > IOW, can you please explain more fully why this patchset is valuable to
> > our users?

I'll let the users speak for themselves, but I have a similar use case to Pavel
of limiting the downtime of VMs running on these large systems, and spinning up
instances as fast as possible is also desirable for our cloud users.
