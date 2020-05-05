Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA11C3A5A9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 02:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EC9206D7
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 02:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Otm4amx9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEECMo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 22:12:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgEECMn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 22:12:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04529enq048881;
        Tue, 5 May 2020 02:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lVKBNME8NJj6ZpopdgFkQ+iNkRORu46exO/01/KF0Vs=;
 b=Otm4amx90nPq2D8dA3V63mup9ZoB/4gYpNZ5nE1a8E2myKw6a7doDycHN3v/mKYb5pEA
 xn39xZSzRQcapN1PuQdEDNvaxxZZZIGEHDZ0vE/mdOfFTOgZCHqdsZx3HQhWSCsRIIlg
 xsb0KO/yIoRh8yvqB8RdqLsDTD1V0wi7Yvxx40VLuAoz2dxZ5syQq2Mt0JNQbk/ZVO97
 6hmnmz+tTDYs9H9jRgOz/X7dbTL++BKLLaH4hZgogzaad7fPxrZZONaZG5sCDZyEht8V
 DLNzP5rVfK7O1MLDXakCf5sM+BgVQdJmC5zNO45SCVzKvMWkMHQT+P4MNbHLx6a5wOI+ 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r26vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 02:11:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04526o22176015;
        Tue, 5 May 2020 02:09:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrwuqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 02:09:05 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04528tjn007418;
        Tue, 5 May 2020 02:08:56 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 19:08:55 -0700
Date:   Mon, 4 May 2020 22:09:16 -0400
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
Message-ID: <20200505020916.mve4ijrg4z5h7eh5@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com>
 <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
 <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org>
 <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
 <20200505014844.ulp4rtih7adtcicm@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505014844.ulp4rtih7adtcicm@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050013
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 04, 2020 at 09:48:44PM -0400, Daniel Jordan wrote:
> On Mon, May 04, 2020 at 05:40:19PM -0700, Alexander Duyck wrote:
> > On Mon, May 4, 2020 at 4:44 PM Josh Triplett <josh@joshtriplett.org> wrote:
> > >
> > > On May 4, 2020 3:33:58 PM PDT, Alexander Duyck <alexander.duyck@gmail.com> wrote:
> > > >On Thu, Apr 30, 2020 at 1:12 PM Daniel Jordan
> > > ><daniel.m.jordan@oracle.com> wrote:
> > > >>         /*
> > > >> -        * Initialize and free pages in MAX_ORDER sized increments so
> > > >> -        * that we can avoid introducing any issues with the buddy
> > > >> -        * allocator.
> > > >> +        * More CPUs always led to greater speedups on tested
> > > >systems, up to
> > > >> +        * all the nodes' CPUs.  Use all since the system is
> > > >otherwise idle now.
> > > >>          */
> > > >
> > > >I would be curious about your data. That isn't what I have seen in the
> > > >past. Typically only up to about 8 or 10 CPUs gives you any benefit,
> > > >beyond that I was usually cache/memory bandwidth bound.
> 
> On Skylake it took more than 8 or 10 CPUs, though on other machines the benefit
> of using all versus half or 3/4 of the CPUs is less significant.
> 
> Given that the rest of the system is idle at this point, my main concern is
> whether other archs regress past a certain thread count.

Reposting the data to be consistent with the way the percentages are reported
in the changelog.


    Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
      2 nodes * 26 cores * 2 threads = 104 CPUs
      384G/node = 768G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   4056.7 (  5.5)         --   1763.3 (  4.2)
       2% (  1)      -2.4%   4153.3 (  2.5)      -5.6%   1861.7 (  5.5)
      12% (  6)      35.0%   2637.7 ( 38.7)      80.3%    346.7 ( 37.5)
      25% ( 13)      38.4%   2497.3 ( 38.5)      88.1%    210.0 ( 41.8)
      37% ( 19)      38.9%   2477.0 ( 19.0)      89.5%    185.3 ( 21.5)
      50% ( 26)      39.1%   2471.7 ( 21.4)      89.8%    179.7 ( 25.8)
      75% ( 39)      39.5%   2455.7 ( 33.2)      90.8%    161.7 ( 29.3)
     100% ( 52)      39.9%   2436.7 (  2.1)      91.8%    144.3 (  5.9)
    
    
    Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
      1 node * 16 cores * 2 threads = 32 CPUs
      192G/node = 192G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1957.3 ( 14.0)         --   1093.7 ( 12.9)
       3% (  1)       1.4%   1930.7 ( 10.0)       3.7%   1053.3 (  7.6)
      12% (  4)      41.2%   1151.7 (  9.0)      74.5%    278.7 (  0.6)
      25% (  8)      46.3%   1051.0 (  7.8)      83.7%    178.0 (  2.6)
      38% ( 12)      48.7%   1003.3 (  7.6)      87.0%    141.7 (  3.8)
      50% ( 16)      48.2%   1014.3 ( 20.0)      87.8%    133.3 (  3.2)
      75% ( 24)      49.5%    989.3 (  6.7)      88.4%    126.3 (  1.5)
     100% ( 32)      49.1%    996.0 (  7.2)      88.4%    127.3 (  5.1)
    
    
    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
      2 nodes * 18 cores * 2 threads = 72 CPUs
      128G/node = 256G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1666.0 (  3.5)         --    618.0 (  3.5)
       3% (  1)       1.0%   1649.7 (  1.5)       2.9%    600.0 (  1.0)
      11% (  4)      25.9%   1234.7 ( 21.4)      70.4%    183.0 ( 22.5)
      25% (  9)      29.6%   1173.0 ( 10.0)      80.7%    119.3 (  9.6)
      36% ( 13)      30.8%   1153.7 ( 17.0)      84.0%     99.0 ( 15.6)
      50% ( 18)      31.0%   1150.3 ( 15.5)      84.3%     97.3 ( 16.2)
      75% ( 27)      31.0%   1150.3 (  2.5)      84.6%     95.0 (  5.6)
     100% ( 36)      31.3%   1145.3 (  1.5)      85.6%     89.0 (  1.7)
    
    
    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 8 cores * 2 threads = 16 CPUs
      64G/node = 64G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1029.7 ( 42.3)         --    253.7 (  3.1)
       6% (  1)       3.3%    995.3 ( 21.4)       4.3%    242.7 (  5.5)
      12% (  2)      14.0%    885.7 ( 24.4)      46.4%    136.0 (  5.2)
      25% (  4)      18.9%    835.0 ( 21.5)      66.1%     86.0 (  1.7)
      38% (  6)      21.9%    804.7 ( 15.7)      71.4%     72.7 (  2.1)
      50% (  8)      20.8%    815.3 ( 11.7)      74.4%     65.0 (  3.5)
      75% ( 12)      23.5%    787.7 (  2.1)      74.0%     66.0 (  3.6)
     100% ( 16)      23.3%    789.3 ( 15.0)      76.3%     60.0 (  5.6)
    
    
    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      16G/node = 16G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --    757.7 ( 17.1)         --     57.0 (  0.0)
      25% (  1)      -1.0%    765.3 (  5.5)       3.5%     55.0 (  0.0)
      50% (  2)       4.7%    722.3 ( 21.5)      42.7%     32.7 (  4.6)
      75% (  3)       3.7%    729.7 (  4.9)      54.4%     26.0 (  0.0)
     100% (  4)       6.2%    710.3 ( 15.0)      63.2%     21.0 (  0.0)
    
    
    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      14G/node = 14G memory
    
                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --    656.3 (  7.1)         --     57.3 (  1.5)
      25% (  1)       1.8%    644.7 (  3.1)       0.6%     57.0 (  0.0)
      50% (  2)       6.5%    613.7 (  5.1)      40.7%     34.0 (  5.3)
      75% (  3)       6.9%    611.3 (  6.7)      57.6%     24.3 (  0.6)
     100% (  4)       8.6%    599.7 (  5.9)      62.8%     21.3 (  1.2)


> > > I've found pretty much linear performance up to memory bandwidth, and on the systems I was testing, I didn't saturate memory bandwidth until about the full number of physical cores. From number of cores up to number of threads, the performance stayed about flat; it didn't get any better or worse.
> > 
> > That doesn't sound right though based on the numbers you provided. The
> > system you had was 192GB spread over 2 nodes with 48thread/24core per
> > node, correct? Your numbers went from ~290ms to ~28ms so a 10x
> > decrease, that doesn't sound linear when you spread the work over 24
> > cores to get there. I agree that the numbers largely stay flat once
> > you hit the peak, I have seen similar behavior when I was working on
> > the deferred init code previously. One concern I have though is that
> > we may end up seeing better performance with a subset of cores instead
> > of running all of the cores/threads, especially if features such as
> > turbo come into play. In addition we are talking x86 only so far. I
> > would be interested in seeing if this has benefits or not for other
> > architectures.
> > 
> > Also what is the penalty that is being paid in order to break up the
> > work before-hand and set it up for the parallel work? I would be
> > interested in seeing what the cost is on a system with fewer cores per
> > node, maybe even down to 1. That would tell us how much additional
> > overhead is being added to set things up to run in parallel.
> 
> The numbers above have the 1-thread case.  It seems close to the noise.
> 
> > If I get
> > a chance tomorrow I might try applying the patches and doing some
> > testing myself.
> 
> If you end up doing that, you might find this helpful:
>     https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=patch;h=afc72bf8478b95a1d6d174c269ff3693c60630e0
>     
> and maybe this:
>     https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=patch;h=dff6537eab281e5a9917682c4adf9059c0574223
> 
> Thanks for looking this over.
> 
> [ By the way, I'm going to be out Tuesday but back the rest of the week. ]
> 
