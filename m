Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3605BC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 21:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B534222C3
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 21:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569533821;
	bh=OyZSdjbLBMhgPOUk+Mr6qz+tKzwnie60KWYmwf3kT3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KACZAiXJGVWi+UeOg7Ad3R2l0ims8WKq0x6Kt8CvfY8vpkI+1qlGEXdXdVO39lfSl
	 dEjL/qBcLndguDDVii2TRwJWn4CrhK+1eelGfhzXong34N4rBAhllWgLWbiBiJE2o4
	 q7TNe+qLQ78/Cb+m3mZcsvQydEibXZEkNWyMtdX0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfIZVg7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 17:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfIZVg7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 17:36:59 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E9D2245B
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 21:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569533818;
        bh=OyZSdjbLBMhgPOUk+Mr6qz+tKzwnie60KWYmwf3kT3g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kGEOUXDO6eeyHW1Xmw7tTs3P94vmlGnuWYD1Q1UDfmQKO/DhLPvkWkC4NDxHOWRag
         RgGpPieSue/d8FN0Ds4rk1iWlcMNBeFhdZlAoK81J3SN1S/I7brj1kgVJL5ixnlvKO
         RfLM0pBg0iCZAsRkzSoauN4SUw9bNOAfQiqWQOCU=
Received: by mail-wr1-f43.google.com with SMTP id i1so411925wro.4
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 14:36:58 -0700 (PDT)
X-Gm-Message-State: APjAAAWjDNeHM7cxkFZLihE+Mi3CMkQa6IGjRXHWDn9qtpVYbTNea5Zd
        xBvLOenkLNCG8Ph0TL0F5xjBfOMsGj0d2koBlbUeng==
X-Google-Smtp-Source: APXvYqxlURCWSp4HCUsNoCx7QmBbg/9ouN3KolYysgQ1vXlxVhLH+OslMHbI7BBC9R7Ed9Bg/H7yvYJXwf00AFpsrFA=
X-Received: by 2002:adf:cc0a:: with SMTP id x10mr348170wrh.195.1569533816729;
 Thu, 26 Sep 2019 14:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com> <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
In-Reply-To: <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 26 Sep 2019 14:36:45 -0700
X-Gmail-Original-Message-ID: <CALCETrUrbSGNfo=g=PS4=t1zzXqGAHSs5oUL46LwMgu+2aVh1Q@mail.gmail.com>
Message-ID: <CALCETrUrbSGNfo=g=PS4=t1zzXqGAHSs5oUL46LwMgu+2aVh1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 26, 2019 at 1:52 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Ard,
>
>
> Our goals are that chacha20_arch() from each of these arch glues gets
> included in the lib/crypto/chacha20.c compilation unit. The reason why
> we want it in its own unit is so that the inliner can get rid of
> unreached code and more tightly integrate the branches. For the MIPS
> case, the advantage is clear.

IMO this needs numbers.  My suggestion from way back, which is at
least a good deal of the way toward being doable, is to do static
calls.  This means that the common code will call out to the arch code
via a regular CALL instruction and will *not* inline the arch code.
This means that the arch code could live in its own module, it can be
selected at boot time, etc.  For x86, inlining seems a but nuts to
avoid a whole mess of:

if (use avx2)
  do_avx2_thing();
else if (use avx1)
  do_avx1_thing();
else
  etc;

On x86, direct calls are pretty cheap.  Certainly for operations like
curve25519, I doubt you will ever see a real-world effect from
inlining.  I'd be surprised for chacha20.  If you really want inlining
to dictate the overall design, I think you need some real numbers for
why it's necessary.  There also needs to be a clear story for how
exactly making everything inline plays with the actual decision of
which implementation to use.  I think it's also worth noting that LTO
is coming.

--Andy
