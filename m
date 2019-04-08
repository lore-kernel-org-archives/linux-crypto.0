Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB561C10F13
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 21:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 896BA20880
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 21:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YTss2Hxn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfDHVSE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:18:04 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53744 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfDHVSE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 17:18:04 -0400
Received: by mail-it1-f193.google.com with SMTP id y204so1540228itf.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 Apr 2019 14:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GfosOtNCiAMT/aOmCktYjPCm22lNTrJ7t7YkyU6lJzw=;
        b=YTss2Hxn5K7h5RBSUbNijXsP1dQfPrBaQ8CFzXjZZPSQyr207ZsZ4cxnXVBzAdmQEM
         qI+Z24F0SbEZ90rfpBEUOpOzkV64owrERWyD6UkgX6TvIYHbIbBMfnkOC/fF4Lhm8XkP
         5NkSQKMKWOkunJRuRNejtfMbXWLIXbL5obVSZUfDWorF6UNTVCkA0FN+DX+P3Y19P7f1
         aBe2r46JYJqNefuYQ2FsRY39Awc/vuEmPv2pGo10W6KMX15rfVBOiIfWbAJLwuhnzgRl
         1QJAg5xkopmr0+1dhzMxyrAgnczdi2aItk47FTxcN/PLkdzHycClOqe2Z9G+TmytPq4i
         s+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfosOtNCiAMT/aOmCktYjPCm22lNTrJ7t7YkyU6lJzw=;
        b=HViCDCiMJMOYiU4ukzc8xYm8WHsw12CXwWBy9hc0b3NPrLuwvALF5NkW+KoGbI+Xq7
         YSESdl18hEDr6tSx7ObzVT8UJj44gDC8a+QUkNGPsmFBjSSg8QUYfaVe0qRF23x/OyH3
         iFuVp1jyBMLe2+QpUGPK24opWE+wAhd9sy3YvblJW2l9kYLdK+jnVwPhMcODzOM76HWX
         qEqjIxT5COr6kvO5yOwyvG7iULs3e2aSeFCnPToKid8NumwZtZuawyoLlv1q8Mqo29l1
         FqdL3tOMTRF8+Op0kAXnTXr4NHTp93+xZT4KvauWKrH87ZQOMi7REILCtEg42KeZMH30
         6rrA==
X-Gm-Message-State: APjAAAV4XtNkLj/YH4MEfPfLRxK6wvwpOBaNy76hJ1QeFK3gRk16r8SK
        Mw9Iqgfe/G1tKDojp9rmNnqtZ8+BX7WW+flHSi5rEw==
X-Google-Smtp-Source: APXvYqzmJtBYVNnX6N7fNRJEWLYDwbzcDYtXtH2ty2lOBJdjDALXs71Jmawf5IAtTJ1ThiSw0O9+wkroisAd5qY6PDk=
X-Received: by 2002:a02:9042:: with SMTP id y2mr23039949jaf.113.1554758283280;
 Mon, 08 Apr 2019 14:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190126210530.GB709@sol.localdomain> <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil> <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain> <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com> <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
 <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190408182757.GD9145@gmail.com>
In-Reply-To: <20190408182757.GD9145@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 8 Apr 2019 23:17:51 +0200
Message-ID: <CAKv+Gu8q6RTT134kZTjKkxDrWLezfio0AVWf8rnTji4wVdUpnw@mail.gmail.com>
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "ezequiel@collabora.com" <ezequiel@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 8 Apr 2019 at 20:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Apr 07, 2019 at 07:12:43PM +0000, Pascal Van Leeuwen wrote:
> >
> > Fact is, there are at least 2 hardware device drivers NOT doing this - and
> > I want to bet a nice sum of money there will be more - and that this has
> > not been noticed prior to adding these tests to testmgr, otherwise this
> > would have been fixed by now. Which seems to confirm that there is no
> > real use case for this functionality.
> >
>
> I really shouldn't have to say this, but just because something hasn't been
> reported doesn't mean it's not a real problem.  Someone could easily be affected
> by one of these bugs where crypto drivers produce the wrong output, and never
> notice it because their use case doesn't involve checking the output against
> another implementation.  Or, perhaps they noticed but never reported it
> upstream.  Or perhaps they didn't have the time or skill to debug the problem so
> just they disabled the broken driver, or used No Crypto instead.
>
> That's why we have tests -- so bugs can be detected immediately rather than
> maybe years out in the field after causing critical security vulnerabilities.
>

Perhaps we could wire this up using a CRYPTO_ALG flag? I.e.,
implementations that need the compliant behavior (such as cts) check
for the flag, and the asynchronous implementations produce two
versions, where the one that lacks the flag has a higher priority.
That way, we don't take the performance hit in cases where it is not
needed.
