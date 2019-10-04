Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B292BC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8655C2070B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q8a0Vk2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbfJDOaN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:30:13 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:55439 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389087AbfJDOaN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:30:13 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d085fedb
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=g2tcOJaOkZ283uLRnEUPFgcJe9s=; b=Q8a0Vk
        2gPRA61Bi9HmrcZjfNtuTr42yuL+2rqBWDwyVdUoo6gB8au5ntL+Njc2xt0GzWqC
        J92BfnqVbR/PLPVMCWc0IxxYKjaxcUPgCA57wooHJpCzwLPvvond+WOQHmD2xwXQ
        nHEFXcyDFXATjpIqP64AG6SNwsekDw/zYsw1TlcHPu9CG7meKRvee3J2XRS54xDS
        6SxR7aI9tXwXgvL5ohnhEbVjxkrTq8YK8qqtCE9IG0UhOXp0sdSSjh61HZh2EtA9
        zTALd23pBnsOXARWcDufCo1zWRXQRyizYXAUbeEk207SDSTAm7nuNAV1EM9VxliX
        FNuKJDjylDrUZkCg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e04c5b51 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:43:16 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id w6so5893418oie.11
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:30:10 -0700 (PDT)
X-Gm-Message-State: APjAAAWQMHF/aN6SAHGzjECypAKBl0vJGdKNs0/BUL4NRZQQXzkzYtMA
        IoTB4LORsE8JpAYmMBVbgUWCjR9rXWmjpOKhshQ=
X-Google-Smtp-Source: APXvYqzSwvnxcD4o5b7sWYFpSGHx2wFs+I4gU6yfJAuuoKOWnmv2pEty762f7V1tXgg/8rjYMQR36yUYS63JMThG8jY=
X-Received: by 2002:aca:f555:: with SMTP id t82mr7085255oih.66.1570199409226;
 Fri, 04 Oct 2019 07:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-5-ard.biesheuvel@linaro.org> <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
 <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 16:29:57 +0200
X-Gmail-Original-Message-ID: <CAHmME9qYtvhqQ25+E-GW0=6AuAwCPmsCeHpw6cS_zs1XSBpR7A@mail.gmail.com>
Message-ID: <CAHmME9qYtvhqQ25+E-GW0=6AuAwCPmsCeHpw6cS_zs1XSBpR7A@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 4, 2019 at 4:23 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> How is it relevant whether the boot CPU is A5 or A7? These are bL
> little cores that only implement NEON for feature parity with their bl
> big counterparts, but CPU intensive tasks are scheduled on big cores,
> where NEON performance is much better than scalar.

Yea big-little might confuse things indeed. Though the performance
difference between the NEON code and the scalar code is not that huge,
and I suspect that big-little machines might benefit from
unconditionally using the scalar code, given that sometimes they might
wind up doing things on the little cores.

Eric - what did you guys wind up doing on Android with the fast scalar
implementation?
