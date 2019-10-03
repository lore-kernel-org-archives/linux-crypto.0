Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD11C4CED1
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 08:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E1821A4C
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 08:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qx9d9qv/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfJCInn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 04:43:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45890 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbfJCInn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 04:43:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so2417063qtj.12
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2019 01:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50RIEioku5CDiSfNzlxsHwpRubKKO5Rp34EruQU7kdU=;
        b=Qx9d9qv/WE3y5X+tlKjqpa0xc/JfvUvTM8z7HZkbCGisehBHJVsgq3YOT+8cevBjq0
         4D0jjGroAASHzwscxa6o3LPdYXuA3i8BaBgg584D5/mYl1aS3Ors9aCoX73tku3X4UiB
         /XiU2I5k4pVafGIMN/OIvJYp2siiD6/DkgCQV2LHzi2V3pbe942Q4dmB5FPGh/J0QVR0
         EYbqMpO064gBDpXcV5RN9t/BneNrIZf1U3cVgkURibQUHVzHb7bKBbYxS1D8SwbJ9SRQ
         +UW20SW2SxtvMxbNdUgXXGeb5xtcUhE7q9vzpEykA51W6UUDENQSnEJnLWoG02j5xzaq
         eEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50RIEioku5CDiSfNzlxsHwpRubKKO5Rp34EruQU7kdU=;
        b=otnfzKwY/3hnCsA0SQCsOBEAW3QjJ1XrvUHG/QsIdsx8Z1TEetHw8iNOuWLCo5U41E
         JLDOPTxKJFHo1xXHjUw41ePnReazjsTh8Z0+iOOdiIXGusYST/ObtI1+kCc8+YwrMsI2
         KgLdxCcv9sLmBuHV2jmzkNrIw5/mlY5F5QmWzrJMboBreE1Z/3xDHmRAzBaNReUDRvUA
         /azXFCqCLIhJJeHkD+92ywnFxl8DYmmBQfYWJdck3l4uK1EXe/22YZiGBW+g/stYfeFn
         A789LFYm9JhiRudGLQqJzTKqoqi2T3gDsHV1yCQxCXpf53j5daPDoeIshU2MWQS3g2dK
         wTFg==
X-Gm-Message-State: APjAAAW2rNZvNloxcAzaPzhKrwQdbHipNw3a8o5ma1boXBuOSNK/0iKD
        3oUVXwV+1ik25sY28qAcDY+0G6W11eWwJnTQ9ll0OY3ZEvc=
X-Google-Smtp-Source: APXvYqxb85V23hEyoMWWCHHp95SDoTIN0rzl23OwBqVTBCvrXgLrjnad0RXcGpmDv2+a3r62UYQEFUpYiJVb8utbL3c=
X-Received: by 2002:aed:2381:: with SMTP id j1mr8670886qtc.373.1570092222344;
 Thu, 03 Oct 2019 01:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 3 Oct 2019 10:43:29 +0200
Message-ID: <CAKv+Gu-+3AWNAK0WWSFQT15Q3r6ak7wGr3ZROyJ35-4GN6=iJQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
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

On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
...
>
> In the future, I would like to extend these interfaces to use static calls,
> so that the accelerated implementations can be [un]plugged at runtime. For
> the time being, we rely on weak aliases and conditional exports so that the
> users of the library interfaces link directly to the accelerated versions,
> but without the ability to unplug them.
>

As it turns out, we don't actually need static calls for this.
Instead, we can simply permit weak symbol references to go unresolved
between modules (as we already do in the kernel itself, due to the
fact that ELF permits it), and have the accelerated code live in
separate modules that may not be loadable on certain systems, or be
blacklisted by the user.
