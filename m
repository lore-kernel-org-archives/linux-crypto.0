Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AABC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 20:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E405F20658
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 20:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596053216;
	bh=e0KNsMRF8PEhDQuCHiRqDtR1FSDwYF++FqK8GxV5J5U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=b00JwcW5nxHmV0+TGqBRmFiOC+kddI2Cn6JD9EYUQBebD+t5RyLFa3ZEg/9+UbjTl
	 kgqa1PQ3de8GPdch+rYj5/l69AoMSRJM8EQOoFIg7HKrw3xphzYF4xJGPMzoQlVRgO
	 eBgIMUOsAgLxsciCLjgoxNJXZ7+2s/bwRFgJLksk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgG2UG4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 16:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgG2UG4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 16:06:56 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4099420658
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2020 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596053215;
        bh=e0KNsMRF8PEhDQuCHiRqDtR1FSDwYF++FqK8GxV5J5U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=juWnMg3iFPGtQvLRVnzfiLYhsEFldz5qr1VCd08kYvKQWMYen9EVDxCmzCrhIryMX
         6Z4vk2w4Sho7nZpJYRNZ1B6LoLXH40958p04JYdxrhxS228LPR6yEDSgq8aKtUC9um
         WcJsA4dR6jH3uDjRcwHz2vVuvbBhsgDDsHa0dDAE=
Received: by mail-oi1-f181.google.com with SMTP id u63so10065374oie.5
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2020 13:06:55 -0700 (PDT)
X-Gm-Message-State: AOAM531Pq3XwK6d/CfQsJGCVYpyYrMO12AVkj33JdD+rHH+z8D75nrCQ
        qNr/J5agYawJtyL6lZAwNOEBK2w2jZkTvLvJGUg=
X-Google-Smtp-Source: ABdhPJz71qPqkHZdfw3HX5L22aHbLnrz3+gy6BaQSsm0sztt8RsoH0ufKGqi+IUiHq5h/CM0ZBDR4P7WC+jCUTtEtdk=
X-Received: by 2002:aca:cc0a:: with SMTP id c10mr9550140oig.174.1596053214596;
 Wed, 29 Jul 2020 13:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <2a55b661-512b-9479-9fff-0f2e2a581765@candelatech.com>
 <CAMj1kXFwPPDfm1hvW+LgnfuPO-wfguTZ0NcLyeyesGeBcuDKGQ@mail.gmail.com>
 <04d8e7e3-700b-44b2-e8f2-5126abf21a62@candelatech.com> <CAMj1kXFK4xkieEpjW+ekYf9am6Ob15aGsnmWJMfn=LD_4oCuXg@mail.gmail.com>
 <9e6927a6-8f70-009a-ad76-4f11a396e43a@candelatech.com>
In-Reply-To: <9e6927a6-8f70-009a-ad76-4f11a396e43a@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 29 Jul 2020 23:06:43 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEDBSfuTxi6CCPGdpdC6h+F18gutz3h2xJaGtdN8kS40Q@mail.gmail.com>
Message-ID: <CAMj1kXEDBSfuTxi6CCPGdpdC6h+F18gutz3h2xJaGtdN8kS40Q@mail.gmail.com>
Subject: Re: Help getting aesni crypto patch upstream
To:     Ben Greear <greearb@candelatech.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 29 Jul 2020 at 22:29, Ben Greear <greearb@candelatech.com> wrote:
>
> On 7/29/20 12:09 PM, Ard Biesheuvel wrote:
> > On Wed, 29 Jul 2020 at 15:27, Ben Greear <greearb@candelatech.com> wrote:
> >>
> >> On 7/28/20 11:06 PM, Ard Biesheuvel wrote:
> >>> On Wed, 29 Jul 2020 at 01:03, Ben Greear <greearb@candelatech.com> wrote:
> >>>>
> >>>> Hello,
> >>>>
> >>>> As part of my wifi test tool, I need to do decrypt AES on the CPU, and the only way this
> >>>> performs well is to use aesni.  I've been using a patch for years that does this, but
> >>>> recently somewhere between 5.4 and 5.7, the API I've been using has been removed.
> >>>>
> >>>> Would anyone be interested in getting this support upstream?  I'd be happy to pay for
> >>>> the effort.
> >>>>
> >>>> Here is the patch in question:
> >>>>
> >>>> https://github.com/greearb/linux-ct-5.7/blob/master/wip/0001-crypto-aesni-add-ccm-aes-algorithm-implementation.patch
> >>>>
> >>>> Please keep me in CC, I'm not subscribed to this list.
> >>>>
> >>>
> >>> Hi Ben,
> >>>
> >>> Recently, the x86 FPU handling was improved to remove the overhead of
> >>> preserving/restoring of the register state, so the issue that this
> >>> patch fixes may no longer exist. Did you try?
> >>>
> >>> In any case, according to the commit log on that patch, the problem is
> >>> in the MAC generation, so it might be better to add a cbcmac(aes)
> >>> implementation only, and not duplicate all the CCM boilerplate.
> >>>
> >>
> >> Hello,
> >>
> >> I don't know all of the details, and do not understand the crypto subsystem,
> >> but I am pretty sure that I need at least some of this patch.
> >>
> >
> > Whether this is true is what I am trying to get clarified.
> >
> > Your patch works around a performance bottleneck related to the use of
> > AES-NI instructions in the kernel, which has been addressed recently.
> > If the issue still exists, we can attempt to devise a fix for it,
> > which may or may not be based on this patch.
>
> Ok, I can do the testing.  Do you expect 5.7-stable has all the needed
> performance improvements?
>

Yes.

> Thanks,
> Ben
>
> >
> >> If you can suggest a patch to try I'll be happy to test it to see how it
> >> performs.
> >>
> >
> > Please share performance numbers of an old kernel with this patch
> > applied, and a recent one without. If that shows there is in fact an
> > issue, we will do something about it.
> >
> >>
> >> --
> >> Ben Greear <greearb@candelatech.com>
> >> Candela Technologies Inc  http://www.candelatech.com
> >
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
