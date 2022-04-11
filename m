Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F833C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 19:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349605AbiDKTiK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 15:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiDKTiJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 15:38:09 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8A213F0C
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 12:35:54 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id t67so12530750ybi.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 12:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ctsBGHHI9fHwwFQuTHX2ntOMJxKsTa2iIDRP2hXt+D0=;
        b=slGV0/Ar19gJuMe7YfVJmI0gWO/MmehfBZr/e3d8u1vwMKQDfD1ZQ7zU9cj9fDFuwp
         wqKkiOUS43bCN4vuYG4V4ux9AgeWG2YzhWrq2NzRnZI5RvWLZudhZiPAxOVSdD2v434n
         cbC2aypUD7NBboBMLUhKyfxLHZXWERTa1uM6W7zwJjsd40XAmUZ+0evN2w6RDLBrYZgu
         bCJEyWbyvNnzOIg+xNefryDdGUVEikcChZsvnbox/NIowRGnvZk7b9YypdOcXQjCcAz+
         qqhXlFPRSyNA47L2ge11qrzzytK2u/YbkE5j/RtysNa8mvW8dlOPXsy5sFU2cjxrUX0w
         rPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ctsBGHHI9fHwwFQuTHX2ntOMJxKsTa2iIDRP2hXt+D0=;
        b=rCLZszVGb5WsmfE4soq4brv6kjjGHYm6HLGNnH+QPO99+zEHhDohBwUb+YafBsGacV
         Oybiv6hjH+gf1OoOqqXQC8XwaLP84LPNY3AecRNxaUn0PiNRyhMNm+5EF1/6T/yg3+Qb
         /DYY52F3I79n0hdQ2iq3UpP0wiXf5b6qNdVdJmytpTK8UrtpYWtbqLGe1pwE19jEJHuc
         Br6UqSwJmY5crCI6yIESJQBaIBNUGbqmT9ahB/5MTOMzIkE0gKizXwdOLxkrbDJ0CZ5g
         dT++xs/yrqTmcK7n24lqMx84Ky2Y+F6/TwKaaZky/ypUqYB+2iktIX2IQYIkmERKapOI
         HPEA==
X-Gm-Message-State: AOAM532OVxY0grk43fBmIrTRmkMz85Zmv7/1VhVnCUWKtcmxErClGy8G
        gkzsgmH7a3AXf2ZIFnTg0U5Ces7C2XteV2Fx3Cxn
X-Google-Smtp-Source: ABdhPJzxdu+zSoihQSMJl+2XUSrgNDyTf8QD+9tKSBur49OSsRbf3Dting9soeQbT4KwfUCDKsy4mk3XI39sNW95F1U=
X-Received: by 2002:a05:6902:706:b0:641:5f7d:8ff2 with SMTP id
 k6-20020a056902070600b006415f7d8ff2mr5176516ybt.80.1649705753449; Mon, 11 Apr
 2022 12:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220411180006.4187548-1-jackyli@google.com> <4278ae8b-eb87-06ac-43af-41a1c741f9a9@amd.com>
In-Reply-To: <4278ae8b-eb87-06ac-43af-41a1c741f9a9@amd.com>
From:   Jacky Li <jackyli@google.com>
Date:   Mon, 11 Apr 2022 12:35:42 -0700
Message-ID: <CAJxe5cvAq9+FVfHrCMkN-re9v_v33FZNVsT6b1NyVZb8bdcC8w@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp - Fix the INIT_EX data file open failure
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 11, 2022 at 11:58 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 4/11/22 13:00, Jacky Li wrote:
> > There are 2 common cases when INIT_EX data file might not be
> > opened successfully and fail the sev initialization:
> >
> > 1. In user namespaces, normal user tasks (e.g. VMM) can change their
> >     current->fs->root to point to arbitrary directories. While
> >     init_ex_path is provided as a module param related to root file
> >     system. Solution: use the root directory of init_task to avoid
> >     accessing the wrong file.
> >
> > 2. Normal user tasks (e.g. VMM) don't have the privilege to access
> >     the INIT_EX data file. Solution: open the file as root and
> >     restore permissions immediately.
> >
> > Signed-off-by: Jacky Li <jackyli@google.com>
>
> Should this have a Fixes: tag?

Yes you are right, will add the Fixes: tag in v2.

Thanks,
Jacky

>
> Thanks,
> Tom
