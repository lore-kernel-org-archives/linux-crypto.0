Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCA6C55179
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 06:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB6721655
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 06:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="Ojl6JlAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbgJ0G7g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 02:59:36 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37985 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgJ0G7f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 02:59:35 -0400
Received: by mail-yb1-f193.google.com with SMTP id b138so363832yba.5
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 23:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/MJ+UTfnuNYWSl6F6YSIZ4D2DyAhRF8y858D6tasEvw=;
        b=Ojl6JlAN3zbm1LbCOHvpxKHmr3L5vs2pku5A2tc4RvlhiU4fWtenEdLlujKmeaGUC7
         aqlL3W3bCv/Dt56pp+AZ5AHOyb7JkxXmw6wbM1XwxiZgb/6/C2gsf5XhDEdQuyGMHu1u
         vhfblhEok3wrb0k+5LrnzzO5GPKgypY8HiDrJaGyWfMz3TY5NFWjIWSp3eUOIS2NoSCI
         TyVuaIjNkYUNTkRvu0tIoctrY2MqgImQWSBodF8ZPCITXRf2L+EUXZQ05EdgP43jUAUM
         1KmSuO3DQjCsHBlYwfkzB2mWMxmkgeFELaBURyuXFadqBG0mtb3jPz+KAzp/EriNXiEE
         Pnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/MJ+UTfnuNYWSl6F6YSIZ4D2DyAhRF8y858D6tasEvw=;
        b=dHL1Log0Pj1MyxflC9mV0dVQwRj32BbDQiW8Z/+c7WmRAfm3zg82Brx0Co8rBSgEGy
         wl3Q91StptW1B02M1ZztCp+KzqvsRVQVZ9U2HqAFjr9of/nnKGLykau4HC/ZZXTkDWkE
         J9V/1LBUxeMY936nN6oWy0huKPIrFmxSFyv3Lh3Exqn2Ut2J+8kl7Ic/vTWlohzSduL/
         rDQhZ2vIygpdAd/LNQQdk5SKKpRZWGb4sXooetbDHOETXeKsatEufAEY+RnA7/Z5CSU7
         mXQGDi6LcILbV3mN6oZoxhz1weqCZnUPgT8dzGxniQNXoDvoxUg/8xdPE4vWWY4jr1ch
         I+Vw==
X-Gm-Message-State: AOAM532ZZKM7kTSD2G1MrJyTCU918oSQgTt+m4c+cLE67yvTKdb0SpLo
        cblCN6sTfUfNH65HVPpI8lDAUHlSv9GypK0MCQyG2Q==
X-Google-Smtp-Source: ABdhPJz+9qYgc6z6pEq4anawMnwD8UgeJFA5p9U95SlGuQbt5EuEgoDjkIODeWkTxrO6zuIhQ9mwwY+zQLKSY3uumOg=
X-Received: by 2002:a25:6609:: with SMTP id a9mr1102464ybc.375.1603781973236;
 Mon, 26 Oct 2020 23:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201026130450.6947-1-gilad@benyossef.com> <20201026130450.6947-4-gilad@benyossef.com>
 <20201026175231.GG858@sol.localdomain> <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
 <20201026183936.GJ858@sol.localdomain> <fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
In-Reply-To: <fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 27 Oct 2020 08:59:27 +0200
Message-ID: <CAOtvUMdatUOnffg90aEGanD0y1LtKc7EeKQ=E+N+W-wpo8Zo3A@mail.gmail.com>
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 9:04 PM Milan Broz <gmazyland@gmail.com> wrote:
>
>
>
> On 26/10/2020 19:39, Eric Biggers wrote:
> > On Mon, Oct 26, 2020 at 07:29:57PM +0100, Milan Broz wrote:
> >> On 26/10/2020 18:52, Eric Biggers wrote:
> >>> On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
> >>>> Replace the explicit EBOIV handling in the dm-crypt driver with call=
s
> >>>> into the crypto API, which now possesses the capability to perform
> >>>> this processing within the crypto subsystem.
> >>>>
> >>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >>>>
> >>>> ---
> >>>>  drivers/md/Kconfig    |  1 +
> >>>>  drivers/md/dm-crypt.c | 61 ++++++++++++++--------------------------=
---
> >>>>  2 files changed, 20 insertions(+), 42 deletions(-)
> >>>>
> >>>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> >>>> index 30ba3573626c..ca6e56a72281 100644
> >>>> --- a/drivers/md/Kconfig
> >>>> +++ b/drivers/md/Kconfig
> >>>> @@ -273,6 +273,7 @@ config DM_CRYPT
> >>>>    select CRYPTO
> >>>>    select CRYPTO_CBC
> >>>>    select CRYPTO_ESSIV
> >>>> +  select CRYPTO_EBOIV
> >>>>    help
> >>>>      This device-mapper target allows you to create a device that
> >>>>      transparently encrypts the data on it. You'll need to activate
> >>>
> >>> Can CRYPTO_EBOIV please not be selected by default?  If someone reall=
y wants
> >>> Bitlocker compatibility support, they can select this option themselv=
es.
> >>
> >> Please no! Until this move of IV to crypto API, we can rely on
> >> support in dm-crypt (if it is not supported, it is just a very old ker=
nel).
> >> (Actually, this was the first thing I checked in this patchset - if it=
 is
> >> unconditionally enabled for compatibility once dmcrypt is selected.)
> >>
> >> People already use removable devices with BitLocker.
> >> It was the whole point that it works out-of-the-box without enabling a=
nything.
> >>
> >> If you insist on this to be optional, please better keep this IV insid=
e dmcrypt.
> >> (EBOIV has no other use than for disk encryption anyway.)
> >>
> >> Or maybe another option would be to introduce option under dm-crypt Kc=
onfig that
> >> defaults to enabled (like support for foreign/legacy disk encryption s=
chemes) and that
> >> selects these IVs/modes.
> >> But requiring some random switch in crypto API will only confuse users=
.
> >
> > CONFIG_DM_CRYPT can either select every weird combination of algorithms=
 anyone
> > can ever be using, or it can select some defaults and require any other=
 needed
> > algorithms to be explicitly selected.
> >
> > In reality, dm-crypt has never even selected any particular block ciphe=
rs, even
> > AES.  Nor has it ever selected XTS.  So it's actually always made users=
 (or
> > kernel distributors) explicitly select algorithms.  Why the Bitlocker s=
upport
> > suddenly different?
> >
> > I'd think a lot of dm-crypt users don't want to bloat their kernels wit=
h random
> > legacy algorithms.
>
> Yes, but IV is in reality not a cryptographic algorithm, it is kind-of a =
configuration
> "option" of sector encryption mode here.
>
> We had all of disk-IV inside dmcrypt before - but once it is partially mo=
ved into crypto API
> (ESSIV, EBOIV for now), it becomes much more complicated for user to sele=
ct what he needs.
>
> I think we have no way to check that IV is available from userspace - it
> will report the same error as if block cipher is not available, not helpi=
ng user much
> with the error.
>
> But then I also think we should add abstract dm-crypt options here (Legac=
y TrueCrypt modes,
> Bitlocker modes) that will select these crypto API configuration switches=
.
> Otherwise it will be only a complicated matrix of crypto API options...

hm... just thinking out loud, but maybe the right say to go is to not
have a build dependency,
but add some user assistance code in cryptosetup that parses
/proc/crypto after failures to
try and suggest the user with a way forward?

e.g. if eboiv mapping initiation fails, scan /proc/crypto and either
warn of a lack of AES
or, assuming some instance of AES is found, warn of lack of EBOIV.
It's a little messy
and heuristic code for sure, but it lives in a user space utility.

Does that sound sane?
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
