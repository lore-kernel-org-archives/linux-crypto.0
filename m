Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33F6C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D792084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yu51cycU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388704AbfIMQYH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 12:24:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33080 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388221AbfIMQYG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 12:24:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so2239438wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 09:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oMSsFWDeuI+JrpydDI+5Ui7hm8ODpxgYuXhV6cm12Bs=;
        b=yu51cycUwATFkwbo4DS/11GX9i9iQFs+aAxh7ke5D+UoOxUb5Xx/bH79AZWdH/t91a
         Yh/fnZbRqDqwoilQVDoT/a9IuKHOMn+4QkMgNKgbwuyWibSXvDWYyFM6aGXZ8DfsnUhT
         e0oUynYAIj0NXsnDlqtwFMrLFA7rMRxk5oMteH4qYxJAqlROdFRJwcffP07v7D1gT4mi
         O6BiWGJjG3/o9fHamvYdkgLtqRQPC2AoZBjVBpzz4My6ZgML7aamZqvu/xbIsCxr+gtw
         FMGl0ivE3pEmhrjNsZYwKyA49vbR/HdKix+vTmgyeDnPU3P+z0q1Uahh0SJWtujoH12A
         CnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oMSsFWDeuI+JrpydDI+5Ui7hm8ODpxgYuXhV6cm12Bs=;
        b=YjEiLsSNKNMjlJHfS18VWM5EwhcJg/HMP77C//Nl25d0Uk9CbVR7jw/t8O3JDbMQXe
         P1HMD7/wY3WRXiX7/4F1g8MF+EDtOBU1NJpo3yhB6WCyI6v2PvSUFrE68+6pj3lob8yb
         268LaktKVjENdRC3nX7j2fMWeN/dp4YGs8JsPyyDs9f4nBZI8BNdySbCnze9vRjlB8r1
         XHDS5ahnmp4DIiPxT7LC9tgedCpujoqEXvNgGYFEG3szoOYlUV/8d9RqMbhWCVGAm2vK
         lsoHLa2SBaeZPzX6Y8PM32ez6FMRkRCAmPvmrCcPO+uPWnSovTcksH7mBhDkkTzZwIw0
         0O6Q==
X-Gm-Message-State: APjAAAU7kLDot8oM/XlxRu6zODsfyDA3tv2k+IMa/L1OcnNEhjesKIXY
        YGlpLpZ5qJ+ovlvUYufv0XjRYSK9iMoXbUi6TrcDSQ==
X-Google-Smtp-Source: APXvYqzBSkcEBo3KrvVfj9Fvo3TlUqeqjaHaxF3rgJP8UAgrgs63rpVoHGnf2Chx2AkrGnA7olXCjk5kXqMPgcwDdTc=
X-Received: by 2002:a7b:cc86:: with SMTP id p6mr3824749wma.136.1568391844739;
 Fri, 13 Sep 2019 09:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568383406-8009-2-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu_qMDxNDYnMOmV1mA4+JwX3eAB3B-4aC=YJ07oZrz+wCg@mail.gmail.com> <MN2PR20MB2973F80500C43C22E05B2332CAB30@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973F80500C43C22E05B2332CAB30@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 13 Sep 2019 17:23:42 +0100
Message-ID: <CAKv+Gu9-r3bKae_YNkvhWEwwS-GRUhp9qJn6+Lsgug97iGqS+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Sep 2019 at 17:17, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Friday, September 13, 2019 5:27 PM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: open list:HARDWARE RANDOM NUMBER GENERATOR CORE <linux-crypto@vger.kernel.org>;
> > Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> > David S. Miller <davem@davemloft.net>; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Subject: Re: [PATCH 1/3] crypto: inside-secure - Added support for authenc HMAC-
> > SHA1/DES-CBC
> >
> > On Fri, 13 Sep 2019 at 16:06, Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
> > >
> > > This patch adds support for the authenc(hmac(sha1),cbc(des)) aead
> > >
> > > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> >
> > Please make sure your code is based on cryptodev/master before sending
> > it to the list.
> >
> Looks like with this patchset and the previous (SHA3) patchset I forgot
> to add the disclaimer that it applies on top of the previous patchset.
> Mea culpa.
>
> So there you go: "Added support for authenc HMAC-SHA1/DES-CBC" applies
> on top of "Added (HMAC) SHA3 support", which applies on top of
> "Add support for SM4 ciphers".
>

Sorry if I wasn't clear, but that was not my point.

You should really base your code on cryptodev/master since some of the
DES helpers you are using don't exist anymore.
