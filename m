Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC4DC433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 10:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8822E2395C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 10:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbhAHKnv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 05:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbhAHKnu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 05:43:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC9C23977
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610102590;
        bh=+2QFs0OGNftMJ0a2Z7GgyjD2lvsXmH2/al2AwubOuYs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HMNPtpFQvGLVdNI9lFLp2PYZCWNd8atIrVLDWWZRznt8h07uTDxqvoRmO7cNHv/Fp
         5qfFUdp1ULHyXXXU9Gqt67+vVOLidCBmJG5HqxQEPiy7U+h+H1Ywg0ct5Ln2AKH9ba
         s2Q+SJQnrTvtNHniI3M7cuUr+I2jMNKXDOYGdq+Vn/9jzABTJ2jYkXCFj+++B6GyUC
         esSrSQ1GN2MLg1WNGTXPm9T58ws4pz04pl+BdVC1TprcHjnHwzvbvw0rF9SScisBjU
         BuXLk4gRzUfIVQRJ3u1wY0ZyQT4euCt+ODmmFG6BwP2qYsMCqonfmnT9p/zxjhwmQd
         SyZR5gIJMtGgw==
Received: by mail-oo1-f49.google.com with SMTP id 9so2282093ooy.7
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 02:43:10 -0800 (PST)
X-Gm-Message-State: AOAM532Gnqdn2M8fL0sooYypAf0WGtuuBL5hwu44++FKsJwVuN0Xv6yc
        Vfx7HxXAKL1kqCQRCH9xPOXkD26wJp5SHqUyjAg=
X-Google-Smtp-Source: ABdhPJxJmPt0EkBlojJMHe8J9CW/lR/V5poIEdGJQDdpB5ovyO0Ku/t6LyqvNqu4/M5vnDbeaGMUTfx8UYl30SNRtfw=
X-Received: by 2002:a4a:2cc9:: with SMTP id o192mr3928093ooo.66.1610102589242;
 Fri, 08 Jan 2021 02:43:09 -0800 (PST)
MIME-Version: 1.0
References: <20210107124128.19791-1-ardb@kernel.org> <X/daxUIwf8iXkbxr@gmail.com>
 <CAMj1kXE_qHkuk0zmhS=F4uFYWHnZumEB_XWyzo4SYXj1vjqKmg@mail.gmail.com> <20210108092246.GA13460@gondor.apana.org.au>
In-Reply-To: <20210108092246.GA13460@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 8 Jan 2021 11:42:53 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2k_bdhxKUnrae__OpmN807qeJpXHGB1zgAzFqLVZEZuQ@mail.gmail.com>
Message-ID: <CAK8P3a2k_bdhxKUnrae__OpmN807qeJpXHGB1zgAzFqLVZEZuQ@mail.gmail.com>
Subject: Re: [PATCH] crypto - shash: reduce minimum alignment of shash_desc structure
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 8, 2021 at 10:22 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jan 08, 2021 at 09:36:23AM +0100, Ard Biesheuvel wrote:
> >
> > scatterlists, and I don't think we permit pointing the scatterlist
> > into request structures)
>
> Not only do we allow that, we do that in lots of places.

How does this work for kernels with CONFIG_VMAP_STACK?
I remember some other subsystems (usb, hid) adding workarounds
for that, but I don't see those in drivers/crypto

      Arnd
