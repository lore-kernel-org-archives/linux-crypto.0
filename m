Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E71C19759
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 07:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC71206B8
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 07:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jpFxYnQm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbfHAHQe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:16:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53486 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfHAHQe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 03:16:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so63453595wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2019 00:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NnB2nDFWI5ec51xZpRNS0eGeVvyyeRajJNG5CTwO4OU=;
        b=jpFxYnQm1en+21QoCMtdXajNs+goTe/CRGRqjtrMaD9G6dr71nskYBTTdLoHUbfyNe
         dx60QgPZ72uI7pOr6AulRt1DkxBoXL8edSnrawZAHTg3D+ptHu/oPdEe4O3CkKs7L9LZ
         wOwYQPQ61qBH0sqoHR3/jvCca09FY1BZLoakTnXMJQz++/j+Fa75z6MrTPT5urUf7W5e
         keXbitgVe4JTb/Vn4UyX6sLk7ZQYsqVrTx32OOB3lWlhLT0f4xjyTtXBNofJ700mBVim
         SLDY4UyceVgWtsPBbtn9Oqv7d3f5T/17uZQyN5TFLwCDvT+eA2PC7uVecrp6xJktEOsb
         CUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NnB2nDFWI5ec51xZpRNS0eGeVvyyeRajJNG5CTwO4OU=;
        b=Xr6QZOQG0TVrSTt/L3osJEkbvujdRSysUVua4wUC7MbrejglYjoeAzLgz3Y1VWihh6
         MU1Qw1Y3GFH6hL9NCBGEmpKqhZDWDugwQZ657Mq1JlUnYEG3h783RV6amNRHgzN/1uhA
         q28bxrQ3ZcZlogu35yT7gZmiqUSSIj1vodZWoaPboTEMkkvqZ84rxcVMUtSou1B0ZMV9
         0ODbSqKPD91eOFRihu4PZScfF8on9UaUUyiBneNSTk0YiGgqIavnHpW2wzxiUWfrWDg7
         USHIp1qVXtUahSy9F92t5NTSs65uOhNTdx5RZBdMfoRTgcJoF/Sq0qyBkTooT6DW+qac
         SCWA==
X-Gm-Message-State: APjAAAWqopKlLtO5dPOamem9yf77T/BxGkRV4y4v2CKD4o7uKSvD8J/J
        8Kii6UkS2SES1SmgooRuAIdRiJtwnUHrNPdeqBmZrg==
X-Google-Smtp-Source: APXvYqxs68atl0y996xjePC7x7rIgCrytEqFiRB74cPlgPYNA6yMTSx1VN9AUIgMKSNjSXYDwpUJb4m5lNmbJr7t08o=
X-Received: by 2002:a1c:b706:: with SMTP id h6mr111148067wmf.119.1564643792026;
 Thu, 01 Aug 2019 00:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190801115346.77439e35@canb.auug.org.au> <20190801021133.GA1428@gondor.apana.org.au>
In-Reply-To: <20190801021133.GA1428@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 1 Aug 2019 10:16:21 +0300
Message-ID: <CAKv+Gu-Yo72DQvh_M3P4NW9pOKDh5YH-DN3cH+MQZkdACwcb3g@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: Remove redundant arch-specific rules for simd.h
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 1 Aug 2019 at 05:11, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 01, 2019 at 11:53:46AM +1000, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the crypto tree, today's linux-next build (arm
> > multi_v7_defconfig) produced this warning:
> >
> > scripts/Makefile.asm-generic:25: redundant generic-y found in arch/arm/include/asm/Kbuild: simd.h
> >
> > Introduced by commit
> >
> >   82cb54856874 ("asm-generic: make simd.h a mandatory include/asm header")
> >
> > Also the powerpc ppc64_defconfig build produced this warning:
> >
> > scripts/Makefile.asm-generic:25: redundant generic-y found in arch/powerpc/include/asm/Kbuild: simd.h
>
> Thanks for the heads up Stephen.  This patch should fix the
> warnings.
>
> ---8<---
> Now that simd.h is in include/asm-generic/Kbuild we don't need
> the arch-specific Kbuild rules for them.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 82cb54856874 ("asm-generic: make simd.h a mandatory...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
> index 6b2dc15..68ca86f 100644
> --- a/arch/arm/include/asm/Kbuild
> +++ b/arch/arm/include/asm/Kbuild
> @@ -17,7 +17,6 @@ generic-y += parport.h
>  generic-y += preempt.h
>  generic-y += seccomp.h
>  generic-y += serial.h
> -generic-y += simd.h
>  generic-y += trace_clock.h
>
>  generated-y += mach-types.h
> diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
> index 9a1d2fc..64870c7 100644
> --- a/arch/powerpc/include/asm/Kbuild
> +++ b/arch/powerpc/include/asm/Kbuild
> @@ -11,4 +11,3 @@ generic-y += mcs_spinlock.h
>  generic-y += preempt.h
>  generic-y += vtime.h
>  generic-y += msi.h
> -generic-y += simd.h

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
