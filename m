Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1434EEB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jun 2023 18:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjFWSin (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jun 2023 14:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjFWSid (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2023 14:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8F1273D
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 11:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73FD961ACF
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 18:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D7BC433C0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687545491;
        bh=OtWHIwsSfrQ1UbW0o6UkWOmN15JAugavya5osLAtWxk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MwIuyytOCpzi5bTEpXsIlv89e8oVc40ptpIpx/AYq/yeLeHuK6BH/2op0mH0ygtTA
         OeQhyIVlF858fxkBrEj7KMajanqkBcVt7PsJT5wIoEXxQNTZS6s7t77yxN3JtlP6iB
         CbCXWDIuODC89jAgOoM83FYf227Qu5RbxWhdUF0ctNrDQCpMHO0IA4zAHvVq5WE/tq
         zmtxsKlvXaPfYr827sh8mE2btun4j8gZ09eR05yN8m7pbm/i97gi3vH3fhUgsc/l/L
         M4D5snI+stVJQ2plP/PVpRWb4j+7OIumEo9NXklDShUDu4vCRwzxfu+cvySt22hAo3
         IFWFCnijK2zxw==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2b4826ba943so15929501fa.0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2023 11:38:11 -0700 (PDT)
X-Gm-Message-State: AC+VfDxxUsqyyQKxG55guvSh4arpVqwpx3qXY7gzIAPIRHH3C9TtAPVj
        9NIPiPXP9WkV/WR8C8O389cfOaVRuhbHtBawh44=
X-Google-Smtp-Source: ACHHUZ6cc+8gpcupzcqws5C34Ikcj04oxb+vkdLZprFolSCtLBG/2Bs0QU67hkAsDlUfg+GH/BP3oAJNh14unDCcjBo=
X-Received: by 2002:a05:6512:340f:b0:4f5:1418:e230 with SMTP id
 i15-20020a056512340f00b004f51418e230mr15249612lfr.52.1687545489648; Fri, 23
 Jun 2023 11:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230606173127.4050254-1-ardb@kernel.org> <20230606173127.4050254-3-ardb@kernel.org>
 <ZIQmrj7lh7cCfC_C@debian.me> <CAC1cPGzQKwXt=2fHT4HLwGmdqDDGCmvY9iBcvoC9OEuW0qFsGw@mail.gmail.com>
In-Reply-To: <CAC1cPGzQKwXt=2fHT4HLwGmdqDDGCmvY9iBcvoC9OEuW0qFsGw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 23 Jun 2023 20:37:58 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH=oJMO-j=rdbGuEu2ntz1DeXu2cYL8utm25OUhnrpm2Q@mail.gmail.com>
Message-ID: <CAMj1kXH=oJMO-j=rdbGuEu2ntz1DeXu2cYL8utm25OUhnrpm2Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: arm - add some missing SPDX headers
To:     Richard Fontana <rfontana@redhat.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 20 Jun 2023 at 05:50, Richard Fontana <rfontana@redhat.com> wrote:
>
> On Sat, Jun 10, 2023 at 3:31=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.c=
om> wrote:
> >
> > [also Cc'ing Richard]
> >
> > On Tue, Jun 06, 2023 at 07:31:26PM +0200, Ard Biesheuvel wrote:
> > > Add some missing SPDX headers, and drop the associated boilerplate
> > > license text to/from the ARM implementations of ChaCha, CRC-32 and
> > > CRC-T10DIF.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm/crypto/chacha-neon-core.S  | 10 +----
> > >  arch/arm/crypto/crc32-ce-core.S     | 30 ++-------------
> > >  arch/arm/crypto/crct10dif-ce-core.S | 40 +-------------------
> > >  3 files changed, 5 insertions(+), 75 deletions(-)
> > >
> > > diff --git a/arch/arm/crypto/chacha-neon-core.S b/arch/arm/crypto/cha=
cha-neon-core.S
> > > index 13d12f672656bb8d..46d708118ef948ec 100644
> > > --- a/arch/arm/crypto/chacha-neon-core.S
> > > +++ b/arch/arm/crypto/chacha-neon-core.S
> > > @@ -1,21 +1,13 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > >  /*
> > >   * ChaCha/XChaCha NEON helper functions
> > >   *
> > >   * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> > >   *
> > > - * This program is free software; you can redistribute it and/or mod=
ify
> > > - * it under the terms of the GNU General Public License version 2 as
> > > - * published by the Free Software Foundation.
> > > - *
> > >   * Based on:
> > >   * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSE3 functions
> > >   *
> > >   * Copyright (C) 2015 Martin Willi
> > > - *
> > > - * This program is free software; you can redistribute it and/or mod=
ify
> > > - * it under the terms of the GNU General Public License as published=
 by
> > > - * the Free Software Foundation; either version 2 of the License, or
> > > - * (at your option) any later version.
> > >   */
> >
> > I think above makes sense, since I had to pick the most restrictive one
> > to satisfy both license option (GPL-2.0+ or GPL-2.0-only).
>
> I am not sure "had to pick the most restrictive one" is necessarily
> correct - the kernel could adopt that approach but I don't think
> there's any reason why you can't have multiple
> SPDX-License-Identifier: lines in a single source file, and it is also
> syntactically valid to use
> SPDX-License-Identifier: GPL-2.0-only AND GPL-2.0-or-later
>

For the record, my reasoning was that my code (which is a rewrite of
the algorithm using a completely different ISA) is the derived work,
and I am permitted to exercise my right granted by the original work
to redistribute it under the GPLv2. So this is why the 'outer' license
(as well a the SPDX header) is GPLv2 only.

I didn't expect there to be a requirement for SPDX to describe the
original licenses of all the constituent parts.

In any case, I am going to take Greg's advice and not pursue this any
further - if anyone needs this cleaned up, they can do it themselves.

Thanks for the education on this topic, I'll know better next time :-)
