Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB92C282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D63D02148D
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 09:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WBorixOo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfA0JKf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 04:10:35 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:55336 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfA0JKf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 04:10:35 -0500
Received: by mail-it1-f196.google.com with SMTP id m62so16475627ith.5
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 01:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LM8bj7p/lfjMdMYHTyfAr7tTR3nI20UMCrTrK0viarY=;
        b=WBorixOoN5g7truf1h3BG8owdeFxLRddNDLJaKKRbPfKXgFEYkMB7uw7ubwkzwCkyZ
         Cv5YX7wgHDFGehSGJHgK+Ymc/qs4nyldfluBoJbJUbOQGiGlKo1Pp0857JbQL6b/J+Wh
         5fiG34ZsTDtuTF2l3My59JZUriiMpa8sNy6fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LM8bj7p/lfjMdMYHTyfAr7tTR3nI20UMCrTrK0viarY=;
        b=lvqk/9RRQ7bam11gPgSD08S42OdI2RRqUs3PEaThdGGlEudTVSxZEF6CgBL4Uw3A3o
         NNAV+OOGCry3peZ+03qJm2U1GptJCx0xX7UpXFFN/AnRqNfpqOPXHwEerMdc3C0I45Gt
         1IzCrLIWfskzfO/AyPHHFm7ij4TD7v5qG97pXdDuac/cMDPI7rCCwG0TOXDroCdiKKKF
         UE5X4mk+qu9Vry0y/sp71VNRATu5TsWPcmWf54Bytt2H1rPVHDFcIWqu6d8ZqoePlGn+
         hztL1ETQoNycrwO62md7bZP/JDSNaoabzYQ/4oLKpi8bU6terx45RF3WEoWyZhs/rsnK
         WtGg==
X-Gm-Message-State: AJcUukfxCIxElWxHH7eeG0nt0d0LM7IPEZPcRz/lpKkood8lnefhMet0
        pb5s/7rcd0puIbYsuO7QQX33s8/rcHqx3lmt3qOU/w==
X-Google-Smtp-Source: ALg8bN7IXRD8FMzyAbxNN7PyUMyy4q08/zCiTPaUH52uziTxFwZaqQNSklyQmxJYoFKgPiE/wf/Xbmh7Ghyk+EhUzio=
X-Received: by 2002:a02:4c9:: with SMTP id 192mr10720981jab.2.1548580234791;
 Sun, 27 Jan 2019 01:10:34 -0800 (PST)
MIME-Version: 1.0
References: <20190125084915.25411-1-ard.biesheuvel@linaro.org> <20190127000752.GC709@sol.localdomain>
In-Reply-To: <20190127000752.GC709@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 27 Jan 2019 10:10:22 +0100
Message-ID: <CAKv+Gu-cbfgC=jtEwDB=ozxgf1cty5wzHg+ZMAnMN518jbsy0g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: fix crct10dif for ARM and arm64
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 27 Jan 2019 at 01:07, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jan 25, 2019 at 09:49:11AM +0100, Ard Biesheuvel wrote:
> > Fix the issues in both NEON implementations of the CRC-T10DIF routines,
> > that were reported by Eric's new testing code.
> >
> > v2:
> > - keep alignment specifiers where possible (#1)
> > - clarify/fix commit log (#2)
> > - add fixes/cc-stable/etc tags
> > - add patches that drop the now unreacheable code (#3 - #4)
> >
> > Ard Biesheuvel (4):
> >   crypto: arm/crct10dif - revert to C code for short inputs
> >   crypto: arm64/crct10dif - revert to C code for short inputs
> >   crypto: arm/crct10dif - remove dead code
> >   crypto: arm64/crct10dif - remove dead code
> >
> >  arch/arm/crypto/crct10dif-ce-core.S   | 27 +++++---------------
> >  arch/arm/crypto/crct10dif-ce-glue.c   | 23 +++++------------
> >  arch/arm64/crypto/crct10dif-ce-core.S | 11 --------
> >  arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++-------------
> >  4 files changed, 19 insertions(+), 67 deletions(-)
> >
>
> In the commit message of patches 1-2, "more than 16 bytes" should be
> "at least 16 bytes".
>
> Otherwise for all 4 patches:
>
>         Reviewed-by: Eric Biggers <ebiggers@kernel.org>
>

Thanks Eric. I'll update and resend.
