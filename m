Return-Path: <SRS0=yZoL=WA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CECC19759
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Aug 2019 08:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF3B206C1
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Aug 2019 08:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gZQuXkDa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfHDIgj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Aug 2019 04:36:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50840 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfHDIgj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Aug 2019 04:36:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so71984346wml.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Aug 2019 01:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S5z3diwrj3LTNJL99A/1OowPibFl4kOSfl1ebMrUQAM=;
        b=gZQuXkDa92Cg03NJBMuifLv2d00BelHmlNmbsuBjP/1HV2Jot7X3S36dFGBXMo32TO
         pkH1RiRWaspaELe4VXwWZS+b5aL0k3utLiRrvRDiuWI57ppEyxSbQnUYHNltOM8TsIW3
         MDJKTS2VfidcnNerS6p5N+KalylRTweD9Fdj9ZylNJivZOJnG/xy02sAdkyEL6l4DGli
         6MKls/brtzzYOHF76Qp9PvNcdKo0QKPBfDvkzCiOaF9bDdogY3QFeaG//ubRpmrcCDOf
         F2DeR1mTxT4KH7asc3pl8biSGI8PBvT+OzBqWdrVY4PUJAJvLQ67NsaYTh8ZxY6m2rVM
         7u3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S5z3diwrj3LTNJL99A/1OowPibFl4kOSfl1ebMrUQAM=;
        b=Jd/7MxCMgWxXnfmlkKCNPts9v5Tqt6Za9COS64eHfjL6Iky4oL4SXhsZDfxeuzE/+l
         FTUH3+fIhdBsbWtfMrfJeDV3Z5YRvABZCyjJvn2VTDZKmi7MfIqQy0bbB92gNm688RtF
         om2LYbQY67u6mlpjjicru5IOA6eN/HnOQFeu4WnAIIB85rokcH29oaYpL+catVpLJyJS
         /y87fhibK24k1znC1ePSO/YxV7rtkcbtyKt7TfuiR0u0uYQZphDq3SXbjpIcDN1vaT12
         5ZYz48VjIKH9odd0gKoFDr0O8d1NNbrCDKyiZSIStQKeD+N786X0+6wf2Q8u4DwE4hRV
         lBTw==
X-Gm-Message-State: APjAAAX9NHnebmb3G/oxfS960BnV2SndnYTAQhmRcD7JmYiEkEhC439Y
        AJGCDmmV1c8FEUswEvPCGQaK3vvu2AFSsEyd1B6oBQ==
X-Google-Smtp-Source: APXvYqzwfFFMUOMV4ujWhOonieSQIcv9qD5u01lkqbHt35xWftkOx8hC38QvI2mu4JjWc36l0PN9p6bAjlX2GLNcllI=
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr11976048wmj.61.1564907797099;
 Sun, 04 Aug 2019 01:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190716221639.GA44406@gmail.com> <20190720065807.GA711@sol.localdomain>
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
 <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com> <97532fae-4c17-bb8f-d245-04bf97cef4d1@gmail.com>
In-Reply-To: <97532fae-4c17-bb8f-d245-04bf97cef4d1@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 4 Aug 2019 11:36:25 +0300
Message-ID: <CAKv+Gu9JuXJspTO9tYbBgkdgmUznhgW+DWc029JWR2bqNsW_Bw@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 27 Jul 2019 at 19:04, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 27/07/2019 07:39, Ard Biesheuvel wrote:
> > Thanks for the additional test vectors. They work fine with my SIMD
> > implementations for ARM [0], so this looks like it might be a CAAM
> > problem, not a problem with the test vectors.
> >
> > I will try to find some time today to run them through OpenSSL to double check.
>
> I shamelessly copied your test vectors to my vector test for cryptsetup backend.
>
> Both OpenSSL and gcrypt XTS implementation passed all tests here!
>
> If interested - this is copy of backend we have in cryptsetup, vectors added in crypto-vectors.c
> (there are some hard defines in Makefile, cryptsetup uses autoconf instead).
>   OpenSSL: https://github.com/mbroz/cryptsetup_backend_test
>   gcrypt branch: https://github.com/mbroz/cryptsetup_backend_test/tree/gcrypt
>
> Once kernel AF_ALG supports it, I can easily test it the same way.
>

Thanks for confirming. So we can be reasonably confident that the test
vectors contributed by Pascal are sound.

I'll try to send out my ARM/arm64 changes shortly. However, I won't
have any access to hardware until end of next month, so they are
tested on QEMU only, which means I won't be able to provide any
performance numbers.
