Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC628C3A589
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 17:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 803C22063F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 17:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zSc8i1yp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfHORqf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 13:46:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41441 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbfHORqf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 13:46:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so2934662wrr.8
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 10:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYNKyNDEVZaSn3KKU5nVN59Ch0APFsTcvR6fvX99Bx4=;
        b=zSc8i1ypbaWLdawvBpPJamGyioGgXkw4qE2S4xlu//+y7XHfmkYpBAWMiqgxswdXnT
         2Kbfqp7macugCIm2p0D3m8IR1/f/Xo7txfxoxUzpPVH9s2sUfzUibBFsgUZa/cq+b++j
         IkGa7fJqNQFnokMj/UTRlUTDsC5o8OCJij7bpBFg1XajnkkC8Noym1U5oVmhRX+Fmz95
         kgYaqoi0zEc0LZFqbK6Xk8XLgBOD6IpQgBTNGllnJ1SW++MYBRikQDBjavNXifJJkFSh
         I7h/rPVxmsHPi992yiHoHK9t7r5H1urmjbDXNz1JRsxI77xKSGeO2h32kgPSvYx1XNzn
         vwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYNKyNDEVZaSn3KKU5nVN59Ch0APFsTcvR6fvX99Bx4=;
        b=qIyMeQUabBPD3QlvCYBRSlm46UmKCLopPr8HUgTXW/zt4srvSgiDYzjmi4xYEPW5Pz
         G88YGiblktapoq1ynoqYZRI5FWXdJmK/YS/1FeoOk8O7H+xtLCIdoMtY2Bx8wCKePm/S
         7h3ZVGe+Z8PQPIn887T9NNXFSt2wKLvnl/1BrS0DZsOwbLMHScmL8HoqhQNCoDBO44D6
         CPTx98yAsL0wYM/8KCPEHBYkjnuHAlW1hiII0CnrGyZFYZANgQLP2eH3rkHjiqGEHCxL
         eaVGASJ2JNl7GfCFn4gIZH3lqJHO8RdEOUx/MpC4YzCnH8SPFq2MnLCpQWxqbSixi7pp
         KUlQ==
X-Gm-Message-State: APjAAAVOCL6MNWpXnGFrW4fbCcIeV4dF4jdyQQp85EpitJQ+ybNcz8CG
        whAL0MV2k/I2lmqpZZATtCzRRv35jxo+tM8IYUWO7A==
X-Google-Smtp-Source: APXvYqyQgpk/VC0fEjSazze6ItoFVCjI/DkEOxBShq9LIPJT1ACJ9jFU5KOvmph9m5hLW3UbL54QtU/RwDF2CkyQcVA=
X-Received: by 2002:adf:9e09:: with SMTP id u9mr6695965wre.169.1565891192633;
 Thu, 15 Aug 2019 10:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
 <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com>
 <20190815051320.GA24982@gondor.apana.org.au> <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
 <20190815113548.GA27723@gondor.apana.org.au>
In-Reply-To: <20190815113548.GA27723@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 20:46:21 +0300
Message-ID: <CAKv+Gu9Yx3Jk_ikZC1GrR8rR1zV_5CzkXv5NntXnLYim2n+R9g@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 15 Aug 2019 at 14:35, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 15, 2019 at 08:15:29AM +0300, Ard Biesheuvel wrote:
> >
> > So what about checking that the cipher key size matches the shash
> > digest size, or that the cipher block size matches the skcipher IV
> > size? This all moves to the TFM init function?
>
> I don't think you need to check those things.  If the shash produces
> an incorrect key size the setkey will just fail naturally.  As to
> the block size matching the IV size, in the kernel it's not actually
> possible to get an underlying cipher with different block size
> than the cbc mode that you used to derive it.
>

dm-crypt permits any skcipher to be used with ESSIV, so the template
does not enforce CBC to be used.

> The size checks that we have in general are to stop people from
> making crazy combinations such as lrw(des3_ede), it's not there
> to test the correctness of a given implementation.  That is,
> we assume that whoever provides "aes" will give it the correct
> geometry for it.
>
> Sure we haven't made it explicit (which we should at some point)
> but as it stands, it can only occur if we have a bug or someone
> loads a malicious kernel module in which case none of this matters.
>

OK.

> > Are there any existing templates that use this approach?
>
> I'm not sure of templates doing this but this is similar to fallbacks.
> In fact we don't check any gemoetry on the fallbacks at all.
>

OK, so one other thing: how should I populate the cra_name template
field if someone instantiates essiv(cbc(aes),sha256-ce)? We won't know
until TFM init time what cra_name allocating the sha256-ce shash
actually produces, so the only way to populate those names is to use
the bare string supplied by the caller, which could be bogus.

To me, it seems like retaining the spawn for the shash is more
idiomatic, and avoids strange issues like the one above. Dropping the
spawn for the encapsulated cipher (which is tightly coupled to the
skcipher/aead being encapsulated) does seem feasible, so I'll go with
that.
