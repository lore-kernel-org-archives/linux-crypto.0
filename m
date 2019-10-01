Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69342C388F3
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 08:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A8FC218DE
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 08:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y+iE/NUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfJAI4i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 04:56:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47046 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfJAI4i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 04:56:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so14403139wrv.13
        for <linux-crypto@vger.kernel.org>; Tue, 01 Oct 2019 01:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rveAeMH6nUFyX5FAstmiBHjqBY6vb+FrCceaPqrZxk4=;
        b=y+iE/NUt/TozRmqNM2IRjQjT0A9MNjIyxcU4CVljJRq18FbRdjN6KbsQwjS0n9JXir
         XYoB9mrKTgiurrdZaubQnqtQmwVpJsDB+YUHfJmH+LmFrZ8QFtifXmroC4+isLCfUQWS
         6LPYIl+EOEFSuBE0cYDZkpDOBdZa3L1QtyOLb9/juFyIgwjRZJWKvAhcwSsLwWw8ErLF
         idbV3P9PujoXG8LnEzDPWPwCjRTAiUXJPNBhzXlCBx1XmBi0t2uV2nSRXRCYsrH1PnSB
         Cb6dCg/3UoHlwyIKbciCosAVBQemhPQVTmHNbIGOvo6WsH3WY5dRcgtl+btGFHPDjbiS
         KtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rveAeMH6nUFyX5FAstmiBHjqBY6vb+FrCceaPqrZxk4=;
        b=iDEh8r4QcdCvrJM0zNfyzTkle+Rb7d/6q0nCdCXTmYqcgOxW2eUtNWG7431giVUdt0
         9L9osggCQ4MTUgSiXXSoZPPY3SnjwXtdbZ5MOqO/THXCcGmmk8MjV4XEPYohSsvfort9
         y6+XFqbQ5OsRkOrFcXss7r6DpcQaSm8l+ZyQosxJtnSS98qnpcdL1UPJDlyeUjV06LUW
         arNIOFoJy1BT8uQjdvkBxXOfxNlUu9H+xFvmLtG3orO4gb4ZUv6IlchIELp5khTZT4nQ
         efSjr5jP3DmFhwi9ZPCW25ZJkrpjE/TqKshgfZnPcnJm8uafzgYWhHvR8+hUtHX33YqY
         5O0A==
X-Gm-Message-State: APjAAAWhPMVNlJIH5mRdZNx1JI5CMkUDyYYqRydBlx+aQ6jIhCa7QkwX
        0Cgasq/IGCQh4lOlkKB6PlILVISKImMkABymEZIw6w==
X-Google-Smtp-Source: APXvYqyiIxZQ9hatqsRWZAC4sogQuwH4+ap5++pQOwScsiA/n19BN11oN8HPJfsRAP9IkQMd1fMra26mUgXSffr9SPk=
X-Received: by 2002:adf:f406:: with SMTP id g6mr16011124wro.325.1569920195413;
 Tue, 01 Oct 2019 01:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
 <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
 <CALCETrUrbSGNfo=g=PS4=t1zzXqGAHSs5oUL46LwMgu+2aVh1Q@mail.gmail.com> <CAHmME9pgrCY4MHcJ0Or+-5h+k3fWCjrbY50sUjNY4TdfeyBFxg@mail.gmail.com>
In-Reply-To: <CAHmME9pgrCY4MHcJ0Or+-5h+k3fWCjrbY50sUjNY4TdfeyBFxg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 1 Oct 2019 10:56:23 +0200
Message-ID: <CAKv+Gu95AT7HQGYbwzRK307axPO93zYuB7wsZb_-59TbycbPMA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 27 Sep 2019 at 09:21, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Andy,
>
> Thanks for weighing in.
>
> > inlining.  I'd be surprised for chacha20.  If you really want inlining
> > to dictate the overall design, I think you need some real numbers for
> > why it's necessary.  There also needs to be a clear story for how
> > exactly making everything inline plays with the actual decision of
> > which implementation to use.
>
> Take a look at my description for the MIPS case: when on MIPS, the
> arch code is *always* used since it's just straight up scalar
> assembly. In this case, the chacha20_arch function *never* returns
> false [1], which means it's always included [2], so the generic
> implementation gets optimized out, saving disk and memory, which I
> assume MIPS people care about.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/lib/zinc/chacha20/chacha20-mips-glue.c?h=jd/wireguard#n13
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/lib/zinc/chacha20/chacha20.c?h=jd/wireguard#n118
>
> I'm fine with considering this a form of "premature optimization",
> though, and ditching the motivation there.
>
> On Thu, Sep 26, 2019 at 11:37 PM Andy Lutomirski <luto@kernel.org> wrote:
> > My suggestion from way back, which is at
> > least a good deal of the way toward being doable, is to do static
> > calls.  This means that the common code will call out to the arch code
> > via a regular CALL instruction and will *not* inline the arch code.
> > This means that the arch code could live in its own module, it can be
> > selected at boot time, etc.
>
> Alright, let's do static calls, then, to deal with the case of going
> from the entry point implementation in lib/zinc (or lib/crypto, if you
> want, Ard) to the arch-specific implementation in arch/${ARCH}/crypto.
> And then within each arch, we can keep it simple, since everything is
> already in the same directory.
>
> Sound good?
>

Yup.

I posted something to this effect - I am ironing out some wrinkles
doing randconfig builds (with Arnd's help) but the general picture
shouldn't change.
