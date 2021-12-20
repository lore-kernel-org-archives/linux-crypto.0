Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3C5C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Dec 2021 15:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhLTPa4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Dec 2021 10:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240046AbhLTPaa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Dec 2021 10:30:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FACCC08EACC
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 07:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28E061183
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 15:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079C6C36AE8
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 15:25:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M4+2A5cg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640013945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BrglIZ2uziYB5hhERfe4Diq8dIHSNZ55KGFuS6Y3hYw=;
        b=M4+2A5cgIYqdasfGYDLegdrAXObL54QAnTr+arnWOFouXMGnwqJ+xCdBxPwBsxZ3iab59n
        DsjaB++fSE+3wsOBjVUmx8doYTGUw3Zzw3cmzD3rJe5lKBb7h5G11HGHsUpR/LBnTPL1G3
        4rjZn0Jb4X8Nq7f+GJjgx1JZuXs5AJE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9d5a7b3b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 20 Dec 2021 15:25:45 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id j2so29758811ybg.9
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 07:25:45 -0800 (PST)
X-Gm-Message-State: AOAM5335rm6lgYydILd+U30cQEZwH4/7T/n3ofa7pRp2ZCFpBazO3rpV
        CdpXcy5WGtAUUDDVpHYAh/mp1oLlmU9ZRiIYY+0=
X-Google-Smtp-Source: ABdhPJwYedglWUYCPQjKWLi9KdO925tEYGEgi/+AVNzSuiFASiTSzqHbAlhu5/Z8ljwktkPDo1+dOOY7Q9VjOSTY/GE=
X-Received: by 2002:a25:ab86:: with SMTP id v6mr22775341ybi.457.1640013944462;
 Mon, 20 Dec 2021 07:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20211214160146.1073616-1-Jason@zx2c4.com> <CAMj1kXEuzHWKDtOX2nCHABWZKQ2K_QV4eJ3cF9zg4KM-6aOTuw@mail.gmail.com>
In-Reply-To: <CAMj1kXEuzHWKDtOX2nCHABWZKQ2K_QV4eJ3cF9zg4KM-6aOTuw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Dec 2021 16:25:33 +0100
X-Gmail-Original-Message-ID: <CAHmME9pURVsMXO4nH+6NB7FNsM9cASNcruE7Om+GBk+kJ+54gQ@mail.gmail.com>
Message-ID: <CAHmME9pURVsMXO4nH+6NB7FNsM9cASNcruE7Om+GBk+kJ+54gQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/curve25519 - use in/out register constraints
 more precisely
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mathias Krause <minipli@grsecurity.net>,
        Aymeric Fromherz <aymeric.fromherz@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Tue, Dec 14, 2021 at 6:23 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> Could we separate the whitespace-only changes from the code changes
> please? Otherwise, this is really hard to review.

Grr, not so easily, unfortunately. It was really a mistake that the
original one wasn't clang-formatted for some level of determinism like
this one is. As Mathias mentioned, --color-words -w makes it a lot
more clear what's going on. But actually, even with whitespace
unchanged, there's a *lot* of change in this patch because the
register allocation changed, so lots of %1 became %0 and suchlike.

It's probably easier to just look at
https://github.com/project-everest/hacl-star/commit/a9f1c5fa440b7e95e3d853671ee65b31ee5c473b
to see what's changed.

Alternatively, if you don't want to review this, that's fine -- just
say so -- and Herbert can go with Mathias' Reviewed-by, which might
make sense anyway because he spent a lot of time with this code.

Jason
