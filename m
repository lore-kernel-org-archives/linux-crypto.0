Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A047DC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 15:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E12B65005
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 15:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhCLPgB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 10:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbhCLPfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 10:35:43 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9768C061574;
        Fri, 12 Mar 2021 07:35:42 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e26so2094412pfd.9;
        Fri, 12 Mar 2021 07:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BcgI+/sZqGfr/XwhmMch7PJe4eVMZtOr6NBcMOyY6Q8=;
        b=Gfz6gp0xNwa7iuRWCgUkiqnjHJCwIaEiIxa4oohO6H77hP/gcZU28esNMxOfoeyvSQ
         iJEFdqwHBEDyw2vJ7hHHqOdLw13E+QCy+4I/pqwhdIf2tveJJYB9KpZIOd0xmHvVjS7Z
         RVAT8WxRsALA8j2OIqotC5o9ajS3ggu6nUYxXoGUqOGutOnjUkL9lb8u/a7A6oBM7fFw
         plSjboj88k3xMdDj142k0Zvo15miKlPpTjvSlw0278aRx1CDj8arQt5psKZp0qyxBvKw
         xd3aYXGPYVvp588RU3FZ2AjhGNb8TR7Eayof4aQ2uv33yOT1bgXvAlanXvKtGWQFp/nY
         H1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BcgI+/sZqGfr/XwhmMch7PJe4eVMZtOr6NBcMOyY6Q8=;
        b=HasN3WAjsGUnjpMCN3CxBKuUHHyqmr9cMGZOmjb3EFVj+PaxbN6Ma4aXt1SH06qRNa
         1+xDlZG05Vnlms95Vm8lZaEAbZfN4izwYmVmJ/PTvUsezPpV8PtTnbVnrp6ebw9KoMFp
         oaS1fM4f2yRyoQjwj6xs8j/uzWODhx/1IEjm0H0ByMM9bzH67my5dmTPG2Wh7XAypfiS
         XVhNHzvM6nZeM1er5mwc6zsM21mb8GOgZcKAmthHowtziCJfdLjEHhARt9I503JPNPho
         cvPZZeLo/1e5JPX/I1AvcAyW6r+18ZZCKYpeqOXxtaTC0UwnKRHjPf41j9dFQBYCJd7P
         OJVg==
X-Gm-Message-State: AOAM530gj+W6QMi/R9aPsYQ7DLjeEJY/4NinqFDMMmi8f8Oq4to7b+iO
        7czm2TtwlE+lTVpGrVIP3ftnn4AGfdXC0p7aug4=
X-Google-Smtp-Source: ABdhPJyy/bal8GpR5DiTyQx1ADWchFoWycvJYamea/YpSQ+D3g/xGr+xh66r99YO2TnQA3XOYcr/DE5Op7vc+5Iuw7M=
X-Received: by 2002:a65:4c08:: with SMTP id u8mr12071350pgq.203.1615563341485;
 Fri, 12 Mar 2021 07:35:41 -0800 (PST)
MIME-Version: 1.0
References: <20210312141908.2388121-1-ztong0001@gmail.com> <20210312141908.2388121-3-ztong0001@gmail.com>
In-Reply-To: <20210312141908.2388121-3-ztong0001@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 12 Mar 2021 17:35:25 +0200
Message-ID: <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com>
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

On Fri, Mar 12, 2021 at 4:21 PM Tong Zhang <ztong0001@gmail.com> wrote:
>
> ADF_STATUS_PF_RUNNING is (only) used and checked  by adf_vf2pf_shutdown()
> before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
> vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
> fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
> use of vf2pf_lock will cause issue.
> To fix this issue, only set this flag if adf_dev_init() returns 0.
>
> [    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
> [    7.180345] Call Trace:
> [    7.182576]  mutex_lock+0xc9/0xd0
> [    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
> [    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
> [    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
> [    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]

Don't you miss the tag I gave?

-- 
With Best Regards,
Andy Shevchenko
