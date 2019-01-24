Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DAEC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEF9921855
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 14:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="RSD6g2Qd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbfAXOJw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:09:52 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:40128 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbfAXOJv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 09:09:51 -0500
Received: by mail-it1-f196.google.com with SMTP id h193so4515431ita.5
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 06:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uxj8XOwvdIoz9PkIKRxaosXpnX6yAk4tAYyXLmR8emI=;
        b=RSD6g2QdAoHfCvVpVxwPXlX9+gJ2M4Olo0F9KRxCphcRv5ErccuwJDB/Bf/vCEM6ng
         a9W/sZOKUEZF/QxjSLuooT6BV40PSmbA+5Vwh80qe6SrtMH7WQSmRJpAbYUSjse18ukn
         A4VXJhN+6PUN1+p1Bp0TVmslVd/uxIdW/+vGY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uxj8XOwvdIoz9PkIKRxaosXpnX6yAk4tAYyXLmR8emI=;
        b=Oh2dGmZavDZFQ6/Kl5uwN6kMcpY8e6ue65vpJQxjy3p1iU96VTd9aOWkTolnXJXG4e
         F4OFDD1yIgfw/pCpdS3foCNGRGGPChEZS/JmYEcQKTIBboACyzMpHpKRuYJvANQKXqTl
         7ChdFQn5ZGShPdihludHT3OIejimf+NoPMViBB2GbJlv6tLInZGiXSSaZ1/TsAFzL3ee
         i/tSGpMuMBoJvUnIm1aD5YtF3LfOIuEep8axM9uxZgYleIEGBBuVF4FLjxG4XLQWwFdW
         bRbSYpaIuVvDHDl3tRDI4eu4UMdzU5E5002sRX5/dWYTuWXi9hE1CrQaY4QzcrZT5Y3F
         a8Aw==
X-Gm-Message-State: AJcUukfmcDCoUQg0ypOAov8EW1uvvhN0L/vZE5oyu4Ve47VexhzBRxpv
        RP7DN4eE+EA5IKhQ1DddhI6jhlZiaQkt63Cn/vN/gw==
X-Google-Smtp-Source: ALg8bN7haPyTYh9vngq2B67q5eh0VVcObl5UIt6aSdqiCCbaXG9+BnS0aOO+qMKaT0vxDquJaJP7E1p5aWa7v594ydg=
X-Received: by 2002:a02:734b:: with SMTP id a11mr3693952jae.62.1548338990973;
 Thu, 24 Jan 2019 06:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20190123224926.250525-1-ebiggers@kernel.org> <20190123224926.250525-12-ebiggers@kernel.org>
 <CAKv+Gu-uELtKc_fNKFLPZ9KqrSMhX+cXuiP79JMR1zm0yo0r8w@mail.gmail.com> <20190124131414.GA13624@Red>
In-Reply-To: <20190124131414.GA13624@Red>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 24 Jan 2019 15:09:40 +0100
Message-ID: <CAKv+Gu_HNsjYkkDPUYY9bJ_u0MMf1mcYfTMydE6-TW7iR6QDNQ@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 11/15] crypto: testmgr - convert skcipher testing
 to use testvec_configs
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Jan 2019 at 14:14, Corentin Labbe <clabbe.montjoie@gmail.com> wrote:
>
> On Thu, Jan 24, 2019 at 01:36:23PM +0100, Ard Biesheuvel wrote:
> > On Wed, 23 Jan 2019 at 23:53, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Convert alg_test_skcipher() to use the new test framework, adding a list
> > > of testvec_configs to test by default.  When the extra self-tests are
> > > enabled, randomly generated testvec_configs are tested as well.
> > >
> > > This improves skcipher test coverage mainly because now all algorithms
> > > have a variety of data layouts tested, whereas before each algorithm was
> > > responsible for declaring its own chunked test cases which were often
> > > missing or provided poor test coverage.  The new code also tests both
> > > the MAY_SLEEP and !MAY_SLEEP cases, different IV alignments, and buffers
> > > that cross pages.
> > >
> > > This has already found a bug in the arm64 ctr-aes-neonbs algorithm.
> > > It would have easily found many past bugs.
> > >
> > > I removed the skcipher chunked test vectors that were the same as
> > > non-chunked ones, but left the ones that were unique.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >
> > This patch does not apply after applying 1..10 onto cryptodev/master
> >
> > Do you have a tree somewhere?
>
> Hello
>
> I got the same with next.
> You need to apply "crypto: clarify name of WEAK_KEY request flag" from his repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git branch testmgr-improvements
>

Thanks

I just pulled that branch entirely instead.
