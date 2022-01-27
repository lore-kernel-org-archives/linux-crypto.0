Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F8DC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 19:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiA0T0q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 14:26:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50882 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiA0T0q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 14:26:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F3C2B8234B
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 19:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B7DC340E4;
        Thu, 27 Jan 2022 19:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643311604;
        bh=6Res9NRPtl5YF/M1Ud8bjLRuxD85faal3wD0WLiFvBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qb6ozEBKceGhedjc1f2FDyBZ+Rv36iJlImMdxU0sCyiz3q1jj5sEGpzTCrzxQOJ3d
         Xr9fvz/IEUB7J1bCYvgJ/HB8oua14QZwH94D/IFhcXoZ/KbrM+Mmp2ITNnYN2WAPda
         bxxvIPmD3WJC0E+FKEs7YBItncUVOD5KvrzfXGks3XAFpdWOp0NXI556TEKN7arPZ0
         5tkGyQTb4A2VTo4npG8QD0L19A2sL61kC8gAIxi+1K5nVzxnrSNsV2Ab0lKFu0eV4K
         M1Pi9NcmyV5fnKCMmWHywM1+EAn5UjkoeWypoPKTWvoP7bIS5pg1PppTXSoSeSY8rE
         Z4BjMGeeo+w8Q==
Date:   Thu, 27 Jan 2022 11:26:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 1/7] crypto: xctr - Add XCTR support
Message-ID: <YfLx8vU1jziBsihp@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-2-nhuck@google.com>
 <CAMj1kXHCXNZEuK7hY5MfiBE2xAHbTN=ZOtm4zKzd4=dfTErgDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHCXNZEuK7hY5MfiBE2xAHbTN=ZOtm4zKzd4=dfTErgDA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 10:42:49AM +0100, Ard Biesheuvel wrote:
> > diff --git a/include/crypto/xctr.h b/include/crypto/xctr.h
> > new file mode 100644
> > index 000000000000..0d025e08ca26
> > --- /dev/null
> > +++ b/include/crypto/xctr.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + * XCTR: XOR Counter mode
> > + *
> > + * Copyright 2021 Google LLC
> > + */
> > +
> > +#include <asm/unaligned.h>
> > +
> > +#ifndef _CRYPTO_XCTR_H
> > +#define _CRYPTO_XCTR_H
> > +
> > +static inline void u32_to_le_block(u8 *a, u32 x, unsigned int size)
> > +{
> > +       memset(a, 0, size);
> > +       put_unaligned(cpu_to_le32(x), (u32 *)a);
> 
> Please use put_unaligned_le32() here.
> 
> And casting 'a' to (u32 *) is invalid C, so just pass 'a' directly.
> Otherwise, the compiler might infer that 'a' is guaranteed to be
> aligned after all, and use an aligned access instead.

I agree that put_unaligned_le32() is more suitable here, but I don't think
casting 'a' to 'u32 *' is undefined; it's only dereferencing it that would be
undefined.  If such casts were undefined, then get_unaligned() and
put_unaligned() would be unusable under any circumstance.  Here's an example of
code that would be incorrect in that case:
https://lore.kernel.org/linux-crypto/20220119093109.1567314-1-ardb@kernel.org

- Eric
