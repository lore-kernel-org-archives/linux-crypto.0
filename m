Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473FAC43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 18:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8DA20872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 18:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Sj++ggZX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfCaSSb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 14:18:31 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:54851 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfCaSSa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 14:18:30 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 609fb3c8;
        Sun, 31 Mar 2019 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Ti4V61HDeZDVBAG3CXQ/8uid5S0=; b=Sj++gg
        ZXXI0knSqB2hbxyWvqVtiqIBIGzUoaAEMsdKrME55Gd269XxAhJE/lRxpfNSsCk7
        jLUehyHGNHjcgxGSn5F50yT9YoFcEPxVjkoo/iAWnaBoCOlmG8zalOAqkWJpb/y1
        BX2XMlHE7nEhjEGyFzoL7q4pDNFqgvo/XAlKvJIQJ7pOc0RgQlAO8vcljJRsv0TR
        1EGUbQndd9mcpfkLueFFoq01407l8cfYJdF3/Q9goJTGhIpo5cwpYufMkCb3qYKV
        PDj/KSNCpQt30EKEjUjjDEFevRvczt8Hu+ifERHb0kkUkUM5FLAbxiKR7ajrIUwD
        1zlWLJinGk3E2IPw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f2b473e4 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 31 Mar 2019 17:55:30 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id e5so6475957otk.12;
        Sun, 31 Mar 2019 11:18:26 -0700 (PDT)
X-Gm-Message-State: APjAAAXotfLyoGy4FPSOYV+zNz9b6OUKNvkTPa1JXGdJE2PO3B8XzLWu
        HUBwO9ufsW2oAUcQRQ4dyV/QZ12C99nOowAXpe4=
X-Google-Smtp-Source: APXvYqzgait/TmLmBd7A84YuraR+WSdurvyDju0SbIiZUO/LBlMjbcRUtDA+lqqNLtm5mm7RFs0bEWLHg9fG5N1sWrc=
X-Received: by 2002:a9d:7d0e:: with SMTP id v14mr2355535otn.225.1554056305103;
 Sun, 31 Mar 2019 11:18:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190322071122.6677-1-Jason@zx2c4.com> <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
 <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com> <20190330055307.GA8001@sol.localdomain>
In-Reply-To: <20190330055307.GA8001@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 31 Mar 2019 20:18:13 +0200
X-Gmail-Original-Message-ID: <CAHmME9o+HqyrXX403bSXJX4Xs0dsZ9Qo=owiu7QGzBbaLQWZag@mail.gmail.com>
Message-ID: <CAHmME9o+HqyrXX403bSXJX4Xs0dsZ9Qo=owiu7QGzBbaLQWZag@mail.gmail.com>
Subject: Re: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Samuel Neves <samuel.c.p.neves@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 30, 2019 at 6:53 AM Eric Biggers <ebiggers@kernel.org> wrote:
> poly1305-simd is among the failing algorithms because it loses carry bits when
> handling long "all 0xff bytes" inputs.  poly1305-avx2-x86_64.S is definitely
> broken, and poly1305-sse2-x86_64.S *might* be too.  I am working on a patch...

Yea.... yikes. I'm kind of souring on this plan of having to deal with
that code in Zinc, versus the extensively studied, fuzzed, and
scrutinized code from Andy. Subtle carry bugs like that are kind of a
testament to my overall plan of preferring formally verified or
heavily used implementations to bespoke ones. This stuff is hard to
get right.

Jason
