Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23E5C3A5A9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 00:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDD720707
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 00:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVBOX4+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgEEAkc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 20:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgEEAkb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 20:40:31 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F18C061A0E;
        Mon,  4 May 2020 17:40:31 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w6so710055ilg.1;
        Mon, 04 May 2020 17:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F2N0yw9CtjKdQBdxtCgQ9EQo5C05PfhCk6kaMbyQP8g=;
        b=kVBOX4+ioERAfmKI4jXBXAKq+7hDz0X9NL48BCmJIx9i9P+DaYsb9uEFk13CIwzZ86
         kDS3FNP05eHe+dYITHg7QdO42ehdtvjC5lUVoDV5TQ0wsibMC5z945sANd72P4ovftdC
         4l9P/1COaITBdAJEE8nj4u2SDM+PkNM4pgWEgNL/6k/6mvmyeHzw4G3V5yJwSsAIWQ2q
         ECmzZeZeQcANmXX11Ea40DHvhaOc0P5eNvVhEtApZauetHRjdKYGSFYh3amkSNdMO2Wg
         GmPNgsPuxZGiAesYP0UzOnNhcrb+D7ghov2qE06ifkBDPSkmfkiE9dSm1k0kbj98eksx
         zfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F2N0yw9CtjKdQBdxtCgQ9EQo5C05PfhCk6kaMbyQP8g=;
        b=KhuTywGfT7oTml+BPoPXoZBz9ddfo/mUnjPcGEVaf1Xspz46rZLzMf3m4H60hw0CDK
         Z2kzqNDXSzuzfRvBIkg2eTNJjYb1T0H8Q0ynPhB715tlAozzUZz43V/gXrgww11bhLFS
         askgvL1+9V4ku8VkVzCBvtBU7eOelSzlVQ/Vv0dcwJkfH1JefLurlUeOekHVDS2yZMF4
         vlAPJMfTT2ktUgoQ1SVPO6+q+ecU4aRwg7710mQUAdIcZInI6wJuEhSfL7E1uwz/zP8X
         hE9oxmS5wvMUfbdg9LuekksHcvdNoqfOpy6tjhb0l+OCZ2li06gdfPU04YOJlCZmqsmF
         FVfA==
X-Gm-Message-State: AGi0PuYDja0uAstSCgmoB70JzgqlxKMvYPKQeV4uc0FeTTQq+QdcqFy0
        eFUk8G62EFdNfCCd5wkO3vWU2vRbXLjY7fyMzy0=
X-Google-Smtp-Source: APiQypJcRt7XOS9secWqyeSwojx7NwEL4cUU4fk7R9HGOpe0IpLTzcwsqduPPi7rRjwPMMg6mVWmD+Z7Bl6O7EZZMRI=
X-Received: by 2002:a92:3dd5:: with SMTP id k82mr1178579ilf.237.1588639230609;
 Mon, 04 May 2020 17:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com> <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
 <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org>
In-Reply-To: <3C3C62BE-6363-41C3-834C-C3124EB3FFAB@joshtriplett.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 4 May 2020 17:40:19 -0700
Message-ID: <CAKgT0UdBv-Wj98P2wMFGDSihPLKWFsqpu77ZmO+eA51uteZ-Ag@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm: parallelize deferred_init_memmap()
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 4, 2020 at 4:44 PM Josh Triplett <josh@joshtriplett.org> wrote:
>
> On May 4, 2020 3:33:58 PM PDT, Alexander Duyck <alexander.duyck@gmail.com=
> wrote:
> >On Thu, Apr 30, 2020 at 1:12 PM Daniel Jordan
> ><daniel.m.jordan@oracle.com> wrote:
> >>         /*
> >> -        * Initialize and free pages in MAX_ORDER sized increments so
> >> -        * that we can avoid introducing any issues with the buddy
> >> -        * allocator.
> >> +        * More CPUs always led to greater speedups on tested
> >systems, up to
> >> +        * all the nodes' CPUs.  Use all since the system is
> >otherwise idle now.
> >>          */
> >
> >I would be curious about your data. That isn't what I have seen in the
> >past. Typically only up to about 8 or 10 CPUs gives you any benefit,
> >beyond that I was usually cache/memory bandwidth bound.
>
> I've found pretty much linear performance up to memory bandwidth, and on =
the systems I was testing, I didn't saturate memory bandwidth until about t=
he full number of physical cores. From number of cores up to number of thre=
ads, the performance stayed about flat; it didn't get any better or worse.

That doesn't sound right though based on the numbers you provided. The
system you had was 192GB spread over 2 nodes with 48thread/24core per
node, correct? Your numbers went from ~290ms to ~28ms so a 10x
decrease, that doesn't sound linear when you spread the work over 24
cores to get there. I agree that the numbers largely stay flat once
you hit the peak, I have seen similar behavior when I was working on
the deferred init code previously. One concern I have though is that
we may end up seeing better performance with a subset of cores instead
of running all of the cores/threads, especially if features such as
turbo come into play. In addition we are talking x86 only so far. I
would be interested in seeing if this has benefits or not for other
architectures.

Also what is the penalty that is being paid in order to break up the
work before-hand and set it up for the parallel work? I would be
interested in seeing what the cost is on a system with fewer cores per
node, maybe even down to 1. That would tell us how much additional
overhead is being added to set things up to run in parallel. If I get
a chance tomorrow I might try applying the patches and doing some
testing myself.

Thanks.

- Alex
