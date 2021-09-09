Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8506BC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 05:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6171A61139
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 05:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350570AbhIIFQG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Sep 2021 01:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350662AbhIIFQF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Sep 2021 01:16:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1169BC06175F
        for <linux-crypto@vger.kernel.org>; Wed,  8 Sep 2021 22:14:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z4so643344wrr.6
        for <linux-crypto@vger.kernel.org>; Wed, 08 Sep 2021 22:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0rSslgaT6trl5t/rsmP7qXtX/NEAgmUtRkOyKb2Hba0=;
        b=l7LVdZyjfwSQqSPhg2I5wAxEorI6MIMR/gnOlvXGAqZgNxvx6wBQfJYVZJcNAK5nlk
         lkwPgsTQanaxXtKzwwut6UfF/mkyqW1+XrQ3jaJDyHJ2Gctxl/UTgKZH8XNjv/swWFmC
         59hvO8nxwPSKyVPvdGzUv436Rl1JsgS/DtLCSBkMQ53d/4lWQSA+efgdLsDCJD7GHOEA
         MZ9KJFbPCT7B0qzzNIJxvOhBGYNfzlJuj7uJW6mj/fpGHc/sBGyecbwSGtnQD6EOr3YN
         jcZy9MbaaLRhF0vi7WmKQr0UDPkR0hfmC2jLqQYEyLIXv342eJHO7oYQRUSpQCVtwBWa
         h9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0rSslgaT6trl5t/rsmP7qXtX/NEAgmUtRkOyKb2Hba0=;
        b=SbdsT+S2E6mK94Vtg1RlZVcqQb/9x6Weor2bjCmD3EMJqsR53sshnrdiTwEW2zz0Ni
         iHo9Cjp4x/YdlU28pp6YTFs2+io7eQCN5s45aEn80BP1L4JaxJnvrRlwBvSP/RdJlC6b
         JVmvpQh8fUv3SlMuJdp7XJXSgSOM01Uqnbu1L2KS6S8KU6MYp0eFIrGKEposjrNOJjpN
         wWXu5KBvu4A9PWtGPZzPJvTapPByOQQ3583+TCZZNPlDoU67LYtXP/zlXfPE2wlih+FT
         AJ3tb7kbZlDiuOKIJdmo30lhutk7K7ozyE+n38q/mVxyqrBz85xgOjDLfpsl1V9t9Smo
         +QWg==
X-Gm-Message-State: AOAM533Pr2/JKmFJ7859o6YRm0TNzblTb1fpXw1oYK0qwa0LOeNunzxm
        f/3uVQuaKmyAaODL8D4ESs0VNcpmae9mnbTHd2U=
X-Google-Smtp-Source: ABdhPJwdjOJM2vt5nmI6MA771k77UXshKjMwzz1HTioFPiPCmtUQX3rwgbDTAyzRvnoc4PZIZ3PYtG2wgL13J6Ola9s=
X-Received: by 2002:a5d:538e:: with SMTP id d14mr1205386wrv.192.1631164495681;
 Wed, 08 Sep 2021 22:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFmm798P6mPErh9B4thz7uvBG1sUO-eJpa1MB+7ayDyTCvw@mail.gmail.com>
 <YTmCyOTFADDSTdQm@sol.localdomain>
In-Reply-To: <YTmCyOTFADDSTdQm@sol.localdomain>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 9 Sep 2021 13:14:42 +0800
Message-ID: <CACXcFmmpf+bkjr3oiMcABCbXE+LnNQxWXXSiuVk-GMYV09u+Zw@mail.gmail.com>
Subject: Re: [PATCH] In _extract-crng mix in 64 bits if possible
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 9, 2021 at 11:43 AM Eric Biggers <ebiggers@kernel.org> wrote:

> This patch is corrupted and doesn't apply.
> ...
> > -    unsigned long v, flags;
> > +    unsigned long v, flags, *last;
> > +    last = (unsigned long *) &crng->state[14] ;
>
> How do you know that this has the right alignment for an unsigned long?

Good question, thanks. I don't & that's definitely a bug.

On my version, which includes patches I have not sent yet, it is
necessarily 64-bit aligned.
