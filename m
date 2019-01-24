Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CC1C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 10:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DB07218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 10:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="TO+6z/ki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfAXKQf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:16:35 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:38403 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfAXKQf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 05:16:35 -0500
Received: by mail-it1-f196.google.com with SMTP id z20so3579878itc.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 02:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3SwDObEh9OokimBV+T4T/grxG1yyhQk0b56zMiko/6I=;
        b=TO+6z/ki0ONeEuoS5OI2Q7jdQeuywhdXLvkekokMzMWiR5GQERwbrfV2mexOAoZ1GO
         b8I8iEvum5lYcQHoIy/2NIRn1k6gyBS6ejXQuiNFbKjsIVZ0ZP97oryjKm582yTvP3Zy
         /+UFbrj7Aj7S9k4WeZqssOQcus07F/KRphEkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3SwDObEh9OokimBV+T4T/grxG1yyhQk0b56zMiko/6I=;
        b=cwLLC63JxnxxnkeecULtO+WE/OPNdzT7cTFzZGVui/1BOqdcLTIGvXRnGeFnaZELxR
         yu6Atkd1N6vOKvsciHeV3CYIouzGvDWCffwkbsNPw3bS01y6ljGrnh06Lt0d/YSKjvfy
         oXXfq3oyL5tBbLIIW+xpsll4HtvENwVQ+rW4iCmEB/XbptpArvd6CuGB2+cDxyhj6ka8
         k4S9ZlNMvkGoqh5IKWF5ziRz4fxpuiMpLRi5fJ01jf8c+XNVaRF3A2kYlZlUixYkuzPi
         Wmh/DLtRXAdS/JkkIa46oJxuZnHu6ojic8+zSBdAcDi8oCTh8vBISh2fwcn79YgqTy5d
         leVA==
X-Gm-Message-State: AJcUukdl6PlTvyksKlpbhG6TSJXCCJRsIZBf+I5eK3vxxeb3mov8jM1J
        YUGKQhiy8CJD05hJVueKFhzER992aaOVTIAdbLPaJg==
X-Google-Smtp-Source: ALg8bN68VTe9/KZuOypBEz8B822lYhOWK53rZDTATXA5TXHv+5gbAIzE2nQfBq8SRTj3ZlmcUr8yfW/om8B0HSYyp24=
X-Received: by 2002:a24:edc4:: with SMTP id r187mr1140494ith.158.1548324994563;
 Thu, 24 Jan 2019 02:16:34 -0800 (PST)
MIME-Version: 1.0
References: <20190123224926.250525-1-ebiggers@kernel.org> <20190124084818.GA650@sol.localdomain>
 <CAKv+Gu9zridWAYO3cR_KAAbupWfLd+FAMmcgAMuYE5Lgxoek-w@mail.gmail.com> <20190124092359.hvizqdi2ptjdsot7@gondor.apana.org.au>
In-Reply-To: <20190124092359.hvizqdi2ptjdsot7@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 24 Jan 2019 11:16:23 +0100
Message-ID: <CAKv+Gu_C5p1pf_+8Ci+y8GGRr4OHEN8FwLJHnvu=wq3bTzGrYA@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 00/15] crypto: improved skcipher, aead, and hash tests
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Jan 2019 at 10:24, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jan 24, 2019 at 09:50:35AM +0100, Ard Biesheuvel wrote:
> >
> > Thanks for yet another round of cleanup
> >
> > I'll look into these, but I'd like to clarify one thing first.
> >
> > IIUC, you are trying to deal with the case where a single scatterlist
> > element describes a range that strides two pages, and I wonder if that
> > is a valid use of scatterlists in the first place.
> >
> > Herbert?
>
> Yes it is valid.  IIRC the network stack may generate such a
> scatterlist.
>

OK, so how many adjacent physical pages is a scatterlist entry
permitted to cover? Unbounded?
