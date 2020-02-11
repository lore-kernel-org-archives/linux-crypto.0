Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED67C35242
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 20:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A77D20708
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 20:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aIQ4u3vp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbgBKUMx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:12:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38954 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731735AbgBKUMx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 15:12:53 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so4709496plp.6
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2020 12:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O+YlTCrlJTVX8DSxE4IzklKJKrCQ5zp/2SwquObWiWs=;
        b=aIQ4u3vp7IWSazLOv0YhwW1Z0SrsRv60EnwvwomFDDAGS0EaUThs5IHrwP+u8jx5Uw
         liDrgSew79qPv3yHPnkvuWLhPs1umkZerRIAFB4c3KYS7IFiHit6BbqBsdPwBeIbNBOl
         1AVDPSnesP46pHUt5jd+IxvZWo49vSbVbuol0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O+YlTCrlJTVX8DSxE4IzklKJKrCQ5zp/2SwquObWiWs=;
        b=S7Xzwr+B4swCfcbEFuIUWU5RUVoAaPEdDE81evDqxEj5xtBIEGLnwy5eLt6KJ6SxjH
         nl/Yb4E4WuD/1iFkYoemtkTfpB1giejkIk4cl1I7ocU7CXhd+m4qMEmLJa6sdk15UwXu
         yJce0w5q+8WyulhfBraXd+W+n+SRJ7bVUfwRM6H6Xj1+pVzvkCz0h1rpHGJqLXJKD+05
         3Qgx2Rb+DueJ5YamhLRzVv2C4mbISPN0TTx7AxlptmPebplOu8CpYHfm2ZfZrGQkbz8K
         kIU5FOsGby0tjD5PeM8bekfYFt0SjPeDcvViZfdbwiq83ecBj2glAcuBuepNrB4FEnv1
         T/3Q==
X-Gm-Message-State: APjAAAXOnfyWJm7KR3jQBOkU76sQUqCktqCTxkmCgU47aOPuweQbAIb0
        Muuon9plqA8a/Q5IzE/Hf2ZSEQ==
X-Google-Smtp-Source: APXvYqzRLaVmMHXEt33UgGXT/mQJIihdN5a7G3O3Avk/5c8ljVgfF5W7gDmWwiC3SOKdcJITd1FtuA==
X-Received: by 2002:a17:902:8d94:: with SMTP id v20mr4925424plo.259.1581451972636;
        Tue, 11 Feb 2020 12:12:52 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m26sm5151488pgc.84.2020.02.11.12.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:12:51 -0800 (PST)
Date:   Tue, 11 Feb 2020 12:12:50 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array
 member
Message-ID: <202002111210.876CEB6@keescook>
References: <20200211174126.GA29960@embeddedor>
 <20200211183229.GA1938663@kroah.com>
 <3fdbb16a-897c-aa5b-d45d-f824f6810412@embeddedor.com>
 <202002111129.77DB1CCC7B@keescook>
 <20200211193854.GA1972490@kroah.com>
 <88e09425-8207-7a1e-8802-886f9694a37f@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88e09425-8207-7a1e-8802-886f9694a37f@embeddedor.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 11, 2020 at 01:54:22PM -0600, Gustavo A. R. Silva wrote:
> 
> 
> On 2/11/20 13:38, Greg KH wrote:
> > On Tue, Feb 11, 2020 at 11:32:04AM -0800, Kees Cook wrote:
> >> On Tue, Feb 11, 2020 at 01:20:36PM -0600, Gustavo A. R. Silva wrote:
> >>>
> >>>
> >>> On 2/11/20 12:32, Greg KH wrote:
> >>>> On Tue, Feb 11, 2020 at 11:41:26AM -0600, Gustavo A. R. Silva wrote:
> >>>>> The current codebase makes use of the zero-length array language
> >>>>> extension to the C90 standard, but the preferred mechanism to declare
> >>>>> variable-length types such as these ones is a flexible array member[1][2],
> >>>>> introduced in C99:
> >>>>>
> >>>>> struct foo {
> >>>>>         int stuff;
> >>>>>         struct boo array[];
> >>>>> };
> >>>>>
> >>>>> By making use of the mechanism above, we will get a compiler warning
> >>>>> in case the flexible array does not occur last in the structure, which
> >>>>> will help us prevent some kind of undefined behavior bugs from being
> >>>>> unadvertenly introduced[3] to the codebase from now on.
> >>>>>
> >>>>> All these instances of code were found with the help of the following
> >>>>> Coccinelle script:
> >>>>>
> >>>>> @@
> >>>>> identifier S, member, array;
> >>>>> type T1, T2;
> >>>>> @@
> >>>>>
> >>>>> struct S {
> >>>>>   ...
> >>>>>   T1 member;
> >>>>>   T2 array[
> >>>>> - 0
> >>>>>   ];
> >>>>> };
> >>>>>
> >>>>> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> >>>>> [2] https://github.com/KSPP/linux/issues/21
> >>>>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> >>>>>
> >>>>> NOTE: I'll carry this in my -next tree for the v5.6 merge window.
> >>>>
> >>>> Why not carve this up into per-subsystem patches so that we can apply
> >>>> them to our 5.7-rc1 trees and then you submit the "remaining" that don't
> >>>> somehow get merged at that timeframe for 5.7-rc2?
> >>>>
> >>>
> >>> Yep, sounds good. I'll do that.
> >>
> >> FWIW, I'd just like to point out that since this is a mechanical change
> >> with no code generation differences (unlike the pre-C90 1-byte array
> >> conversions), it's a way better use of everyone's time to just splat
> >> this in all at once.
> >>
> >> That said, it looks like Gustavo is up for it, but I'd like us to
> >> generally consider these kinds of mechanical changes as being easier to
> >> manage in a single patch. (Though getting Acks tends to be a bit
> >> harder...)
> > 
> > Hey, if this is such a mechanical patch, let's get it to Linus now,
> > what's preventing that from being merged now?

Now would be a good time, yes. (Linus has wanted Acks for such things
sometimes, but those were more "risky" changes...)

> Well, the only thing is that this has never been in linux-next.

Hmm. Was it in one of your 0day-tested trees?

-- 
Kees Cook
