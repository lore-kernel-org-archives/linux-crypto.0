Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8CAC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3107215EA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OPGiWhO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfFLPjO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:39:14 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42526 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfFLPjO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 11:39:14 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so13301932ior.9
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 08:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifBC/l5g0ZnHif+jQfWdq5AQrHE8H4f17vz418sGVwk=;
        b=OPGiWhO9+kpAt0k/dxPeB/4/SdmtRbeSK3l6YPIJqG3BWwUEZMP9pWZ5+1nypKIbN1
         gX7BzHnSg3BmhxHtbqgpNoBNwNJ3+A/9xMNugXpRdZSrdq7yZbkMuxEE3ElwAshnkB2Z
         Ut4AmmhKwd5UOwPhoFHQYHjiRkrsuw4U/fWPJG9AugOCDkHHLbnvmZWPhLZczwjHNed8
         teFKzD2VyEZM+EimLxHQvTqCkAziyDUE1vC8d1qLofTpbqKKBm77K1iGdGb/KZp0CvjX
         ybasjuzeXRD91FnG0/AcExOKzAOcLq1d+XewTV9krqHEZJCibhWvHGl023ovf5uHjM3e
         /HIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifBC/l5g0ZnHif+jQfWdq5AQrHE8H4f17vz418sGVwk=;
        b=oJnykE3rA0EpohBTRhc4pjAjzDxrlWIVSwObc873AVMnj5TNUaSKcTxDE7CwluXHYD
         22E+L5UiP70UIgKxhASc1o7UDWCL+Tcws1AmXeruaRCaCberPj7KwsRswqCCl3vFIaxg
         ZorgJhfbZkIqtvdwwcdng7GocEAIykHnlCoByLTqtkdgh8CUntYYWlvyRidO6LrDvUD0
         +H9RQyqc/80c3nQ/fKBB+s/x6nSeV16p8OtAL7qUxHo1Et+TWk6MSRaNMv0NgANcNdf1
         +93MzbpIT0tSqio0zwZP+mPSVkUK9ZpfneIOTc2nEEJgBShE00e/fVsKgtZIFiYnZx5V
         s1SQ==
X-Gm-Message-State: APjAAAVuQfDP6YZNN0h+7ocIhh1YcRwMNzJ5m+4kF7pH4gP3nYlXHqn1
        DvsIID4xNIHVO2nWmc08mTcAE7RIRq+aQpIo+mtEvUrgxN8=
X-Google-Smtp-Source: APXvYqzTxGHfjKy5whohe4rHR9KN6SEtj2aisLUBDRKdaxkGT5ekdD+phDQWKls4tLhy8BIhWmcXTbVX8YFLkYocbRQ=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr7388135iob.49.1560353953653;
 Wed, 12 Jun 2019 08:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-6-ard.biesheuvel@linaro.org> <20190611173938.GA66728@gmail.com>
 <20190612153316.GA680@sol.localdomain>
In-Reply-To: <20190612153316.GA680@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 12 Jun 2019 17:39:01 +0200
Message-ID: <CAKv+Gu8V7PDtP8SHXoJcr761213ycZ6BHprT21MiFBMbRvRFTA@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] crypto: arc4 - remove cipher implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 Jun 2019 at 17:33, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jun 11, 2019 at 10:39:39AM -0700, Eric Biggers wrote:
> > > -
> > >  static struct skcipher_alg arc4_skcipher = {
> >
> > Similarly this could be renamed from arc4_skcipher to arc4_alg, now that the
> > skcipher algorithm doesn't need to be distinguished from the cipher algorithm.
> >
> > >     .base.cra_name          =       "ecb(arc4)",
> >
> > Given the confusion this name causes, can you leave a comment?  Like:
> >
> >         /*
> >          * For legacy reasons, this is named "ecb(arc4)", not "arc4".
> >          * Nevertheless it's actually a stream cipher, not a block cipher.
> >          */
> >        .base.cra_name          =       "ecb(arc4)",
> >
> >
> > Also, due to removing the cipher algorithm, we need the following testmgr change
> > so that the comparison self-tests consider the generic implementation of this
> > algorithm to be itself rather than "ecb(arc4-generic)":
> >
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 658a7eeebab28..5d3eb8577605f 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -4125,6 +4125,7 @@ static const struct alg_test_desc alg_test_descs[] = {
> >               }
> >       }, {
> >               .alg = "ecb(arc4)",
> > +             .generic_driver = "ecb(arc4)-generic",
> >               .test = alg_test_skcipher,
> >               .suite = {
> >                       .cipher = __VECS(arc4_tv_template)
> >
> > - Eric
>
> Hi Ard, did you see these comments?  They weren't addressed in v4.  We need at
> least the testmgr change, otherwise there's a warning when booting with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y:
>
> [    0.542610] alg: skcipher: skipping comparison tests for ecb(arc4)-generic because ecb(arc4-generic) is unavailable
>

Oops, no, I didn't

I'll fix it up and resend. I forgot to add a MODULE_LICENSE() to
libarc4.ko as well, so I needed to do this anyway.
