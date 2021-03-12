Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D81FC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 15:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD51064FFB
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 15:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhCLP5y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 10:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhCLP5n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 10:57:43 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95FBC061574;
        Fri, 12 Mar 2021 07:57:42 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id r16so823626pfh.10;
        Fri, 12 Mar 2021 07:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uf2SEtm8jRqAk4x8Ah7Gxsm8CJbu1eQ39IlQrsbF1N4=;
        b=J/rM3bnmXGg87LxymfyrZ8AKS6VQ75GeCMyys7tLQadbm12JxHveMcl4DW8L3TQyv6
         b8JzK++IRMNCnVbKyX66h+27jWNj71FyxGgRaDFViX3p/iKtP8DhYhd6Q5jnSVIjSJPW
         Yl64+QJlGTFy0YS9b9w07EF340mwSm69lYMg27zouCgIrR14Zgzo3TwgPOFs/IzehjLc
         eEb7IX5sc0Zh2lUwg1oE4yMroGvTWc1fIvo7I9aD2tcmI76XdeM1g+TDr+idvD2nzjmv
         Fxrg6PPqVIwsh4VVFGpLbilM/o+mDaSY8SBISUvd55ZnVQw+yXn17wjH6ZtkOneyD9Lz
         yyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uf2SEtm8jRqAk4x8Ah7Gxsm8CJbu1eQ39IlQrsbF1N4=;
        b=K0+dmltt5YIJyRFMC0KHYHho8RLGyhyDOSCNyiEiKa4+3akyTLdGnmQYdoCzeLw5rV
         8B3ZW7guvTSoA/v4WHzwKQH/jCpE4cIgq8KiX6xq0stHDgGEUDxnCUIt65jU1CxIYJiu
         RekZ2p7iyVjgycvaH0CBPM0RVWBkIhjw2r0LQoQYojSHJPZBUw5xW1GF2ZccIZWxC2K4
         tjIKcebOQ1z7jofrgimliRYBTOQ9+5+D3z2OfF7UOS0Yv21dGEBpg4e3R3sOmDFm/9Sf
         biuIllC5136w1kpX8oNZrxgEVFa3NrP1R+KbwJ7g4RMz/uPXeAVShgMZt11VFY+VVT0h
         J4Jg==
X-Gm-Message-State: AOAM531YxhqLf2Ez6S87gAa4oga7u1xB4Z1uNKl2+eHZS6T/f55C54Qh
        O6iL2QnA1woqYxQtbh4YmdmuWbTEZAffqIkJBqE=
X-Google-Smtp-Source: ABdhPJxC+8KZnsf99GKrp7LdlcXnyibMx2SCo1Owbcm2uLCnJzyz3ZaUIt9907x8j0Jx/mDzItYTj/khxF5T+Ah0sdA=
X-Received: by 2002:a65:4bc5:: with SMTP id p5mr12239037pgr.74.1615564662411;
 Fri, 12 Mar 2021 07:57:42 -0800 (PST)
MIME-Version: 1.0
References: <20210312141908.2388121-1-ztong0001@gmail.com> <20210312141908.2388121-3-ztong0001@gmail.com>
 <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com> <CAA5qM4CM4noDtaedPpd0yh8R2f+jDV2DnCERKi_ycD5Lq-vKDw@mail.gmail.com>
In-Reply-To: <CAA5qM4CM4noDtaedPpd0yh8R2f+jDV2DnCERKi_ycD5Lq-vKDw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 12 Mar 2021 17:57:26 +0200
Message-ID: <CAHp75VcFDXTXcaFqOyRCdArx1bGED_jsEeK1yRQhxUvHp0goTg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        qat-linux@intel.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 12, 2021 at 5:48 PM Tong Zhang <ztong0001@gmail.com> wrote:

Please, do not top post when replying to the email.

> Complete newbie here, could you please remind me of the tag you are
> referring to?

Reviewed-by IIRC.

> I am not really familiar with the process.

Have you read [1]? The chapters 11-13 refer to the tags.


> On Fri, Mar 12, 2021 at 10:35 AM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > On Fri, Mar 12, 2021 at 4:21 PM Tong Zhang <ztong0001@gmail.com> wrote:
> > >
> > > ADF_STATUS_PF_RUNNING is (only) used and checked  by adf_vf2pf_shutdown()
> > > before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
> > > vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
> > > fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
> > > use of vf2pf_lock will cause issue.
> > > To fix this issue, only set this flag if adf_dev_init() returns 0.
> > >
> > > [    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
> > > [    7.180345] Call Trace:
> > > [    7.182576]  mutex_lock+0xc9/0xd0
> > > [    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
> > > [    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
> > > [    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
> > > [    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]
> >
> > Don't you miss the tag I gave?

[1]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html

-- 
With Best Regards,
Andy Shevchenko
