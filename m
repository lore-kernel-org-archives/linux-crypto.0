Return-Path: <SRS0=L99/=UU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344FCC43613
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jun 2019 05:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F5120449
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jun 2019 05:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="svF7VF+q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFUFjd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 01:39:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44594 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFUFjd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 01:39:33 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so491710iob.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2019 22:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mELfp6zRiexEAAqmgN6eWetdKn6WzfvAuPTZHTzVDWY=;
        b=svF7VF+qCnzPwCwMCoZ+RtNCIB1W6c/EC80WLwt1DlIaQ9mlIgSqUyd8LrbJcvpAk7
         /kPVCZGWvfvbEeW4rOawCrCoDamBpdmjQ3qHOQ9vfopNyJY6YVu4m/R/PvxGSKt6s3DK
         hjKsD7ews8DXFV8COLiSZXxI609fkYzy+qTzZCpe7klu1yK6YzEuuMtz6f+2UYq73vSi
         NW1xE60yZmMXXy1e9Rnncyr0dQXgRMffhuOtaUufcrvaEysR64Cz3jiN6gp3lGeB6E6T
         gph/8QO05dZ/DIZqI7DCQworhTWlWwx+W4b7juW7Orui4vGIs2K45AHOfbXXHi16kNNS
         ymCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mELfp6zRiexEAAqmgN6eWetdKn6WzfvAuPTZHTzVDWY=;
        b=Ovs12PDGznq5PJQ0Xxz6GOOESZmFRMdRzitL7bwIsdJ/HS8eIF/Nva71lFGSZwaBEm
         /nnSovKm8QuiuASs3Iee6T8dXfqKo8PMi/nPrq+WCSVKjs3JLdbs+sVpVEoHkhRWISuO
         mLSaiwliI2ddiVGPYLBIlTH0bpxWuUzo4bEzsCe1iOM7D/1aZNtaU67ageA+ZCfZH441
         J9vMzOLwjs+ZLQahs2+v2eaKrhgUPBgIEMiBOi7Q8xGmUig8hq/EUoKmjCEJfSxT4w1S
         LuEGIzvgow5/B9LYLs7Yx6xZUPiAl2/yfXZUcHFXCNZV/eYh0gIvf3sX2lwlnMm1ry85
         ZixQ==
X-Gm-Message-State: APjAAAXiPwC4WNNz0ljaHcy8blvSP9HDnPSBwhnlSM9/v8kyADhBoHye
        VUaKi3m6sZuceAZkRAQZTOvIPjaVOhXJhwWsrjdkC4Z6QSM=
X-Google-Smtp-Source: APXvYqwqwaQdBl4xxaWd9W0wXDLMctP1dBqHsxmbtoY+rcrFS2Ha4qhnpo3ck9WLvMCF2o0xS8ZfyOMWRx02fDNfqZk=
X-Received: by 2002:a02:6597:: with SMTP id u145mr9933869jab.26.1561095572685;
 Thu, 20 Jun 2019 22:39:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au> <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au> <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
 <20190620134045.fncibzc7eyufd5sj@gondor.apana.org.au> <CAKv+Gu8OFbDJGoYw_DHresF5HJDSamtw1YtZ13gpOVJCYV+22Q@mail.gmail.com>
 <20190621010657.foscl7aaxlx7tfuy@gondor.apana.org.au>
In-Reply-To: <20190621010657.foscl7aaxlx7tfuy@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 21 Jun 2019 07:39:21 +0200
Message-ID: <CAKv+Gu9DuYvMA7yOTT3p75hvNHY_LOaDBE_oCdxB=SRFZ7U-kA@mail.gmail.com>
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

On Fri, 21 Jun 2019 at 03:07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 20, 2019 at 03:53:45PM +0200, Ard Biesheuvel wrote:
> >
> > We'd need at least 512 and 4k for dm-crypt, but I don't think the
> > sector size is limited at all tbh
>
> In that case my preference would be to encode this into the key
> and hardware that encounters unsupported sector sizes can use a
> fallback.
>

OTOH, it also depends on what makes sense to implement in practice.

Gilad, I suppose sector size 512 is an obvious win, since the OS
always fetches at least 8 consective ones at a time. Do you see a
benefit for other sector sizes as well?
