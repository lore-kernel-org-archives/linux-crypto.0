Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE03C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802642064A
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o9alXZRU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbfFTNfl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 09:35:41 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41955 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfFTNfl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 09:35:41 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so20732ioc.8
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2019 06:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIDlsIvtATsL3hA5QAEsaHCyI03s2C5u03IcGdawceo=;
        b=o9alXZRUfb+rgrya2OuK7msSKBSLIOUcWsFtVHJICr1ID4KycIx7HeXphqKApgwkI9
         iw0YS5AdA0fd8S83GuH7isN4P46piJaZucQrcO8ruXW+kJlrMAlX7V3RGwNhUMBHwusy
         CKEO6hOXtvhXh8p3lY2HbCSH+vJY+2boyK2mzZ+5o73aqFC2CzeGmVxRVgquHcMCRso4
         CC/ckDTCWo5P1Lhs3Hz5hBXUExB8hoc+AiNI21xrnOnoXE8FK+7zsnyuEz5t7kEGTuGf
         wCKoKqoq4Tskwk2qh+Y240HsyZpWKtvGadkxkAFffQ3V/GkdyDzDIDUFJ1NZsm/n7kRv
         xq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIDlsIvtATsL3hA5QAEsaHCyI03s2C5u03IcGdawceo=;
        b=k60Iwk/Gy8vDZqCkkYLZZ9DXYK5UPyHXX1CKLPXVZSSUlzDhwH31uitoLPWxVsrDZv
         0n83lPnS0WVNPFnymOINMXidLSuyvOfRDfxfVZB0poSnAVy26syWntDhqjivqb3A7/nd
         9jbjsZo9lzCrmrWbNEy0m1C1pgQLvutLsMLwGkCGT7+hRUbk5XdQ9r/QnFTsdaePUEB1
         WVwxTE47g523Iab0/a9CDDW+8Etij79jRkg9qmqqeExBpFBXplGlgdZIKRtv2AceAslQ
         jI1Xbk0EqnAs33k33xYNgpHuBhEVAXb72Xd4AOhJAVis5fxoJsuMp6hxd0lWIAi6jDDs
         WLzA==
X-Gm-Message-State: APjAAAXTvzazAsKI7jqEA2/zU/RXeeaVyEMOJ13TZfXMMcJFko55e6mD
        I+g/RpMs77mhLH0hu7mJL855lETp48Sv9Lf0Nesm0w==
X-Google-Smtp-Source: APXvYqxDNCT96WaC9Fy8q5f65kLAobnwxGYT6HTiFYdT15g7/FQXFMdaTJClLAv6we1Ldq6NmxiyxWHSpR02EcCMayA=
X-Received: by 2002:a02:9143:: with SMTP id b3mr48893jag.12.1561037740085;
 Thu, 20 Jun 2019 06:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au> <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au> <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 15:35:28 +0200
Message-ID: <CAKv+Gu_7dQsJdb1Wmn2mzG7HFcfjF7ggGzUyPB5b_JR0ujHCrQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Jun 2019 at 15:02, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 20 Jun 2019 at 14:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Jun 20, 2019 at 09:30:41AM +0200, Ard Biesheuvel wrote:
> > >
> > > Is this the right approach? Or are there better ways to convey this
> > > information when instantiating the template?
> > > Also, it seems to me that the dm-crypt and fscrypt layers would
> > > require major surgery in order to take advantage of this.
> >
> > Oh and you don't have to make dm-crypt use it from the start.  That
> > is, you can just make things simple by doing it one sector at a
> > time in the dm-crypt code even though the underlying essiv code
> > supports multiple sectors.
> >
> > Someone who cares about this is sure to come along and fix it later.
> >
>
> It also depend on how realistic it is that we will need to support
> arbitrary sector sizes in the future. I mean, if we decide today that
> essiv() uses an implicit sector size of 4k, we can always add
> essiv64k() later, rather than adding lots of complexity now that we
> are never going to use. Note that ESSIV is already more or less
> deprecated, so there is really no point in inventing these weird and
> wonderful things if we want people to move to XTS and plain IV
> generation instead.

Never mind, the sector size is already variable ...
