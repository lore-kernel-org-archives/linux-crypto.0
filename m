Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41141C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B2A21D81
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nAQDAZdT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389071AbfJDO2T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:28:19 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:60179 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389020AbfJDO2T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:28:19 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 15fa848d
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Et90i8w45ambohKuaRgwzItzLHI=; b=nAQDAZ
        dTuA5+wS87j0kXb5x+ol/tip12PUP1v75ovhOTn1WiZAp5gEKJSfWOReF/WuugQD
        WLG5I8nC4Ae2AbDhnlt/G0cXD/OWEnThRZHTMscWLVz9I+BYIettW/UKKddDnjwR
        JcWEjOs/fnyKy6uy1gyT8znb2VGp/5rkinUdoyleA7Ko7irY+J7EnfttFws9kE8c
        3Z3QpzQEOUtnW4Uw+F90S2r7AOKN4Q0X0MJJd09EUT7Nda5MqmzZTs20tZt5RCmo
        aWOxInm5w1/VDQb3+uyFWMgHtMtz1j6l0SE9172lYcXJ7rg6pdNFVqUbOjSh9H+a
        uN5NxEqTzfMcAMsg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b4b7ff50 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 13:41:21 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id 83so5951371oii.1
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:28:16 -0700 (PDT)
X-Gm-Message-State: APjAAAUiGVyOedy01fIhA1cfeh1ooZS5jDMTPUAX+RU02b6iexaM1ki2
        5L/x80i4r5FeYtYrJdAWx4rCOYIsmOXr0upqQ8c=
X-Google-Smtp-Source: APXvYqx5YnjskWDh/YxtMBRITiYq0X0Fgb3EVYC1V0d7e01hfKY1JunwhZX1Q5CwouMlFictCKcNtfNXb12FHQ6s/zo=
X-Received: by 2002:a54:4807:: with SMTP id j7mr6896456oij.122.1570199294731;
 Fri, 04 Oct 2019 07:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-5-ard.biesheuvel@linaro.org> <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
 <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 16:28:03 +0200
X-Gmail-Original-Message-ID: <CAHmME9o5iDgPvztJqWNrWs4Aj1LyVnyGUWWKVNjRjtPpbuP2ZA@mail.gmail.com>
Message-ID: <CAHmME9o5iDgPvztJqWNrWs4Aj1LyVnyGUWWKVNjRjtPpbuP2ZA@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
> > Did these changes make it into the existing tree?
>
> I'd like to keep Eric's code, but if it is really that much faster, we
> might drop it in arch/arm/lib so it supersedes the builtin code that
> /dev/random uses as well.

That was the idea with Zinc. For things like ARM and MIPS, the
optimized scalar code is really quite fast, and is worth using all the
time and not compiling the generic code at all.
