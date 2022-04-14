Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF98C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 07:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbiDNHSU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 03:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiDNHST (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 03:18:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF449F9B
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 00:15:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A9661F2F
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2516C385A1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649920553;
        bh=EeV/5Nhdg/5bu9cfDt0xS09M8xVJV+b2pAVgIXM9lio=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RKbZpmHt/FaZvRse12kTPsVac6uMr4L1qYv2+c8TmFqTRu7LIaHkvYvytvE1IBp9c
         WA09atZlJCHEpTYDmvDlcFblSKquIyCHtr2kKEc1+M95/v79ZiQQSFuyrXuQHHgnyO
         2invVhfTo8VtdL9bjWAgfaGfntFJBzID/vGpSb0Thco9w1VJRhvzF0rMatKEg22lNY
         1KAYqhcvdKkzsZ3+WhOtDGfeFNfQTYx8gzxuxaCreYxDVIa1qeDXYj8B8Q2cX58ZZ2
         xZ1kIPER1Pyjs0Vctk8xWe43iPZxQSFDnp+q2tiftsQxBqk5d1V8UaUFGRENzfD/0C
         CBjnrg7VhtWKg==
Received: by mail-oo1-f47.google.com with SMTP id c2-20020a4aacc2000000b003333c8697bbso78715oon.12
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 00:15:53 -0700 (PDT)
X-Gm-Message-State: AOAM532zB61NgeV5IEsIp0bbnTJQIbVYcj2x0PO1Vd0Z/eorxWZG/Tfi
        7zeTgmLW1kzGsN+QlkRS+bYY5TsCb7dCbKjMKms=
X-Google-Smtp-Source: ABdhPJwU8m6J1/8TnOfpldGcdxoxNXyxO6cQyeM/8MHRmGfEbICG+w0u6oMeo2B26uGCEZYTX2S7qSio6Rs+TXJnzOk=
X-Received: by 2002:a4a:e6c2:0:b0:329:1863:6c3a with SMTP id
 v2-20020a4ae6c2000000b0032918636c3amr392945oot.98.1649920552947; Thu, 14 Apr
 2022 00:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220412172816.917723-1-nhuck@google.com> <20220412172816.917723-9-nhuck@google.com>
 <YlZpUijo/1nJp0Bw@sol.localdomain> <CAMj1kXH1C8W6Cxa7jTZ8_h3L4_Xefwv2=r1JRNva101CvWWsjw@mail.gmail.com>
 <YlfJYwwCukoGuLek@sol.localdomain>
In-Reply-To: <YlfJYwwCukoGuLek@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Apr 2022 09:15:42 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGS_vtcgZSB5qXt4dekTb51FeZ7yMWbtu8-DrvFU39ogA@mail.gmail.com>
Message-ID: <CAMj1kXGS_vtcgZSB5qXt4dekTb51FeZ7yMWbtu8-DrvFU39ogA@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] fscrypt: Add HCTR2 support for filename encryption
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

On Thu, 14 Apr 2022 at 09:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Apr 13, 2022 at 08:16:25AM +0200, Ard Biesheuvel wrote:
> > > > diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
> > > > index 9f4428be3e36..a756b29afcc2 100644
> > > > --- a/tools/include/uapi/linux/fscrypt.h
> > > > +++ b/tools/include/uapi/linux/fscrypt.h
> > > > @@ -27,7 +27,8 @@
> > > >  #define FSCRYPT_MODE_AES_128_CBC             5
> > > >  #define FSCRYPT_MODE_AES_128_CTS             6
> > > >  #define FSCRYPT_MODE_ADIANTUM                        9
> > > > -/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> > > > +#define FSCRYPT_MODE_AES_256_HCTR2           10
> > > > +/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> > > >
> > >
> > > As far as I know, you don't actually need to update the copy of UAPI headers in
> > > tools/.  The people who maintain those files handle that.  It doesn't make sense
> > > to have copies of files in the source tree anyway.
> > >
> >
> > Doesn't the x86 build emit a warning if these go out of sync?
>
> The warning is emitted when building tools/perf/, not the kernel itself.
>
> According to https://lore.kernel.org/r/20191001185741.GD13904@kernel.org, the
> perf maintainers actually prefer that their files are *not* updated for them.
> And I'd like to push back against having duplicate source files in the tree
> anyway, for obvious reasons.  So I think we shouldn't update this file.
>

Fair enough.
