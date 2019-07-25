Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E562BC7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 08:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9657521901
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 08:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sI5ZGVHQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388842AbfGYIBy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 04:01:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39418 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388596AbfGYIBy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 04:01:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id u25so33447931wmc.4
        for <linux-crypto@vger.kernel.org>; Thu, 25 Jul 2019 01:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPV+5nYuHvPip1in8zVbGa9yz5HxPYcILBTs+OS2gzU=;
        b=sI5ZGVHQRajJ75UblxSdXtL2Tg9vKFcnI1Bbbc+Pdg0DcHOerTl82uWjHrxBBBaJYo
         w41fLdG8OgOSXnCkAvmob6PhKwmAboLjZ8IiCguewmXdOwBT25vw92Z08WjNJTHpjOzC
         d2s1CyruhfZMZ5iY0spEeL2pblTpii1S+hexeQdI5tNtI7yf48l66X4Tw1Z+74nlV4QW
         1AKWmGHuWuLSxWBBXEe+Bh6GwIy/h33FimJ8by4V7QtTd0X7bOB6Zcd9k2/hX4Ry1t8U
         Cku12EOS2zTbJG9hTa8wVgiIgGv5c2+PFptNK2fNW61gqhzr/LjksvBjPtBMoM3WbXq6
         Fg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPV+5nYuHvPip1in8zVbGa9yz5HxPYcILBTs+OS2gzU=;
        b=A7k/lLjPLjsOiQJ7zn7AgMfuSHKMgxcw9MMFbC7rQ0rfNaAb3IPUz2Rxq2hG/9pCNO
         6xqe/jRh6ZOOSCLhNM7vpd52qq0yKX3W75KqwhIedCBiC/8/8jXcFqIS2kE1FkRK0xvr
         LGB1yRzKzG9z/59yaCtN9dFHWNcx7njgnw65BB3DfLPTOJgtGbmZqhacwLXd1Y1IKQoR
         7tCm2a/XcOwBhndr60D5879L74xjD99uS9ol8JayGky+It8LRZEiGWGv4CKs1sdP247X
         VPCwUILNK0ybhByeujVvutpJ9/AZ0RxCRShP81Dbebrx/mOTirmPaVq872YBFhoLKSPK
         jm9g==
X-Gm-Message-State: APjAAAUeV/6fa/qjl62DrwTb7/0ZVt5rc5o1oTAjPBHw6Jpa1j2FePS4
        9IArjuKq0YufSA7dm6okYpN7BOkPcxnT1IQZuzoTBA==
X-Google-Smtp-Source: APXvYqwMqa+2T5HCA0DRhMyVsHLssDvqMHodAKEXLQTRGl8hAGbjSUU0X9nw3G/LFfBx7/k4ksnQ0fXHiLMeTGZtwr8=
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr71796865wmj.61.1564041711747;
 Thu, 25 Jul 2019 01:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190716221639.GA44406@gmail.com> <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au> <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au> <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com> <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com> <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com> <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 25 Jul 2019 11:01:40 +0300
Message-ID: <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 25 Jul 2019 at 10:49, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Thursday, July 25, 2019 8:22 AM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.org.au>; dm-devel@redhat.com; linux-
> > crypto@vger.kernel.org; Horia Geanta <horia.geanta@nxp.com>
> > Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
> >
> > > >
> > > > Actually, that spec has a couple of test vectors. Unfortunately, they
> > > > are all rather short (except the last one in the 'no multiple of 16
> > > > bytes' paragraph, but unfortunately, that one is in fact a multiple of
> > > > 16 bytes)
> > > >
> > > > I added them here [0] along with an arm64 implementation for the AES
> > > > instruction based driver. Could you please double check that these
> > > > work against your driver?
> > > >
> > > I got XTS working with the inside-secure driver and these (and all other) vectors pass :-)
> > >
> >
> > Excellent, thanks for the report. May I add your Tested-by when I post
> > the patch? (just the one that adds the test vectors)
> >
> Sure, feel free
>

Thanks

> > > > That would establish a ground truth against
> > > > which we can implement the generic version as well.
> > > >
> > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=xts-cts
> > > >
> > > > > Besides that, I'd be happy to generate some testvectors from our defacto-standard
> > > > > implementation ;-)
> > > > >
> > > >
> > > > One or two larger ones would be useful, yes.
> > > >
> > > I'll see if I can extract some suitable vectors from our verification suite ...
> > >
> >
> > Great. Once available, I'll run them against my implementations and report back.
> >
> Just wondering ... do you have any particular requirements on the sizes?
> From my implementation's perspective, it doesn't make a whole lot of sense to test vectors
> of more than 3 times the cipher block size, but then I realized that you probably need
> larger vectors due to the loop unrolling you do for the vector implementations?
> You also don't want them to be too big as they take up space in the kernel image ...
>

We have code that operates on 1 block, 3 blocks (ARM), 4-5 blocks
(arm64) or 8 blocks (ARM,arm64) at a time. However, the most important
thing is to test the handover between the block based loop and the
epilogue that operates on the final 17-31 bytes when ciphertext
stealing is being done.

So ideally, we'd have 1 full block + 1 full/1 partial, 3 full blocks +
1 full/1 partial, and so on for 4, 5 and 8 blocks, to cover all the
code flows, but since the unrolled routines all support arbitrary
block counts (and so the handover between the multiblock and the
single block handling is already covered), just having the first two
would  be sufficient IMO.
