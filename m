Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CBACA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 10:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9715721D71
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 10:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UC5Pa7cS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409442AbfJYKTe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 06:19:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33340 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409431AbfJYKTe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 06:19:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id 6so3949171wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 03:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qc/ztTJAKK4J0aU63ev+egDW8U3y1aNoFPLB9AwTm3w=;
        b=UC5Pa7cScT/WFAguuRUDz2M78p0dmWLmOfW1dC8/N7SIGs6qM3l5vSKSd/qfuJDCfm
         DZwVsSY1fqEVzYQfsuc/06YzjJ6KBZXIEdBoijdF+h46xR42SxcAM4CcHb2rlrT7iB2N
         /A1o81hFIu1nrqjC4OHrfKOeSB3dv/bPrsThXc9ohRHI9gxrySJGDUjvFEYD6dbxV7nl
         rdogqwWXlJycW66GsbbwV946pLpHgK22+xzHaGaoslGwEuTUfu9dqmA+MLl0lwE/YJ7C
         K87GxrrOU/3X1tV1P5zdwaz8cedB6jbV9Y0PvNqFdTYYEHSXrzI8UVB3bWSyf1i0iasq
         hDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qc/ztTJAKK4J0aU63ev+egDW8U3y1aNoFPLB9AwTm3w=;
        b=b+t3ibBL4K/URlMoskdHwVooy7qhcKaRP7HqFOqrmBxr7i16l4YJ9BUWXqkmJ/SgwV
         JUMTDm4EUHOkRvwExY0Ky7B/Vqq7bBwWzirO98gSM5rYDqNYmf4VnW5ID3A/dqgyJTxR
         FZ5Jyz3Fr/3ItJp5KOVojS7/y9NkmxBo0bnzgkPFxVQlA/M2W/+1EUcjwH9ir+VsFnft
         t8o2JdsiLvF/RE1QH5/bzKIhJCBzkzLL/BDZCKNFGwmPzj2R8xe2chgcxGizZOvliaS9
         FdA252JqA3EETJSHQznzZDse5MT7Ykm7Kk4GJ1Dwfksh6xOu2kRpqRy8FW0AC+hz2NPh
         a+/g==
X-Gm-Message-State: APjAAAUwSalTWVD/JLkeugINuN6cWojU6DSLk72f5Yf/CDmnw+V60Ezi
        aFkrbvAlyiGEMKeKGpaGyIJi3dgNnDMJOEd5eNucvQ==
X-Google-Smtp-Source: APXvYqyOvakmk18SJSBfU3bQ15rT25r/fiIWuvLvo3ZtqL2B40sMEKutw7b2eeoZZa603ekAwfCYdoOC7dYdRddhwNA=
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr2880087wml.10.1571998772535;
 Fri, 25 Oct 2019 03:19:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-6-ard.biesheuvel@linaro.org> <20191024134123.GW5610@atomide.com>
 <CAKv+Gu_xTe8qmPab=_UE_buxaSzj2Kxtq+CPrm-cawAyg8MUzg@mail.gmail.com> <2b461903-dbbc-1f1c-2359-6dae656d477c@ti.com>
In-Reply-To: <2b461903-dbbc-1f1c-2359-6dae656d477c@ti.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Oct 2019 12:19:29 +0200
Message-ID: <CAKv+Gu_0HejeZLEft1VQpPruW+L8Ao1J2fFhp-io_sVZnUVxbg@mail.gmail.com>
Subject: Re: [PATCH v2 05/27] crypto: omap - switch to skcipher API
To:     Tero Kristo <t-kristo@ti.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Oct 2019 at 09:32, Tero Kristo <t-kristo@ti.com> wrote:
>
> On 24/10/2019 16:42, Ard Biesheuvel wrote:
> > On Thu, 24 Oct 2019 at 15:41, Tony Lindgren <tony@atomide.com> wrote:
> >>
> >> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [191024 13:24]:
> >>> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> >>> dated 20 august 2015 introduced the new skcipher API which is supposed to
> >>> replace both blkcipher and ablkcipher. While all consumers of the API have
> >>> been converted long ago, some producers of the ablkcipher remain, forcing
> >>> us to keep the ablkcipher support routines alive, along with the matching
> >>> code to expose [a]blkciphers via the skcipher API.
> >>>
> >>> So switch this driver to the skcipher API, allowing us to finally drop the
> >>> blkcipher code in the near future.
> >>
> >> Adding Tero to Cc on this one.
> >>
> >
> > Ah, of course - apologies for missing that.
>
> Works for me, also can't find any bugs in the code via inspection, so
> feel free to add:
>
> Reviewed-by: Tero Kristo <t-kristo@ti.com>
> Tested-by: Tero Kristo <t-kristo@ti.com>
>


Thanks Tero

I'll dig up my Beaglebone White today and test/review the patches you
sent out last week.
