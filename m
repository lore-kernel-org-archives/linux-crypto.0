Return-Path: <SRS0=QZ1D=WG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC4AC32751
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Aug 2019 04:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E022089E
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Aug 2019 04:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VmyOY5Ra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbfHJEjy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Aug 2019 00:39:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53500 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfHJEjx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Aug 2019 00:39:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id 10so7502577wmp.3
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 21:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sr/zw12oaV0tFYuK6So8cdvlVZQffOlnt1O8uVTE8/A=;
        b=VmyOY5Ra89SwHutLuCooN7L4rHx7jBchuaQusIv7w7GvWVvV7wbGCM5xtqKARpgVNw
         fpV43QJBKXyjHV3GyUxz389KeSpTGALHK7X9I4BfxuUGirvNqt+025AovTONWPSQRSUa
         jRkbz3YGHRDHEwyaFAXtmfodWhrtQY53egXDJ4SKhxRNN8azovI2Tp2+JVEbLlXqPjrC
         woXv9pPh8hOuq9ObtUPJZ8bPIYVQ0t5jo7l/Tqwy3sRFH/WYbwr5GzPC9SGBAxv0JpIM
         FbtgwUba7+NHqeFt6/IpJyKxkzSe8vJ5EniifW8jf9aVDXjZfuIWfKrzI5JhMAXg3kRv
         1Qow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sr/zw12oaV0tFYuK6So8cdvlVZQffOlnt1O8uVTE8/A=;
        b=IPLfbCIVDoFn+4QDQIcnFUVUgBxN045+FdjyiMvXcAxURPG7EE0QW7vBAhVVEWzK9a
         b9pqhv98kYRVn3A5oohjkMyfpJftZoGTqpvE4LBmiWBkDQ+awokBfLlihbpfL/JhVebM
         FE3tq2JXv9FLsdg/3Ek09kkvYZld+wNrG2UUEQ42yJmYW4SRPJ/FLGcASEez0Du/9Qwv
         fzCk1ZuBdrcAoTO1UGyuC8w1CVmxQO9ltI7noh1VEkg/m2IwquHxGrczz3T9E1zolsJX
         cDJx9i+Vj1PMY26FFDO1q/o4/l5R4nJzG61u4uLWapGsrZgHwvEN98bdlro0qVFXGXhK
         3i5w==
X-Gm-Message-State: APjAAAXmkEyS9tbGREpaDP7n341Ga0HnVdjzAhpQ9nhpYghKgzUlWzp/
        OhNP28jS/MCb9fZtNJ+rdEqXHgaPlVz682jYKKFjOw==
X-Google-Smtp-Source: APXvYqw32jl/rEhhkWYtE8QXGrQYkQpqnBb27Hr1AdgKPkLqwjAlVpRZWLqEvO21GkblI2++t+WWziHZIpEet2juMiI=
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr13465304wmm.119.1565411990875;
 Fri, 09 Aug 2019 21:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com> <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au> <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
 <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com> <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 10 Aug 2019 07:39:38 +0300
Message-ID: <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Aug 2019 at 23:57, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Friday, August 9, 2019 7:49 PM
> > To: Horia Geanta <horia.geanta@nxp.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com>; Milan Broz <gmazyland@gmail.com>; dm-devel@redhat.com; linux-
> > crypto@vger.kernel.org
> > Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
> >
> > On Fri, 9 Aug 2019 at 10:44, Horia Geanta <horia.geanta@nxp.com> wrote:
> > >
> > > On 8/9/2019 9:45 AM, Ard Biesheuvel wrote:
> > > > On Fri, 9 Aug 2019 at 05:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > >>
> > > >> On Thu, Aug 08, 2019 at 06:01:49PM +0000, Horia Geanta wrote:
> > > >>>
> > > >>> -- >8 --
> > > >>>
> > > >>> Subject: [PATCH] crypto: testmgr - Add additional AES-XTS vectors for covering
> > > >>>  CTS (part II)
> > > >>
> > > >> Patchwork doesn't like it when you do this and it'll discard
> > > >> your patch.  To make it into patchwork you need to put the new
> > > >> Subject in the email headers.
> > > >>
> > > >
> > > > IMO, pretending that your XTS implementation is compliant by only
> > > I've never said that.
> > > Some parts are compliant, some are not.
> > >
> > > > providing test vectors with the last 8 bytes of IV cleared is not the
> > > > right fix for this issue. If you want to be compliant, you will need
> > > It's not a fix.
> > > It's adding test vectors which are not provided in the P1619 standard,
> > > where "data unit sequence number" is at most 5B.
> > >
> >
> > Indeed. But I would prefer not to limit ourselves to 5 bytes of sector
> > numbers in the test vectors. However, we should obviously not add test
> > vectors that are known to cause breakages on hardware that works fine
> > in practice.
> >
> Well, obviously, the full 16 byte sector number vectors fail on existing
> CAAM hardware, which I do assume to work fine in practice. And you know
> I'm not in favor of building all kinds of workarounds into the drivers.
>
> Fact is, we know there are no current users that need more than 64 bits
> of IV. Fact is also that having 64 bits of IV in the vectors is already
> an improvement over the 40 bits in the original vectors. And unlike CTS,
> I am not aware of any real use case for more than 64 bits.
> Finally, another fact is that limiting the *vectors* to 64 bits of IV
> does not prohibit anyone from *using* a full 128 bit IV on an
> implementation that *does* support this. I would think most users of
> XTS, like dmcrypt, would allow you to specify the cra_drivername
> explictly anyway, so just don't select legacy CAAM if you need that.
> (heck, if it would be reading and writing its own data, and not need
> compatibility with other implementations, it wouldn't even matter)
>
> So yes, the specs are quite clear on the sector number being a full
> 128 bits. But that doesn't prevent us from specifying that the
> crypto API implementation currently only supports 64 bits, with the
> remaining bits being forced to 0. We can always revisit that when
> an actual use case for more than 64 bits arises ...
>

You have got it completely backwards:

CTS has never worked in any kernel implementation, so regardless of
what the spec says, supporting it in the kernel is not a high priority
issue whichever way you put it. Now is the first time anyone has asked
for it in 12 years, and only because someone spotted a deviation
between a h/w and a s/w implementation, not because anyone tried to
use it and failed. (Note that passing anything other than a multiple
of the block size will cause an error rather than fail silently)

Truncated IVs are a huge issue, since we already expose the correct
API via AF_ALG (without any restrictions on how many of the IV bits
are populated), and apparently, if your AF_ALG request for xts(aes)
happens to be fulfilled by the CAAM driver and your implementation
uses more than 64 bits for the IV, the top bits get truncated silently
and your data might get eaten.

In my experience, users tend to care more about the latter than the former.


> > > > to provide a s/w fallback for these cases.
> > > >
> > > Yes, the plan is to:
> > >
> > > -add 16B IV support for caam versions supporting it - caam Era 9+,
> > > currently deployed in lx2160a and ls108a
> > >
> > > -remove current 8B IV support and add s/w fallback for affected caam versions
> > > I'd assume this could be done dynamically, i.e. depending on IV provided
> > > in the crypto request to use either the caam engine or s/w fallback.
> > >
> >
> > Yes. If the IV received from the caller has bytes 8..15 cleared, you
> > use the limited XTS h/w implementation, otherwise you fall back to
> > xts(ecb-aes-caam..).
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
>
