Return-Path: <SRS0=2pnx=6U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B21C28CBC
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 22:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D677220659
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 22:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lho8OH4E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgEFWoC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 May 2020 18:44:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgEFWoC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 May 2020 18:44:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046MfRPL087376;
        Wed, 6 May 2020 22:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qxCl0w8RFM4/l1IN+gQYmT3V1Br1VTWD4aTDDTrdu0I=;
 b=Lho8OH4E9JeoPeXdTBqyyIkroI5DsWGoyuxXe+VY1VwWtD9AgbXIcaTfJnCNQ7oyBFTp
 YDBO9KDN6JTRuCcu17qG78qycIp7J/wEUPcvI2RLtR06CUWFPswCp2NJb7iTaHKXy5mT
 JgbJVcdFIY4dXthIlsjEBUJ8YEu+4xKqbvO0bxs0NmWTAidlr6gm4scfbFvSAJYavceA
 9GLTRKyz58PxU0/fTkqHil2b+7Yih4BgzapKMC5S1XXk8He8ydNAYKRE33qfVypZcQAy
 yJyeCNCKv0fq427GXrqlzo7ZAYvAmH8oOAMwG9g/I7pJlOmT8CmlO9K6/jV/21zibl2O 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gncx6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 22:43:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046MhVFq125753;
        Wed, 6 May 2020 22:43:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjnky4s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 22:43:31 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046MhDlZ011089;
        Wed, 6 May 2020 22:43:13 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 15:43:13 -0700
Date:   Wed, 6 May 2020 18:43:35 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] mm: parallelize deferred_init_memmap()
Message-ID: <20200506224335.gv3as7vuik3rtt5w@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com>
 <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
 <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org>
 <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
 <20200505014844.ulp4rtih7adtcicm@ca-dmjordan1.us.oracle.com>
 <20200505020916.mve4ijrg4z5h7eh5@ca-dmjordan1.us.oracle.com>
 <CAKgT0UdE1ex_aAyMeR3PWtVcmXL8cUtjqy0J8hLpnFm42yn82w@mail.gmail.com>
 <20200506222127.l3p2a2vjavwz2bdl@ca-dmjordan1.us.oracle.com>
 <CAKgT0UcZhnCtM4YP3L9kbtghNp9vOzSpVm5WC1164OVmRHLaMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcZhnCtM4YP3L9kbtghNp9vOzSpVm5WC1164OVmRHLaMA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 06, 2020 at 03:36:54PM -0700, Alexander Duyck wrote:
> On Wed, May 6, 2020 at 3:21 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> >
> > On Tue, May 05, 2020 at 07:55:43AM -0700, Alexander Duyck wrote:
> > > One question about this data. What is the power management
> > > configuration on the systems when you are running these tests? I'm
> > > just curious if CPU frequency scaling, C states, and turbo are
> > > enabled?
> >
> > Yes, intel_pstate is loaded in active mode without hwp and with turbo enabled
> > (those power management docs are great by the way!) and intel_idle is in use
> > too.
> >
> > > I ask because that is what I have seen usually make the
> > > difference in these kind of workloads as the throughput starts
> > > dropping off as you start seeing the core frequency lower and more
> > > cores become active.
> >
> > If I follow, you're saying there's a chance performance would improve with the
> > above disabled, but how often would a system be configured that way?  Even if
> > it were faster, the machine is configured how it's configured, or am I missing
> > your point?
> 
> I think you might be missing my point. What I was getting at is that I
> know for performance testing sometimes C states and P states get
> disabled in order to get consistent results between runs, it sounds
> like you have them enabled though. I was just wondering if you had
> disabled them or not. If they were disabled then you wouldn't get the
> benefits of turbo and as such adding more cores wouldn't come at a
> penalty, while with it enabled the first few cores should start to
> slow down as they fell out of turbo mode. So it may be part of the
> reason why you are only hitting about 10x at full core count.

All right, that makes way more sense.

> As it stands I think your code may speed up a bit if you split the
> work up based on section instead of max order. That would get rid of
> any cache bouncing you may be doing on the pageblock flags and reduce
> the overhead for splitting the work up into individual pieces since
> each piece will be bigger.

See my other mail.
