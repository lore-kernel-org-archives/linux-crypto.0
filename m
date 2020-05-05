Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF73C3A5A9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 01:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C564E20705
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 01:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iNB6FJV6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgEEBtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 21:49:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41892 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgEEBtP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 21:49:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451mbVm120792;
        Tue, 5 May 2020 01:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=esa1b1qNCywCas2lY0NTLlSB9GKx5dhhlyjR07e85IU=;
 b=iNB6FJV6syh8kcnTOhJZZjY8aaL3Y52paEnq5NdWwWKhAaw6dvXQjqNtonIrB0llqfKc
 a2IXrB8dgY9DhBW+NOxcas/g8ryeczMipKpVcwVZDBj6wHymi6HzLFMJsjYrLN7lagXO
 hY2uJZSxpm42f3SIRRIJImnK7jTRPLkX0QK0lrHUUHg1IQERkKlrQqTmz3oE54tWf+9d
 5tRlStHN+Vl0jW76lJp8yCYu4GPT4TukNOJ49SZPpWuQr7/XkLM3PlRoJNLdRD0cXn7l
 ka6PkREcup39pzC45TOtsaWpGVoPV8aVFgrX5X128JSYERLgG4dUEDZowyMXmd8c6vr6 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn1xpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:48:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451mXSt079427;
        Tue, 5 May 2020 01:48:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjxcpdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:48:36 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451mMGF000691;
        Tue, 5 May 2020 01:48:22 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:48:22 -0700
Date:   Mon, 4 May 2020 21:48:44 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
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
Message-ID: <20200505014844.ulp4rtih7adtcicm@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com>
 <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
 <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org>
 <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050010
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 04, 2020 at 05:40:19PM -0700, Alexander Duyck wrote:
> On Mon, May 4, 2020 at 4:44 PM Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > On May 4, 2020 3:33:58 PM PDT, Alexander Duyck <alexander.duyck@gmail.com> wrote:
> > >On Thu, Apr 30, 2020 at 1:12 PM Daniel Jordan
> > ><daniel.m.jordan@oracle.com> wrote:
> > >>         /*
> > >> -        * Initialize and free pages in MAX_ORDER sized increments so
> > >> -        * that we can avoid introducing any issues with the buddy
> > >> -        * allocator.
> > >> +        * More CPUs always led to greater speedups on tested
> > >systems, up to
> > >> +        * all the nodes' CPUs.  Use all since the system is
> > >otherwise idle now.
> > >>          */
> > >
> > >I would be curious about your data. That isn't what I have seen in the
> > >past. Typically only up to about 8 or 10 CPUs gives you any benefit,
> > >beyond that I was usually cache/memory bandwidth bound.

On Skylake it took more than 8 or 10 CPUs, though on other machines the benefit
of using all versus half or 3/4 of the CPUs is less significant.

Given that the rest of the system is idle at this point, my main concern is
whether other archs regress past a certain thread count.


    Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
      2 nodes * 26 cores * 2 threads = 104 CPUs
      384G/node = 768G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   4056.7 (  5.5)         --   1763.3 (  4.2)
          (  1)      -2.3%   4153.3 (  2.5)      -5.3%   1861.7 (  5.5)
      12% (  6)      53.8%   2637.7 ( 38.7)     408.7%    346.7 ( 37.5)
      25% ( 13)      62.4%   2497.3 ( 38.5)     739.7%    210.0 ( 41.8)
      37% ( 19)      63.8%   2477.0 ( 19.0)     851.4%    185.3 ( 21.5)
      50% ( 26)      64.1%   2471.7 ( 21.4)     881.4%    179.7 ( 25.8)
      75% ( 39)      65.2%   2455.7 ( 33.2)     990.7%    161.7 ( 29.3)
     100% ( 52)      66.5%   2436.7 (  2.1)    1121.7%    144.3 (  5.9)


    Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
      1 node * 16 cores * 2 threads = 32 CPUs
      192G/node = 192G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1957.3 ( 14.0)         --   1093.7 ( 12.9)
          (  1)       1.4%   1930.7 ( 10.0)       3.8%   1053.3 (  7.6)
      12% (  4)      70.0%   1151.7 (  9.0)     292.5%    278.7 (  0.6)
      25% (  8)      86.2%   1051.0 (  7.8)     514.4%    178.0 (  2.6)
      37% ( 12)      95.1%   1003.3 (  7.6)     672.0%    141.7 (  3.8)
      50% ( 16)      93.0%   1014.3 ( 20.0)     720.2%    133.3 (  3.2)
      75% ( 24)      97.8%    989.3 (  6.7)     765.7%    126.3 (  1.5)
     100% ( 32)      96.5%    996.0 (  7.2)     758.9%    127.3 (  5.1)
    

    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
      2 nodes * 18 cores * 2 threads = 72 CPUs
      128G/node = 256G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1666.0 (  3.5)         --    618.0 (  3.5)
          (  1)       1.0%   1649.7 (  1.5)       3.0%    600.0 (  1.0)
      12% (  4)      34.9%   1234.7 ( 21.4)     237.7%    183.0 ( 22.5)
      25% (  9)      42.0%   1173.0 ( 10.0)     417.9%    119.3 (  9.6)
      37% ( 13)      44.4%   1153.7 ( 17.0)     524.2%     99.0 ( 15.6)
      50% ( 18)      44.8%   1150.3 ( 15.5)     534.9%     97.3 ( 16.2)
      75% ( 27)      44.8%   1150.3 (  2.5)     550.5%     95.0 (  5.6)
     100% ( 36)      45.5%   1145.3 (  1.5)     594.4%     89.0 (  1.7)
    

    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 8 cores * 2 threads = 16 CPUs
      64G/node = 64G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1029.7 ( 42.3)         --    253.7 (  3.1)
          (  1)       3.4%    995.3 ( 21.4)       4.5%    242.7 (  5.5)
      12% (  2)      16.3%    885.7 ( 24.4)      86.5%    136.0 (  5.2)
      25% (  4)      23.3%    835.0 ( 21.5)     195.0%     86.0 (  1.7)
      37% (  6)      28.0%    804.7 ( 15.7)     249.1%     72.7 (  2.1)
      50% (  8)      26.3%    815.3 ( 11.7)     290.3%     65.0 (  3.5)
      75% ( 12)      30.7%    787.7 (  2.1)     284.3%     66.0 (  3.6)
     100% ( 16)      30.4%    789.3 ( 15.0)     322.8%     60.0 (  5.6)
    
    
    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      16G/node = 16G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --    757.7 ( 17.1)         --     57.0 (  0.0)
      25% (  1)      -1.0%    765.3 (  5.5)       3.6%     55.0 (  0.0)
      50% (  2)       4.9%    722.3 ( 21.5)      74.5%     32.7 (  4.6)
      75% (  3)       3.8%    729.7 (  4.9)     119.2%     26.0 (  0.0)
     100% (  4)       6.7%    710.3 ( 15.0)     171.4%     21.0 (  0.0)
    

    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      14G/node = 14G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --    656.3 (  7.1)         --     57.3 (  1.5)
      25% (  1)       1.8%    644.7 (  3.1)       0.6%     57.0 (  0.0)
      50% (  2)       7.0%    613.7 (  5.1)      68.6%     34.0 (  5.3)
      75% (  3)       7.4%    611.3 (  6.7)     135.6%     24.3 (  0.6)
     100% (  4)       9.4%    599.7 (  5.9)     168.8%     21.3 (  1.2)


> > I've found pretty much linear performance up to memory bandwidth, and on the systems I was testing, I didn't saturate memory bandwidth until about the full number of physical cores. From number of cores up to number of threads, the performance stayed about flat; it didn't get any better or worse.
> 
> That doesn't sound right though based on the numbers you provided. The
> system you had was 192GB spread over 2 nodes with 48thread/24core per
> node, correct? Your numbers went from ~290ms to ~28ms so a 10x
> decrease, that doesn't sound linear when you spread the work over 24
> cores to get there. I agree that the numbers largely stay flat once
> you hit the peak, I have seen similar behavior when I was working on
> the deferred init code previously. One concern I have though is that
> we may end up seeing better performance with a subset of cores instead
> of running all of the cores/threads, especially if features such as
> turbo come into play. In addition we are talking x86 only so far. I
> would be interested in seeing if this has benefits or not for other
> architectures.
> 
> Also what is the penalty that is being paid in order to break up the
> work before-hand and set it up for the parallel work? I would be
> interested in seeing what the cost is on a system with fewer cores per
> node, maybe even down to 1. That would tell us how much additional
> overhead is being added to set things up to run in parallel.

The numbers above have the 1-thread case.  It seems close to the noise.

> If I get
> a chance tomorrow I might try applying the patches and doing some
> testing myself.

If you end up doing that, you might find this helpful:
    https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=patch;h=afc72bf8478b95a1d6d174c269ff3693c60630e0
    
and maybe this:
    https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=patch;h=dff6537eab281e5a9917682c4adf9059c0574223

Thanks for looking this over.

[ By the way, I'm going to be out Tuesday but back the rest of the week. ]
