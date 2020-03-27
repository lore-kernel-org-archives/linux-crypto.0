Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45468C43331
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D8F206DB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VLrodBXs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgC0E6E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 00:58:04 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:60559 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgC0E6E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 00:58:04 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 753e66c7
        for <linux-crypto@vger.kernel.org>;
        Fri, 27 Mar 2020 04:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=7gnGUQ2EvAfmMqgVrIQAc5gNH5E=; b=VLrodB
        XsH4FbhaBXFd/NA+zMRXpS2+Igg4VPaZmTY059nNpsgpwEaqPi59VuHZ+Ck1+JBF
        DswvED2ghBCa4IkMWmT1uz5jzguljMOfPisMjJpLeCWSejkXDeBSZseuxjuxGgDI
        pLImjWLDVHRtJQTp27ynC//Q/qqHnwPQy60yCGhk50YFUHFkVY9hGcnlwjbLdvIa
        glG6mVUlI7IurVdxPLtuEU4GF8wH0Ame3TcRogSnD96ljLZeqoYYamZe3HtttG0X
        b8+d2hJVNtNh5rhLjLNKYdpWNIdnEUnbgnbMqwyUvQN0qvKT2neCFPVtiXJT+tRJ
        x4YDoCv3rDI73T0Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9a4261bb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 27 Mar 2020 04:50:34 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id i75so361185ild.13
        for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2020 21:58:02 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2wGd0YXxCI/v7CM4rnTxzML604BGh65q7FKe7iNZbUFGCruZUp
        G8v4bwUG2uSqZcK6eBavAVI4qjIJR8pBP0t3jDk=
X-Google-Smtp-Source: ADFU+vsI0n2RysO9c2Sk5urezKbf8wua2T+yBM4GO30jBfJruJkZIAC103dJ8/6hil0fquVXF8OC80Sob1UJWYPhWY4=
X-Received: by 2002:a92:cc8c:: with SMTP id x12mr12583904ilo.224.1585285081670;
 Thu, 26 Mar 2020 21:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200319180114.6437-1-Jason@zx2c4.com> <20200327045543.GA19982@gondor.apana.org.au>
In-Reply-To: <20200327045543.GA19982@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 26 Mar 2020 22:57:50 -0600
X-Gmail-Original-Message-ID: <CAHmME9osVGrkjkUWaveQX1L3S+0dTtUQNFmFJmv89oHsjkR3-w@mail.gmail.com>
Message-ID: <CAHmME9osVGrkjkUWaveQX1L3S+0dTtUQNFmFJmv89oHsjkR3-w@mail.gmail.com>
Subject: Re: [PATCH crypto] crypto: arm[64]/poly1305 - add artifact to
 .gitignore files
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 26, 2020 at 10:55 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Mar 19, 2020 at 12:01:14PM -0600, Jason A. Donenfeld wrote:
> > The .S_shipped yields a .S, and the pattern in these directories is to
> > add that to .gitignore so that git-status doesn't raise a fuss.
> >
> > Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> > Reported-by: Emil Renner Berthing <kernel@esmil.dk>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  arch/arm/crypto/.gitignore   | 1 +
> >  arch/arm64/crypto/.gitignore | 1 +
> >  2 files changed, 2 insertions(+)
>
> Patch applied.
>
> > diff --git a/arch/arm64/crypto/.gitignore b/arch/arm64/crypto/.gitignore
> > index 879df8781ed5..e403b1343328 100644
> > --- a/arch/arm64/crypto/.gitignore
> > +++ b/arch/arm64/crypto/.gitignore
> > @@ -1,2 +1,3 @@
> >  sha256-core.S
> >  sha512-core.S
> > +poly1305-core.S
>
> This didn't apply because a similar patch had already been added
> to cryptodev a month ago.  Please base your patches on the latest
> cryptodev in future.

I had sent this with [PATCH crypto] in the subject line, meant for
crypto-2.6.git for 5.6, since it's a bug fix for the things there. I
didn't realize you were queuing these changes for 5.7 instead.
