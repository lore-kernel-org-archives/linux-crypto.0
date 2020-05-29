Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF932C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 13:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 872AE20C09
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590759681;
	bh=Ln5kLaZwQP3i6SW2waQXcocCo7X59Pe9/XFzkY7bwTo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NUlqnjmSjx9A0G+FtuKfoXaI3YzdAejl5rf7Dpo9/gNIRg94yiaOhnaplyjrMxAmF
	 E1p6OJoeR4rUbJdjP1Nr34nAG8Ay/Brid20sc/IS4/ziVMxHnIJZB5OG+j1/HcWpMZ
	 /7mSfxVpRVh354Aru4FbzU5s03o4stxqpFVhYCJU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgE2NlV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 09:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgE2NlU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 09:41:20 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC74214D8
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590759680;
        bh=Ln5kLaZwQP3i6SW2waQXcocCo7X59Pe9/XFzkY7bwTo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1oV93xO6cYenguhKBfKOw174zOww8pOWs7kdrQrhnTB9mGsYF4fvzDMuQGLpK5LbO
         8D/ezKKn39+o+2bQvC/HeTVJF2XHbjKUoWzqZxRPsplEitIrT7AcJv56dCI6YZ/HKg
         lieygh0K6Z99cQXmDZchfGo316aLafg0Fa3m8xOU=
Received: by mail-io1-f50.google.com with SMTP id s18so2378743ioe.2
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2020 06:41:20 -0700 (PDT)
X-Gm-Message-State: AOAM5323klSvum67flzPUCY7gY1Q4YBo/gkf1C+NMnKMjG+37qBGRca5
        rL95tul6eIXrKp+KacWO4Q6Dlc3nPLjATujrTO8=
X-Google-Smtp-Source: ABdhPJytmZNZRBpeLqlnt0MG7D1quaUYLw+a+QTe2AgAN7bNoNqPJ68v+NZ3B7czgCOpSypV0FSP9h4gmAPhA4fopxY=
X-Received: by 2002:a05:6638:5b9:: with SMTP id b25mr4811366jar.68.1590759679500;
 Fri, 29 May 2020 06:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <20200528073349.GA32566@gondor.apana.org.au>
 <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
 <20200529080508.GA2880@gondor.apana.org.au> <CAMj1kXE43VvEXyYQF=s5HybhF6Wq23wDTrvTfNV9d4fUVZZ8aw@mail.gmail.com>
 <20200529115126.GA3573@gondor.apana.org.au> <CAMj1kXFFPKWwwSpLnPmNa_Up1syMb7T5STG7Tw8mRuRqSzc9vw@mail.gmail.com>
 <20200529120216.GA3752@gondor.apana.org.au> <CAMj1kXF2-jJ6yGh9m759V2858_c45txoUBgKirvR-4z4GOHUfQ@mail.gmail.com>
 <20200529131953.GA9187@gondor.apana.org.au>
In-Reply-To: <20200529131953.GA9187@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 29 May 2020 15:41:08 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHnQhLWUC_dPeuscEutOZPGzW4ZGaqphT2mSExmfChtsg@mail.gmail.com>
Message-ID: <CAMj1kXHnQhLWUC_dPeuscEutOZPGzW4ZGaqphT2mSExmfChtsg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 May 2020 at 15:19, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, May 29, 2020 at 03:10:43PM +0200, Ard Biesheuvel wrote:
> >
> > OK, so the undocumented assumption is that algif_skcipher requests are
> > delineated by ALG_SET_IV commands, and that anything that gets sent to
> > the socket in between should be treated as a single request, right? I
>
> Correct.
>

So what about the final request? At which point do you decide to
return the final chunk of data that you have been holding back in
order to ensure that you can perform the final processing correctly if
it is not being followed by a ALG_SET_IV command?
