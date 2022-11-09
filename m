Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28540C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Nov 2022 10:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKIKFk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 05:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKIKFj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 05:05:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4726365
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 02:05:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4A05B81CED
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 10:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BDFC433C1
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 10:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667988334;
        bh=SdShPDo8seKi2ttg5ulGnAQY422cQybk529pPjOLYak=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Rv7tm7uYpyMBAmWNz+0Cc+V2/RseYr6PduG8Dn7tx2Xf9FZXTz0OnwgJ35uqBr1rv
         UhKDq9cZCHajprHo+6vRk5ForR9bwapBJMAD7+qz6bKocwfjiZ6w5PdkJAuh9Kiw07
         Qo9f+vN/0HJ7iags65FHnEt35l4GfV717eUP7UUrI2B+LeSwlBuagl02UfFQtDhRfX
         miU82klkTyRaVnIOr6d+XIy5yFmf5kdN4/ogok2nko3CxG3NmTnkLyVzc04n2NrIeO
         q2IZIBkfZ4bG/YKslKlJsiiII9lWfVg8a1zsFwHcAm7ZKjwcvTaAPur+GHJZTrsGJm
         xPxAeCbvAAX5w==
Received: by mail-lf1-f45.google.com with SMTP id g12so24901571lfh.3
        for <linux-crypto@vger.kernel.org>; Wed, 09 Nov 2022 02:05:34 -0800 (PST)
X-Gm-Message-State: ACrzQf1qQFFUhSNEARX8dvMiB+ZEvyesmfA7uX0UqIeSmF/3m93qPsGE
        CP5HEYxAVhbHQ7kXK5WxUHQKmA3caLx+IY2qkTo=
X-Google-Smtp-Source: AMsMyM7M/QMzW1Q9yA5O3dMdVh9uNRrAT4xzSk9xw0R0CRL6DpZESLc7P1thxLqTEgWjx2Jt0zj4X5DmPAuua5svQLk=
X-Received: by 2002:ac2:4c47:0:b0:4a2:c07b:4b62 with SMTP id
 o7-20020ac24c47000000b004a2c07b4b62mr19563753lfk.426.1667988332486; Wed, 09
 Nov 2022 02:05:32 -0800 (PST)
MIME-Version: 1.0
References: <20201210024342.GA26428@gondor.apana.org.au> <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au> <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au> <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au> <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au>
In-Reply-To: <Y2sj84u/w/nOgKwx@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 9 Nov 2022 11:05:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
Message-ID: <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 9 Nov 2022 at 04:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
> >
> > While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
> > and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
> > supported upstream now?  Or is it specific to whatever xctr is?  If so,
> > any chance the patch is wanted upstream now?
>
> AFAICS the xctr patch has nothing to do with what you were trying
> to achieve with wireless.  My objection still stands with regards
> to wireless, we should patch wireless to use the async crypto
> interface and not hack around it in the Crypto API.
>

Indeed. Those are just add/add conflicts because both patches
introduce new code into the same set of files. The resolution is
generally to keep both sides.

As for Herbert's objection: I will note here that in the meantime,
arm64 now has gotten rid of the scalar fallbacks entirely in AEAD and
skipcher implementations, because those are only callable in task or
softirq context, and the arm64 SIMD wrappers now disable softirq
processing. This means that the condition that results in the fallback
being needed can no longer occur, making the SIMD helper dead code on
arm64.

I suppose we might do the same thing on x86, but since the kernel mode
SIMD handling is highly arch specific, you'd really need to raise this
with the x86 maintainers.
