Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF800C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 15:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B466D64F72
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 15:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCLPst (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 10:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhCLPso (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 10:48:44 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9F5C061574;
        Fri, 12 Mar 2021 07:48:43 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id o9so26204840iow.6;
        Fri, 12 Mar 2021 07:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q//CU7rVliQSa4hRUYMM1ojKvL6g3kz3LyCTmAbjul4=;
        b=CF+zfLHL+gdPNtXtaqKugTM/zx32sFiIanYLcRVURma6rUagpmPisONYLoi9uoxTbn
         LU3lF83se/kuuw3vvxZQ/2asQtSkPLMwkHrBRh39BNrUun16J8zPDr5cqVzW/wduLVaN
         F565OuOSb3nDUqaYV31mXozPbAp8SBjjZGT2Nwa/uOA0s3kCa9DIboM7Rn0vTgFd5y6y
         eaqlbR7/yMw7byQBVNeAhuySfTpJ8VuU3SIfF7BsYQAU2rkvT5VzuV1yIkZh+3Q5HvKl
         JcI/VH3UEwHK1BNszbNGafal1V1h+an7tQKWK4XH4/UVkyFPLQ2NDTsbhhgDs7i6lvOV
         wAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q//CU7rVliQSa4hRUYMM1ojKvL6g3kz3LyCTmAbjul4=;
        b=rOR+/xX2I4jLJpOXhtZL3e2b+FIPzAe0/rYeiKCV7Cp84Xt9GMNwuwGhOt30F089Z2
         1osTUrIHJu3WhpFtgCT0S+z6lgwJ4uLv9f98JaVn9lRS5MHETipAd3/XCWyLJgLOvON7
         Rdn1lIG7O92ON+0pWnxlJe3Vb9t1Zto6Qa1llsUzXvELt8BOFYJwXLkkFyrywYBhHQeK
         OFG0pfjwYg06G4QsxHuBC+Iyg20d7yifHxo5Zg9AOoyA8fm5+esPcSGiJfyJ8wAeDB76
         HbJ2faO0B6PiENO/qRUPtI3WUPzwCjHVC8GiTztWdTZnVzwMuemsp2Wo9CsOkrI3WOMG
         Nt1A==
X-Gm-Message-State: AOAM530cLRO5U9G9n2h+PALbTioBS5YX9AycyEsvzjiJ7K3urGhfbwZ0
        QCTAgX+UIaZQW9dvsMZ0b2UhHvje5piHZVN2Lgg=
X-Google-Smtp-Source: ABdhPJzIb79Ce3Dtp9rTOtwGMw3rRrzfWZZTCoGMhL6v0eEyFl52NkyvYKVemVgLu6obdIq1sZd4iqE9LZK/0v+S1oc=
X-Received: by 2002:a02:ba13:: with SMTP id z19mr8968948jan.131.1615564123262;
 Fri, 12 Mar 2021 07:48:43 -0800 (PST)
MIME-Version: 1.0
References: <20210312141908.2388121-1-ztong0001@gmail.com> <20210312141908.2388121-3-ztong0001@gmail.com>
 <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com>
In-Reply-To: <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Fri, 12 Mar 2021 10:48:32 -0500
Message-ID: <CAA5qM4CM4noDtaedPpd0yh8R2f+jDV2DnCERKi_ycD5Lq-vKDw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
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

Hi Andy,
Complete newbie here, could you please remind me of the tag you are
referring to?
I am not really familiar with the process.
Thanks,
- Tong


On Fri, Mar 12, 2021 at 10:35 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Mar 12, 2021 at 4:21 PM Tong Zhang <ztong0001@gmail.com> wrote:
> >
> > ADF_STATUS_PF_RUNNING is (only) used and checked  by adf_vf2pf_shutdown()
> > before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
> > vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
> > fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
> > use of vf2pf_lock will cause issue.
> > To fix this issue, only set this flag if adf_dev_init() returns 0.
> >
> > [    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
> > [    7.180345] Call Trace:
> > [    7.182576]  mutex_lock+0xc9/0xd0
> > [    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
> > [    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
> > [    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
> > [    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]
>
> Don't you miss the tag I gave?
>
> --
> With Best Regards,
> Andy Shevchenko
