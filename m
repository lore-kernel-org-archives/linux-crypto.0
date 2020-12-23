Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BE9C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 21:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 565E922273
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 21:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgLWVcb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 16:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLWVcb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 16:32:31 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0F9C0617A6
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 13:31:41 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id 75so346294ilv.13
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 13:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbxsWfgRlzCJgOBxqB1SwxZEGeePTfdrMkj+YGC6JAo=;
        b=Z9K6Fn4hT/nSk9i8CErJ6bmQCsMMOcNp7Bt7j+01+MHkB6QJ/NqED08RvBk4ZkwDs4
         ep+q+MMmoC3gCyMErKrgsjZHvjFx7zubx/VOHVC5THt50fvDcCaq04C137s/L91FSa6l
         XfRTwdgR+Q1Kz7Yulcnw4FYxkwjUFPJX9v73k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbxsWfgRlzCJgOBxqB1SwxZEGeePTfdrMkj+YGC6JAo=;
        b=TStz7Z7fEAoEYFyQbUkUjrL3Euv/AI0mTuw9P5X1WeuNEitXP+Q885XQNTSc8bYtDc
         a3cBNHbOXUe/B40tjAq6TnZsHAQxxgEyxFEAYLq1oRTYLJukZpEO7MD6w8qQ4biW3Fhb
         RCSgS37zOvKiRLs9nqYrpC39lU7QH2tfNdtR6e4FtI+Gu/NMYnfem4WLbKxlwNzVTGiQ
         U47+6OeEigOcRSt1cPR2ik39Ornws2OLpO9/xLzDOon/8gH2Pcc20gHqR6khImPA8YpR
         C8BY+p7SuuqJqQozg3kpA9YZkJfkZGWtB2Ucuaz5oSUU0JPJkUO4YoMfYM8YZD18njLp
         DAJw==
X-Gm-Message-State: AOAM532V6SWU5q8UIhnEilSoRBOYIiz29APNquFGG6232FBTFIb8dzPN
        /ChYkDiyG2OKDKjy8gZWW6jPi7svvpHK/zxtk3R7pA==
X-Google-Smtp-Source: ABdhPJw7V/eEElU2vOuKPcbbwjTNnQSkE2GjRl2RJ/IHsDvus/FqzOOyUqBW6cMF5+UWgLfMLa4buvJS20HzeW05lDI=
X-Received: by 2002:a05:6e02:10c3:: with SMTP id s3mr27679093ilj.269.1608759100500;
 Wed, 23 Dec 2020 13:31:40 -0800 (PST)
MIME-Version: 1.0
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
 <74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
 <CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com> <fc27dc51-65a7-f2fa-6b29-01a1d5eaec6c@maciej.szmigiero.name>
In-Reply-To: <fc27dc51-65a7-f2fa-6b29-01a1d5eaec6c@maciej.szmigiero.name>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 23 Dec 2020 21:31:29 +0000
Message-ID: <CALrw=nEuMx4YDCFEa89kxn-pw+65h61g1grSsvY8sd=JeGAHjA@mail.gmail.com>
Subject: Re: dm-crypt with no_read_workqueue and no_write_workqueue + btrfs
 scrub = BUG()
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Alasdair G Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team <kernel-team@cloudflare.com>,
        Nobuto Murata <nobuto.murata@canonical.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 23, 2020 at 9:20 PM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
>
> On 23.12.2020 22:09, Ignat Korchagin wrote:
> (..)
> > I've been looking into this for the last couple of days because of
> > other reports [1].
> > Just finished testing a possible solution. Will submit soon.
>
> Thanks for looking into it.
>
> By the way, on a bare metal I am actually hitting a different problem
> (scheduling while atomic) when scrubbing a btrfs filesystem, just as one
> of your users from that GitHub report had [1].

That is because dm-crypt calls "wait_for_completion" in rare cases
when Crypto API (cryptd) backlogs the decryption request. I've
reproduced that one as well (even with no FS).
We never hit these problems in the original testing probably due to
the fact we mostly used xtsproxy custom crypto module, which is
totally synchronous.
I did test it later with standard crypto, but did not encounter these
problems as well most likely because it is also depends which storage
driver underneath we are using: most of them do not submit read
requests to dm-crypt in irq/softirq context in the first place

> I've pasted that backtrace in my original Dec 14 message.
>
> Thanks,
> Maciej
>
> [1]: https://github.com/cloudflare/linux/issues/1#issuecomment-736734243

Regards,
Ignat
