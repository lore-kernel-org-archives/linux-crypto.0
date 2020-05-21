Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9899C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 13:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960F92072C
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 13:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="A+cQUoka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgEUNBs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 09:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgEUNBr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 09:01:47 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9260FC061A0E
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2020 06:01:47 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id t4so2023596vsq.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2020 06:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gjDV6wdVoxT/9fCvE29lP7McG7rySuctHCYfO/Iaawk=;
        b=A+cQUoka9CcrIXRfGc4hOl7D5nMttgd+RnJxbpmoqAMxSpZ4YwMuG4O/6mBqPOHB2j
         RvIXdFW+ybr+/4P/gi8LwGD3Ql4S5peFYQ07yHi8L+9s/Jt+80TLsm7pcdXZ5kasdIyR
         BiFRneP7lXDC/KRv8cDRbeYukoJuWZek6kSWr1UMqUL0lWEpYbW6qCXlUt18xR0X6tOV
         dhrF1uw4Y42NIgfJtgh1q4Np6zKi6ACdRXG5rYyzTRVG1aq43HEKLA4LNAnZ6s4H3Upq
         329mT8IZIpMQIofWvmGUbByrdWpEFMPlyD/GW4jBEGI4qS3H/93959QAfF1sz9AEBHKM
         SyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gjDV6wdVoxT/9fCvE29lP7McG7rySuctHCYfO/Iaawk=;
        b=kBNc/MgLpkUIKp+4sXoNEPbu3eGeWRFTfqU3jba9U56jejujDvHlFiS+tmaoFauXbR
         HoS5qCohF6BmFSljiIbWX5X2C3/PE0XNoTDe3h+iZADSwmcfcSW73Tu5ziPAIlgeLuVM
         MPp8OHF/0PGhtuYBGCr/IrcAUwrYY+fNimwPvku9jXIHpYC53d0SetuqdgbeV8hopmPI
         JIVe0a6S3dOnEaTMOwISZsT80h6fJrgANL7O54OgQKzZw0pK//IxlAXrJ2EdDescLMEN
         GnLzoWGv1Et7fdFv1H4cU7LGi5DXawuU8gw/xi26Z1s6C334XMZETB4oU1qLDe2m+V0y
         HvCg==
X-Gm-Message-State: AOAM532pAhPZYgtFk5J9gYKKuBIvZ7Hmq8xd9tkKnvTHT8oSkOcCKnRo
        r0Ezv+wBKc2Jqi/3om9vOnRIiNbtprOrO3S/+IyNTCtzloBiRQ==
X-Google-Smtp-Source: ABdhPJye19zWdmn8Su73iyvBPelzLJXAOZwEgE+CL1ky9yRyelHLRGrsW2SRu5NtsPzuYpEhektLLbXaCkf3RClTkBU=
X-Received: by 2002:a67:f890:: with SMTP id h16mr7035241vso.193.1590066105863;
 Thu, 21 May 2020 06:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <16394356.0UTfFWEGjO@tauon.chronox.de>
 <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com>
 <2010567.jSmZeKYv2B@tauon.chronox.de> <CAMj1kXGNqo=d-hgK=0zBZCoJYgSxxhhm=Jdk2gAGXPo1-KSCgA@mail.gmail.com>
In-Reply-To: <CAMj1kXGNqo=d-hgK=0zBZCoJYgSxxhhm=Jdk2gAGXPo1-KSCgA@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 21 May 2020 16:01:34 +0300
Message-ID: <CAOtvUMc8PhToLDVO+Y4NVhVkA6B7yndp3gbaeaQZJtrW_NSzaw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

Thank you for looping me in.

On Wed, May 20, 2020 at 10:09 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 20 May 2020 at 09:01, Stephan Mueller <smueller@chronox.de> wrote=
:
> >
> > Am Mittwoch, 20. Mai 2020, 08:54:10 CEST schrieb Ard Biesheuvel:
> >
> > Hi Ard,
> >
> > > On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox.de> w=
rote:
> ...
> > > > The state of all block chaining modes we currently have is defined =
with
> > > > the
> > > > IV. That is the reason why I mentioned it can be implemented statel=
ess
> > > > when I am able to get the IV output from the previous operation.
> > >
> > > But it is simply the same as the penultimate block of ciphertext. So
> > > you can simply capture it after encrypt, or before decrypt. There is
> > > really no need to rely on the CTS transformation to pass it back to
> > > you via the buffer that is only specified to provide an input to the
> > > CTS transform.
> >
> > Let me recheck that as I am not fully sure on that one. But if it can b=
e
> > handled that way, it would make life easier.
>
> Please refer to patch 2. The .iv_out test vectors were all simply
> copied from the appropriate offset into the associated .ctext member.

Not surprisingly since to the best of my understanding this behaviour
is not strictly specified, ccree currently fails the IV output check
with the 2nd version of the patch.

If I understand you correctly, the expected output IV is simply the
next to last block of the ciphertext?

Thanks,
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
