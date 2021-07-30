Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1CEC432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 05:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D0BB60F46
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 05:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhG3FeF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jul 2021 01:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbhG3FeE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jul 2021 01:34:04 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A50C0613C1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jul 2021 22:33:59 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so5541378wmg.4
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jul 2021 22:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1WY5v0DZXHTp8X+jU1XBLMpyZKc7p/7Jj3rqiqH4LA=;
        b=lSscHTftFvVptU0RS+B9xY4/Kl/vKO0fmd8RJGUtS0QJ7Cr+HIxgoDwzNcHLV2KcRq
         yaT6keM0oGDXc3g8ZUrvahCgeQ8zhc0bV9uDYtmXoO/w4FeCIKbeGql0cmwWkc9uMWNp
         7J4wlepD4tHdJAgjt3sIf2nWEEpOnAVnSd3s25CSzaItqfe23aRogMnFmjUcQ0H8SVhj
         Qao+bSdulih83AGQIt98is8fwF9t6zY8EyA301QW4G1xdTWL5faEh+ATQZax/v91wtpJ
         fKK/bm2q5IXTx0xCN7WDvo7cKg67B0PK75se07A5oWQyPOfJLPWKax5F6WtOFWWqgXxO
         KjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1WY5v0DZXHTp8X+jU1XBLMpyZKc7p/7Jj3rqiqH4LA=;
        b=R5SClkzqzLeFyc4D2tR6bZSmtr9bwSMxgb2FZHjgFbm9DHMNswVoA7Rrpxb2NNsMEt
         G2b0fVYYKkrzir+QKUnkeBmzTPL03q+Hi8K8+Xj0IoEK2QZR1Xp7C5B/4848jlBG+wtn
         8CyUbI3eHFkuNiUwW3JwHqCyRIGxsRvis6l20Ac833BprG3nqB0wXDl5jjVsW3FeU5Es
         fY75X0AEY7G3M/u4niRTV5IXvDZJPR29Pmypd+k2DMF0SfPsdEXgkj2moYgAHPy6Z7Tt
         cuX8bh5HCEmZgUIFYBcavHHU7aCsD2cYqn5VeuW5nwSnx9WyXynpBvdIHxijyjdLAPCw
         GtIA==
X-Gm-Message-State: AOAM530YarQ9mLGlJwFiJb+inQqnwhSyAFn/DNmiB17yeN03clCpASgT
        YurtGxcD301469xtxOHMpUbphUohWcOeNQ+ha06dmGkVuP+xgg==
X-Google-Smtp-Source: ABdhPJy99kphmNZI2cUkbVS6HIZYZEcjuxBuzxR25itmrpo9gyztj1XHxGHYctWdO87pV6jxujWlnPyusuvuvlFn3Fw=
X-Received: by 2002:a1c:1dcf:: with SMTP id d198mr981162wmd.103.1627623237784;
 Thu, 29 Jul 2021 22:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210715213138.1363079-1-dlatypov@google.com> <20210715213138.1363079-2-dlatypov@google.com>
 <20210723064328.GA7986@gondor.apana.org.au> <CAGS_qxqOD+Bcvy7xti7_eg8+H1cJcfp94BtnRhuzijDcaGF_uA@mail.gmail.com>
 <20210730025544.GA12781@gondor.apana.org.au>
In-Reply-To: <20210730025544.GA12781@gondor.apana.org.au>
From:   David Gow <davidgow@google.com>
Date:   Fri, 30 Jul 2021 13:33:46 +0800
Message-ID: <CABVgOSnde5VmF8TLfF=B4Nbvo7C5GUJ91OY9Rct-ksyPaTtpcw@mail.gmail.com>
Subject: Re: [RFC v1 1/2] crypto: tcrypt: minimal conversion to run under KUnit
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Latypov <dlatypov@google.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 30, 2021 at 10:55 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jul 23, 2021 at 12:31:28PM -0700, Daniel Latypov wrote:
> >
> > Thanks, that makes a lot of sense.
> > In that case, how useful would `kunit.py run` be? I.e. Do people
> > mostly want to see numbers on bare metal?
>
> I think it's a mix of both.  As in performance on bare metal and
> under virtualisation may be of interest.  I don't think you're going
> to be going through kunit for the speed tests though, because you
> need to supply module parameters for tcrypt to do that.

FYI, there is a patch for kunit_tool which will allow kernel
parameters to be passed through:
https://patchwork.kernel.org/project/linux-kselftest/patch/20210715160819.1107685-1-dlatypov@google.com/

That being said, no-one's ever used any of the KUnit tooling for
performance testing before, as far as I know, so whether or not it
turns out to be useful or not remains to be seen. With this patch,
it'd at least be an option if you wanted to try it.

-- David
