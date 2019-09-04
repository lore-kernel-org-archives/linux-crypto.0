Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB7BC3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 14:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5337222DBF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 14:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A+5kP410"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfIDOXl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 10:23:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52856 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730552AbfIDOXl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 10:23:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id t17so3551031wmi.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 Sep 2019 07:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MOucKwxyOMSdV1lq4JpX6GteCAGudM3NFzlYYmtKmMo=;
        b=A+5kP4105+Fiiz6ZY3ZWlk0Qh9vXFx4t4D4Z8sBGWBOudh80rIuyoRZumZnFZn7Y6m
         1ICUp1qytPYdPcIH1+it6Sy17YsXaLd+GM2m73cidlRQEttA7VhSr4gZQQj+xayPK0FI
         jCc5UnMwAMdFVnoLc2Qoh13wiO0LDS/2urAmjDOD1TxYD0OVsfVw06ng6ehJC/xT4I4o
         XRs8I7vv82NHTWKbjvTZoMkBk0MHbvr8fS7SiZKRvvJahOFQZQRxTDme1yf+tAjonUFV
         g5F9QsoKDC/fJ2J0c0dZcOD2dFnr39d6uKREfXYnHdNKU8ZPEJtN98ThrW2fxy+j9/TC
         eQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MOucKwxyOMSdV1lq4JpX6GteCAGudM3NFzlYYmtKmMo=;
        b=pjaiS+UMIdHRpvABQfDHSJoeKo5R9rZzmxU8hniGmG/tvstZQu04fdkuLvM2ofArDc
         /R+txIOWQWeZUW9SI07jkOd6D00ATtHU2ThgQj2GvucvE/iKpxlrt6xetMSL9+vfEhcQ
         5/bAOlK6YFLrkIwkM0uPE2h2DWDqpqP+o+FBbDyEo8jLSSFlzYFCEO7Ef6P3+jrXAdJD
         eblEaypfPDuRS80uP38aG2D0sFtIcPYDtknxLUfH8Hn0Gy4lNmd/Oq2K0GMagHINN3PG
         P36ZmghkiFKEK3ykYy2SzylhWczTBIbiTDrlE4Wnj51s/d1fvxAO6+nc7W61FPEx9nP/
         GmUw==
X-Gm-Message-State: APjAAAWEHHpldXyHg7iXtGKoDG5fibMwCrJDe4hHQ8rLkmS+lZgQ63J8
        bnIpDbR5tA+L87HiS+Sh8eq5YwjHAZZW9M3b+JUxEA==
X-Google-Smtp-Source: APXvYqwsjBC7+jw1o5C6umtxfcTtBCRft+oC2mWoKkVSbpHeAD/w9bkaKgBp2nyLiwf0fqAs2UrOrZEyCWNgvBAO9HI=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr4465756wma.119.1567607019303;
 Wed, 04 Sep 2019 07:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190822102454.4549-1-ard.biesheuvel@linaro.org> <8e480e5b-14d5-8ff1-0630-5a53b4646a1c@linux.ibm.com>
In-Reply-To: <8e480e5b-14d5-8ff1-0630-5a53b4646a1c@linux.ibm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 4 Sep 2019 07:23:27 -0700
Message-ID: <CAKv+Gu9KAB299tXWePQGnYX5WforbeJvCg7r1iS54P+d9i5NLg@mail.gmail.com>
Subject: Re: [PATCH cryptodev buildfix] crypto: s390/aes - fix typo in
 XTS_BLOCK_SIZE identifier
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Reinhard Buendgen <buendgen@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 4 Sep 2019 at 07:21, Harald Freudenberger <freude@linux.ibm.com> wrote:
>
> On 22.08.19 12:24, Ard Biesheuvel wrote:
> > Fix a typo XTS_BLOCKSIZE -> XTS_BLOCK_SIZE, causing the build to
> > break.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > Apologies for the sloppiness.
> >
> > Herbert, could we please merge this before cryptodev hits -next?
> >
> >  arch/s390/crypto/aes_s390.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> > index a34faadc757e..d4f6fd42a105 100644
> > --- a/arch/s390/crypto/aes_s390.c
> > +++ b/arch/s390/crypto/aes_s390.c
> > @@ -586,7 +586,7 @@ static int xts_aes_encrypt(struct blkcipher_desc *desc,
> >       struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
> >       struct blkcipher_walk walk;
> >
> > -     if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
> > +     if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
> >               return xts_fallback_encrypt(desc, dst, src, nbytes);
> >
> >       blkcipher_walk_init(&walk, dst, src, nbytes);
> > @@ -600,7 +600,7 @@ static int xts_aes_decrypt(struct blkcipher_desc *desc,
> >       struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
> >       struct blkcipher_walk walk;
> >
> > -     if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
> > +     if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
> >               return xts_fallback_decrypt(desc, dst, src, nbytes);
> >
> >       blkcipher_walk_init(&walk, dst, src, nbytes);
>
> Applied together with the aes xts common code fix and the testmanager fixes,
> build and tested. Works fine, Thanks.
> With the 'extra run-time crypto self tests' enabled I see a failure of the s390 xts
> implementation when nbytes=0 is used (should return with EINVAL but actually
> returns with 0). I'll send a fix for this via the s390 maintainers.

Thanks Harald.
