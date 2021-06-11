Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207ABC48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 16:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06A13613F0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 16:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFKQFm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:05:42 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33465 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhFKQEj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 12:04:39 -0400
Received: by mail-lf1-f46.google.com with SMTP id bp38so9342977lfb.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8cTgYop9NFZ0qyAjdKFalLsNoJbK6hVndemtwl7l5Ok=;
        b=JI+g1YiYzhV06je+UJHtI4hG3GnxkuzxgymgJDwaeWA6WGD2qXUyRj1NOBlwnKuyTd
         NaPkND+luK7G0qt+yz8ypcgXRq7rKjgstB/RCNkCODwAPj1YApFLufh5S0QBvekiKtX5
         97Nw+Lmo2DmelofysTIDQKdXUYR22ffH2MAzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cTgYop9NFZ0qyAjdKFalLsNoJbK6hVndemtwl7l5Ok=;
        b=b0kBsc5g+BVBnTjVlbcDweyrpubgAzl0/Vwu6bNgaNPaVsB2vGKtpwftxuhh4youGx
         DOccEMc69r6u+Zb52VoYF4qgGNz7PS9IHroSK7r8tGJd5ii/cXUrDuMOiwd2qgBUTC48
         jrp6IgTcZPPcj/JWltroEpq75XNYiSwT6JHetkt9IXaPOOGY6ocK59yN7uNVhB5nkCQi
         ptvrP6yhxQF39ayKFdnfeY6WIKwESQBFtuMlseZ0kpaSGgKN/HRjDjtkz39iX/Hne5mn
         4/foAnZu4wa8TQ8Ph/IGMD5GjYo+Do4zMP1dn4wB9+J8GjypKpmYrcKqkFbdQPFCaP7j
         +JFQ==
X-Gm-Message-State: AOAM531WD69fsY6q6X3vHU+DxfZ7jF36i9lYGKRhYFzzg826hNXEKWBT
        smJsvYHTq8AvGmEIMdkjMJyE86MtCkVuAntuqmY=
X-Google-Smtp-Source: ABdhPJxu16ZE7SUHVnauZ8MQLrNwQXTF/9KwjCYrN6jWNb3gCtXuV2Tb0yWdrmoHPxqV0FAXMyaEXA==
X-Received: by 2002:ac2:4c83:: with SMTP id d3mr3083176lfl.543.1623427288395;
        Fri, 11 Jun 2021 09:01:28 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id v9sm766277ljv.131.2021.06.11.09.01.22
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:01:24 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id p7so9299666lfg.4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 09:01:22 -0700 (PDT)
X-Received: by 2002:a19:7d04:: with SMTP id y4mr2952000lfc.201.1623427281920;
 Fri, 11 Jun 2021 09:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local> <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com> <20210611062153.GA30906@lst.de>
In-Reply-To: <20210611062153.GA30906@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 11 Jun 2021 09:01:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh70m5dYtJcoc3TQtJSp0+AHTuXZM=raBXQVW9CJKG5ng@mail.gmail.com>
Message-ID: <CAHk-=wh70m5dYtJcoc3TQtJSp0+AHTuXZM=raBXQVW9CJKG5ng@mail.gmail.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb) stable/for-linus-5.12)
To:     Christoph Hellwig <hch@lst.de>
Cc:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jianxiong Gao <jxgao@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 10, 2021 at 11:21 PM Christoph Hellwig <hch@lst.de> wrote:
>
> FYI, there has been a patch on the list that should have fixed this
> for about a month:
>
> https://lore.kernel.org/linux-iommu/20210510091816.GA2084@lst.de/T/#m0d0df6490350a08dcc24c9086c8edc165b402d6f

Honestly, that patch is all kinds of strange.

This expression:

    tlb_offset = (tlb_addr & (IO_TLB_SIZE - 1)) -
        swiotlb_align_offset(dev, orig_addr);

makes no sense to me. Maybe it happens to work, but I think it does so
by mistake rather than by design.

What my patch used was:

    unsigned long offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

which actually pairs with - and makes sense with - the index calculation:

    int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;

so that offset truly is the offset within that index. Look at how that
'index' calculation calculates the high bits of the difference, and
the 'offset' calculation now literally is the low bits of the same
thing that got dropped on the floor by the 'index' calculation?

So those two calculations actually make sense. The
swiotlb_align_offset() one doesn't.

It's possible that that swiotlb_align_offset() function ends up giving
the right answer just almost by mistake (because of how tlb_addr and
orig_addr end up being related - the swiotlb_align_offset() expression
might just end up being the same thing - I didn't look deeper), but
even if the result is the same, it's not _sensible_ code,

It's also possible that the swiotlb_align_offset() function ends up
giving the right answer very much by design and because of how
orig_addr works - because maybe the remapping is doing odd things and
using that swiotlb_align_offset() function in ways that make the
*obvious* and natural offset calculation not actually work.

So it's at least in theory possible that my "natural offset"
calculation that matches how the index is calculated doesn't actually
work. But that means that the swiotlb remapping is doing some really
odd things, and then I think the patch would need a lot more
commentary on exactly what those very odd things are.

            Linus
