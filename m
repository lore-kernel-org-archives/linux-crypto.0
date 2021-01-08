Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9828C4332B
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 09:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D4323372
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 09:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbhAHJdw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 04:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbhAHJdo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 04:33:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1870235FA
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 09:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610098384;
        bh=5DpViUW/x7mBZSqH/tGtofzQOlxmrNQ/TkvagOg/1lA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LXmJeyanXMt2U3w+UDEbPa2nkPHQ5ly6b8rxqI9YF/ZcEZvCAdfiAOfwJ0/vi8yDL
         FZMWm1lMXbBFVFvU2nEn5q+jkmoMyPQmSoFIKW33VbB1+BVaclo1WNyEUbxmMK57wx
         nL0AW1q1BuK5Ykzd92BZhA4dLwv/INIdnN5p/TTAbggmZ2/Py/JOFsxVtFJB69jcq8
         afp3H9f48MF3gkwAHwSa+AdnLQ9N/9opXwlzM98JeQfaRAagfuqGZdW4iTrbIxtUqO
         kqobl83R24sMZZ/naXho6aS9wjwaZ4L6hSjyCzWET5SkuErY8hwNbrozsRxglR6Qpc
         EJY6bmHe2D0Yw==
Received: by mail-oi1-f169.google.com with SMTP id w124so10713915oia.6
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 01:33:03 -0800 (PST)
X-Gm-Message-State: AOAM533pDji2tFD89KDh+q2HkBDrx1mtyQwXB4za7IWo+ZbiO6RFAI3R
        Z4cBdifWYUrU9FWRuJehp33/cKQae+qp6sJxWN4=
X-Google-Smtp-Source: ABdhPJypGQwnbQ4jTB5oCcg+8tK3pe1VLDd2fB/ofQxXtQvWvRdWbO4ZAem51/g0eOHsvKcg0g6SnDjbfd3Syq25F70=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr1784937oig.33.1610098383198;
 Fri, 08 Jan 2021 01:33:03 -0800 (PST)
MIME-Version: 1.0
References: <20210107124128.19791-1-ardb@kernel.org> <X/daxUIwf8iXkbxr@gmail.com>
 <CAMj1kXE_qHkuk0zmhS=F4uFYWHnZumEB_XWyzo4SYXj1vjqKmg@mail.gmail.com> <20210108092246.GA13460@gondor.apana.org.au>
In-Reply-To: <20210108092246.GA13460@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 8 Jan 2021 10:32:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG1pEon1EzNwnv64=u_9KZ1pqDRbx7Sqq6ck+s530C0vw@mail.gmail.com>
Message-ID: <CAMj1kXG1pEon1EzNwnv64=u_9KZ1pqDRbx7Sqq6ck+s530C0vw@mail.gmail.com>
Subject: Re: [PATCH] crypto - shash: reduce minimum alignment of shash_desc structure
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Jan 2021 at 10:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jan 08, 2021 at 09:36:23AM +0100, Ard Biesheuvel wrote:
> >
> > scatterlists, and I don't think we permit pointing the scatterlist
> > into request structures)
>
> Not only do we allow that, we do that in lots of places.
>

Fair enough. So changing CRYPTO_MINALIGN in general may trigger DMA
related bugs in non-coherent devices.
