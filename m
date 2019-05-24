Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F006FC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A765E20879
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w8yp/iaQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389716AbfEXJPu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:15:50 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:33666 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389569AbfEXJPu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:15:50 -0400
Received: by mail-io1-f53.google.com with SMTP id z4so7250114iol.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 02:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q0v7EeLEIQ8MAjf8JXayR03JPLTlAekwvZg69w5nTyA=;
        b=w8yp/iaQVmyXoAPkus2gp+9G0Gsg+RGuj0+XsI0uTQ408zJfjK8xv8W7ROxJZeechJ
         HDZS/SV+9YQnDnTZP63J9IK967Yh0uij9OLHRdKkJF/IxlfkLppdoPIdY59Wqp9ehTgH
         L82ijorx6SoJCPWa8biIlW42xuocy1DSOdqzhqH0NRgcMdlbV7aXCkoM8+Agme3wQpvj
         Q8ooQGl1lni2eeyUhUvWhI9bvbuaNYYeoemS51aiUJwiYHk+kvUcqtklwAhE/fYUR7Xq
         1ep5TkFWKPPXqFb43s6grlrr0fRtp8Pz14fUwBNzzBcvK0T3dvgD3tuI1dGbIzK5lKKO
         xZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q0v7EeLEIQ8MAjf8JXayR03JPLTlAekwvZg69w5nTyA=;
        b=nfyNmrsliANYDPmDoHAKHwck9Nx90SWfqQFFg/lbXTli1mL/FvvmgA3UuoLD13oAF6
         BadWk4Pg9gGWNkHZyHMQK3Aa78/XYIDhX+OejovLpMH29W2iCZB8mmXVeVOm/bDRYIb2
         PUsl+IYa5/EtaKyvOEsHrgRa6nQOdjI6qK4adXb8NpSc9580OGUn90eHJdNlYsqVnaJV
         O+PO/LcFwgO5SOgq6Z7DrJ6KThczVSpCaifka02rrjlqkAyLSLXhX1U2mFq57hp4A1ft
         kvVebZBTpd2ncEF592hN12Y6uzfvp7ovapUBvRstuUNyAKx3RZsKZyuoC1kUAv8jUMHD
         8ybw==
X-Gm-Message-State: APjAAAUmhT/IUQCX/+eACwD6CZGnQ+wxz5b5B/Lg0NDp6lUg82Ao57rb
        2Hs9jM7UmontsYqyeXGKuu6PgIrSyVSqOKolR1j/Bw==
X-Google-Smtp-Source: APXvYqzFrcO3lUVXttPABO0Bw6PPC3Uu5wrDTY7u02MCHz1wj5o7ySHm8JkSfYPpejoNWMLk0odmfP/KHX9nDe0b4+8=
X-Received: by 2002:a05:6602:2109:: with SMTP id x9mr16521293iox.128.1558689349025;
 Fri, 24 May 2019 02:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com> <AM6PR09MB3523A3C44CFE5C83746B6136D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523A3C44CFE5C83746B6136D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 24 May 2019 11:15:35 +0200
Message-ID: <CAKv+Gu_-Z9rVC4Yup1ZyhES4-bYopMVNWw4-0d+G2oFD83z7OA@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 24 May 2019 at 09:47, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > > Valid? A totally fabricated case, if you ask me. Yes, you could do that,
> > > but is it *useful* at all? Really?
> >
> > Yes, really. The likelihood of a test vector occurring in practice is
> > entirely irrelevant. What matters is that the test vectors provide
> > known outputs for known inputs, and many algorithm specifications
> > explicitly contain the empty message as one of the documented test
> > vectors.
> >
> I wholeheartedly disagree - in the context of hardware design, anyway.
> When you implement something, you care about practicle usability.
> Wasting gates / timing / power / cycles / whatever on something that
> has no use relevant use case is just silly. (In the particular case of
> zero length messages, this is not so trivial to implement in a data
> driven HW architecture! Data driven ... But no data ...)
> As long as you properly specify your hardware's limitations, it should
> not need to be an issue. If the HW doesn't match your use case, then
> don't use it for that ... HW almost always has such limitations.
>
> For FIPS certification, zero length vectors are considered *optional*.
> Probably because they realized most HW out there can't do it ...
>
> > In fact, given the above, I am slightly shocked that your hardware
> > does not handle empty messages correctly. Are you sure it is a
> > hardware problem and not a driver problem?
> >
> As a matter of fact, pretty sure, yeah, as I'm actually "the HW guy".
>

Apologies, I did not mean to imply that you don't understand your own hardware.

> Nothing really shocking about that. We mainly do network protocol
> acceleration anyway, being able to do some basic operations is just a
> bonus. We do specify very extensively what we can and cannot support.
>
> > In any case, as Eric points out as well, nothing is stopping you from
> > adding a special case to your driver that falls back to the software
> > implementation for known broken test cases.
> >
> Sure. But my point is that you end up with a driver full of special cases.
> Which is just bloat slowing it down and blowing it up.
>

Those are usually the consequences of a HW guy deciding to punt
something to software. The software never looks better for it :-)

> Besides, in order to be able to fallback to software for this case
> I would have to maintain a shadow software context for *every* HW context
> just because someone *might* do some zero length operation somewhere in
> the future. Because by the time the context is established (setkey),
> I cannot predict that I will get such a zero length request yet. Yuck.
>

Yuck indeed. Sacrificing correctness for reduced silicon area comes with a cost.

> > Removing test cases from the set because of broken hardware is out of
> > the question IMO. It doesn't actually fix the problem, and it may
> > actually result in breakage, especially for h/w accelerated crypto
> > exposed to userland, of which we have no idea whatsoever how it is
> > being used, and whether correct handling of zero length vectors is
> > likely to break anything or not.
> >
> The driver could check for it and return an -EINVAL error code.
> That would not break anything besides the application itself trying
> to do this. Which could then fail gracefully.
>

This is intractible. Software already exists that does not treat the
zero length vector as a special case. Such software may be plumbed
into the kernel crypto API via its AF_ALG interface. So the only
wiggling room we have is in the kernel driver.

> > > No, it's not because a file of length 0 is a file of length 0, the length
> > > in itself is sufficient guarantee of its contents. The hash does not add
> > > *anything* in this case. It's a constant anyway, the same value for *any*
> > > zero-length file. It doesn't tell you anything you didn't already know.
> > > IMHO the tool should just return a message stating "hashing an empty file
> > > does not make any sense at all ...".
> > >
> >
> > You are making assumptions about how the crypto is being used at a
> > higher level. Eric's example may not make sense to you, but arguing
> > that *any* use of sha256sum on empty files is guaranteed to be
> > non-sensical in all imaginable cases is ridiculous.
> >
> Actually, the thought occurred to me in the shower this morning that that
> *might* be useful in case you don't have expectations of the length
> whatsoever and only know the expected sum. In which case that would
> validate that a zero-length file is indeed what you should have ...
>
> Still - is that something the crypto API is *currently* being used for?
> And if not, do we ever *intend* to use it for something like that?
> If not, then we could just specify it to be illegal such that no one
> would ever attempt to do it. You have that freedom as long as there are
> no existing applications depending on it ...
>

As others have pointed out as well, h/w accelerated crypto is exposed
to userland, so nobody knows how exactly it is being used in the
field.
