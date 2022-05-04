Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692D2C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 20:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357185AbiEDUaD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 16:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiEDUaD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 16:30:03 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC9B4ECD0
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 13:26:26 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id l19so3122524ljb.7
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 13:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mmrVv14fPgXxwEi6qY3BXXY+CxBqDRKooA9FDuaSqV8=;
        b=DQgRC/EIfbWTO7QipnFt6qsWGushz/ykabQ4BikNPsBniuH7tmy2HqjGaM/O/TTfjR
         PeGmWoUZNVKcciqEeK9HLq+1xzjRzJpGjJ1eJXH5UuI8k7WRVZLn9WO5h3h+CUyKYLq9
         8CDVmr9R33re1VR4CQcJV26FFK5+hmaku/Sdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mmrVv14fPgXxwEi6qY3BXXY+CxBqDRKooA9FDuaSqV8=;
        b=f631aa7vfWrKapuf32SAsbWs3yJzduhE0diSX+Pno46u/vvk3lY8vh5mqwaHQ6VNxo
         fePNfUHjDli82w6F/0EQTNuuPsc1IID9iPqm+EBn910El4XL0l7u0Zoz0Fhj2iDWxN0+
         DSXwkJ5xV2S4d50DRtOTYgvVuiY9zsTWJNUe6RFh2IOF5DwEYw8oqAqkSLyoG7UhcGlN
         YwdZz+e+SJ6oAAdcjg3jVNXEmxwrTnmw9STyrLjk4V3XXL/PHajJEFhAiz48lfRozA0t
         LC5ENGYuDKszP0lsj3kNlFysTodpBGAXmo8+dP5BtMgCC/oCpdP0yVZ+y1bmfEqPEaLg
         3pSg==
X-Gm-Message-State: AOAM531/jeH6VDwRDJwiztYWPkk6bmiVH8niP9QIBojT+kFqdCe6tl1C
        JB+BiHKGC8K+IjamGuQlrA7B5ROqPe4TZuEB98Q=
X-Google-Smtp-Source: ABdhPJxg0MzPLUxOeXS5UG8XvAUEoAWj3eENw8IJhWBmRDRS67xNf74ZixtmlLBDwhZF/VLkhEwxUg==
X-Received: by 2002:a05:651c:1781:b0:247:daa7:4358 with SMTP id bn1-20020a05651c178100b00247daa74358mr13417264ljb.477.1651695983775;
        Wed, 04 May 2022 13:26:23 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id d15-20020ac2544f000000b0047255d21154sm1291540lfn.131.2022.05.04.13.26.22
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 13:26:22 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id t25so4268305lfg.7
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 13:26:22 -0700 (PDT)
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id
 h19-20020a0565123c9300b0044b04bac334mr15722106lfv.27.1651695982340; Wed, 04
 May 2022 13:26:22 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
 <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com> <YnLeH7kBImX5XLNn@antec>
In-Reply-To: <YnLeH7kBImX5XLNn@antec>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 13:26:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
Message-ID: <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
Subject: Re: [PATCH v2] hex2bin: make the function hex_to_bin constant-time
To:     Stafford Horne <shorne@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 4, 2022 at 1:12 PM Stafford Horne <shorne@gmail.com> wrote:
>
> Which version of Fedora?

F35 here.

But looking further, it's not dnsmasq either. Yes, dnsmasq is built
with no-i18n, but as mentioned IDN2 does seem to be enabled, so I
think it's just "no i18n messages".

It seems to be the upstream dns server.

Using 8.8.8.8 explicitly makes it work for me, and that obviously
bypasses not just the local dns cache, but also the next dns server
hop.

Could be anywhere. Xfinity, Nest WiFi, or the cable router. They all
are doing their own dns thing.

Probably my cable box, since it's likely the oldest thing in the chain.

                Linus
