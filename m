Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6453CC04A68
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jul 2022 00:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiG1AkR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jul 2022 20:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiG1AkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jul 2022 20:40:15 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D302965F1
        for <linux-crypto@vger.kernel.org>; Wed, 27 Jul 2022 17:40:12 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id v17so255100wrr.10
        for <linux-crypto@vger.kernel.org>; Wed, 27 Jul 2022 17:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=00VtRx17FOWjYwT1CKqFIGQhFvsSjII65T55g6qnIDU=;
        b=pZo7XWKwNPxrkrJ8XmFbaKRmlx3MMapCU2D6icaVgZpApaoD8FcNSTQmwiKtm4Knp0
         dfAcNrOIsN8ZOs4HZzi1s3XElNXFO93bGucPRRBFehOqrBkgFW4Y9ASYzHec2+Q68WDg
         CmLdyRL1KLFz2ivtNCYhIxxc84JmZmx+jiCOuRs9PkLpH9wyBUYwuNfNfuaEIf8ph5n6
         dSIobf/Qakt74ute/4MIAYQFmw6OJ3wz3SVX1Aq61LbtHffB0zPpgO51O+Y/51yJWgfQ
         QuBWF7lnz7YtKKbxmGTwQc+aaloPfajKkT1R58y3HfDE0OwM2e7A0Gah47vDDAC0vn/S
         D0+A==
X-Gm-Message-State: AJIora8dcI03wqh+JmbXWDKhsNfhyBpZe/UjMqOdUbRqsmqyXDUzK6LD
        j6XR4SeeMjpKqlf+4CdgkHhUE9gqy92w67F43ivN2A==
X-Google-Smtp-Source: AGRyM1vEGf0Ey1h1sPA2iOZhHrCp8NNAAIPv5aN7Ua+QXM1B0fAxVCgC7WKHqj8QjOqT3yAObBpTksgeg0UzQ+hHSdg=
X-Received: by 2002:a5d:65cd:0:b0:21e:6e3b:b1a8 with SMTP id
 e13-20020a5d65cd000000b0021e6e3bb1a8mr14586353wrw.470.1658968811242; Wed, 27
 Jul 2022 17:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
 <20220725153303.GF7074@brightrain.aerifal.cx> <878rohp2ll.fsf@oldenburg.str.redhat.com>
 <20220725174430.GI7074@brightrain.aerifal.cx> <CAPBLoAe89Pwt=F_jcZirVXQA7JtugV+5+BWHBt0RaZka1y0K=g@mail.gmail.com>
 <20220725184929.GJ7074@brightrain.aerifal.cx> <YuCa1lDqoxdnZut/@mit.edu>
 <a5b6307d-6811-61b6-c13d-febaa6ad1e48@linaro.org> <YuEwR0bJhOvRtmFe@mit.edu>
 <87v8rid8ju.fsf@oldenburg.str.redhat.com> <YuGc3O88Zxb5HkxY@mit.edu>
In-Reply-To: <YuGc3O88Zxb5HkxY@mit.edu>
From:   =?UTF-8?Q?Cristian_Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Date:   Wed, 27 Jul 2022 20:39:59 -0400
Message-ID: <CAPBLoAcNNyiMf+FMtde_TsJL6gryq=yA32SXXPr=FcWMRQPO-Q@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Rich Felker <dalias@libc.org>, libc-alpha@sourceware.org,
        Michael@phoronix.com, linux-crypto@vger.kernel.org, jann@thejh.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 27, 2022 at 4:15 PM Theodore Ts'o via Libc-alpha
<libc-alpha@sourceware.org> wrote:
>
> On Wed, Jul 27, 2022 at 02:49:57PM +0200, Florian Weimer wrote:
> > * Theodore Ts'o:
> >
> > > But even if you didn't take the latest kernels, I think you will find
> > > that if you actually benchmark how many queries per second a real-life
> > > secure web server or VPN gateway, even the original 5.15.0 /dev/random
> > > driver was plenty fast enough for real world cryptographic use cases.
> >
> > The idea is to that arc4random() is suitable in pretty much all places
> > that have historically used random() (outside of deterministic
> > simulations).  Straight calls to getrandom are much, much slower than
> > random(), and it's not even the system call overhead.
>
> What are those places?

Well pretty much everywhere a shared library is involved from the start..
On one very basic vm here there are 18 shared libraries using srandom,
thus perturbing each other states if loaded by the same process,
possibly in a catastrophic/predictable way.
and nobody uses the random_r interfaces.


> And what are their performance and security
> requirements?

Common programmers know nothing about this, even seasoned ones don't..
if it runs slow or is not CSPRNG then the average app will
use one userspace PRNG or CSPRNG  or buffer from the kernel somewhere..
I do not have to justify this assertion..it is just a matter you
download libgcrypt, gnutls, openssl none of those libraries use the
kernel entropy
as the first option, all feed them to either proven or dubious s RNGs
schemes and then pass that to users.
Think on why that is and why we are discussing yet another interface
in the first place..
