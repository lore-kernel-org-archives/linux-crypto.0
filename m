Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17A0C47254
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 14:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4EC8206B9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 14:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MASQ4qXl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgEEOz4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 10:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbgEEOzz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 10:55:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFA4C061A0F;
        Tue,  5 May 2020 07:55:55 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c16so2548066ilr.3;
        Tue, 05 May 2020 07:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NS/Er7IwWIFbzDl21PFz+7Gm89txLKeh/GpsaYNLu/8=;
        b=MASQ4qXlT2eIHPvFrXugI0zcu+DRET4XmbvoUi2Ju7BXVrYwoFayqf8JrrpIOwk9eC
         8GJYfZP1auWX5ho8tdQtPy8dKNC+05FajiP+JH+yVZIFonzC3V3Pg2i9SH0vUw8ZK5Dm
         /hhgo8RnHq4wmp+ebifVMCs8SstI10KfzLTb5A0xa74N5s+y2M/gG+hQHmuPYxNHTYrq
         5ZIXvVWgpe6HytRSYhYeg1V4lENm4NxPY9zhfjY/Tsi4BAJR7uEubg7HN0P1hkteU/l1
         ZtEVOh+UtMbRTkKRFwILRQ6DS+QUA7McGrBgFfKM1p25twMwiO7ZBCHPADaKdKGTh6XS
         vj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NS/Er7IwWIFbzDl21PFz+7Gm89txLKeh/GpsaYNLu/8=;
        b=ocvCv4wn/0SBjX65WRMgll0DVVzPQ11NquKRcKVlApQY8i7P/Q7//YYx2HQG5RB7Kb
         72pYjiwYqyq2eOvdZzNqx8EC+Z1kQgPNF/vFEMMqRillVONC1Uq7e3nh7nuIY/3wpILJ
         wNLNoAgSgE0lm7EPxFhrARCndosYABNPJFmElZtUUxFoXE9Aln6wL7Qd8i3WcRPU8qnG
         9vVhL+764PFUC9lbnfupt5tCXbR/nUsk7Z+PN+zSxFKsco4SufygFZ9LKNHO48+yKkH1
         y8EYJPH1mOHS+czN6kzXfzUmJQg6ckuQGrXsWVo1j56kYfNhxZKf432pALflPHcJvfx4
         GOAA==
X-Gm-Message-State: AGi0Pub1onli2ba6eLCDstL2Si4EfHpWCRjoYk5mV3EAQ++lg1ZHm1/F
        QrLI0jnmXxtko0IEjjDjDy7p1qQH1zhHOTPD8F4=
X-Google-Smtp-Source: APiQypKZDkvZEoUsnmz58MqpVMx474ZJ0f6dVp/7meZiwf5sp2yDk/zovIWKo1xxBl8RhBEJzUAlaSxGinuIbGdC9+Q=
X-Received: by 2002:a92:3dd5:: with SMTP id k82mr4122003ilf.237.1588690554407;
 Tue, 05 May 2020 07:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com> <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
 <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org> <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
 <20200505014844.ulp4rtih7adtcicm@ca-dmjordan1.us.oracle.com> <20200505020916.mve4ijrg4z5h7eh5@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200505020916.mve4ijrg4z5h7eh5@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 5 May 2020 07:55:43 -0700
Message-ID: <CAKgT0UdE1ex_aAyMeR3PWtVcmXL8cUtjqy0J8hLpnFm42yn82w@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm: parallelize deferred_init_memmap()
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Josh Triplett <josh@joshtriplett.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 4, 2020 at 7:11 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Mon, May 04, 2020 at 09:48:44PM -0400, Daniel Jordan wrote:
> > On Mon, May 04, 2020 at 05:40:19PM -0700, Alexander Duyck wrote:
> > > On Mon, May 4, 2020 at 4:44 PM Josh Triplett <josh@joshtriplett.org> wrote:
> > > >
> > > > On May 4, 2020 3:33:58 PM PDT, Alexander Duyck <alexander.duyck@gmail.com> wrote:
> > > > >On Thu, Apr 30, 2020 at 1:12 PM Daniel Jordan
> > > > ><daniel.m.jordan@oracle.com> wrote:
> > > > >>         /*
> > > > >> -        * Initialize and free pages in MAX_ORDER sized increments so
> > > > >> -        * that we can avoid introducing any issues with the buddy
> > > > >> -        * allocator.
> > > > >> +        * More CPUs always led to greater speedups on tested
> > > > >systems, up to
> > > > >> +        * all the nodes' CPUs.  Use all since the system is
> > > > >otherwise idle now.
> > > > >>          */
> > > > >
> > > > >I would be curious about your data. That isn't what I have seen in the
> > > > >past. Typically only up to about 8 or 10 CPUs gives you any benefit,
> > > > >beyond that I was usually cache/memory bandwidth bound.
> >
> > On Skylake it took more than 8 or 10 CPUs, though on other machines the benefit
> > of using all versus half or 3/4 of the CPUs is less significant.
> >
> > Given that the rest of the system is idle at this point, my main concern is
> > whether other archs regress past a certain thread count.
>
> Reposting the data to be consistent with the way the percentages are reported
> in the changelog.
>
>
>     Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
>       2 nodes * 26 cores * 2 threads = 104 CPUs
>       384G/node = 768G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>           (  0)         --   4056.7 (  5.5)         --   1763.3 (  4.2)
>        2% (  1)      -2.4%   4153.3 (  2.5)      -5.6%   1861.7 (  5.5)
>       12% (  6)      35.0%   2637.7 ( 38.7)      80.3%    346.7 ( 37.5)
>       25% ( 13)      38.4%   2497.3 ( 38.5)      88.1%    210.0 ( 41.8)
>       37% ( 19)      38.9%   2477.0 ( 19.0)      89.5%    185.3 ( 21.5)
>       50% ( 26)      39.1%   2471.7 ( 21.4)      89.8%    179.7 ( 25.8)
>       75% ( 39)      39.5%   2455.7 ( 33.2)      90.8%    161.7 ( 29.3)
>      100% ( 52)      39.9%   2436.7 (  2.1)      91.8%    144.3 (  5.9)
>
>
>     Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
>       1 node * 16 cores * 2 threads = 32 CPUs
>       192G/node = 192G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>           (  0)         --   1957.3 ( 14.0)         --   1093.7 ( 12.9)
>        3% (  1)       1.4%   1930.7 ( 10.0)       3.7%   1053.3 (  7.6)
>       12% (  4)      41.2%   1151.7 (  9.0)      74.5%    278.7 (  0.6)
>       25% (  8)      46.3%   1051.0 (  7.8)      83.7%    178.0 (  2.6)
>       38% ( 12)      48.7%   1003.3 (  7.6)      87.0%    141.7 (  3.8)
>       50% ( 16)      48.2%   1014.3 ( 20.0)      87.8%    133.3 (  3.2)
>       75% ( 24)      49.5%    989.3 (  6.7)      88.4%    126.3 (  1.5)
>      100% ( 32)      49.1%    996.0 (  7.2)      88.4%    127.3 (  5.1)
>
>
>     Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
>       2 nodes * 18 cores * 2 threads = 72 CPUs
>       128G/node = 256G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>           (  0)         --   1666.0 (  3.5)         --    618.0 (  3.5)
>        3% (  1)       1.0%   1649.7 (  1.5)       2.9%    600.0 (  1.0)
>       11% (  4)      25.9%   1234.7 ( 21.4)      70.4%    183.0 ( 22.5)
>       25% (  9)      29.6%   1173.0 ( 10.0)      80.7%    119.3 (  9.6)
>       36% ( 13)      30.8%   1153.7 ( 17.0)      84.0%     99.0 ( 15.6)
>       50% ( 18)      31.0%   1150.3 ( 15.5)      84.3%     97.3 ( 16.2)
>       75% ( 27)      31.0%   1150.3 (  2.5)      84.6%     95.0 (  5.6)
>      100% ( 36)      31.3%   1145.3 (  1.5)      85.6%     89.0 (  1.7)
>
>
>     AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
>       1 node * 8 cores * 2 threads = 16 CPUs
>       64G/node = 64G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>           (  0)         --   1029.7 ( 42.3)         --    253.7 (  3.1)
>        6% (  1)       3.3%    995.3 ( 21.4)       4.3%    242.7 (  5.5)
>       12% (  2)      14.0%    885.7 ( 24.4)      46.4%    136.0 (  5.2)
>       25% (  4)      18.9%    835.0 ( 21.5)      66.1%     86.0 (  1.7)
>       38% (  6)      21.9%    804.7 ( 15.7)      71.4%     72.7 (  2.1)
>       50% (  8)      20.8%    815.3 ( 11.7)      74.4%     65.0 (  3.5)
>       75% ( 12)      23.5%    787.7 (  2.1)      74.0%     66.0 (  3.6)
>      100% ( 16)      23.3%    789.3 ( 15.0)      76.3%     60.0 (  5.6)
>
>
>     AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
>       1 node * 2 cores * 2 threads = 4 CPUs
>       16G/node = 16G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>           (  0)         --    757.7 ( 17.1)         --     57.0 (  0.0)
>       25% (  1)      -1.0%    765.3 (  5.5)       3.5%     55.0 (  0.0)
>       50% (  2)       4.7%    722.3 ( 21.5)      42.7%     32.7 (  4.6)
>       75% (  3)       3.7%    729.7 (  4.9)      54.4%     26.0 (  0.0)
>      100% (  4)       6.2%    710.3 ( 15.0)      63.2%     21.0 (  0.0)
>
>
>     Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
>       1 node * 2 cores * 2 threads = 4 CPUs
>       14G/node = 14G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>           (  0)         --    656.3 (  7.1)         --     57.3 (  1.5)
>       25% (  1)       1.8%    644.7 (  3.1)       0.6%     57.0 (  0.0)
>       50% (  2)       6.5%    613.7 (  5.1)      40.7%     34.0 (  5.3)
>       75% (  3)       6.9%    611.3 (  6.7)      57.6%     24.3 (  0.6)
>      100% (  4)       8.6%    599.7 (  5.9)      62.8%     21.3 (  1.2)

One question about this data. What is the power management
configuration on the systems when you are running these tests? I'm
just curious if CPU frequency scaling, C states, and turbo are
enabled? I ask because that is what I have seen usually make the
difference in these kind of workloads as the throughput starts
dropping off as you start seeing the core frequency lower and more
cores become active.
