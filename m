Return-Path: <SRS0=2pnx=6U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCB8C54E49
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 22:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99BDA2075E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 22:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTekYnJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgEFWhG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 May 2020 18:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbgEFWhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 May 2020 18:37:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29924C061A0F;
        Wed,  6 May 2020 15:37:06 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t12so1780998ile.9;
        Wed, 06 May 2020 15:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EqjtatwoK6H8Lcx1Rhpj+GxNACQFKFH+9PeapNxu2JM=;
        b=MTekYnJP90JNHZTmsIuBlkEn4myBtRaTxukh4xi/ctVgI0KxdRIcicfubDzM7VNSZ1
         RGnmh3eNtWnS6SV/MGvc8hBdCQxR5ICDyfnkBTkDuDtjc9eW0Mzg+iCG6ErR8hfnkO2b
         yFHfKAQy8Q5u8XYIetUR8EACxcHMqHfa64OXKnnnPhaPPklkvNf9o6hVjGzqN2REgr6h
         TTrpAsZIxGLfpn6AhkibRAy2gsztNp7IS/7EPP2Kaq7AsykcWwzSFZXfzFQpyFXwwrdT
         xmX/YuqCf66apZ5qP/laKCkxPO7cjwyn7lyNtSqhqJRANdjsYjfmeWhoeTvMeiUeIA/L
         xMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EqjtatwoK6H8Lcx1Rhpj+GxNACQFKFH+9PeapNxu2JM=;
        b=SS4dpuFzNWOtGBbnQhVbuu8FrurbkR3rpe2lVMcWcHOhbtoDRhVx19NeFT2Hf3DPt2
         2KLQmM3xzgBNTpdalZsK8Xj5inMZDWqPQ/XVtLAEhSsxxXZ64B3bn1E9F8ZFdECYgpyT
         VoSI64lfFlj5XDcraA8BeuZuCML8VBTqQnUK9ghcPMFM96JcRJ2+Oh0AamkKH3sR6keB
         DjyUQks4xtQPJrW0D5gQGMia3CGWD55U9nLVyDUo/h8gmRW/YLdoBCFAi8qTgV2uLVsd
         1yTiWPHIa/DGnoUY7jXouGuTDdWW2tfOnayZJK6yh3u+KXgl3tj3Ot81iXHwCLjhDyBq
         K/5A==
X-Gm-Message-State: AGi0PubHpmkv11JFryR2BfGKyEkBNT+PbXkH5c5JZECkdBg1td30d07d
        vq0LAnEiNwlUyOHrwQIP1Inv5dPhXfcZBeGf0w0=
X-Google-Smtp-Source: APiQypJh1i3df2NxoyGwheWAG3Ch1BHPcr0BNM6f4zyqUF6px9kD/RgBXFKKX/b6OduGEY0oNq/GyoKLcUIe4Bk+1bQ=
X-Received: by 2002:a92:858b:: with SMTP id f133mr10241065ilh.97.1588804625313;
 Wed, 06 May 2020 15:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com> <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
 <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org> <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
 <20200505014844.ulp4rtih7adtcicm@ca-dmjordan1.us.oracle.com>
 <20200505020916.mve4ijrg4z5h7eh5@ca-dmjordan1.us.oracle.com>
 <CAKgT0UdE1ex_aAyMeR3PWtVcmXL8cUtjqy0J8hLpnFm42yn82w@mail.gmail.com> <20200506222127.l3p2a2vjavwz2bdl@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20200506222127.l3p2a2vjavwz2bdl@ca-dmjordan1.us.oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 6 May 2020 15:36:54 -0700
Message-ID: <CAKgT0UcZhnCtM4YP3L9kbtghNp9vOzSpVm5WC1164OVmRHLaMA@mail.gmail.com>
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

On Wed, May 6, 2020 at 3:21 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Tue, May 05, 2020 at 07:55:43AM -0700, Alexander Duyck wrote:
> > One question about this data. What is the power management
> > configuration on the systems when you are running these tests? I'm
> > just curious if CPU frequency scaling, C states, and turbo are
> > enabled?
>
> Yes, intel_pstate is loaded in active mode without hwp and with turbo enabled
> (those power management docs are great by the way!) and intel_idle is in use
> too.
>
> > I ask because that is what I have seen usually make the
> > difference in these kind of workloads as the throughput starts
> > dropping off as you start seeing the core frequency lower and more
> > cores become active.
>
> If I follow, you're saying there's a chance performance would improve with the
> above disabled, but how often would a system be configured that way?  Even if
> it were faster, the machine is configured how it's configured, or am I missing
> your point?

I think you might be missing my point. What I was getting at is that I
know for performance testing sometimes C states and P states get
disabled in order to get consistent results between runs, it sounds
like you have them enabled though. I was just wondering if you had
disabled them or not. If they were disabled then you wouldn't get the
benefits of turbo and as such adding more cores wouldn't come at a
penalty, while with it enabled the first few cores should start to
slow down as they fell out of turbo mode. So it may be part of the
reason why you are only hitting about 10x at full core count.

As it stands I think your code may speed up a bit if you split the
work up based on section instead of max order. That would get rid of
any cache bouncing you may be doing on the pageblock flags and reduce
the overhead for splitting the work up into individual pieces since
each piece will be bigger.
