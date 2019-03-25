Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6E3C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 11:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A2620850
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 11:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="2yr4VexP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbfCYL5g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 07:57:36 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:43551 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730730AbfCYL5f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 07:57:35 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3409dd19;
        Mon, 25 Mar 2019 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=DBwobPcp+XLi0JlgbvkNQ17mcME=; b=2yr4Ve
        xPiz3LpBl2Bhgzo7jdpsaP1//wQjyutECetZ1BPl3xzFRQGrciVGNwzVBLaFdK7a
        4DNxcgJ57h9zF5ebfQkd1ilzV0Um4H0rdhrRPd8MMlslVMWxo83eXYrLp97VwJu0
        fIjDW6xI54faIoP8iXePRAPFmXnVpvi4885BI3j+7croJE5vlY43182yiAbO8eKH
        GHD9AlE/N3/VU6BLfJif8jOuzZDskQpe2RXORNqE+5QUZ1Ol2Tt7tnjYKlxY2y4r
        etUtfGoor7mfX2xKLfS2mjZiX2TvqRmIxTmnxC5ECN/BzTxyx324wNwpDx2E57tp
        aXj+cUKz+MY9K55w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f598297d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 25 Mar 2019 11:35:25 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id i21so6661336oib.11;
        Mon, 25 Mar 2019 04:57:32 -0700 (PDT)
X-Gm-Message-State: APjAAAWaho2e5zd2vKL4K08I13U9ihb+N4NXaALTzpPTkTMvY2e9FjiB
        EWHRy+CleSwjpW6IGLDglJH3keuAh0w+VBIWaDw=
X-Google-Smtp-Source: APXvYqwsR4oRu/q5zmvku3tlrxsPBR4U8hytDrtQpHuYbuiN+CKKpHpvCTmm0QeH44olD5ncivfvHGnqzKxKivEVpSM=
X-Received: by 2002:aca:61d6:: with SMTP id v205mr6056387oib.122.1553515052019;
 Mon, 25 Mar 2019 04:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190322071122.6677-1-Jason@zx2c4.com> <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
In-Reply-To: <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 25 Mar 2019 12:57:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
Message-ID: <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Samuel Neves <samuel.c.p.neves@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Herbert,

On Mon, Mar 25, 2019 at 12:52 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Sorry but adding new implementations of chacha20/poly1305 without
> removing the existing ones is not acceptable.  I really think
> we ought to separate the zinc interface from these new crypto
> implementations.  They have nothing to do with each other.
>
> As we've been stuck on this point for so long, let's get the
> ball rolling by first merging just the zinc interface itself
> with the existing chacha20/poly1305 code.  Then we can replace
> these implementations with your implementations without getting
> bogged down by all these other discussions.
>
> AFAICS once we resolve Thomas's concerns with regards to the simd
> patch, then we can merge the zinc interface right away and go from
> there.

I think we're slightly closer to being same page, but I haven't
followed up here yet because I was waiting for something else first.

Your previous patchset left out a few implementations and wasn't
totally complete with regards to the glue code. I'm going to whip
something up now that is Zinc, but where there's already an existing
assembly implementation in the tree (i.e. Martin's code), it uses that
instead of what I've been posting until now. Then, after that lands, I
can post stand-alone patches for replacing the various
implementations, and we can discuss those separately, alongside all
the various discussion of verification and benchmarks and so forth.

So, I'll have something to examine somewhat soon. Working on it now.

Jason
