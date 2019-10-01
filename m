Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0724EC352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB868215EA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbfJAStY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:49:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44491 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJAStY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:49:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id u40so22962929qth.11;
        Tue, 01 Oct 2019 11:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQ/aeUAODcfHsnJVhrCVPGFZvCnxoF2P68MP76wAWmI=;
        b=AlZxib+mGrsNLwaQc5WEpQUiZKR30Peq7nNgLoexWN80JZqJjMunu6vMxgokE3Fwjo
         u7SjYl3tT8ieXMO2jKHaaSeUp8RUOHTF+QpNJ/yEMX1GU52TUtGzwGHR2oE0KtnT0buG
         zAMABkGQ6lYRlYsZEiKmrfZTyypNyR7nMCMiYYzJIcOyl5WjbdDRatF05ytu1e82miSy
         T/I56w8/DUa2V/oPI4kMiyXSQt1PQV2E7QrrflERnhS01saWCR6kD1XpYdL/kgUbuEhZ
         hpUrR4sF/9A/eH0i/bk3dJnGYZ0alB9jXR/zXuvFQoj4vlj+aGnGX4aKaB2CUjAmakoq
         0voA==
X-Gm-Message-State: APjAAAX1l/FN+KeajfXT7I2RwJMAs8d8Z7FW6OZCIl0eDBunKMcXh5Ge
        zxIkdXl7jYtiL0yQoaYO5On4an7AtpNX5yhksOM=
X-Google-Smtp-Source: APXvYqyKolI0m0eL4KVQA6JY8f/fHGLIsg+k3X/A7B4lxu4r3JPwQIOYgeTZWrWRk1KDX7C5SA8y2/wMSQYTZe1zEKo=
X-Received: by 2002:a0c:e0c4:: with SMTP id x4mr26961100qvk.176.1569955762750;
 Tue, 01 Oct 2019 11:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190930121520.1388317-1-arnd@arndb.de> <20190930121520.1388317-2-arnd@arndb.de>
 <CH2PR20MB2968B7855D241C747BEB68B9CA820@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAK8P3a0PeocENP6c=ENVrq2X8x-vinM6qhPRDDi_WEf6y73AOQ@mail.gmail.com> <CH2PR20MB29682E2C514733F290CFA3CECA820@CH2PR20MB2968.namprd20.prod.outlook.com>
In-Reply-To: <CH2PR20MB29682E2C514733F290CFA3CECA820@CH2PR20MB2968.namprd20.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 1 Oct 2019 20:49:06 +0200
Message-ID: <CAK8P3a0_ZAdoYkZsb_C2y5gi9u3_Pt-qa3c1FiCMq7_Lax0AYw@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 11:09 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
> > Subject: Re: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
> >
> > On Mon, Sep 30, 2019 at 9:04 PM Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> >
> > > > Alternatively, it should be possible to shrink these allocations
> > > > as the extra buffers appear to be largely unnecessary, but doing
> > > > this would be a much more invasive change.
> > > >
> > > Actually, for HMAC-SHA512 you DO need all that buffer space.
> > > You could shrink it to 2 * ctx->state_sz but then your simple indexing
> > > is no longer going to fly. Not sure if that would be worth the effort.
> >
> > Stack allocations can no longer be dynamically sized in the kernel,
> > so that would not work.
> >
> I was actually referring to your kzalloc, not to the original stack
> based implementation ...

Ok, got it. For the kzalloc version, the size matters much less, as
this is not coming from a scarce resource and only takes a few more
cycles to do the initial clearing of the larger struct.

> > > And it conflicts with another change I have waiting that gets rid of
> > > aes_expandkey and that struct alltogether (since it was really just
> > > abused to do a key size check, which was very wasteful since the
> > > function actually generates all roundkeys we don't need at all ...)
> >
> > Right, this is what I noticed there. With 480 of the 484 bytes gone,
> > you are well below the warning limit even without the other change.
> >
> And by "other change" you mean the safexcel_ahash_export_state?

Yes.

> Ok, good to known, although I do like to improve that one as well,
> but preferably by not exporting the cache so I don't need the full
> struct.

Sounds good to me.

      Arnd
