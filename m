Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC9AC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 00:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C202145D
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 00:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UpEy0Sr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgKBAaj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Nov 2020 19:30:39 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:58121 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgKBAai (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Nov 2020 19:30:38 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 59c65cec
        for <linux-crypto@vger.kernel.org>;
        Mon, 2 Nov 2020 00:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=uY7lkA0p7tYrHy7bz6qN2qoiRu0=; b=UpEy0S
        r/DKoIyqodE4T1twC09387GNZrMkmAOLyF4VOVlTYVttiu1sQqDY40LhifsxJYaI
        9aUk/uzyUYhrGtacCEBIGIBRneHkYIDV5XPW+uHwXpmLl9W+KjwrGzoWK2QDyWEi
        VPnv//gLvAljBISgntMeTpm61mD9avoGwBMyNavQHtfbGaZYi5vyO4yihu+grqKl
        69Ac2IuunP81qV3xyfAaLZXV9RSNXikx8m4V2jTmcSz7kQHqc+9ypYopt7XksdkH
        /GJylWIjNV60KxXZyBds1nWrfEf0UVaoUGd5cfYLPivaeRNPL4DGr81XkiZaBHKF
        rj+h5BIAhNJ2LgUQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2fba4ead (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 2 Nov 2020 00:28:47 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id z7so8425536ybg.10
        for <linux-crypto@vger.kernel.org>; Sun, 01 Nov 2020 16:30:36 -0800 (PST)
X-Gm-Message-State: AOAM531WlgJeenIzSj7+xMucH762Tq1rDoa87AAMvccOm14p/JdVz6SW
        mutxy6y0OxD4bWOzf1x69O3OdY0Ad8e+b+nRSXw=
X-Google-Smtp-Source: ABdhPJyh3M7dSWpj0qdtBOpPR2SC0XpMwF/p4EmJ/dF0+cPxmyN83gfSR0qRUSCNGh2cfhJryqM+ix2zJThPszh/0sg=
X-Received: by 2002:a05:6902:513:: with SMTP id x19mr9269986ybs.239.1604277036420;
 Sun, 01 Nov 2020 16:30:36 -0800 (PST)
MIME-Version: 1.0
References: <20201101163352.6395-1-ardb@kernel.org>
In-Reply-To: <20201101163352.6395-1-ardb@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 2 Nov 2020 01:30:25 +0100
X-Gmail-Original-Message-ID: <CAHmME9qKgB3_ZGF4eGVGy2qU2obiwRgiXTxCZ8PuW7EaRsef_Q@mail.gmail.com>
Message-ID: <CAHmME9qKgB3_ZGF4eGVGy2qU2obiwRgiXTxCZ8PuW7EaRsef_Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/chacha-neon - optimize for non-block size multiples
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cool patch! I look forward to getting out the old arm32 rig and
benching this. One question:

On Sun, Nov 1, 2020 at 5:33 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> On out-of-order microarchitectures such as Cortex-A57, this results in
> a speedup for 1420 byte blocks of about 21%, without any signficant
> performance impact of the power-of-2 block sizes. On lower end cores
> such as Cortex-A53, the speedup for 1420 byte blocks is only about 2%,
> but also without impacting other input sizes.

A57 and A53 are 64-bit, but this is code for 32-bit arm, right? So the
comparison is more like A15 vs A5? Or are you running 32-bit kernels
on armv8 hardware?
