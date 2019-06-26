Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B6AC4646B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 07:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F4152085A
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 07:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FyISUsSv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfFZHPv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 03:15:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38451 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfFZHPv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 03:15:51 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so1095969ioa.5
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2019 00:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pTCFrBIM0ZlXWFqQY/bLyrBIYuhEJZiIVkwQ9g2jE00=;
        b=FyISUsSvIgFbjwYPykHxta83XA1W4jsjUMUJ21oGZceFbdOfOiJVdkIgpXHth+KiNr
         pJlup1HdZzE+egd4FePRKHxn0gVVFe633pq5OG8PGr9I1sGU+gdNGeGqyvoLkAYmxJj7
         +GDl78sj9Bysjgrz/Oyu0zfIg8RdSmzp/ZPsE2SVwW48llbS4jDhbPZD8ccFX3vXGNiv
         JEM6WxhsG7DQL5gmUDHJ2zX3jWs2BlsWEoYu3WJG7iDN2Y3QZkMdN27I4TwxcQnO4q/7
         w54mq8lH7SawzasVULr8wcOPZxVHDLm+iS5K0g3460oHUHJTMplJVid6tkm78MAyzNfg
         OY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pTCFrBIM0ZlXWFqQY/bLyrBIYuhEJZiIVkwQ9g2jE00=;
        b=qJ+AtbCVC39PqP7fhJdDWm/G1+kUFEpg3n99Vtvt6EXLNqVtWJdgPM5hdvu9PCs2pq
         76cPvUpdpLk+oOnQhyIL44Cf+RPhe2FvHRcvZ6pnSI90Xobc49OT+nU1p20bC7V+EmRH
         8rsPTX5NmP3hFuXEvXNAEMGEIW7Nb2ZWjpiu0MBagq7CQJISdoJVBQSkN2MSYAlemzdk
         VIO7jZ6Hs/4iJtcd+hqwSyde/EkI9/36M5wdAhXecdEIof6y+3RXlIZObYA1mgF2Jc7Z
         O8Teg3eKpH8Tl1sVLX1ftNaQhOrkFV1CXhEoTRUUNafOoFdLsbJhD1vvbPTJaUlnpVZw
         icsQ==
X-Gm-Message-State: APjAAAXMfkOiY9PcTIFJFiJj26py3tAbIRH4Pk+uxm7IBfdMOxyBbvu8
        ddPspRtmvZhAnnQ2Ze1HvbFFm3DKwVASLnL7qURgqg==
X-Google-Smtp-Source: APXvYqwShtIKwZA9nXO3me2DO9qf7+3GsrUUaR7wv37RQk1OFfFV9uMbrWm7uSb6fJ2gRHRYC33xL2ZpJc9fJjG2DtE=
X-Received: by 2002:a02:3308:: with SMTP id c8mr498027jae.103.1561533350876;
 Wed, 26 Jun 2019 00:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <20190625171234.GB81914@gmail.com> <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
 <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com>
In-Reply-To: <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 26 Jun 2019 09:15:38 +0200
Message-ID: <CAKv+Gu9jAqGAYg8f_rBVbve=L3AQb_xKnpmnsqrZ3m7VLnaz1g@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 26 Jun 2019 at 09:00, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 25/06/2019 20:37, Ard Biesheuvel wrote:
> > On Tue, 25 Jun 2019 at 19:12, Eric Biggers <ebiggers@kernel.org> wrote:
> >>
> >> [+Cc Milan]
>
> I was discussing this with Ondra before he sent the reply, anyway comments below:
>
> >> On Tue, Jun 25, 2019 at 04:52:54PM +0200, Ard Biesheuvel wrote:
> >>> MORUS was not selected as a winner in the CAESAR competition, which
> >>> is not surprising since it is considered to be cryptographically
> >>> broken. (Note that this is not an implementation defect, but a flaw
> >>> in the underlying algorithm). Since it is unlikely to be in use
> >>> currently, let's remove it before we're stuck with it.
> >>>
> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> ...
> >>
> >> Maybe include a link to the cryptanalysis paper
> >> https://eprint.iacr.org/2019/172.pdf in the commit message, so people seeing
> >> this commit can better understand the reasoning?
> >>
> >
> > Sure.
>
> Yes, definitely include the link please.
>
> >> Otherwise this patch itself looks fine to me, though I'm a little concerned
> >> we'll break someone actually using MORUS.  An alternate approach would be to
> >> leave just the C implementation, and make it print a deprecation warning for a
> >> year or two before actually removing it.  But I'm not sure that's needed, and it
> >> might be counterproductive as it would allow more people to start using it.
> >>
> >
> > Indeed. 'Breaking userspace' is permitted if nobody actually notices,
> > and given how broken MORUS is, anyone who truly cares about security
> > wouldn't have chosen it to begin with. And if it does turn out to be a
> > real issue, we can always put the C version back where it was.
>
> >
> >> From a Google search I don't see any documentation floating around specifically
> >> telling people to use MORUS with cryptsetup, other than an email on the dm-crypt
> >> mailing list (https://www.spinics.net/lists/dm-crypt/msg07763.html) which
> >> mentioned it alongside other options.  So hopefully there are at most a couple
> >> odd adventurous users, who won't mind migrating their data to a new LUKS volume.
>
> Yes, there are perhaps some users.
>
> TL;DR: Despite it, I am for completely removing the MORUS cipher now form the kernel.
> Cryptsetup integrity extension (authenticated encryption) is still marked experimental.
>

Thanks for the insight. So I guess we have consensus that MORUS should
be removed. How about aegis128l and aegis256, which have been
disregarded in favor of aegis128 by CAESAR (note that I sent an
accelerated ARM/arm64 version of aegis128 based on the ARMv8 crypto
instructions, in case you missed it)
