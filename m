Return-Path: <SRS0=7d9E=VY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EFEC76190
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 05:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F8020840
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 05:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EdvLuNMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfG0FjX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Jul 2019 01:39:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40778 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfG0FjX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Jul 2019 01:39:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so49260795wmj.5
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 22:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUVETRd5jGXNj319q2hmPRDJzjSos23f23Rl11EPouA=;
        b=EdvLuNMV7jhFKSns1ldkH4GCbJ0g1ZLoSbu87dsGP/8WFobdd2gPZpvGvGopDuGCrO
         NAhClaioZe9t3QF+E68aQIqEGhYofXiezJCZRKv95d9qdljFZ1g4dj3kx5749R7ajExW
         9HIozlw1j7shQqGCp3+dD2eF5aJXqxJzvy6noDoSaVULiP4kD5S6KE4x36cyEiU9cnmt
         xHbBbit2+LdsFgPtS9HMZqE3vEKfCgEmI6ElZuatUpqkdO/s/S2d2AQtUiHs518+eIJe
         dqE9O/qZZ7RHu4fquRjH88kalLbQjm0sj8gKbN2lHAtW7q36SCUDoC2Myfp62Y7JDOnJ
         4T4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUVETRd5jGXNj319q2hmPRDJzjSos23f23Rl11EPouA=;
        b=BqfUusGPHfIh7h8sfZPoMPhjzTPDfa8mDezIkPjzvc85iTudXKcNI1Dqt66/EGVvSn
         +GLbZhtYIoj1MRV+lWH7MYFoafaAu+tiSXPbkFjAhfY/rsjjnSU2amyHsGW76JbQYlJj
         Wb91QICy+Xow4FoLalYsNtvQipchNz+Yfje7BGkIIzDiaFSYeZblRqmNrmP+yBrx+lac
         XhtH4rRJtSBFvn5iSe49qdptGxNBDnMd7eACqi4L+25kM60K/woAQLH/Zepe0VzosIYI
         jUuTO/gfxIMyLXUtcuxa4H879ZTJV1hPZDAmKFblK3ZSLHhyxKp5z6xhj0hHCGxGugwF
         DSJg==
X-Gm-Message-State: APjAAAUytGB4bX5+pIGf4nxganvuGwC0noxoiqm5DARJffXFYxZUymTP
        qNLk3fdiln8M6V/rLg+rZcHaEKYIR+bXJeaHeB4GVg==
X-Google-Smtp-Source: APXvYqzQcd1U5wjYDSIVkLNIWAzSCfPsOd836HkHWKRCZZe7ICMAEtbgEEDDcZhW+g42/wWElyBMKBZJOguOPJsC3FU=
X-Received: by 2002:a1c:720e:: with SMTP id n14mr7388848wmc.53.1564205960368;
 Fri, 26 Jul 2019 22:39:20 -0700 (PDT)
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
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 27 Jul 2019 08:39:12 +0300
Message-ID: <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 27 Jul 2019 at 00:43, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Horia Geanta <horia.geanta@nxp.com>
> > Sent: Friday, July 26, 2019 9:59 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Milan Broz <gmazyland@gmail.com>; Herbert Xu <herbert@gondor.apana.org.au>; dm-devel@redhat.com; linux-
> > crypto@vger.kernel.org
> > Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
> >
> > On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
> > > Ok, find below a patch file that adds your vectors from the specification
> > > plus my set of additional vectors covering all CTS alignments combined
> > > with the block sizes you desired. Please note though that these vectors
> > > are from our in-house home-grown model so no warranties.
> > I've checked the test vectors against caam (HW + driver).
> >
> > Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18")
> > are fine.
> >
> > caam complains when /* Additional vectors to increase CTS coverage */
> > section starts:
> > alg: skcipher: xts-aes-caam encryption test failed (wrong result) on test vector 9, cfg="in-place"
> >
> > (Unfortunately it seems that testmgr lost the capability of dumping
> > the incorrect output.)
> >
> > IMO we can't rely on test vectors if they are not taken
> > straight out of a spec, or cross-checked with other implementations.
> >
>
> First off, I fully agree with your statement, which is why I did not post this as a straight
> patch. The problem is that specification vectors usually (or actuaclly, always) don't cover
> all the relevant corner cases needed for verification. And "reference" implementations
> by academics are usually shady at best as well.
>
> In this particular case, the reference vectors only cover 5 out of 16 possible alignment
> cases and the current situation proves that this is not sufficient. As we have 2 imple-
> mentations (or actually more, if you count the models used for vector generation)
> that are considered to be correct that disagree on results.
>
> Which is very interesting, because which one is correct? I know that our model and
> hardware implementation were independently developed (by 2 different engineers)
> from the IEEE spec and match on results. And our hardware has been used "out in
> the field" for many years already in disk controllers from major silicon vendors.
> But that's still not a guarantee .... So how do we resolve this? Majority vote? ;-)
>

Thanks for the additional test vectors. They work fine with my SIMD
implementations for ARM [0], so this looks like it might be a CAAM
problem, not a problem with the test vectors.

I will try to find some time today to run them through OpenSSL to double check.


[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=xts-cts
