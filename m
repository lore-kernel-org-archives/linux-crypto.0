Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D50C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 19:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245706AbiA0ToP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 14:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245708AbiA0ToF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 14:44:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32827C061747
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:44:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6F27B801BC
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 19:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9581DC340E6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643312642;
        bh=SHfA5+Qmjah1EPAAGDAkqRu40aF4cEcTGEBvuupi2gQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cF/z9oAdv0KkW0NvIbujfO3LI24Te1DaJHM5yXQvmP9qpKTQLKxOytXzVNbmd3cZf
         IgvO1ZGA8fYuEAelVkDeD2Y/nHpzEVBgRZOiQFMVAvhZ/sGa1ZcMK4zL1AZsiApmNY
         fg45woRELF4Z3WZC+IU04PJ5KvXcRO4ac8Dngsexo78dqI0re0QCZztcKtt9kSAPaa
         yDZlXnRCZnEyAOvu6VF0m32o2O5ewxog0DhgorLmzkySSgmlBHw3F03FD4M/xZU5o6
         sQqJL6uSKfZpb+P6JxHEkU6JVuc0ygnxYmzfjS+NvyWA2WFepssR6nEpJRyxvABPGv
         ULM1lslK7fLBA==
Received: by mail-wr1-f43.google.com with SMTP id m14so6442513wrg.12
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:44:02 -0800 (PST)
X-Gm-Message-State: AOAM533m0j0bn91tj+QO4/+U0s7Qgw8CDWdVS/hDwApSjbKjruqSanva
        htrasEr70dMkoa7elcMZjWSv8YMdeT5jpdN/Uds=
X-Google-Smtp-Source: ABdhPJyjRLwlAp2azaYwB6kt87RRibq5qgoxdvafXe+q3EpNiQZpj/t8Vv411h1QLF6PhBVeeLDKBQZ+tlvTuqFspiw=
X-Received: by 2002:a05:6000:15ca:: with SMTP id y10mr4159973wry.417.1643312640906;
 Thu, 27 Jan 2022 11:44:00 -0800 (PST)
MIME-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com> <20220125014422.80552-2-nhuck@google.com>
 <CAMj1kXHCXNZEuK7hY5MfiBE2xAHbTN=ZOtm4zKzd4=dfTErgDA@mail.gmail.com> <YfLx8vU1jziBsihp@sol.localdomain>
In-Reply-To: <YfLx8vU1jziBsihp@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Jan 2022 20:43:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEGvSBoOy+TNK749+sUx8cbwSu7YHYFQKu3vA1XvXrE9Q@mail.gmail.com>
Message-ID: <CAMj1kXEGvSBoOy+TNK749+sUx8cbwSu7YHYFQKu3vA1XvXrE9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/7] crypto: xctr - Add XCTR support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jan 2022 at 20:26, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 27, 2022 at 10:42:49AM +0100, Ard Biesheuvel wrote:
> > > diff --git a/include/crypto/xctr.h b/include/crypto/xctr.h
> > > new file mode 100644
> > > index 000000000000..0d025e08ca26
> > > --- /dev/null
> > > +++ b/include/crypto/xctr.h
> > > @@ -0,0 +1,19 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > +/*
> > > + * XCTR: XOR Counter mode
> > > + *
> > > + * Copyright 2021 Google LLC
> > > + */
> > > +
> > > +#include <asm/unaligned.h>
> > > +
> > > +#ifndef _CRYPTO_XCTR_H
> > > +#define _CRYPTO_XCTR_H
> > > +
> > > +static inline void u32_to_le_block(u8 *a, u32 x, unsigned int size)
> > > +{
> > > +       memset(a, 0, size);
> > > +       put_unaligned(cpu_to_le32(x), (u32 *)a);
> >
> > Please use put_unaligned_le32() here.
> >
> > And casting 'a' to (u32 *) is invalid C, so just pass 'a' directly.
> > Otherwise, the compiler might infer that 'a' is guaranteed to be
> > aligned after all, and use an aligned access instead.
>
> I agree that put_unaligned_le32() is more suitable here, but I don't think
> casting 'a' to 'u32 *' is undefined; it's only dereferencing it that would be
> undefined.  If such casts were undefined, then get_unaligned() and
> put_unaligned() would be unusable under any circumstance.  Here's an example of
> code that would be incorrect in that case:
> https://lore.kernel.org/linux-crypto/20220119093109.1567314-1-ardb@kernel.org
>

Good point :-)
