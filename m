Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85770C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 21:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C2D4206CD
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 21:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfJKVjQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 17:39:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37147 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfJKVjQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 17:39:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id l49so1967563qtc.4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 14:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Emaejysl5mBHMeLX8UojNwQG/pC4GtfE2Q5wUE+vjxs=;
        b=Uo3CtT60Qdym/9pjaDJ7wx2vN+KhjKcTw2oqzCVzr9u6xnCCbgryWYLYmQC97OiNqv
         BqpaWDbaspH5U7aaCP2U7UWYrv1OZEBPYjFYQdJN5HT0nMcyRhJc3r6h9GBd7pzNbBAJ
         ui/DaBZrJ10O7yovUk2VA3XDxwZGeh/EUOI3XcYwgexC+zIOgZUO/oipwGC16D6ztcFw
         jNnhMGKI/Ld+6Ng5lXilJEQpCX0JX9mfZTy+6s6AJWEENTtst8dLBarmbrGgfLdOYCyQ
         9Eq74fQUCf/A9pSqumqBFUBs8ebuAA2a2j1t5LatV0QI6JuWFLG0LMFtkKyZUsMiZNIR
         UhPw==
X-Gm-Message-State: APjAAAU1LYfqrZh3nBHsmW6CnRElY6TTprvXos5ho/2dKPXDt/8ur+de
        oDXh/5xehcwHrPZfBJrthxI2i89WCt2QmjLyKBg=
X-Google-Smtp-Source: APXvYqzowDYKytV3s0hJR0MZAZFtLNuPMTaejX+1aVKB9vWHZFQXRxWFPD2G6jlsWwd57/3y2+cWAICi4ZAg4hPSbJQ=
X-Received: by 2002:aed:3c67:: with SMTP id u36mr19227623qte.142.1570829954952;
 Fri, 11 Oct 2019 14:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org> <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
 <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org> <CABb3=+a5zegft0e8ixCVe0xc=FAV1W-bse3x5qhytQ8GKJTJPA@mail.gmail.com>
 <20191011172133.Horde.sxiyClHzSJAUvHtYJdMQEbN@www.vdorst.com>
In-Reply-To: <20191011172133.Horde.sxiyClHzSJAUvHtYJdMQEbN@www.vdorst.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 11 Oct 2019 23:38:58 +0200
Message-ID: <CAK8P3a3g00MzLXRBjk7C6BuMd-Y1YHjC2_zUSO+_cgUyixzcQg@mail.gmail.com>
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     Andy Polyakov <appro@cryptogams.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 7:21 PM René van Dorst <opensource@vdorst.com> wrote:
> Quoting Andy Polyakov <appro@cryptogams.org>:
> > On 10/8/19 1:38 PM, Andy Polyakov wrote:
> > As an example, MIPS 1004K manual discusses that that there are two
> > options for multiplier for this core, proper and poor-man's. Proper
> > multiplier unit can issue multiplication or multiplication-n-add each
> > cycle, with multiplication latency apparently being 4. Poor-man's unit
> > on the other hand can issue multiplication each 32nd[!] cycle with
> > corresponding latency. This means that core with poor-man's unit would
> > perform ~13% worse than it could have been. Updated module does use
> > multiply-by-1-n-add, so this note is effectively for reference in case
> > "poor man" wonders.
>
> Thanks for this information.
> I wonder how many devices do exist with the "poor man" version.

I'm fairly sure the MT7621 is the only 1004k supported by the mainline
Linux kernel today, and likely the only one that will ever run this code.

Ralink/Mediatek, Lantiq/Intel and Ikanos/Qualcomm had some other
SoCs based on the related 34k core with an optional iterative multiplier,
out of those only Lantiq ARX100/VRX200 has support in Linux or
OpenWRT.

Everyone else (in the wireless and router space at least) seems to have
skipped the 34k/1004k and only used 24k or 74k/1074k based chips that
are the most common and have a fast multiplier, or some custom mips
core.

      Arnd
